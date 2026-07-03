public class CompanyUpsertScheduler implements Database.AllowsCallouts, Schedulable {
    
    private static String applicationKey = '4191e0dd-e77f-44a1-86ba-dfb808abfd4b';
    private static String endpoint = 'https://api.propertytree.io/apikey/v1/application_keys/'+applicationKey;
    private static String subscriptionKey = '90a524b869834ee88c681ece28e2576a';
    
    public void execute(SchedulableContext sc) { 
        getCompanyDetails();
    }
    
    @future(callout=true)
    public static void getCompanyDetails() {
        List<Error_Log__c> errorLogsList = new List<Error_Log__c>();
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');  
        httpRequest.setHeader('Ocp-Apim-Subscription-Key', subscriptionKey);
        httpRequest.setEndpoint(endpoint); 
        Http http = new Http();   
        HttpResponse httpResponse = http.send(httpRequest);  
        if (httpResponse.getStatusCode() == 200) { 
            List<CompanyWrapper> result = (List<CompanyWrapper>) System.JSON.deserialize(httpResponse.getBody(), List<CompanyWrapper>.class);
            
            Map<String, Property_360_Company__c> property360KeyToRecMap = new Map<String, Property_360_Company__c>();
            List<Property_360_Company__c> existingCompanies = Property_360_Company__c.getAll().values();
            for(Property_360_Company__c companyRec : existingCompanies) {
                property360KeyToRecMap.put(companyRec.Key__c, companyRec);
            }

            List<Property_360_Company__c> newCompanies = new List<Property_360_Company__c>();
            List<Property_360_Company__c> deletedCompanies = new List<Property_360_Company__c>();
            
            Map<String, Property_360_Company__c> activeCompanyNamesToRecMap = new Map<String, Property_360_Company__c>();
            Integer companyCounter = (existingCompanies.size() + 1);
            for(CompanyWrapper companyObj : result) {
                Property_360_Company__c companyRec;
                if(property360KeyToRecMap.containsKey(companyObj.key)) {
                    companyRec = property360KeyToRecMap.get(companyObj.key);
                    property360KeyToRecMap.remove(companyObj.key);
                } else {
                    String companyName = (('X' + companyCounter++) + '-' + companyObj.company_name).replaceAll('[/]','');
                     integer lastlen= companyName.length()-1;
                    if(lastlen >= 39){
                        lastlen =38;
                    }
                    companyName = companyName.substring(0,lastlen);
                    system.debug('companyName:-'+companyName +'----'+companyName.length());
                    companyRec = new Property_360_Company__c(Name = companyName, Company_Name__c = companyObj.company_name, Key__c = companyObj.key);
                    newCompanies.add(companyRec);
                }
                activeCompanyNamesToRecMap.put(companyObj.company_name.toLowerCase(), companyRec);
            }
            deletedCompanies.addAll(property360KeyToRecMap.values());
            insert newCompanies;
            delete deletedCompanies;
            
            List<Account> accListToUpdate = new List<Account>();
            for(Account realEstateRec : [SELECT Id, ExternalIdEncrypted__c, Archived__c, Name, RecordType.Name FROM Account where RecordType.Name = 'Real Estate Office' AND API_Connection__c ='Property Tree' ]) {
               // realEstateRec.Archived__c = true;(Name IN: activeCompanyNamesToRecMap.keySet() OR (Name NOT IN: activeCompanyNamesToRecMap.keySet() AND Archived__c = false)
                if(activeCompanyNamesToRecMap.containsKey(realEstateRec.Name.toLowerCase())) {
                   // realEstateRec.Archived__c = false;
                    realEstateRec.ExternalIdEncrypted__c = activeCompanyNamesToRecMap.get(realEstateRec.Name.toLowerCase()).Key__c;
                }
                accListToUpdate.add(realEstateRec);
            }
            update accListToUpdate;
            sendEmail(newCompanies);
        }else {  
            errorLogsList.add(
                ErrorLogUtil.createSampleErrorLog(
                    String.valueOf(httpResponse.getStatusCode()), httpResponse.getStatus(), httpResponse.getStatus(), 'CompanyUpsertScheduler', 'getCompanyDetails', 'https://api.propertytree.io/apikey', null
                )
            );  
        }
        if(!errorLogsList.isEmpty()){
            insert errorLogsList;
        }
    }
    
    public class CompanyWrapper {
        public String key;
        public String company_name;
        public String activation_date;
    }
    
    public static void sendEmail(List<Property_360_Company__c> newCompanies) {
        if(newCompanies != null && !newCompanies.isEmpty()) {
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            for(Property_360_Company__c companyRec : newCompanies) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{'a.t.186807785.u-2806745.9f59433c-51c5-47ce-8ec5-97f5973e6254@tasks.clickup.com'});
                mail.setSubject(companyRec.Company_Name__c + ' <tag Property Tree>');
                mail.PlainTextBody = companyRec.Key__c;
                mailList.add(mail);
            }
            if(!Test.isRunningTest()) Messaging.sendEmail(mailList);
        }
    }
}