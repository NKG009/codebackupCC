public class PropertyTreeInvoicePostSchedular implements schedulable{
    
     public void execute(SchedulableContext sc){
        Database.executeBatch(new PropertyTreeInvoicePostBatch(),1);
        
    }

}