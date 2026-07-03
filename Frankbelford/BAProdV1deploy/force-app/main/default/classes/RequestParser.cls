public class RequestParser {
    public class FrostCandidateRequest
    {
        public string LastName; // @Surname char (20)
        public string FirstName; // @Forename char (20)
        public string Address1; //@Address char (100)
        public string Address2; //@Address2 char (100)
        public string Town; //@PostTown char (100)
        public string County; //@County char (100)
        public string PostCode; //@Postcode char (24)
        public string Phone; //@Telephone varchar(80)
        public DateTime DOB; //@DOB smalldatetime
        public string PhoneType; //@PhoneType char (20)
        public string Title; //@Title char (4)
        public string Initials; //@Initials char (4)
        public string Gender; //@Sex char (1)
        public string Nino; //@NiNo char (9)
        public integer Care; //@Care int
        public integer TempApplicant; //@TempApplicant int
        public integer PermApplication; //@PermApplicant int
        public string ThirdPartyTemp; //@ThirdPartyTemp char (1)
        public integer Office; //@Office int
        public integer Driver; //@Driver int
        public integer ShareIssue; //@ShareIssue int
        public integer Industrial; //@Industrial int
        public integer Catering; //@Catering int
        public integer Technical; //@Technical int
        public integer Status; //  @Status int
        public string Controller; //@Controller char (30)
        public string ControllerId; //ControllerID varchar(8)
        public string LensKey; //varchar 20
        
        public LtdCompanyRequest LtdCompany;
    }
    
    
    public class LtdCompanyRequest
    {
        public string Name; // @LtdCompanyName varchar(50)
        public string RegNo; // @LtdCompanyRegNo varchar(15)
        public string ApplicantID; // @ApplicantID varchar(10) or @LTDCpyID varchar(10)
        public string ControllerID; // @ControllerID varchar(8)
        public integer TaxTypesID; // @TaxTypesID int
        public string CISCertNo; // @CISCertNo(varchar(13)) = (NULL)
        public DateTime CISExpiry; // @CISExpiry smalldatetime = NULL
        public integer SignedByWorker; // @LtdSignedByWorker tinyint
        public integer SignedByCompany; // @LtdSignedByCompany tinyint
        public integer CompanyVatRegistered; // @LtdCompanyVatRegistered tinyint
        public string CompanyVATRegNo; // @LtdCompanyVATRegNo varchar(15)
        public integer OkToSupply; // @LtdOkToSupply tinyint -- Users can not change this (only Back Office)
        public boolean CIS; // @CIS bit = 0
        public string VerificationNo; // @VerificationNo Varchar(13) = NULL
        public DateTime VerificationDate; // @VerificationDate smalldatetime = NULL
        public string TaxRate; // @TaxRate varchar(1) = NULL
        public string UTR; // @UTR char (10) = NULL
        public integer CompanyTypeID; // @LtdCompanyTypeID INT = NULL
        public string ShareInPSC; // @ShareInPSC varchar(30) = NULL    
    }
    
}