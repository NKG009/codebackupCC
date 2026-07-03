//********************************************************************************************
//********************************************************************************************
//
//     Sourcebreaker JSON Candidate Class, contains JSON object structure for REST integration
//
//********************************************************************************************
//********************************************************************************************

 
public with sharing class SbJsonCandidate {
      
    //**************************************
    // jsonWrapper Class: Wrapper class, which holds the Info/Value child objects
    //**************************************
    public class jsonWrapper{
        public infoObject Info {get; set;} 
        public valueObject Value  {get; set;}
    }
    
    public class infoObject{
        public string Code {get; set;}
        public string Message {get; set;}
    }
    
    public class valueObject{
        public string FileType {get; set;}
        public string Text {get; set;}
        public string TextCode {get; set;}
        public string Html {get; set;}
        public string HtmlCode {get; set;}
        public string ParsedDocument {get; set;}  //Contains the parsed document from Parser. 
        public string Pdf {get; set;}
        public string PdfCode {get; set;}

        //THESE OPTIONS ARE ALSO AVAILABLE, BUT NOT CURRENTLY USED FOR CV PARSING:
        //public resumeObject ScrubbedParsedDocument {get; set;} 
        //public string CandidateImage {get; set;}
        //public string CandidateImageExtension {get; set;}
        public string GeocodeResponse {get; set;} 
        //public string Rtf {get; set;}
        //public string RtfCode {get; set;}
        public string CreditsRemaining {get; set;}
        //public string FileExtension {get; set;}
        //public string IndexingResponse {get; set;}
    }

    //RESUME Object is created from 'ParsedDocument' and also used in test classes to create JSON as needed.
    public class ResumeObject{ //extends ValueObject{
        public structuredResumeObject StructuredXMLResume {get; set;}
        public nonXMLResumeObject NonXMLResume {get; set;}
    }

    public class ResumeObjectWrapper{
        public ResumeObject Resume {get; set;}
    }

    //**************************************
    // PARENT OBJECT IN JSON INPUT 
    // structuredResumeObject Class: Wrapper class, which holds the JSON input and all child objects/arrays
    //**************************************
    public class structuredResumeObject{
        public contactInfoObject ContactInfo {get; set;}
        public string ExecutiveSummary {get; set;}
        public string Objective {get; set;}
        public employmentHistoryObject EmploymentHistory {get; set;} 
        public string RevisionDate {get; set;}

        //THESE OPTIONS ARE ALSO AVAILABLE, BUT NOT CURRENTLY USED FOR CV PARSING
        //If developing integration for these, recommended to create additional classes for each object (like emply history above)
        //public list<string> EducationHistory {get; set;}  
        //public list<string> licensesAndCertifications {get; set;} 
        //public list<string> Languages {get; set;} 
        //public list<string> Achievements {get; set;} 
    }
    
    
    public class nonXMLResumeObject{
        public string TextResume {get; set;}
    }

    //**************************************
    // contactInfoObject Class: Holds the relevant details of the individual like name/contact info
    //**************************************
    public class contactInfoObject{
        public personNameObject PersonName {get; set;}
        public contactMethodObject[] ContactMethod {get; set;}
    }
    
    public class personNameObject{
        public string FormattedName {get; set;}
        public string GivenName {get; set;}
        public string MiddleName {get; set;}
        public string FamilyName {get; set;}
        public affixObject[] Affix {get; set;}
    }
    
    public class affixObject{
        public string x_type {get; set;}
        public string x_text {get; set;}
    }
    
    public class contactMethodObject{
        public string WhenAvailable {get; set;}
        public string Use {get; set;}
        public string Location {get; set;}
        public phoneNumberObject Mobile {get; set;}
        public phoneNumberObject Telephone {get; set;}
        public phoneNumberObject Fax {get; set;}
        public string InternetEmailAddress {get; set;}
        public string InternetWebAddress {get; set;}
        public postalAddressObject PostalAddress {get; set;}
    }
    
    public class phoneNumberObject{
        public string FormattedNumber {get; set;}
    }
    
    //**************************************
    // Postal/Address Class: Holds the relevant details of the address information, used for indiviudal and employers
    //**************************************
     /*  example format expected in JSON:
            PostalAddress": {              
            "CountryCode": "US",
            "PostalCode": "92075",
            "Region": [ "CA" ],  
            "Municipality": "Solana Beach", 
            "DeliveryAddress": { 
            "AddressLine": [ "930 Via Mil Cumbres Unit 119" ]  }  }   },  */

    public class postalAddressObject{
        public string CountryCode {get; set;}
        public string PostalCode {get; set;}
        public string[] Region {get; set;}
        public string Municipality {get; set;}
        public deliveryAddressObject DeliveryAddress {get; set;}
    }
    
    public class deliveryAddressObject{
        public string[] AddressLine {get; set;}
    }
    
    
    
    //**************************************
    // employmentHistoryObject Class: Holds the relevant details of the individual's career history
    //**************************************
    public class employmentHistoryObject{
        public employerOrgObject[] EmployerOrg {get; set;}
    }
    
    public class employerOrgObject{
        public string EmployerOrgName {get; set;}
        public positionHistoryObject[] PositionHistory {get; set;}
        
    }
    
    public class positionHistoryObject{
        public string x_positionType {get; set;}
        public string x_currentEmployer {get; set;}
        public string Title {get; set;}
        public orgNameObject OrgName {get; set;}
        public orgInfoObject[] OrgInfo {get; set;}
        public string Description {get; set;}
        public dateObject StartDate {get; set;}
        public dateObject EndDate {get; set;}
        public jobCatergoryObject[] JobCategory {get; set;}
    }
    
    public class orgNameObject{
        public string OrganizationName {get; set;}
    }
    
    public class orgInfoObject{
        public postalAddressObject PositionLocation {get; set;}
    }
    
    public class dateObject{
        public string YearMonth {get; set;}
        public string StringDate {get; set;}
        public string AnyDate {get; set;}
    }
    
    public class jobCatergoryObject{
        public string TaxonomyName {get; set;}
        public string CategoryCode {get; set;}
        public string Comments {get; set;}
        
    }

}