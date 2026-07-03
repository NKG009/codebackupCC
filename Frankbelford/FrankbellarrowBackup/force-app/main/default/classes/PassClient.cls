public class PassClient {
    
    public static void passclienttemp(SObject so)
    {
    String ab1;
        String ab2;
        String ab3;
        String ab4;
        String ab5;
        String ab6;
        String ab7;
        String ab8;
        String ab9;
    IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
        Boolean sendMail = false;
        String errorFile = 'Id,Error\n';
        Database.SaveResult[] sList;
        sirenum__Site__c tl = (sirenum__Site__c) so;
        List<sirenum__Site__c> sitelist = [select Id,IP_InvoiceAddressCountry__c,IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c,IP_InvoiceAddressStreet__c,IP_SalesLedgerNo__c,Name,IP_Department__c,IP_TempestDepartment__c,IP_TempestDivision__c,IP_PublicSector__c,IP_PaymentTerms__c,NetMonthlySettlementCode__c,IP_ClientIDLegacy__c,IP_Clientinvoicename__c,IP_InvoiceAddressCity__c,IP_MainContact__r.Email,IP_MainContact__r.Mobilephone,IP_MainContact__r.Name,IP_MainContact__r.Phone,IP_InvoiceContactText__c,IP_InvoiceContactEmail__c,IP_InvoiceContactPhone__c,IP_InvoiceContactMobile__c,IP_InvoiceAddressLine4__c,IP_InvoiceAddressLine5__c,IP_Public_Sector__c from sirenum__Site__c where Id=:tl.id];


        List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
        Map<Id,String> Errmsg = new Map<Id,String>();

        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: tl.IP_TempestDepartment__c];
        if(branchlist.size()>0){
            for(sirenum__Site__c st : sitelist){
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
                 if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob.IP_LEA__c = '<IGNORE>';
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
         // we dont have IP_LEA__c field on site object in BA org that is why making it blank in the code here
         ob.IP_LEA__c = '';
        }
                ob.IP_OriginRecordID__c = st.Id;
                ob.IP_Client_ID_Legacy__c = st.IP_ClientIDLegacy__c;
                ob.IP_Company_Name__c = st.IP_Clientinvoicename__c;
                ob.IP_City_Invoice__c = st.IP_InvoiceAddressCity__c;
                ob.IP_Country_Invoice__c = st.IP_InvoiceAddressCountry__c;
                ob.IP_County_Invoice__c = st.IP_InvoiceAddressCounty__c;
                ob.IP_Postcode_Invoice__c   = st.IP_InvoiceAddressPostcode__c;
                ob.IP_Street_Invoice__c = st.IP_InvoiceAddressStreet__c;
                ob.IP_Invoice_ContactName__c = st.IP_InvoiceContactText__c;
                ob.IP_Email__c = st.IP_InvoiceContactEmail__c;
                ob.Invoice_Address_Line_5__c = st.IP_InvoiceAddressLine5__c;
                ob.Invoice_Address_Line_4__c = st.IP_InvoiceAddressLine4__c;
                //ob.IP_Fax__c = st.IP_InvoiceContact__r.Fax;
                ob.IP_MobilePhone__c = st.IP_InvoiceContactMobile__c;   
                ob.IP_Phone__c = st.IP_InvoiceContactPhone__c;
                ob.IP_Main_Contact_Email__c = st.IP_MainContact__r.Email;      
                ob.IP_Main_Contact_MobilePhone__c = st.IP_MainContact__r.Mobilephone;     
                ob.IP_Main_ContactName__c = st.IP_MainContact__r.Name;      
                ob.IP_Main_Contact_Phone__c = st.IP_MainContact__r.Phone;
                ob.IP_Sales_Ledger_No__c = st.IP_SalesLedgerNo__c;      
                ob.IP_SiteName__c = st.Name;
                //ob.IP_Department__c = st.IP_Department__c; - JIRA - 2459
         IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(st.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
                ob.IP_Tempest_Department__c = st.IP_TempestDepartment__c;
                ob.IP_Tempest_Division__c = st.IP_TempestDivision__c;
                ob.IP_Public_Sector_location__c = st.IP_Public_Sector__c;
                ob.IP_Payment_Terms__c = st.IP_PaymentTerms__c;      
                ob.IP_Settlement_Code__c = st.NetMonthlySettlementCode__c;
                ob.IP_Passed__c ='PASSING';
                ob.IP_TransferType__c = 'Client';
                   // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                outbound.add(ob);              
            }
        }
        if(outbound.size()>0){
            sList = Database.insert(outbound,false);


            List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted Data' );
                }
                else {
                        for(Database.Error err : sr.getErrors()) {                        errorIds.add(tl.id);                      Errmsg.put(tl.id,err.getMessage());
                    }
                }
            }
            if(!errorIds.IsEmpty()){
                for(integer i=0;i<errorIds.size();i++){
                    errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                    sendMail = true;
                }
            }
            else
            {
                try{
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                    if(parallelcheck.Run_Parallel_Payroll__c == false){
                        tl.IP_PassClientToTempest__c = false;
                        tl.IP_ClientLastPassedToTempest__c = System.now();
                    }
                }
                catch(Exception e){
                    errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                } 
            }



            /* Send email for error Ids */
            if(sendMail == true){  
                String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;

                Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
                blob errBlob = blob.valueof(errorFile);            errAtt.setFileName('Failed_Records.csv');
                errAtt.setBody(errBlob);                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
                String subject ='Outbound Data Failure - Client';
                email.setSubject(subject);   String[] toAddresses = new String[] {emailid};            
                email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});

                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

            }       
        }
        //    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
        //  Payroll.Batch_check__c=true;                 
             
    }
    
    public static void passclientaddresstemp(SObject so){
        Boolean sendMail = false;
        String errorFile = 'Id,Error\n';
        Database.SaveResult[] sList;
        sirenum__Site__c tl = (sirenum__Site__c) so;
        List<sirenum__Site__c> sitelist = [select Id,IP_InvoiceAddressCountry__c,IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c,IP_InvoiceAddressStreet__c,Name,IP_InvoiceAddressCity__c,sirenum__Street_Address__c,sirenum__City__c,sirenum__County__c,sirenum__Postal_Code__c,sirenum__Country__c,IP_MainContact__r.Fax,IP_MainContact__r.Phone,IP_MainContact__r.Name,IP_ClientIDLegacy__c from sirenum__Site__c where Id=:tl.id];
        List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
        Map<Id,String> Errmsg = new Map<Id,String>();

        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: tl.IP_TempestDepartment__c];
        if(branchlist.size()>0){
            for(sirenum__Site__c st : sitelist){
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
                ob.IP_OriginRecordID__c = st.Id;
                ob.IP_City_Invoice__c = st.IP_InvoiceAddressCity__c;
                ob.IP_Country_Invoice__c = st.IP_InvoiceAddressCountry__c;
                ob.IP_County_Invoice__c = st.IP_InvoiceAddressCounty__c;
                ob.IP_Postcode_Invoice__c   = st.IP_InvoiceAddressPostcode__c;
                ob.IP_Street_Invoice__c = st.IP_InvoiceAddressStreet__c;
                ob.IP_SiteName__c = st.Name;
                ob.IP_Street_Address__c = st.sirenum__Street_Address__c;
                ob.IP_City__c = st.sirenum__City__c;
                ob.IP_County__c = st.sirenum__County__c;
                ob.IP_Postal_Code__c = st.sirenum__Postal_Code__c;
                ob.IP_Country__c = st.sirenum__Country__c;
                ob.IP_Main_Contact_Fax__c = st.IP_MainContact__r.Fax; 
                ob.IP_Main_ContactName__c = st.IP_MainContact__r.Name;      
                ob.IP_Main_Contact_Phone__c = st.IP_MainContact__r.Phone;
                ob.IP_Client_ID_Legacy__c = st.IP_ClientIDLegacy__c;
                ob.IP_Passed__c ='PASSING';
                ob.IP_TransferType__c = 'Client Address';
                outbound.add(ob);              
            }
        }
        if(outbound.size()>0){
            sList = Database.insert(outbound,false);

            List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted Data' );
                }
                else {
                    for(Database.Error err : sr.getErrors()) { 
                        errorIds.add(tl.id);                      Errmsg.put(tl.id,err.getMessage());
                    }
                }
            }
            if(!errorIds.IsEmpty()){
                for(integer i=0;i<errorIds.size();i++){
                    errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                   sendMail = true;
                }
            }
            else{
                try{
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                    if(parallelcheck.Run_Parallel_Payroll__c == false){
                        tl.IP_PassClientAddressToTempest__c = false;
                        tl.IP_ClientAddressLastPassedToTempest__c = System.now();
                    }
                }
                catch(Exception e){
                    errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                } 
            }



            /* Send email for error Ids */
            if(sendMail == true)
            {   
            String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);          errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);             Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Outbound Data Failure - Client Address';
            email.setSubject(subject);
            // String[] toAddresses = new String[]{'tajinder.singh@espire.com'};
            String[] toAddresses = new String[] {emailid};
            email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});

            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

            }       
        }
         //   Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
         //   Payroll.Batch_check__c=true;                
             
    }

    
    public static void passEmergencyClient(SObject so){
      IP_CompanyCode__c Ccode = IP_CompanyCode__c.getValues('CompanyCode');
        Boolean sendMail = false;
        String errorFile = 'Id,Error\n';
        Database.SaveResult[] sList;
        sirenum__Site__c tl = (sirenum__Site__c) so;
        List<sirenum__Site__c> sitelist = [select Id,IP_InvoiceAddressCountry__c,IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c,IP_InvoiceAddressStreet__c,IP_SalesLedgerNo__c,Name,IP_Department__c,IP_TempestDepartment__c,IP_TempestDivision__c,IP_PublicSector__c,IP_PaymentTerms__c,NetMonthlySettlementCode__c,IP_ClientIDLegacy__c,IP_Clientinvoicename__c,IP_InvoiceAddressCity__c,IP_MainContact__r.Email,IP_MainContact__r.Mobilephone,IP_MainContact__r.Name,IP_MainContact__r.Phone,IP_InvoiceContactText__c,IP_InvoiceContactEmail__c,IP_InvoiceContactPhone__c,IP_InvoiceContactMobile__c,IP_InvoiceAddressLine4__c,IP_InvoiceAddressLine5__c,IP_Public_Sector__c from sirenum__Site__c where Id=:tl.id];


        List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
        Map<Id,String> Errmsg = new Map<Id,String>();

        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: tl.IP_TempestDepartment__c];
        if(branchlist.size()>0){
            for(sirenum__Site__c st : sitelist){
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
                 if(Ccode.IP_CompanyCodeValue__c == 'BAL'){
        ob.IP_LEA__c = '<IGNORE>';
        }
        else if(Ccode.IP_CompanyCodeValue__c == 'CEL'){
        ob.IP_LEA__c = '';
        }
                ob.IP_OriginRecordID__c = st.Id;
                ob.IP_EmergencyPull__c = True;
                ob.IP_Client_ID_Legacy__c = st.IP_ClientIDLegacy__c;
                ob.IP_Company_Name__c = st.IP_Clientinvoicename__c;
                ob.IP_City_Invoice__c = st.IP_InvoiceAddressCity__c;
                ob.IP_Country_Invoice__c = st.IP_InvoiceAddressCountry__c;
                ob.IP_County_Invoice__c = st.IP_InvoiceAddressCounty__c;
                ob.IP_Postcode_Invoice__c   = st.IP_InvoiceAddressPostcode__c;
                ob.IP_Street_Invoice__c = st.IP_InvoiceAddressStreet__c;
                ob.IP_Invoice_ContactName__c = st.IP_InvoiceContactText__c;
                ob.IP_Email__c = st.IP_InvoiceContactEmail__c;
                ob.Invoice_Address_Line_5__c = st.IP_InvoiceAddressLine5__c;
                ob.Invoice_Address_Line_4__c = st.IP_InvoiceAddressLine4__c;
                // ob.IP_Fax__c = st.IP_InvoiceContact__r.Fax;
                ob.IP_MobilePhone__c = st.IP_InvoiceContactMobile__c;   
                ob.IP_Phone__c = st.IP_InvoiceContactPhone__c;
                ob.IP_Main_Contact_Email__c = st.IP_MainContact__r.Email;      
                ob.IP_Main_Contact_MobilePhone__c = st.IP_MainContact__r.Mobilephone;     
                ob.IP_Main_ContactName__c = st.IP_MainContact__r.Name;      
                ob.IP_Main_Contact_Phone__c = st.IP_MainContact__r.Phone;
                ob.IP_Sales_Ledger_No__c = st.IP_SalesLedgerNo__c;      
                ob.IP_SiteName__c = st.Name;
                 //ob.IP_Department__c = st.IP_Department__c; - JIRA - 2459
         IP_Shift_Template__c shiftcode = IP_Shift_Template__c.getValues(st.IP_TempestDepartment__c);
        if(shiftcode != NULL){
        ob.IP_Department__c = shiftcode.IP_Site_Name__c;}
                ob.IP_Tempest_Department__c = st.IP_TempestDepartment__c;
                ob.IP_Tempest_Division__c = st.IP_TempestDivision__c;
                ob.IP_Public_Sector_location__c = st.IP_Public_Sector__c;
                ob.IP_Payment_Terms__c = st.IP_PaymentTerms__c;      
                ob.IP_Settlement_Code__c = st.NetMonthlySettlementCode__c;
                ob.IP_Passed__c ='PASSING';
                ob.IP_TransferType__c = 'Client';
                   // ob.IP_BrandCompanyCode__c = Ccode.IP_CompanyCodeValue__c;
                outbound.add(ob);              
            }
        }
        if(outbound.size()>0){
            sList = Database.insert(outbound,false);

            List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted Data' );
                }
                else {
                        for(Database.Error err : sr.getErrors()) {                        errorIds.add(tl.id);                      Errmsg.put(tl.id,err.getMessage());
                    }

                }
            }
            
            if(!errorIds.IsEmpty()){
                for(integer i=0;i<errorIds.size();i++){
                errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                    sendMail = true;
                }
            }
            else{
                try{
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                    if(parallelcheck.Run_Parallel_Payroll__c == false){
                        tl.IP_PassClientToTempest__c = false;
                        tl.IP_EmergencyPullClient__c = false;
                        tl.IP_ClientLastPassedToTempest__c = System.now();
                    }
                }
                catch(Exception e){
                    errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                } 
            }



            /* Send email for error Ids */
            if(sendMail == true){  
                String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;

                Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
                blob errBlob = blob.valueof(errorFile);            errAtt.setFileName('Failed_Records.csv');
                errAtt.setBody(errBlob);                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
                String subject ='Outbound Data Failure - Emergency Client';            email.setSubject(subject);   String[] toAddresses = new String[] {emailid};            
                email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});

                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

            }       
        }
        //    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
        //  Payroll.Batch_check__c=true;
    }
    
    public static void passEmergencyclientadd(SObject so){
        Boolean sendMail = false;
        String errorFile = 'Id,Error\n';
        Database.SaveResult[] sList;
        sirenum__Site__c tl = (sirenum__Site__c) so;
        List<sirenum__Site__c> sitelist = [select Id,IP_InvoiceAddressCountry__c,IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c,IP_InvoiceAddressStreet__c,Name,IP_InvoiceAddressCity__c,sirenum__Street_Address__c,sirenum__City__c,sirenum__County__c,sirenum__Postal_Code__c,sirenum__Country__c,IP_MainContact__r.Fax,IP_MainContact__r.Phone,IP_MainContact__r.Name,IP_ClientIDLegacy__c from sirenum__Site__c where Id=:tl.id];
        List<IP_OutboundDataTransfer__c> outbound = new List<IP_OutboundDataTransfer__c>();
        Map<Id,String> Errmsg = new Map<Id,String>();

        List<IP_BranchStatus__c> branchlist = [select id from IP_BranchStatus__c where IP_BranchID__c=: tl.IP_TempestDepartment__c];
        if(branchlist.size()>0){
            for(sirenum__Site__c st : sitelist){
                IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
                ob.IP_OriginRecordID__c = st.Id;
                ob.IP_EmergencyPull__c = true;
                ob.IP_City_Invoice__c = st.IP_InvoiceAddressCity__c;
                ob.IP_Country_Invoice__c = st.IP_InvoiceAddressCountry__c;
                ob.IP_County_Invoice__c = st.IP_InvoiceAddressCounty__c;
                ob.IP_Postcode_Invoice__c   = st.IP_InvoiceAddressPostcode__c;
                ob.IP_Street_Invoice__c = st.IP_InvoiceAddressStreet__c;
                ob.IP_SiteName__c = st.Name;
                ob.IP_Street_Address__c = st.sirenum__Street_Address__c;
                ob.IP_City__c = st.sirenum__City__c;
                ob.IP_County__c = st.sirenum__County__c;
                ob.IP_Postal_Code__c = st.sirenum__Postal_Code__c;
                ob.IP_Country__c = st.sirenum__Country__c;
                ob.IP_Main_Contact_Fax__c = st.IP_MainContact__r.Fax; 
                ob.IP_Main_ContactName__c = st.IP_MainContact__r.Name;      
                ob.IP_Main_Contact_Phone__c = st.IP_MainContact__r.Phone;
                ob.IP_Client_ID_Legacy__c = st.IP_ClientIDLegacy__c;
                ob.IP_Passed__c ='PASSING';
                ob.IP_TransferType__c = 'Client Address';
                outbound.add(ob);             
            }
        }
        if(outbound.size()>0){
            sList = Database.insert(outbound,false);
            
            List<Id> errorIds = new List<Id>();
            for (Database.SaveResult sr : sList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted Data' );
                }
                else {
                    for(Database.Error err : sr.getErrors()) { 
                        errorIds.add(tl.id);                      Errmsg.put(tl.id,err.getMessage());
                    }
                }
            }
            if(!errorIds.IsEmpty()){
                for(integer i=0;i<errorIds.size();i++){
                    errorFile = errorFile + errorIds[i]+','+ Errmsg.get(errorIds[i]) + ',' +'\n';                   sendMail = true;
                }
            }
            else{
                try{
                    IP_Parallel_Payroll_Check__c parallelcheck = IP_Parallel_Payroll_Check__c.getValues('RunParallelCheck'); 
                    if(parallelcheck.Run_Parallel_Payroll__c == false){
                        tl.IP_PassClientAddressToTempest__c = false;
                        tl.IP_EmergencyPullClientAddress__c = false;
                        tl.IP_ClientAddressLastPassedToTempest__c = System.now();
                    }
                }
                catch(Exception e){
                    errorFile = errorFile + tl +',' +e +','+'\n';                   sendMail = true;
                } 
            }



            /* Send email for error Ids */
            if(sendMail == true){   
                String emailid = IP_ImpellamGlobalSetting__c.getInstance().IP_OutboundErrorEmailAddress__c;
                Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
                blob errBlob = blob.valueof(errorFile);          errAtt.setFileName('Failed_Records.csv');
                errAtt.setBody(errBlob);             Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
                String subject ='Outbound Data Failure - Client Address';            email.setSubject(subject);
                // String[] toAddresses = new String[]{'tajinder.singh@espire.com'};
                String[] toAddresses = new String[] {emailid};
                email.setToAddresses(toAddresses);            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }       
        }
        //   Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
        //   Payroll.Batch_check__c=true;             
    }
    
}