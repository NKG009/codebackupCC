global class Portaluserdisable extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>, Database.Stateful {
  global Database.QueryLocator start(Database.BatchableContext BC) {
    String query = 'Select Id, IsActive, IsPortalEnabled from User where Contact.IP_MarkedForDeletion__c = true';
    return Database.getQueryLocator(Query);
  }
  global void execute(Database.BatchableContext BC, List<User> scope) {
    List<user> userupdate = new List<User>();
    for (integer i = 0; i < scope.size(); i++) {
      if (scope[i].IsActive || scope[i].IsPortalEnabled) {
        scope[i].IsActive = false;
        scope[i].IsPortalEnabled = false;
        System.debug(scope[i]);
        userupdate.add(scope[i]);
      }
    }
    System.debug(userupdate);
    Database.SaveResult[] UserList = Database.update(userupdate, false);
    //update scope;
  }

  global void finish(Database.BatchableContext BC) {
    super.finishBatch(BC);
  }
}