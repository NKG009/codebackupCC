public class accountRecordTypeSelection_Ext {
    
    public  String conID;
    public List<RecordType> accList{get;set;} 
    List<SelectOption> options = new List<SelectOption>();
    public String selectedrecordtype{get;set;}
    public accountRecordTypeSelection_Ext(ApexPages.StandardController controller) {
        selectedrecordtype = 'Account';
        accList = [SELECT id,Name, Description FROM RecordType where SObjectType = 'Account'];
    }
    public List<selectOption> allrecordtype{
        get {
            for(RecordTypeInfo info: Account.SObjectType.getDescribe().getRecordTypeInfos()) {
                if(info.isAvailable() && info.getName() != 'Master') {
                    options.add(new SelectOption(info.getName(), info.getName()));
                }
            } 
            return options;        
        }
        set;
    }
    
    public Pagereference nextPage()
    {
        
        if(selectedrecordtype == 'Candidate')
        {
            Recordtype recp = [Select id from RecordType where Name = 'Candidate' and SobjectType = 'Account'];
            PageReference pageRef = new PageReference('/001/e?&retURL=%2F001%2Fo&RecordType='+recp.id+'&ent=Account&nooverride=1');
            return pageRef;
        }    
        else if(selectedrecordtype == 'Client')
        {
            Recordtype recp = [Select id from RecordType where Name = 'Client' and SobjectType = 'Account'];
            PageReference pageRef = new PageReference('/apex/createClientAccountCusPage?recid='+recp.id);  
            return pageRef;
        }
        else if(selectedrecordtype == '2nd Tier Supplier')
        {
            Recordtype recp = [Select id from RecordType where Name = '2nd Tier Supplier' and SobjectType = 'Account'];
            PageReference pageRef = new PageReference('/apex/create2ndTierAccountCusPage?recid='+recp.id);  
            return pageRef;
        }
        else if(selectedrecordtype == 'Account')
        {
            Recordtype recp = [Select id from RecordType where Name = 'Account' and SobjectType = 'Account'];
            PageReference pageRef = new PageReference('/apex/AccountCustPage?recid='+recp.id);  
            return pageRef;
        }
        else
            return null;
    }
    public pageReference cancelredirect() 
    {
        
        Pagereference pagenew = new Pagereference('/001/o');
        pagenew.setRedirect(true);
        return pagenew;
    } 
    
}