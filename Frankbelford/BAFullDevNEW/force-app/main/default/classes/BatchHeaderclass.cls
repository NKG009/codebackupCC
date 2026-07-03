global class BatchHeaderclass implements Database.Batchable<sObject>,Database.Stateful{
    
    // Start method of batch for fecthing data from object
    global Database.QueryLocator start(Database.BatchableContext BC){
        //   IP_State__c = \'Closed\' and IP_Status__c = \'Open\'
        String  query = 'select Id,IP_State__c,IP_Status__c,IP_BatchType__c from Batch_header__c where (IP_BatchType__c!=\'P45 Sync\' AND IP_BatchType__c!=\'Capita\') And ((IP_State__c = \'Closed\' And IP_Status__c = \'Approved\') OR (IP_State__c = \'processing\' AND IP_Status__c = \'Partial completed\') OR (IP_State__c = \'processing\' AND IP_Status__c = \'Complete\'))';
        return Database.getQueryLocator(query);
    }
    
    // excute method of batch for doing business logic
    global void execute(Database.BatchableContext BC,List<Batch_header__c> batchheaderlist){
     //   system.debug('Before P45 Sync method'+batchheaderlist);
     //   batchheaderlist = P45syncBatchHeader.P45sync(batchheaderlist);
     //   system.debug('After P45 Sync method'+batchheaderlist);
        
        set<id> batchheaderid = new set<id>();
        list<Batch_header__c> toupdatebatchheader = new list<Batch_header__c>();
        list<IP_BatchLine__c > toupdatebatchline = new list<IP_BatchLine__c >();
        // below list are for 4th point of batch
        list<string> accountname = new list<string>();
        list<string> sitename = new list<string>();
        list<string> batchtype = new list<string>();
        list<string> jobrollname3 = new list<string>();
        list<string> contactnamelist = new list<string>();
        
        
        // updating IP_Status__c field of Batch Header object
        for(Batch_header__c batch : batchheaderlist){
            batch.IP_Status__c = 'processing';
            batchheaderid.add(batch.id);
            batchtype.add(batch.IP_BatchType__c);
        }
        
        // updating IP_Status__c of Batch Line object main batchline
        list<IP_BatchLine__c> batchlinelist = [select id,IP_BatchHeader__c,IP_CurrencyField2__c,IP_DateField1__c,IP_TextField9__c,IP_LinkField9__c,IP_CurrencyField1__c,IP_LinkField2__c,IP_LinkField3__c,IP_BatchHeader__r.IP_BatchType__c, IP_Number12d4Field1__c,IP_Status__c,IP_TextField3__c,IP_LinkField1__c,IP_TextField4__c,IP_ErrorReason__c from IP_BatchLine__c where IP_Status__c =: 'open' and IP_BatchHeader__c In :batchheaderid limit 9500];
        system.debug('inside execute method batchline'+batchlinelist );
        for(IP_BatchLine__c batchline : batchlinelist ){
            batchline.IP_Status__c = 'Open'; 
            jobrollname3.add(batchline.IP_TextField4__c);
            contactnamelist.add(batchline.IP_TextField3__c); 
            //toupdatebatchline.add(batchline);               
        }     
        
        // 3.Finding or creating a worker
        System.debug('batchlinelist-1->'+batchlinelist);
        
        list<contact> conlist1 = [select id,Name from contact where name in : contactnamelist ];
        
        Map<string,contact> conmap1 = new Map<string,contact>();
        
        for(contact con1 : conlist1 ){
            
            conmap1.put(con1.name,con1);
            
        }
        system.debug('Conlist without contact name in bline='+conlist1);
        
        for(IP_BatchLine__c bline : batchlinelist ){
            
            if(conmap1.containsKey(bline.IP_TextField3__c) && (conlist1.size() > 0) ){
                
                bline.IP_LinkField1__c = conmap1.get(bline.IP_TextField3__c).id;
                bline.IP_Status__c = 'Linking';
                
            }
            else{
                bline.IP_Status__c = 'Errored';
                bline.IP_ErrorReason__c = 'contact Not found';
                
            }
            
        }
        
        System.debug('batchlinelist-2->'+batchlinelist);
        
        
        // 4.Finding the Site and Client
        list<string> batchname = new list<string>();
        for(String s: batchtype ){
            
            if(s.containsAny('-')){
                batchname = s.split(' \\- ');
                accountname.add(batchname[0]);
                sitename.add(batchname[1]);
                
            }
            else{
                accountname.add(s);
                
            }
        }
        
        system.debug('account name'+accountname);
        system.debug('site name'+sitename);
        
        list<account> acclist = [select id,name from account where name in :accountname];
        
        Map<string,account> mapofacc = new Map<string,account>();
        
        for(account acc1 : acclist ){
            
            mapofacc.put(acc1.name,acc1); 
            
        }
        System.debug('@@ '+mapofacc);
        list<sirenum__Site__c> sitelist = [select id,name,sirenum__Operating_Company__r.id from sirenum__Site__c where name in :sitename];
        
        Map<string,sirenum__Site__c> mapofsite = new Map<string,sirenum__Site__c>(); 
        
        for(sirenum__Site__c site1 : sitelist ){
            
            mapofsite.put(site1.name,site1); 
            
        } 
        System.debug('batchlinelist-3->'+batchlinelist);
        list<string> batchname1 = new list<string>();
        for(IP_BatchLine__c bline10 :batchlinelist){
            
            if(bline10.IP_Status__c != 'Errored'){
                string batchtype1 = bline10.IP_BatchHeader__r.IP_BatchType__c;
                if(batchtype1.containsAny('-')){
                    batchname1 = batchtype1.split(' \\- ');
                    System.debug('12345 '+batchname1[0]);
                    System.debug('123 '+mapofacc.containsKey(batchname1[0]));
                    if(mapofacc.containsKey(batchname1[0])){
                        bline10.IP_LinkField2__c = mapofacc.get(batchname1[0]).id;
                    }
                    
                    if(mapofsite.containsKey(batchname1[1])){
                        
                        bline10.IP_LinkField3__c = mapofsite.get(batchname1[1]).id;
                    }
                }  
                else {
                    
                    bline10.IP_LinkField2__c = mapofacc.get(bline10.IP_BatchHeader__r.IP_BatchType__c).id;
                    
                }
                
                bline10.IP_Status__c = 'Linking';
                
            }
            
            
        }
        
        //5.Finding a Job Role 
        list<sirenum__Team__c> jobroll2 = [select id,name from sirenum__Team__c where name in : jobrollname3 ];
        
        Map<string,sirenum__Team__c> jobrollmap = new Map<string,sirenum__Team__c>();
        
        for(sirenum__Team__c jobroll4 : jobroll2){
            
            jobrollmap.put(jobroll4.name,jobroll4);
        } 
        
        system.debug(jobroll2);
        for(IP_BatchLine__c bline1 : batchlinelist ){
            if(bline1.IP_Status__c != 'Errored'){
                
                if(jobrollmap.containskey(bline1.IP_TextField4__c) && jobroll2.size() > 0 ){
                    
                    bline1.IP_Status__c = 'Linking';
                    
                }
                else{
                    bline1.IP_ErrorReason__c = 'Job Role Not found';
                    bline1.IP_Status__c = 'Errored';
                    
                }        
            }  
            
        } 
        /*******************************************************************************************/
        // check is there placement is present or not ?? If not than create it.
        set<id> conid3 = new set<id>();
        list<string> jobrollname2 = new list<string>();
        for(IP_BatchLine__c bline0 : batchlinelist ){
            
            conid3.add(bline0.IP_LinkField1__c);
            jobrollname2.add(bline0.IP_TextField4__c);      
        }
        
        system.debug('conid '+conid3+' jobrollname -->'+jobrollname2 );
        
        list<sirenum__Placement__c > placementlist = [select id,sirenum__End_Date__c,sirenum__Start_Date__c,sirenum__Contact__r.id,sirenum__Contact__r.name,sirenum__Job_Role__r.name from sirenum__Placement__c  where sirenum__Contact__r.id in : conid3  and sirenum__Job_Role__r.name in : jobrollname2 ];
        system.debug('placement list-->'+placementlist);
        set<id> blineid = new set<id>();
        list<IP_BatchLine__c> blinewithid = new list<IP_BatchLine__c>();
        
        for(IP_BatchLine__c bline2 : batchlinelist ){
            
            if(bline2.IP_Status__c != 'Errored' && placementlist.size()>0){
                
                for(sirenum__Placement__c placement : placementlist ){
                    
                    if(bline2.IP_TextField4__c == placement.sirenum__Job_Role__r.name && placementlist.size() > 0  && bline2.IP_LinkField1__c == placement.sirenum__Contact__r.id && (placement.sirenum__Start_Date__c <= bline2.IP_DateField1__c || bline2.IP_DateField1__c >= placement.sirenum__End_Date__c)){
                        
                        bline2.IP_LinkField4__c = placement.id; 
                        bline2.IP_Status__c = 'Linking';   
                        
                    }
                    
                    else {
                        
                        blineid.add(bline2.id); 
                        
                    }
                    
                }  
            }
            else {
                
                blineid.add(bline2.id); 
                
            }
            
        }
        
        system.debug('bline who dont have placement'+blineid);
        
        
        // creating contract and placement; 
        
        if(!blineid.isEmpty()){
            
            set<id> conid1 = new set<id>();
            list<string> jobrollname = new list<string>();
            set<id> accid1 = new set<id>();
            Map<id,IP_BatchLine__c> blinemapnew = new Map<id,IP_BatchLine__c>(); 
            for(IP_BatchLine__c batchLineList17 : batchlinelist ){
                
                blinemapnew.put(batchLineList17.id,batchLineList17); 
            } 
            
            for(id bid : blineid){
                if(blinemapnew.containsKey(bid)){
                    
                    accid1.add(blinemapnew.get(bid).IP_LinkField2__c); 
                    conid1.add(blinemapnew.get(bid).IP_LinkField1__c);
                    jobrollname.add(blinemapnew.get(bid).IP_TextField4__c); 
                }
            }
             system.debug('accid1 list:'+accid1);
            Map<id,sirenum__ProActiveContract__c> contractmap = new Map<id,sirenum__ProActiveContract__c>();
            list<sirenum__ProActiveContract__c > contractlist = [select id,sirenum__Client__r.id from sirenum__ProActiveContract__c where sirenum__Client__c in : accid1];
            for(sirenum__ProActiveContract__c contract1 : contractlist ){
                
                contractmap.put(contract1.sirenum__Client__r.id,contract1);
                
            }
            system.debug('contract list:'+contractmap);
            
            Map<id,contact> conmap = new Map<id,contact>([select id,name from contact where id in : conid1] );
            list<sirenum__Team__c> jobrolllist3 = [select id,name from sirenum__Team__c where name in : jobrollname];
            
            list<sirenum__Placement__c > placement3 = new list<sirenum__Placement__c>();
            
            for(IP_BatchLine__c bline5 : batchlinelist){
                
                for(sirenum__Team__c jobroll1 : jobrolllist3 ){
                    
                    if(bline5.IP_TextField4__c == jobroll1.name && conmap.containsKey(bline5.IP_LinkField1__c) &&  contractmap.containsKey(bline5.IP_LinkField2__c) ){
                        
                        sirenum__Placement__c placement1 = new sirenum__Placement__c();
                        
                        placement1.sirenum__Contact__c     =   bline5.IP_LinkField1__c;
                        placement1.sirenum__Contract__c    =   contractmap.get(bline5.IP_LinkField2__c).id;
                        placement1.sirenum__Job_Role__c    =   jobroll1.id; 
                        placement1.sirenum__Start_Date__c  =   bline5.IP_DateField1__c; 
                        placement1.Name                    =   bline5.IP_TextField4__c; 
                        placement3.add(placement1);
                        
                    }
                    
                }
                
            }
            
            try{
                insert placement3;
            }
            catch(Exception DMLException ){
                
                for(IP_BatchLine__c bline16 : batchlinelist){
                    if(bline16.IP_Status__c != 'Errored'){
                        bline16.IP_Status__c = 'Errored';
                        bline16.IP_ErrorReason__c = 'Due to Failed of Insertion of Placement';
                    }
                }
            }
            system.debug(placement3);
            
            Map<id,sirenum__Placement__c> placementmap = new Map<id,sirenum__Placement__c>();
            
            for(sirenum__Placement__c placement4 : placement3 ) {
                
                placementmap.put(placement4.sirenum__Contact__c,placement4);
                
            }
            
            
            for(IP_BatchLine__c bline6 : batchlinelist ){
                
                
                if(bline6.IP_Status__c != 'Errored'){
                    if(placementmap.containsKey(bline6.IP_LinkField1__c) ){              bline6.IP_LinkField4__c = placementmap.get(bline6.IP_LinkField1__c).id;                 bline6.IP_Status__c = 'Linking';
                        
                    }
                }
                
            }
            system.debug('batchline after placement insert by batch'+batchlinelist);
            
        }
        
        list<sirenum__Timesheet__c> newtimesheet = new list<sirenum__Timesheet__c>(); 
        
        for(IP_BatchLine__c bline8 : batchlinelist ){
            
            if(bline8.IP_Status__c != 'Errored'){
                sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
                newTimeSheet1.sirenum__Worker__c = bline8.IP_LinkField1__c;
                
                newtimesheet.add(newTimeSheet1); 
                bline8.IP_Status__c = 'Processing';
                
            }
        } 
        
        try{
            insert newtimesheet;
        }
        
        catch(Exception DMLException ){
            for(IP_BatchLine__c bline14 : batchLineList ){
                if(bline14.IP_Status__c != 'Errored'){                    bline14.IP_Status__c = 'Errored';                    bline14.IP_ErrorReason__c = 'Due to Failed of Insertion of TimeSheet';
                }
            }
        } 
        system.debug(' newly created timesheet'+newtimesheet);
        // update toupdatebatchline;
        
        Map<id,sirenum__Timesheet__c> timesheetmap = new Map<id,sirenum__Timesheet__c>();
        set<id> conid2 = new set<id>();
        set<id> timesheetid = new set<id>();
        for(sirenum__Timesheet__c timesheet1 : newtimesheet ){
            timesheetid.add(timesheet1.id);
            conid2.add(timesheet1.sirenum__Worker__c);
            
        }
        
        list<sirenum__Timesheet_Line__c> timesheetline = new list<sirenum__Timesheet_Line__c >(); 
        
        for(IP_BatchLine__c bline9 : batchlinelist ){
            
            if(bline9.IP_Status__c != 'Errored'){
                
                for(sirenum__Timesheet__c newTimeSheet2 : newtimesheet ){
                    
                    if(bline9.IP_LinkField1__c == newTimeSheet2.sirenum__Worker__c && bline9.IP_TextField4__c !=''){
                        
                        sirenum__Timesheet_Line__c timeSheetLine1 = new sirenum__Timesheet_Line__c();
                        
                        timeSheetLine1.sirenum__Timesheet__c = newTimeSheet2.id;  
                        // timeSheetLine.sirenum__Shift__c     = 
                        timeSheetLine1.sirenum__Rate__c      =     bline9.IP_CurrencyField1__c;
                        timeSheetLine1.sirenum__Hours__c     =     bline9.IP_Number12d4Field1__c;
                        timeSheetLine1.IP_RateCodes__c      =     bline9.IP_TextField9__c;
                        timeSheetLine1.For_BatchClass__c     =     true;
                        timeSheetLine1.sirenum__Charge__c    =     bline9.IP_CurrencyField2__c;
                        
                        timesheetline.add(timeSheetLine1);
                        bline9.IP_Status__c = 'Processed';
                        //toupdatebatchline.add(bline9); 
                    }     
                }   
            }     
        }
        try{
            insert timesheetline;
        }
        catch(Exception DMLException ){
            for(IP_BatchLine__c bline15 : batchLineList ){
                if(bline15.IP_Status__c != 'Errored'){
                    bline15.IP_Status__c = 'Errored';
                    bline15.IP_ErrorReason__c = 'Due to Failed of Insertion of TimeSheetLine';
                }
                
            }
            
        }
        system.debug(' newly created timesheetline'+timesheetline);
        
        list<sirenum__Timesheet_Line__c> timesheetlst = [select id, sirenum__Timesheet__r.id,sirenum__Timesheet__r.sirenum__Worker__c from sirenum__Timesheet_Line__c  where sirenum__Timesheet__r.id in : timesheetid ];
        Map<id,sirenum__Timesheet_Line__c> timesheetlinemap = new Map<id,sirenum__Timesheet_Line__c>();
        
        for(sirenum__Timesheet_Line__c tline1 : timesheetlst){
            
            timesheetlinemap.put(tline1.sirenum__Timesheet__r.sirenum__Worker__c,tline1);     
            
        } 
        
        for(IP_BatchLine__c bline12 : batchlinelist ){
            
            if(bline12.IP_Status__c != 'Errored'){
                
                if(newtimesheet.size() > 0 && timesheetline.size() > 0 && timesheetlinemap.containsKey(bline12.IP_LinkField1__c)  ){
                    
                    bline12.IP_Status__c = 'Closed';   bline12.IP_State__c  = 'Closed';
                    bline12.IP_LinkField5__c = timesheetlinemap.get(bline12.IP_LinkField1__c).sirenum__Timesheet__r.id;
                    bline12.IP_LinkField6__c = timesheetlinemap.get(bline12.IP_LinkField1__c).id;
                    
                }
                
            }
            
        }
        
        update batchlinelist;
        
        for(Batch_header__c batch1 : batchheaderlist){
            
            for(IP_BatchLine__c bline17 : batchlinelist ){
                
                if(bline17.IP_BatchHeader__c == batch1.id){
                    
                    if(bline17.IP_Status__c =='Closed'){                      batch1.IP_Status__c = 'Complete'; 
                        
                    }
                    else if(bline17.IP_Status__c =='open'){                    batch1.IP_Status__c = 'Rejected';
                    }
                    
                    else if(bline17.IP_Status__c =='Errored'){
                        
                        batch1.IP_Status__c = 'Partialy completed';                        break;
                    }
                    
                    else {
                        
                        batch1.IP_Status__c = 'Partialy completed';
                    }
                    
                }      
            }
            
        }    
        
        update batchheaderlist;
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
}