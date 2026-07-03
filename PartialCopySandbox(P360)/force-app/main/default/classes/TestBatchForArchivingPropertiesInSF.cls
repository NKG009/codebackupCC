@IsTest
public class TestBatchForArchivingPropertiesInSF {
    
    @testSetup
    static void setup(){
        
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = false;
        insert cs1;
        
        Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
        account acc= new account();
        acc.name='paccount';
        acc.RecordTypeId=rcId;
        insert acc;
        
        Id rcIdp=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        
        Account acc1 = new Account();
        acc1.Name = 'Account A';
        acc.RecordTypeId=rcIdp;
        acc1.ParentId=acc.Id;
        acc1.External_ID__c='afd602b0-47ca-4d64-947a-3543b40bf78b';
        insert acc1;
        
        Agency_Integration_Info__c ai = new Agency_Integration_Info__c();
        ai.Agency_Account__c=acc.Id;
        ai.Access_Token__c='xyz';
        ai.Client_ID__c='xyaa';
        ai.Client_Secret__c='xyaa';
        ai.Refresh_Token__c='xyaa';
        ai.Supplier_ID__c='ae2e04da-c729-46ea-acf9-d726b44de2c6';
        insert ai;
        
    }
    
    
    @Istest
    public static void newtestmethod(){
        
        test.startTest();
        BatchForArchivingPropertiesInSF bc = new BatchForArchivingPropertiesInSF();
        database.executeBatch(bc,1);
        test.setMock(HttpCalloutMock.class, new mockcallout());
        test.stopTest();
        
        
        
        
    }
    
     @Istest
    public static void newerrorblockmethod(){
        
        test.startTest();
        BatchForArchivingPropertiesInSF bc = new BatchForArchivingPropertiesInSF();
        database.executeBatch(bc,1);
        test.setMock(HttpCalloutMock.class, new mockcalloutnew());
        test.stopTest();
        
        
        
        
    }
    
