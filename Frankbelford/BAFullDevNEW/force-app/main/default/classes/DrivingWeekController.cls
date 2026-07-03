public with sharing class DrivingWeekController {
	public Reference_Period_Week__c wFilter {get;set;} /* Used for filter fields on the page */
	public List<Period> periods {get;set;}

	public DrivingWeekController() {
		//Instantiate filter object
		this.wFilter = new Reference_Period_Week__c();
		this.periods = new List<Period>();
	}

	private List<Reference_Period_Week__c> getAllRelevantWeeks(Integer weekLimit) {
		//Find all reference periods we'll be displaying
		Date earliestDate = system.today().addDays(weekLimit * (-7));
		List<Reference_Period__c> periods = [SELECT Id FROM Reference_Period__c WHERE End_Date__c > :earliestDate];

		//Return all period weeks for all displayed reference periods
		Date dtToday = system.today();
		return [SELECT Id, Average_Hours__c, Comments__c, Hours_Left__c, Manually_Saved__c, Other_Hours__c, Reference_Period__c,
					   Target_Average__c, Start_Date__c, End_Date__c, Duty_Hours__c, Unavailable_Hours__c, Is_Locked__c,
					   Total_Hours__c,
					   Reference_Period__r.Name, Reference_Period__r.Id, Reference_Period__r.Allowed_Hours__c,
					   Reference_Period__r.Start_Date__c, Reference_Period__r.End_Date__c,
					   (SELECT Break__c, Comments__c, Duty_Hours__c, Job_Role__r.Name, Period_of_Availability__c,
							   Timesheet__r.sirenum__Total_Hours__c, Timesheet__c
						FROM Reference_Period_Jobs__r
					    ORDER BY Job_Role__r.Name)
				FROM Reference_Period_Week__c
				WHERE Contact__c =: wFilter.Contact__c
				AND Start_Date__c <= :dtToday
				AND Reference_Period__c IN :periods
				ORDER BY Start_Date__c DESC];
	}

	private void breakToPeriods(List<Reference_Period_Week__c> weeks, Integer weekLimit, Set<Id> timesheetIds, List<Reference_Period_Job__c> jobsToQuery) {
		this.periods = new List<Period>();
		Period per = null;
		for (Reference_Period_Week__c w : weeks) {
			//Check whether we need to create a new period
			if (per == null || w.Reference_Period__c != per.id) {
				//No existing period, or changed to new period - create a new instance
				per = new Period(w.Reference_Period__r);
				periods.add(per);
			}

			//Add the week to the current period
			if (weekLimit-- <= 0) {
				//Count the week without displaying it
				per.count(w);
			} else {
				//Add the week to the list to be displayed
				per.add(w);
			}

			//For each job, check if we need to load timesheet data by default
			if (w.Manually_Saved__c == false && w.Is_Locked__c == false) {
				//Week not manually saved - load default values from timesheet
				for (Reference_Period_Job__c j : w.Reference_Period_Jobs__r) {
					if (j.Timesheet__c != null) {
						j.Duty_Hours__c = j.Timesheet__r.sirenum__Total_Hours__c;

						//Mark timesheet ID so we can query break hours
						timesheetIds.add(j.Timesheet__c);

						//Add the job to a list to quickly return to it after querying the break data
						jobsToQuery.add(j);
					}
				}
			}
		}
	}

	private void attachDefaultData(List<Reference_Period_Week__c> weeks, Set<Id> timesheetIds, List<Reference_Period_Job__c> jobsToQuery) {
		//Query break hours and apply to weeks that need it
		if (timesheetIds.size() > 0) {
			//Query break durations
			List<AggregateResult> breaks = [SELECT sirenum__Shift__r.sirenum__Timesheet_Summaries__c t, SUM(sirenum__Duration__c) d
											FROM sirenum__Shift_Break__c
											WHERE sirenum__Paid_Break__c = true
											AND sirenum__Shift__r.sirenum__Timesheet_Summaries__c IN :timesheetIds
											GROUP BY sirenum__Shift__r.sirenum__Timesheet_Summaries__c];

			//Map break duration per timesheet
			Map<Id, Decimal> mapTimesheetToBreak = new Map<Id, Decimal>();
			for (AggregateResult ar : breaks) {
				mapTimesheetToBreak.put((Id)ar.get('t'), (Decimal)ar.get('d'));
			}

			//Iterate over all jobs again, and plug in the break value
			for (Reference_Period_Job__c j : jobsToQuery) {
				Decimal br = mapTimesheetToBreak.get(j.Timesheet__c);
				j.Break__c = (br == null) ? 0 : br;
			}
		}
	}

	private void calculatePeriods() {
		for (Period p : this.periods) {
			p.calculate();
		}
	}

	public void loadDriver() {
		try {
			if (!SObjectType.Reference_Period__c.isAccessible() ||
				!SObjectType.Reference_Period_Week__c.isAccessible() ||
				!SObjectType.Reference_Period_Job__c.isAccessible()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.No_Permission));
				return;
			}

			//Verify a driver was selected to load
			if (wFilter.Contact__c == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Please_Select_Driver));
				return;
			}

			//Prepare lists of timesheet IDs and period IDs we'll need to query later
			Set<Id> timesheetIds = new Set<Id>();
			List<Reference_Period_Job__c> jobsToQuery = new List<Reference_Period_Job__c>();

			//Load custom settings
			Driving_Settings__c settings = Driving_Settings__c.getInstance();
			Integer weekLimit = Integer.valueOf(settings.Weeks_to_View__c);

			//Load all the weeks required to display relevant data
			List<Reference_Period_Week__c> weeks = getAllRelevantWeeks(weekLimit);

			//Split weeks into reference periods, and load break details if needed
			breakToPeriods(weeks, weekLimit, timesheetIds, jobsToQuery);

			//Query default data from shifts and timesheets
			attachDefaultData(weeks, timesheetIds, jobsToQuery);

			//Calculate period-level data
			calculatePeriods();
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getLineNumber()));
			if (Test.isRunningTest()) {
				throw e;
			}
		}
	}

	public void doSave() {
		try {
			if (!SObjectType.Reference_Period_Week__c.isUpdateable() ||
				!SObjectType.Reference_Period_Job__c.isUpdateable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.No_Permission));
				return;
			}

			//Make a list of all weeks and jobs to update
			List<Reference_Period_Week__c> weeks = new List<Reference_Period_Week__c>();
			List<Reference_Period_Job__c> jobs = new List<Reference_Period_Job__c>();

			//Iterate over the periods and fill the list with all weeks and jobs
			for (Period p : this.periods) {
				for (Reference_Period_Week__c w : p.weeks) {
					if (w.Is_Locked__c == false) {
						//Mark the week as manually saved
						w.Manually_Saved__c = true;

						//Add week to the update list
						weeks.add(w);

						//Add all jobs for that week to the update list
						jobs.addAll(w.Reference_Period_Jobs__r);
					}
				}
			}

			//Commit changes to the database
			Database.update(jobs);
			Database.update(weeks);

			//Reload page
			loadDriver();

			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved successfully.'));
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getLineNumber()));
			if (Test.isRunningTest()) {
				throw e;
			}
		}
	}

	public class Period {
		public Id id {get;set;}
		public String name {get;set;}
		public Decimal hoursLeft {get;set;}
		public Decimal allowedHours {get;set;}
		public Decimal rollingAverage {get;set;}
		public Decimal targetAverage {get;set;}
		public Decimal totalHours {get;set;}
		public Integer totalWeeks {get;set;}
		public Date latestWeek {get;set;}
		public Date endDate {get;set;}
		public List<Reference_Period_Week__c> weeks {get;set;}
		private List<Reference_Period_Week__c> allWeeks;

		public Period(Reference_Period__c period) {
			this.id = period.id;
			this.name = period.name;
			this.allowedHours = period.Allowed_Hours__c;
			this.weeks = new List<Reference_Period_Week__c>();
			this.allWeeks = new List<Reference_Period_Week__c>();
			this.latestWeek = period.Start_Date__c;
			this.endDate = period.End_Date__c;
			this.totalWeeks = 0;
			this.totalHours = 0;
		}

		public void add(Reference_Period_Week__c week) {
			count(week);
			this.weeks.add(week);
		}

		public void count(Reference_Period_Week__c week) {
			this.allWeeks.add(week);

			//Increase week counter
			this.totalWeeks++;

			//Count total hours
			this.totalHours += week.Total_Hours__c;

			//Catch maximum date
			if (week.End_Date__c > this.latestWeek) {
				this.latestWeek = week.End_Date__c;
			}
		}

		public void calculate() {
			//Calculate data after completion of loading
			this.hoursLeft = this.allowedHours - this.totalHours;

			if (this.hoursLeft == null) {
				this.hoursLeft = 0;
			}

			//Figure out how many weeks are left in the period
			Integer weeksLeft = Integer.valueOf(Math.abs(Math.ceil(this.endDate.daysBetween(this.latestWeek)) / 7.0));
			this.targetAverage = (this.hoursLeft / Math.max(1, weeksLeft)).setScale(2);

			//Calculate rolling average
			this.rollingAverage = (this.totalHours / Math.max(1, this.totalWeeks)).setScale(2);

			//Calculate weekly averages
			Decimal h = 0, w = 1.0;
			for (Integer i = this.allWeeks.size() - 1;i >= 0;i--) {
				//Set week number
				this.allWeeks[i].Week_Number__c = Integer.valueOf(w);

				//Calculate rolling average
				h += this.allWeeks[i].Total_Hours__c;
				this.allWeeks[i].Average_Hours__c = (h / (w++)).setScale(2);
			}
		}
	}
}