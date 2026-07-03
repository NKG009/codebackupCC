@isTest
public class LaborCodeTriggerHandlerTest {
        
    @isTest
    public static void checkForContractLineItemsTest(){ 
        Account acc = new Account(Name = 'Test');
        insert acc;
        Product2 prod = new Product2(Name = 'Technician', ProductCode = 'TC', isActive = true);
        insert prod;
        System.debug(prod);
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update standardPricebook;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = prod.Id,UnitPrice = 100,IsActive = true,
                                               Base_Price__c = 100);
        Insert pbe;
        System.debug(standardPricebook);
        System.debug(pbe);
        ServiceContract sc = new ServiceContract(Name = 'SC Test', AccountId = acc.Id, Pricebook2Id = standardPricebook.id);
        insert sc; 
        ContractLineItem cli = new ContractLineItem(Quantity = 1, PricebookEntryId = pbe.id, UnitPrice = 100, ServiceContractId = sc.id);
        insert cli;
        System.debug(cli);
        WorkOrder wo = new WorkOrder(ServiceContractId = sc.Id);
        insert wo;
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId = wo.id, Status = 'New', Duration = 2,
                                                       EarliestStartTime = System.now(),FN_Template__c = 'Template 1',
                                                      DueDate = DateTime.newInstance(2224, 12, 12, 12, 00, 00));
        insert sa;
        Labor_Codes__c lc = new Labor_Codes__c(Quantity__c = 1, Service_Appointment__c = sa.Id,
                                               Product__c = '01tDT000009oAstYAE');
        try{
            Test.startTest();    
            insert lc;
            Test.stopTest();
        }catch(Exception e){
            System.debug(e.getMessage());
        }       
    }
}