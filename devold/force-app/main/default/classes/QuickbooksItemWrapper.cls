public class QuickbooksItemWrapper {
    public list<BatchItemRequest> BatchItemRequest;
    public class QBOItem {  
       // public String Id;
       // public string SyncToken;
        public String Sku; 
        public String Name;
        public String Description;
        public Boolean Active;
        public String Type;
        public Boolean sparse;
        public QuickBooksCategoryAccountRefWrapper IncomeAccountRef;
        public QuickBooksCategoryAccountRefWrapper ExpenseAccountRef;
        public QuickBooksCategoryAccountRefWrapper AssetAccountRef;
        
        public QBOItem(Product2 productRec) {
            if(productRec != null) {
                this.Name = productRec.Name;
                this.Sku = productRec.Id; 
                this.Active = productRec.IsActive;
                this.Description = productRec.Description;
                //this.Name = productRec.Name;
                this.Type = 'Service';	//Product
                if(productRec.Name.containsIgnoreCase('welcome') || productRec.Name.containsIgnoreCase('kit')){
                    this.IncomeAccountRef = new QuickBooksCategoryAccountRefWrapper(Label.QBO_Welcome_Kit_Income_Ref_Id);
                }
                else{
                   this.IncomeAccountRef = new QuickBooksCategoryAccountRefWrapper(Label.QBO_Diamond_Income_Ref_Id);
                }
                //this.ExpenseAccountRef = new QuickBooksCategoryAccountRefWrapper();
                //this.AssetAccountRef = new QuickBooksCategoryAccountRefWrapper();
            }
        }
    }
    
    public class QuickBooksCategoryAccountRefWrapper {
        public String value;
        public QuickBooksCategoryAccountRefWrapper(String value) {
            this.value = value;
        }
    }
    
    public class BatchItemRequest{
        public QBOItem Item;
        public String operation;
        public String bId;
    }
}