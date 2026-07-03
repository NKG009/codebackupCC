public class subcategoriesResponseWrapper {

    public list<childCategories> childCategories{get;set;}
		public String name{get;set;}
		public String url{get;set;}
		public String label{get;set;}
    
		public class childCategories{
		public String url{get;set;}
		public String label{get;set;}
		public String name{get;set;}
		public String childCategories{get;set;}
	}
   
    
 
}