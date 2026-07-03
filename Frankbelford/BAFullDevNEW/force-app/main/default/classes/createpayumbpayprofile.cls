public class createpayumbpayprofile{

    public String recordtypeid{get;set;}
    public String profileName{get;set;}
    public  String parentId{get;set;}
    public String recordTypeName{get;set;}
    public String parentname {get;set;}
    public IP_PayProfile__c payrec{get;set;}

    public createpayumbpayprofile(ApexPages.StandardController controller) {
        payrec= new IP_PayProfile__c();
        Id profileId= userinfo.getProfileId();
        profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(ApexPages.currentPage().getParameters().get('conID') != null){
            parentId = ApexPages.currentPage().getParameters().get('conID');
            Contact con = [Select id,Name from COntact where id=:parentId];
            parentname= con.Name;
            payrec.IP_Candidate__c = con.ID;
        }
        if(ApexPages.currentPage().getParameters().get('recid') != null){
            recordtypeid = ApexPages.currentPage().getParameters().get('recid');
            RecordType rec = [Select id,Name from RecordType where id =: recordtypeid];
            recordTypeName = rec.Name;
            payrec.RecordTypeID = rec.id;
        }
    }

    public pageReference saveandredirect(){
        IP_PayProfile__c pay = new IP_PayProfile__c();
        pay.RecordTypeid = recordtypeid;
        pay.IP_candidate__c = payrec.IP_Candidate__c;
        pay.IP_MissingPayrollDetail__c = payrec.IP_MissingPayrollDetail__c;
        pay.IP_PayrollID__c = payrec.IP_PayrollID__c;       
        pay.IP_PrimaryPayMethod__c = payrec.IP_PrimaryPayMethod__c;
        if(recordTypeName.equals('Umbrella')){          
            pay.IP_UmbrellaName__c = payrec.IP_UmbrellaName__c;
            pay.IP_SupplierReference__c = payrec.IP_SupplierReference__c;
        }
        else if(recordTypeName.equals('PAYE')){
            pay.IP_PayFrequency__c = payrec.IP_PayFrequency__c;
            pay.IP_NewStarterTaxStatus__c   = payrec.IP_NewStarterTaxStatus__c;
            pay.IP_EmailPayslip__c = payrec.IP_EmailPayslip__c;
            pay.IP_StudentLoan__c   = payrec.IP_StudentLoan__c;
            pay.IP_Derogated__c = payrec.IP_Derogated__c;
            pay.P45_Requested__c = payrec.P45_Requested__c;
            pay.Date_P45_Requested__c   = payrec.Date_P45_Requested__c;
            pay.Reason_for_Leaving1__c = payrec.Reason_for_Leaving1__c;
            pay.P45_Date_by_Head_Office__c    = payrec.P45_Date_by_Head_Office__c ;
            pay.IP_Branch_Code__c = payrec.IP_Branch_Code__c;
            pay.IP_GUID__c = payrec.IP_GUID__c;
            pay.P45_Initiated__c   = payrec.P45_Initiated__c;
            pay.IP_EmergencyPull__c = payrec.IP_EmergencyPull__c;
            pay.Reason_for_P45_Internal__c   = payrec.Reason_for_P45_Internal__c;
            pay.IP_TimesheetIDLink__c = payrec.IP_TimesheetIDLink__c;
            pay.For_P45_batch__c   = payrec.For_P45_batch__c;
            pay.IP_Payroll_Leaver__c  = payrec.IP_Payroll_Leaver__c ;
        }
        pay.IP_Status__c = 'Active';
        pay.IP_PassToTempest__c = payrec.IP_PassToTempest__c;
        pay.IP_LastPassedToTempest__c = payrec.IP_LastPassedToTempest__c;

        try{
            insert pay;
            PageReference pageref = new PageReference('/'+pay.id);
            pageref.setRedirect(true);
            return pageref;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    public pageReference saveandredirectnewpage(){
        IP_PayProfile__c pay = new IP_PayProfile__c();
        pay.RecordTypeid = recordtypeid;
        pay.IP_candidate__c = payrec.IP_Candidate__c;
        pay.IP_MissingPayrollDetail__c = payrec.IP_MissingPayrollDetail__c;
        pay.IP_PayrollID__c = payrec.IP_PayrollID__c;       
        pay.IP_PrimaryPayMethod__c = payrec.IP_PrimaryPayMethod__c;
        if(recordTypeName.equals('Umbrella')){          
            pay.IP_UmbrellaName__c = payrec.IP_UmbrellaName__c;
            pay.IP_SupplierReference__c = payrec.IP_SupplierReference__c;
        }
        else if(recordTypeName.equals('PAYE')){
            pay.IP_PayFrequency__c = payrec.IP_PayFrequency__c;
            pay.IP_NewStarterTaxStatus__c   = payrec.IP_NewStarterTaxStatus__c;
            pay.IP_EmailPayslip__c = payrec.IP_EmailPayslip__c;
            pay.IP_StudentLoan__c   = payrec.IP_StudentLoan__c;
            pay.IP_Derogated__c = payrec.IP_Derogated__c;
            pay.P45_Requested__c = payrec.P45_Requested__c;
            pay.Date_P45_Requested__c   = payrec.Date_P45_Requested__c;
            pay.Reason_for_Leaving1__c = payrec.Reason_for_Leaving1__c;
            pay.P45_Date_by_Head_Office__c    = payrec.P45_Date_by_Head_Office__c ;
            pay.IP_Branch_Code__c = payrec.IP_Branch_Code__c;
            pay.IP_GUID__c = payrec.IP_GUID__c;
            pay.P45_Initiated__c   = payrec.P45_Initiated__c;
            pay.IP_EmergencyPull__c = payrec.IP_EmergencyPull__c;
            pay.Reason_for_P45_Internal__c   = payrec.Reason_for_P45_Internal__c;
            pay.IP_TimesheetIDLink__c = payrec.IP_TimesheetIDLink__c;
            pay.For_P45_batch__c   = payrec.For_P45_batch__c;
            pay.IP_Payroll_Leaver__c  = payrec.IP_Payroll_Leaver__c ;
        }
        pay.IP_Status__c = 'Active';
        pay.IP_PassToTempest__c = payrec.IP_PassToTempest__c;
        pay.IP_LastPassedToTempest__c = payrec.IP_LastPassedToTempest__c;

        try{
            insert pay;
            PageReference pageref = new PageReference('/apex/RecordTypeselection');
            pageref.setRedirect(true);
            return pageref;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }

    public pageReference cancelredirect(){
        Pagereference pagenew = new Pagereference('/'+parentID);
        pagenew.setRedirect(true);
        return pagenew;
    }

}