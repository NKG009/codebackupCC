@isTest
public with sharing class QuickbooksServicesTest {

    @TestSetup
    static void makeData(){
        
        QBO_Quickbooks_App_Info__c config = QBO_Quickbooks_App_Info__c.getOrgDefaults();
        config.QBO_Enable_Quickbooks__c = true;
        config.QBO_Client_ID__c = '823042834345';
        config.QBO_Client_Secret__c = '823042834345';
        upsert config;
       
		QBO_QuickBook_Auth_Info__c qboAuthInfoRec = new QBO_QuickBook_Auth_Info__c();
       	qboAuthInfoRec.QBO_Refresh_Token__c = qboAuthInfoRec.QBO_Access_Token__c = '273649827304720';
       	insert qboAuthInfoRec;
        RecursiveTriggerCheck.runBoxAutomations = true;
        RecursiveTriggerCheck.firstcall=true;
        RecursiveTriggerCheck.firstcallEternevaTriggerAfterUpdate=true;
        RecursiveTriggerCheck.firstcallEternevaTriggerBeforeUpdate=true;
        RecursiveTriggerCheck.firstcallOpportunityTrigger=true;
        //QBO_ConstantUtilityClass.forceStopTrigger = true;
        //RecursiveTriggerCheck.firstcallOrderedProduct=true;
        //RecursiveTriggerCheck.firstcallOrderTrigger=true;
        
    
        TestUtility.createStorage();
        Id householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                                                            .get('Household')
                                                            .getRecordTypeId();
        Id partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                                                            .get('Partner')
                                                            .getRecordTypeId();

        List<Vendor_Product__c> vendorProducts = TestUtility.createVendorProducts();
        insert vendorProducts;

        Inauguration_Team__c inaugurationTeam = new Inauguration_Team__c(Sales_Consultant__c = UserInfo.getUserId(),
                                                                            CX_Name__c = UserInfo.getUserId()
                                                                            );
        insert inaugurationTeam;

        Account acc = new Account(
            Name = 'TestAccount',
            RecordTypeId = householdRecordTypeId
        );
        Account acc1 = new Account(
            Name = 'Eterneva',
            RecordTypeId = partnerRecordTypeId
        );
        Account acc2 = new Account(
            Name = 'Partner',
            RecordTypeId = partnerRecordTypeId
        );
        Account acc3 = new Account(
            Name = 'Sedkrist',
            RecordTypeId = partnerRecordTypeId
        );
        insert new List<Account>{acc, acc1, acc2, acc3};

        List<Account> partnerAccounts = new List<Account>{acc1, acc2, acc3};
        List<String> sizes = new List<String>{'.1 to .19','.7 to .89', '1.00 to 1.24'};
        List<String> colors = new List<String>{'Blue','Red', 'Colorless'};
        List<Integer> stepDoneEffectives = new List<Integer>{2, 4, 6};
        List<Vendor_Lead_Time__c> vlts = TestUtility.createVendorLeadTimes(partnerAccounts, sizes, colors, stepDoneEffectives);
        insert vlts;


        Id householdMemberRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                                                            .get('Household_Member')
                                                            .getRecordTypeId();
        Contact customer = new Contact(
            FirstName = 'Test First',
            LastName = 'Test Last',
            AccountId = acc.Id,
            email='zzz@test.com',
            MobilePhone='094884994',
            Phone='23456765432',
            RecordTypeId = householdMemberRecordTypeId,
            OtherState = 'CO',
            OtherPostalCode = '80003'
        );

        insert customer;

        Opportunity opp = TestUtility.createOpportunity('Test Opp', 'Draft');
        opp.AccountId = acc.Id;
        opp.StageName = 'Sales Qualified';
        opp.Billing_State__c = 'CO';
        opp.Billing_Zip_Code__c = '80003';
        opp.Minimum_Payment_Collected__c = true;
        // opp.Customer_Agreement_Signed_Received__c = true;
        // opp.Payment_Processing_Flow_Complete__c = true;
        // opp.Closed_Won_Flow_Complete__c = true;
        insert opp;

        Product2 prod = new Product2(
            Name = 'Welcome Kit',
            MSRP__c = 100.00,
            IsActive = True,
            Description='xys'
           // QBO_Income_Account_Ref__c='56'
        );

        Product2 prod1 = new Product2(
            Name = 'Diamond1',
            Size__c = '.1 to .19',
            Color__c = 'Blue',
            MSRP__c = 10000.00,
            IsActive = True
        );

        insert new List<Product2>{prod};

        Id wkOppRecordTypeId = Schema.SObjectType.Eterneva_Product__c.getRecordTypeInfosByDeveloperName()
                                                                        .get('Welcome_Kit').getRecordTypeId();

        Eterneva_Product__c etProdWK = new Eterneva_Product__c(
                                                                Opportunity__c = opp.Id,
                                                                Product__c = prod.Id,
                                                                Quantity__c = 1,
                                                                RecordTypeId  = wkOppRecordTypeId,
                                                                Ready_to_Ship__c = true,
                                                                Discount_Code__c = '',
                                                                Tax__c = 0,
                                                                Welcome_Video_URL__c ='',
                                                                Tin_Label__c = 'Test tin label',
                                                                CZ_Selections__c = '',
                                                                Communication_Contact__c = customer.Id,
                                                                Billing_Contact__c = customer.Id,
                                                                Shipping_Contact__c = customer.Id,
                                                                Kit_Phone__c = '+1 (777) 666-5555',
                                                                Email__c = 'test@email.com',
                                                                Address__c = '11 Main Rd',
                                                                Address_2__c = '',
                                                                City__c = 'Austin',
                                                                State__c  = 'TX',
                                                                Zipcode__c = '12121-2222',
                                                                Country__c = 'USA',
                                                                Shipping_Speed__c = 'Standard',
                                                                Shipping_Carrier__c = ''
                                                            );
        Id diamondsTypeId = Schema.SObjectType.Eterneva_Product__c.getRecordTypeInfosByDeveloperName()
                                                                        .get('Diamonds').getRecordTypeId();
        insert etProdWK;
        
        Eterneva_Product__c etProd = new Eterneva_Product__c(
            Opportunity__c = opp.Id,
            Product__c = prod1.Id,
            Quantity__c = 1,
            Diamond_Cut__c = 'Emerald',
            Diamond_Color__c = 'Blue',
            Diamond_Size__c = '.1 to .19',
            RecordTypeId = diamondsTypeId,
            Communication_Contact__c = customer.Id, 
            Shipping_Contact__c = customer.Id, 
            Billing_Contact__c = customer.Id,
            Carbon_Id__c = etProdWK.Id
        );
        insert etProd;

       // List<Product2> products = TestUtility.createWorkOrderItemProducts();
       // insert products;

        Id orderRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
                                                            .get('Eternal_Diamond')
                                                            .getRecordTypeId();
        Order newOrder = new Order(
            BillToContactId = customer.Id,
            EffectiveDate = System.today(),
            Status = 'Draft',
            Order_Status__c = 'Draft',
            AccountId = opp.AccountId,
            OpportunityId = opp.Id,
            ShippingStreet = opp.Shipping_Street__c,
            ShippingCity = opp.Shipping_City__c,
            ShippingState = opp.Shipping_State__c,
            ShippingPostalCode = opp.Shipping_Zip_Code__c,
            ShippingCountry = opp.Shipping_Country__c,
            BillingStreet = opp.Billing_Street__c,
            BillingCity = opp.Billing_City__c,
            BillingState = opp.Billing_State__c,
            BillingPostalCode = opp.Billing_Zip_Code__c,
            BillingCountry = opp.Billing_Country__c,
            Billing_Contact_Name__c = opp.Billing_Contact_Name__c,
            Billing_Contact_Email__c = opp.Billing_Contact_Email__c,
            Diamond_Engraving_1__c = opp.Diamond_Engraving_1__c,
            Diamond_Engraving_2__c = opp.Diamond_Engraving_2__c,
            Diamond_Engraving_3__c = opp.Diamond_Engraving_3__c,
            Diamond_Engraving_4__c = opp.Diamond_Engraving_4__c,
            Contingent_Beneficiary_Name__c = opp.Contingent_Beneficiary_Name__c,
            Contingent_Beneficiary_Address__c = opp.Contingent_Beneficiary_Address__c,
            RecordTypeId = orderRecordType
        );
        insert newOrder;

        List<Id> selectedSlotsIds = StorageEngineInvocable.getAvailableSlots('Ashes', 1);

        Id welcomeKitOrderProdRecordTypeId = Schema.SObjectType.ET_Order_Product__c.getRecordTypeInfosByDeveloperName().get('Welcome_Kit').getRecordTypeId();
        ET_Order_Product__c newOrderProdWK = new ET_Order_Product__c(
            Ready_to_Ship__c = true,
            Eterneva_Product__c = etProdWK.Id,
            Order__c = newOrder.Id,
            Discount_Code__c = etProdWK.Discount_Code__c,
            Sale_Price__c = etProdWK.Sale_Price__c,
            Tax__c = etProdWK.Tax__c,
            Welcome_Video_URL__c = etProdWK.Welcome_Video_URL__c,
            Tin_Label__c = etProdWK.Tin_Label__c,
            CZ_Selections__c = etProdWK.CZ_Selections__c,
            Communication_Contact__c = etProdWK.Communication_Contact__c,
            Billing_Contact__c = etProdWK.Billing_Contact__c,
            Shipping_Contact__c = etProdWK.Shipping_Contact__c,
            Kit_Phone__c = etProdWK.Kit_Phone__c,
            Email__c = etProdWK.Email__c,
            Address__c = etProdWK.Address__c,
            Address_2__c = etProdWK.Address_2__c,
            City__c = etProdWK.City__c,
            State__c = etProdWK.State__c,
            Zipcode__c = etProdWK.Zipcode__c,
            Country__c = etProdWK.Country__c,
            Shipping_Speed__c = etProdWK.Shipping_Speed__c,
            Shipping_Carrier__c = etProdWK.Shipping_Carrier__c,
            Product__c = etProdWK.Product__c,
            RecordTypeId = welcomeKitOrderProdRecordTypeId,
            Related_Account__c = etProdWK.Opportunity__r.AccountId,
            Carbon_Id__c = etProdWK.Id,
            Tin_Id__c = etProdWK.Id + '1',
            Customer_Name_s__c = 'Communications Contact',
            Current_Materials_Location__c = selectedSlotsIds[0],
            Current_Materials_Storage__c = 'Ashes test storage slot'
        );
        insert newOrderProdWK;

        
        Id welcomeKitWorkOrderRecordTypeId = Schema.SObjectType.Work_Order__c.getRecordTypeInfosByDeveloperName().get('Kits').getRecordTypeId();
        Work_Order__c newKitsWorkOrder = new Work_Order__c(
                                                        Carbon_Id__c = newOrderProdWK.Carbon_Id__c,
                                                        Tin_Id__c = newOrderProdWK.Tin_Id__c,
                                                        RecordTypeId = welcomeKitWorkOrderRecordTypeId,
                                                        Stage__c = 'Kit Assembly',
                                                        Start_Date__c = Date.today(),
                                                        Start_Date_Time__c = Datetime.now(),
                                                        Opportunity__c = opp.Id,
                                                        Order__c = newOrder.Id,
                                                        Related_Account__c = newOrder.AccountId,
                                                        Current_Materials_Location__c = selectedSlotsIds[0],
                                                        Current_Materials_Storage__c = 'Ashes test storage slot'
                                                        );
        insert newKitsWorkOrder;
        Storage_Slot__c stSL = new Storage_Slot__c(Id = selectedSlotsIds[0],
                                                    Ordered_Product__c = newOrderProdWK.Id
                                                    );
        update stSL;

        Work_Order_Product__c newWorkOrderProd = new Work_Order_Product__c(
                                                        Ordered_Product__c = newOrderProdWK.Id,
                                                        Carbon_Id__c = newOrderProdWK.Carbon_Id__c,
                                                        Tin_Id__c = newOrderProdWK.Tin_Id__c,
                                                        Order__c = newOrder.Id,
                                                        Work_Order__c = newKitsWorkOrder.Id
                                                        );
        insert newWorkOrderProd;

        Id diamondETOrderProdRecordTypeId = Schema.SObjectType.ET_Order_Product__c.getRecordTypeInfosByDeveloperName().get('Diamond').getRecordTypeId();
        ET_Order_Product__c newOrderProdDiamond = new ET_Order_Product__c(
            Number_of_Diamonds__c = etProd.Quantity__c,
            Sale_Price__c = etProd.Sale_Price__c,
            Stage__c = 'Final Sales Verification',
            Order__c = newOrder.Id,
            Imported_from_Track_Via__c = false,
            Order_Created__c = System.today(),
            Order_Date__c = System.today(),
            // Sold_By__c = etProd.Opportunity__r.OwnerId,
            Eterneva_Product__c = etProd.Id,
            Diamond_Cut__c = etProd.Diamond_Cut__c,
            Diamond_Color__c = etProd.Diamond_Color__c,
            Diamond_Size__c = etProd.Diamond_Size__c,
            Product__c = etProd.Product__c,
            RecordTypeId = diamondETOrderProdRecordTypeId,
            Related_Account__c = etProd.Opportunity__r.AccountId,
            Communication_Contact__c = etProd.Communication_Contact__c, 
            Shipping_Contact__c = etProd.Shipping_Contact__c, 
            Billing_Contact__c = etProd.Billing_Contact__c,
            Carbon_Id__c = etProd.Carbon_Id__c,
            Tin_Id__c = etProd.Tin_Id__c
        );

        insert newOrderProdDiamond;
        
    }    
    
    @isTest
    public static void testmethod1 () {
        Id diamondId = getIdByDeveloperName('Diamond');
        Id welcomeKId = getIdByDeveloperName('Welcome_Kit');
        Id settingId = getIdByDeveloperName('Setting');
        Id spinOffId = getIdByDeveloperName('Spin_off_Diamond');        
        Id order1 = [SELECT Id FROM Order LIMIT 1].Id;
        
        ET_Order_Product__c setting1 = new ET_Order_Product__c(Order__c = order1, RecordTypeId = settingId);
        ET_Order_Product__c setting2 = new ET_Order_Product__c(Order__c = order1, RecordTypeId = settingId);
        ET_Order_Product__c spinOff1 = new ET_Order_Product__c(Order__c = order1, RecordTypeId = spinOffId);
		insert new List<ET_Order_Product__c>{setting1, setting2, spinOff1}; 
            
        List<ET_Order_Product__c> oldDiamonds = [SELECT Id FROM ET_Order_Product__c WHERE RecordTypeId = :diamondId AND Order__c = :order1];
        List<ET_Order_Product__c> oldWelcomeKits = [SELECT Id FROM ET_Order_Product__c WHERE RecordTypeId = :welcomeKId AND Order__c = :order1];
        List<ET_Order_Product__c> oldSettings = [SELECT Id FROM ET_Order_Product__c WHERE RecordTypeId = :settingId AND Order__c = :order1];
        List<ET_Order_Product__c> oldSpinOffs = [SELECT Id FROM ET_Order_Product__c WHERE RecordTypeId = :spinOffId AND Order__c = :order1];        
        
        ET_Order_Product__c diamond = new ET_Order_Product__c(Order__c = order1, RecordTypeId = diamondId, Carbon_Id__c = 'a003h000ATC6SAAX');
        ET_Order_Product__c welcomeKit = new ET_Order_Product__c(Order__c = order1, RecordTypeId = welcomeKId, Carbon_Id__c = 'a003h000ATC6SAAX');
        ET_Order_Product__c setting = new ET_Order_Product__c(Order__c = order1, RecordTypeId = settingId);
        ET_Order_Product__c spinOff = new ET_Order_Product__c(Order__c = order1, RecordTypeId = spinOffId);       
        
        System.assertEquals(null, diamond.Eterneva_OP_Id__c);
        System.assertEquals(null, welcomeKit.Eterneva_OP_Id__c);
        System.assertEquals(null, setting.Eterneva_OP_Id__c);
        System.assertEquals(null, spinOff.Eterneva_OP_Id__c); 
         
        
        
		
        
       
         set<id> prodset = new set<id>();
        id prdid=[select id from Product2 where Name='Welcome Kit' ].id;
        prodset.add(prdid);
        system.debug('testprodset====='+prodset);
        
        Test.startTest();
        insert new List<ET_Order_Product__c>{diamond, welcomeKit, setting, spinOff};
            Test.setMock(HttpCalloutMock.class, new QuickBooksHttpCalloutMock());
            //QuickbooksSendRequestAndRecieveResponse.SendRequest('{"test":"test"}','Invoice','POST');
        	//QuickbooksCustomerService.QBOcreatecustomer(idsets);
        	QuickbooksProductService.createiteminQBO(prodset);
        	QuickbooksProductService.NewitemcreationinQBO(prodset);
			Test.stopTest();        
        
    }
    
        @isTest
    public static void testmethod2 () {
        set<id> idsets = new set<id>();
        id ordid=[select id from contact where FirstName='Test First' ].id;
        idsets.add(ordid);
        
        system.debug('testidsets====='+idsets);//Welcome Kit
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new QuickBooksHttpCalloutMock());
        	QuickbooksCustomerService.QBOcreatecustomer(idsets);
			Test.stopTest();     
        
    }
      
     @isTest
    public static void testmethod4 () {
        set<id> idsets = new set<id>();
        id ordid=[select id from order where BillToContact.FirstName='Test First' ].id;
        idsets.add(ordid);
        
        system.debug('testidsets2====='+idsets);//Welcome Kit
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new QuickBooksHttpCalloutMock());
        	QuickbooksInvoiceService.createUpdateInvoicesInQBO(idsets);
            QBOWelcomeKitInvoiceSync.createUpdateInvoicesInQBO(idsets);
			Test.stopTest();     
        
    }


        
    private static Id getIdByDeveloperName (String DeveloperName) {
    	return Schema.SObjectType.ET_Order_Product__c.getRecordTypeInfosByDeveloperName().get(DeveloperName).getRecordTypeId();
    }
        @isTest
    public static void recalculateTaxOnOppItemDeleteTest() {
        ET_Order_Product__c orderedProduct = [SELECT Id
                                                FROM ET_Order_Product__c
                                                ][0];
        Work_Order_Product__c wop = [SELECT Id
                                        FROM Work_Order_Product__c
                                        WHERE Ordered_Product__c = :orderedProduct.Id
                                        ][0];

        delete wop;
        
        Test.startTest();
        delete orderedProduct;
        Test.stopTest();
        // Assertion not present since tax will not be calculated during testing.
    }

	 @isTest
    public static void runReadyForGrowthAutomations() {
        ET_Order_Product__c orderedProduct = [SELECT Id,
                                              		 Stage__c
                                                FROM ET_Order_Product__c
                                                WHERE Stage__c != 'Regrowth'
                                                ][0];
        
        orderedProduct.Stage__c = 'Regrowth';
        orderedProduct.Automatic_Regrowth__c = false;

        Test.startTest();
        update orderedProduct;
        Test.stopTest();
    }
    
    
    @isTest
    public static void Productgettest () {
        set<id> prodset = new set<id>();
        id prdid=[select id from Product2 where Name='Welcome Kit' ].id;
        prodset.add(prdid);
        system.debug('testprodsetProductgettest====='+prodset);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new QBOGetRequestMockGenerator());
       QuickbooksProductService.QueryitemQBO(prodset);
        test.stopTest();
    }
    
 public class QBOGetRequestMockGenerator implements HttpCalloutMock{
    
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint().containsIgnoreCase('tokens'))
            response.setBody('{"x_refresh_token_expires_in":8726400,"refresh_token":"AB11602094975KiN2qJNm5axzgWeddwdldTeqcdSbXd4lk1XR9","token_type":"bearer","access_token":"abcdxyz","expires_in":-100}');
        else if(request.getEndpoint().containsIgnoreCase('item'))
            response.setBody('{"QueryResponse":{"startPosition":1,"Item":[{"FullyQualifiedName":"Concrete","domain":"QBO","Name":"Concrete","TrackQtyOnHand":false,"Type":"Service","PurchaseCost":0,"IncomeAccountRef":{"name":"LandscapingServices:JobMaterials:FountainsandGardenLighting","value":"48"},"Taxable":true,"MetaData":{"CreateTime":"2014-09-16T10:36:03-07:00","LastUpdatedTime":"2014-09-19T12:47:47-07:00"},"sparse":false,"Active":true,"SyncToken":"1","UnitPrice":0,"Id":"159","Description":"Concreteforfountaininstallation"}],"maxResults":2},"time":"2015-04-22T11:04:34.194-07:00"}');
       response.setStatusCode(200);
        return response; 
    }
}

   

    
}