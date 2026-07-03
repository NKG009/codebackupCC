trigger AWRTrigger on sirenum__AWR__c (before update) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
        List<sirenum__AWR__c> newAWR = Trigger.new;
       // List<sirenum__AWR__c> oldAWR = Trigger.old;
        
        List<sirenum__AWR__c> awr = [ select id, name, sirenum__Client__c from sirenum__AWR__c where id in:Trigger.new];
        
        List<sirenum__ProActiveContract__c> contract =[select id, name, sirenum__Client__c,sirenum__PayrollCycle__r.Name from sirenum__ProActiveContract__c where sirenum__Client__c =:awr[0].sirenum__Client__c];
        
        System.debug('value in contract '+ contract);
        
        // List<sirenum__Team__c> jobRole = [select id, name, sirenum__Account__r.sirenum__PayrollCycle__c
        //                                 from sirenum__Team__c  limit 1];
        
        //system.debug('-----jobRole-----'+jobRole);                                
        system.debug('Size-->'+newAWR.size());
        // system.debug('Size-->'+jobRole.size()); 
        // System.debug('----sirenium payroll----'+jobRole[0].sirenum__Account__r.sirenum__PayrollCycle__c);
        if(contract!=null && contract.size() > 0 && newAWR!=null && newAWR.size() > 0){
            system.debug('Got the Job Role');
            
            if(contract[0].sirenum__PayrollCycle__r.Name == 'Saturday to Friday'){
                System.debug('-----swati virmani in 1------');
                for(integer i = 0; i< newAWR.size();i++){
                    
                    System.debug('In forr');
                    if(newAWR[i].sirenum__Valid_From__c != null){
                        
                        System.debug('In if after forr');
                        
                        date myDate = newAWR[i].sirenum__Valid_From__c;
                        system.debug('-----myDate----'+myDate);
                        date weekStart = (myDate.toStartofWeek())-2;
                        
                        system.debug('----myDate.toStartofWeek()-----'+myDate.toStartofWeek());
                        System.debug('Date'+ weekStart);
                        system.debug('----counter----'+i);
                        newAWR[i].sirenum__Valid_From__c = weekStart;
                        
                        system.debug('diff---->'+ myDate.daysBetween(weekStart));
                        if(weekStart.daysBetween(myDate)  == 7){
                            
                            newAWR[i].sirenum__Valid_From__c =  myDate;
                        }
                        
                        
                        
                    }
                   
                }
                
            }
            
            if(contract[0].sirenum__PayrollCycle__r.Name == 'Sunday to Saturday'){
                System.debug('-----swati virmani in 2------');
                for(integer i = 0; i< newAWR.size();i++){
                    
                    System.debug('In forr');
                    if(newAWR[i].sirenum__Valid_From__c != null){
                        
                        System.debug('In if after forr');
                        
                        date myDate = newAWR[i].sirenum__Valid_From__c;
                        system.debug('myDate.toStartofWeek()'+ myDate.toStartofWeek());
                        date weekStart = myDate.toStartofWeek()-1;
                        System.debug('Date'+ weekStart);
                        
                        newAWR[i].sirenum__Valid_From__c = weekStart;
                        
                        if(weekStart.daysBetween(myDate)  == 7){
                            
                            newAWR[i].sirenum__Valid_From__c =  myDate;
                        }
                    }
                }
                
            }
            
            if(contract[0].sirenum__PayrollCycle__r.Name == 'Monday to Sunday'){
                System.debug('-----swati virmani in 3------');
                for(integer i = 0; i< newAWR.size();i++){
                    
                    System.debug('In forr');
                    if(newAWR[i].sirenum__Valid_From__c != null){
                        
                        System.debug('In if after forr');
                        
                        date myDate = newAWR[i].sirenum__Valid_From__c;
                        date weekStart = myDate.toStartofWeek();
                        System.debug('Date'+ weekStart);
                        
                        newAWR[i].sirenum__Valid_From__c = weekStart;
                        
                        if(weekStart.daysBetween(myDate)  == 7){
                            
                            newAWR[i].sirenum__Valid_From__c =  myDate;
                        }
                    }
                }
                
            }
            
        }
    }
}