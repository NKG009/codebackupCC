global class P45DailyProfileProcessorBatch implements Database.Batchable<sObject>,Database.Stateful{

datetime dt = system.now();
date today = system.today();
List<Contact> updatelist = new List<Contact>();
List<IP_PayProfile__c> updatepay = new List<IP_PayProfile__c>();
         global Database.QueryLocator start(Database.BatchableContext BC){
           String query ='Select id,name,IP_Status__c,P45_Date_by_Head_Office__c,IP_Candidate__r.Person_Status__c,P45_Initiated__c,IP_Candidate__c,IP_Candidate__r.IP_Allpayprofiles__c,IP_Payroll_Leaver__c,IP_LastPassedToTempest__c from IP_PayProfile__c where IP_LastPassedToTempest__c <=:dt and IP_Status__c =\'Active\' and IP_Payroll_Leaver__c = \'PL\'';
             return Database.getQueryLocator(query);
         
         }
           global void execute(Database.BatchableContext BC,List<IP_PayProfile__c > payprofile){
             for(IP_PayProfile__c pp: payprofile){
                    pp.IP_Status__c='Inactive';
                    pp.IP_PrimaryPayMethod__c=false;
                    pp.For_P45_batch__c = true;
                    updatepay.add(pp);
                     //Databse.update(payprofile,false);
                     System.debug('active pay profile count'+ pp.IP_Candidate__r.IP_Allpayprofiles__c);
                   if(pp.IP_Candidate__r.IP_Allpayprofiles__c == 1)
                   {
                       pp.IP_Candidate__r.Person_Status__c = 'Inactive';
                   }
                    updatelist.add(pp.IP_Candidate__r);
                }
          
          Database.update(updatelist,false);
          Database.update(updatepay,false);
           
              system.debug('after update payprofile'+payprofile);
           }
            global void finish(Database.BatchableContext BC){
            
            
        
        }
        }