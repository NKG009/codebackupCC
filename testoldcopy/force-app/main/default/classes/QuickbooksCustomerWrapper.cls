public class QuickbooksCustomerWrapper {
    /*public QuickbooksCustomerWrapper() {
        
    }
    public list<BatchItemRequest> BatchItemRequest;
    public Class Customer{
        public String Id;
        public String SyncToken;
        public String Title;
        public String GivenName;
        public String MiddleName;
        public String FamilyName;
        public String Suffix;
        public String CompanyName;
        public String DisplayName;
        public String PrintOnCheckName;
        public QuickbooksBillAddr BillAddr;
        public QuickbooksBillAddr ShipAddr;
        public Phone Fax;
        public PrimaryEmailAddr PrimaryEmailAddr;
        public Phone PrimaryPhone;
        public Phone Mobile;
        public Phone AlternatePhone;
        public WebAddr WebAddr;
       // public QBOInnerEntityWrapper SalesTermRef;
        
        public Customer(Contact customerRec) {
            if(customerRec != null) {
                this.Id = customerRec.QBO_Customer_Id__c;
               // this.SyncToken = customerRec.QBO_SyncToken__c;
                this.GivenName = customerRec.FirstName;
               // this.MiddleName = customerRec.MiddleName;
                this.FamilyName = customerRec.LastName;
                this.Title = customerRec.Title;
                this.Suffix = customerRec.Suffix;
                this.CompanyName = customerRec.account.Eterneva_Account_ID__c;
                string name = this.CompanyName;
                if(this.GivenName!=null || this.GivenName != ' '){
                    name =name+this.GivenName;
                }
           
                if(this.FamilyName!=null || this.FamilyName!= ' '){
                    name =name+this.FamilyName;
                }
                system.debug('name'+name);
                this.DisplayName =  name;
                this.PrintOnCheckName= this.GivenName+' '+this.FamilyName;
                
                this.BillAddr = new QuickbooksBillAddr();
                this.BillAddr.Line1 = customerRec.MailingStreet;
                //this.BillAddr.Line2 = customerRec.Billing_Street_2_Quickbooks__c;
                this.BillAddr.City = customerRec.MailingCity;
                this.BillAddr.CountrySubDivisionCode = customerRec.MailingState;
                this.BillAddr.Country = customerRec.MailingCountry;
                this.BillAddr.PostalCode = customerRec.MailingPostalCode;
               
                
                //this.Fax = new Phone(customerRec.);
                this.PrimaryEmailAddr = new PrimaryEmailAddr(customerRec.Email);
                this.Mobile = new Phone(customerRec.MobilePhone);
                this.PrimaryPhone = new Phone(customerRec.Phone);
               // this.AlternatePhone = new Phone(customerRec.Other_Phone_Quickbooks__c);
                //this.WebAddr = new WebAddr(customerRec.Email);
                
               // if(customerRec.Terms__c != null) {
               // 	this.SalesTermRef = new QBOInnerEntityWrapper(customerRec.Terms__c, null); 

            }
        }
    }
    
    public Class WebAddr{
        public String URI;
        
        public WebAddr(String uri) {
            this.URI = uri;
        }
    }
    public Class Phone{
        public String FreeFormNumber;
        
        public Phone(String mobNumber) {
            this.FreeFormNumber = mobNumber;
        }
    }
    public Class PrimaryEmailAddr {
        public String Address;
        
        public PrimaryEmailAddr(String emailAddress) {
            this.Address = emailAddress;
        }
    }
    public class BatchItemRequest{
        public Customer Customer;
        public String operation;
        public String bId;
    }
    */
}