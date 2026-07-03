//********************************************************************************************
//********************************************************************************************
//
//     Sourcebreaker JSON Lead Class, contains JSON object structure for REST integration
//
//********************************************************************************************
//********************************************************************************************


public with sharing class SbJsonLead {
    

    //********************************************************************************
    //********************************************************************************
    // leadWrapper Class: holds the leads to be created from Sourcebreaker
    //********************************************************************************
    //********************************************************************************

    public class leadWrapper{
        public dataObject[] Data {get; set;} 
    }
    
    public class dataObject{
        public string company {get; set;}
        public string description {get; set;}
        public string education {get; set;}
        public string isViewed {get; set;}
        public string isDownloaded {get; set;} 
        public string isNew {get; set;}
        public string jobTitle {get; set;}
        public string lastViewed {get; set;}
        public string lastDownloaded {get; set;}
        public string link {get; set;} 
        public string location {get; set;}
        public string name {get; set;}
        public string id {get; set;}
        public string summary {get; set;}
        public string jobBoard {get; set;}
        public detailsObject details {get; set;} 
    }
    
    public class detailsObject{
        public string[] emails {get; set;}
        public string[] phones {get; set;}
        public string[] locations {get; set;}
        public string companySize {get; set;}
    }
}