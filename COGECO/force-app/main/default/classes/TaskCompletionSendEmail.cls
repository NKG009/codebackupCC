public class TaskCompletionSendEmail {

      public static void sendOpportunityEmail(Opportunity ld, Task ts) {

         String[] toEM = new String[] {ld.owner.email};
         String[] toEMLastNM = new String[] {ld.owner.firstname};
         String[] toEMFirstNM = new String[] {ld.owner.lastname};
         String[] toOppName = new String[] {ld.name};
         String[] toOppStage = new String[] {ld.StageName};
         String[] toOppAccount = new String[] {ld.Account_Name_Desc__c};
         String[] toEOppInstDT = new String[] {string.valueof(ld.Installation_Date__c)};
         String[] toEMLang = new String[] {ld.owner.LanguageLocaleKey};
         String[] OppID = new String[] {ld.id};

         String[] tkSubject = new String[] {ts.Subject};
         String[] tkStatus = new String[] {ts.Status};
         String[] tkDesc = new String[] {ts.Description};
         String[] tkDueDT = new String[] {string.valueof(ts.ActivityDate )};
         String[] tkID = new String[] {ts.ID};
        

     if(string.valueof(ld.owner.LanguageLocaleKey) == 'en_US'){
               
      Messaging.reserveSingleEmailCapacity(1);  
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSaveAsActivity(true);

      //String[] toAddresses = new String[] {'shyam.verma@cogeco.com'};
      User ulng = [SELECT toLabel(LanguageLocaleKey) FROM User WHERE Id = :UserInfo.getUserId()];
      
      String plainTextBody = '';
        plainTextBody += '\n Hello '+string.valueof(ld.owner.firstname)+' '+string.valueof(ld.owner.lastname)+ '\n\n';
        plainTextBody += 'Your Opportunity : '+string.valueof(ld.name)+ ' related TASK has been completed \n\n';
        plainTextBody += 'Opportunity Account : '+string.valueof(ld.Account_Name_Desc__c)+ ' \n';
        plainTextBody += 'Opportunity Install Date : '+string.valueof(ld.Installation_Date__c)+ ' \n';
        plaintextbody += 'Opportunity URL https://cogeco-connexion.lightning.force.com/'+string.valueof(ld.ID )+ ' \n\n';
        plainTextBody += 'Task Subject : '+string.valueof(ts.Subject)+ ' \n';
        plainTextBody += 'Task Status : '+string.valueof(ts.Status)+ ' \n';
        plainTextBody += 'Task Desc : '+string.valueof(ts.Description)+ ' \n';
        plainTextBody += 'Task Install Date : '+string.valueof(ts.ActivityDate)+ ' \n';
        plaintextbody += 'Task URL https://cogeco-connexion.lightning.force.com/'+string.valueof(ts.ID )+ ' \n\n\n';
        plainTextBody += 'Thank you, Salesforce Support \n';
        plainTextBody += 'Shyam Verma - shyam.verma@cogeco.com \n\n';
      String body = plainTextBody;

      mail.setToAddresses(toEM);
      mail.setSubject('Salesforce CPQ --- Task Completed for Opportunity '+string.valueof(ld.name)); // string.valueof(toEM));
      mail.setPlainTextBody(body);   
      mail.setSaveAsActivity(true);
      
      Messaging.SendEmailResult[] results = Messaging.sendEmail(
                          new Messaging.SingleEmailMessage[] { mail });
   
   } else {
   
      Messaging.reserveSingleEmailCapacity(1);  
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSaveAsActivity(true);
        
      //String[] toAddresses = new String[] {'shyam.verma@cogeco.com'};
      User ulng = [SELECT toLabel(LanguageLocaleKey) FROM User WHERE Id = :UserInfo.getUserId()];
      
      String plainTextBody = '';
        plainTextBody += '\n Bonjour '+string.valueof(ld.owner.firstname)+' '+string.valueof(ld.owner.lastname)+ '\n\n';
        plainTextBody += 'Votre opportunité : '+string.valueof(ld.name)+ ' reliée à Test789 été complété \n\n';
        plainTextBody += 'Compte de l opportunite : '+string.valueof(ld.Account_Name_Desc__c)+ ' \n';
        plainTextBody += 'Date d installation de l opportunité : '+string.valueof(ld.Installation_Date__c)+ ' \n';
        plaintextbody += 'URL de l opportunité : https://cogeco-connexion.lightning.force.com/'+string.valueof(ld.ID )+ ' \n\n';
        plainTextBody += 'Sujet de la tache : '+string.valueof(ts.Subject)+ ' \n';
        plainTextBody += 'Sujet de la tache : '+string.valueof(ts.Status)+ ' \n';
        plainTextBody += 'Descrip tâche : '+string.valueof(ts.Description)+ ' \n';
        plainTextBody += 'Date d installation de la tache : '+string.valueof(ts.ActivityDate)+ ' \n';
        plaintextbody += 'URL de la tache : https://cogeco-connexion.lightning.force.com/'+string.valueof(ts.ID )+ ' \n\n\n';
        plainTextBody += 'Merci, Support Salesforce \n';
        plainTextBody += 'Shyam Verma - shyam.verma@cogeco.com \n\n';
      String body = plainTextBody;

      mail.setToAddresses(toEM);
      mail.setSubject('Salesforce CPQ --- Task Completed for Opportunity '+string.valueof(ld.name)); // string.valueof(toEM));
      mail.setPlainTextBody(body);   
      mail.setSaveAsActivity(true);
      
      Messaging.SendEmailResult[] results = Messaging.sendEmail(
                          new Messaging.SingleEmailMessage[] { mail });
   }
      }


         public static void sendAccountEmail(Account acc, Task ts){

         String[] toEM = new String[] {acc.owner.email};
         String[] toEMLastNM = new String[] {acc.owner.firstname};
         String[] toEMFirstNM = new String[] {acc.owner.lastname};
         String[] toOppName = new String[] {acc.name };
         String[] toEMLang = new String[] {acc.owner.LanguageLocaleKey };
         String[] OppID = new String[] {acc.id };

         String[] tkSubject = new String[] {ts.Subject };
         String[] tkStatus = new String[] {ts.Status};
         String[] tkDesc = new String[] {ts.Description};
         String[] tkDueDT = new String[] {string.valueof(ts.ActivityDate ) };
         String[] tkID = new String[] {ts.ID };
        

     if(string.valueof(acc.owner.LanguageLocaleKey) == 'en_US'){
               
      Messaging.reserveSingleEmailCapacity(1);  
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSaveAsActivity(true);

      //String[] toAddresses = new String[] {'shyam.verma@cogeco.com'};
      User ulng = [SELECT toLabel(LanguageLocaleKey) FROM User WHERE Id = :UserInfo.getUserId()];
      
      String plainTextBody = '';
        plainTextBody += '\n Hello '+string.valueof(acc.owner.firstname)+' '+string.valueof(acc.owner.lastname)+ '\n\n';
        plainTextBody += 'Your Account : '+string.valueof(acc.name)+ ' related TASK has been completed \n\n';
        plaintextbody += 'Account URL https://cogeco-connexion.lightning.force.com/'+string.valueof(acc.ID )+ ' \n\n';
        plainTextBody += 'Task Subject : '+string.valueof(ts.Subject)+ ' \n';
        plainTextBody += 'Task Status : '+string.valueof(ts.Status)+ ' \n';
        plainTextBody += 'Task Desc : '+string.valueof(ts.Description)+ ' \n';
        plainTextBody += 'Task Install Date : '+string.valueof(ts.ActivityDate)+ ' \n';
        plaintextbody += 'Task URL https://cogeco-connexion.lightning.force.com/'+string.valueof(ts.ID )+ ' \n\n\n';
        plainTextBody += 'Thank you, Salesforce Support \n';
        plainTextBody += 'Shyam Verma - shyam.verma@cogeco.com \n\n';
      String body = plainTextBody;

      mail.setToAddresses(toEM);
      mail.setSubject('Salesforce CPQ --- Task Completed for Account '+string.valueof(acc.name)); // string.valueof(toEM));
      mail.setPlainTextBody(body);   
      mail.setSaveAsActivity(true);
      
      Messaging.SendEmailResult[] results = Messaging.sendEmail(
                          new Messaging.SingleEmailMessage[] { mail });
   
   } else {
   
      Messaging.reserveSingleEmailCapacity(1);  
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSaveAsActivity(true);
        
      //String[] toAddresses = new String[] {'shyam.verma@cogeco.com'};
      User ulng = [SELECT toLabel(LanguageLocaleKey) FROM User WHERE Id = :UserInfo.getUserId()];
      
      String plainTextBody = '';
        plainTextBody += '\n Bonjour '+string.valueof(acc.owner.firstname)+' '+string.valueof(acc.owner.lastname)+ '\n\n';
        plainTextBody += 'Votre compté : '+string.valueof(acc.name)+ ' reliée à Test789 été complété \n\n';
        plaintextbody += 'URL de l compté : https://cogeco-connexion.lightning.force.com/'+string.valueof(acc.ID )+ ' \n\n';
        plainTextBody += 'Sujet de la tache : '+string.valueof(ts.Subject)+ ' \n';
        plainTextBody += 'Sujet de la tache : '+string.valueof(ts.Status)+ ' \n';
        plainTextBody += 'Descrip tâche : '+string.valueof(ts.Description)+ ' \n';
        plainTextBody += 'Date d installation de la tache : '+string.valueof(ts.ActivityDate)+ ' \n';
        plaintextbody += 'URL de la tache : https://cogeco-connexion.lightning.force.com/'+string.valueof(ts.ID )+ ' \n\n\n';
        plainTextBody += 'Merci, Support Salesforce \n';
        plainTextBody += 'Shyam Verma - shyam.verma@cogeco.com \n\n';
      String body = plainTextBody;

      mail.setToAddresses(toEM);
      mail.setSubject('Salesforce CPQ --- Task Completed for Account '+string.valueof(acc.name)); // string.valueof(toEM));
      mail.setPlainTextBody(body);   
      mail.setSaveAsActivity(true);
      
      Messaging.SendEmailResult[] results = Messaging.sendEmail(
                          new Messaging.SingleEmailMessage[] { mail });

}


}
          
}