public class ContactRecordTypeSelection_ext {

    public List<RecordType> ppList{get;set;} 
public String selectedrecordtype{get;set;}

    public ContactRecordTypeSelection_ext(ApexPages.StandardController controller) {
         //   selectedrecordtype = 'Contact';
         selectedrecordtype = 'Candidate';
                ppList = [SELECT id,Name, Description FROM RecordType where SObjectType = 'Contact'];
        system.debug('check recordtype'+ppList);

    }
     public List<selectOption> allrecordtype{
        get {
       /*   List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('2nd Tier Candidate','2nd Tier Candidate'));  
        options.add(new SelectOption('Candidate','Candidate'));     
        options.add(new SelectOption('Contact','Contact')); */
         List<SelectOption> options = new List<SelectOption>();
        for(RecordTypeInfo info: Contact.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable() && info.getName() != 'Master') {
                options.add(new SelectOption(info.getName(), info.getName()));
            }
        }
        
          
        return options;        
          }
        set;
    }
    public Pagereference nextpage()
    {
    
        System.debug('selectedrecordtype**'+selectedrecordtype);
        if(selectedrecordtype == 'Contact')
        {
            Recordtype recp = [Select id from RecordType where developername = 'Contact' and SobjectType = 'Contact'];
            PageReference pageRef = new PageReference('/apex/CreateContactPage?recid='+recp.id);  
            return pageRef;
        }
        else if(selectedrecordtype == 'Candidate')
        {
            Recordtype recp = [Select id from RecordType where developername = 'Candidate' and SobjectType = 'Contact'];
            PageReference pageRef = new PageReference('/apex/CreateCandidatePage?recid='+recp.id);  
            pageref.setredirect(true);
            return pageRef;
        }
        else
        {
        Recordtype recp = [Select id from RecordType where developername = 'IP_2ndTierCandidate' and SobjectType = 'Contact'];
        PageReference pageRef = new PageReference('/apex/create2ndtiersupplier?recid='+recp.id);  
            return pageRef;
        }
     // return null;
    }


}