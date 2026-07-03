trigger ShiftTriggerV2 on sirenum__Shift__c (before Update, before insert,after update) {
    //List<sirenum__Shift__c> shiftid =new List<sirenum__Shift__c>();
    Set<ID> sftid = new Set<ID>();
    Map<id,Boolean> tlmap = new Map<id,Boolean>();
    for(sirenum__Shift__c sft:Trigger.new){
        sftid.add(sft.id) ;
      
    }
    Profile p = [Select id from Profile where name = 'System Administrator' limit 1];
    Map<Id, sirenum__Shift__c> shifts = new Map<Id, sirenum__Shift__c>();
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        
        Set<ID> placementIds = new Set<ID>();
        for(sirenum__Shift__c ss:Trigger.New){
            placementIds.add(ss.sirenum__Placement__c);
           
        }
        
        List<sirenum__Placement__c> placementRecords = [select id, name, IP_PayrollStatus__c,IP_PayMethod__c,IP_PayMethod__r.RecordType.Name,IP_PayMethod__r.IP_PrimaryPayMethod__c,
                                                        sirenum__Contact__r.IP_MCPAYE__c,
                                                        sirenum__Contact__r.IP_MCLTD__c,
                                                        sirenum__Contact__r.IP_MCUmb__c
                                                        from sirenum__Placement__c where id in : placementIds];
        
        system.debug('Placement Record-->' + placementRecords);
        for(sirenum__Shift__c ss:Trigger.New){
            if(ss.sirenum__Cancelled__c == Trigger.oldMap.get(ss.Id).sirenum__Cancelled__c && ss.sirenum__CancellationReason__c == Trigger.oldMap.get(ss.Id).sirenum__CancellationReason__c && ss.IP_CancellationTime__c == Trigger.oldMap.get(ss.Id).IP_CancellationTime__c)
            {
            if(ss.sirenum__Allow_charge__c || ss.sirenum__Allow_pay__c){
                if(ss.sirenum__Placement__c != null){
                    for(sirenum__Placement__c pp : placementRecords){
                     
                        if(ss.sirenum__Placement__c == pp.id && pp.IP_PayMethod__r.IP_PrimaryPayMethod__c && UserInfo.getProfileId() != p.Id && ((pp.IP_PayMethod__r.Recordtype.name == 'PAYE' && pp.sirenum__Contact__r.IP_MCPAYE__c!=null) ||
                                                                                                              (pp.IP_PayMethod__r.Recordtype.name == 'LTD' && 
                                                                                                               pp.sirenum__Contact__r.IP_MCLTD__c!=null)||(pp.IP_PayMethod__r.Recordtype.name == 'Umbrella' && pp.sirenum__Contact__r.IP_MCUmb__c!=null)))
{
                                                                                                                   system.debug('Match'+pp.IP_PayMethod__r.IP_PrimaryPayMethod__c);
                                                                                                                   ss.addError('There is missing compliance detail on the candidate for this shift therefore it cannot be processed for Pay and Charge');
                                                                                                               }
                        else if(ss.sirenum__Placement__c == pp.id && pp.IP_PayrollStatus__c!=null && UserInfo.getProfileId() != p.Id){
                           
                            ss.addError('There is missing detail on the placement for this shift therefore it cannot be processed for Pay and Charge');
                        }
                    }
                }
                else{
          if(UserInfo.getProfileId() != p.Id){
                    ss.addError('There is missing detail on the placement for this shift therefore it cannot be processed for Pay and Charge');}
                }
            }
            }
        }  
    }
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        Profile adminId1 = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        if(UserInfo.getProfileId() != adminId1.id)
        {
            for(sirenum__Shift__c ss:Trigger.New){
                system.debug('@@ sirenum__Shift__c' +ss.sirenum__Team__c+ ' !! '+ss.sirenum__Team__r.sirenum__Rota__c);
                if(ss.sirenum__Team__c!=null && ss.sirenum__Team__r.sirenum__Rota__c !=null)                ss.sirenum__Rota__c = ss.sirenum__Team__r.sirenum__Rota__c;
                
                if(ss.sirenum__Timesheet_summaries__c != NULL && ss.sirenum__Cancelled__c==TRUE && UserInfo.getProfileId() != p.Id)
                {
                    System.debug('Stranger things'+ss.sirenum__Timesheet_summaries__c);
                    ss.adderror('You cannot cancel a shift that has a timesheet');
                    
                }
            }
        }
    }
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        System.debug('Inside After Update');
        Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        List<sirenum__timesheet_line__c> tllines = [Select id, sirenum__Shift__c, sirenum__Shift__r.sirenum__cancelled__c from sirenum__timesheet_line__c where sirenum__Shift__c in: Trigger.new];
        System.debug('Tl List'+tllines);
        for(sirenum__timesheet_line__c tl: tllines)
        {
            tlmap.put(tl.sirenum__Shift__c, tl.sirenum__Shift__r.sirenum__cancelled__c);
        }
        System.debug('Tl map'+tlmap);
        if(UserInfo.getProfileId() != adminId.id)
        {
            for(integer i=0;i<trigger.new.size();i++){
                
                if(tlmap.get(Trigger.new[i].id) == TRUE && UserInfo.getProfileId() != p.Id)
                {
                    trigger.new[i].adderror('You cannot cancel a shift that has timesheet lines');
                }
                
                
            }
        }
    }
    
    
}