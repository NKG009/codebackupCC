global class SiteRecordCreationBatch implements Database.Batchable<sObject>,Database.Stateful  {
    
    global Datetime CreatedDate;
    global Datetime batchstartdate;
    
    global SiteRecordCreationBatch( Datetime CreDate){
        this.CreatedDate=CreDate;
        this.batchstartdate = system.now();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
      string querywithcreateddate='select Id,Status,createddate,Work_Type__c,AccountId,Account.Name,Account.RecordtypeId,Account.Recordtype.DeveloperName,ContactId,Contact.RecordtypeId,Contact.vacate_date__c,Contact.Is_Archived_in_Property_Tree__c,Contact.Is_Deleted_in_Property_Tree__c,Contact.Is_Prospect_in_Property_Tree__c,Contact.Archived_By_PS360__c,FSSK__FSK_Work_Order__c,FSSK__FSK_Work_Order__r.Position__c,(select id,Service_Appointment__c from Site_Contacts__r) from ServiceAppointment where FSSK__FSK_Work_Order__r.Position__c=Null'; 
      if(CreatedDate!=null){
           querywithcreateddate= querywithcreateddate +' And createddate>=:CreatedDate';
        }
      
         return Database.getQueryLocator(querywithcreateddate);
    }    //(Status='None' AND Work_Type__c='Key Pickup') OR
    global void execute(Database.BatchableContext bc, List<ServiceAppointment> SARecords){
        try{  
            Map<Id,Id> accountVservApp= New Map<Id,Id>();
            list<Id> Accids= New list<Id>();
            //list<Id> Sappointmentids= New list<Id>();
            Set<Id> Servids= New Set<Id>();
            list<Site_Contact__c> SiteContactlist= New list<Site_Contact__c>();
            list<Site_Contact__c> SiteCToUpdate= New list<Site_Contact__c>();
            list<ServiceAppointment>Servicelist= New list<ServiceAppointment>(); 
            //list<ServiceAppointment> SAlist2= New list<ServiceAppointment>();
             
                  
            for(ServiceAppointment sa:SARecords){
             string acctype =sa.Account.Recordtype.DeveloperName;
                if(sa.AccountId !=Null && acctype=='Property' && sa.Site_Contacts__r.size()==0 ){ 
                    Accids.add(sa.AccountId);
                    accountVservApp.put(sa.AccountId,sa.Id);
                    //Sappointmentids.add(sa.Id);
                }
                
                
            }
            if(Accids.size()>0){       
            date d = system.today();
            for(contact con :[Select Id,AccountId,MobilePhone,LastName,FirstName,Email,Is_Primary__c,Contact_Name_80_Char__c,RecordtypeId,Recordtype.DeveloperName ,vacate_date__c,Is_Archived_in_Property_Tree__c,Is_Deleted_in_Property_Tree__c,Is_Prospect_in_Property_Tree__c,Archived_By_PS360__c from contact where AccountId IN:Accids AND (Recordtype.DeveloperName='Tenant'AND Is_Archived_in_Property_Tree__c=false AND Is_Deleted_in_Property_Tree__c=false AND Is_Prospect_in_Property_Tree__c=false AND Archived_By_PS360__c=false) AND (vacate_date__c=:d OR vacate_date__c=null)]){
                
                if(con.id !=null){
                    Site_Contact__c st = new Site_Contact__c();
                    st.Contact__c=con.Id;
                    st.Service_Appointment__c=accountVservApp.get(con.AccountId);
                    st.Name=con.Contact_Name_80_Char__c;
                    st.Last_Name__c=con.LastName;
                    st.Mobile_Num__c=con.MobilePhone;
                    st.Site_Contact_Email__c=con.Email;
                    SiteContactlist.add(st);
                    Servids.add(st.Service_Appointment__c);
                } 
                
            }
            system.debug('aftersitecontactcreation=='+ SiteContactlist);
                if(SiteContactlist.size()>0){
                    insert SiteContactlist;
                }
            for(ServiceAppointment sa:[select id,Comms__c,(select id,Service_Appointment__c,Primary_Contact__c,Number_on_contact__c from Site_Contacts__r) from ServiceAppointment where id IN:Servids]){
                integer i=1;
                Boolean boolval= false;
                for(Site_Contact__c SC : sa.Site_Contacts__r){
                    
                if(sc.Primary_Contact__c==true && boolval ==false){
                      sc.Number_on_contact__c=0; 
                       boolval=true;
                   }  
                   
                    else{ 
                        sc.Number_on_contact__c=i;
                        system.debug('i value======'+i);
                         i++;
                        }  
                
                   
                    SiteCToUpdate.add(sc); 
                    
                } 
                
            }
            system.debug('no=='+ SiteCToUpdate);
            if(SiteCToUpdate.size()>0) {
                update SiteCToUpdate;
            }
           
            for(ServiceAppointment sa:[select id,Comms__c,Contact_1__c,Contact2__c,Contact3__c,Contact4__c,(select id,Contact__c,Service_Appointment__c,Primary_Contact__c,Number_on_contact__c from Site_Contacts__r) from ServiceAppointment where id IN:Servids]){
                sa.Comms__c='Site Contact Added';
                Boolean boolval= false;
                for(Site_Contact__c SC : sa.Site_Contacts__r){
                  if(sc.Primary_Contact__c==true && boolval ==false){
                        sa.ContactId=sc.Contact__c;
                        boolval=true;
                       system.debug('boolvalif==' + boolval );
                    } 
                    if(sc.Number_on_contact__c==1){
                        sa.Contact_1__c=sc.Contact__c;
                    }
                    if(sc.Number_on_contact__c==2){
                        sa.Contact2__c=sc.Contact__c;
                    }
                    if(sc.Number_on_contact__c==3){
                        sa.Contact3__c=sc.Contact__c;
                    }
                    if(sc.Number_on_contact__c==4){
                        sa.Contact4__c=sc.Contact__c;
                    }
                   // Servicelist.add(sa);
                 system.debug('boolval==' + boolval ); 
                } 
                Servicelist.add(sa); 
            }
             system.debug('last update=='+ Servicelist);
            if(Servicelist.size()>0) {
                update Servicelist;
        
           }
           }
           } 
        catch(Exception ex){
            system.debug('!!!!!Error while processing the request:'+ ex+'!!!!!!');
            List<Error_Log__c> errorLogsList=new List<Error_Log__c>();
            //  Capture Error Log Details
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
            errorLog.Class_Name__c = 'SiteRecordCreation';
            errorLog.Method_Name__c = 'execute';
            errorLogsList.add(errorLog); 
            if(errorLogsList.size()>0){
            insert errorLogsList;
            }
        }
    }
   
    global void finish(Database.BatchableContext bc){
       SiteRecordCreationSchedulable.reschedulebatch(batchstartdate);
    }   
   
}