public class ShopDirectBatchHeaderdisplay{

   public ShopDirectBatchHeaderdisplay() {
  
    }

public List<IP_BatchLine__c> batchline;
public List<Batch_header__c> batchheader = new List<Batch_header__c>();
public List<IP_BatchLine__c> batchlineupdate = new List<IP_BatchLine__c>();
public String status{get;set;}
public Id selectedbatchId { get; set; }
private String sortDirection = 'ASC';
private String sortExp = 'IP_TextField1__c';
public string batchtype;
public boolean displaymsg {get;set;}
public string checkrender{get;set;}
public List<sirenum__Timesheet__c> tslist = new List<sirenum__Timesheet__c>();
public set<string> tsids = new set<string>();
    public ShopDirectBatchHeaderdisplay(ApexPages.StandardController controller) {
    
    }
    public SelectOption[] getbatchOptions() {
        
         SelectOption[] options = new SelectOption[]{};
         options.add(new SelectOption('','--None--'));
                 
      //   for(Batch_header__c bh : [Select id,Name,IP_BatchType__c from Batch_header__c where  (IP_Status__c != 'Processed' and IP_Status__c != 'Rejected')  and IP_BatchType__c LIKE 'Shop Direct%' and createddate>=LAST_N_WEEKS:4 Order BY Name]) {
       //   for(Batch_header__c bh : [Select id,Name,IP_BatchType__c from Batch_header__c where IP_Status__c = 'Pending Approval' and IP_State__c = 'Open'  and IP_BatchType__c LIKE 'Shop Direct%' Order BY Name]) {
           for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE 'Shop Direct%' and createddate = THIS_WEEK Order BY Name])) {
              
             options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+' - '+bh.IP_BatchType__c));  
                           
         } 
         return options;           
    } 

 public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)

         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';

       else

         sortDirection = 'ASC';
       sortExp = value;

     }
   }


public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
 
   public List<IP_BatchLine__c> getbatchline() {
       return batchline;
   }
   
 public PageReference displaylines() {
         
               System.debug('**selectedbatchId'+selectedbatchId);

        if(selectedbatchId!=null)
        {
        Batch_header__c header = [Select id,Batch_check__c from Batch_header__c where id =:selectedbatchId];
        header.Batch_check__c = 'All';
        update header;
         showlines();
         }
         else
         {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));

         }
        return null;
   }

public pageReference showerroredlines(){

        if(selectedbatchId!=null)
        {
        Batch_header__c header = [Select id,Batch_check__c from Batch_header__c where id =:selectedbatchId];
        header.Batch_check__c = 'Error';
        update header;
         showlines();
         }
         else
         {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
         }
        return null;
}

public pageReference checkstatus(){

        if(selectedbatchId!=null)
        {
        Batch_header__c header1 = [Select id,IP_Status__C,Check_status__c from Batch_header__c where id =:selectedbatchId];
        status = header1.IP_Status__C;
        if(header1.Check_status__c!=null)
        {
        checkrender = 'true';
        }
        else
        {
        checkrender = 'false';
        }
        System.debug('*8Check 1**'+header1.Check_status__c);
        System.debug('*8Check 2**'+checkrender);
        }
        return null;
}

public pageReference showlines(){

       Batch_header__c checkheader = [Select id,Batch_check__c from Batch_header__c where id =:selectedbatchId];
       string sortFullExp = sortExpression  + ' ' + sortDirection;
       system.debug('**Sort Expression**'+sortFullExp);      
       if(checkheader.Batch_check__c == 'All')
       {
       batchline = Database.query('Select id,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_Status__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId order by ' + sortFullExp + ' limit 1000');
       }
       else
       {
       batchline = Database.query('Select id,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_Status__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and IP_Status__c=\'Errored\' order by ' + sortFullExp + ' limit 1000');
       }
       return null; 
}

