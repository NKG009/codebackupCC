@IsTest
public class TestAgencyAccountAuthentication {
    @testSetup
    static void setup(){
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = false;
        insert cs1;
    }
    //MasterLabel, Access_Token_Url__c,Client_ID__c,Client_Secret__c,OAuth_Url__c,Redirect_Uri__c
    
    public static testmethod void oauth(){
        
        Id rctId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
        account acct= new account();
        acct.name='tastacc';
        acct.RecordTypeId=rctId;
        insert acct;
        
        Agency_Integration_Info__c aa = new Agency_Integration_Info__c();
        aa.Agency_Account__c=acct.id;
        aa.Client_Secret__c='14d5610d-ae17-45c3-b639-5898572fbeff';
        aa.Client_ID__c='c98a4c0c-d70b-46ed-b198-d7d0d7fd16cc';
        aa.Access_Token__c='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2NzI4NDMwODMsImV4cCI6MTY3Mjg0NjY4MywiaXNzIjoiaHR0cHM6Ly9sb2dpbi5wcm9wZXJ0eW1lLmNvbSIsImF1ZCI6WyJodHRwczovL2xvZ2luLnByb3BlcnR5bWUuY29tL3Jlc291cmNlcyIsImh0dHBzOi8vYXBwLnByb3BlcnR5bWUuY29tL2FwaSJdLCJjbGllbnRfaWQiOiJjOThhNGMwYy1kNzBiLTQ2ZWQtYjE5OC1kN2QwZDdmZDE2Y2MiLCJzdWIiOiJDdXN0b21lcklkX2FlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsImF1dGhfdGltZSI6MTY3Mjg0MzA4MiwiaWRwIjoibG9jYWwiLCJjdXN0b21lcl9pZCI6ImFlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsIm1lbWJlcl9pZCI6ImFlMmUwNGRhLWM2YTMtNDgyYy04N2EzLTliMTliMGQ2YTczZiIsIm1lbWJlcl9hY2Nlc3NfaWQiOiJhZTJlMDRkYS1jNmFkLTRiMzMtOGNmYi0yZjQ4Njg2MTExNjgiLCJzY29wZSI6WyJwcm9wZXJ0eTpyZWFkIiwiYWN0aXZpdHk6d3JpdGUiLCJjb21tdW5pY2F0aW9uOnJlYWQiLCJhY3Rpdml0eTpyZWFkIiwidHJhbnNhY3Rpb246d3JpdGUiLCJjb250YWN0OnJlYWQiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl19.uk09Iqltdzx5iueUmoLX4drWSFUdxETuVXcijHrWT-aR3ap4xCTF0C2_M03saPZEozjggTuo4a-cL7e-ck8TtqyYUj698fQ3vyNUZblMsz10wTL93FF-JFeYJNMtCk_KkyJCJ740uEk1t2mT-h2SQNmUpImFFMfHfCOcvk1DHPYuEW685Sp3ExinTXXzeFKR6nFQOKAjT-6ecdYPr6zpIapRXUOBFTg88rBPdpyHMSkYkdbWrlBFJJh5CiPBTCPlDIvXT1KviF5OKPA9sKR80geH1x30gYMM2Kza4PIJvfEsgh7pAUQ56uw4_-9LbsO2PchlrvU1g1_i3yQg5M6ABA';
        aa.Refresh_Token__c='f4d22d24fa08ee5d81e91d6a66804398f1f9e1d428cd669a784584af752a3fbb';
        aa.Expires_In_Seconds__c=3600;
        insert aa;
        test.startTest();
        AgencyAccountAuthenticationController.getOAuthcode(aa.id); 
        test.stopTest();
    } 
    public static testmethod void authorisationcode(){
        Id rctId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
        account acct= new account();
        acct.name='tastacc';
        acct.RecordTypeId=rctId;
        insert acct;
        
        Agency_Integration_Info__c aa = new Agency_Integration_Info__c();
        aa.Agency_Account__c=acct.id;
        aa.Client_Secret__c='14d5610d-ae17-45c3-b639-5898572fbeff';
        aa.Client_ID__c='c98a4c0c-d70b-46ed-b198-d7d0d7fd16cc';
        aa.Access_Token__c='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2NzI4NDMwODMsImV4cCI6MTY3Mjg0NjY4MywiaXNzIjoiaHR0cHM6Ly9sb2dpbi5wcm9wZXJ0eW1lLmNvbSIsImF1ZCI6WyJodHRwczovL2xvZ2luLnByb3BlcnR5bWUuY29tL3Jlc291cmNlcyIsImh0dHBzOi8vYXBwLnByb3BlcnR5bWUuY29tL2FwaSJdLCJjbGllbnRfaWQiOiJjOThhNGMwYy1kNzBiLTQ2ZWQtYjE5OC1kN2QwZDdmZDE2Y2MiLCJzdWIiOiJDdXN0b21lcklkX2FlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsImF1dGhfdGltZSI6MTY3Mjg0MzA4MiwiaWRwIjoibG9jYWwiLCJjdXN0b21lcl9pZCI6ImFlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsIm1lbWJlcl9pZCI6ImFlMmUwNGRhLWM2YTMtNDgyYy04N2EzLTliMTliMGQ2YTczZiIsIm1lbWJlcl9hY2Nlc3NfaWQiOiJhZTJlMDRkYS1jNmFkLTRiMzMtOGNmYi0yZjQ4Njg2MTExNjgiLCJzY29wZSI6WyJwcm9wZXJ0eTpyZWFkIiwiYWN0aXZpdHk6d3JpdGUiLCJjb21tdW5pY2F0aW9uOnJlYWQiLCJhY3Rpdml0eTpyZWFkIiwidHJhbnNhY3Rpb246d3JpdGUiLCJjb250YWN0OnJlYWQiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl19.uk09Iqltdzx5iueUmoLX4drWSFUdxETuVXcijHrWT-aR3ap4xCTF0C2_M03saPZEozjggTuo4a-cL7e-ck8TtqyYUj698fQ3vyNUZblMsz10wTL93FF-JFeYJNMtCk_KkyJCJ740uEk1t2mT-h2SQNmUpImFFMfHfCOcvk1DHPYuEW685Sp3ExinTXXzeFKR6nFQOKAjT-6ecdYPr6zpIapRXUOBFTg88rBPdpyHMSkYkdbWrlBFJJh5CiPBTCPlDIvXT1KviF5OKPA9sKR80geH1x30gYMM2Kza4PIJvfEsgh7pAUQ56uw4_-9LbsO2PchlrvU1g1_i3yQg5M6ABA';
        aa.Refresh_Token__c='f4d22d24fa08ee5d81e91d6a66804398f1f9e1d428cd669a784584af752a3fbb';
        aa.Expires_In_Seconds__c=3600;
        insert aa;
        
        ApexPages.currentPage().getParameters().put('code','eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2NzI4NDMwODMsImV4cCI6MTY3Mjg0NjY4MywiaXNzIjoiaHR0cHM6Ly9sb2dpbi5wcm9wZXJ0eW1lLmNvbSIsImF1ZCI6WyJodHRwczovL2xvZ2luLnByb3BlcnR5bWUuY29tL3Jlc291cmNlcyIsImh0dHBzOi8vYXBwLnByb3BlcnR5bWUuY29tL2FwaSJdLCJjbGllbnRfaWQiOiJjOThhNGMwYy1kNzBiLTQ2ZWQtYjE5OC1kN2QwZDdmZDE2Y2MiLCJzdWIiOiJDdXN0b21lcklkX2FlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsImF1dGhfdGltZSI6MTY3Mjg0MzA4MiwiaWRwIjoibG9jYWwiLCJjdXN0b21lcl9pZCI6ImFlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsIm1lbWJlcl9pZCI6ImFlMmUwNGRhLWM2YTMtNDgyYy04N2EzLTliMTliMGQ2YTczZiIsIm1lbWJlcl9hY2Nlc3NfaWQiOiJhZTJlMDRkYS1jNmFkLTRiMzMtOGNmYi0yZjQ4Njg2MTExNjgiLCJzY29wZSI6WyJwcm9wZXJ0eTpyZWFkIiwiYWN0aXZpdHk6d3JpdGUiLCJjb21tdW5pY2F0aW9uOnJlYWQiLCJhY3Rpdml0eTpyZWFkIiwidHJhbnNhY3Rpb246d3JpdGUiLCJjb250YWN0OnJlYWQiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl19.uk09Iqltdzx5iueUmoLX4drWSFUdxETuVXcijHrWT-aR3ap4xCTF0C2_M03saPZEozjggTuo4a-cL7e-ck8TtqyYUj698fQ3vyNUZblMsz10wTL93FF-JFeYJNMtCk_KkyJCJ740uEk1t2mT-h2SQNmUpImFFMfHfCOcvk1DHPYuEW685Sp3ExinTXXzeFKR6nFQOKAjT-6ecdYPr6zpIapRXUOBFTg88rBPdpyHMSkYkdbWrlBFJJh5CiPBTCPlDIvXT1KviF5OKPA9sKR80geH1x30gYMM2Kza4PIJvfEsgh7pAUQ56uw4_-9LbsO2PchlrvU1g1_i3yQg5M6ABA');
        ApexPages.currentPage().getParameters().put('state',aa.id);
        AgencyAccountAuthenticationController aaac = new AgencyAccountAuthenticationController();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockcallout());
        aaac.getAuthorization();
        Test.stopTest();
        
    }
    
     public static testmethod void refreshtokenbatch(){
        Id rctId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Real_Estate_Office').getRecordTypeId();
        account acct= new account();
        acct.name='tastacc';
        acct.RecordTypeId=rctId;
        insert acct;
        
        Agency_Integration_Info__c aa = new Agency_Integration_Info__c();
        aa.Agency_Account__c=acct.id;
        aa.Client_Secret__c='14d5610d-ae17-45c3-b639-5898572fbeff';
        aa.Client_ID__c='c98a4c0c-d70b-46ed-b198-d7d0d7fd16cc';
        aa.Access_Token__c='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2NzI4NDMwODMsImV4cCI6MTY3Mjg0NjY4MywiaXNzIjoiaHR0cHM6Ly9sb2dpbi5wcm9wZXJ0eW1lLmNvbSIsImF1ZCI6WyJodHRwczovL2xvZ2luLnByb3BlcnR5bWUuY29tL3Jlc291cmNlcyIsImh0dHBzOi8vYXBwLnByb3BlcnR5bWUuY29tL2FwaSJdLCJjbGllbnRfaWQiOiJjOThhNGMwYy1kNzBiLTQ2ZWQtYjE5OC1kN2QwZDdmZDE2Y2MiLCJzdWIiOiJDdXN0b21lcklkX2FlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsImF1dGhfdGltZSI6MTY3Mjg0MzA4MiwiaWRwIjoibG9jYWwiLCJjdXN0b21lcl9pZCI6ImFlMmUwNGRhLWFjN2YtNGVkOC05YTZhLTVhZTA4ZDgwMzFlOCIsIm1lbWJlcl9pZCI6ImFlMmUwNGRhLWM2YTMtNDgyYy04N2EzLTliMTliMGQ2YTczZiIsIm1lbWJlcl9hY2Nlc3NfaWQiOiJhZTJlMDRkYS1jNmFkLTRiMzMtOGNmYi0yZjQ4Njg2MTExNjgiLCJzY29wZSI6WyJwcm9wZXJ0eTpyZWFkIiwiYWN0aXZpdHk6d3JpdGUiLCJjb21tdW5pY2F0aW9uOnJlYWQiLCJhY3Rpdml0eTpyZWFkIiwidHJhbnNhY3Rpb246d3JpdGUiLCJjb250YWN0OnJlYWQiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl19.uk09Iqltdzx5iueUmoLX4drWSFUdxETuVXcijHrWT-aR3ap4xCTF0C2_M03saPZEozjggTuo4a-cL7e-ck8TtqyYUj698fQ3vyNUZblMsz10wTL93FF-JFeYJNMtCk_KkyJCJ740uEk1t2mT-h2SQNmUpImFFMfHfCOcvk1DHPYuEW685Sp3ExinTXXzeFKR6nFQOKAjT-6ecdYPr6zpIapRXUOBFTg88rBPdpyHMSkYkdbWrlBFJJh5CiPBTCPlDIvXT1KviF5OKPA9sKR80geH1x30gYMM2Kza4PIJvfEsgh7pAUQ56uw4_-9LbsO2PchlrvU1g1_i3yQg5M6ABA';
        aa.Refresh_Token__c='f4d22d24fa08ee5d81e91d6a66804398f1f9e1d428cd669a784584af752a3fbb';
        //aa.Expires_In_Seconds__c=3600;
         
        insert aa;
         
        
          test.startTest();
         
          AgencyAccountAuthenticationController.GetRefreshToken(aa.id); 
         Test.setMock(HttpCalloutMock.class, new mockcallout());
          //aa.Expires_In_Seconds__c=aa.Expires_In_Seconds__c-3700;
         //update aa;
         Agency_Integration_Info__c aarec =[select id,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c from Agency_Integration_Info__c where id=:aa.Id limit 1];
        BatchRefreshTokenPropertyMe srcb = new BatchRefreshTokenPropertyMe ();
            Database.executebatch(srcb);
         
  
        
      test.stopTest();   
        
     }
    
     public static testmethod void batchclass(){
        
    Test.startTest();
        SchedularForBatchRefreshTokenPropertyMe schqb = new SchedularForBatchRefreshTokenPropertyMe(); 
        String sch = '0 0 * * * ?'; 
        system.schedule('AccessTokenbtch', sch, schqb); 
        Test.stopTest();
        
        
        
    }
    
    public class mockcallout implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();   
            res.setStatusCode(200);
            res.setHeader('Authorization' , 'Basic ');
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "token_type": "Bearer", "expires_in":3600,"access_token": "eyJraWQ.....rm8EA4osYg","scope": "offline_access openid","refresh_token": "i6mapTIAVSp2oJkgUnCACKKfZxt_H5MBLiqcybBBd04","id_token": "eyJraWQiOiJXAn3ty6o-yeA"}');
            return res;            
        }
    }   
}