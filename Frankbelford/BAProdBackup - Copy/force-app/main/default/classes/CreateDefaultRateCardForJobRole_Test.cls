@IsTest
public class CreateDefaultRateCardForJobRole_Test {
    
    private static List<sirenum__Rate_Modifier_Type__c> rateModifierTypes = new List<sirenum__Rate_Modifier_Type__c>();

    static void createRateModifierTypes () {
        for (Integer i = 0; i < 2; i++) {
            rateModifierTypes.add(new sirenum__Rate_Modifier_Type__c(Name                        = 'RMT' + i, 
                                                                     sirenum__Condition_Field__c = 'AWR',
                                                                     sirenum__Condition_value__c = 'TRUE',
                                                                     sirenum__SortOrder__c       = i));
        }
        insert rateModifierTypes;
    }

    static sirenum__Rate_Card__c createRateCard(String rateCardName,
                                                Decimal chargeRate,
                                                Decimal payRate) {
        
        sirenum__Rate_Card__c            rateCard;
        List<sirenum__Rate_Card_Page__c> rateCardPages = new List<sirenum__Rate_Card_Page__c>();
        List<sirenum__Rate_Line__c>      rateLines     = new List<sirenum__Rate_Line__c>();
        List<sirenum__Rate_Modifier__c>  rateModifiers = new List<sirenum__Rate_Modifier__c>();

        // Rate Card
        rateCard = new sirenum__Rate_Card__c(Name = rateCardName);
        insert rateCard;
        system.debug('Rate Card Id: ' + rateCard.Id);
        
        // Rate Card Pages
        for (Integer i = 0; i < 2; i++) {
            rateCardPages.add(new sirenum__Rate_Card_Page__c(Name                  = 'Rate Card Page ' + i,
                                                             sirenum__Rate_Card__c = rateCard.Id,
                                                             sirenum__Rate_Type__c = 'Hourly',
                                                             sirenum__SortOrder__c = i));
        }
        insert rateCardPages;
        
        // Rate Lines
        for (sirenum__Rate_Card_Page__c rateCardPage : rateCardPages) {
            for (Integer i = 0; i < 2; i++) {
                rateLines.add(new sirenum__Rate_Line__c(sirenum__Rate_Card_Page__c = rateCardPage.Id,
                                                        sirenum__SortOrder__c      = i,
                                                        sirenum__Charge_Rate__c    = chargeRate,
                                                        sirenum__Pay_Rate__c       = payRate));
            }
        }
        insert rateLines;

        // Rate Modifiers
        for (sirenum__Rate_Line__c rateLine : rateLines) {
            for (sirenum__Rate_Modifier_Type__c rateModifierType : rateModifierTypes) {
                rateModifiers.add(new sirenum__Rate_Modifier__c(sirenum__Rate_Line__c          = rateLine.Id,
                                                                sirenum__Rate_Modifier_Type__c = rateModifierType.Id,
                                                                sirenum__Charge_Rate__c        = chargeRate + 1.0,
                                                                sirenum__Pay_Rate__c           = payRate + 1.0));
            }
        }
        insert rateModifiers;

        return rateCard;
    }
    
