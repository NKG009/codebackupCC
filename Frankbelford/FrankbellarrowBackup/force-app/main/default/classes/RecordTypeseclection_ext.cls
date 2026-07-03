public with sharing class RecordTypeseclection_ext {

public  String conID;
    public List<RecordType> ppList{get;set;} //pay profile
    public string lightningTheme ='Theme4d';

public String selectedrecordtype{get;set;}
    public RecordTypeseclection_ext(ApexPages.StandardController controller) {
        string abc1;
        string abc2;
        string abc3;
        string abc4;
        string abc5;
        string abc6;
        string abc7;
            conID = ApexPages.currentPage().getParameters().get('conid');
            selectedrecordtype = 'PAYE';
            ppList = [SELECT id,Name, Description FROM RecordType where SObjectType = 'IP_PayProfile__c'];
        system.debug('check pay profile list'+ppList);
    }
    
    // Simple accessors for the System.UserInfo theme methods
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
     public List<selectOption> allrecordtype{
        get {
       /*   List<SelectOption> options = new List<SelectOption>(); 
        for(Recordtype rt: ppList)
        {
         options.add(new SelectOption(rt.Name,rt.Name));
        } */
       /* options.add(new SelectOption('LTD','LTD')); 
        options.add(new SelectOption('PAYE','PAYE')); 
        options.add(new SelectOption('Umbrella','Umbrella')); */      
        
        List<SelectOption> options = new List<SelectOption>();
        for(RecordTypeInfo info: IP_PayProfile__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable() && info.getName() != 'Master') {
                options.add(new SelectOption(info.getName(), info.getName()));
            }
        }
        
        // Include these next 3 lines to output the results during development and debugging
       /* for( SelectOption selopt: recordTypes ) {
            System.debug( selopt.getLabel() + ',' + selopt.getValue() );
        } */
                  
        return options;        
          }
        set;
    }

    public Pagereference nextpage()
    {
    Contact con = new Contact();
    if(conID != null)
    {
    con = [Select id,Name from Contact where id=:conID];
    }
        if(selectedrecordtype == 'PAYE')
        {
            
            Recordtype recp = [Select id from RecordType where Name = 'PAYE' and SobjectType = 'IP_PayProfile__c'];
            String getLightning = getContextUserUiThemeDisplayed();
            if(conID != null){
                if(lightningTheme.equals(getLightning)){
                    PageReference pageRef = new PageReference('/apex/PayeandUmbPage?conid='+conID+'&recid='+recp.id);  
                    return pageRef;
                }
                else{
                    PageReference  pageRef = new PageReference('/a4a/e?CF00N0Y00000Ppq5M='+con.Name+'&CF00N0Y00000Ppq5M_lkid='+con.id+'&retURL%2F='+con.id+'&RecordType='+recp.id+'&ent=01I0Y000002NXG2&nooverride=1');  
                    pageRef.setredirect(True);
                    return pageRef;
                }
            }
            else{
                if(lightningTheme.equals(getLightning)){
                    PageReference pageRef = new PageReference('/apex/PayeandUmbPage?recid='+recp.id);                      return pageRef;
                }
                else{
                    PageReference  pageRef = new PageReference('/a4a/e?retURL%2F=a4e/o&RecordType='+recp.id+'&ent=01I0Y000002NXG2&nooverride=1');                      pageRef.setredirect(True);                    return pageRef;
                }
            }
           // pageRef.setredirect(True);
           // return pageRef;
        }
        else if(selectedrecordtype == 'Umbrella')
        {
            Recordtype recp = [Select id from RecordType where Name = 'Umbrella' and SobjectType = 'IP_PayProfile__c'];
            String getLightning = getContextUserUiThemeDisplayed();
           /* if(lightningTheme.equals(getLightning)){
                PageReference pageRef = new PageReference('lightning/o/IP_PayProfile__c/new?recordTypeId='+recp+'&0.source=alohaHeader ');  
                pageRef.setredirect(True);
                return pageRef;
            }*/
          //  else{
                if(conID != null)
                {
                    if(lightningTheme.equals(getLightning))
                    {
                         PageReference pageRef = new PageReference('/apex/PayeandUmbPage?conid='+conID+'&recid='+recp.id);                          return pageRef;
                    }
                    else
                    {
                        PageReference pageRef = new PageReference('/a4a/e?CF00N0Y00000Ppq5M='+con.Name+'&CF00N0Y00000Ppq5M_lkid='+con.id+'&retURL='+con.id+'&RecordType='+recp.id+'&ent=01I0Y000002NXG2&nooverride=1');  
                        pageRef.setredirect(True);
                        return pageRef;
                    }
                }
                else
                {
                    if(lightningTheme.equals(getLightning))
                    {
                         PageReference pageRef = new PageReference('/apex/PayeandUmbPage?recid='+recp.id);                          return pageRef;
                    }
                    else
                    {
                        PageReference  pageRef = new PageReference('/a4a/e?retURL%2F=a4e/o&RecordType='+recp.id+'&ent=01I0Y000002NXG2&nooverride=1');  
                         pageRef.setredirect(True);                        return pageRef;
                    }
                }
          //  }
        }
        else
        {
        Recordtype recp = [Select id from RecordType where Name = 'LTD' and SobjectType = 'IP_PayProfile__c'];
        if(conID != null)
        {
        PageReference pageRef = new PageReference('/apex/LTDpayprofile?conid='+conID+'&recid='+recp.id);  
            return pageRef;
            }
            else
            {
            PageReference pageRef = new PageReference('/apex/LTDpayprofile?recid='+recp.id);              return pageRef;
            }
        }
     // return null;
    }
     

}