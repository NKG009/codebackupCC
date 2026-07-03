global class Schedule_PortalUserDisable implements schedulable{
 
    global void execute(SchedulableContext sc){
        
        Portaluserdisable DA = new Portaluserdisable();
        database.executebatch(DA,100);
        
    }


}