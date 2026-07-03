public class TestHelper_Opportunity {

    public static Opportunity createOpportunity(String name, Id accountId, Boolean insertRecord){
        
        Opportunity opp = new Opportunity();
        opp.Name = name;
        opp.AccountId = accountId;
        opp.CloseDate = Date.today().addMonths(1);
        opp.StageName = TestUtil.OPPORTUNITY_STAGE_QUALIFICATION;
        opp.Opp_Customer_Category__c = 'SMB';
        opp.Opportunity_Source__c = 'Inbound Call';
        opp.Inbound_Call_Source__c = 'OTHER';
        
        if(insertRecord){
        	insert opp;
        }

        return opp;
    }
}