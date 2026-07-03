public class RestrictDeleteActionTLController {
     public static final string lightningTheme ='Theme4d';
    public  String Iddel;
    public  String parentId;
    public  String failparentId;
    public String reportsURL{get; set; } 
    public String BackURL{get; set; } 
    public String urlparent;
      public String urlparent2;
  public Decimal rowCount;
    public Boolean check{get; set;}
    Set<id> deleteid = new Set<id>();
      Set<id> timeid = new Set<id>();
                Set<id> deleterelatedsset = new Set<id>();
      List<IP_OutboundDataTransfer__c> dellist = new List<IP_OutboundDataTransfer__c>();
    public RestrictDeleteActionTLController(ApexPages.StandardController controller) {
     urlparent2 =Label.Instance_URLLightning;
        check = false;
        Iddel = ApexPages.currentPage().getParameters().get('id');
        parentId = ApexPages.currentPage().getParameters().get('retURL');
        failparentId=ApexPages.currentPage().getParameters().get('failRetURL');
        urlparent = Label.Instance_URL;
        if(failparentId==null)
        {
            failparentId=parentId;
        }
    }
      public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    public void deletemethod()
    { 
      String getLightning = getContextUserUiThemeDisplayed();
     List<String> TlId = new List<String>();
     String startId;
     System.debug('Iddel@ '+Iddel);
        Map<id,id> timeoutbound = new Map<id,id>();
        Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
       sirenum__Timesheet_Line__c TSL = [Select id,sirenum__Timesheet__r.id,IP_Locktimesheet__c,IP_OutboundID__c,sirenum__Timesheet__c,sirenum__Timesheet__r.sirenum__Lines__c from sirenum__Timesheet_Line__c where id =: Iddel limit 1];
        List<IP_OutboundDataTransfer__c> existingoutbound = [Select id,IP_Passed__c,IP_OriginRecordID__c from IP_OutboundDataTransfer__c where IP_TransferType__c = 'Timesheet' and IP_OriginRecordID__c =: TSL.id and IP_Passed__c !=null];
        System.debug('check existing data'+existingoutbound );
        if(existingoutbound.size()>0)
        {
        for(IP_OutboundDataTransfer__c ot: existingoutbound)
        {
            timeoutbound.put(ot.IP_OriginRecordID__c,ot.id);
        }
        }
        System.debug('check existing map'+timeoutbound);
        try{
            if(!String.isEmpty(parentId)){
     system.debug('TEStparentId '+parentId);
        TlId = parentId.split('/');
        system.debug('TESt '+TlId);
         startId = parentId.substring(1,4);
    }
    else {  parentId = TSL.sirenum__Timesheet__r.Id;} 
            if( UserInfo.getProfileId() != adminId.id)
            {
               // for(sirenum__Timesheet_Line__c sheetline : [SELECT Id,sirenum__Timesheet__r.IP_TSLinesWithGUIDs__c,sirenum__Timesheet__r.IP_TSLinesPassedToTempest__c FROM sirenum__Timesheet_Line__c WHERE Id =:TSL.id])
                List<sirenum__Timesheet_Line__c> sheetlinelist = [SELECT Id,sirenum__Timesheet__r.sirenum__Lines__c,IP_Locktimesheet__c,IP_OutboundID__c,sirenum__Timesheet__c,IP_LastPassedtoTempest__c FROM sirenum__Timesheet_Line__c WHERE Id =:TSL.id];
                for(sirenum__Timesheet_Line__c sheetline : sheetlinelist)
                {
                
                    if(sheetline.IP_Locktimesheet__c == TRUE || sheetline.IP_LastPassedtoTempest__c!=null || (existingoutbound.size()>0 && timeoutbound.containsKey(sheetline.id)))
                    {
                        check = true;
                        BackURL= urlparent+parentId ;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Timesheet line cannot be Deleted, as the data has been Passed to Tempest.');
                        ApexPages.addMessage(myMsg); 
                    }
                    else
                    {
            rowCount = sheetline.sirenum__Timesheet__r.sirenum__Lines__c;
                        deleteid.add(tsl.IP_OutboundID__c);
                        timeid.add(tsl.sirenum__Timesheet__c);
                        delete TSL;
                        reportsURL = urlparent+parentId ;
                    }
                }
            }
            else
            {
        
                deleteid.add(tsl.IP_OutboundID__c);
                timeid.add(tsl.sirenum__Timesheet__c);
                delete TSL;
            
                 if(lightningTheme.equals(getLightning)){                              reportsURL = urlparent2+parentId ;}        
                     else{           reportsURL = urlparent+parentId ;}
               // reportsURL = urlparent+parentId ;
                
            }
        }
        catch(Exception e)
        {
           System.debug('In exception1'+deleteid);
            deleteid.remove(Iddel);
            System.debug('check exception'+e.getMessage());
            check = true;
            BackURL= urlparent+parentId ;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot delete the Timesheet line.Please Contact your System Admin.');
            ApexPages.addMessage(myMsg);  
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
                   // delete deleterelated;
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
    }
    public PageReference move()
    {
        PageReference pageRef = new PageReference( urlparent+failparentId ); 
        pageRef.setRedirect(true); 
        return pageRef;
    } 
    
    
    
}