public Pagereference approvebatch()
{
if(selectedbatchID!=null)
{
Batch_header__c b = [Select id,IP_Status__c,IP_State__c from Batch_header__c where id=:selectedbatchID];
if(b.IP_Status__c == 'Pending Approval')
{
b.IP_Status__c = 'Approved';
b.IP_State__c = 'Closed';
}
batchlineupdate = [Select id,IP_Status__c,IP_ErrorReason__c,IP_BatchHeader__r.IP_BatchType__c,IP_LinkField1__c,IP_LinkField2__c,IP_LinkField3__c,IP_LinkField4__c,IP_LinkField5__c,IP_LinkField6__c,IP_LinkField7__c from IP_BatchLine__c where IP_BatchHeader__c =:selectedbatchID and IP_Status__c!='Complete'];
for(IP_BatchLine__c b1: batchlineupdate)
{
    tsids.add(b1.IP_LinkField6__c);
b1.IP_Status__c = 'Open';
b1.IP_ErrorReason__c = '';
b1.IP_LinkField1__c = '';
b1.IP_LinkField2__c = '';
b1.IP_LinkField3__c = '';
b1.IP_LinkField4__c = '';
b1.IP_LinkField5__c = '';
b1.IP_LinkField6__c = '';
b1.IP_LinkField7__c = '';
batchtype = b1.IP_BatchHeader__r.IP_BatchType__c;
}
if(!tsids.isEmpty())
{
   tslist = [Select id from sirenum__Timesheet__c where id in:tsids and sirenum__Lines__c = 0]; 
}
try{
    if(tslist.size()>0)
    {
        delete tslist;
    }
update b;
update batchlineupdate;
if(batchtype == 'Shop Direct - Shaw')
{
List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectBatchHeaderclass' and status='Processing' and createddate = TODAY];

if(job.size()>0)
{
system.debug('IF Display MSG '+displaymsg);
displaymsg = true;

}
else
{
if(!Test.isRunningTest())
{
ShopDirectBatchHeaderclass bt1 = new ShopDirectBatchHeaderclass(); Database.executeBatch(bt1,1); 
}
else
{
ShopDirectBatchHeaderclass bt1 = new ShopDirectBatchHeaderclass(); bt1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
}
}
}
if(batchtype == 'Shop Direct - Shaw Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectBatchHeaderclassFlex' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectBatchHeaderclassFlex batch1 = new ShopDirectBatchHeaderclassFlex(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectBatchHeaderclassFlex batch1 = new ShopDirectBatchHeaderclassFlex(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - Ravenmill')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectRavenMillclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectRavenMillclass batch1 = new ShopDirectRavenMillclass(); Database.executeBatch(batch1,1);
    }
else
{
ShopDirectRavenMillclass batch1 = new ShopDirectRavenMillclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
}   
}
}
if(batchtype == 'Shop Direct - Ravenmill Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectRavenMillAmendmentsclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectRavenMillAmendmentsclass batch1 = new ShopDirectRavenMillAmendmentsclass(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectRavenMillAmendmentsclass batch1 = new ShopDirectRavenMillAmendmentsclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - Speke')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectSpekeclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectSpekeclass batch1 = new ShopDirectSpekeclass(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectSpekeclass batch1 = new ShopDirectSpekeclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - Speke Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectSpekeAmendmentsclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectSpekeAmendmentsclass batch1 = new ShopDirectSpekeAmendmentsclass(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectSpekeAmendmentsclass batch1 = new ShopDirectSpekeAmendmentsclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - Little Hulton')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectlittlehultonclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectlittlehultonclass batch1 = new ShopDirectlittlehultonclass(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectlittlehultonclass batch1 = new ShopDirectlittlehultonclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);     
    }
}
}
if(batchtype == 'Shop Direct - Little Hulton Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectliitlehultonAmendmentsclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectliitlehultonAmendmentsclass batch1 = new ShopDirectliitlehultonAmendmentsclass(); Database.executeBatch(batch1,1);
    }
else
{
    ShopDirectliitlehultonAmendmentsclass batch1 = new ShopDirectliitlehultonAmendmentsclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);
}   
}
}
if(batchtype == 'Shop Direct - Croal Mill')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectCroalMillclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectCroalMillclass batch1 = new ShopDirectCroalMillclass(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectCroalMillclass batch1 = new ShopDirectCroalMillclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - Croal Mill Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectCroalMillAmendmentsclass' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectCroalMillAmendmentsclass batch1 = new ShopDirectCroalMillAmendmentsclass(); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectCroalMillAmendmentsclass batch1 = new ShopDirectCroalMillAmendmentsclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - FM Booking')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectFMbookclass ' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectFMbookclass  batch1 = new ShopDirectFMbookclass (); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectFMbookclass  batch1 = new ShopDirectFMbookclass (); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
if(batchtype == 'Shop Direct - FM Booking Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectFMbookamendclass ' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectFMbookamendclass  batch1 = new ShopDirectFMbookamendclass (); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectFMbookamendclass  batch1 = new ShopDirectFMbookamendclass (); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);     
    }
}
}
if(batchtype == 'Shop Direct - Internals')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectinternalsclass ' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectinternalsclass  batch1 = new ShopDirectinternalsclass (); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectinternalsclass  batch1 = new ShopDirectinternalsclass (); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
    }
}
}
if(batchtype == 'Shop Direct - Internals Amendments')
{
List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectinternalsamendclass ' and status='Processing' and createddate = TODAY];
if(job1.size()>0)
{
displaymsg = true;
}
else
{
    if(!Test.isRunningTest())
    {
ShopDirectinternalsamendclass  batch1 = new ShopDirectinternalsamendclass (); Database.executeBatch(batch1,1); 
    }
    else
    {
ShopDirectinternalsamendclass  batch1 = new ShopDirectinternalsamendclass (); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
    }
}
}
}
catch(Exception e){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Batch Header'));
}
}
else
{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
}
//return null;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Approved and Batch processing initiated'));

PageReference pageRef = new PageReference('/apex/ShopDirectBatchHeader'+'?sx=0');
return pageRef.setRedirect(true);
}
public Pagereference rejectbatch()
{
if(selectedbatchID!=null)
{
Batch_header__c b = [Select id,IP_Status__c,IP_State__c from Batch_header__c where id=:selectedbatchID ];
b.IP_Status__c = 'Rejected';
b.IP_State__c = 'Closed';
batchlineupdate = [Select id,IP_Status__c from IP_BatchLine__c where IP_BatchHeader__c =:selectedbatchID];
for(IP_BatchLine__c b1: batchlineupdate)
{
b1.IP_Status__c = 'Rejected';
}
try{
update b;
update batchlineupdate;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Batch header Rejected'));
}
catch(Exception e){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Batch Header'));
}
}
else
{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
}
return null;
}


}