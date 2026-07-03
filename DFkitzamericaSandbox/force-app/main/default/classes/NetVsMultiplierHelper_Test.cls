/****************************
 * Name : NetVsMultiplierHelper_Test
 * Description : Test Class to cover NetVsMultiplierHelper class which automate the population of multiplier or net price on each line item based on Net vs multiplier pricing logic.
 ****************************/

@isTest
public class NetVsMultiplierHelper_Test {  
  
    @isTest
    static void testMethod1(){
        
        List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();

        //configLineItemList = [Select Id, Name, Apttus_Config2__BillToAccountId__c, Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Material_Num__c, Apttus_Config2__PriceListId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c, Apttus_Config2__ListPrice__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c,Apttus_Config2__BasePriceOverride__c, APTS_Multiplier__c From Apttus_Config2__LineItem__c Where Apttus_Config2__ConfigurationId__c = 'a4Gc00000005xnm'];

         Account acc1 = Testutility.createAccount();
        acc1.AccountNumber = 'RR282';
        insert acc1;

        Account acc2 = Testutility.createAccount();
        acc2.Name = 'test 2';
        acc2.ParentId = acc1.Id;
        acc2.AccountNumber = 'RR82';
        insert acc2;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;
        proposal1.Apttus_QPConfig__ShipToAccountId__c = acc2.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        productConfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
        
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc2.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        lineItem1.APTS_Override_Multiplier__c = 1;
        lineItem1.Apttus_Config2__PricingStatus__c = 'Complete';

        System.debug('BEFORE INSERT *****lineItem1.Apttus_Config2__PricingDate__c---'+lineItem1.Apttus_Config2__PricingDate__c);

        insert lineItem1;

        System.debug('OLD *****lineItem1.Apttus_Config2__PricingDate__c---'+lineItem1.Apttus_Config2__PricingDate__c);

        lineItem1 = [select Id, APTS_Multiplier__c, Apttus_Config2__ListPrice__c, APTS_Override_Multiplier__c, Apttus_Config2__BasePriceOverride__c,
                     Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c, 
                     Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                     Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__ShipToAccountId__c,
                     Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineNumber__c,  Apttus_Config2__PriceListId__c, APTS_Material_Num__c,
                     Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c,
                     Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c 
                     from Apttus_Config2__LineItem__c Where Id = :lineItem1.Id];

        System.debug('lineItem1.Apttus_Config2__PricingDate__c---'+lineItem1.Apttus_Config2__PricingDate__c);

        lineItem1.Apttus_Config2__PricingDate__c = System.now();
        
        configLineItemList.add(lineItem1);

        APTS_ContractualPriceMultiplier__c priceMultiplier =  Testutility.createContractualPriceMultiplier();
        priceMultiplier.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier.APTS_PriceList__c = priceList1.Id;
        priceMultiplier.APTS_Ship_To_Account__c = acc2.Id;
        priceMultiplier.APTS_Product_Name__c = prod1.Id;
        priceMultiplier.APTS_Invalid__c = false;

        insert priceMultiplier;


        APTS_ContractualPriceMultiplier__c priceMultiplier2 =  Testutility.createContractualPriceMultiplier();
        priceMultiplier2.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier2.APTS_PriceList__c = null;
        priceMultiplier2.APTS_Ship_To_Account__c = acc2.Id;
        priceMultiplier2.APTS_Product_Name__c = prod1.Id;
        priceMultiplier2.APTS_Invalid__c = false;
        priceMultiplier.APTS_Sold_To_Acct_Number__c = 'RR282';
        priceMultiplier.APTS_Ship_To_Acct_Number__c = 'RR82';

        insert priceMultiplier2;

        list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
        
        ContractualPriceMultiplierlst.add(priceMultiplier);
        ContractualPriceMultiplierlst.add(priceMultiplier2);       
        

        //insert configLineItemList;

        NetVsMultiplierHelper helperClass = new NetVsMultiplierHelper();
        helperClass.getMultiplierOrNetPrice(configLineItemList,ContractualPriceMultiplierlst);
    }


    /**
     * Method to check condition 2.
     * 
     * If ( 
            ContractualPriceMultiplier.APTS_Ship_To_Account__c == null && 
            ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
            ContractualPriceMultiplier.APTS_Contract_Price__c != null
        )
     * 
     **/

