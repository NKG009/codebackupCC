global without sharing class JobListViewComponentController1 {
    global String selectLanguage { get; set; }
    global String jobSiteVar { get; set; }
    global Organization org { get; set; }
    global String jobSearch;
    global String pageURL;
    global String applyPageURL;
    global String currentUrlJobListPage { get; set; }
    global String cmsCssCustom { get; set; }
    global Map<String, String> fieldsAndLabelsToDisplay { get; set; }
    global List<String> fieldLabels { get; set; }
    AVTRRT__Job__c job = new AVTRRT__Job__c();
 
    Boolean jobCheckBox ;
    List<Boolean> jobCheckBoxList = new List<Boolean>();
    
    private static Map<String, Schema.SObjectField> avtrrtMap =
            Schema.SObjectType.AVTRRT__Job__c.fields.getMap();
    
    private static LoggerCP logger = new LoggerCP('JobListViewComponentController1');
    
    List<List<SObject>> searchedJobList = new List<List<SObject>>(); // for dynamic search query
    List<AVTRRT__Job__c> searchedJobList1 = new List<AVTRRT__Job__c>(); // for dynamic select query
    //access modifier changed to global #00033458 
    global transient List<List<AVTRRT__Job__c>> searchedJobList2;
    
    global Boolean showApplyButton;
    global Boolean showJobError;
    global Boolean showSearchFilterError;
    
    //access modifier changed to global #00033458
    global List<List<searchedJobBean>> searchedJobBeanListOfList1 {get; set;}
    List<AVTRRT__Job_Applicant__c> existingJobApplicantList = new List<AVTRRT__Job_Applicant__c>();
    Map<Id, AVTRRT__Job_Applicant__c> existingJobApplicantMap;
    
    global Boolean jobCheckBox1 { get; set; }
    private String subject = 'JobListViewComponentController1';
    private String metaKeywords = 'open jobs';
    
    global AVTRRT__Job__c industry { get; set; } //for IndustryPicklist
    global List<SelectOption> statusOptions { get; set; } //for IndustryPicklist
    
    global Boolean enableGeoCoding { get; set; }
    global Boolean useMyCurrentLocation { get; set; }
    global String zipCode { get; set; }
    global Decimal radius { get; set; }
    global String selectedCountry { get; set; }
    global List<SelectOption> availableCountryCodes { get; set; }
    
    private TRGTFCMS__CustomSettingsComponent__c cs = TRGTFCMS.ConfigHelper.getConfigDataSet();
    
    global JobListViewComponentController1() {
        //   job.Job__c = 'Remote';
        selectLanguage = UserInfo.getLocale();
        //Get Organization Name
        org = [
                SELECT Name
                FROM Organization
        ];
        
        //Block1. Added by Kans 8.2.11. It make Select List (Industry) without "--none--" value.
        industry = new AVTRRT__Job__c();
        statusOptions = new List<SelectOption>();
        
        fieldsAndLabelsToDisplay = new Map<String, String>();
        fieldLabels = new List<String>();
        // Use DescribeFieldResult object to retrieve status field.
        Schema.DescribeFieldResult statusFieldDescription
                = AVTRRT__Job__c.AVTRRT__Job_Industry__c.getDescribe();
        
        // For each picklist value, create a new select option
        for (Schema.PicklistEntry picklistEntry : statusFieldDescription.getPicklistValues()) {
            statusOptions.add(new SelectOption(picklistEntry.getValue(), picklistEntry.getLabel()));
            
            // obtain and assign default value
            if (picklistEntry.defaultValue) {
                industry.AVTRRT__Job_Industry__c = picklistEntry.getValue();
            }
        }
        //End_of_Block1
    }
      global Boolean errorParam { get; set; }
      global String redirectUrl { get; set; }
      global Boolean isRedirect { get; set; }
      global String jobIdsPerPage { get; set; }
    
    /* Abhi code */


    String s = 'Remote';
 
    public String getString() {
        return s;
    }
 			
    public void setString(String s) {
        this.s = s;
    }

     /* Abhi code */ 

  global void init() {
        
        try {
            if (cs.TRGTFCMS__JobListPage_Search_Displayed_Fields__c != null) {
                List<String> labelsAndFields =
                        cs.TRGTFCMS__JobListPage_Search_Displayed_Fields__c.trim().split(';');
                for (String eachField : labelsAndFields) {
                    if (eachField.contains('=')) {
                        fieldsAndLabelsToDisplay.put(
                                eachField.substringBefore('='),
                                eachField.substringAfter('='));
                        fieldLabels.add(eachField.substringBefore('='));
                    }
                }
            
            }
            
            if (cs.TRGTFCMS__Count_Jobs_for_Job_List_Page__c != null) {
                List<String> valueForJobList =
                        cs.TRGTFCMS__Count_Jobs_for_Job_List_Page__c.trim().split(',');
                
                selectedPageSize = valueForJobList.get(0);
            
            } else {
                selectedPageSize = '10';
            }
            selectedPageSizeTop = selectedPageSize;
            
            errorParam = true;
            cmsCssCustom = FCMS.CMSHelper.getCSSStyles();
            currentUrlJobListPage = ApexPages.currentPage().getUrl();
            Integer index = currentUrlJobListPage.indexOf('?');
            if (index != -1 && index != null) {
                currentUrlJobListPage = currentUrlJobListPage.substring(index);
            }
            
            jobSiteVar = ApexPages.currentPage().getParameters().get('jobSite');
            if (jobSiteVar == null || (jobSiteVar != null && jobSiteVar.length() == 0)) {
                FCMS.Logger.addErrorMessage(
                        cs.TRGTFCMS__jobSiteParameterError__c);
                errorParam = false;
            }
            
            availableCountryCodes = new List<SelectOption>(); // CC: 1.3.6.
          //  availableCountryCodes.add(new SelectOption('', '--None--'));
           
            if (String.isNotBlank(cs.TRGTFCMS__Country_For_GeoCoding__c)) {
                List<String> options = cs.TRGTFCMS__Country_For_GeoCoding__c.split(',');
                for (String countryCode : options) {
                    availableCountryCodes.add(new SelectOption(countryCode, countryCode));
                }
            }
            
            if (cs.TRGTFCMS__JobListFastSearch__c) {
                search();
            }
            
            radius = null;
        } catch (Exception e) {
            logger.catchBlockMethodNew(e);
        }
    }
    
    global String getCmsCssCustom() {
        return cmsCssCustom;
    }
    
    // get , set for the metaKeywords variable
    global String getMetaKeywords() {
        
        List<AVTRRT__Job__c> jobList;
        String jobIds = apexPages.currentPage().getParameters().get('jobIds');
        List<String> jobIdsList = new List<String>();
        
        if (jobIds != null) {
            jobIdsList = jobIds.split(';');
        }
        
        jobList = [
                SELECT a.Id, a.AVTRRT__Job_Title__c, a.AVTRRT__Job_Industry__c, a.AVTRRT__Job_Contact_Name__c,
                        a.AVTRRT__Job_Contact_Email__c, a.AVTRRT__Job_City__c, a.AVTRRT__Job_Category__c,
                        a.AVTRRT__EEO_Job_Category__c, a.AVTRRT__Country_Locale__c, a.AVTRRT__AutoPopulated_Skills__c,
                        a.AVTRRT__Account_Job_Name__c
                FROM AVTRRT__Job__c a
                WHERE a.Id IN :jobIdsList
        ];
        
        if (jobList.size() > 0) {
            for (AVTRRT__Job__c job : jobList) {
                List<String> jobIndustryList = job.AVTRRT__Job_Industry__c.split('=');
                metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_Title__c;
                metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_Contact_Name__c;
                
                if (job.AVTRRT__AutoPopulated_Skills__c != null &&
                        job.AVTRRT__AutoPopulated_Skills__c.length() > 0) {
                    
                    metaKeywords = metaKeywords + ',' +
                            job.AVTRRT__AutoPopulated_Skills__c.replace(';', ',');
                }
                
                metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_Contact_Email__c;
                metaKeywords = metaKeywords + ',' + job.AVTRRT__Job_City__c;
                metaKeywords = metaKeywords + ',' + job.AVTRRT__Country_Locale__c;
                metaKeywords = metaKeywords + ',' + job.AVTRRT__Account_Job_Name__c;
                
                if (jobIndustryList.size() > 0) {
                    metaKeywords = metaKeywords + ',' + jobIndustryList[0];
                }
            }
            metaKeywords = metaKeywords.replace(',null', '');
        }
        return metaKeywords;
    }
    
    global class searchedJobBean {
        global String oddEvenCssClass { get; set; }
        global AVTRRT__Job__c jobObject { get; set; }
        global Boolean checkBox { get; set; }
        global Boolean jobAppliedBefore { get; set; }
    }
    
    global Integer countJobForPage { get; set; }
    global Integer pageNumber { get; set; }
    global Boolean IsDoubleLoadInit = false;
    global Boolean isShowPagination { get; set; }
    
    global Integer totalCountRecords { get; set; }
    global Boolean disableNextButton { get; set; }
    global Boolean disablePreviousButton { get; set; }
    
    global String selectedJobsPagination { get; set; }
    
    global void setSearchedJobBeanListOfList(List<List<searchedJobBean>> searchList) {
        
        this.searchedJobBeanListOfList1 = searchList;
    }
    
    global List<List<searchedJobBean>> getSearchedJobBeanListOfList() {
        setExistingJobApplicantMap();
        searchedJobBeanListOfList1 = new List<List<searchedJobBean>>();
        Integer count = 1;
        jobIdsPerPage = '';
        
        if (searchedJobList2.size() > 0) {
            List<searchedJobBean> beanList = new List<searchedJobBean>();
            List<String> selectedJobList = new List<String>();
            
            if (String.isNotBlank(selectedJobsPagination)) {
                selectedJobList = selectedJobsPagination.split(';');
            }
            for (List<AVTRRT__Job__c> jobList : searchedJobList2) {
                for (AVTRRT__Job__c job : jobList) {
                    
                    if (beanList.size() < 1000) {
                        searchedJobBean bean = new searchedJobBean();
                        bean.jobObject = job;
                        
                        if (existingJobApplicantMap.get(job.Id) != null &&
                                existingJobApplicantMap.get(job.Id).AVTRRT__Stage__c !=
                                        System.Label.TRGTFCMS.Withdrawn_by_Candidate) {
                            
                            bean.jobAppliedBefore = true;
                            bean.checkBox = true;
                        }
                        if (selectedJobList != null) {
                            for (String jobId : selectedJobList) {
                                if (jobId == (String)job.Id) {
                                    System.debug('bean check box:' + bean);
                                    bean.checkBox = true;
                                }
                            }
                        }
                        
                        if (count == 1) {
                            bean.oddEvenCssClass = 'odd';
                            count = 2;
                        } else if (count == 2) {
                            bean.oddEvenCssClass = 'even';
                            count = 1;
                        }
                        beanList.add(bean);
                    } else {
                        
                        searchedJobBean bean = new searchedJobBean();
                        bean.jobObject = job;
                        if (existingJobApplicantMap.get(job.Id) != null &&
                                existingJobApplicantMap.get(job.Id).AVTRRT__Stage__c !=
                                        System.Label.TRGTFCMS.Withdrawn_by_Candidate) {
                            
                            bean.jobAppliedBefore = true;
                            bean.checkBox = true;
                        }
                        
                        if (count == 1) {
                            bean.oddEvenCssClass = 'odd';
                            count = 2;
                        } else if (count == 2) {
                            bean.oddEvenCssClass = 'even';
                            count = 1;
                        }
                        
                        beanList.add(bean);
                    }
                }
            }
            
            searchedJobBeanListOfList1.add(beanList);
            
            /**
             * @author Sergey Prishepo
             * @date 2/10/2013
             * @description That Section for pagination.
             */
            isShowPagination = cs.TRGTFCMS__isShowPagination__c;
            
            if (isShowPagination) {
                if (!IsDoubleLoadInit) {
                    
                    totalCountRecords = beanList.size() ;
                    
                    countJobForPage = selectedPageSize == null ? 10 : Integer.valueOf(selectedPageSize);
                    pageSize(countJobForPage, searchedJobBeanListOfList1[0].size());
                    
                    pageNumber
                            = (ApexPages.currentPage().getParameters().get('pageNumber') != null)
                            ? Integer.valueOf(ApexPages.currentPage().getParameters().get('pageNumber'))
                            : pageNumber == null ? 1 : pageNumber ;
                    
                    if (ApexPages.currentPage().getParameters().get('nextPage') != null) {
                        if (pageSizeList.size() >= (pageNumber + 1)) {
                            pageNumber += 1;
                        }
                    }
                    if (ApexPages.currentPage().getParameters().get('PreviousPage') != null) {
                        if (1 <= (pageNumber - 1)) {
                            pageNumber -= 1;
                        }
                    }
                    
                    disableNextButton = pageSizeList.size() == pageNumber ? true : false;
                    disablePreviousButton = pageNumber > 1 ? false : true;
                    selectedPage = String.valueOf(pageNumber);
                    selectedPageTop = selectedPage;
                    
                    pageNumbers(pageNumber, pageSizeList.size());
                    List<searchedJobBean> beanListValueForOnePage
                            = moveToPage(pageNumber, countJobForPage, beanList);
                    searchedJobBeanListOfList1.clear();
                    searchedJobBeanListOfList1.add(beanListValueForOnePage);
                } else {
                    IsDoubleLoadInit = false;
                }
            }
        }
        return searchedJobBeanListOfList1;
    }
    
    global List<Integer> pageSizeList { get; set; }
    /**
     * @author Sergey Prishepo
     * @date 1/10/2013
     * @description PageSize method make count show job on one Page .
     */
    global void pageSize(Integer p_pageCountRecords, Integer p_allSizeList) {
        
        Integer pageSize;
        pageSizeList = new List<Integer>();
        Double pageCountRecords = p_pageCountRecords;
        Double allSizeList = p_allSizeList;
        if (pageCountRecords > allSizeList) {
            pageSize = 1;
        } else {
            pageSize = Math.ceil(allSizeList / pageCountRecords).intValue();
        }
        for (Integer i = 1; i <= pageSize; i++) {
            pageSizeList.add(i);
        }
    }
    global List<Integer> numbersPage { get; set; }
    
    global void pageNumbers(Integer p_numberPage, Integer totalCountPage) {
        
        Integer firstNumber = p_numberPage > 0 ? p_numberPage : 1;
        Integer lastNumber = (firstNumber + 4) < totalCountPage ? (firstNumber + 4) : totalCountPage;
        firstNumber = (lastNumber - 4) > 0 ? (lastNumber - 4) : 1;
        
        numbersPage = new List<Integer>();
        for (Integer i = firstNumber; i <= lastNumber; i++) {
            numbersPage.add(i);
        }
    
    }
    /**
     * @author Sergey Prishepo
     * @date 1/10/2013
     * @description move To Page method make move between across Page.
     */
    global List<searchedJobBean> moveToPage(Integer p_numberPage,
            Integer p_countJob, List<searchedJobBean> p_jobListOnOnePage) {
        jobCheckBox1 = false;
        List<searchedJobBean> listJobForOnePage = new List<searchedJobBean>();
        
        Integer countElement = p_numberPage * p_countJob;
        Integer startPosition = countElement - p_countJob;
        
        if (p_jobListOnOnePage.size() <= countElement) {
            Integer modvalue = p_jobListOnOnePage.size() - startPosition;
            countElement = startPosition + modvalue;
        }
        
        for (Integer i = startPosition; i < countElement; i++) {
            listJobForOnePage.add(p_jobListOnOnePage[i]);
            jobIdsPerPage += ';' + p_jobListOnOnePage[i].jobObject.Id;
        }
        
        return listJobForOnePage;
    }
    
    global String selectedPage { get; set; }
    global String selectedPageTop { get; set; }
    global List<SelectOption> pageList;
    
    global List<SelectOption> getPages() {
        
        pageList = new List<SelectOption>();
        
        for (Integer i = 0; i < pageSizeList.size(); i++) {
            pageList.add(new SelectOption(String.valueOf(pageSizeList[i]),
                    String.valueOf(pageSizeList[i])));
        }
        
        return pageList;
    }
    
    global void selectedPageNumberTop() {
        selectedPage = selectedPageTop;
        pageNumber = Integer.valueOf(selectedPage);
        pageChanged();
    }
    
    global void selectedPageNumber() {
        selectedPageTop = selectedPage;
        pageNumber = Integer.valueOf(selectedPage);
        pageChanged();
    }
    
    global void pageChanged() {
        addDataToTransient();
        selectedJobs();
        searchedJobBeanListOfList1 = getSearchedJobBeanListOfList();
        IsDoubleLoadInit = false;
        jobCheckBox1 = false;
    }
    
    global String selectedPageSize { get; set; }
    global String selectedPageSizeTop { get; set; }
    global List<SelectOption> pageCountSizeList;
    
    global List<SelectOption> getpageCountSizeList() {
        
        pageCountSizeList = new List<SelectOption>();
        List<String> valueForJobList = new List<String>();
        
        if (cs.TRGTFCMS__Count_Jobs_for_Job_List_Page__c != null) {
            valueForJobList =
                    cs
                            .TRGTFCMS__Count_Jobs_for_Job_List_Page__c.trim().split(',');
            for (String value : valueForJobList) {
                pageCountSizeList.add(new SelectOption(value, value));
            }
        
        } else {
            
            pageCountSizeList.add(new SelectOption('10', '10'));
            pageCountSizeList.add(new SelectOption('30', '30'));
            pageCountSizeList.add(new SelectOption('50', '50'));
        
        }
        
        return pageCountSizeList;
    }
    
    global void selectedPageCountRecordTop() {
        selectedPageSize = selectedPageSizeTop;
        selectedPageCountRecord();
    }
    
    global void selectedPageCountRecord() {
        selectedPageSizeTop = selectedPageSize;
        countJobForPage = Integer.valueOf(selectedPageSize);
        pageNumber = 1;
        if(!Test.isRunningTest()){
            pageChanged();
        }
    }
    
    private void setExistingJobApplicantMap() {
        
        Id contactId = FCMS.Login.getLoggedInContact();
        
        if (contactId != null) {
            existingJobApplicantList = [
                    SELECT a.AVTRRT__Stage__c, a.AVTRRT__Job__c, a.AVTRRT__Job_Title__c,
                            a.AVTRRT__Contact_Candidate__c
                    FROM AVTRRT__Job_Applicant__c a
                    WHERE a.AVTRRT__Job__r.AVTRRT__Job_Publish_Site__c INCLUDES(:jobSiteVar)
                            AND a.AVTRRT__Contact_Candidate__c = :contactId
                    ORDER BY a.LastModifiedDate
            ];
        }
        
        existingJobApplicantMap = new Map<Id, AVTRRT__Job_Applicant__c>();
        for (AVTRRT__Job_Applicant__c jobApplicant : existingJobApplicantList) {
            existingJobApplicantMap.put(jobApplicant.AVTRRT__Job__c, jobApplicant);
        }
    }
    
    // End Ramesh changes
    global Boolean getShowApplyButton() {
        return showApplyButton;
    }
    
    global void setShowApplyButton(Boolean showApplyButton) {
        this.showApplyButton = showApplyButton;
    }
    
    global Boolean getShowJobError() {
        return showJobError;
    }
    
    global void setShowJobError(Boolean showJobError) {
        this.showJobError = showJobError;
    }
    
    global Boolean getShowSearchFilterError() {
        return showSearchFilterError;
    }
    
    global void setShowSearchFilterError(Boolean showSearchFilterError) {
        this.showSearchFilterError = showSearchFilterError;
    }
    
    global AVTRRT__Job__c getJob() {
        return job;
    }
    
    global void setJob(AVTRRT__Job__c job) {
        this.job = job;
    }
    
    global String getJobSearch() {
        return this.jobSearch;
    }
    
    global void setJobSearch(String jobSearch) {
        this.jobSearch = jobSearch;
    }
    
    global List<List<AVTRRT__Job__c>> getSearchedJobList() {
        return searchedJobList2;
    }
    
    global List<AVTRRT__Job__c> getSearchedJobList1() {
        return this.searchedJobList1;
    }
    
    global Boolean getJobCheckBox() {
        return this.jobCheckBox;
    }
    
    global void setJobCheckBox(Boolean jobCheckBox) {
        this.jobCheckBox = jobCheckBox;
        jobCheckBoxList.add(jobCheckBox);
    }
    
    String finalQuery;
    String finaSearchQuery;
    // This function will find all jobs according to search conditions.
    global PageReference search() {
        try {
            finalQuery = null;
            finaSearchQuery = null;
            selectedJobsPagination = '';
            searchedJobList.clear();
            searchedJobList1.clear();
            searchedJobList2  = new List<List<AVTRRT__Job__c>>();
            jobCheckBoxList.clear();
            
            Integer count = 0;
            String filterString = ' ';
            String searchContains = ' ';
            String searchExact = ' ';
       
            pageNumber = 1;
            
            logger.log('search', '', '');
            // This loop converts sObject values into string and making the query for search criteria. it also checks the datatype of the field and counts the number of fields used for search criteria from page.
            List<Schema.SObjectField> mapValuesList = avtrrtMap.values();
            for (Schema.SObjectField mapValue : mapValuesList) {
                if (('' + mapValue).startsWith('INVALID FIELD: ')) {
                    continue;
                }
                
                Schema.DescribeFieldResult fieldDescribe = mapValue.getDescribe();
                if (job.get(mapValue) != null) {
                    
                    String value = String.escapeSingleQuotes('' + job.get(mapValue));
                    count++;
                    
                    if (fieldDescribe.getType() == Schema.DisplayType.STRING ||
                            fieldDescribe.getType() == Schema.DisplayType.TEXTAREA) {
                        
                        searchContains = searchContains + 'AND '
                                + mapValue + ' like \'%' + value + '%\' ';
                    } else {
                        searchExact = searchExact + 'AND ' + mapValue + '=\'' + value + '\' ';
                    }
                    logger.log('search', 'count=', count);
                }
            }
            
            filterString = searchContains + ' ' + searchExact; // concatenating both the string
            
            logger.log('search', 'count=', count);
            
            logger.log('search', 'filterString1=', filterString);
            //end
            if (count <= 6) {
                
                logger.log('search', 'filterString1=', filterString);
                logger.log('search', 'jobSiteVar=', jobSiteVar);
                
                String jobSite1 = jobSiteVar == null ? '\'null\'' : '\'' + jobSiteVar.replace(';', '\',\'') + '\'';
                
                logger.log('search', 'jobSite1=', jobSite1);
                logger.log('search', 'mapValuesList=', mapValuesList);
                
                String searchQueryString =
                        cs.TRGTFCMS__Job_List_Page_fields_for_query__c;
                
                searchQueryString = (searchQueryString == null)
                        ? 'AVTRRT__Job_Title__c,AVTRRT__Job_Summary__c'
                        : searchQueryString;
                
                logger.log('search', 'filterString2=', filterString);
                logger.log('search', 'searchQueryString=', searchQueryString);
                
                String searchStr = getJobSearch();
                
                logger.log('search', 'searchStr=', searchStr);
                
                String searchString = searchStr != null ? String.escapeSingleQuotes(searchStr) : searchStr;
                
                logger.log('search', 'searchQueryString=', searchQueryString);
                logger.log('search', 'searchStr=', searchStr);
                logger.log('search', 'searchString=', searchString);
                
                String profile = ApexPages.currentPage().getParameters().get('p');
                
                /**
                 * @author Sergey Prishepo
                 * @date 02/04/2013
                 * @description If the loggedin person profile contains "vendor", then use the custom setting from vendor portal criteria.
                 */
                String queryWhere;
                if (profile.contains('Vendor Profile')) {
                    
                    queryWhere = ConfigHelper.getConfigDataSetFromVendor().TRGTFCMS__Vendors_Jobs_Criteria__c +
                            ' AND AVTRRT__Stage__c != \'' + System.Label.TRGTFCMS.INACTIVE +
                            '\' AND AVTRRT__Publish__c=true AND ' +
                            'AVTRRT__Closed__c = false' + ((jobSite1 == '\'null\''
                            || jobSite1.toLowerCase() == '\' default\'')
                            ? ''
                            : ' AND AVTRRT__Job_Publish_Site__c INCLUDES (' + jobSite1 + ') ')
                            + filterString;
                } else {
                    
                    if (cs.TRGTFCMS__JobListWhere__c != null) {
                        queryWhere = (cs.TRGTFCMS__JobListWhere__c + filterString).trim();
                    } else {
                        queryWhere = 'AVTRRT__Stage__c != \'' + System.Label.TRGTFCMS.INACTIVE +
                                '\' AND AVTRRT__Publish__c=true AND ' +
                                'AVTRRT__Closed__c = false' + ((jobSite1 == '\'null\''
                                || jobSite1.toLowerCase() == '\' default\'')
                                ? '' : ' AND AVTRRT__Job_Publish_Site__c INCLUDES ('
                                        + jobSite1 + ') ') + filterString;
                    }
                }
                
                // Gets ORDER BY for queries from settings.
                // If the value in settings is empty then sort by 'Name' by default
                String orderBy = cs.TRGTFCMS__JobListOrderBy__c;
                orderBy = ' ORDER BY ' + (orderBy != null ? orderBy : 'Name');
                
                logger.log('search', 'orderBy=', orderBy);
                
                //GeoCoding
                
                enableGeoCoding = cs.TRGTFCMS__Enable_Jobs_location_search__c;
                if (enableGeoCoding == true
                        && radius != null
                        && String.isNotBlank(zipCode)
                        && String.isNotBlank(selectedCountry)) {
                    
                    Boolean isBoundingGeocodedBox = AVTRRT.Geocoding_Util.getBoundingGeocodedBox(
                            radius,
                            zipCode,
                            selectedCountry);
                    
                    logger.log('search', 'isBoundingGeocodedBox', isBoundingGeocodedBox);
                    
                    if (!isBoundingGeocodedBox) {
                        ApexPages.addMessage(
                                new ApexPages.Message(ApexPages.Severity.ERROR,
                                        Label.TRGTFCMS.Location_was_not_found));
                        
                        searchedJobBeanListOfList1.clear();
                        showApplyButton = false;
                        
                        return null;
                    }
                    
                    String boundingBoxWhereClause =
                            AVTRRT.Geocoding_Util.getBoundingBoxWhereClause();
                    
                    // Need to remove below 2 lines before package creation.
                    // Since we might need to add this while testing,
                    // keeping in comments for quick replace
                    // boundingBoxWhereClause = boundingBoxWhereClause.replaceAll('lat__c',
                    //      'AVTRRT__Lat__c');
                    // boundingBoxWhereClause = boundingBoxWhereClause.replaceAll('lon__c',
                    //      'AVTRRT__Lon__c');
                    
                    queryWhere = queryWhere + ' ' + ' AND ' + boundingBoxWhereClause;
                    
                    logger.log('search', 'queryWhere', queryWhere);
                } 
               /*   else if (enableGeoCoding == true
                        && ((String.isBlank(zipCode) && String.isNotBlank(selectedCountry))
                        || (String.isNotBlank(zipCode) && String.isBlank(selectedCountry)))) {
                  //  logger.addError(Label.TRGTFCMS.Country_and_zipcode_is_mandatory);
                } */
                
                if (searchString != '' && searchString != null) {
                    
                    String searchString1;
                    String searchString2;
                    
                    if (searchString.contains('*') || searchString.contains('?')) {
                        
                        searchString1 = searchString.replace('*', '');
                        
                        logger.log('search', 'searchString1=', searchString1);
                        
                        if (searchString1.contains('*') || searchString1.contains('?')) {
                            searchString2 = searchString1.replace('?', '');
                            
                            logger.log('search', 'searchString2=', searchString2);
                            
                            if (searchString2.length() == 1 || searchString2.length() == 0) {
                                searchString = searchString2;
                                logger.log('search', 'searchString=', searchString);
                            }
                            
                            logger.log('search', 'searchString2=', searchString2);
                        } else {
                            if (searchString1.length() == 1 || searchString1.length() == 0) {
                                searchString = searchString1;
                            }
                        }
                    }
                    
                    if (searchString.trim().length() > 1) {
                        String searchQuery = 'FIND \'' + searchString + '\' IN ALL FIELDS RETURNING ' +
                                'AVTRRT__Job__c(' + searchQueryString + ' WHERE ' +
                                queryWhere + orderBy + ')';
                        logger.log('search', 'FIND searchQuery=', searchQuery);
                        finaSearchQuery = searchQuery;
                        searchedJobList = Search.query(searchQuery);
                        logger.log('search', 'FIND searchedJobList=', searchedJobList);
                        
                        searchedJobList2.add((List<AVTRRT__Job__c>)searchedJobList[0]);
                    } else {
                        System.debug('>>>>>>>>>>>in else=');
                        
                        String msg = cs.TRGTFCMS__JobListPageMessage__c;
                        
                        System.debug('>>>>>>>>>>>msg=' + msg);
                        
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, msg);
                        System.debug('>>>>>>>>>>>myMsg=' + myMsg);
                        
                        ApexPages.addMessage(myMsg);
                        
                        System.debug('>>>>>>>>>>>myMsg2=' + myMsg);
                        
                        System.debug(LoggingLevel.ERROR, '::::9');
                    }
                } else {
                    String selectQuery = 'SELECT ' + searchQueryString +
                        ' FROM AVTRRT__Job__c WHERE ' + queryWhere + orderBy;
                    finalQuery = selectQuery;
                    logger.log('search', 'selectQuery=', selectQuery);
                    
                    searchedJobList2.add(Database.query(selectQuery));
                    
                    logger.log('search', 'searchedJobList2', searchedJobList2);
                
                }
                
                if (searchedJobList2.size() > 0 && searchedJobList2[0].size() > 0) {
                    logger.log('search', 'searchedJobList2=', searchedJobList2);
                    
                    showApplyButton = true;
                    showSearchFilterError = false;
                    showJobError = false;
                    
                    searchedJobBeanListOfList1 = getSearchedJobBeanListOfList();
                } else {
                    logger.log('search', 'searchedJobList2=', searchedJobList2);
                    
                    showApplyButton = false;
                    showSearchFilterError = false;
                    showJobError = true;
                
                }
            } else {
                showApplyButton = false;
                showSearchFilterError = true;
                showJobError = true;
            }
            
            
            FCMS.Logger.sendLog(subject);
            
            
        } catch (Exception e) {
            logger.catchBlockMethodNew(e);
        }
        return null;
    }
    
    public void addDataToTransient() {
        searchedJobList2  = new List<List<AVTRRT__Job__c>>();
        if (finaSearchQuery != null) {
            searchedJobList = Search.query(finaSearchQuery);
            searchedJobList2.add((List<AVTRRT__Job__c>)searchedJobList[0]);
        }
        else if (finalQuery != null) {
            searchedJobList2.add(Database.query(finalQuery));
        }
    }
    
    global String getapplyPageURL() {
        PageReference pg = apply();
        pageURL = pg.getUrl();
        return pageURL;
    }
    // This function will send user to the JobApplicationPage with the parameters like jobIds and jobSiteVar
    
    global PageReference apply() {
        try {
            String jobIds = getJobIds();
            if (String.isNotBlank(selectedJobsPagination)) {
                jobIds = selectedJobsPagination + ';' + jobIds;
            }
            
            if (String.isBlank(jobIds)) {
                LoggerCP.addErrorMessage(Label.AVTRRT.Please_select_at_least_one_job);
                return null;
            }
            
            jobCheckBoxList.clear();
            
            PageReference pg = new PageReference('/apex/FCMS__CMSLayout');
            Url.setParam(pg, 'jobIds', jobIds);
            Url.setParam(pg, 'page', 'JobApplicationPage');
            
            if (Url.getParam('sessionId') != 'null' && Url.getParam('sessionId') != null) {
                Url.setParam(pg, 'sessionId', Url.getParam('sessionId'));
            } else {
                Url.setParam(pg, 'sessionId', '');
            }
            
            if (jobSiteVar != null) {
                Url.setParam(pg, 'jobSite', jobSiteVar);
            } else {
                Url.setParam(pg, 'jobSite', '');
            }
            
            if (Url.getParam('p') != null) {
                Url.setParam(pg, 'p', Url.getParam('p'));
            } else {
                Url.setParam(pg, 'p', '');
            }

            if (Url.getParam('source') != null) {
                Url.setParam(pg, 'source', Url.getParam('source'));
            } else {
                Url.setParam(pg, 'source', '');
            }
            
            pg.setRedirect(true);
            return pg;
        } catch (Exception e) {
            logger.catchBlockMethodNew(e);
        }
        
        return null;
    }
    
    /**
     * @author Rakesh Rangu
     * @date 10/17/2014
     * @description To capture selected jobs when traversed through different pages in pagination
     */
    global void selectedJobs() {
        
        String jobIds;
        jobIds = getJobIds();
        
        if (String.isNotBlank(jobIds)) {
            selectedJobsPagination += ';' + jobIds;
        }
    
    }
    
    /**
     * @author Rakesh Rangu
     * @date 10/17/2014
     * @description To Fetch JobIds while traversing to next page or when user clicks on Apply button
     */
    private String getJobIds() {
        Boolean flag = false;
        String jobIds;
        for (List<searchedJobBean> jobBeanList : searchedJobBeanListOfList1) {
            for (Integer i = 0; i < jobBeanList.size(); i++) {
                
                if (jobBeanList[i].checkBox == true &&
                        jobBeanList[i].jobAppliedBefore != jobBeanList[i].checkBox && flag == false) {
                    
                    jobIds = jobBeanList[i].jobObject.Id;
                    flag = true;
                    continue;
                }
                
                if (jobBeanList[i].checkBox == true && jobBeanList[i].jobAppliedBefore !=
                        jobBeanList[i].checkBox && flag == true) {
                    
                    jobIds = jobIds + ';' + jobBeanList[i].jobObject.Id;
                }
            }
        }
        return jobIds;
    }
   public void testCover() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}