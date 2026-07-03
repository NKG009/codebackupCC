public class directmgmtcontroller {
    public set<ID> checkbatch1 = new set<ID>();
    public set<ID> checkbatch2 = new set<ID>();
    public set<ID> checkbatch3 = new set<ID>();
     public integer counter1=0;  //keeps track of the offset
      public integer counter{get;set;}
   public integer list_size{get;set;} //sets the page size or number of rows
   public integer total_size{get;set;} 
    public integer pagesize {get;set;} 
      public Boolean bnext = false;
       public Boolean batchlineBoolean{get;set;}
    public Boolean bprevious = true;
  //  public static final Integer PAGE_SIZE = 100;
    public List<IP_BatchLine__c> batchline;
  //  public List<CCWRow> tRecords{get;set;}
    transient List<Batch_header__c> batchheader = new List<Batch_header__c>();
    public List<IP_BatchLine__c> batchlineupdate = new List<IP_BatchLine__c>();
    public Map<Id,String> mapBatchLineIdCandidateName{get;set;}
    public Map<Id,String> mapBatchLineIdCandidateBranchName{get;set;}
    public Map<Id,String> mapBatchLineIdCandidateBranchPostCode{get;set;}
    public String status{get;set;}
    public Id selectedbatchId { get; set; }
    public string selectedduration{ get; set; }
    public string selectedbatchtype{ get; set; }
    public String sortDirection = 'ASC';
    public String sortExp = 'IP_TextField1__c';
    public string batchtype;
    public string btype{get;set;}
    public boolean displaymsg {get;set;}
    public string checkrender{get;set;}
    public List<String> type;
    public User u;  
    public Integer totalPages{get;set;}
    transient List<sirenum__Timesheet__c> tslist = new List<sirenum__Timesheet__c>();
    public set<string> tsids = new set<string>();
    @TestVisible Map<Id,Contact> mapCanidateIdCandidateRecord;
    //default page size

    //pagination information
 /*    public Integer page{get;set;}
   public Integer totalRecords{get;set;}
  
    public Integer startIdx{get;set;}
    public Integer endIdx{get;set;} */
    //set controller
    //public List<CCWRow> tRecords{get;set;}
   
    public directmgmtcontroller () {
        batchlineBoolean = false;
    list_size = 1000;
  //  pagesize = list_size ;
        counter=1;
        mapBatchLineIdCandidateName = new Map<Id,String>();
      //selectedduration = 'Last 7 Days';
        u = [Select id, Batch_Type__c from User where id =:Userinfo.getUserId()];
        
      //  this.tRecords = new List<CCWRow>();
        //set initial page
      //  this.page = 1;
       
         mapCanidateIdCandidateRecord = new Map<Id,Contact>();
        mapBatchLineIdCandidateName = new Map<Id,String>();
        mapBatchLineIdCandidateBranchName = new Map<Id,String>();
        mapBatchLineIdCandidateBranchPostCode = new Map<Id,String>();

    }

 
     public SelectOption[] getbatchtypeOptions() {
         
         SelectOption[] options = new SelectOption[]{};
         options.add(new SelectOption('','--None--'));
         string st = u.Batch_Type__c;
              if(st!=null)
              {               
                list<string> strLst = st.split(';');
                for(String s: strLst)
                {
                    options.add(new SelectOption(s,s));
                }
              }
 
         return options;      
              
    } 
   
    public SelectOption[] getAllduration() {
        SelectOption[] options = new SelectOption[]{};
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('LAST_N_DAYS:7','Last 7 Days'));  
        options.add(new SelectOption('LAST_N_DAYS:14','Last 14 Days')); 
        options.add(new SelectOption('LAST_N_DAYS:28','Last 28 Days')); 
        options.add(new SelectOption('LAST_N_DAYS:52','Last 52 Days'));
        return options;      

    }
    
     public SelectOption[] getbatchOptions() {
        
         SelectOption[] options = new SelectOption[]{};
         options.add(new SelectOption('','--None--'));
                system.debug('print selected type'+selectedduration ); 
             if(selectedbatchtype == 'Shop Direct')    
             {            
                if(selectedduration == 'LAST_N_DAYS:7')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE 'Shop Direct%'  and createddate = LAST_N_DAYS:7 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:14')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE 'Shop Direct%'  and createddate = LAST_N_DAYS:14 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:28')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE 'Shop Direct%'  and createddate = LAST_N_DAYS:28 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                    
                else if(selectedduration == 'LAST_N_DAYS:52')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE 'Shop Direct%'  and createddate = LAST_N_DAYS:52 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                
             }
             else if(selectedbatchtype == 'Beeline')
             {
                 if(selectedduration == 'LAST_N_DAYS:7')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Beeline%'  and createddate = LAST_N_DAYS:7 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:14')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Beeline%'  and createddate = LAST_N_DAYS:14 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:28')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Beeline%'  and createddate = LAST_N_DAYS:28 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                    
                else if(selectedduration == 'LAST_N_DAYS:52')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Beeline%'  and createddate = LAST_N_DAYS:52 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
             }
             else if(selectedbatchtype == 'IKEA')
             {
                 if(selectedduration == 'LAST_N_DAYS:7')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE '%Ikea%'  and createddate = LAST_N_DAYS:7 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:14')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE '%Ikea%'  and createddate = LAST_N_DAYS:14 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:28')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE '%Ikea%'  and createddate = LAST_N_DAYS:28 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                    
                else if(selectedduration == 'LAST_N_DAYS:52')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where ((IP_Status__c = 'Pending Approval' and IP_State__c = 'Open') OR (IP_Status__c = 'Errored' and IP_State__c = 'Processing'))  and IP_BatchType__c LIKE '%Ikea%'  and createddate = LAST_N_DAYS:52 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                } 
             }
             else if(selectedbatchtype == 'Generic')
             {
                if(selectedduration == 'LAST_N_DAYS:7')
                {
                    for(Batch_header__c bh : ([Select id,IP_Account__c,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing'  and IP_BatchType__c LIKE '%Generic%'  and createddate = LAST_N_DAYS:7 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.IP_Account__c+'-'+bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:14')
                {
                    for(Batch_header__c bh : ([Select id,IP_Account__c,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Generic%' and createddate = LAST_N_DAYS:14 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.IP_Account__c+'-'+bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:28')
                {
                    for(Batch_header__c bh : ([Select id,IP_Account__c,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing'  and IP_BatchType__c LIKE '%Generic%' and createddate = LAST_N_DAYS:28 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.IP_Account__c+'-'+bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                    
                else if(selectedduration == 'LAST_N_DAYS:52')
                {
                    for(Batch_header__c bh : ([Select id,IP_Account__c,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing'  and IP_BatchType__c LIKE '%Generic%' and createddate = LAST_N_DAYS:52 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.IP_Account__c+'-'+bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }  
             }
             else
             {
                if(selectedduration == 'LAST_N_DAYS:7')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Capita%'  and createddate = LAST_N_DAYS:7 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:14')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Capita%'  and createddate = LAST_N_DAYS:14 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                else if(selectedduration == 'LAST_N_DAYS:28')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Capita%'  and createddate = LAST_N_DAYS:28 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }
                    
                else if(selectedduration == 'LAST_N_DAYS:52')
                {
                    for(Batch_header__c bh : ([Select id,Name,IP_BatchType__c,Createddate,IP_Status__c from Batch_header__c where IP_Status__c = 'Errored' and IP_State__c = 'Processing' and IP_BatchType__c LIKE '%Capita%'  and createddate = LAST_N_DAYS:52 Order BY Name DESC]))
                        options.add(new SelectOption(String.valueOf(bh.Id),bh.Name+'-'+bh.IP_BatchType__c+'-'+bh.Createddate+'-'+bh.IP_Status__c));  
                }  
             }
               return options;                 
         } 
         
    public void updatenull(){
        if(selectedduration!=null){
            selectedduration = null;
        }
    }
    
    public void updatebatchnull(){
        if(selectedbatchId !=null && selectedduration!=null)
        selectedbatchId = null;
    }
             
               
    public String sortExpression{        
        get{
            return sortExp;
        }
        set{
       //if the column is clicked on then switch between Ascending and Descending modes
        if (value == sortExp)
            sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
        else
            sortDirection = 'ASC';        
        
        sortExp = value;
        }
    }


    public String getSortDirection(){
    //if not column is selected   
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
    }  
    
    public void setSortDirection(String value){  
        sortDirection = value;
    } 
   
    public PageReference displaylines() {
        System.debug('**selectedbatchId'+selectedbatchId);
        batchlineBoolean = true;
        if(selectedbatchId!=null){
          
            Batch_header__c header = [Select id,Batch_check__c from Batch_header__c where id =:selectedbatchId];
            header.Batch_check__c = 'All';
            update header;
            
             if(batchline != null && batchline.size()>0){
        batchline.clear();       counter = 1;        bnext = false;       bprevious = true;
System.debug('**in batch '+batchline.size());
        }
        showlines();
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
        }
        return null;
    }
      public List<IP_BatchLine__c> getbatchline() {        
        return batchline;
    }   
    public pageReference showerroredlines(){   
        batchlineBoolean = true;    
        if(selectedbatchId!=null){
            Batch_header__c header = [Select id,Batch_check__c from Batch_header__c where id =:selectedbatchId];
            header.Batch_check__c = 'Error';
            update header;
                 if(batchline != null && batchline.size()>0){
        batchline.clear();
    counter = 1;
bnext = false;
       bprevious = true;
        }
                
            showlines();
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
        }
        return null;
    }   

    public pageReference checkstatus(){
        if(selectedbatchId!=null){
        Batch_header__c header1 = [Select id,IP_Status__C,Check_status__c,IP_BatchType__c from Batch_header__c where id =:selectedbatchId];
        status = header1.IP_Status__C;
        btype = header1.IP_BatchType__c;
        if(header1.Check_status__c!=null){
            checkrender = 'true';
        }
        else{
            checkrender = 'false';
        }
        }
   
        return null;
    }
public PageReference Beginning() { //user clicked beginning
      counter = 0;      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;       bnext = false;       bprevious = true;        showlines();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;       bnext = true;       bprevious = false;       showlines();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>1) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {
      return counter/list_size + 1;
   }

   public Integer getTotalPages () {
   system.debug('@@ +pagestotal' );
      if (math.mod(total_size, list_size) > 0) {
      totalPages = total_size/list_size + 1;
      system.debug('@@ '+totalPages );
         return totalPages;
      } else {
       totalPages = (total_size/list_size);
        system.debug('@@ '+totalPages );
         return totalPages;
        
      }
   }
    public pageReference showlines(){
       Integer pagenum = getPageNumber();
   
 //   List<IP_BatchLine__c> bline2 = new List<IP_BatchLine__c>();
        Batch_header__c checkheader = [Select id,Batch_check__c from Batch_header__c where id =:selectedbatchId];
      
        string sortFullExp = sortExpression  + ' ' + sortDirection;
   // set<ID> checkbatch1 = new set<ID>();
   // set<ID> checkbatch2 = new set<ID>();
        Integer counttotal=1;
        if(checkheader.Batch_check__c == 'All'){
      
                  system.debug('bnext %%% '+bnext+bprevious);
              for(IP_BatchLine__c bccline : [Select ID from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId ORDER By Id ASC limit 3000]){
                if(counttotal>1000 && counttotal<=2000 && bnext == true && bprevious == false && pagenum <3){
                    checkbatch2.add(bccline.Id);                    
                }
                else if(counttotal>2000 && counttotal<=3000 && bnext == true && bprevious == false){
                    checkbatch3.add(bccline.Id);
                }
                else if(counttotal<=1000 && bnext == false && bprevious == true){
                    checkbatch1.add(bccline.Id);
                }
                counttotal++;
                
            }
                    system.debug('counttotal %%% '+counttotal);
            if(checkbatch1.size()>0 && bnext == false && bprevious == true){
                    batchline = Database.query('Select id,IP_Number12d4Field1__c,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_TextField2__c ,IP_TextField3__c, IP_DateField2__c,IP_Status__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c,IP_LinkField1__c,IP_TextField5__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and ID in : checkbatch1 Order By ' + sortFullExp+ ' limit:list_size' ); 
                   // total_size =  batchline.size();  
                 system.debug('in IF');

            }
            else if(checkbatch2.size()>0 && bnext == true && bprevious == false && pagenum <3){
                    batchline = Database.query('Select id,IP_Number12d4Field1__c,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_TextField2__c ,IP_TextField3__c ,IP_DateField2__c,IP_Status__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c,IP_LinkField1__c,IP_TextField5__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and ID in : checkbatch2 Order By ' + sortFullExp+ ' limit:list_size' ); 
                  //  total_size =  batchline.size();    
                 system.debug('in else IF');
            }
             else if(checkbatch3.size()>0 && bnext == true && bprevious == false && counttotal>2000 && pagenum >2){
                    batchline = Database.query('Select id,IP_Number12d4Field1__c,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_TextField2__c ,IP_TextField3__c ,IP_Status__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c,IP_LinkField1__c,IP_DateField2__c,IP_TextField5__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and ID in : checkbatch3 Order By ' + sortFullExp+ ' limit:list_size' ); 
                  //  total_size =  batchline.size();    
                 system.debug('in else IF2');
            }
            total_size = counttotal-1;
           
          //  Integer pagenum = getPageNumber();
            pagesize =  pagenum * list_size;
             if(pagesize > total_size ){pagesize =total_size ; }
        }
        else{
         if(batchline != null && batchline.size()>0){        batchline.clear();

        }
               for(IP_BatchLine__c bccline : [Select ID from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and IP_Status__c = 'Errored' ORDER By Id ASC limit 3000]){
                if(counttotal>1000 && counttotal<=2000 && bnext == true && bprevious == false && pagenum <3){                    checkbatch2.add(bccline.Id);                    
                }
                else if(counttotal>2000 && counttotal<=3000 && bnext == true && bprevious == false){                    checkbatch3.add(bccline.Id);
                }
                else if(counttotal<=1000 && bnext == false && bprevious == true){                    checkbatch1.add(bccline.Id);
                }
                counttotal++;
                
            }
                    system.debug('counttotal %%% '+counttotal);
            if(checkbatch1.size()>0 && bnext == false && bprevious == true){
                    batchline = Database.query('Select id,IP_Number12d4Field1__c,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_TextField2__c ,IP_TextField3__c ,IP_Status__c,IP_DateField2__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c,IP_LinkField1__c,IP_TextField5__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and ID in : checkbatch1 and IP_Status__c = \'Errored\' Order By ' + sortFullExp+ ' limit:list_size' ); 
                   // total_size =  batchline.size();  
                 system.debug('in IF');

            }
            else if(checkbatch2.size()>0 && bnext == true && bprevious == false && pagenum <3){
                    batchline = Database.query('Select id,IP_Number12d4Field1__c,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_TextField2__c ,IP_TextField3__c ,IP_Status__c,IP_DateField2__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c,IP_LinkField1__c,IP_TextField5__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and ID in : checkbatch2 and IP_Status__c = \'Errored\' Order By ' + sortFullExp+ ' limit:list_size' ); 
                  //  total_size =  batchline.size();    
                 system.debug('in else IF');
            }
             else if(checkbatch3.size()>0 && bnext == true && bprevious == false && counttotal>2000 && pagenum >2){
                    batchline = Database.query('Select id,IP_Number12d4Field1__c,name,IP_BatchHeader__c,IP_BatchHeader__r.Name,IP_DateField1__c,IP_TextField1__c,IP_TextField2__c ,IP_TextField3__c ,IP_Status__c,IP_DateField2__c,IP_TextField4__c,IP_TextField9__c,IP_CurrencyField1__c,IP_CurrencyField2__c,IP_ErrorReason__c,IP_LinkField1__c,IP_TextField5__c from IP_BatchLine__c where IP_BatchHeader__c=:selectedbatchId and ID in : checkbatch3 and IP_Status__c = \'Errored\' Order By ' + sortFullExp+ ' limit:list_size' ); 
                  //  total_size =  batchline.size();    
                 system.debug('in else IF2');
            }
            total_size = counttotal-1;
           
           
            pagesize =  pagenum * list_size;
             if(pagesize > total_size ){pagesize =total_size ; }   
        }
      @TestVisible Map<Id,Id> mapBatchLineIdCandidateId = new Map<Id,Id>();
        mapCanidateIdCandidateRecord = new Map<Id,Contact>();
        mapBatchLineIdCandidateName = new Map<Id,String>();
        mapBatchLineIdCandidateBranchName = new Map<Id,String>();
        mapBatchLineIdCandidateBranchPostCode = new Map<Id,String>();
        //System.debug('++++batchline++'+batchline.size());
        if(batchline!=null && !batchline.isEmpty()){
            for(IP_BatchLine__c bLine : batchline){
                mapBatchLineIdCandidateId.put(bLine.Id,bLine.IP_LinkField1__c);
            }
           // System.debug('++++mapBatchLineIdCandidateId++'+mapBatchLineIdCandidateId);
            if(!mapBatchLineIdCandidateId.isEmpty()){
                for(Contact candidate : [Select id,Name,IP_TempestDepartment__c,Owner.UserRole.Name from Contact where ID IN: mapBatchLineIdCandidateId.values()]){
                    mapCanidateIdCandidateRecord.put(candidate.id,candidate);
                }
            }
           // System.debug('**mapCanidateIdCandidateRecord'+mapCanidateIdCandidateRecord);
            for(IP_BatchLine__c bLine : batchline){
               // System.debug('1111111111bLine111111111111111'+bLine.id);
              //  System.debug('1111111111bLine111111111111111'+bLine.IP_LinkField1__c);
              //  System.debug('1111111111111111111111111'+mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c));
                if(!mapCanidateIdCandidateRecord.isEmpty()){
                    if(mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c)==null){
                        mapBatchLineIdCandidateName.put(bLine.Id,bLine.IP_TextField1__c);                        mapBatchLineIdCandidateBranchPostCode.put(bLine.Id,'');                        mapBatchLineIdCandidateBranchName.put(bLine.Id,'');
                    }
                    else{           
                    //    System.debug('**link field 1'+bLine.IP_LinkField1__c);
                     //   System.debug('**mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c)'+mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c));
                        mapBatchLineIdCandidateName.put(bLine.Id,bLine.IP_TextField1__c);
                        if(mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c).Owner.UserRole.Name!=null){
                            mapBatchLineIdCandidateBranchName.put(bLine.Id,mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c).Owner.UserRole.Name);
                        }
                        else{
                            mapBatchLineIdCandidateBranchName.put(bLine.Id,'');
                        }
                        if(mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c).IP_TempestDepartment__c!=null){
                            mapBatchLineIdCandidateBranchPostCode.put(bLine.Id,mapCanidateIdCandidateRecord.get(bLine.IP_LinkField1__c).IP_TempestDepartment__c);                       
                        }
                        else{
                            mapBatchLineIdCandidateBranchPostCode.put(bLine.Id,'');
                        }
                    }
                }
                else{
                    mapBatchLineIdCandidateName.put(bLine.Id,'');
                    mapBatchLineIdCandidateBranchPostCode.put(bLine.Id,'');
                    mapBatchLineIdCandidateBranchName.put(bLine.Id,'');
                }   
            }
        }
        getTotalPages ();
      //  System.debug('++++++++++++++++++++++++mapBatchLineIdCandidateName++'+mapBatchLineIdCandidateName);
    //    System.debug('++++++++++++++++++++++++mapBatchLineIdCandidateBranchPostCode++'+mapBatchLineIdCandidateBranchPostCode);
     //   System.debug('++++++++++++++++++++++++mapBatchLineIdCandidateBranchName++'+mapBatchLineIdCandidateBranchName);
      //   System.debug('++++++++++++++++++++++++batchline++'+batchline);
        return null; 
    }

    public with sharing class CCWRow{
        public IP_BatchLine__c tbachline{get;set;}
        
        public CCWRow(IP_BatchLine__c bccline){
            if(bccline!=null){                this.tbachline=bccline;}
        
        }    
    }
    
    public Pagereference approvebatch(){
        if(selectedbatchID!=null){
            Batch_header__c b = [Select id,IP_Status__c,IP_State__c from Batch_header__c where id=:selectedbatchID];
            if(b.IP_Status__c == 'Pending Approval'){
                b.IP_Status__c = 'Approved';  b.IP_State__c = 'Closed';
            }
            batchlineupdate = [Select id,IP_Status__c,IP_ErrorReason__c,IP_BatchHeader__r.IP_BatchType__c,IP_LinkField1__c,IP_LinkField2__c,IP_LinkField3__c,IP_LinkField4__c,IP_LinkField5__c,IP_LinkField6__c,IP_LinkField7__c from IP_BatchLine__c where IP_BatchHeader__c =:selectedbatchID and (IP_Status__c!='Complete' and IP_Status__c!='Processed')];
            for(IP_BatchLine__c b1: batchlineupdate){
                batchtype = b1.IP_BatchHeader__r.IP_BatchType__c;
                if(batchtype == 'Capita' || batchtype == 'Beeline'){
                    tsids.add(b1.IP_LinkField4__c);
                }
                else if(batchtype == 'Generic'){
                    tsids.add(b1.IP_LinkField5__c);
                }
                else
                {
                    tsids.add(b1.IP_LinkField6__c);
                }

                b1.IP_Status__c = 'Open';
                b1.IP_ErrorReason__c = '';
                b1.IP_LinkField1__c = '';
                b1.IP_LinkField2__c = '';
                b1.IP_LinkField3__c = '';
                b1.IP_LinkField4__c = '';
                b1.IP_LinkField5__c = '';
                b1.IP_LinkField6__c = '';
                b1.IP_LinkField7__c = '';
            }
            if(!tsids.isEmpty()){
                tslist = [Select id from sirenum__Timesheet__c where id in:tsids and sirenum__Lines__c = 0]; 
            }
            try{
                if(tslist.size()>0){                    delete tslist;
                }
                update b;
                update batchlineupdate;
                
                if(batchtype == 'Shop Direct - Shaw'){
                    List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectBatchHeaderclass' and status='Processing' and createddate = TODAY];

                    if(job.size()>0){                        system.debug('IF Display MSG '+b);                        displaymsg = true;
                    }
                    else{
                        system.debug('ELSE Display MSG '+displaymsg);
                        if(!Test.isRunningTest()){
                            ShopDirectBatchHeaderclass bt1 = new ShopDirectBatchHeaderclass();  Database.executeBatch(bt1,1); 
                        }
                        else{
                            ShopDirectBatchHeaderclass bt1 = new ShopDirectBatchHeaderclass();  bt1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
                        }
                    }
                }
                if(batchtype == 'Shop Direct - Shaw Amendments'){
                    List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectBatchHeaderclassFlex' and status='Processing' and createddate = TODAY];
                    if(job1.size()>0) {                         displaymsg = true;
                    }
                    else{
                        if(!Test.isRunningTest()){
                            ShopDirectBatchHeaderclassFlex batch1 = new ShopDirectBatchHeaderclassFlex();  Database.executeBatch(batch1,1); 
                        }
                        else{
                            ShopDirectBatchHeaderclassFlex batch1 = new ShopDirectBatchHeaderclassFlex();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
                        }
                    }
                }
                if(batchtype == 'Shop Direct - Ravenmill'){
                    List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectRavenMillclass' and status='Processing' and createddate = TODAY];
                    if(job1.size()>0){                        displaymsg = true;                    }
                    else{
                        if(!Test.isRunningTest()){
                            ShopDirectRavenMillclass batch1 = new ShopDirectRavenMillclass(); Database.executeBatch(batch1,1); 
                        }
                        else{
                        ShopDirectRavenMillclass batch1 = new ShopDirectRavenMillclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
                        }
                    }
                }
                if(batchtype == 'Shop Direct - Ravenmill Amendments'){
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectRavenMillAmendmentsclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectRavenMillAmendmentsclass batch1 = new ShopDirectRavenMillAmendmentsclass();  Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectRavenMillAmendmentsclass batch1 = new ShopDirectRavenMillAmendmentsclass();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);  
                }
                }
                }
                if(batchtype == 'Shop Direct - Speke')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectSpekeclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectSpekeclass batch1 = new ShopDirectSpekeclass(); Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectSpekeclass batch1 = new ShopDirectSpekeclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
                }
                }
                }
                if(batchtype == 'Shop Direct - Speke Amendments')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectSpekeAmendmentsclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectSpekeAmendmentsclass batch1 = new ShopDirectSpekeAmendmentsclass();  Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectSpekeAmendmentsclass batch1 = new ShopDirectSpekeAmendmentsclass();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);  
                }
                }
                }
                if(batchtype == 'Shop Direct - Little Hulton')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectlittlehultonclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectlittlehultonclass batch1 = new ShopDirectlittlehultonclass();  Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectlittlehultonclass batch1 = new ShopDirectlittlehultonclass();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);        
                }
                }
                }
                if(batchtype == 'Shop Direct - Little Hulton Amendments')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectliitlehultonAmendmentsclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectliitlehultonAmendmentsclass batch1 = new ShopDirectliitlehultonAmendmentsclass(); Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectliitlehultonAmendmentsclass batch1 = new ShopDirectliitlehultonAmendmentsclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);
                }
                }
                }
                if(batchtype == 'Shop Direct - Croal Mill')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectCroalMillclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                ShopDirectCroalMillclass batch1 = new ShopDirectCroalMillclass();  Database.executeBatch(batch1,1); 
                }
                }
                if(batchtype == 'Shop Direct - Croal Mill Amendments')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectCroalMillAmendmentsclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectCroalMillAmendmentsclass batch1 = new ShopDirectCroalMillAmendmentsclass(); Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectCroalMillAmendmentsclass batch1 = new ShopDirectCroalMillAmendmentsclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);   
                }
                }
                }
                if(batchtype == 'Shop Direct - FM Booking')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectFMbookclass ' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)               {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectFMbookclass  batch1 = new ShopDirectFMbookclass (); Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectFMbookclass  batch1 = new ShopDirectFMbookclass (); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);       
                }
                }
                }
                if(batchtype == 'Shop Direct - FM Booking Amendments')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectFMbookamendclass ' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectFMbookamendclass  batch1 = new ShopDirectFMbookamendclass ();  Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectFMbookamendclass  batch1 = new ShopDirectFMbookamendclass ();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);        
                }
                }
                }
                if(batchtype == 'Shop Direct - Internals')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectinternalsclass ' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectinternalsclass  batch1 = new ShopDirectinternalsclass ();  Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectinternalsclass  batch1 = new ShopDirectinternalsclass ();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);        
                }
                }
                }
                if(batchtype == 'Shop Direct - Internals Amendments')
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'ShopDirectinternalsamendclass ' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                ShopDirectinternalsamendclass  batch1 = new ShopDirectinternalsamendclass ();  Database.executeBatch(batch1,1); 
                }
                else
                {
                ShopDirectinternalsamendclass  batch1 = new ShopDirectinternalsamendclass ();  batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);      
                }
                }
                }
                System.debug('check batchtype'+batchtype);
                if(batchtype.contains('Vanquish - Ikea') )
                {
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'IkeaBatchHeaderClass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0)                {                displaymsg = true;
                }
                else
                {
                if(!Test.isRunningTest())
                {
                IkeaBatchHeaderClass batch1 = new IkeaBatchHeaderClass(); Database.executeBatch(batch1,1); 
                }
                else
                {
                IkeaBatchHeaderClass batch1 = new IkeaBatchHeaderClass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]);        
                }
                }
                }
                if(batchtype == 'Capita'){
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'CapitaBatchHeaderclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0){                displaymsg = true;
                }
                else{
                if(!Test.isRunningTest()){
                CapitaBatchHeaderclass batch1 = new CapitaBatchHeaderclass(); Database.executeBatch(batch1,1); 
                }
                else{
                CapitaBatchHeaderclass batch1 = new CapitaBatchHeaderclass(); batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
                }
                }
                }

                if(batchtype == 'Beeline'){
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'BeelineBatchHeaderClass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0){                displaymsg = true;
                }
                else{
                if(!Test.isRunningTest()){
                BeelineBatchHeaderClass batch1 = new BeelineBatchHeaderClass();                 Database.executeBatch(batch1,1); 
                }
                else{
                BeelineBatchHeaderClass batch1 = new BeelineBatchHeaderClass(); 
                batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
                }
                }
                }
                if(batchtype == 'Generic'){
                List<AsyncApexJob> job1 = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'GenericBatchHeaderclass' and status='Processing' and createddate = TODAY];
                if(job1.size()>0){                displaymsg = true;
                }
                else{
                if(!Test.isRunningTest()){
                GenericBatchHeaderclass batch1 = new GenericBatchHeaderclass();                 Database.executeBatch(batch1,1); 
                }
                else{
                GenericBatchHeaderclass batch1 = new GenericBatchHeaderclass(); 
                batch1.execute(null,[Select id from IP_BatchLine__c where id in :batchlineupdate]); 
                }
                }
                }

            }
            catch(Exception e){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Batch Header'));
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
        }

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Approved and Batch processing initiated'));

        PageReference pageRef = new PageReference('/apex/DirectImportMgmt'+'?sx=0');
        return pageRef.setRedirect(true);
    }


    public Pagereference rejectbatch(){    
        if(selectedbatchID!=null)
        {
            Batch_header__c b = [Select id,IP_Status__c,IP_State__c from Batch_header__c where id=:selectedbatchID ];
            b.IP_Status__c = 'Rejected';
            b.IP_State__c = 'Closed';
            batchlineupdate = [Select id,IP_Status__c from IP_BatchLine__c where IP_BatchHeader__c =:selectedbatchID];
            for(IP_BatchLine__c b1: batchlineupdate)
            {
                b1.IP_Status__c = 'Rejected';
            }
            try{
                update b;
                update batchlineupdate;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Batch header Rejected'));
                selectedduration = '';
                selectedbatchtype = '';
                /*PageReference pageRef = new PageReference('/apex/DirectImportMgmt'+'?sx=0');
                return pageRef.setRedirect(true);*/
            }
            catch(Exception e){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Batch Header'));
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
        }
        return null;
    }
    
    
    public Pagereference closebatch(){      
        if(selectedbatchID!=null){
            Batch_header__c b = [Select id,IP_Status__c,IP_State__c,IP_BatchType__c from Batch_header__c where id=:selectedbatchID ];
            
            //[10918]:Update status to Processed on Close Batch button
            b.IP_Status__c = 'Processed';
            b.IP_State__c = 'Closed';
            /*if(b.IP_BatchType__c == 'Capita' || b.IP_BatchType__c == 'Beeline'){
                b.IP_Status__c = 'Complete'; 
                b.IP_State__c = 'Processing';
            }
            else{
                b.IP_Status__c = 'Processed';
                b.IP_State__c = 'Closed';
            }*/
            
            batchlineupdate = [Select id,IP_Status__c from IP_BatchLine__c where IP_BatchHeader__c =:selectedbatchID and (IP_Status__c!='Complete' AND IP_Status__c!= 'Processed')];
            for(IP_BatchLine__c b1: batchlineupdate){
                b1.IP_Status__c = 'Rejected';
            }
            try{
                update b;
                update batchlineupdate;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Batch header Closed'));
                selectedduration = '';
                selectedbatchtype = '';
                /*PageReference pageRef = new PageReference('/apex/DirectImportMgmt'+'?sx=0');
                return pageRef.setRedirect(true);*/
            }
            catch(Exception e){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Batch Header'));
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Batch header'));
        }
        return null;
    }

}