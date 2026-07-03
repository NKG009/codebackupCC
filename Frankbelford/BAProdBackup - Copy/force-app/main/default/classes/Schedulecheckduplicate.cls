global class Schedulecheckduplicate implements Schedulable{
 global void execute(SchedulableContext SC) {
      Checkduplicatebatch checkduplicate = new Checkduplicatebatch(); 
      database.executebatch(checkduplicate,1);

   }
    
    
}