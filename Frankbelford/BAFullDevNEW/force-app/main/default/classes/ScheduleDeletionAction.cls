global class ScheduleDeletionAction implements schedulable{
 
    global void execute(SchedulableContext sc){
        
        DeletionAction DA = new DeletionAction();
        database.executebatch(DA,1);
        
    }


}