    public class mockcallout implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse(); 
            res.setStatusCode(200);
            res.setHeader('Authorization' , 'Basic ');
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"OwnerContactReference":null,"TenantContactReference":null,"ManagerName":"Tony Wagener","ActiveManagerTeams":"&#124;Team 1&#124;","RentAmount":0,"RentPeriod":"weekly","EffectivePaidTo":null,"TenancyStart":null,"TenancyEnd":null,"AgreementStart":null,"AgreementEnd":null,"OwnerContactId":null,"TenantContactId":null,"OwnerFolioCode":null,"TenantFolioCode":null,"SellerFolioCode":null,"SearchText":"Nirwana Street, 333      ","Id":"afd602b0-47ca-4d64-947a-3543b40bf78b","CustomerId":"ae2e04da-ac7f-4ed8-9a6a-5ae08d8031e8","Reference":"Nirwana Street, 333","Address":{"Unit":"","Number":"","Street":"Ann St","Suburb":"uk","Locality":"","PostalCode":"NE31","State":"England","Country":"United Kingdom","BuildingName":"","MailboxName":"","Latitude":54.979884,"Longitude":-1.5254999,"Text":"Ann Stnuk England NE31","Reference":"Ann St"},"AddressText":"Ann St, uk England NE31","PrimaryType":"Residential","PropertySubtype":"House","Bedrooms":1,"Bathrooms":0,"CarSpaces":0,"Area":null,"AreaUnit":"SquareMetres","LandArea":null,"LandAreaUnit":"SquareMetres","Description":null,"Notes":null,"NextInspectionOn":null,"KeyNumber":null,"ArchivedOn":"2023-03-31T12:32:17.0000000Z","AdRentAmount":null,"AdRentPeriod":null,"ActiveOwnershipId":null,"ActiveSaleAgreementId":null,"ActiveTenancyId":null,"Longitude":-1.5254999,"Latitude":54.9798840,"InspectionFrequency":null,"InspectionFrequencyType":"weekly","InitialInspectionFrequency":null,"InitialInspectionFrequencyType":"weekly","MainPhotoDocumentId":null,"ActiveManagerMemberId":"ae2e04da-c6a3-482c-87a3-9b19b0d6a73f","Labels":null,"StrataManagerContactId":null,"RuralCategory":"Cropping","DisplayAddress":null,"IsRental":false,"IsArchived":true,"CreatedOn":"2023-03-31T12:31:47.0000000Z","UpdatedOn":"2023-03-31T12:32:17.0000000Z","ExternalListingId":null,"ActiveRentalListingId":null,"ActiveSaleListingId":null}');
            res.setBody('[{"OwnerContactReference":null,"TenantContactReference":null,"ManagerName":"Tony Wagener","ActiveManagerTeams":"&#124;Team 1&#124;","RentAmount":0,"RentPeriod":"weekly","EffectivePaidTo":null,"TenancyStart":null,"TenancyEnd":null,"AgreementStart":null,"AgreementEnd":null,"OwnerContactId":null,"TenantContactId":null,"OwnerFolioCode":null,"TenantFolioCode":null,"SellerFolioCode":null,"SearchText":"Nirwana Street, 333      ","Id":"afd602b0-47ca-4d64-947a-3543b40bf78b","CustomerId":"ae2e04da-ac7f-4ed8-9a6a-5ae08d8031e8","Reference":"Nirwana Street, 333","Address":{"Unit":"","Number":"","Street":"Ann St","Suburb":"uk","Locality":"","PostalCode":"NE31","State":"England","Country":"United Kingdom","BuildingName":"","MailboxName":"","Latitude":54.979884,"Longitude":-1.5254999,"Text":"Ann Stuk England NE31","Reference":"Ann St"},"AddressText":"Ann St, uk England NE31","PrimaryType":"Residential","PropertySubtype":"House","Bedrooms":1,"Bathrooms":0,"CarSpaces":0,"Area":null,"AreaUnit":"SquareMetres","LandArea":null,"LandAreaUnit":"SquareMetres","Description":null,"Notes":null,"NextInspectionOn":null,"KeyNumber":null,"ArchivedOn":"2023-03-31T12:32:17.0000000Z","AdRentAmount":null,"AdRentPeriod":null,"ActiveOwnershipId":null,"ActiveSaleAgreementId":null,"ActiveTenancyId":null,"Longitude":-1.5254999,"Latitude":54.9798840,"InspectionFrequency":null,"InspectionFrequencyType":"weekly","InitialInspectionFrequency":null,"InitialInspectionFrequencyType":"weekly","MainPhotoDocumentId":null,"ActiveManagerMemberId":"ae2e04da-c6a3-482c-87a3-9b19b0d6a73f","Labels":null,"StrataManagerContactId":null,"RuralCategory":"Cropping","DisplayAddress":null,"IsRental":false,"IsArchived":true,"CreatedOn":"2023-03-31T12:31:47.0000000Z","UpdatedOn":"2023-03-31T12:32:17.0000000Z","ExternalListingId":null,"ActiveRentalListingId":null,"ActiveSaleListingId":null}]');
            return res;            
        }
    }
    
    
    public class mockcalloutnew implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse(); 
            res.setStatusCode(200);
            res.setHeader('Authorization' , 'Basic ');
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"OwnerContactReference":null,"TenantContactReference":null,"ManagerName":"Tony Wagener","ActiveManagerTeams":"&#124;Team 1&#124;","RentAmount":0,"RentPeriod":"weekly","EffectivePaidTo":null,"TenancyStart":null,"TenancyEnd":null,"AgreementStart":null,"AgreementEnd":null,"OwnerContactId":null,"TenantContactId":null,"OwnerFolioCode":null,"TenantFolioCode":null,"SellerFolioCode":null,"SearchText":"Nirwana Street, 333      ","Id":"afd602b0-47ca-4d64-947a-3543b40bf78b","CustomerId":"ae2e04da-ac7f-4ed8-9a6a-5ae08d8031e8","Reference":"Nirwana Street, 333","Address":{"Unit":"","Number":"","Street":"Ann St","Suburb":"uk","Locality":"","PostalCode":"NE31","State":"England","Country":"United Kingdom","BuildingName":"","MailboxName":"","Latitude":54.979884,"Longitude":-1.5254999,"Text":"Ann Stnuk England NE31","Reference":"Ann St"},"AddressText":"Ann St, uk England NE31","PrimaryType":"Residential","PropertySubtype":"House","Bedrooms":1,"Bathrooms":0,"CarSpaces":0,"Area":null,"AreaUnit":"SquareMetres","LandArea":null,"LandAreaUnit":"SquareMetres","Description":null,"Notes":null,"NextInspectionOn":null,"KeyNumber":null,"ArchivedOn":"2023-03-31T12:32:17.0000000Z","AdRentAmount":null,"AdRentPeriod":null,"ActiveOwnershipId":null,"ActiveSaleAgreementId":null,"ActiveTenancyId":null,"Longitude":-1.5254999,"Latitude":54.9798840,"InspectionFrequency":null,"InspectionFrequencyType":"weekly","InitialInspectionFrequency":null,"InitialInspectionFrequencyType":"weekly","MainPhotoDocumentId":null,"ActiveManagerMemberId":"ae2e04da-c6a3-482c-87a3-9b19b0d6a73f","Labels":null,"StrataManagerContactId":null,"RuralCategory":"Cropping","DisplayAddress":null,"IsRental":false,"IsArchived":true,"CreatedOn":"2023-03-31T12:31:47.0000000Z","UpdatedOn":"2023-03-31T12:32:17.0000000Z","ExternalListingId":null,"ActiveRentalListingId":null,"ActiveSaleListingId":null}');
            res.setBody('[{"OwnerContactReference":null,"TenantContactReference":null,"ManagerName":"Tony Wagener","ActiveManagerTeams":"&#124;Team 1&#124;","RentAmount":0,"RentPeriod":"weekly","EffectivePaidTo":null,"TenancyStart":null,"TenancyEnd":null,"AgreementStart":null,"AgreementEnd":null,"OwnerContactId":null,"TenantContactId":null,"OwnerFolioCode":null,"TenantFolioCode":null,"SellerFolioCode":null,"SearchText":"Nirwana Street, 333      ","Id":"afd602b0-47ca-4d64-947a-3543b40bf78b","CustomerId":"ae2e04da-ac7f-4ed8-9a6a-5ae08d8031e8","Reference":"Nirwana Street, 333","Address":{"Unit":"","Number":"","Street":"Ann St","Suburb":"uk","Locality":"","PostalCode":"NE31","State":"England","Country":"United Kingdom","BuildingName":"","MailboxName":"","Latitude":54.979884,"Longitude":-1.5254999,"Text":"Ann Stu\nk England NE31","Reference":"Ann St"},"AddressText":"Ann St, uk England NE31","PrimaryType":"Residential","PropertySubtype":"House","Bedrooms":1,"Bathrooms":0,"CarSpaces":0,"Area":null,"AreaUnit":"SquareMetres","LandArea":null,"LandAreaUnit":"SquareMetres","Description":null,"Notes":null,"NextInspectionOn":null,"KeyNumber":null,"ArchivedOn":"2023-03-31T12:32:17.0000000Z","AdRentAmount":null,"AdRentPeriod":null,"ActiveOwnershipId":null,"ActiveSaleAgreementId":null,"ActiveTenancyId":null,"Longitude":-1.5254999,"Latitude":54.9798840,"InspectionFrequency":null,"InspectionFrequencyType":"weekly","InitialInspectionFrequency":null,"InitialInspectionFrequencyType":"weekly","MainPhotoDocumentId":null,"ActiveManagerMemberId":"ae2e04da-c6a3-482c-87a3-9b19b0d6a73f","Labels":null,"StrataManagerContactId":null,"RuralCategory":"Cropping","DisplayAddress":null,"IsRental":false,"IsArchived":true,"CreatedOn":"2023-03-31T12:31:47.0000000Z","UpdatedOn":"2023-03-31T12:32:17.0000000Z","ExternalListingId":null,"ActiveRentalListingId":null,"ActiveSaleListingId":null}]');
            return res;            
        }
    }
    
   static testMethod void testParse() {
         //String json ='[{"OwnerContactReference":null,"TenantContactReference":null,"ManagerName":"Tony Wagener","ActiveManagerTeams":"&#124;Team 1&#124;","RentAmount":0,"RentPeriod":"weekly","EffectivePaidTo":null,"TenancyStart":null,"TenancyEnd":null,"AgreementStart":null,"AgreementEnd":null,"OwnerContactId":null,"TenantContactId":null,"OwnerFolioCode":null,"TenantFolioCode":null,"SellerFolioCode":null,"SearchText":"Nirwana Street, 333      ","Id":"afd602b0-47ca-4d64-947a-3543b40bf78b","CustomerId":"ae2e04da-ac7f-4ed8-9a6a-5ae08d8031e8","Reference":"Nirwana Street, 333","Address":{"Unit":"","Number":"","Street":"Ann St","Suburb":"uk","Locality":"","PostalCode":"NE31","State":"England","Country":"United Kingdom","BuildingName":"","MailboxName":"","Latitude":54.979884,"Longitude":-1.5254999,"Text":"Ann St\nuk England NE31","Reference":"Ann St"},"AddressText":"Ann St, uk England NE31","PrimaryType":"Residential","PropertySubtype":"House","Bedrooms":1,"Bathrooms":0,"CarSpaces":0,"Area":null,"AreaUnit":"SquareMetres","LandArea":null,"LandAreaUnit":"SquareMetres","Description":null,"Notes":null,"NextInspectionOn":null,"KeyNumber":null,"ArchivedOn":"2023-03-31T12:32:17.0000000Z","AdRentAmount":null,"AdRentPeriod":null,"ActiveOwnershipId":null,"ActiveSaleAgreementId":null,"ActiveTenancyId":null,"Longitude":-1.5254999,"Latitude":54.9798840,"InspectionFrequency":null,"InspectionFrequencyType":"weekly","InitialInspectionFrequency":null,"InitialInspectionFrequencyType":"weekly","MainPhotoDocumentId":null,"ActiveManagerMemberId":"ae2e04da-c6a3-482c-87a3-9b19b0d6a73f","Labels":null,"StrataManagerContactId":null,"RuralCategory":"Cropping","DisplayAddress":null,"IsRental":false,"IsArchived":true,"CreatedOn":"2023-03-31T12:31:47.0000000Z","UpdatedOn":"2023-03-31T12:32:17.0000000Z","ExternalListingId":null,"ActiveRentalListingId":null,"ActiveSaleListingId":null}]';
         String json ='{"OwnerContactReference":"null","TenantContactReference":"null","ManagerName":"Tony Wagener","ActiveManagerTeams":"&#124;Team 1&#124;","RentAmount":0,"RentPeriod":"weekly","EffectivePaidTo":null,"TenancyStart":"null","TenancyEnd":"null","AgreementStart":"null","AgreementEnd":"null","OwnerContactId":"null","TenantContactId":"null","OwnerFolioCode":"null","TenantFolioCode":"null","SellerFolioCode":null,"SearchText":"Nirwana Street, 333      ","Id":"afd602b0-47ca-4d64-947a-3543b40bf78b","CustomerId":"ae2e04da-ac7f-4ed8-9a6a-5ae08d8031e8","Reference":"Nirwana Street, 333","Address":{"Unit":"1","Number":"1","Street":"Ann St","Suburb":"uk","Locality":"22","PostalCode":"NE31","State":"England","Country":"United Kingdom","BuildingName":"222","MailboxName":"222","Latitude":54.979884,"Longitude":-1.5254999,"Text":"Ann Snuk England NE31","Reference":"Ann St"},"AddressText":"Ann St, uk England NE31","PrimaryType":"Residential","PropertySubtype":"House","Bedrooms":1,"Bathrooms":0,"CarSpaces":0,"Area":null,"AreaUnit":"SquareMetres","LandArea":null,"LandAreaUnit":"SquareMetres","Description":null,"Notes":null,"NextInspectionOn":null,"KeyNumber":null,"ArchivedOn":"2023-03-31T12:32:17.0000000Z","AdRentAmount":null,"AdRentPeriod":null,"ActiveOwnershipId":null,"ActiveSaleAgreementId":null,"ActiveTenancyId":null,"Longitude":-1.5254999,"Latitude":54.9798840,"InspectionFrequency":null,"InspectionFrequencyType":"weekly","InitialInspectionFrequency":null,"InitialInspectionFrequencyType":"weekly","MainPhotoDocumentId":null,"ActiveManagerMemberId":"ae2e04da-c6a3-482c-87a3-9b19b0d6a73f","Labels":null,"StrataManagerContactId":null,"RuralCategory":"Cropping","DisplayAddress":null,"IsRental":false,"IsArchived":true,"CreatedOn":"2023-03-31T12:31:47.0000000Z","UpdatedOn":"2023-03-31T12:32:17.0000000Z","ExternalListingId":null,"ActiveRentalListingId":null,"ActiveSaleListingId":null}';
        ArchivingPropertyWrapper r = ArchivingPropertyWrapper.parse(json);
    }
    
    
    
}