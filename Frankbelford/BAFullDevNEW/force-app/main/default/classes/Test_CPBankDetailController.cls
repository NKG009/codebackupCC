@isTest
private class Test_CPBankDetailController {
    
    @testSetup  
    static void sSetup() {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile pProfile = [Select Id from Profile where name = 'System Administrator'];
        User userP = new User(Username = System.now().millisecond() + 'portalUser123@test.com', ProfileId = pProfile.Id,
                              UserRoleId = portalRole.Id, Alias = 'pt123', Email = 'manish.mishra@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'l4848',
                              CommunityNickname = 'chec', IP_TempestDepartment__c='1062',IP_TempestID__c='1062',
                              IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US');
        insert userP;    
        contact con;
        Contact c1 ;
        sirenum__Timesheet__c sts;
        System.runAs(userP) {
            Account acc1 = new Account(Name = 'TestAccount', OwnerId = userP.Id );
            insert acc1;
                    insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

            c1 = new Contact( FirstName = 'tt', Lastname = 'mm', AccountId = acc1.Id, Email = System.now().millisecond() + 'as@test.com');
            Database.insert(c1);            
        }
        
        Profile dProfile = [Select Id from Profile where name = 'System Administrator'];
        User userd = new User( Username = System.now().millisecond() + 'portalUser123@test.com',    ProfileId = dProfile.Id,
                              Alias = 'klkl', Email = 'user1@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'lnamemm',
                               CommunityNickname = 'checked', TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        Database.insert(userd);                       
    }
    @isTest
    static void get_bank_Positive(){
        
        User au = [select id , contactId from user where lastname = 'l4848' limit 1];
        User u = [select id , contactId from user where lastname = 'lnamemm' limit 1];
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];     
        Account client = new Account(Name='candidates',RecordTypeId=accountRec.id);
        Database.insert(client);
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 
        Account Clnt = new Account(IP_Business_Type__c='Catering', Name='Client Name', RecordTypeId=accountRec1.id);    
        Database.insert(Clnt);    
        
        RecordType accRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        Account acct = new Account(IP_Business_Type__c ='Catering', Name = 'Account Name', RecordTypeId=accRec.id, IP_BusinessIncorporationNumber__c='12345678');    
        Database.insert(acct);
                insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

        RecordType contRec1 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Contact cont = new Contact(FirstName = 'cFirstName', LastName = 'cLastName', AccountID = acct.Id, RecordTypeId = contRec1.Id,  MailingStreet = 'Mailing Street details', Salutation='Mr', MailingPostalCode='hgf 23', sirenum__National_Insurance__c='AA123456A', EEO_Gender__c='M', Birthdate =Date.newInstance(2000, 12, 9));            
        Database.insert(cont);
        
        RecordType condRec22 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact cond = new Contact(AccountID = acct.Id, RecordTypeId=condRec22.id, FirstName ='Manish', Salutation ='Mr', MailingCity='ggn',
                                   MailingCountry='india', MailingPostalCode='110092', MailingState='Haryana', LastName ='candidate',
                                   sirenum__National_Insurance__c='AA323232A', IP_CandidateIDlegacy__c='dsdsdsdd', MailingStreet='abc',
                                   P45_Requested__c=true, PayrollLeaver__c=null, Title = 'TestLastName', Initials__c = 'TestLastName',Email='test@abc.com',
                                   Birthdate = Date.valueOf('1990-02-20'), Phone = '9879879877', EEO_Gender__c = 'M');              
        Database.insert(cond);    
        
        
        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(name = 'MyClient', IP_StatusID__c = 1);                
        Database.insert(tgci);    
        
        sirenum__Site__c sites = new sirenum__Site__c( Name='my site', IP_InvoiceAddressCity__c='ballia', IP_InvoiceAddressStreet__c='street1',
                                                      sirenum__Operating_Company__c=acct.Id,  GlobalClientName__c = tgci.Id, IP_ClientIDLegacy__c='eww3',  IP_Clientinvoicename__c='invoice name',
                                                      IP_InvoiceAddressCountry__c='ind', IP_InvoiceAddressCounty__c='cnt', IP_InvoiceAddressPostcode__c='23d fdd',
                                                      IP_PublicSector__c='No', IP_PassClientToTempest__c=false, IP_ClientLastPassedToTempest__c=null, Credit_Status__c='Credit Approved',
                                                      IP_PassClientAddressToTempest__c=true);            
        Database.insert(sites);
        
        sirenum__ProActiveContract__c pac = new sirenum__ProActiveContract__c( Name='contact name', sirenum__Client__c=client.id,
                                                                              sirenum__Employee__c=cont.id, sirenum__AWR_Eligable__c=true);           
        Database.insert(pac);    
        
        sirenum__Rota__c rota = new sirenum__Rota__c( Name='Imapellam' );           
        Database.insert(rota);
        
        sirenum__Job_Type__c job = new sirenum__Job_Type__c( Impellam_Sector__c=rota.id,  Impellam_Core_Category__c='Administration -ADM', Impellam_Job_Category__c='Administrator -OA001');            
        Database.insert(job);
        
        sirenum__Team__c tm = new sirenum__Team__c( Name='job role', sirenum__Account__c=pac.id, sirenum__Job_Type__c=job.id, IP_OPWIPSRole__c = 'No');            
        Database.insert(tm);
               insert new IP_Shift_Template__c(name = '0000', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();    
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false); 
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = cond.Id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_StudentLoan__c ='Y';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c ='t1e';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        payprofile.IP_OkToSupply__c =1;
        payprofile.IP_AccountNumberSalted__c='12345678';
        payprofile.IP_SortCodeSalted__c='123456';
        payprofile.IP_PassToTempest__c=true;        
        insert payprofile;
        
        List<IP_PayProfile__C> Lst = new List<IP_PayProfile__C>();
        List<IP_PayProfile__C> ppLst = [Select Id,Name,IP_AccountNumber__c,IP_BankAccountName__c,IP_SortCode__c,IP_BuildingSocietyNumber__c,RecordType.Name,IP_AccountNumberSalted__c,IP_SortCodeSalted__c from IP_PayProfile__C where IP_PrimaryPayMethod__c=true and ID=:payprofile.Id];                              
        IP_PayProfile__c pp = [select Id,Name,IP_BankAccountName__c,IP_AccountNumber__c,IP_SortCode__c,IP_AccountNumberSalted__c,IP_SortCodeSalted__c from IP_PayProfile__c where id=:payprofile.Id];
        
        System.runAs(au) 
        {
            
            Test.startTest();
            for(IP_PayProfile__C p:ppLst){
                if(p.IP_SortCodeSalted__c!=null){
                    p.IP_SortCodeSalted__c = p.IP_SortCodeSalted__c.left(1) + '****' + p.IP_SortCodeSalted__c.right(1);
                }else{
                    p.IP_SortCodeSalted__c = '1****6';
                }
                if(p.IP_AccountNumberSalted__c!=null){
                    p.IP_AccountNumberSalted__c = p.IP_AccountNumberSalted__c.left(2) + '****' + p.IP_AccountNumberSalted__c.right(2);
                }else{
                    p.IP_AccountNumberSalted__c = '1****8';
                }               
            }    
            CPBankDetailController.getDefaultBankDetail();
            CPBankDetailController.getPaymentType();
            CPBankDetailController.BankDetail(payprofile.id);    
            
            String part;
            String inputId;
            
            part='ACCOUNTNAME';
            inputId='testname2'; 
            CPBankDetailController.savePP(pp.Id,inputId,part); 
            
            part='SORTCODE';
            inputId='123456';            	
            CPBankDetailController.savePP(pp.Id,inputId,part); 
            
            part='ACCOUNTNUMBER';
            inputId='12345678';   
            CPBankDetailController.savePP(pp.Id,inputId,part); 
            
            part='BUILDINGSOCIETYREF';
            inputId='1234';   
            CPBankDetailController.savePP(pp.Id,inputId,part);  

            Test.stopTest();
        }
        
    }
    
    @isTest
    static void get_bank_nigative(){
        
        User au = [select id , contactId from user where lastname = 'l4848' limit 1];
        User u = [select id , contactId from user where lastname = 'lnamemm' limit 1];
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];     
        Account client = new Account(Name='candidates',RecordTypeId=accountRec.id);
        Database.insert(client);
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 
        Account Clnt = new Account(IP_Business_Type__c='Catering', Name='Client Name', RecordTypeId=accountRec1.id);    
        Database.insert(Clnt);    
        
        RecordType accRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        Account acct = new Account(IP_Business_Type__c ='Catering', Name = 'Account Name', RecordTypeId=accRec.id, IP_BusinessIncorporationNumber__c='12345678');    
        Database.insert(acct);
                insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

        RecordType contRec1 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Contact cont = new Contact(FirstName = 'cFirstName', LastName = 'cLastName', AccountID = acct.Id, RecordTypeId = contRec1.Id,  MailingStreet = 'Mailing Street details', Salutation='Mr', MailingPostalCode='hgf 23', sirenum__National_Insurance__c='AA123456A', EEO_Gender__c='M', Birthdate =Date.newInstance(2000, 12, 9));            
        Database.insert(cont);
        
        RecordType condRec22 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact cond = new Contact(AccountID = acct.Id, RecordTypeId=condRec22.id, FirstName ='Manish', Salutation ='Mr', MailingCity='ggn',
                                   MailingCountry='india', MailingPostalCode='110092', MailingState='Haryana', LastName ='candidate',
                                   sirenum__National_Insurance__c='AA323232A', IP_CandidateIDlegacy__c='dsdsdsdd', MailingStreet='abc',
                                   P45_Requested__c=true, PayrollLeaver__c=null, Title = 'TestLastName', Initials__c = 'TestLastName',Email='test@abc.com',
                                   Birthdate = Date.valueOf('1990-02-20'), Phone = '9879879877', EEO_Gender__c = 'M' );              
        Database.insert(cond);    
        
               insert new IP_Shift_Template__c(name = '1069', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(name = 'MyClient', IP_StatusID__c = 1);                
        Database.insert(tgci);    
        
        sirenum__Site__c sites = new sirenum__Site__c( Name='my site', IP_InvoiceAddressCity__c='ballia', IP_InvoiceAddressStreet__c='street1',
                                                      sirenum__Operating_Company__c=acct.Id,  GlobalClientName__c = tgci.Id, IP_ClientIDLegacy__c='eww3',  IP_Clientinvoicename__c='invoice name',
                                                      IP_InvoiceAddressCountry__c='ind', IP_InvoiceAddressCounty__c='cnt', IP_InvoiceAddressPostcode__c='23d fdd',
                                                      IP_PublicSector__c='No', IP_PassClientToTempest__c=false, IP_ClientLastPassedToTempest__c=null, Credit_Status__c='Credit Approved',
                                                      IP_PassClientAddressToTempest__c=true);            
        Database.insert(sites);
        
        sirenum__ProActiveContract__c pac = new sirenum__ProActiveContract__c( Name='contact name', sirenum__Client__c=client.id,
                                                                              sirenum__Employee__c=cont.id, sirenum__AWR_Eligable__c=true);           
        Database.insert(pac);    
        
        sirenum__Rota__c rota = new sirenum__Rota__c( Name='Imapellam' );           
        Database.insert(rota);
        
        sirenum__Job_Type__c job = new sirenum__Job_Type__c( Impellam_Sector__c=rota.id,  Impellam_Core_Category__c='Administration -ADM', Impellam_Job_Category__c='Administrator -OA001');            
        Database.insert(job);
        
        sirenum__Team__c tm = new sirenum__Team__c( Name='job role', sirenum__Account__c=pac.id, sirenum__Job_Type__c=job.id, IP_OPWIPSRole__c = 'No');            
        Database.insert(tm);
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();    
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false); 
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = cond.Id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_StudentLoan__c ='Y';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c ='t1e';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        payprofile.IP_OkToSupply__c =1;
        payprofile.IP_AccountNumberSalted__c='';
        payprofile.IP_SortCodeSalted__c='';
        payprofile.IP_PassToTempest__c=true;
        insert payprofile;
        
        
        List<IP_PayProfile__C> Lst = new List<IP_PayProfile__C>();
        List<IP_PayProfile__C> ppLst = [Select Id,Name,IP_AccountNumber__c,IP_BankAccountName__c,IP_SortCode__c,IP_BuildingSocietyNumber__c,RecordType.Name,IP_AccountNumberSalted__c,IP_SortCodeSalted__c from IP_PayProfile__C where IP_PrimaryPayMethod__c=true and ID=:payprofile.Id];                              
        
        
        
        System.runAs(u) {
            Test.startTest();
            CPBankDetailController.getDefaultBankDetail();
            CPBankDetailController.getPaymentType();
            CPBankDetailController.BankDetail(payprofile.id);
            //savePP(payprofile.Id,inputId,String part); 
            for(IP_PayProfile__C p:ppLst){
                if(p.IP_SortCodeSalted__c!=null){
                    p.IP_SortCodeSalted__c = p.IP_SortCodeSalted__c.left(1) + '****' + p.IP_SortCodeSalted__c.right(1);
                }else{
                    p.IP_SortCodeSalted__c = '1****6';
                }
                if(p.IP_AccountNumberSalted__c!=null){
                    p.IP_AccountNumberSalted__c = p.IP_AccountNumberSalted__c.left(2) + '****' + p.IP_AccountNumberSalted__c.right(2);
                }else{
                    p.IP_AccountNumberSalted__c = '1****8';
                }
                Lst.add(p);    
            }   
            Test.stopTest();
        }
        
    }
}