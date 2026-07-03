@istest
public class BatchHeaderclasstest{

    @istest static void BatchHeaderclassmethod1(){
    
    
     Account acc =  TestDataFactory.createClients(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createContact(acc.id,1)[0];
        insert con;
         
         sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc.id;
          site.IP_ClientIDLegacy__c='123';
         insert site;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         
         insert contract;
         
         // to create job roll need to create job type and  Imappelam Sector
         
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
         
         insert jobroll;
         
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'test placment';
                 spleacement.sirenum__Contact__c = con.id;
                 spleacement.sirenum__Start_Date__c = system.today();
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 
                 insert spleacement;
                 
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Approved';
               batchheader.IP_State__c ='Closed';
               batchheader.IP_BatchType__c ='Client Name0 - testsite';
               
               insert batchheader;
               
        IP_BatchLine__c batchline = new IP_BatchLine__c();
        
                batchline.IP_BatchHeader__c = batchheader.id;
                batchline.IP_Status__c = 'Open';
                batchline.IP_State__c  = 'Open';
                batchline.IP_Number12d4Field1__c = 20;
                batchline.IP_TextField9__c = 'Standard Rate /P1';
                batchline.IP_CurrencyField1__c = 25;
                batchline.IP_CurrencyField2__c = 30;
                batchline.IP_DateField1__c     = system.today();
                batchline.IP_TextField3__c     = 'cFirstName cLastName';
                batchline.IP_TextField4__c     = 'testjobroll';
 
                insert batchline;
                
                 
                
                
                
        Test.startTest();

            BatchHeaderclass obj = new BatchHeaderclass();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
                
                  
    
    }

     @istest static void BatchHeaderclassmethod2(){
    
    
    Account acc =  TestDataFactory.createClients(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createContact(acc.id,1)[0];
        insert con;
         
         
    //   Contact con1 = TestDataFactory.createContact(acc.id,1)[0];
     //   insert con1;
         
         sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc.id;
         site.IP_ClientIDLegacy__c='123';
         insert site;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         
         insert contract;
         
         // to create job roll need to create job type and  Imappelam Sector
         
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
         
         insert jobroll;
         
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'test placment';
                 spleacement.sirenum__Contact__c = con.id;
                 spleacement.sirenum__Start_Date__c = system.today();
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 
                 insert spleacement;
                 
        Batch_header__c batchheader = new Batch_header__c();
        
                batchheader.IP_Status__c = 'Approved';
               batchheader.IP_State__c ='Closed';
               batchheader.IP_BatchType__c ='Client Name0 - testsite';
               
               insert batchheader;
               
        IP_BatchLine__c batchline = new IP_BatchLine__c();
        
                batchline.IP_BatchHeader__c = batchheader.id;
                batchline.IP_Status__c = 'open';
                batchline.IP_State__c  = 'open';
                batchline.IP_Number12d4Field1__c = 20;
                batchline.IP_TextField9__c = 'Standard Rate /P1';
                batchline.IP_CurrencyField1__c = 25;
                batchline.IP_CurrencyField2__c = 30;
                batchline.IP_DateField1__c     = system.today();
                batchline.IP_TextField3__c     = 'cFirstName cLastName';
                batchline.IP_TextField4__c     = 'testjobroll';
 
                insert batchline;
                
                IP_BatchLine__c batchline1 = new IP_BatchLine__c();
        
                batchline1.IP_BatchHeader__c = batchheader.id;
                batchline1.IP_Status__c = 'open';
                batchline1.IP_State__c  = 'open';
                batchline1.IP_Number12d4Field1__c = 20;
                batchline1.IP_TextField9__c = 'Standard Rate /P1';
                batchline1.IP_CurrencyField1__c = 25;
                batchline1.IP_CurrencyField2__c = 30;
                batchline1.IP_DateField1__c     = system.today();
                batchline1.IP_TextField3__c     = 'cFirstName cLastName';
                batchline1.IP_TextField4__c     = 'testjobroll123';
 
                insert batchline1;
                
                IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_Number12d4Field1__c = 20;
                batchline2.IP_TextField9__c = 'Standard Rate /P1';
                batchline2.IP_CurrencyField1__c = 25;
                batchline2.IP_CurrencyField2__c = 30;
                batchline2.IP_DateField1__c     = system.today();
                batchline2.IP_TextField3__c     = 'test12345';
                batchline2.IP_TextField4__c     = 'testjobroll123';
 
                insert batchline2;
                
                 IP_BatchLine__c batchline3 = new IP_BatchLine__c();
        
                batchline3.IP_BatchHeader__c = batchheader.id;
                batchline3.IP_Status__c = 'open';
                batchline3.IP_State__c  = 'open';
                batchline3.IP_Number12d4Field1__c = 20;
                batchline3.IP_TextField9__c = 'Standard Rate /P1';
                batchline3.IP_CurrencyField1__c = 25;
                batchline3.IP_CurrencyField2__c = 30;
               // batchline3.IP_DateField1__c     = system.today();
                batchline3.IP_TextField3__c     = 'cFirstName cLastName';
                batchline3.IP_TextField4__c     = 'testjobroll';
 
                insert batchline3; 
                
               
                
        Test.startTest();

            BatchHeaderclass obj1 = new BatchHeaderclass();
            DataBase.executeBatch(obj1); 
            
        Test.stopTest();
                
                  
    
    }
    
      @istest static void BatchHeaderclassmethod3(){
    
    
     Account acc =  TestDataFactory.createClients(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createContact(acc.id,1)[0];
        insert con;
         
         sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc.id;
          site.IP_ClientIDLegacy__c='123';
         insert site;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         
         insert contract;
         
         // to create job roll need to create job type and  Imappelam Sector
         
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
         
         insert jobroll;
         
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'test placment';
                 spleacement.sirenum__Contact__c = con.id;
                 spleacement.sirenum__Start_Date__c = system.today();
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 
                 insert spleacement;
                 
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Approved';
               batchheader.IP_State__c ='Closed';
               batchheader.IP_BatchType__c ='Client Name0 - testsite';
               
               insert batchheader;
               
        IP_BatchLine__c batchline = new IP_BatchLine__c();
        
                batchline.IP_BatchHeader__c = batchheader.id;
                batchline.IP_Status__c = 'Open';
                batchline.IP_State__c  = 'Open';
             
                batchline.IP_TextField9__c = 'Standard Rate /P1';
              
                batchline.IP_CurrencyField2__c = 30;
                batchline.IP_DateField1__c     = system.today();
                batchline.IP_TextField3__c     = 'cFirstName cLastName';
                batchline.IP_TextField4__c     = 'testjobroll';
 
                insert batchline;
                
                 
                
                
                
        Test.startTest();

            BatchHeaderclass obj = new BatchHeaderclass();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
                
                  
    
    }


}