public class TicketsBatch implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.stateful{
    public Zendesk_Ticket_Details__c custSet = [Select Ticket_Start_Id__c,TempVar__c,Ticket_End_Id__c from Zendesk_Ticket_Details__c];
    public integer startTicketId =0;
    public Integer endTicketNumber = 0;
    public integer tempVar = 0;
    public Iterable<Integer> start(Database.BatchableContext bcs){ 
        List<Integer> ticketNumbers = new List<Integer>();
        if(custSet.Ticket_Start_Id__c.isNumeric()){
            startTicketId = Integer.valueOf(custSet.Ticket_Start_Id__c.subString(0));
        }
        if(custSet.Ticket_End_Id__c.isNumeric()){
            endTicketNumber = Integer.valueOf(custSet.Ticket_End_Id__c.subString(0));
        }
        if(custSet.TempVar__c.isNumeric()){
            tempVar = Integer.valueOf(custSet.TempVar__c.subString(0));
        }
        for (Integer i = startTicketId; i <= tempVar; i++) {
            ticketNumbers.add(i);
        }
        return  ticketNumbers;
    }
    
    public void execute(Database.BatchableContext bce, List<Integer> ticketNumbers){
        System.debug(ticketNumbers);
        Set<String> zdIds = new Set<String>();
        for(Integer i : ticketNumbers){
            zdIds.add(String.valueOf(i));
        }
        List<Case> cases = [Select id, Zendesk_Ticket_Id__c from Case where Zendesk_Ticket_Id__c in: zdIds];
        for(Integer i : ticketNumbers){
            if(cases.isEmpty()){
                CommentsCallOut.basicAuthCallout(new List<Integer>{i}); 
            } 
        }        
    }
    
    public void finish(Database.BatchableContext bcf){
        System.debug('finish method');
        startTicketId = startTicketId +1;
        tempVar = tempVar +1;
        custSet.TempVar__c = String.valueOf(tempVar);
        custSet.Ticket_Start_Id__c = String.valueOf(startTicketId);
		update custSet;
        if(tempVar <= endTicketNumber){
            System.debug('temp var is less than end');
            Database.executeBatch(new TicketsBatch(),1);
        }
    }
    
}