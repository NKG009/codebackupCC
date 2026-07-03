/*
* Class Name: CreateCommunityBackgroundCheckCompetency
* Description: Class to update the Community Background Data on Candidate
* Test Class : TestCommunityBackgroundCheckCompetency
* Date : 21th Nov 2019
*/
public class CreateCommunityBackgroundCheckCompetency{
    
    private static final string COMMUNITY_BACKGROUND_CHECK = 'Community Background Check';
    
    /*
    * Method Name: sendEmail
    * Description: Method to update the Community Background Data on Candidate
    * Parameters : List<String> listCandidateId
    * Return Type: nothing
    */
    @InvocableMethod
    public static void sendEmail(List<String> listCandidateId){
        Map<Id,List<sirenum__Ticket__c>> mapCandidateIdCompetency = new Map<Id,List<sirenum__Ticket__c>>();
        List<sirenum__Ticket__c> listCompetencyInsert = new List<sirenum__Ticket__c>();
        List<sirenum__Ticket__c> listCompetencyUpdate = new List<sirenum__Ticket__c>();
        try{
            List<sirenum__TicketType__c> communitBackGroundCompetency = [Select id from sirenum__TicketType__c 
                                                        where Name=:COMMUNITY_BACKGROUND_CHECK limit 1];
            if(!communitBackGroundCompetency.isEmpty()){                                            
                for(Contact candidate : [Select id,(Select id,sirenum__Valid__c,sirenum__Valid_from__c,sirenum__Valid_until__c 
                                        from sirenum__Tickets__r where sirenum__TicketType__r.Name=:COMMUNITY_BACKGROUND_CHECK) 
                                    from Contact where Id IN : listCandidateId]){
                    mapCandidateIdCompetency.put(candidate.id,candidate.sirenum__Tickets__r);                   
                }
                system.debug('+++++mapCandidateIdCompetency+++++++++'+mapCandidateIdCompetency);
                if(!mapCandidateIdCompetency.isEmpty()){
                    for(Id candidateId : mapCandidateIdCompetency.keySet()){
                        if(!mapCandidateIdCompetency.isEmpty() && mapCandidateIdCompetency.get(candidateId)!=null
                        && mapCandidateIdCompetency.get(candidateId).size()>0){
                            sirenum__Ticket__c competency = new sirenum__Ticket__c(Id=mapCandidateIdCompetency.get(candidateId)[0].Id);
                            //competency.sirenum__Valid__c = true;
                            competency.sirenum__Valid_from__c = System.today();
                            listCompetencyUpdate.add(competency);
                        }
                        else{
                            sirenum__Ticket__c competency = new sirenum__Ticket__c();
                            competency.sirenum__TicketType__c = communitBackGroundCompetency[0].id;                         
                            competency.sirenum__Owner__c = candidateId;
                            //competency.sirenum__Valid__c = true;
                            competency.sirenum__Valid_from__c = System.today();
                            listCompetencyInsert.add(competency);
                        }
                    }
                }
                if(!listCompetencyInsert.isEmpty()){
                    insert listCompetencyInsert;
                }
                if(!listCompetencyUpdate.isEmpty()){
                    update listCompetencyUpdate;
                }
            }
        }
        catch(Exception e) {
        }
    }
    
}