    @IsTest
    static void MultipleDefaultTemplates() {

        createRateModifierTypes();
        
        Integer totalLineCount = 0;
        Decimal totalLineCharge = 0;
        Decimal totalLinePay = 0;
        Integer totalModifierCount = 0;
        Decimal totalModifierCharge = 0;
        Decimal totalModifierPay = 0;

        sirenum__Rate_Card__c globalRateCard = createRateCard('Global', 10.0, 9.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(10.0);
        totalLinePay        += 4*(9.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(10.0 + 1.0);
        totalModifierPay    += 8*(9.0 + 1.0);

        sirenum__TimesheetSettings__c timesheetSettings = new sirenum__TimesheetSettings__c();
        timesheetSettings.Default_Rate_Card__c = globalRateCard.Id;
        insert timesheetSettings;
        
        sirenum__Rate_Card__c accountRateCard = createRateCard('Account', 12.0, 10.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(12.0);
        totalLinePay        += 4*(10.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(12.0 + 1.0);
        totalModifierPay    += 8*(10.0 + 1.0);

        Account accRC = new Account(Name = 'ABC', 
                                    Default_Rate_Card__c = accountRateCard.Id);
        insert accRC;
        
        Account accNoRC = new Account(Name = 'DEF');
        insert accNoRC;
        
        
        sirenum__Rate_Card__c contractRateCard = createRateCard('Contract', 15.0, 12.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(15.0);
        totalLinePay        += 4*(12.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(15.0 + 1.0);
        totalModifierPay    += 8*(12.0 + 1.0);

        // Contract with rate card and account with rate card - Contract rate card will be used
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name                 = 'Test Contract 123', 
                                                                                   sirenum__Client__c   = accRC.Id,
                                                                                   Default_Rate_Card__c = contractRateCard.Id);
        insert contract;
        
        // Contract with no rate card and account with rate card - Account rate card will be used
        sirenum__ProActiveContract__c contractAccount = new sirenum__ProActiveContract__c(Name                  = 'Test Contract ABC', 
                                                                                          sirenum__Client__c    = accRC.Id);
        insert contractAccount;

        // Contract with no rate card and account with no rate card - Global rate card will be used
        sirenum__ProActiveContract__c contractGlobal = new sirenum__ProActiveContract__c(Name                  = 'Test Contract 3', 
                                                                                         sirenum__Client__c    = accNoRC.Id);
        insert contractGlobal;
                
        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Chefs & Cooks -CHC',
                                                                Impellam_Job_Category__c  = 'Chef -CA048');
        insert jobType;

        // Job Roles with no Contract - Global rate card will be used
        List<sirenum__Team__c> jobRolesNoContract = new List<sirenum__Team__c>();
        for (Integer i=0; i<2; i++)
        {
            jobRolesNoContract.add(new sirenum__Team__c(Name = 'Test Job Role', 
                                                        sirenum__Job_Type__c = jobType.id,
                                                        IP_OPWIPSRole__c     = 'No'));
        }
        insert jobRolesNoContract;
        
        // Global rates
        totalLineCount      += jobRolesNoContract.size()*4;
        totalLineCharge     += jobRolesNoContract.size()*4*(10.0);
        totalLinePay        += jobRolesNoContract.size()*4*(9.0);
        totalModifierCount  += jobRolesNoContract.size()*8;
        totalModifierCharge += jobRolesNoContract.size()*8*(10.0 + 1.0);
        totalModifierPay    += jobRolesNoContract.size()*8*(9.0 + 1.0);


        // Job Roles with rate card on Contract
        List<sirenum__Team__c> jobRolesContract = new List<sirenum__Team__c>();
        for (Integer i=0; i<3; i++)
        {
            jobRolesContract.add(new sirenum__Team__c(Name = 'Test Job Role', 
                                                      sirenum__Account__c  = contract.Id,
                                                      sirenum__Job_Type__c = jobType.id,
                                                      IP_OPWIPSRole__c     = 'No'));
        }
        insert jobRolesContract;
        
        // Contract rates
        totalLineCount      += jobRolesContract.size()*4;
        totalLineCharge     += jobRolesContract.size()*4*(15.0);
        totalLinePay        += jobRolesContract.size()*4*(12.0);
        totalModifierCount  += jobRolesContract.size()*8;
        totalModifierCharge += jobRolesContract.size()*8*(15.0 + 1.0);
        totalModifierPay    += jobRolesContract.size()*8*(12.0 + 1.0);

        // Job Roles with rate card on Account
        List<sirenum__Team__c> jobRolesAccount = new List<sirenum__Team__c>();
        for (Integer i=0; i<4; i++)
        {
            jobRolesAccount.add(new sirenum__Team__c(Name = 'Test Job Role', 
                                                     sirenum__Account__c  = contractAccount.Id,
                                                     sirenum__Job_Type__c = jobType.id,
                                                     IP_OPWIPSRole__c     = 'No'));
        }
        insert jobRolesAccount;
        
        // Account rates
        totalLineCount      += jobRolesAccount.size()*4;
        totalLineCharge     += jobRolesAccount.size()*4*(12.0);
        totalLinePay        += jobRolesAccount.size()*4*(10.0);
        totalModifierCount  += jobRolesAccount.size()*8;
        totalModifierCharge += jobRolesAccount.size()*8*(12.0 + 1.0);
        totalModifierPay    += jobRolesAccount.size()*8*(10.0 + 1.0);
        
        // Job Roles with global rate card
        List<sirenum__Team__c> jobRolesGlobal = new List<sirenum__Team__c>();
        for (Integer i=0; i<5; i++)
        {
            jobRolesGlobal.add(new sirenum__Team__c(Name = 'Test Job Role', 
                                                    sirenum__Account__c  = contractGlobal.Id,
                                                    sirenum__Job_Type__c = jobType.id,
                                                    IP_OPWIPSRole__c     = 'No'));
        }
        insert jobRolesGlobal;
        
        // Global rates
        totalLineCount      += jobRolesGlobal.size()*4;
        totalLineCharge     += jobRolesGlobal.size()*4*(10.0);
        totalLinePay        += jobRolesGlobal.size()*4*(9.0);
        totalModifierCount  += jobRolesGlobal.size()*8;
        totalModifierCharge += jobRolesGlobal.size()*8*(10.0 + 1.0);
        totalModifierPay    += jobRolesGlobal.size()*8*(9.0 + 1.0);
        
        AggregateResult[] lineRates = [SELECT Count(Id) Lines,
                                              SUM(sirenum__Charge_Rate__c) Charge, 
                                              SUM(sirenum__Pay_Rate__c) Pay 
                                       FROM   sirenum__Rate_Line__c];
        system.assertEquals(totalLineCount , lineRates[0].get('Lines'));
        system.assertEquals(totalLineCharge, lineRates[0].get('Charge'));
        system.assertEquals(totalLinePay   , lineRates[0].get('Pay'));
        
        AggregateResult[] modifierRates = [SELECT Count(Id) Modifiers,
                                                  SUM(sirenum__Charge_Rate__c) Charge, 
                                                  SUM(sirenum__Pay_Rate__c) Pay 
                                           FROM   sirenum__Rate_Modifier__c];
        system.assertEquals(totalModifierCount , modifierRates[0].get('Modifiers'));
        system.assertEquals(totalModifierCharge, modifierRates[0].get('Charge'));
        system.assertEquals(totalModifierPay   , modifierRates[0].get('Pay'));
    }

    @IsTest
    static void ContractDefaultTemplate() {

        createRateModifierTypes();
        
        Integer totalLineCount = 0;
        Decimal totalLineCharge = 0;
        Decimal totalLinePay = 0;
        Integer totalModifierCount = 0;
        Decimal totalModifierCharge = 0;
        Decimal totalModifierPay = 0;

        sirenum__Rate_Card__c globalRateCard = createRateCard('Global', 10.0, 9.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(10.0);
        totalLinePay        += 4*(9.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(10.0 + 1.0);
        totalModifierPay    += 8*(9.0 + 1.0);

        sirenum__TimesheetSettings__c timesheetSettings = new sirenum__TimesheetSettings__c();
        timesheetSettings.Default_Rate_Card__c = globalRateCard.Id;
        insert timesheetSettings;
        
        sirenum__Rate_Card__c accountRateCard = createRateCard('Account', 12.0, 10.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(12.0);
        totalLinePay        += 4*(10.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(12.0 + 1.0);
        totalModifierPay    += 8*(10.0 + 1.0);

        Account acc = new Account(Name = 'Test Client', 
                                  Default_Rate_Card__c = accountRateCard.Id);
        insert acc;
        
        // Add value to rate card to allow to identify which one was used
        accountRateCard.sirenum__Account__c = acc.Id;
        update accountRateCard;
        
        sirenum__Rate_Card__c contractRateCard = createRateCard('Contract', 15.0, 12.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(15.0);
        totalLinePay        += 4*(12.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(15.0 + 1.0);
        totalModifierPay    += 8*(12.0 + 1.0);

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name                 = 'Test Contract', 
                                                                                   sirenum__Client__c   = acc.Id,
                                                                                   Default_Rate_Card__c = contractRateCard.Id);
        insert contract;
        
        // Add value to rate card to allow to identify which one was used
        contractRateCard.sirenum__Sirenum_Contract__c = contract.Id;
        update contractRateCard;
        
        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Chefs & Cooks -CHC',
                                                                Impellam_Job_Category__c  = 'Chef -CA048');
        insert jobType;

        // Job Role
        sirenum__Team__c jobRole = new sirenum__Team__c(Name = 'Test Job Role', 
                                                        sirenum__Account__c  = contract.Id,
                                                        sirenum__Job_Type__c = jobType.id,
                                                        IP_OPWIPSRole__c     = 'No');
        insert jobRole;
        
        // Contract rates
        totalLineCount      += 4;
        totalLineCharge     += 4*(15.0);
        totalLinePay        += 4*(12.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(15.0 + 1.0);
        totalModifierPay    += 8*(12.0 + 1.0);


        sirenum__Team__c insertedJobRole = [SELECT sirenum__Rate_Card__r.sirenum__Account__c,
                                                   sirenum__Rate_Card__r.sirenum__Sirenum_Contract__c,
                                                   sirenum__Rate_Card__r.IP_AcountLinkCustom__c
                                            FROM   sirenum__Team__c
                                            WHERE  Id = :jobRole.Id];
        system.assertEquals(null       , insertedJobRole.sirenum__Rate_Card__r.sirenum__Account__c);
        system.assertEquals(contract.Id, insertedJobRole.sirenum__Rate_Card__r.sirenum__Sirenum_Contract__c);
        system.assertEquals(acc.Id     , insertedJobRole.sirenum__Rate_Card__r.IP_AcountLinkCustom__c);
        
        AggregateResult[] lineRates = [SELECT Count(Id) Lines,
                                              SUM(sirenum__Charge_Rate__c) Charge, 
                                              SUM(sirenum__Pay_Rate__c) Pay 
                                       FROM   sirenum__Rate_Line__c];
        system.assertEquals(totalLineCount , lineRates[0].get('Lines'));
        system.assertEquals(totalLineCharge, lineRates[0].get('Charge'));
        system.assertEquals(totalLinePay   , lineRates[0].get('Pay'));
        
        AggregateResult[] modifierRates = [SELECT Count(Id) Modifiers,
                                                  SUM(sirenum__Charge_Rate__c) Charge, 
                                                  SUM(sirenum__Pay_Rate__c) Pay 
                                           FROM   sirenum__Rate_Modifier__c];
        system.assertEquals(totalModifierCount , modifierRates[0].get('Modifiers'));
        system.assertEquals(totalModifierCharge, modifierRates[0].get('Charge'));
        system.assertEquals(totalModifierPay   , modifierRates[0].get('Pay'));
    }

    @IsTest
    static void AccountDefaultTemplate() {

        createRateModifierTypes();
            
        Integer totalLineCount = 0;
        Decimal totalLineCharge = 0;
        Decimal totalLinePay = 0;
        Integer totalModifierCount = 0;
        Decimal totalModifierCharge = 0;
        Decimal totalModifierPay = 0;

        sirenum__Rate_Card__c globalRateCard = createRateCard('Global', 10.0, 9.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(10.0);
        totalLinePay        += 4*(9.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(10.0 + 1.0);
        totalModifierPay    += 8*(9.0 + 1.0);

        sirenum__TimesheetSettings__c timesheetSettings = new sirenum__TimesheetSettings__c();
        timesheetSettings.Default_Rate_Card__c = globalRateCard.Id;
        insert timesheetSettings;
        
        sirenum__Rate_Card__c accountRateCard = createRateCard('Account', 12.0, 10.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(12.0);
        totalLinePay        += 4*(10.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(12.0 + 1.0);
        totalModifierPay    += 8*(10.0 + 1.0);

        Account acc = new Account(Name = 'Test Client', 
                                  Default_Rate_Card__c = accountRateCard.Id);
        insert acc;
        
        // Add value to rate card to allow to identify which one was used
        accountRateCard.sirenum__Account__c = acc.Id;
        update accountRateCard;
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name                  = 'Test Contract', 
                                                                                   sirenum__Client__c    = acc.Id,
                                                                                   Default_Rate_Card__c = null);
        insert contract;
               
        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Chefs & Cooks -CHC',
                                                                Impellam_Job_Category__c  = 'Chef -CA048');
        insert jobType;

        // Job Role
        sirenum__Team__c jobRole = new sirenum__Team__c(Name = 'Test Job Role', 
                                                        sirenum__Account__c  = contract.Id,
                                                        sirenum__Job_Type__c = jobType.id,
                                                        IP_OPWIPSRole__c     = 'No');
        insert jobRole;
        
        // Account rates
        totalLineCount      += 4;
        totalLineCharge     += 4*(12.0);
        totalLinePay        += 4*(10.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(12.0 + 1.0);
        totalModifierPay    += 8*(10.0 + 1.0);


        sirenum__Team__c insertedJobRole = [SELECT sirenum__Rate_Card__r.sirenum__Account__c,
                                                   sirenum__Rate_Card__r.sirenum__Sirenum_Contract__c,
                                                   sirenum__Rate_Card__r.IP_AcountLinkCustom__c
                                            FROM   sirenum__Team__c
                                            WHERE  Id = :jobRole.Id];
        system.assertEquals(acc.Id , insertedJobRole.sirenum__Rate_Card__r.sirenum__Account__c);
        system.assertEquals(null   , insertedJobRole.sirenum__Rate_Card__r.sirenum__Sirenum_Contract__c);
        system.assertEquals(acc.Id , insertedJobRole.sirenum__Rate_Card__r.IP_AcountLinkCustom__c);

        AggregateResult[] lineRates = [SELECT Count(Id) Lines,
                                              SUM(sirenum__Charge_Rate__c) Charge, 
                                              SUM(sirenum__Pay_Rate__c) Pay 
                                       FROM   sirenum__Rate_Line__c];
        system.assertEquals(totalLineCount , lineRates[0].get('Lines'));
        system.assertEquals(totalLineCharge, lineRates[0].get('Charge'));
        system.assertEquals(totalLinePay   , lineRates[0].get('Pay'));
        
        AggregateResult[] modifierRates = [SELECT Count(Id) Modifiers,
                                                  SUM(sirenum__Charge_Rate__c) Charge, 
                                                  SUM(sirenum__Pay_Rate__c) Pay 
                                           FROM   sirenum__Rate_Modifier__c];
        system.assertEquals(totalModifierCount , modifierRates[0].get('Modifiers'));
        system.assertEquals(totalModifierCharge, modifierRates[0].get('Charge'));
        system.assertEquals(totalModifierPay   , modifierRates[0].get('Pay'));
    }
    
    @IsTest
    static void GlobalDefaultTemplate() {

        createRateModifierTypes();
        
        Integer totalLineCount = 0;
        Decimal totalLineCharge = 0;
        Decimal totalLinePay = 0;
        Integer totalModifierCount = 0;
        Decimal totalModifierCharge = 0;
        Decimal totalModifierPay = 0;

        sirenum__Rate_Card__c globalRateCard = createRateCard('Global', 10.0, 9.0);
        totalLineCount      += 4;
        totalLineCharge     += 4*(10.0);
        totalLinePay        += 4*(9.0);
        totalModifierCount  += 8;
        totalModifierCharge += 8*(10.0 + 1.0);
        totalModifierPay    += 8*(9.0 + 1.0);

        sirenum__TimesheetSettings__c timesheetSettings = new sirenum__TimesheetSettings__c();
        timesheetSettings.Default_Rate_Card__c = globalRateCard.Id;
        insert timesheetSettings;
        
        Account acc = new Account(Name = 'Test Client', 
                                  Default_Rate_Card__c = null);
        insert acc;
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name                 = 'Test Contract', 
                                                                                   sirenum__Client__c   = acc.Id,
                                                                                   Default_Rate_Card__c = null);
        insert contract;
               
        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Chefs & Cooks -CHC',
                                                                Impellam_Job_Category__c  = 'Chef -CA048');
        insert jobType;

        // Job Roles
        List<sirenum__Team__c> jobRoles = new List<sirenum__Team__c>();
        jobRoles.add(new sirenum__Team__c(Name = 'Test Job Role 1', 
                                          sirenum__Account__c  = contract.Id,
                                          sirenum__Job_Type__c = jobType.id,
                                          IP_OPWIPSRole__c     = 'No'));
        
        jobRoles.add(new sirenum__Team__c(Name = 'Test Job Role 2', 
                                          sirenum__Account__c  = contract.Id,
                                          sirenum__Job_Type__c = jobType.id,
                                          IP_OPWIPSRole__c     = 'No'));
        insert jobRoles;
        // Global rates
        totalLineCount      += jobRoles.size()*4;
        totalLineCharge     += jobRoles.size()*4*(10.0);
        totalLinePay        += jobRoles.size()*4*(9.0);
        totalModifierCount  += jobRoles.size()*8;
        totalModifierCharge += jobRoles.size()*8*(10.0 + 1.0);
        totalModifierPay    += jobRoles.size()*8*(9.0 + 1.0);


        List<sirenum__Team__c> insertedJobRoles = [SELECT sirenum__Rate_Card__c,
                                                          sirenum__Rate_Card__r.sirenum__Account__c,
                                                          sirenum__Rate_Card__r.sirenum__Sirenum_Contract__c,
                                                          sirenum__Rate_Card__r.IP_AcountLinkCustom__c
                                                   FROM   sirenum__Team__c
                                                   WHERE  Id = :jobRoles];

        for (sirenum__Team__c insertedJobRole : insertedJobRoles) {
            system.assertNotEquals(null, insertedJobRole.sirenum__Rate_Card__c);
            system.assertEquals(null  , insertedJobRole.sirenum__Rate_Card__r.sirenum__Account__c);
            system.assertEquals(null  , insertedJobRole.sirenum__Rate_Card__r.sirenum__Sirenum_Contract__c);
            system.assertEquals(acc.Id, insertedJobRole.sirenum__Rate_Card__r.IP_AcountLinkCustom__c);
        }
        
        AggregateResult[] lineRates = [SELECT Count(Id) Lines,
                                              SUM(sirenum__Charge_Rate__c) Charge, 
                                              SUM(sirenum__Pay_Rate__c) Pay 
                                       FROM   sirenum__Rate_Line__c];
        system.assertEquals(totalLineCount , lineRates[0].get('Lines'));
        system.assertEquals(totalLineCharge, lineRates[0].get('Charge'));
        system.assertEquals(totalLinePay   , lineRates[0].get('Pay'));
        
        AggregateResult[] modifierRates = [SELECT Count(Id) Modifiers,
                                                  SUM(sirenum__Charge_Rate__c) Charge, 
                                                  SUM(sirenum__Pay_Rate__c) Pay 
                                           FROM   sirenum__Rate_Modifier__c];
        system.assertEquals(totalModifierCount , modifierRates[0].get('Modifiers'));
        system.assertEquals(totalModifierCharge, modifierRates[0].get('Charge'));
        system.assertEquals(totalModifierPay   , modifierRates[0].get('Pay'));

    }

    @IsTest
    static void NoDefaultTemplate() {

        createRateModifierTypes();
            
        sirenum__TimesheetSettings__c timesheetSettings = new sirenum__TimesheetSettings__c();
        timesheetSettings.Default_Rate_Card__c = null;
        
        Account acc = new Account(Name = 'Test Client', 
                                  Default_Rate_Card__c = null);
        insert acc;
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name                 = 'Test Contract', 
                                                                                   sirenum__Client__c   = acc.Id,
                                                                                   Default_Rate_Card__c = null);
        insert contract;
               
        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c(Name = 'Test Sector');
        insert sector;

        //Job type
        sirenum__Job_Type__c jobType = new sirenum__Job_Type__c(Name                      ='Test Job Type', 
                                                                Impellam_Sector__c        = sector.id,
                                                                Impellam_Core_Category__c = 'Chefs & Cooks -CHC',
                                                                Impellam_Job_Category__c  = 'Chef -CA048');
        insert jobType;

        // Job Role
        sirenum__Team__c jobRole = new sirenum__Team__c(Name = 'Test Job Role', 
                                                        sirenum__Account__c  = contract.Id,
                                                        sirenum__Job_Type__c = jobType.id,
                                                        IP_OPWIPSRole__c     = 'No');
        insert jobRole;

        sirenum__Team__c insertedJobRole = [SELECT sirenum__Rate_Card__c
                                            FROM   sirenum__Team__c
                                            WHERE  Id = :jobRole.Id];
        system.assertEquals(null, insertedJobRole.sirenum__Rate_Card__c);
    }
}