public class PropertyTreeComplianceWrapper {
    
    public General_details general_details;
    public String smoke_alarm_type;
    
    public PropertyTreeComplianceWrapper(workorder wo,String wtcategory,Agency_Integration_Info__c AIIrec,boolean create){
        this.general_details= new General_details(wo,wtcategory,AIIrec,create);
        if(wtcategory=='Smoke Alarm'){
            this.smoke_alarm_type=wo.Account.SmokeAlarmType__c;
        }
    }
    
    public class General_details {
        public String management_id;
        public String category_id;
        public String managed_by='Agent';
        public String serviced_by_creditor_id;
        public String authority_form='Received';
        //public Frequency frequency;
        //public Frequency reminder;
        public datetime expiry_date;
        public datetime last_service_date;
        public datetime next_service_date;
        public String notes='Updated by Property Services 360';
        public String pinned_to_entity_type;
        
        public General_details(workorder wo,String wtcategory,Agency_Integration_Info__c AIIrec,boolean create){
            if(create){
            this.management_id=wo.Account.Management_ID__c;
            this.pinned_to_entity_type='Property';
            this.notes='Draft Compliance';
            }
            this.serviced_by_creditor_id=AIIrec.CreditorId__c;
            if(wtcategory=='Smoke Alarm'){
                if(create){
                this.category_id=AIIrec.Smoke__c;
                }
                this.expiry_date=this.next_service_date=wo.Account.Next_Service_Date__c;
                this.last_service_date=wo.Account.Last_Service_Date__c;
                          
            }
            
            if(wtcategory=='Water Efficiency'){
                if(create){
                this.category_id=AIIrec.Water__c;
                }
                this.expiry_date=this.next_service_date=null;
                this.last_service_date=wo.Account.LastWaterDate__c;          
            }
            
            if(wtcategory=='Safety Switch'){
                if(create){
                this.category_id=AIIrec.Safety__c;
                }
                this.expiry_date=this.next_service_date=wo.Account.NextSafetyDate__c;
                this.last_service_date=wo.Account.LastSafetyDate__c; 
            }
            
            if(wtcategory=='Corded Blinds'){
                if(create){
                this.category_id=AIIrec.Blinds__c;
                }
                this.expiry_date=this.next_service_date=wo.Account.NextBlindsDate__c; 
                this.last_service_date=wo.Account.LastBlindsDate__c;
                         
            }
            
            if(wtcategory=='Pool Compliance'){
                if(create){
                this.category_id=AIIrec.Pool__c;
                }
                this.expiry_date=this.next_service_date=wo.Account.NextPoolDate__c;
                this.last_service_date=wo.Account.LastPoolDate__c;
                           
            }    
            
            
        }
    }
    
}