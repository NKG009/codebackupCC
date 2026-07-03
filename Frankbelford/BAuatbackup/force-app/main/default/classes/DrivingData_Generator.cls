public with sharing class DrivingData_Generator implements Queueable {
    private Set<Id> lines;
    private Map<Id, Decimal> mapUnavailable;
    private Map<Id, Decimal> mapBreaks;

    public DrivingData_Generator(Set<Id> lines) {
        this.lines = lines;
    }

    public void execute(QueueableContext context) {
        try {
            processTimesheetLineChanges();
        } catch (Exception e) {
            throw new StringException(e.getMessage() + ' - ' + e.getLineNumber());
        }
    }

    private List<Id> getAdditionalTimesheets(List<sirenum__Timesheet_Line__c> lineData, List<Id> existingIds) {
        List<Id> result = new List<Id>();

        //If no lines have been loaded, return an empty list
        if (lineData == null || lineData.isEmpty()) {
            return result;
        }

        //Load additional timesheets created at the same time, by the same user
        DateTime createdDate = lineData[0].sirenum__Timesheet__r.CreatedDate;
        Id createdBy = lineData[0].sirenum__Timesheet__r.CreatedById;
        List<sirenum__Timesheet__c> additionalTimesheets = [SELECT Id FROM sirenum__Timesheet__c
                                                            WHERE CreatedDate =: createdDate
                                                            AND CreatedById =: createdBy
                                                            AND Id NOT IN :existingIds];

        //Strip the timesheets to a list of IDs
        for (sirenum__Timesheet__c t : additionalTimesheets) {
            result.add(t.id);
        }

        return result;
    }

    public void processTimesheetLineChanges() {
        //First, make a list of all changed timesheets (many lines can belong to the same TS)
        List<sirenum__Timesheet_Line__c> lineData = [SELECT sirenum__Timesheet__c, sirenum__Timesheet__r.CreatedDate, sirenum__Timesheet__r.CreatedById FROM sirenum__Timesheet_Line__c WHERE Id IN :lines];
        List<Id> timesheetIds = getTimesheetIds(lineData);

        /* The following is a workaround until Sirenum can implement platform events for payroll. Remove this afterwards. */
        //Add all other timesheets created at the same time by the same user
        timesheetIds.addAll(getAdditionalTimesheets(lineData, timesheetIds));

        /* End of hac--- I mean workaround. */

        processTimesheetChanges(timesheetIds);
    }

    public void processTimesheetChanges(List<Id> timesheetIds) {
        //Query timesheet data, and filter out ones that aren't for driving
        List<sirenum__Timesheet__c> timesheets = [SELECT Id, sirenum__Week_Ending__c, sirenum__Worker__c, sirenum__Team__c,
                sirenum__Total_Hours__c, sirenum__Worker__r.Id, sirenum__Worker__r.IP_WorkerStartDate__c
        FROM sirenum__Timesheet__c
        WHERE id IN :timesheetIds
        AND sirenum__Team__r.sirenum__Job_Type__r.Driving_Applicable__c = true
        ORDER BY sirenum__Week_Ending__c];

        //Load all break times for timesheets
        this.mapBreaks = loadBreaks(timesheets);

        //Convert timesheets into reference weeks and jobs
        processTimesheets(timesheets);
    }

    private void processTimesheets(List<sirenum__Timesheet__c> timesheets) {
        //For every timesheet
        Date weekStart, minDate = null, maxDate = null;
        Set<Id> driverIds = new Set<Id>();
        Set<Id> jobRoleIds = new Set<Id>();
        List<Date> weekDates = new List<Date>();
        sirenum__Timesheet__c t;

        Integer tsSize = timesheets.size();
        for (Integer i = 0; i < tsSize; i++) {
            t = timesheets[i];

            //Get the week start date for the timesheet
            weekStart = getWeekStart(t.sirenum__Week_Ending__c, true);

            //Keep track of min/max weeks
            if (minDate == null || weekStart < minDate) {
                minDate = weekStart;
            }

            if (maxDate == null || weekStart > maxDate) {
                maxDate = weekStart;
            }

            //Keep a list of weeks, contacts, and job roles
            weekDates.add(weekStart);
            driverIds.add(t.sirenum__Worker__c);
            jobRoleIds.add(t.sirenum__Team__c);
        }

        //Query reference periods we'll need for this operation
        List<Reference_Period__c> periods = [
                SELECT Id, Start_Date__c, End_Date__c
                FROM Reference_Period__c
                WHERE Start_Date__c <= :maxDate
                AND End_Date__c >= :minDate
                ORDER BY Start_Date__c
                LIMIT 1000
        ];

        //Load reference weeks and jobs for the drivers/weeks as a map
        WeekContainer weeks = new WeekContainer(driverIds, weekDates, jobRoleIds, periods);

        Map<Object[], Decimal> mapUnavailability = loadUnavailability(driverIds, weekDates, minDate, maxDate);

        updateWeeksAndJobs(timesheets, periods, weeks, mapUnavailability, weekDates);
    }

    private static Set<String> getRelevantRequestTypes() {
        List<sirenum__Request_Type__c> types = [SELECT Name FROM sirenum__Request_Type__c WHERE Driving_Applicable__c = true LIMIT 100];

        //Convert them into a set of strings
        Set<String> lstTypes = new Set<String>();
        for (sirenum__Request_Type__c rt : types) {
            lstTypes.add(rt.Name);
        }

        return lstTypes;
    }

    private Map<Object[], Decimal> loadUnavailability(Set<Id> contactIds, List<Date> weekDates, Date minDate, Date maxDate) {
        Map<Object[], Decimal> mapResult = new Map<Object[], Decimal>();
        Object[] key;
        Date dt;

        //Load unavailability types to count
        Set<String> lstTypes = getRelevantRequestTypes();

        //Find all requests by the drivers
        Date qMaxDate = maxDate.addDays(6);
        List<sirenum__Employee_Request__c> requests = [SELECT Id, Duration__c, sirenum__Date__c, sirenum__Contact__c
                                                        FROM sirenum__Employee_Request__c
                                                        WHERE sirenum__Availability__c = false
                                                        AND Duration__c > 0
                                                        AND sirenum__Contact__c IN :contactIds
                                                        AND sirenum__Date__c >= :minDate
                                                        AND sirenum__Date__c <= :qMaxDate
                                                        AND sirenum__Type__c IN :lstTypes
                                                        LIMIT 10000];

        //Summarize results into a map
        for (sirenum__Employee_Request__c r : requests) {
            dt = getWeekStart(r.sirenum__Date__c);
            key = new Object[] {r.sirenum__Contact__c, dt};

            Decimal val = mapResult.get(key);
            if (val == null) {
                val = r.Duration__c;
            } else {
                val += r.Duration__c;
            }

            mapResult.put(key, val);
        }

        return mapResult;
    }

    private void updateWeeksAndJobs(List<sirenum__Timesheet__c> timesheets, List<Reference_Period__c> periods,
            WeekContainer weeks,
            Map<Object[], Decimal> mapUnavailability, List<Date> weekDates) {
        //For each timesheet, check to see if a reference period week and/or job exist
        List<Reference_Period_Week__c> weeksToUpdate = new List<Reference_Period_Week__c>();
        List<Reference_Period_Job__c> jobsToUpdate = new List<Reference_Period_Job__c>();
        WeekInstance week;
        Reference_Period_Job__c job;
        Object[] key;
        sirenum__Timesheet__c t;
        Integer tsSize = timesheets.size();
        Date weekStart;
        Decimal unavailability;

        //Begin processing timesheets into weeks and jobs
        for (Integer i=0;i<tsSize;i++) {
            t = timesheets[i];
            weekStart = weekDates[i];

            //Retrieve the existing week for the driver and week start date
            key = new Object[] {t.sirenum__Worker__c, weekStart};
            week = weeks.get(key);
            job = null;

            if (week == null) {
                //Week not found

                //Create a new week record
                week = new WeekInstance(createWeek(periods, t.sirenum__Worker__r, weekStart));

                //Check for unavailability for this week
                unavailability = mapUnavailability.get(key);
                week.week.Unavailable_Hours__c = (unavailability == null) ? 0 : unavailability;

                //Create any missing weeks between this week, and the driver's previous week
                List<Reference_Period_Week__c> missingWeeks = createMissingWeeks(week.week, weeks);
                weeksToUpdate.addAll(missingWeeks);

                //Add the week to the list to commit to the DB
                weeksToUpdate.add(week.week);

                //Add the week to the map
                weeks.put(key, week);

                //Add any missing weeks we created to the map as well
                for (Reference_Period_Week__c w : missingWeeks) {
                    weeks.put(new Object[] {t.sirenum__Worker__c, w.Start_Date__c}, new WeekInstance(w));
                }

                //Since it's a new week, don't bother searching for a job
            } else {
                //Week found

                //Find existing job record
                job = week.getJob(t.sirenum__Team__c);
            }

            //If the job was not found, create one
            if (job == null) {
                job = createJob(week.week, t, mapBreaks);
                week.jobs.add(job);
                jobsToUpdate.add(job);
            }
        }

        //Commit weeks to the DB
        Database.upsert(weeksToUpdate, false);

        //Link all jobs to their respective weeks after they were inserted into the DB
        for (WeekInstance wi : weeks.getAllWeeks()) {
            for (Reference_Period_Job__c j : wi.jobs) {
                j.Reference_Period_Week__c = wi.week.id;
            }
        }

        //Commit jobs to the DB
        Database.upsert(jobsToUpdate, false);
    }

    private List<Reference_Period_Week__c> createMissingWeeks(Reference_Period_Week__c week, WeekContainer weeks) {
        List<Reference_Period_Week__c> lstWeeks = new List<Reference_Period_Week__c>();

        //Find the last week the driver has in this period
        Date d = weeks.getMaxDate(week.Contact__c, week.Reference_Period__c);
        if (d == null) {
            //If no week exists, start at the beginning of the reference period
            d = week.Reference_Period__r.Start_Date__c;
            if (week.Contact__r.IP_WorkerStartDate__c > d) {
                d = getWeekStart(week.Contact__r.IP_WorkerStartDate__c);
            }
        } else {
            //If an existing week was found, begin creating from the next calendar week
            d = d.addDays(7);
        }

        //Create an empty week every 7 days from that date
        while (d < week.Start_Date__c) {
            lstWeeks.add(new Reference_Period_Week__c(Start_Date__c = d, Contact__c = week.Contact__c, Reference_Period__c = week.Reference_Period__c));
            d = d.addDays(7);
        }

        weeks.setMaxDate(week.Contact__c, week.Reference_Period__c, week.Start_Date__c);

        return lstWeeks;
    }

    private Map<Id, Decimal> loadBreaks(List<sirenum__Timesheet__c> timesheets) {
        List<AggregateResult> breaks = [SELECT sirenum__Shift__r.sirenum__Timesheet_Summaries__c t, SUM(sirenum__Duration__c) d
        FROM sirenum__Shift_Break__c
        WHERE sirenum__Paid_Break__c = true
        AND sirenum__Shift__r.sirenum__Timesheet_Summaries__c IN :timesheets
        GROUP BY sirenum__Shift__r.sirenum__Timesheet_Summaries__c];

        //Map break duration per timesheet
        Map<Id, Decimal> mapTimesheetToBreak = new Map<Id, Decimal>();
        for (AggregateResult ar : breaks) {
            mapTimesheetToBreak.put((Id)ar.get('t'), (Decimal)ar.get('d'));
        }

        return mapTimesheetToBreak;
    }

    private Reference_Period_Job__c createJob(Reference_Period_Week__c week, sirenum__Timesheet__c timesheet,
            Map<Id, Decimal> mapBreaks) {
        //Create the job record
        Reference_Period_Job__c job = new Reference_Period_Job__c(Break__c = 0, Duty_Hours__c = 0,
                Period_of_Availability__c = 0,
                Job_Role__c = timesheet.sirenum__Team__c,
                Timesheet__c = timesheet.id);

        //If the week has not been manually saved already, copy the hours from the timesheet onto the job
        if (week.Manually_Saved__c == false) {
            job.Duty_Hours__c = timesheet.sirenum__Total_Hours__c;

            Decimal b = mapBreaks.get(timesheet.id);
            job.Break__c = (b == null) ? 0 : b;
        }

        //Because the week could be new, and have no ID, we need to map it to the week and set the ID later
        if (week.id != null) {
            job.Reference_Period_Week__c = week.id;
        }

        return job;
    }

    private Reference_Period_Week__c createWeek(List<Reference_Period__c> periods, Contact contact, Date weekStart) {
        //Find the correct reference period
        Reference_Period__c selectedPeriod = null;
        for (Reference_Period__c p : periods) {
            if (p.Start_Date__c <= weekStart && p.End_Date__c >= weekStart) {
                selectedPeriod = p;
                break;
            }
        }

        //If no period found, throw an exception
        if (selectedPeriod == null) {
            throw new StringException('Reference period not found for week ' + weekStart.format());
        }

        //Create a new period
        return new Reference_Period_Week__c(Reference_Period__c = selectedPeriod.id, Reference_Period__r = selectedPeriod,
                Contact__c = contact.Id, Contact__r = contact,
                Start_Date__c = weekStart, Manually_Saved__c = false);
    }

    private List<Id> getTimesheetIds(List<sirenum__Timesheet_Line__c> lines) {
        List<Id> idList = new List<Id>();
        Id lastId = null;

        //Go over each TS line, and put all TS IDs in the list
        for (sirenum__Timesheet_Line__c l : lines) {
            if (lastId != l.sirenum__Timesheet__c) {
                lastId = l.sirenum__Timesheet__c;
                idList.add(lastId);
            }
        }

        return idList;
    }

    /* Returns the week-starting Saturday */
    private static Time TIME_MIDDAY = Time.newInstance(12,0,0,0);
    public static Date getWeekStart(Date weekDay) {
        return getWeekStart(weekDay, false);
    }

    public static Date getWeekStart(Date weekDay, Boolean isWeekEndingDate) {
        DateTime dt = DateTime.newInstance(weekDay, TIME_MIDDAY);
        Integer dayNum = Integer.valueOf(dt.format('u'));
        Integer delta;
        if (dayNum < 6) { //Mon - Fri
            delta = (-1) - dayNum;
        } else {
            delta = 6 - dayNum;
            if (isWeekEndingDate) {
                delta -= 7;
            }
        }
        return weekDay.addDays(delta);
    }

    /* Updates existing weeks when a request is updated on the database */
    public static void handleRequest(List<sirenum__Employee_Request__c> requests) {
        //Load request types that affect driving unavailability
        Set<String> lstTypes = getRelevantRequestTypes();

        //Make a list of drivers and weeks that need to be recounted
        Set<Id> driverIds = new Set<Id>();
        Set<Date> weekDates = new Set<Date>();
        for (sirenum__Employee_Request__c er : requests) {
            Date d = getWeekStart(er.sirenum__Date__c);
            weekDates.add(d);
            driverIds.add(er.sirenum__Contact__c);
        }

        //Query for existing weeks
        List<Reference_Period_Week__c> weeks = [SELECT Id, Contact__c, Start_Date__c, End_Date__c, Unavailable_Hours__c
        FROM Reference_Period_Week__c
        WHERE Contact__c IN :driverIds
        AND Start_Date__c IN :weekDates
        AND Manually_Saved__c = false
        AND Is_Locked__c = false];

        driverIds.clear();
        Date minDate = null, maxDate = null;
        Object[] key;
        Map<Object[], Reference_Period_Week__c> mapWeeks = new Map<Object[], Reference_Period_Week__c>();
        for (Reference_Period_Week__c w : weeks) {
            //Make a list of all drivers we need to recount, the min, and max dates to query for
            driverIds.add(w.Contact__c);
            if (minDate == null || minDate > w.Start_Date__c) {
                minDate = w.Start_Date__c;
            }

            if (maxDate == null || maxDate < w.End_Date__c) {
                maxDate = w.End_Date__c;
            }

            //Reset the unavailability hours
            w.Unavailable_Hours__c = 0;

            //Map the week for easy access
            key = new Object[] {w.Contact__c, w.Start_Date__c};
            mapWeeks.put(key, w);
        }

        //Query for all relevant requests for those periods
        List<sirenum__Employee_request__c> reqs = [SELECT Id, sirenum__Contact__c, Duration__c, sirenum__Date__c
        FROM sirenum__Employee_Request__c
        WHERE sirenum__Date__c >= :minDate
        AND sirenum__Date__c <= :maxDate
        AND sirenum__Type__c IN :lstTypes
        LIMIT 20000];

        //Summarize the total duration per week
        Reference_Period_Week__c week;
        for (sirenum__Employee_Request__c r : reqs) {
            key = new Object[] {r.sirenum__Contact__c, getWeekStart(r.sirenum__Date__c)};
            week = mapWeeks.get(key);

            //Add duration to the unavailability hours of that week
            if (week != null) {
                week.Unavailable_Hours__c += r.Duration__c;
            }
        }

        //Update the database
        Database.update(weeks, false);
    }

    /* Erases reference jobs if their timesheets are deleted */
    public static void handleTimesheetDeletion(List<sirenum__Timesheet__c> timesheets) {
        List<Reference_Period_Job__c> jobs = [SELECT Id FROM Reference_Period_Job__c WHERE Timesheet__c IN :timesheets];
        if (jobs.size() > 0) {
            delete jobs;
        }
    }

    /* Updates existing weeks when a shift break is updated on the database */
    public static void handleBreaks(List<sirenum__Shift_Break__c> breaks) {
        //Load required shift break data
        breaks = [SELECT Id, sirenum__Shift__r.sirenum__Contact__c, sirenum__Shift__r.sirenum__Date__c, sirenum__Shift__r.sirenum__Team__c
        FROM sirenum__Shift_Break__c
        WHERE Id IN :breaks
        AND sirenum__Paid_Break__c = true
        AND sirenum__Shift__r.sirenum__Cancelled__c = false
        AND sirenum__Shift__r.sirenum__Timesheet_summaries__c != null];

        //Make a list of drivers, job roles, and weeks that need to be recounted
        Set<Id> driverIds = new Set<Id>();
        Set<Id> jobRoleIds = new Set<Id>();
        Set<Date> weekDates = new Set<Date>();
        for (sirenum__Shift_Break__c br : breaks) {
            Date d = getWeekStart(br.sirenum__Shift__r.sirenum__Date__c.date());
            weekDates.add(d);
            driverIds.add(br.sirenum__Shift__r.sirenum__Contact__c);
            jobRoleIds.add(br.sirenum__Shift__r.sirenum__Team__c);
        }

        //Query for existing jobs
        List<Reference_Period_Job__c> jobs = [SELECT Id, Reference_Period_Week__r.Contact__c,
                Reference_Period_Week__r.Start_Date__c,
                Reference_Period_Week__r.End_Date__c, Break__c
        FROM Reference_Period_Job__c
        WHERE Reference_Period_Week__r.Contact__c IN :driverIds
        AND Reference_Period_Week__r.Start_Date__c IN :weekDates
        AND Job_Role__c IN :jobRoleIds
        AND Reference_Period_Week__r.Manually_Saved__c = false
        AND Reference_Period_Week__r.Is_Locked__c = false];

        driverIds.clear();
        Date minDate = null, maxDate = null;
        Object[] key;
        Map<Object[], Reference_Period_Job__c> mapJobs = new Map<Object[], Reference_Period_Job__c>();
        for (Reference_Period_Job__c j : jobs) {
            //Make a list of all drivers we need to recount, the min, and max dates to query for
            driverIds.add(j.Reference_Period_Week__r.Contact__c);
            if (minDate == null || minDate > j.Reference_Period_Week__r.Start_Date__c) {
                minDate = j.Reference_Period_Week__r.Start_Date__c;
            }

            if (maxDate == null || maxDate < j.Reference_Period_Week__r.End_Date__c) {
                maxDate = j.Reference_Period_Week__r.End_Date__c;
            }

            //Reset the break hours
            j.Break__c = 0;

            //Map the week for easy access
            key = new Object[] {j.Reference_Period_Week__r.Contact__c, j.Reference_Period_Week__r.Start_Date__c, j.Job_Role__c};
            mapJobs.put(key, j);
        }

        //Query for all relevant requests for those periods
        List<AggregateResult> breakSum =
        [SELECT sirenum__Shift__r.sirenum__Contact__c c, sirenum__Shift__r.sirenum__Timesheet_summaries__r.sirenum__Week_Ending__c d, sirenum__Shift__r.sirenum__Team__c j, SUM(sirenum__Duration__c) du
        FROM sirenum__Shift_Break__c
        WHERE sirenum__Shift__r.sirenum__Date__c >= :minDate
        AND sirenum__Shift__r.sirenum__Date__c <= :maxDate
        AND sirenum__Paid_Break__c = true
        AND sirenum__Shift__r.sirenum__Cancelled__c = false
        AND sirenum__Shift__r.sirenum__Timesheet_summaries__c != null
        GROUP BY sirenum__Shift__r.sirenum__Contact__c, sirenum__Shift__r.sirenum__Timesheet_summaries__r.sirenum__Week_Ending__c, sirenum__Shift__r.sirenum__Team__c
        LIMIT 20000];

        //Summarize the total duration per week
        Reference_Period_Job__c job;
        for (AggregateResult ar : breakSum) {
            key = new Object[] {(Id)ar.get('c'), getWeekStart((Date)ar.get('d')), (Id)ar.get('j')};
            job = mapJobs.get(key);

            //Add duration to the unavailability hours of that week
            if (job != null) {
                job.Break__c += (Decimal)ar.get('du');
            }
        }

        //Update the database
        Database.update(jobs, false);
    }

    public class WeekContainer {
        private Map<Id[], Date> mapMaxDate;
        private Map<Object[], WeekInstance> mapWeekByContactAndDate;
        private Set<Id> oldDrivers;

        public WeekContainer(Set<Id> driverIds, List<Date> weekDates, Set<Id> jobRoleIds, List<Reference_Period__c> periods) {
            //Instantiate the maps
            this.mapMaxDate = new Map<Id[], Date>();
            this.mapWeekByContactAndDate = new Map<Object[], WeekInstance>();
            this.oldDrivers = new Set<Id>();

            //Query reference weeks and jobs for the drivers/weeks
            List<Reference_Period_Week__c> weeks = [SELECT Id, Contact__c, Start_Date__c, Manually_Saved__c, Reference_Period__c,
            (SELECT Id, Job_Role__c
            FROM Reference_Period_Jobs__r
            WHERE Job_Role__c IN :jobRoleIds)
            FROM Reference_Period_Week__c
            WHERE Contact__c IN :driverIds
            AND Reference_Period__c IN :periods
            //AND Start_Date__c IN :weekDates
            ORDER BY Contact__c, Start_Date__c
            LIMIT 20000];

            //Map weeks by driver and week
            Object[] key;
            Id[] idKey;
            Set<Id> periodIds = new Set<Id>();
            WeekInstance wi;
            for (Reference_Period_Week__c w : weeks) {
                //Map period week by contact and start date
                key = new Object[] {w.Contact__c, w.Start_Date__c};
                wi = new WeekInstance(w);

                this.mapWeekByContactAndDate.put(key, wi);
            }

            //Load maximum weeks for drivers by period
            List<AggregateResult> maxWeeks = [SELECT Contact__c c, Reference_Period__c p, MAX(Start_Date__c) d
            FROM Reference_Period_Week__c
            WHERE Contact__c IN :driverIds
            AND Reference_Period__c IN :periods
            GROUP BY Contact__c, Reference_Period__c];

            for (AggregateResult ar : maxWeeks) {
                //Also keep a mapping of the maximum week date per contact
                idKey = new Id[] {(Id)ar.get('c'), (Id)ar.get('p')};
                this.mapMaxDate.put(idKey, (Date)ar.get('d'));
            }
        }

        public WeekInstance get(Object[] key) {
            return this.mapWeekByContactAndDate.get(key);
        }

        public void put(Object[] key, WeekInstance val) {
            this.mapWeekByContactAndDate.put(key, val);
        }

        public Date getMaxDate(Id contactId, Id periodId) {
            return this.mapMaxDate.get(new Id[] {contactId, periodId});
        }

        public void setMaxDate(Id contactId, Id periodId, Date newDate) {
            this.mapMaxDate.put(new Id[] {contactId, periodId}, newDate);
        }

        public List<WeekInstance> getAllWeeks() {
            return this.mapWeekByContactAndDate.values();
        }
    }

    public class WeekInstance {
        public Reference_Period_Week__c week;
        public List<Reference_Period_Job__c> jobs;

        public WeekInstance(Reference_Period_Week__c week) {
            //Attach the week record
            this.week = week;

            //Add all jobs from the week record
            this.jobs = new List<Reference_Period_Job__c>();

            if (week.Reference_Period_Jobs__r != null) {
                this.jobs.addAll(week.Reference_Period_Jobs__r);
            }
        }

        public Reference_Period_Job__c getJob(Id jobRoleId) {
            for (Reference_Period_Job__c j : this.jobs) {
                if (j.Job_Role__c == jobRoleId) {
                    return j;
                }
            }

            return null;
        }
    }
}