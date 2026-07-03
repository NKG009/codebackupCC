global class UpdateValuePerHourBatch implements Database.Batchable<SObject> {
    global final String Query;
    global UpdateValuePerHourBatch(String q){
        if(q == null || q == '')
        {
            
            Query = 'SELECT Id, Owner.Name FROM Timesheet__c';
        }
        else
        {
            Query = 'SELECT Id, Owner.Name FROM Timesheet__c where ID = \''+q+'\'';
        }
   }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for all the timesheets that need to be updated
        //String soql = 'SELECT Id, Owner.Name FROM Timesheet__c WHERE Value_per_Hour__c = null';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext bc, List<Timesheet__c> scope) {
        // Create a map of hourly rates by owner name
        Map<String, Decimal> hourlyRatesByOwnerName = new Map<String, Decimal>{
            'Sinead Gortland' => 100,
            'Lauren Doyle' => 70,
            'Ciara Ellix' => 60,
            'Sharon Larkin' => 80,
            'Laura Kelly' => 100,
            'Emma Bardon' => 60,
            'Colm Owens' => 200,
            'Lindsay Webber' => 200,
            'Elaine Jackson' => 200,
            'John Murphy' => 250,
            'Lisa Cosgrave' => 150,
            'Sarah Murphy' => 60
        };
            System.debug(scope);
        list<Timesheet__c> timesheettoUpdate=new list<Timesheet__c>();
     
        // Loop through the timesheets and update their hourly rate based on owner name
        for (Timesheet__c timesheet : scope) {
            System.debug('Owner Name==='+timesheet.Owner.Name);
                 System.debug('Hourly Rate==='+hourlyRatesByOwnerName.get(timesheet.Owner.Name));
            if (hourlyRatesByOwnerName.containsKey(timesheet.Owner.Name)) {
                System.debug('Owner Name==='+timesheet.Owner.Name);
                 System.debug('Hourly Rate==='+hourlyRatesByOwnerName.get(timesheet.Owner.Name));
                timesheet.Value_per_Hour__c = hourlyRatesByOwnerName.get(timesheet.Owner.Name);
                timesheettoUpdate.add(timesheet);
            }
        }
        
        // Update the timesheets
        If(!timesheettoUpdate.IsEmpty()){
           
            update timesheettoUpdate;
        }
        
    
    }
    
    global void finish(Database.BatchableContext bc) {
        // This method is called after all batches are processed.
        // In this case, we don't need to do anything here.
    }
    
}