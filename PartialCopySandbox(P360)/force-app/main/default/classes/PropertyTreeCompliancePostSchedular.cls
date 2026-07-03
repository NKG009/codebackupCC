public class PropertyTreeCompliancePostSchedular implements schedulable{
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new PropertyTreeCompliancePostBatch2(),1);
        
    }

}