    @isTest
    static void testMethod2(){
        
        List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();

         Account acc1 = Testutility.createAccount();
        acc1.AccountNumber = 'RR282';
        insert acc1;
        
        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        productConfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc1.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        lineItem1.APTS_Override_Multiplier__c = 0;
		lineItem1.Apttus_Config2__PricingStatus__c = 'Complete';
        
        insert lineItem1;

        lineItem1 = [select Id, APTS_Multiplier__c, Apttus_Config2__ListPrice__c, APTS_Override_Multiplier__c, Apttus_Config2__BasePriceOverride__c, 
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__ShipToAccountId__c,
                    Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                    Apttus_Config2__ItemSequence__c, Apttus_Config2__LineNumber__c,  Apttus_Config2__PriceListId__c, APTS_Material_Num__c,
                    Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c 
                    from Apttus_Config2__LineItem__c Where Id = :lineItem1.Id];

        lineItem1.Apttus_Config2__PricingDate__c = System.now();

        APTS_ContractualPriceMultiplier__c priceMultiplier =  Testutility.createContractualPriceMultiplier();
        priceMultiplier.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier.APTS_PriceList__c = priceList1.Id;
        //priceMultiplier.APTS_Ship_To_Account__c = acc1.Id;
        priceMultiplier.APTS_Product_Name__c = prod1.Id;
        priceMultiplier.APTS_Invalid__c = false;
        priceMultiplier.APTS_Sold_To_Acct_Number__c = 'RR282';

        insert priceMultiplier;

        configLineItemList.add(lineItem1);

        list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
        
        ContractualPriceMultiplierlst.add(priceMultiplier);        

        //insert configLineItemList;

        NetVsMultiplierHelper helperClass = new NetVsMultiplierHelper();
        helperClass.getMultiplierOrNetPrice(configLineItemList,ContractualPriceMultiplierlst);

    }


    /**
     * Method to check condition 3.
     * 
     * If ( 
            ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ShipToAccountId__c != null &&
            ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ShipToAccountId__c &&
            ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
            ContractualPriceMultiplier.APTS_Multiplier__c != null
        )
     * 
     **/

    @isTest
    static void testMethod3(){
        
        List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();

        Account acc1 = Testutility.createAccount();
        acc1.AccountNumber = 'RR282';
        insert acc1;

        Account acc2 = Testutility.createAccount();
        acc2.Name = 'test 2';
        acc2.ParentId = acc1.Id;
        acc2.AccountNumber = 'RR82';
        insert acc2;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;
        proposal1.Apttus_QPConfig__ShipToAccountId__c = acc2.Id;
        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        productConfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc2.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        lineItem1.Apttus_Config2__PricingStatus__c = 'Complete';

        insert lineItem1;

        lineItem1 = [select Id, APTS_Multiplier__c, Apttus_Config2__ListPrice__c, APTS_Override_Multiplier__c, Apttus_Config2__BasePriceOverride__c, 
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__ShipToAccountId__c,
                    Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                    Apttus_Config2__ItemSequence__c, Apttus_Config2__LineNumber__c,  Apttus_Config2__PriceListId__c, APTS_Material_Num__c,
                    Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c  
                    from Apttus_Config2__LineItem__c Where Id = :lineItem1.Id];

        lineItem1.Apttus_Config2__PricingDate__c = System.now();

        APTS_ContractualPriceMultiplier__c priceMultiplier =  Testutility.createContractualPriceMultiplier();
        priceMultiplier.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier.APTS_PriceList__c = priceList1.Id;
        priceMultiplier.APTS_Ship_To_Account__c = acc2.Id;
        priceMultiplier.APTS_Product_Name__c = prod1.Id;
        priceMultiplier.APTS_Contract_Price__c = null;
        priceMultiplier.APTS_Invalid__c = false;
        priceMultiplier.APTS_Sold_To_Acct_Number__c = 'RR282';
        priceMultiplier.APTS_Ship_To_Acct_Number__c = 'RR82';

        insert priceMultiplier;

        configLineItemList.add(lineItem1);

        list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
        
        ContractualPriceMultiplierlst.add(priceMultiplier);       

        //insert configLineItemList;

        NetVsMultiplierHelper helperClass = new NetVsMultiplierHelper();
        helperClass.getMultiplierOrNetPrice(configLineItemList,ContractualPriceMultiplierlst);
    }


    /**
     * Method to check condition 4.
     * 
     * If (
            ContractualPriceMultiplier.APTS_Ship_To_Account__c == null &&
            ContractualPriceMultiplier.APTS_Material_Number__c == configLineItem.APTS_Material_Num__c &&
            ContractualPriceMultiplier.APTS_Multiplier__c != null
        )
     * 
     **/

