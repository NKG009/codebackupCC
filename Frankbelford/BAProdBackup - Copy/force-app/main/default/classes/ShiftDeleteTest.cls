@isTest
public class ShiftDeleteTest {

    static testmethod void ShiftMethod(){
               
        Test.startTest();

        //Profile profileId = [SELECT Id FROM Profile where name='System Administrator'];
        Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
        
        // Account act = TestDataFactory.createClients(1)[0];
        //  insert act;
        
        Contact con = TestDataFactory.createContact(acc.id, 1)[0]; 
        insert con;
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient';
        createtopaz.IP_StatusID__c = 1;
        insert createtopaz;
        
        User user = new User();
        DateTime dt = DateTime.newInstance(2017, 6, 23, 3, 3, 3);
        Long gettime = dt.getTime();
        user.LastName = 'Virmani';
        user.FirstName='Swati';
        user.Alias = 'svir';
        user.Email = 'swati.vir@outlook.com';
        user.Username = 'Email'+gettime+'@js.com';
        user.ProfileId = '00e0Y000000viGi'; 
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8'; 
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='1287';
         user.IP_TempestId__c='1287';
        user.IP_TempestDivision__c='NTS';
        user.Department='1287';
        user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c ='QAWWSED12';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= createtopaz.Id;
        site.IP_PassClientToTempest__c=true;
        site.IP_ClientLastPassedToTempest__c=null;
        site.IP_PassClientAddressToTempest__c=true;
        site.OwnerId=user.id;
        insert site;
        system.debug('Value in site'+ site);
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        
        contract.Name = 'test contract';
        contract.sirenum__Client__c   = acc.id;
        contract.sirenum__Employee__c = con.id;
        insert contract;
        
        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;
        
        
        
        sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name = 'testjobtype';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c ='Administrator -OA001';
        
        insert jobtype;
        
        sirenum__Team__c jobroll = new sirenum__Team__c();
        
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract.id; 
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.IP_OPWIPSRole__c='No';
        jobroll.sirenum__Rota__c=sector.id;
        insert jobroll;
        
        
            
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        
        spleacement.Name = 'test placement';
        spleacement.sirenum__Contact__c = con.id;
        spleacement.sirenum__Start_Date__c = system.today();
        spleacement.sirenum__Site__c= site.Id;
        spleacement.IP_Consultant1LookupSplitShare__c= user.Id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        
        
       // spleacement.IP_Consultant1IDnumberSplitShare__c=[Select IP_TempestDepartment__c from user where id= user.id];
        // spleacement.IP_PayMethod__c=payprofile.Id;
        insert spleacement;
        system.debug('Value in spleacement'+ spleacement);
        
        sirenum__Shift__c sshift =new sirenum__Shift__c();
        sshift.sirenum__Placement__c = spleacement.id;
        sshift.sirenum__Team__c = jobroll.id;
        sshift.sirenum__Site__c=site.id;
        sshift.sirenum__Contact__c=con.id;
        // sshift.sirenum__Cancelled__c=true;
        insert sshift;
        system.debug('value in shift'+sshift);
        
        sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
        createtimeshsheet.sirenum__Client__c= acc.id;
        createtimeshsheet.sirenum__Worker__c=con.id;
        createtimeshsheet.sirenum__Team__c=jobroll.id;
        createtimeshsheet.sirenum__Site__c=site.id;
        createtimeshsheet.sirenum__Week_Ending__c=system.today();
        createtimeshsheet.sirenum__Non_Taxed_Expenses__c=34.2;
        createtimeshsheet.sirenum__Taxed_Expenses__c=22.2;
        createtimeshsheet.sirenum__Non_Taxed_Deductions__c=22.0;
        createtimeshsheet.sirenum__Taxed_Deductions__c=22.1;
        insert createtimeshsheet;
        system.debug('Value in createtimeshsheet'+ createtimeshsheet);
        
        sirenum__Timesheet_Line__c tsl = new sirenum__Timesheet_Line__c();
        tsl.sirenum__Timesheet__c=createtimeshsheet.Id;
        tsl.sirenum__Shift__c=sshift.id;
        tsl.sirenum__Charge__c =12;
        tsl.sirenum__Rate__c=10;
        tsl.IP_RateCodes__c='Standard Hours /P1';
        tsl.IP_PassToTempest__c=true;
        tsl.sirenum__Hours__c=2;
        insert tsl;
        system.debug('Value in tsl'+ tsl);
        
        for(sirenum__Shift__c sht:[Select Id,sirenum__Placement__c , (Select Id,IP_PassToTempest__c, IP_LastPassedToTempest__c from sirenum__Timesheet_Lines__r where IP_PassToTempest__c =true or IP_LastPassedToTempest__c!=null)
                                   from sirenum__Shift__c where id =:sshift.id ]){
                                       
                                       if(sht.Id!=null ||sht.Id!='' )
                                       {
                                           
                                           for(sirenum__Timesheet_Line__c tl:sht.sirenum__Timesheet_Lines__r)
                                           { 
                                               if((tsl.IP_PassToTempest__c==true || tsl.IP_LastPassedToTempest__c!=null) && sshift.sirenum__Placement__c!=null)
                                               {
                                                   try{
                                                       delete sht;
                                                   }Catch (DMLException e){
                                                       
                                                       System.assert(e.getMessage().contains('You can not delete shift associated with Placement and corresponding Timesheetline Pass to tempest is true'), 'You can not delete shift associated with Placement and corresponding Timesheetline Pass to tempest is true');
                                                       
                                                   }
                                                   
                                               }  
                                           }
                                           
                                       }
                                   }
        
        Test.stopTest();
        
    }
}