global class ScheduleCriminalConvictionDetails implements Schedulable{
    
    global void execute(SchedulableContext sc){
        
        UpdateCriminalConvictionDetails ucd = new UpdateCriminalConvictionDetails();
        Database.executeBatch(ucd);
        
    }


}