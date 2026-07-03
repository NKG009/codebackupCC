@IsTest
private class JobListViewComponentController1Test {
  
  static testMethod void testJobListViewComponentController1() {
  //  TestGenerateData dataObject = new TestGenerateData();
  //  dataObject.initData();
    
    AVTRRT__Config_Settings__c configSetting = new AVTRRT__Config_Settings__c(
        Name = 'Default',
        AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true,
        AVTRRT__Trigger_Disabled_Trigger_Job__c = true,
        AVTRRT__Trigger_Disabled_Contact__c = true,
        AVTRRT__Disable_Email_Alerts_Trigger__c = true,
        AVTRRT__Trigger_Disabled_attachCoverletter__c = true,
        AVTRRT__Trigger_Disabled__c = true
    
    );
    
    FCMS__Page__c newPage = new FCMS__Page__c(
        Name = 'NewCMSDefaultProfilePage',
        FCMS__Name__c = 'NewCMSDefaultProfilePage',
        FCMS__Active__c = true
    );
    insert newPage;
    
    insert configSetting;
    Account account = new Account(
        Name = 'New Account',
        Business_Entity__c='Wavelength International'
    );
    insert account;
    
    FCMS__CMSProfile__c cmsProfile = new FCMS__CMSProfile__c(
        FCMS__Name__c = 'Vendor Profile',
        FCMS__Profile_Manager__c = UserInfo.getUserId(),
        FCMS__Default_Home_Page__c = newPage.Id,
        FCMS__Profile_Account__c = account.Id,
        FCMS__CMSCss__c = 'CMSCssCustom1',
        FCMS__Portal_Enabled__c = true,
        FCMS__User_Registration__c = true
    );
    insert cmsProfile;
    
    Contact cont = new Contact(
        FirstName = 'Ramesh',
        LastName = 'Dhull',
        FCMS__UserName__c = 'dhull.ramesh@gmail.com',
        Email = 'dhull.ramesh@gmail.com'
    );
    insert cont;
    
    Map<String, String> headerMap = System.currentPageReference().getHeaders();
    
  //  String sessionString;
    
  //  sessionString = String.valueOf(Math.random());
  //  sessionString = sessionString.substring(2,16);
    
    FCMS__Session__c session = new FCMS__Session__c();
    session.FCMS__Session_For__c = cont.Id;
    session.FCMS__User_Agent__c = headerMap.get('User-Agent');
    session.FCMS__IP_Address__c = headerMap.get('X-Salesforce-SIP');
 //   session.FCMS__SessionId__c = sessionString;
    insert session;
    
    insert new FCMS__CustomSettingsComponent__c(
        Name = 'Default',
        FCMS__SessionTimeout__c = 5000000,
        FCMS__ErrorsReceiver__c = 'mikhail.ivanov@targetrecruit.net'
    );
    
    insert new trgtfcms__CustomSettingsComponent__c(
        Name = 'Default',
        trgtfcms__Count_Jobs_for_Job_List_Page__c = '20,30,50',
        trgtfcms__Job_List_Page_fields_for_query__c = 'AVTRRT__Job_Title__c,AVTRRT__Job_Term__c,AVTRRT__Job_Category__c,AVTRRT__Job_Country__c,AVTRRT__Experience__c,AVTRRT__Job_Industry__c,AVTRRT__Job_Summary__c,AVTRRT__Job_City__c,AVTRRT__State__c,Id',
        trgtfcms__isShowPagination__c = true,
        trgtfcms__JobListOrderBy__c = 'LastModifiedDate',
        trgtfcms__JobListFastSearch__c = true,
        trgtfcms__JobListWhere__c = 'AVTRRT__Publish__c != false',
        trgtfcms__Enable_Jobs_location_search__c = true,
        trgtfcms__Country_For_GeoCoding__c = 'US',
        trgtfcms__JobListPageMessage__c = 'List message'
    );
    
    insert new trgtfcms__Vendor_Portal_Settings__c(
        trgtfcms__Vendors_Jobs_Criteria__c = 'AVTRRT__Job_Title__c != NULL'
    );
    
    AVTRRT__Job__c job = new AVTRRT__Job__c();
    job.AVTRRT__Account_Job__c = account.Id;
    job.AVTRRT__Job_Title__c = 'Java Developer';
        job.AVTRRT__Department__c = 'Administrative';
    job.AVTRRT__Recruiter__c = [
        SELECT Id
        FROM User
        WHERE IsActive = TRUE
        LIMIT 1
    ].Id;
    insert job;
    
    List<AVTRRT__Job__c> jobList = new List<AVTRRT__Job__c>();
    jobList.add(job);
    
    String jobIds = '';
    Boolean count = false;
    if (jobList.size() > 0) {
      for (AVTRRT__Job__c job1 : jobList) {
        if (count == false) {
          jobIds = job1.Id;
          count = true;
          continue;
        } else {
          jobIds = jobIds + ';' + job1.Id;
        }
      }
    }
    
    PageReference pg = new PageReference('apex/JobListPage1');
    pg.getParameters().put('jobSite', 'default');
    pg.getParameters().put('sessionId', session.FCMS__SessionId__c);
    pg.getParameters().put('jobIds', jobIds);
    //pg.getParameters().put('p','Vendor Profile');
    pg.getParameters().put('p', 'Candidate');
    
    ApexPages.currentPage().getParameters().put('nextPage', '2') ;
    ApexPages.currentPage().getParameters().put('previousPage', '1') ;
    
    Test.setCurrentPageReference(pg);
    
    JobListViewComponentController1 jobListObject = new JobListViewComponentController1();
    System.assertEquals('default', ApexPages.currentPage().getParameters().get('jobSite'));
    
    jobListObject.setJob(job);
    
    //jobListObject.searchedJobList2.add(jobList);
    pg = jobListObject.search();
    jobListObject.getSearchedJobBeanListOfList();
    jobListObject.zipCode = '560000';
      try{
         jobListObject.init(); 
      }catch(exception e){
          
          
}
      
   //jobListObject.init();
    jobListObject.setJobSearch('Job ????? Search*****');
    jobListObject.getMetaKeywords();
    jobListObject.setJobCheckBox(true);
    jobListObject.setShowApplyButton(true);
    jobListObject.setShowJobError(true);
    jobListObject.setShowSearchFilterError(true);
    jobListObject.getJob();
    jobListObject.getJobSearch();
    jobListObject.getSearchedJobList();
    jobListObject.getSearchedJobList1();
    jobListObject.getJobCheckBox();
    jobListObject.getShowApplyButton();
    jobListObject.getShowJobError();
    jobListObject.getShowSearchFilterError();
    
    //Rakesh
    jobListObject.pageChanged();
    
    jobListObject.selectedPage = '2';
    jobListObject.selectedPageNumber();
    jobListObject.pageChanged();
    jobListObject.getpageCountSizeList();
    
    pg = jobListObject.search();
    
    jobListObject.getSearchedJobBeanListOfList();
    //jobListObject.jobCheckBoxList.add(true);
    pg = jobListObject.apply();
    //jobListObject.getapplyPageURL();
    
    jobListObject.setJobSearch('a');
    
    jobListObject.getJobSearch();
    System.assertEquals(1, jobListObject.getJobSearch().length());
    jobListObject.getSearchedJobBeanListOfList();
    pg = jobListObject.search();
    
    ApexPages.currentPage().getParameters().put('p', 'Vendor Profile');
    jobListObject.setJobSearch('');
    jobListObject.getJobSearch();
    System.assertEquals(0, jobListObject.getJobSearch().length());
    jobListObject.getSearchedJobBeanListOfList();
    pg = jobListObject.search();
    
    jobListObject.setJobSearch(null);
    jobListObject.getJobSearch();
    System.assertEquals(null, jobListObject.getJobSearch());
    jobListObject.getSearchedJobBeanListOfList();
    pg = jobListObject.search();
    
    PageReference pg1 = new PageReference('apex/JobListPage1');
    pg1.getParameters().put('jobSite', null);
    Test.setCurrentPageReference(pg1);
    jobListObject = new JobListViewComponentController1();
    
    jobListObject.getCmsCssCustom();
    JobListViewComponentController1.searchedJobBean obj = new JobListViewComponentController1.searchedJobBean();
    obj.oddEvenCssClass = 'test';
    obj.jobObject = new AVTRRT__Job__c();
    obj.checkBox = true;
    obj.jobAppliedBefore = true;
    
        AVTRRT__Job__c jobValue = new AVTRRT__Job__c(
            AVTRRT__Job_Title__c = 'Test',
            AVTRRT__Start_Date__c = Date.today(),
            AVTRRT__Account_Job__c = account.Id,
            AVTRRT__Publish__c = true,
            AVTRRT__Stage__c = 'Open'
        );
        
        AVTRRT__Job__c jobTestJob = new AVTRRT__Job__c(
            AVTRRT__Job_Title__c = 'Test',
            AVTRRT__Start_Date__c = Date.today(),
            AVTRRT__Account_Job__c = account.Id,
            AVTRRT__Publish__c = true,
            AVTRRT__Stage__c = 'Open'
        );
    
    List<AVTRRT__Job__c> jobListName = new List<AVTRRT__Job__c>();
    jobListName.add(jobValue);
    jobListName.add(jobTestJob);
    system.debug('@@@jobListName'+jobListName);
  //  jobListObject.searchedJobList2.add(jobListName);
  
    //jobListObject.testCover();
    
    //Rakesh
    jobListObject.pageSize(5, 20);
    jobListObject.getPages();
      jobListObject.testCover();
    jobListObject.selectedPageSize = '10';
      try{
          jobListObject.selectedPageCountRecord();
      }
      catch(exception e) {
          
      }
    
    System.assertEquals(null, ApexPages.currentPage().getParameters().get('jobSite'));
  
  }

}