    @isTest
    static void testMethod4(){
        
        List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();

        Account acc1 = Testutility.createAccount();
        acc1.AccountNumber = 'RR282';
        insert acc1;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        productConfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc1.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        lineItem1.Apttus_Config2__PricingStatus__c = 'Complete';

        insert lineItem1;

        lineItem1 = [select Id, APTS_Multiplier__c, Apttus_Config2__ListPrice__c, APTS_Override_Multiplier__c, Apttus_Config2__BasePriceOverride__c, 
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__ShipToAccountId__c,
                    Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                    Apttus_Config2__ItemSequence__c, Apttus_Config2__LineNumber__c,  Apttus_Config2__PriceListId__c, APTS_Material_Num__c,
                    Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c  
                    from Apttus_Config2__LineItem__c Where Id = :lineItem1.Id];

        lineItem1.Apttus_Config2__PricingDate__c = System.now();

        APTS_ContractualPriceMultiplier__c priceMultiplier =  Testutility.createContractualPriceMultiplier();
        priceMultiplier.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier.APTS_Sold_To_Acct_Number__c = 'RR282';
        priceMultiplier.APTS_PriceList__c = priceList1.Id;
        priceMultiplier.APTS_Product_Name__c = prod1.Id;
        priceMultiplier.APTS_Contract_Price__c = null;
        priceMultiplier.APTS_Invalid__c = false;

        insert priceMultiplier;

        configLineItemList.add(lineItem1);
        
        list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
        
        ContractualPriceMultiplierlst.add(priceMultiplier);        

        //insert configLineItemList;

        NetVsMultiplierHelper helperClass = new NetVsMultiplierHelper();
        helperClass.getMultiplierOrNetPrice(configLineItemList,ContractualPriceMultiplierlst);
    }


    /**
     * Method to check condition 5.
     * 
     * If (
            ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ShipToAccountId__c != null &&
            ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ShipToAccountId__c &&
            ContractualPriceMultiplier.APTS_Mat_Grp_3_Catgr_CD__c == configLineItem.APTS_Mat_Grp_3_Catgr_CD__c &&
            ContractualPriceMultiplier.APTS_Multiplier__c != null
        )
     * 
     **/

    @isTest
    static void testMethod5(){
        
        List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();
        
 		Account acc1 = Testutility.createAccount();
        acc1.AccountNumber = 'RR282';
        insert acc1;

        Account acc2 = Testutility.createAccount();
        acc2.Name = 'test 2';
        acc2.ParentId = acc1.Id;
        acc2.AccountNumber = 'RR82';
        insert acc2;


        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040a';
        prod1.APTS_Mat_Grp_1_CIT__c = 'C';
        prod1.APTS_Mat_Grp_2_Catlg__c = 'LF' ;
        prod1.APTS_Mat_Grp_3_Catgr_CD__c = '21';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;
        proposal1.Apttus_QPConfig__ShipToAccountId__c = acc2.Id;

        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        productConfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc2.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '21';
        lineItem1.Apttus_Config2__PricingStatus__c = 'Complete';

        insert lineItem1;

        lineItem1 = [select Id, APTS_Multiplier__c, Apttus_Config2__ListPrice__c, APTS_Override_Multiplier__c, Apttus_Config2__BasePriceOverride__c, 
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__ShipToAccountId__c,
                    Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                    Apttus_Config2__ItemSequence__c, Apttus_Config2__LineNumber__c,  Apttus_Config2__PriceListId__c, APTS_Material_Num__c,
                    Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c  
                    from Apttus_Config2__LineItem__c Where Id = :lineItem1.Id];

        lineItem1.Apttus_Config2__PricingDate__c = System.now();

        APTS_ContractualPriceMultiplier__c priceMultiplier =  Testutility.createContractualPriceMultiplier();
        priceMultiplier.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier.APTS_PriceList__c = priceList1.Id;
        priceMultiplier.APTS_Ship_To_Account__c = acc2.Id;
        priceMultiplier.APTS_Product_Name__c = prod1.Id;
        priceMultiplier.APTS_Sold_To_Acct_Number__c = 'RR282';
        priceMultiplier.APTS_Ship_To_Acct_Number__c = 'RR82';
        priceMultiplier.APTS_Invalid__c = false;

        insert priceMultiplier;

        configLineItemList.add(lineItem1);

       list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
        
        ContractualPriceMultiplierlst.add(priceMultiplier);       

        //insert configLineItemList;

        NetVsMultiplierHelper helperClass = new NetVsMultiplierHelper();
        helperClass.getMultiplierOrNetPrice(configLineItemList,ContractualPriceMultiplierlst);
    }


