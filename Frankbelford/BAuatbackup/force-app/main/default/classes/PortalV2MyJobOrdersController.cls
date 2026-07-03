public class PortalV2MyJobOrdersController {
    
    @AuraEnabled
    public static List<Portal_V2_JobOrder_Adjust_Columns__mdt> fetchAdjustableColumns() {
        List<Portal_V2_JobOrder_Adjust_Columns__mdt> theCustomMetadata = [
            SELECT
            Display_Order__c,
            MasterLabel,
            DeveloperName,
            Field_API_Name__c,
            Selected_By_Default__c,
            Filterable__c,
            Filter_Type__c,
            Field_Display_Type__c
            FROM Portal_V2_JobOrder_Adjust_Columns__mdt
            ORDER BY Display_Order__c ASC
        ];
        return theCustomMetadata;
    }

@AuraEnabled(cacheable=true)
public static Boolean getVmsContactInfo() {
    try {
        Id currentUserId = UserInfo.getUserId();
        User loggedInUser = [SELECT ContactId FROM User WHERE Id = :currentUserId LIMIT 1];
        if (loggedInUser.ContactId != null) {
            Contact contact = [SELECT VMS_Contact__c FROM Contact WHERE Id = :loggedInUser.ContactId LIMIT 1];
            return contact.VMS_Contact__c;
        }
    } catch (Exception e) {
        throw new AuraHandledException('Error fetching VMS Contact information: ' + e.getMessage());
    }
    return false;
}
    
    @AuraEnabled(cacheable=true)
    public static List<sirenum__JobOrder__c > getAllJobOrders() {
       Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
        Id accountId = userContact.AccountId;
        System.debug(userContact);
        Set <Id> allsitesids = New Set <Id>();
        Set <Id> siteaccountids = New Set <Id>();
        list<sirenum__JobOrder__c> AllfilteredJoborders = New list<sirenum__JobOrder__c>();

        List <Site_Supplier_Link__c> sslallrecords = [select id,Tier__c,Instant_Vend_Date_Time__c,Site__c,Site_Account__c,Suppliers__r.Supplier__c,Suppliers__r.Account__c from Site_Supplier_Link__c where Active__c=true AND Suppliers__r.Supplier__c=:AccountId];
        For(Site_Supplier_Link__c ssl : sslallrecords){
                allsitesids.add(ssl.Site__c);
                siteaccountids.add(ssl.Suppliers__r.Account__c);
        }

        system.debug('sslallrecords:'+sslallrecords.size());

        list<sirenum__JobOrder__c> AllJoborderlist = [SELECT Id,sirenum__Site__c,Instant_Vend_Tier__c,Job_Order_Number__c,Total_Resource_Required__c,createddate, sirenum__Account__c, sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,sirenum__Status__c,sirenum__JobRole__r.Minimum_Pay__c,
            sirenum__Site__r.Name, sirenum__Site__r.Parking_information__c,sirenum__Site__r.Who_to_meet_on_arrival__c,sirenum__Site__r.Public_Transport_Information__c, sirenum__Account__r.Name, sirenum__JobRole__r.Name,
		    Name, Override__c,Quantity__c,Total_Supplier_Flat_Fee__c,Management_Fee_hr__c,JobRoleMinimum__c,Total_Client_Rate__c,Forecasted_Total_Rate__c,
			sirenum__RateCard__c,sirenum__RateCard__r.name,sirenum__JobRole__r.IP_Notified_Health_Safety_Risks__c,sirenum__JobRole__r.IP_Job_Description__c,sirenum__WorkSchedule__c,
            (select Id,Supplier_Account__c,Job_Order__c from Job_Order_Decline_Details__r where Supplier_Account__c =:accountId)
			FROM sirenum__JobOrder__c 
            WHERE sirenum__Account__c IN:siteaccountids AND sirenum__Site__c IN:allsitesids AND sirenum__Status__c='Ongoing' AND sirenum__EndDate__c >= TODAY ORDER BY createddate DESC];

        
        for( sirenum__JobOrder__c  SJO :AllJoborderlist){
        
            for(Site_Supplier_Link__c ssl: sslallrecords ){
            system.debug('ssl.Suppliers__r.Account__c:'+ ssl.Suppliers__r.Account__c);
                if( ssl.Site__c == SJO.sirenum__Site__c && ssl.Suppliers__r.Account__c ==SJO.sirenum__Account__c){
                   if(SJO.Instant_Vend_Tier__c == ssl.Tier__c || SJO.Instant_Vend_Tier__c =='All Tier'){
                            AllfilteredJoborders.add(sjo);
                        }
                  
                    else if(ssl.Instant_Vend_Date_Time__c !=null){
                        if(SJO.createddate <=ssl.Instant_Vend_Date_Time__c){
                             AllfilteredJoborders.add(sjo);
                        }
                       
                    }                       
                 
                }
            }
        }
        return AllfilteredJoborders;
        // return [
        //     SELECT Id,sirenum__Site__c, sirenum__Account__c, sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,sirenum__Status__c,sirenum__JobRole__r.Minimum_Pay__c,
        //     sirenum__Site__r.Name, sirenum__Site__r.Parking_information__c,sirenum__Site__r.Who_to_meet_on_arrival__c,sirenum__Site__r.Public_Transport_Information__c, sirenum__Account__r.Name, sirenum__JobRole__r.Name,
		//     Name, Override__c,Quantity__c,Total_Supplier_Flat_Fee__c,Management_Fee_hr__c,JobRoleMinimum__c,Total_Client_Rate__c,
		// 	sirenum__RateCard__c,sirenum__RateCard__r.name,sirenum__JobRole__r.IP_Notified_Health_Safety_Risks__c,sirenum__JobRole__r.IP_Job_Description__c,sirenum__WorkSchedule__c
		// 	FROM sirenum__JobOrder__c 
        //     WHERE sirenum__Account__c  ='0010Y00001b5LZhQAM'  // :accountId 
        // ];
    }
    
     @AuraEnabled
    public static List<Job_Order_Comments__c > getJobOrderComments(Id jobOrderId) {
        return [SELECT Id,Comment_Text__c,Comment_Type__c,Job_Order__c,createddate from Job_Order_Comments__c where Job_Order__c=:jobOrderId ORDER BY createddate ASC];
    }
    
   
    
    @AuraEnabled
    public static List<ContentDocument> getFilesRelatedToJobOrder(Id jobOrderId) {
         List<ContentDocumentLink> contentLinks = [
            SELECT ContentDocumentId,Visibility
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :jobOrderId
        ];

        // Collect the ContentDocument Ids from the ContentDocumentLink records
        Set<Id> documentIds = new Set<Id>();
        for(ContentDocumentLink link : contentLinks) {
            if (link.Visibility != 'AllUsers') {
                link.Visibility = 'AllUsers'; // Ensure visibility is for all users
                update link;
            }
            documentIds.add(link.ContentDocumentId);
        }

        // Query ContentDocument using the collected ContentDocumentIds
        if (!documentIds.isEmpty()) {
            return [SELECT Id, Title, FileType, ContentSize 
                    FROM ContentDocument 
                    WHERE Id IN :documentIds];
        } else {
            return new List<ContentDocument>();
        }
    
    }
    
     @AuraEnabled
    public static String getCommunityBaseUrl() {
        // Use ConnectApi to get the current community URL
        //String communityUrl = URL.getOrgDomainUrl().toExternalForm();

         Domain d=[SELECT Domain FROM Domain where domain like '%my.site.com%' limit 1];
                Network ns=[select name, UrlPathPrefix FROM Network where name LIKE '%Client Portal V2%' limit 1];
                string communityUrl='https://'+d.Domain+'/'+ns.UrlPathPrefix; 
        return communityUrl;
    }
    
    @AuraEnabled
    public static list<sirenum__Sirenum_Condition_Membership__c> getJobOrderCompConditions(Id joborderid) {

        sirenum__JobOrder__c jodetails = [select Id,sirenum__Account__c,sirenum__JobRole__c,sirenum__Site__c,sirenum__JobRole__r.sirenum__Job_Type__c,sirenum__JobRole__r.sirenum__Rota__c from sirenum__JobOrder__c where Id=:joborderid];

        return [SELECT id ,sirenum__Severity__c,sirenum__TicketType__c,sirenum__TicketType__r.Name,sirenum__TicketType__r.sirenum__Requires_Proof__c,sirenum__TicketType__r.sirenum__Expires__c  from sirenum__Sirenum_Condition_Membership__c
                WHERE sirenum__Client__c=:jodetails.sirenum__Account__c
                OR sirenum__Team__c =: jodetails.sirenum__JobRole__c
                OR sirenum__Site__c =: jodetails.sirenum__Site__c
                OR sirenum__Job_Type__c=:jodetails.sirenum__JobRole__r.sirenum__Job_Type__c
                OR sirenum__Rota__c =:jodetails.sirenum__JobRole__r.sirenum__Rota__c
               ];
        
    }
    
  /*  @AuraEnabled
    public static list<sirenum__Rate_Card_Page__c> getJobOrderratecard(id ratecardid) {
      
      // list<sirenum__Rate_Card_Page__c> ratecards = [SELECT Id, Name,(SELECT Id, Name FROM sirenum__Rate_Lines__r) FROM sirenum__Rate_Card_Page__c where sirenum__Rate_Card__c =:ratecardid ];

       return [SELECT Id, Name,(SELECT Id, Name,sirenum__Standard_Rate_Name__c,sirenum__Unit__c,sirenum__Pay_Rate__c,sirenum__Charge_Rate__c FROM sirenum__Rate_Lines__r) FROM sirenum__Rate_Card_Page__c WHERE sirenum__Rate_Card__c='a4o4J000000QjuUQAS'   //=:ratecardid 
       ];
        
    }*/
    @AuraEnabled
    public static list<sirenum__WorkScheduleDay__c> getJobOrderWorkschedule(Id workschid) {
        
        return [SELECT id ,sirenum__Start__c ,sirenum__End__c, sirenum__Offset__c From sirenum__WorkScheduleDay__c WHERE sirenum__WorkSchedule__c =:workschid];
    }
    
    
    @AuraEnabled
    public static list<Candidate__c> getJobOrderCandidates(Id joborderid) {
		Id currentUserId = UserInfo.getUserId();
        return [SELECT id ,createddate ,Status__c,Contact__r.name,Contact__r.MobilePhone,Contact__r.Email From Candidate__c WHERE Job_Order__c =:joborderid AND Submitted_By__c=:currentUserId];
        
    }  
    
    @AuraEnabled
    public static list<contact> getallcandidatesunderaccount() {
        Id tier2rtypeid = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('IP_2ndTierCandidate').getRecordTypeId();
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
        Id accountId = userContact.AccountId;
        return [SELECT id ,name,MobilePhone,Email,sirenum__National_Insurance__c,(select id,sirenum__TicketType__c from sirenum__Tickets__r) From contact WHERE accountid=:accountId AND recordtypeid =:tier2rtypeid];
        
    }
    
     @AuraEnabled
    public static void generateCompliancePDF(Id contactId) {
        Id recordtypeid =[select id from RecordType where name='Compliance Confirmed by 2nd Tier'].Id;
        ts2__Certification__c cert = new ts2__Certification__c (ts2__Contact__c =contactId,
                                                                 recordtypeid=recordtypeid,
                                                                 IP_Status__c='Current',
                                                                 Verfied__c =true);
        insert cert;


        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];
        Map<Id,contact> contactlist = New Map<Id,contact>([SELECT Id, Name FROM Contact WHERE Id IN :new Set<Id>{currentUser.ContactId, contactId}]);
        
        // Prepare the parameters for Visualforce page
        PageReference pdfPage = Page.CompliancePDF;
        pdfPage.getParameters().put('contactName', contactlist.get(currentUser.ContactId).Name);
        pdfPage.getParameters().put('candidateName', contactlist.get(contactId).Name);
        pdfPage.getParameters().put('submissionDate', String.valueOf(Date.today()));

        // Render the page as PDF
        if(!test.isrunningtest()){
        Blob pdfContent;
        try {
            pdfContent = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            throw new AuraHandledException('Failed to generate PDF: ' + e.getMessage());
        }

        // Create a ContentVersion record to attach the PDF to the Contact's Files
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'Compliance Report - ' + contactlist.get(contactId).Name;
        contentVersion.PathOnClient = 'Compliance_Report.pdf';
        contentVersion.VersionData = pdfContent;
        insert contentVersion;
        
        // Fetch the ContentDocumentId for the ContentVersion
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId, LinkedEntityId = cert.Id, ShareType = 'V', Visibility = 'AllUsers' );
        insert contentDocumentLink;
        }
    }
    
    @AuraEnabled
    public static void createCandidateRecord(id contactId,Id joborderId){
        Candidate__c cand = new Candidate__c(Contact__c =contactId,
												Job_Order__c =joborderid,
                                                Status__c='Submitted',
												Submitted_By__c=UserInfo.getUserId());
            insert cand;
    }
    
    @AuraEnabled
    public static void createCompetencyRecords(id contactId,Id joborderid,List<Map<String, Object>> competencyConditions,string instype) {
        system.debug('***********************************here in createCompetencyRecords************************************');
        try{
            if(instype =='Both'){
              createCandidateRecord(contactId,joborderid);  
            }
            
            

        // Loop through the competency records to create tickets
        for (Map<String, Object> record : competencyConditions) {
            if (record.get('selectedValue') == 'Yes') {
                sirenum__Ticket__c newTicket = new sirenum__Ticket__c();
                newTicket.sirenum__Owner__c = contactid;
                newTicket.sirenum__TicketType__c = (Id) record.get('sirenum__TicketType__c');
                if((Boolean) record.get('showValidtill')){
                  newTicket.sirenum__Valid_until__c= Date.valueOf((string) record.get('validDateValue')); 
                }
                insert newTicket;

                 if ((Boolean) record.get('showFileUpload') && (Boolean) record.get('isContainsFile')) {
                        Id fileId = (Id) record.get('fileId');
                        
                        // Create a ContentDocumentLink for the file
                        ContentDocumentLink fileLink = new ContentDocumentLink();
                        fileLink.ContentDocumentId = fileId;
                        fileLink.LinkedEntityId = newTicket.Id;  // Now the Ticket ID is available
                        fileLink.ShareType = 'V'; 
                        fileLink.Visibility = 'AllUsers';
                        insert fileLink;
                }
            }
        }

            
      }
        catch( exception e){
            if(e.getMessage().contains('Argument cannot be null')){
            throw new AuraHandledException('Please upload files before submitting');
            }
            else{
              throw new AuraHandledException('Internal Server Error.Please Try again');  
            }
        }
        
        
    }

    @AuraEnabled
    public static void sendJobOrderDeclineEmail(Id jobOrderId) {
        try{
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId,account.name FROM Contact WHERE Id =: currentUser.ContactId];

        User MSPUser = [SELECT Id,Name,Email FROM User WHERE Id =:  System.Label.Tier_2_Candidate_Owner_Id];
      
            sirenum__JobOrder__c  jobrec=[select id,name,sirenum__Site__r.Owner.Name,sirenum__Site__r.Owner.Email,Job_Order_Number__c from sirenum__JobOrder__c where ID=:jobOrderId];
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'no.reply@bluearrow.co.uk' LIMIT 1];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

         email.setOrgWideEmailAddressId(owea[0].Id);
        email.setToAddresses(new String[] { 'harrisoncatering@bluearrow.co.uk','nikhil@frankbelford.com','ajay@frankbelford.com' });
        
        email.setSubject('Job Order Declined by Supplier');


         String emailBody = '<p>Dear MSP Team,</p>'
                        + '<p><strong>' + userContact.account.name + '</strong> has declined to fill <strong>'+ jobrec.Job_Order_Number__c+ ' ' + jobrec.name + '</strong>.</p>'
                        + '<p>Please ensure that Blue Arrow and/or other suppliers are working to fulfill the client requirements.</p>'
                        + '<p>Thank you</p>';
                       

         email.setHtmlBody(emailBody);  

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

        insert new Job_Order_Decline_Details__c(Job_Order__c=jobrec.Id, Supplier_Account__c=userContact.AccountId );
        }catch( exception e){
            throw new AuraHandledException('error sending email: ' + e.getMessage());
        }
    }
    
     @AuraEnabled
    public static void deletecreatedcandidate(Id contactId) {
        
        delete [select id from contact where id =:contactId];
    }
    
    
}