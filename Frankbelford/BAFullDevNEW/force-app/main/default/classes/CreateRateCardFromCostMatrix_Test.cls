@IsTest
public class CreateRateCardFromCostMatrix_Test {

    @IsTest
    static void TestCreateRateCardFromCostMatrix() {

        Account a = new Account(Name = 'Test Client');
        insert a;
        
        // Candidate
        Contact c = new Contact(firstName = 'Candy ', lastName = 'Date', email = 'candy@date.com', AccountId = a.id);
        insert c;

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c(Name               = 'Test Contract', 
                                                                              sirenum__Client__c = a.Id);
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

        jobRoles.add(new sirenum__Team__c(Name = 'Test Job Role 3', 
                                                  sirenum__Account__c  = contract.Id,
                                                  sirenum__Job_Type__c = jobType.id,
                                                  IP_OPWIPSRole__c     = 'No'));
        insert jobRoles;
        
        // Cost Matrix Frames
        List<sirenum__PayrollCostMatrixFrame__c> costMatrixFrames = new List<sirenum__PayrollCostMatrixFrame__c>();
        costMatrixFrames.add(new sirenum__PayrollCostMatrixFrame__c (Name                                  = 'Cost Matrix Frame 1',
                                                                     sirenum__Job_Role__c                  = jobRoles.get(0).Id,
                                                                     sirenum__Daily_Overtime_Threshold__c  = 8.0, 
                                                                     sirenum__Weekly_Overtime_Threshold__c = 37.5));
        
        costMatrixFrames.add(new sirenum__PayrollCostMatrixFrame__c (Name                                  = 'Cost Matrix Frame 2',
                                                                     sirenum__Job_Role__c                  = jobRoles.get(1).Id,
                                                                     sirenum__Daily_Overtime_Threshold__c  = 9.0, 
                                                                     sirenum__Weekly_Overtime_Threshold__c = 40.0));

        costMatrixFrames.add(new sirenum__PayrollCostMatrixFrame__c (Name                                  = 'Cost Matrix Frame 3',
                                                                     sirenum__Job_Role__c                  = jobRoles.get(2).Id,
                                                                     sirenum__Daily_Overtime_Threshold__c  = 9.0, 
                                                                     sirenum__Weekly_Overtime_Threshold__c = 40.0));
        insert costMatrixFrames;

        List<sirenum__Standard_Rate_Type__c> stdRateTypes = new List<sirenum__Standard_Rate_Type__c>();
        stdRateTypes.add(new sirenum__Standard_Rate_Type__c(sirenum__SortOrder__c = 0, sirenum__Rate_Code__c='BG'));
        stdRateTypes.add(new sirenum__Standard_Rate_Type__c(sirenum__SortOrder__c = 1, sirenum__Rate_Code__c='P1'));
        stdRateTypes.add(new sirenum__Standard_Rate_Type__c(sirenum__SortOrder__c = 2, sirenum__Rate_Code__c='IN'));
        stdRateTypes.add(new sirenum__Standard_Rate_Type__c(sirenum__SortOrder__c = 3, sirenum__Rate_Code__c='D2'));
        stdRateTypes.add(new sirenum__Standard_Rate_Type__c(sirenum__SortOrder__c = 4, sirenum__Rate_Code__c='DX'));
        insert stdRateTypes;

        List<sirenum__PayrollCostMatrix__c> costMatrices = new List<sirenum__PayrollCostMatrix__c>();
        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(0).Id,
                                                           sirenum__Contact__c              = c.Id,
                                                           sirenum__Start_date__c           = Date.newInstance(2018, 1, 1),
                                                           sirenum__End_date__c             = Date.newInstance(2018, 12, 31),
                                                           sirenum__Day_Type__c             = 'Any',
                                                           Rate_code__c                     = 'BG',
                                                           sirenum__Cost_per_Hour__c        = 10.0,
                                                           sirenum__Income_per_Hour__c      = 12.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 15.0,
                                                           sirenum__Overtime_Charge_Rate__c = 18.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));
        
        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(0).Id,
                                                           sirenum__Contact__c              = null,
                                                           sirenum__Start_date__c           = null,
                                                           sirenum__End_date__c             = Date.newInstance(2018, 3, 31), // Excluded
                                                           sirenum__Day_Type__c             = 'Monday',
                                                           Rate_code__c                     = 'P1',
                                                           sirenum__Cost_per_Hour__c        = 10.0,
                                                           sirenum__Income_per_Hour__c      = 12.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 15.0,
                                                           sirenum__Overtime_Charge_Rate__c = 18.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));
        
        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(0).Id,
                                                           sirenum__Contact__c              = null,
                                                           sirenum__Start_date__c           = Date.newInstance(2018, 4, 1),
                                                           sirenum__End_date__c             = Date.newInstance(2018, 5, 31),
                                                           sirenum__Day_Type__c             = 'Tuesday',
                                                           Rate_code__c                     = 'P1',
                                                           sirenum__Cost_per_Hour__c        = 10.0,
                                                           sirenum__Income_per_Hour__c      = 12.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 15.0,
                                                           sirenum__Overtime_Charge_Rate__c = 18.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));
        
        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(0).Id,
                                                           sirenum__Contact__c              = null,
                                                           sirenum__Start_date__c           = Date.newInstance(2018, 6, 1),
                                                           sirenum__End_date__c             = null,
                                                           sirenum__Day_Type__c             = 'Wednesday',
                                                           Rate_code__c                     = 'IN',
                                                           sirenum__Cost_per_Hour__c        = 10.0,
                                                           sirenum__Income_per_Hour__c      = 12.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 15.0,
                                                           sirenum__Overtime_Charge_Rate__c = 18.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));

        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(1).Id,
                                                           sirenum__Contact__c              = null,
                                                           sirenum__Start_date__c           = null,
                                                           sirenum__End_date__c             = null,
                                                           sirenum__Day_Type__c             = 'Friday',
                                                           Rate_code__c                     = 'DX',
                                                           sirenum__Cost_per_Hour__c        = 10.0,
                                                           sirenum__Income_per_Hour__c      = 12.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 15.0,
                                                           sirenum__Overtime_Charge_Rate__c = 18.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));

        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(1).Id,
                                                           sirenum__Contact__c              = null,
                                                           sirenum__Start_date__c           = null,
                                                           sirenum__End_date__c             = null,
                                                           sirenum__Day_Type__c             = 'Saturday',
                                                           Rate_code__c                     = 'DX',
                                                           sirenum__Cost_per_Hour__c        = 15.0,
                                                           sirenum__Income_per_Hour__c      = 17.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 20.0,
                                                           sirenum__Overtime_Charge_Rate__c = 25.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));

        costMatrices.add(new sirenum__PayrollCostMatrix__c(sirenum__costMatrixFrame__c      = costMatrixFrames.get(2).Id,
                                                           sirenum__Contact__c              = null,
                                                           sirenum__Start_date__c           = null,
                                                           sirenum__End_date__c             = Date.newInstance(2018, 4, 1),
                                                           sirenum__Day_Type__c             = 'Saturday',
                                                           Rate_code__c                     = 'DX',
                                                           sirenum__Cost_per_Hour__c        = 15.0,
                                                           sirenum__Income_per_Hour__c      = 17.0,
                                                           sirenum__Overtime_Pay_Rate__c    = 20.0,
                                                           sirenum__Overtime_Charge_Rate__c = 25.0,
                                                           sirenum__Start_Hour__c           = null,
                                                           sirenum__End_Hour__c             = null
                                                           ));
        insert costMatrices;

        List<Id> costMatrixFrameIds = new List<Id>();
        for (sirenum__PayrollCostMatrixFrame__c costMatrixFrame : costMatrixFrames) {
            costMatrixFrameIds.add(costMatrixFrame.Id);
        }
        CreateRateCardFromCostMatrix.createRateCardsFromMatrixFrames(costMatrixFrameIds);
        
        List<sirenum__Rate_Card__c>      rateCards     = [SELECT Id, IP_AcountLinkCustom__c FROM sirenum__Rate_Card__c];
        List<sirenum__Rate_Card_Page__c> rateCardPages = [SELECT Id FROM sirenum__Rate_Card_Page__c];
        List<sirenum__Rate_Line__c>      rateLines     = [SELECT Id FROM sirenum__Rate_Line__c];
        system.assertEquals(3, rateCards.size());
        system.assertEquals(0, rateCardPages.size());
        system.assertEquals(0, rateLines.size());
        for (sirenum__Rate_Card__c rateCard : rateCards) {
            system.assertEquals(a.Id, rateCard.IP_AcountLinkCustom__c);
        }
    }
}