    /**
     * Method to check condition 6.
     * 
     * If ( 
            ContractualPriceMultiplier.APTS_Ship_To_Account__c != null && configLineItem.Apttus_Config2__ShipToAccountId__c != null &&
            ContractualPriceMultiplier.APTS_Ship_To_Account__c == configLineItem.Apttus_Config2__ShipToAccountId__c &&
            ContractualPriceMultiplier.APTS_Mat_Grp_1_CIT__c == configLineItem.APTS_Mat_Grp_1_CIT__c &&
            ContractualPriceMultiplier.APTS_Mat_Grp_2_Catlg__c == configLineItem.APTS_Mat_Grp_2_Catlg__c &&
            ContractualPriceMultiplier.APTS_Multiplier__c != null
        )
     * 
     **/

   @isTest
    static void testMethod6(){

        
        List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();


       Account acc1 = Testutility.createAccount();
        acc1.AccountNumber = 'RR282';
        insert acc1;

        Account acc2 = Testutility.createAccount();
        acc2.Name = 'test 2';
        acc2.ParentId = acc1.Id;
        acc2.AccountNumber = 'RR82';
        insert acc2;

        Contact con1 = Testutility.createContact(acc1.Id);

        insert con1;

        Product2 prod1 = Testutility.createProduct();
        prod1.APTS_Material_Num__c = '01A1A84040a';
        prod1.APTS_Mat_Grp_1_CIT__c = 'C';
        prod1.APTS_Mat_Grp_2_Catlg__c = 'LF' ;
        prod1.APTS_Mat_Grp_3_Catgr_CD__c = '021';

        insert prod1;

        Apttus_Config2__PriceList__c priceList1 = Testutility.createPriceList();

        insert priceList1;

        Apttus_Proposal__Proposal__c proposal1 = Testutility.createProposal(acc1.Id);
        proposal1.Apttus_QPConfig__PriceListId__c = priceList1.Id;
        proposal1.Apttus_QPConfig__ShipToAccountId__c = acc2.Id;
        insert proposal1;


        Apttus_Config2__ProductConfiguration__c productConfig1 = Testutility.createProductConfig(acc1.Id, proposal1.Id);
        productConfig1.Apttus_QPConfig__Proposald__c = proposal1.Id;
        insert productConfig1;
        
        
        Apttus_Config2__LineItem__c lineItem1 = Testutility.createLineItem(productConfig1.Id, prod1.Id);
        lineItem1.Apttus_Config2__PriceListId__c = priceList1.Id;
        lineItem1.Apttus_Config2__ShipToAccountId__c = acc2.Id;
        lineItem1.APTS_Material_Num__c = '01A1A84040a';
        lineItem1.APTS_Mat_Grp_1_CIT__c = 'C';
        lineItem1.APTS_Mat_Grp_2_Catlg__c = 'LF';
        lineItem1.APTS_Mat_Grp_3_Catgr_CD__c = '021';
        

        insert lineItem1;

        lineItem1 = [select Id, APTS_Multiplier__c, Apttus_Config2__ListPrice__c, APTS_Override_Multiplier__c, Apttus_Config2__BasePriceOverride__c, 
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ShipToAccountId__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__ShipToAccountId__c,
                    Apttus_Config2__ShipToAccountId__c, APTS_Mat_Grp_3_Catgr_CD__c, APTS_Mat_Grp_1_CIT__c, APTS_Mat_Grp_2_Catlg__c,
                    Apttus_Config2__ItemSequence__c, Apttus_Config2__LineNumber__c,  Apttus_Config2__PriceListId__c, APTS_Material_Num__c,
                    Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, Apttus_Config2__PricingDate__c,
                    Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c  
                    from Apttus_Config2__LineItem__c Where Id = :lineItem1.Id];

        lineItem1.Apttus_Config2__PricingDate__c = System.now();

       APTS_ContractualPriceMultiplier__c priceMultiplier =  Testutility.createContractualPriceMultiplier();
        priceMultiplier.APTS_Sold_To_Account__c = acc1.Id;
        priceMultiplier.APTS_PriceList__c = priceList1.Id;
        priceMultiplier.APTS_Ship_To_Account__c = acc2.Id;
        priceMultiplier.APTS_Product_Name__c = prod1.Id;
        priceMultiplier.APTS_Sold_To_Acct_Number__c = 'RR282';
        priceMultiplier.APTS_Ship_To_Acct_Number__c = 'RR82';
        priceMultiplier.APTS_Invalid__c = false;

        insert priceMultiplier;

        configLineItemList.add(lineItem1);

       list<APTS_ContractualPriceMultiplier__c> ContractualPriceMultiplierlst = new list<APTS_ContractualPriceMultiplier__c>();
        
        ContractualPriceMultiplierlst.add(priceMultiplier);        

        //insert configLineItemList;

        NetVsMultiplierHelper helperClass = new NetVsMultiplierHelper();
        helperClass.getMultiplierOrNetPrice(configLineItemList,ContractualPriceMultiplierlst);
    }

}