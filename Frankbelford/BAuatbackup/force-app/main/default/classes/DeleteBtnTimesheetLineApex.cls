public without sharing  class DeleteBtnTimesheetLineApex {
    public static Boolean check{get; set;}
    
    public DeleteBtnTimesheetLineApex() {
        check = false;
    }
    
    @AuraEnabled
    public static string  deletemethod(string Iddel)
    {    Decimal rowCount;
        Set<id> deleteid = new Set<id>();
        Set<id> timeid = new Set<id>();
        Set<id> deleterelatedsset = new Set<id>();
        List<IP_OutboundDataTransfer__c> dellist = new List<IP_OutboundDataTransfer__c>();
        string Message='';
        Map<id,id> timeoutbound = new Map<id,id>();
        Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        sirenum__Timesheet_Line__c TSL = [Select id,IP_Locktimesheet__c,IP_OutboundID__c,sirenum__Timesheet__c from sirenum__Timesheet_Line__c where id =: Iddel limit 1];
        
        List<IP_OutboundDataTransfer__c> existingoutbound = [Select id,IP_Passed__c,IP_OriginRecordID__c from IP_OutboundDataTransfer__c where IP_TransferType__c = 'Timesheet' and IP_OriginRecordID__c =: TSL.id and IP_Passed__c !=null];
        
        if(existingoutbound.size()>0)
        {
            for(IP_OutboundDataTransfer__c ot: existingoutbound)
            {                timeoutbound.put(ot.IP_OriginRecordID__c,ot.id);
            } 
        }
        
        try{
            
            if( UserInfo.getProfileId() != adminId.id)
            {
                // for(sirenum__Timesheet_Line__c sheetline : [SELECT Id,sirenum__Timesheet__r.IP_TSLinesWithGUIDs__c,sirenum__Timesheet__r.IP_TSLinesPassedToTempest__c FROM sirenum__Timesheet_Line__c WHERE Id =:TSL.id])
                List<sirenum__Timesheet_Line__c> sheetlinelist = [SELECT Id,sirenum__Timesheet__r.sirenum__Lines__c,IP_Locktimesheet__c,IP_OutboundID__c,sirenum__Timesheet__c,IP_LastPassedtoTempest__c FROM sirenum__Timesheet_Line__c WHERE Id =:TSL.id];
                
                for(sirenum__Timesheet_Line__c sheetline : sheetlinelist)
                {
                    if(sheetline.IP_Locktimesheet__c == TRUE || sheetline.IP_LastPassedtoTempest__c!=null || (existingoutbound.size()>0 && timeoutbound.containsKey(sheetline.id)))
                    {
                        
                        check = true;                        Message='Timesheet line cannot be Deleted, as the data has been Passed to Tempest';
                    }
                    else
                    {
                         rowCount = sheetline.sirenum__Timesheet__r.sirenum__Lines__c;
                        deleteid.add(tsl.IP_OutboundID__c);
                        timeid.add(tsl.sirenum__Timesheet__c);
                        delete TSL;
                    }
                }
            }
            else
            {
                deleteid.add(tsl.IP_OutboundID__c);
                timeid.add(tsl.sirenum__Timesheet__c);
                delete TSL;
                
            }
        }
        catch(Exception e)
        { 
            
            deleteid.remove(Iddel);            check = true;             Message='You cannot delete the Timesheet line.Please Contact your System Admin';
        } 
        if(check != true)
        {
            if(!deleteid.isEmpty())
            {
                dellist = [Select id from IP_OutboundDataTransfer__c where id in: deleteid];
                
            }
            if(dellist.size()>0)
            {
                delete dellist;  
            }
            List<IP_OutboundDataTransfer__c> checklist = [Select id,IP_TransferType__c,IP_TimesheetID__c from IP_OutboundDataTransfer__c where IP_TransferType__c = 'Timesheet' and IP_TimesheetID__c in: timeid];
            if(checklist.size() == 0)
            {
                
                List<IP_OutboundDataTransfer__c> deleterelated = [Select id from IP_OutboundDataTransfer__c where IP_TimesheetID__c in: timeid];
                
                if(deleterelated.size()>0)
                {
                    for(IP_OutboundDataTransfer__c o: deleterelated )
                    {
                        deleterelatedsset.add(o.id); 
                    }
                    UpdateRelateddateLink.deleteupdatedata(deleterelatedsset);
                }
                
            }
              else{
                    System.debug('IN Else');
              //   List<sirenum__Timesheet__c> sheetlist = [Select id,sirenum__Lines__c from sirenum__Timesheet__c where id in: timeid ];
                Map<Id,Decimal> timeMap = new Map<Id,Decimal>();
                for(sirenum__Timesheet__c st:[Select id,sirenum__Lines__c from sirenum__Timesheet__c where id in: timeid ]){
                  timeMap.put(st.Id,st.sirenum__Lines__c);
                  
                }
                      System.debug('timeMap$ '+timeMap);
                for(IP_OutboundDataTransfer__c op :checklist){
                    if(timeMap.containsKey(op.IP_TimesheetID__c))
                    {
                      op.IP_RowCount__c = timeMap.get(op.IP_TimesheetID__c);
                    }
                    
                  }
                  update checklist;
                  
    }
        }
        if(Message=='')
        {
            Message = 'Successfully Deleted';            
        }
        return Message;
    }
    
    
}