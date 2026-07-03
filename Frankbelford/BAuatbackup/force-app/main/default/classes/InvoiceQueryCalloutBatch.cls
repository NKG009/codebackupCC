/**
 * Created by Espire Team (Ritu Hetawal), 26/06/2020 04:36
 *
 * Update by Musaddekur Rahman on 14/07/2020 to utilise the Batchable context as part of JIRA Ticket: RJSPT-98.
 * Description:
 * Previously all data were processed in a single batch as the callout was performed in the execute method
 * Now the callout is made in default constructor method to ensure that that batchable context is utilised
 *
 * Tasks:
 * 1. Added InvoiceQueryWrapper class to hold each invoice data and to implement Database batchable interface
 * 2. Added a new private method (callout) to perform API callout, ideally it should have been handled outside of this class
 *    but there are some post callout operation to massage the JSON String which are specific to this operation only
 * 3. Delete operation is moved to Finish method as it should be performed once per schedule
 *
 * Known issue:
 * 1. Assuming that it not by design, Invoice Query numbers are not unique in the source system but it is treated as unique
 *    which will cause potential data loss
 */

global class InvoiceQueryCalloutBatch implements Database.AllowsCallouts, Database.batchable<InvoiceQueryWrapper>, Database.Stateful{
    global List<InvoiceQueryWrapper> invoices = new List<InvoiceQueryWrapper>();

    public Map<String, IP_InvoiceQuery__c> deleteIQMape;

    global InvoiceQueryCalloutBatch(){
        System.debug('>>>>>> Preparing to start Invoice Query Batch process <<<<<<<<');
        deleteIQMape = new Map<String, IP_InvoiceQuery__c>();
        for(IP_InvoiceQuery__c iq: [Select id,IP_InvoiceNumber__c from IP_InvoiceQuery__c]){
            deleteIQMape.put(iq.IP_InvoiceNumber__c,iq);
        }
        System.debug('deleteIQMape size:: ' + deleteIQMape.size());
    }

    global Iterable<InvoiceQueryWrapper> start(Database.BatchableContext info) {
        String jsonString = callout();

        InvoiceWrpper invData = (InvoiceWrpper)System.JSON.deserialize(jsonString,InvoiceWrpper.class);
        System.debug('invoices size:: ' + invData.data.size());
        this.invoices.addAll(invData.data);
        return this.invoices;
    }

    global void execute(Database.BatchableContext inv, List<InvoiceQueryWrapper> invparse){
        Map<String,String> entityMap = new Map<String,String>();
        Map<String,String> BranchCodeMap = new Map<String,String>();
        Map<String,String> BranchNameMap = new Map<String,String>();
        Map<String,String> AccNoMap = new Map<String,String>();
        Map<String,String> ClientMap = new Map<String,String>();
        Map<String,DateTime> InvoiceDateMap = new Map<String,DateTime>();
        Map<String,DateTime> DueDateMap = new Map<String,DateTime>();
        Map<String,String> InvoiceNumberMap = new Map<String,String>();
        Map<String,String> QueryValueMap = new Map<String,String>();
        Map<String,DateTime> DateRaisedMap = new Map<String,DateTime>();
        Map<String,String> AgeofQueryMap = new Map<String,String>();
        Map<String,String> ContactMap = new Map<String,String>();
        Map<String,String> StatusMap = new Map<String,String>();
        Map<String,String> QueryDescMap = new Map<String,String>();
        Map<String,String> CommentMap = new Map<String,String>();
        Map<String,IP_InvoiceQuery__c> invmap = new Map<String,IP_InvoiceQuery__c>();
        Map<String,String> Sitemap = new Map<String,String>();
        Map<String,String> SitemapException = new Map<String,String>();
        List<IP_InvoiceQuery__c> Invoicetoinsert = new List<IP_InvoiceQuery__c>();
        List<IP_InvoiceQuery__c> Invoicetoupdate = new List<IP_InvoiceQuery__c>();
        List<IP_InvoiceQuery__c> existingreclist = [Select id,IP_InvoiceNumber__c from IP_InvoiceQuery__c];
        System.debug('check existing list size--->'+existingreclist.size());
        Set<String> branchset = new Set<String>();
        List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c];

        for(IP_BranchStatus__c b:branchlist)
        {
            branchset.add(b.IP_BranchID__c);
        }

        if(existingreclist.size()>0)
        {
            for(IP_InvoiceQuery__c iq: existingreclist)
            {
                invmap.put(iq.IP_InvoiceNumber__c,iq);
            }
        }
        if(invparse.size()>0)
        {
            for (integer i=0 ;i<invparse.size();i++)
            {
                if(branchset.contains(invparse[i].Branch_Code.trim()))
                {
                    entityMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Entity);
                    BranchCodeMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Branch_Code.trim());
                    BranchNameMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Branch_Name.trim());
                    AccNoMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Acc_No.trim());
                    ClientMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Client.trim());
                    InvoiceDateMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Invoice_Date);
                    DueDateMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Due_Date);
                    InvoiceNumberMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Invoice_Number.trim());
                    QueryValueMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Query_Value);
                    DateRaisedMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Date_Raised);
                    AgeofQueryMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Age_of_Query);
                    ContactMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Contact);
                    StatusMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Status);
                    QueryDescMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Query_Description);
                    CommentMap.put(invparse[i].Invoice_Number.trim(),invparse[i].Comment);
                }
            }
            List<sirenum__site__c> sitelist = [Select id,sirenum__Operating_Company__c,IP_SLNUpdateValue__c,IP_TempestDepartment__c from sirenum__site__c where IP_SLNUpdateValue__c in: AccNoMap.values()];
            for(sirenum__site__c s: sitelist)
            {
                siteMap.put(s.IP_SLNUpdateValue__c+'_'+s.IP_TempestDepartment__c,s.sirenum__Operating_Company__c);
                SitemapException.put(s.IP_SLNUpdateValue__c,s.sirenum__Operating_Company__c);
            }

        }
        if(invmap.keyset().isEmpty())
        {
            //SYstem.debug('Inside first if');
            for(String invnoins:InvoiceNumberMap.keyset())
            {
                IP_InvoiceQuery__c invq = new IP_InvoiceQuery__c();
                invq.IP_Entity__c = entityMap.get(invnoins);
                invq.IP_AccountNumber__c = AccNoMap.get(invnoins).trim();
                if(Sitemap.get(AccNoMap.get(invnoins)+'_'+BranchCodeMap.get(invnoins)) != null)
                {
                    invq.IP_Account__c = Sitemap.get(AccNoMap.get(invnoins)+'_'+BranchCodeMap.get(invnoins));
                }
                else
                {
                    invq.IP_Account__c = SitemapException.get(AccNoMap.get(invnoins));
                }
                invq.IP_AgeofQuery__c = Decimal.ValueOf(AgeofQueryMap.get(invnoins));
                invq.IP_BranchCode__c = BranchCodeMap.get(invnoins);
                invq.IP_BranchName__c = BranchNameMap.get(invnoins);
                invq.IP_Client__c = ClientMap.get(invnoins);
                invq.IP_Comment__c = CommentMap.get(invnoins);
                invq.IP_Contact__c = ContactMap.get(invnoins);
                invq.IP_Date_Raised__c = Date.valueOf(DateRaisedMap.get(invnoins));
                invq.IP_Due_Date__c= Date.valueOf(DueDateMap.get(invnoins));
                invq.IP_Invoice_Date__c= Date.valueOf(InvoiceDateMap.get(invnoins));
                invq.IP_InvoiceNumber__c = InvoiceNumberMap.get(invnoins);
                invq.IP_QueryDescription__c = QueryDescMap.get(invnoins);
                invq.IP_QueryValue__c = Decimal.valueOf(QueryValueMap.get(invnoins));
                invq.IP_Status__c = StatusMap.get(invnoins);
                Invoicetoinsert.add(invq);

            }

        }
        else
        {
            //SYstem.debug('Inside else');
            for(String invno:InvoiceNumberMap.keyset())
            {
                if(invmap.containsKey(invno))
                {
                    //SYstem.debug('Inside else - > if');
                    IP_InvoiceQuery__c invq1 = new IP_InvoiceQuery__c();
                    invq1.id = invmap.get(invno).id;
                    invq1.IP_Entity__c = entityMap.get(invno);
                    invq1.IP_AccountNumber__c = AccNoMap.get(invno).trim();
                    if(Sitemap.get(AccNoMap.get(invno)+'_'+BranchCodeMap.get(invno)) != null)
                    {
                        invq1.IP_Account__c = Sitemap.get(AccNoMap.get(invno)+'_'+BranchCodeMap.get(invno));
                    }
                    else
                    {
                        invq1.IP_Account__c = SitemapException.get(AccNoMap.get(invno));
                    }
                    invq1.IP_Actioned__c = false;
                    invq1.IP_AgeofQuery__c = Decimal.valueOf(AgeofQueryMap.get(invno));
                    invq1.IP_BranchCode__c = BranchCodeMap.get(invno);
                    invq1.IP_BranchName__c = BranchNameMap.get(invno);
                    invq1.IP_Client__c = ClientMap.get(invno);
                    invq1.IP_Comment__c = CommentMap.get(invno);
                    invq1.IP_Contact__c = ContactMap.get(invno);
                    invq1.IP_Date_Raised__c = Date.valueOf(DateRaisedMap.get(invno));
                    invq1.IP_Due_Date__c = Date.valueOf(DueDateMap.get(invno));
                    invq1.IP_Invoice_Date__c = Date.valueOf(InvoiceDateMap.get(invno));
                    invq1.IP_InvoiceNumber__c = InvoiceNumberMap.get(invno);
                    invq1.IP_QueryDescription__c = QueryDescMap.get(invno);
                    invq1.IP_QueryValue__c = Decimal.valueOf(QueryValueMap.get(invno));
                    invq1.IP_Status__c = StatusMap.get(invno);
                    Invoicetoupdate.add(invq1);

                    //System.debug('deleteIQMape size:: ' + deleteIQMape.size());
                    if(deleteIQMape.size()>0){
                        deleteIQMape.remove(invq1.IP_InvoiceNumber__c);
                    }
                }
                else
                {
                    //SYstem.debug('Inside else - > else');
                    IP_InvoiceQuery__c invq2 = new IP_InvoiceQuery__c();
                    invq2.IP_Entity__c = entityMap.get(invno);
                    invq2.IP_AccountNumber__c = AccNoMap.get(invno).trim();
                    if(Sitemap.get(AccNoMap.get(invno)+'_'+BranchCodeMap.get(invno)) != null)
                    {
                        invq2.IP_Account__c = Sitemap.get(AccNoMap.get(invno)+'_'+BranchCodeMap.get(invno));
                    }
                    else
                    {
                        invq2.IP_Account__c = SitemapException.get(AccNoMap.get(invno));
                    }
                    invq2.IP_AgeofQuery__c = Decimal.ValueOf(AgeofQueryMap.get(invno));
                    invq2.IP_BranchCode__c = BranchCodeMap.get(invno);
                    invq2.IP_BranchName__c = BranchNameMap.get(invno);
                    invq2.IP_Client__c = ClientMap.get(invno);
                    invq2.IP_Comment__c = CommentMap.get(invno);
                    invq2.IP_Contact__c = ContactMap.get(invno);
                    invq2.IP_Date_Raised__c = Date.valueOf(DateRaisedMap.get(invno));
                    invq2.IP_Due_Date__c = Date.valueOf(DueDateMap.get(invno));
                    invq2.IP_Invoice_Date__c = Date.valueOf(InvoiceDateMap.get(invno));
                    invq2.IP_InvoiceNumber__c = InvoiceNumberMap.get(invno);
                    invq2.IP_QueryDescription__c = QueryDescMap.get(invno);
                    invq2.IP_QueryValue__c = Decimal.valueOf(QueryValueMap.get(invno));
                    invq2.IP_Status__c = StatusMap.get(invno);
                    Invoicetoinsert.add(invq2);
                }
            }
        }
        System.debug('checkinsert list size---->'+Invoicetoinsert.size());
        System.debug('checkupdate list size---->'+Invoicetoupdate.size());

        if(Invoicetoinsert.size()>0)
        {
            //database.insert(Invoicetoinsert,false);
            insert Invoicetoinsert;
        }
        if(Invoicetoupdate.size()>0)
        {
            //database.update(Invoicetoupdate,false);
            update Invoicetoupdate;
        }
    }

    global void finish(Database.BatchableContext inv){
        System.debug('deleteIQMape size:: ' + deleteIQMape.size());
        if(deleteIQMape.size()>0){
            delete new List<Task> ([Select id from Task where Whatid in: deleteIQMape.values()]);
            delete deleteIQMape.values();
            System.debug('Total existing Invoice Query (including task) deleted '+deleteIQMape.size());
        }
        System.debug('Finish block - end of batch');
    }

    //@future(callout=true)
    private static String callout() {
        HttpRequest req = new HttpRequest();
        string endpoint = 'callout:InvoiceQuery';
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/json;charset=UTF-8');
        headers.put('Authorization', Label.InvoiceQueryAuthorization);
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Authorization', Label.InvoiceQueryAuthorization);
        //  System.debug('check req--->'+req);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String json12 = res.getbody();
        json12 = json12.replace('Branch Code','Branch_Code');
        json12 = json12.replace('Branch Name','Branch_Name');
        json12 = json12.replace('Acc No','Acc_No');
        json12 = json12.replace('Invoice Date','Invoice_Date');
        json12 = json12.replace('Due Date','Due_Date');
        json12 = json12.replace('Invoice Number','Invoice_Number');
        json12 = json12.replace('Query Value','Query_Value');
        json12 = json12.replace('Date Raised','Date_Raised');
        json12 = json12.replace('Age of Query','Age_of_Query');
        json12 = json12.replace('Query Description','Query_Description');
        //FOLLOWING 2 LINES OF CODE ADDED FOR JIRA TICKET RJSPT-98 BUG FIX
        json12 = json12.replace('\\"','"');
        json12 = json12.remove('\\"');
        //--------------------------------------------//
        json12 = json12.remove('\\');
        json12 = json12.replace('"data":"[','"data":[');
        json12 = json12.replace(']"',']');
        //System.debug('json12::: '+ json12);
        return json12;
    }
}