/* Akhil
 * https://targetrecruit.atlassian.net/browse/WAVE-22
 * Test class: WIPortalXMLFeedControllerTC
 */ 

public class WIPortalXMLFeedController 
{
     public Transient String output {get; private set;}
    public String pageCount;
    List<AVTRRT__Job__c> jobs;
    
     public WIPortalXMLFeedController(){
        pageCount = Apexpages.currentPage().getParameters().get('page');
        init();
    }
    
    public void init()
    {
      
        Integer recordCount = Integer.valueOf(TR_CustomSettings__c.getOrgDefaults().WIPortalXMLFeedPageRecordCount__c);
        Integer pageCountInt = Integer.valueOf(pageCount);
        
         List<AVTRRT__Job__c> jobsTemp = [SELECT Id,AVTRRT__Publish__c,AVTRRT__Closed__c,Business_Entity__c
                                          FROM AVTRRT__Job__c
                                          WHERE AVTRRT__Publish__c = true AND AVTRRT__Closed__c = false AND Business_Entity__c='Wavelength International'];
                                         
                                          
         Map<Integer, List<Id>> jobsMap = new Map<Integer, List<Id>>();
        Integer i = 0, j = 0, k = 0;
        for (i = 0; i < jobsTemp.size(); i++) {
            List<Id> jobIds = new List<Id>();
            for (j = 0; j < recordCount; j++) {
                if (i < jobsTemp.size()) {
                    jobIds.add(jobsTemp[i].Id);
                    i++;
                }
            }
            i--; k++;
            jobsMap.put(k, jobIds);
        }
        
      List<Id> jobIds = jobsMap.get(pageCountInt) != null ? jobsMap.get(pageCountInt) : new List<Id>();
        
        jobs =[ SELECT Id,Name,AVTRRT__Job_Title__c,Job_Summary_Custom__c,AVTRRT__Job_Description_Rich__c,Salary__c,Regular_Pay_Rate__c,
                Rate_Type__c,Job_Type__c,RecordType.Name,AVTRRT__Start_Date__c,AVTRRT__End_Date__c,Category__c,
                Specialty_NEW__c,Sub_Specialty_New__c,Seniority_NEW__c,Requirements__c,AVTRRT__AutoPopulated_Skills__c,Inclusions__c,
                AVTRRT__Job_City__c,AVTRRT__Job_State__c,AVTRRT__Job_Postal_Code__c,AVTRRT__Job_Country__c,AVTRRT__Job_Application_Tiny_URL__c,
                AVTRRT__Recruiter__c,AVTRRT__Recruiter__r.Name,AVTRRT__Recruiter__r.Phone,AVTRRT__Recruiter__r.Email,CreatedDate,Business_Entity__c
                FROM AVTRRT__Job__c 
                WHERE Id IN : jobIds AND AVTRRT__Publish__c = true AND AVTRRT__Closed__c = false AND Business_Entity__c='Wavelength International'];
        
        
       System.debug('jobs = ' + jobs.size());
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument('utf-8', '1.0');
        w.writeStartElement(null, 'source', null);
        
        if (jobs.size() > 0)
        {
            Id permRecordTypeId = Schema.SObjectType.AVTRRT__Job__c.getRecordTypeInfosByDeveloperName().get('CorporateJob').getRecordTypeId();
            Id LocumRecordTypeId = Schema.SObjectType.AVTRRT__Job__c.getRecordTypeInfosByDeveloperName().get('StaffingJob').getRecordTypeId();
            for ( AVTRRT__Job__c job : jobs ) 
            {
                 w.writeStartElement(null, 'job', null); 
             
                if (job.AVTRRT__Job_Title__c != null) {
                    w.writeStartElement(null, 'Job-Title', null);
                    w.writeCData(job.AVTRRT__Job_Title__c);
                    w.writeEndElement(); 
                }
                
                if (job.Job_Summary_Custom__c != null) {
                    system.debug('@@@@job.Job_Summary_Custom__c'+job.Job_Summary_Custom__c);
                    w.writeStartElement(null, 'Job-Summary', null);
                    w.writeCData(job.Job_Summary_Custom__c);
                    w.writeEndElement(); 
                }
                
                if (job.AVTRRT__Job_Description_Rich__c != null) {
                    w.writeStartElement(null, 'Job-Description-Rich', null);
                    w.writeCData(job.AVTRRT__Job_Description_Rich__c.unescapehtml4());
                    w.writeEndElement(); 
                }
                
                 if(job.recordTypeId==LocumRecordTypeId)  //'Locum Job'
                {
                    if (job.Regular_Pay_Rate__c != null) {
                        w.writeStartElement(null, 'Pay-Rate', null);
                        w.writeCData(String.valueOf((job.Regular_Pay_Rate__c).format()));
                        w.writeEndElement();
                    }
                    if (job.Rate_Type__c != null) {
                        w.writeStartElement(null, 'Pay-Type', null);
                        w.writeCData(job.Rate_Type__c);
                        w.writeEndElement(); 
                    } 
                    
                    if (job.Requirements__c != null) {
                        w.writeStartElement(null, 'Requirements', null);
                        w.writeCData(job.Requirements__c);
                        w.writeEndElement(); 
                    } 
                    
                    if (job.Inclusions__c != null) {
                        w.writeStartElement(null, 'Inclusions', null);
                        w.writeCData(job.Inclusions__c);
                        w.writeEndElement(); 
                    } 
                    
                    
                }
                else if(job.recordTypeId==permRecordTypeId)//recTypeName=='Permanent Job'
                {
                    if (job.Salary__c != null) {
                        w.writeStartElement(null, 'Annual-Salary', null);
                        w.writeCData(String.valueOf((job.Salary__c).format()));
                        w.writeEndElement(); 
                    }
                    
                }
                
                 if (job.Job_Type__c != null) {
                    w.writeStartElement(null, 'Job-Type', null);
                    w.writeCData(job.Job_Type__c);
                    w.writeEndElement(); 
                }
                 if(job.recordTypeId==LocumRecordTypeId)  //'Locum Job'
                {
                   
                    w.writeStartElement(null, 'Record-Type', null);
                    w.writeCData('Locum Job');
                    w.writeEndElement(); 
                }
                else if(job.recordTypeId==permRecordTypeId)//recTypeName=='Permanent Job'
                {
                   w.writeStartElement(null, 'Record-Type', null);
                    w.writeCData('Permanent Job');
                    w.writeEndElement(); 
                }
                
                if (job.AVTRRT__Start_Date__c != null) {
                    w.writeStartElement(null, 'Expected-Start-Date', null);
                    w.writeCData(String.valueOf((job.AVTRRT__Start_Date__c)));
                    w.writeEndElement(); 
                }
                
                if (job.AVTRRT__End_Date__c != null) {
                        w.writeStartElement(null, 'End-Date', null);
                        w.writeCData(String.valueOf((job.AVTRRT__End_Date__c)));
                        w.writeEndElement(); 
                    }
                               
                 if (job.Category__c != null) {
                    w.writeStartElement(null, 'Category ', null);
                    w.writeCData(job.Category__c);
                    w.writeEndElement(); 
                }
                
                if (job.Specialty_NEW__c != null) {
                    w.writeStartElement(null, 'Specialty ', null);
                    w.writeCData(job.Specialty_NEW__c);
                    w.writeEndElement(); 
                }
                 if (job.Sub_Specialty_New__c != null) {
                    w.writeStartElement(null, 'Sub-Specialty ', null);
                    w.writeCData(job.Sub_Specialty_New__c);
                    w.writeEndElement(); 
                }
                
                 if (job.Seniority_NEW__c != null) {
                    w.writeStartElement(null, 'Seniority ', null);
                    w.writeCData(job.Seniority_NEW__c);
                    w.writeEndElement(); 
                }
                
                 if (job.AVTRRT__AutoPopulated_Skills__c != null) {
                    w.writeStartElement(null, 'Desired-Skills ', null);
                    w.writeCData(job.AVTRRT__AutoPopulated_Skills__c);
                    w.writeEndElement(); 
                }
                
                if (job.AVTRRT__Job_City__c != null) {
                    w.writeStartElement(null, 'City', null);
                    w.writeCData(job.AVTRRT__Job_City__c);
                    w.writeEndElement(); 
                }
                
                if (job.AVTRRT__Job_State__c != null) {
                    w.writeStartElement(null, 'State', null);
                    w.writeCData(job.AVTRRT__Job_State__c);
                    w.writeEndElement(); 
                }
                if (job.AVTRRT__Job_Postal_Code__c != null) {
                    w.writeStartElement(null, 'Postal-code', null);
                    w.writeCData(job.AVTRRT__Job_Postal_Code__c);
                    w.writeEndElement(); 
                }
                
                  if (job.AVTRRT__Job_Country__c != null) {
                    w.writeStartElement(null, 'Country', null);
                    w.writeCData(job.AVTRRT__Job_Country__c);
                    w.writeEndElement(); 
                }
                 if (job.AVTRRT__Job_Application_Tiny_URL__c != null) {
                    w.writeStartElement(null, 'Job-Application-URL', null);
                    w.writeCData(job.AVTRRT__Job_Application_Tiny_URL__c);
                    w.writeEndElement(); 
                }
                 if (job.AVTRRT__Recruiter__r.Name != null) {
                    w.writeStartElement(null, 'Recruiter', null);
                    w.writeCData(job.AVTRRT__Recruiter__r.Name);
                    w.writeEndElement(); 
                }
                 if (job.AVTRRT__Recruiter__r.Phone != null) {
                    w.writeStartElement(null, 'User-Phone', null);
                    w.writeCData(job.AVTRRT__Recruiter__r.Phone);
                    w.writeEndElement(); 
                }
                if (job.AVTRRT__Recruiter__r.Email != null) {
                    w.writeStartElement(null, 'User-Email', null);
                    w.writeCData(job.AVTRRT__Recruiter__r.Email);
                    w.writeEndElement(); 
                }
                 if (job.CreatedDate != null) {
                        w.writeStartElement(null, 'Record-Created-Date', null);
                        w.writeCData(String.valueOf((job.CreatedDate).Date()));
                        w.writeEndElement(); 
                    }
     
                w.writeEndElement();
            }
        }
        else {
            System.debug('@@else');
            w.writeStartElement(null, 'job', null);
            w.writeCData('No Jobs Found');
            w.writeEndElement();	
        }
        w.writeEndElement(); 
        output = w.getXmlString();  
        w.close(); 
    }
    
}