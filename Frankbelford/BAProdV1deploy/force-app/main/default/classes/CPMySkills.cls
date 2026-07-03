global without sharing class CPMySkills {
    
    @AuraEnabled  
    global static List<sirenum__Ticket__c> getSkills() { 
        sirenum__Ticket__c tkt;
        if(getUserId()==null){
            return [select Id,Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c from sirenum__Ticket__c where sirenum__Owner__c='0030Y000016UI2w' ]; }else{  return [select Id,Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c from sirenum__Ticket__c where sirenum__Owner__c=:getUserId() ]; }        
    }   
    
    @AuraEnabled  
    global static void  sendQuery(String comments2){
        Id templateIdBranch = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Query_Re_Skills_Branch'].id;
        Id templateIdCandidate = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Query_Re_Skills_Cand'].id;
        
        OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];

        if(comments2!='' || comments2!=null){   
            Contact cont;   
            if(getUserId()==null && !test.isRunningTest()){  
                cont = [Select Owner.Email From Contact where Id='0030Y000016UI2w' limit 1]; 
            } 
            else { 
                cont = [Select Owner.Name,Owner.email,ID,Name,FirstName,IP_TempestDepartment__c From Contact  where Id=:getUserId() limit 1]; 
                cont.QueryDescription__c=comments2;
                update cont;
            }              
      
            String department = cont.IP_TempestDepartment__c;
            IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
            String BranchUserEmail = shiftemp.Email__c;
             OrgWideEmailAddress owd1 = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];

            User usr = new User();
            if(cont.Email!=null && !test.isRunningTest()){
                usr = [Select id from User WHERE ContactId =:cont.id LIMIT 1];
            }
            String targetObjid = '';
            if(usr.Id!=null){
                targetObjid = usr.Id;
            }else
            {
                targetObjid = cont.id;
            }
            /*
            if(cont.Owner.Email!=null && !test.isRunningTest()){
                targetObjid = cont.Owner.Id;
            }
            else{
                targetObjid = cont.id;
            }
            */
            System.debug('Debug log for usr.Id: '+usr.Id); 
            
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.saveAsActivity = false;
            semail.setTargetobjectID(targetObjid);
            semail.setOrgWideEmailAddressId(owd1.Id);
            semail.setTemplateId(templateIdCandidate); 
            if(!test.isRunningTest())
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
            }
             
            
            /* 
Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
semail.setTargetobjectID(cont.id);
semail.setOrgWideEmailAddressId(owd.Id);      
semail.setSubject(' Receipt of your skills query '); 
semail.setPlainTextBody('Hi '+cont.FirstName+','+'\n'+'\n'+
'Thank you for your query. It has been passed to Consultant, '+cont.Owner.Name+', who will contact you very soon to confirm the update on your skills profile. '+'\n\n'+
'Best regards, '+'\n'+
'Customer Support'); 
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
*/
            
            Messaging.SingleEmailMessage semail1 = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {BranchUserEmail};
            semail1.setTreatTargetObjectAsRecipient(False);
            semail1.setTargetObjectId(targetObjid);
            semail1.setToAddresses(toAddresses);
            semail1.setTemplateId(templateIdBranch); 
            semail1.setOrgWideEmailAddressId(owd.Id);
            if(!test.isRunningTest())
            {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail1}); 
            }
            /* 
Messaging.SingleEmailMessage semail1 = new Messaging.SingleEmailMessage();

String department = cont.IP_TempestDepartment__c;
IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
String BranchUserEmail = shiftemp.Email__c;
String[] toAddresses = new String[] {BranchUserEmail};
semail1.setToAddresses(toAddresses);
semail1.setOrgWideEmailAddressId(owd.Id);
semail1.setSubject(' My Skills query from '+cont.Name); 
semail1.setPlainTextBody('Hi, '+'\n'+'\n'+
cont.Name+' has raised the following query regarding their skills. '+'\n\n'+
'Query: '+ comments2 +'\n\n'+
'Please contact '+cont.Name+' to help resolve this query. '+'\n\n'+
'Thanks, '+'\n'+
'Jobscience'); 
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail1}); 
*/
        }
        
    } 
    
    public static String getUserId(){
        ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
        return contactId;
    }
    
}