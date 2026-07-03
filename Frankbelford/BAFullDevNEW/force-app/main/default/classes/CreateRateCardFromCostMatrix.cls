public with sharing class CreateRateCardFromCostMatrix {

    public static void createRateCardsFromMatrixFrames(List<Id> costMatrixFrameIds) {
        try {
            // Query the cost matrix frames
            List<sirenum__PayrollCostMatrixFrame__c> costMatrixFrames;
            costMatrixFrames = [SELECT sirenum__Daily_Overtime_Threshold__c, sirenum__Weekly_Overtime_Threshold__c, sirenum__Job_Role__c,
                                       sirenum__Job_Role__r.sirenum__Account__r.sirenum__Client__c,
                                       (SELECT Rate_Code__c, sirenum__Contact__c, sirenum__Contact__r.Name,
                                               sirenum__costMatrixFrame__c, sirenum__Cost_per_Hour__c, sirenum__Day_Type__c, sirenum__End_date__c,
                                               sirenum__End_Hour__c, sirenum__Income_per_Hour__c, sirenum__Overtime_charge_rate__c,
                                               sirenum__Overtime_pay_rate__c, sirenum__Priority__c, sirenum__RateType__c, sirenum__Start_date__c,
                                               sirenum__Start_Hour__c
                                        FROM   sirenum__Payroll_Cost_Matrices__r
                                        WHERE  (sirenum__End_date__c >= 2018-04-01 OR sirenum__End_date__c = null)
                                        AND    (sirenum__Cost_per_Hour__c > 0 OR sirenum__Income_per_Hour__c > 0)
                                        AND    sirenum__AWR_eligible__c != 'YES'
                                        ORDER BY sirenum__Contact__c    NULLS FIRST,
                                                 sirenum__Start_date__c NULLS FIRST,
                                                 sirenum__End_date__c   NULLS FIRST,
                                                 sirenum__Priority__c)
                                FROM   sirenum__PayrollCostMatrixFrame__c
                                WHERE  Id IN :costMatrixFrameIds];

            if (costMatrixFrames.size() > 0) {
            
                // Create map of rate codes against standard rate type ids
                Map<String, Id> rateCodeRateType = new Map<String, Id>();
                List<sirenum__Standard_Rate_Type__c> rateTypes = [SELECT Id, sirenum__Rate_Code__c
                                                                  FROM   sirenum__Standard_Rate_Type__c];
                for (sirenum__Standard_Rate_Type__c rateType : rateTypes) {
                    rateCodeRateType.put(rateType.sirenum__Rate_Code__c, rateType.Id);
                }

                // New records
                List<sirenum__Rate_Card__c> newRateCardRecords = new List<sirenum__Rate_Card__c>();
                List<sirenum__Rate_Card_Page__c> newRateCardPageRecords = new List<sirenum__Rate_Card_Page__c>();
                List<sirenum__Rate_Line__c> newRateLineRecords = new List<sirenum__Rate_Line__c>();
                
                // New wrapper classes
                List<CreateRateCardFromCostMatrix.RateCard> newRateCards = new List<CreateRateCardFromCostMatrix.RateCard>();
                List<CreateRateCardFromCostMatrix.RateCardPage> newRateCardPages = new List<CreateRateCardFromCostMatrix.RateCardPage>();
                List<CreateRateCardFromCostMatrix.RateLine> newRateLines = new List<CreateRateCardFromCostMatrix.RateLine>();
                
                // Retrieve job roles
                List<Id> jobRoleIds = new List<Id>();
                for (sirenum__PayrollCostMatrixFrame__c costMatrixFrame : costMatrixFrames) {
                    jobRoleIds.add(costMatrixFrame.sirenum__Job_Role__c);
                }
                Map<Id, sirenum__Team__c> jobRoles = new Map<Id, sirenum__Team__c>(
                    [SELECT Id, Name, sirenum__Rate_Card__c
                     FROM   sirenum__Team__c
                     WHERE  Id IN :jobRoleIds]);
                
                // Map Job Role Ids to Rate Cards
                Map<Id, sirenum__Rate_Card__c> jobRoleIdRateCard = new Map<Id, sirenum__Rate_Card__c>();
                
                // Map Cost Matrix Frames Ids to Rate Cards
                Map<Id, CreateRateCardFromCostMatrix.RateCard> costMatrixFrameIdRateCard = new Map<Id, CreateRateCardFromCostMatrix.RateCard>();
                
                // Create rate card for each cost matrix frame
                for (sirenum__PayrollCostMatrixFrame__c costMatrixFrame : costMatrixFrames) {                
                    sirenum__Rate_Card__c newRateCardRecord = new sirenum__Rate_Card__c(
                        Name                   = jobRoles.get(costMatrixFrame.sirenum__Job_Role__c).Name,
                        IP_AcountLinkCustom__c = costMatrixFrame.sirenum__Job_Role__r.sirenum__Account__r.sirenum__Client__c);
                    CreateRateCardFromCostMatrix.RateCard newRateCard = new CreateRateCardFromCostMatrix.RateCard(newRateCardRecord);
                    newRateCards.add(newRateCard);
                    newRateCardRecords.add(newRateCardRecord);
                    jobRoleIdRateCard.put(costMatrixFrame.sirenum__Job_Role__c, newRateCardRecord);
                    costMatrixFrameIdRateCard.put(costMatrixFrame.Id, newRateCard);
                }

                // Insert rate cards
                Database.insert(newRateCardRecords);
                
                // Update job roles to reference rate card
                List<sirenum__Team__c> jobRolesToUpdate = jobRoles.values();
                for (sirenum__Team__c jobRoleToUpdate : jobRolesToUpdate) {
                    jobRoleToUpdate.sirenum__Rate_Card__c = jobRoleIdRateCard.get(jobRoleToUpdate.Id).Id;
                }
                Database.update(jobRolesToUpdate);

                for (sirenum__PayrollCostMatrixFrame__c costMatrixFrame : costMatrixFrames) {

                    CreateRateCardFromCostMatrix.RateCard rateCard = costMatrixFrameIdRateCard.get(costMatrixFrame.Id);
                
                    // Group cost matrix lines by contact and start/end date
                    List<String> contactDateKeys = new List<string>();
                    Map<String, List<sirenum__PayrollCostMatrix__c>> contactDateCostMatrices = new Map<String, List<sirenum__PayrollCostMatrix__c>>();
                    for (sirenum__PayrollCostMatrix__c costMatrix : costMatrixFrame.sirenum__Payroll_Cost_Matrices__r){

                        String startDate = '';
                        if (costMatrix.sirenum__Start_date__c != null) {
                            startDate = String.valueof(costMatrix.sirenum__Start_date__c.year()) 
                                      + String.valueof(costMatrix.sirenum__Start_date__c.month())
                                      + String.valueof(costMatrix.sirenum__Start_date__c.day());
                        }
                        
                        String endDate = '';
                        if (costMatrix.sirenum__End_date__c != null) {
                            endDate = String.valueof(costMatrix.sirenum__End_date__c.year()) 
                                    + String.valueof(costMatrix.sirenum__End_date__c.month())
                                    + String.valueof(costMatrix.sirenum__End_date__c.day());
                        }
                        
                        String contactDateKey = 'C' + costMatrix.sirenum__Contact__c + 'S' + startDate + 'E' + endDate;

                        if (!contactDateCostMatrices.containsKey(contactDateKey)) {
                            contactDateCostMatrices.put(contactDateKey, new List<sirenum__PayrollCostMatrix__c>());
                            contactDateKeys.add(contactDateKey);
                        }
                        contactDateCostMatrices.get(contactDateKey).add(costMatrix);
                    }
                    
                    // Create rate card pages and lines
                    Integer rateCardPageSortOrder = 0;
                    for (String contactDateKey : contactDateKeys) {
                        List<sirenum__PayrollCostMatrix__c> costMatrices = contactDateCostMatrices.get(contactDateKey); 
                        sirenum__Rate_Card_Page__c rateCardPageRecord = new sirenum__Rate_Card_Page__c
                            (sirenum__Rate_Card__c                = rateCard.sfdc.Id,
                             sirenum__Rate_Type__c                = costMatrices.get(0).sirenum__RateType__c,
                             sirenum__SortOrder__c                = rateCardPageSortOrder,
                             sirenum__Daily_Overtime_Treshold__c  = costMatrixFrame.sirenum__Daily_Overtime_Threshold__c,
                             sirenum__Weekly_Overtime_Treshold__c = costMatrixFrame.sirenum__Weekly_Overtime_Threshold__c,
                             sirenum__Valid_From_Date__c          = costMatrices.get(0).sirenum__Start_date__c,
                             sirenum__Valid_Until_Date__c         = costMatrices.get(0).sirenum__End_date__c);
                        
                        // Set rate card page name based on contact and start/end dates
                        String startDate = null;
                        if (costMatrices.get(0).sirenum__Start_date__c != null) {
                            startDate = String.valueof(costMatrices.get(0).sirenum__Start_date__c.day()).leftPad(2, '0')   + '/' 
                                      + String.valueof(costMatrices.get(0).sirenum__Start_date__c.month()).leftPad(2, '0') + '/'
                                      + String.valueof(costMatrices.get(0).sirenum__Start_date__c.year());
                        }
                        
                        String endDate = null;
                        if (costMatrices.get(0).sirenum__End_date__c != null) {
                            endDate = String.valueof(costMatrices.get(0).sirenum__End_date__c.day()).leftPad(2, '0')   + '/'
                                    + String.valueof(costMatrices.get(0).sirenum__End_date__c.month()).leftPad(2, '0') + '/'
                                    + String.valueof(costMatrices.get(0).sirenum__End_date__c.year());
                        }

                        if (costMatrices.get(0).sirenum__Contact__c != null) {
                            rateCardPageRecord.Name = costMatrices.get(0).sirenum__Contact__r.Name;
                        } else if (startDate != null && endDate == null) {
                            rateCardPageRecord.Name = 'From:' + startDate;
                        } else if (startDate == null && endDate != null) {
                            rateCardPageRecord.Name = 'To:' + endDate;
                        } else if (startDate != null && endDate != null) {
                            rateCardPageRecord.Name = startDate + ':' + endDate;
                        } else {
                            rateCardPageRecord.Name = 'Default';
                        }

                        // Add contact condition
                        if (costMatrices.get(0).sirenum__Contact__c != null) {
                            rateCardPageRecord.sirenum__Condition_Field__c       = 'Contact__c';
                            rateCardPageRecord.sirenum__Condition_Operator__c    = 'Equal to';
                            rateCardPageRecord.sirenum__Condition_Suggestions__c = 'Contact__c';
                            rateCardPageRecord.sirenum__Condition_value__c       = costMatrices.get(0).sirenum__Contact__c;
                        }
                        
                        CreateRateCardFromCostMatrix.RateCardPage rateCardPage = new CreateRateCardFromCostMatrix.RateCardPage(rateCardPageRecord);
                        newRateCardPages.add(rateCardPage);
                        newRateCardPageRecords.add(rateCardPageRecord);
                        rateCard.add(rateCardPage);
                        
                        Integer rateLineSortOrder = 0;
                        for (sirenum__PayrollCostMatrix__c costMatrix : costMatrices) {
                            sirenum__Rate_Line__c rateLineRecord = new sirenum__Rate_Line__c
                                (sirenum__Charge_Rate__c          = costMatrix.sirenum__Income_per_Hour__c,
                                 sirenum__Code__c                 = costMatrix.Rate_code__c,
                                 sirenum__End_Hour__c             = costMatrix.sirenum__End_Hour__c,
                                 sirenum__Overtime_Charge_Rate__c = costMatrix.sirenum__Overtime_Charge_Rate__c,
                                 sirenum__Overtime_Pay_Rate__c    = costMatrix.sirenum__Overtime_Pay_Rate__c,
                                 sirenum__Pay_Rate__c             = costMatrix.sirenum__Cost_per_Hour__c,
                                 sirenum__SortOrder__c            = rateLineSortOrder,
                                 sirenum__Standard_Rate_Type__c   = rateCodeRateType.get(costMatrix.Rate_code__c),
                                 sirenum__Start_Hour__c           = costMatrix.sirenum__Start_Hour__c);
                                 
                            if (costMatrix.sirenum__Day_Type__c == 'Any'){
                                rateLineRecord.sirenum__Day_Type__c = 'Any Day';
                            } else {
                                rateLineRecord.sirenum__Day_Type__c = costMatrix.sirenum__Day_Type__c;
                            }
                            
                                 
                            CreateRateCardFromCostMatrix.RateLine rateLine = new CreateRateCardFromCostMatrix.RateLine(rateLineRecord);
                            newRateLines.add(rateLine);
                            newRateLineRecords.add(rateLineRecord);
                            rateCardPage.add(rateLine);

                            rateLineSortOrder++;                        
                        }
                        
                        rateCardPageSortOrder++;                        
                    }

                    // Update cost matrices to reference rate card so that they are not processed again
                    costMatrixFrame.Rate_Card__c = costMatrixFrameIdRateCard.get(costMatrixFrame.Id).sfdc.Id;
                }
                
                // Insert rate card pages
                Database.insert(newRateCardPageRecords);
                
                // Insert rate lines now that the parent rate card pages have been inetred and have ids
                for (CreateRateCardFromCostMatrix.RateLine rateLine : newRateLines) {
                    rateLine.sfdc.sirenum__Rate_Card_Page__c = rateLine.parent.sfdc.Id;
                }
                Database.insert(newRateLineRecords);
                
                Database.update(costMatrixFrames);

            } // if (costMatrixFrames.size() > 0) 

        } // try
        
        catch (Exception e) {
            throw new StringException(e.getMessage() + ' - ' + e.getLineNumber());
        }
    }

    public class RateCard {
        public sirenum__Rate_Card__c sfdc;
        public List<RateCardPage> pages;

        public RateCard(sirenum__Rate_Card__c sfdc) {
            this.sfdc = sfdc;
            this.pages = new List<RateCardPage>();
        }

        public void add(RateCardPage p) {
            this.pages.add(p);
            p.parent = this;
        }
    }

    public class RateCardPage {
        public sirenum__Rate_Card_Page__c sfdc;
        public List<RateLine> lines;
        public RateCard parent;

        public RateCardPage(sirenum__Rate_Card_Page__c sfdc) {
            this.sfdc = sfdc;
            this.lines = new List<RateLine>();
        }

        public void add(RateLine l) {
            this.lines.add(l);
            l.parent = this;
        }
    }

    public class RateLine {
        public sirenum__Rate_Line__c sfdc;
        public RateCardPage parent;

        public RateLine(sirenum__Rate_Line__c sfdc) {
            this.sfdc = sfdc;
        }
    }
}