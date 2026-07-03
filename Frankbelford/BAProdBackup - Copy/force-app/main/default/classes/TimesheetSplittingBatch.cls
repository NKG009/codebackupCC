global class TimesheetSplittingBatch extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{
   
     CreatedDateSPliting__c splitdate= CreatedDateSPliting__c.getInstance('SplittingData');   
     DateTime dt = splitdate.SplittingCreatedDate__c;
     
    global Database.QueryLocator start(Database.BatchableContext BC){

 String query ='Select id,IP_ErrorDetail__c,sirenum__Lines__c,IP_SplitTimesheetCount__c,sirenum__site__c,IP_Error__c from sirenum__Timesheet__c where IP_Error__c = FALSE AND sirenum__Site__r.sirenum__Operating_Company__r.IP_InvoicingMethod__c= \'Standard\' AND CreatedDate > :dt and IP_CheckSplitCount__c = True and IP_DuplicateCheckPassOK__c = TRUE and IP_FlaggingCheck__c = TRUE';
    return Database.getQueryLocator(query);
}
    
     global void execute(Database.BatchableContext BC,List<sirenum__Timesheet__c> timelist){
          Database.SaveResult[] srList;
          Map<Id,String> Errormsg = new Map<Id,String>();
         List<sirenum__Timesheet__c> batchtime = new  List<sirenum__Timesheet__c>();
          List<sirenum__Timesheet_Line__c> updatetimeline = new  List<sirenum__Timesheet_Line__c>();
        Map<Id,Id> newmap1 = new Map<Id,Id>();
        String setletter = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
         string lastletter='';
         Integer counter = 0;
       Set<Id> timeId = new Set<Id>();
         System.debug('@@ timelist '+timelist);
         for(sirenum__Timesheet__c tm: timelist)
         {
             if(tm.sirenum__Lines__c != tm.IP_SplitTimesheetCount__c)
             {
               batchtime.add(tm);  
             }
         }
         if(batchtime.size()>0)
         {
           
             List<sirenum__Timesheet_Line__c> stl = [Select id,IP_SplitTSSet__c,IP_TimesheetSplitCheck__c,sirenum__Timesheet__c,sirenum__Timesheet__r.IP_ErrorDetail__c,sirenum__Timesheet__r.IP_Error__c,sirenum__Charge__c,sirenum__Rate__c,IP_TempestRateCode__c from sirenum__Timesheet_Line__c where sirenum__Timesheet__c in : batchtime  order by CreatedDate Asc]; 
             System.debug('TImeLine list '+stl);
             List<AggregateResult> obj = [Select Count(id) from sirenum__Timesheet_Line__c where sirenum__Timesheet__c in:batchtime group by IP_TempestRateCode__c,Ratebatch__c,ChargeBatch__c]; 
  System.debug('TImeLine listAggregateResult '+obj);

           if(obj.size()>5)
           {
               for(Integer i = 0;i<stl.size();i++)
              {
                  timeId.add(stl[i].id);
                  for(Integer j = 0; j<stl.size();j++)
                  {
                        if(!newmap1.ContainsKey(stl[j].id) &&  stl[i].IP_TempestRateCode__c == stl[j].IP_TempestRateCode__c && stl[i].sirenum__Charge__c == stl[j].sirenum__Charge__c && stl[i].sirenum__Rate__c == stl[j].sirenum__Rate__c && stl[i].id != stl[j].id)
                        {
                            system.debug('I in IF '+i +' '+stl[i].id);
                            system.debug('j in IF '+j +' '+stl[j].id);
                            newmap1.put(stl[i].id,stl[j].id);
                            // newmap1.put(stl[j].id, stl[j].sirenum__Timesheet__c);
                        }
                      
                  }
                  
              }
                System.debug('@@ '+newmap1);  
               Set<Id> svalues = new Set<Id>();
               Set<Id> skey = new Set<Id>();
               if(newmap1.size()>0)
               {
                  // Integer imap = 1;
                 for(Id s: newmap1.keySet())
                 {
                     
                     svalues.add(newmap1.get(s));
                     skey.add(s);
                 }
                 /*  List<Id> mapvalue = newmap1.values();
                    system.debug('@@ mapvalue '+mapvalue);
                   for(Integer i = 0;i<mapvalue.size();i++)
                   {
                       
                   } */
                //    system.debug('@@ set '+svalues);
                    system.debug('timeId before removal '+timeId);
                   system.debug('svalues '+svalues);
                   system.debug('skey '+skey);
                   for(Id s: svalues)
                   {
                       if(timeId.Contains(s))
                       {
                          timeId.remove(s); 
                       }
                   }
                   for(Id s: skey)
                   {
                      if(timeId.Contains(s))
                       {
                          timeId.remove(s); 
                       } 
                   }
                   system.debug('timeId after removal '+timeId);
               }
               
                  if(svalues.size()>5)
                  {
                      
                      Integer listsize = 0;
                        for(Integer i = 0;i<stl.size();i++)
                         {      
                            if(  (svalues.contains(stl[i].id) || skey.contains(stl[i].id)))
                            {
                                System.debug('IN IF for more then 5 svalues');
                                for(Integer j = 0;j<stl.size();j++)
                                {  string A;
                                    if( (stl[i].IP_SplitTSSet__c==null || stl[j].IP_SplitTSSet__c==null) &&  stl[i].IP_TempestRateCode__c == stl[j].IP_TempestRateCode__c && stl[i].sirenum__Charge__c == stl[j].sirenum__Charge__c && stl[i].sirenum__Rate__c == stl[j].sirenum__Rate__c && stl[i].id != stl[j].id)
                                    {
                                          System.debug('IN IF compares ');
                                  listsize ++;
                                      if(listsize<svalues.size())
                                    {
                                  A =setletter.substring(counter,counter+1);
                                    
                                    }
                                    else
                                    {
                                      A =setletter.substring(counter+1,counter+2);
                                        
                                    }
                                           stl[i].IP_SplitTSSet__c = A;
                                           stl[i].IP_TimesheetSplitCheck__c =true;
                                           stl[j].IP_SplitTSSet__c = A;
                                           stl[j].IP_TimesheetSplitCheck__c =true;
                                        lastletter = A;
                                    }
                                }
                            

                             //   A =setletter.substring(counter+1,counter+2);
                             
                           
                                
                            }
                          
                        }
                       if(timeId.size()>0)
                        {
                              system.debug('Last letter '+lastletter);
                                    Integer index = setletter.indexOf(lastletter);
                            for(Integer i = 0;i<stl.size();i++)
                             {
                                 if(timeId.contains(stl[i].id) )
                                {
                                    System.debug('IN TimeId ');
                                 string A ;
                                    if(svalues.size()<10)
                                    {
                                        System.debug('IN TimeId ' + svalues.size());
                                       A =  setletter.substring(index,index+1);
                                    }
                                    else
                                    {
                                     A =   setletter.substring(index+1,index+2);
                                        index++;
                                    }
                                    stl[i].IP_SplitTSSet__c = A;
                                    stl[i].IP_TimesheetSplitCheck__c= true;
                                 //   index ++;
                                }    
                             }
                        }
                      
                  }
                  else
                  {
                      if(svalues.size()>0 && svalues.size()<=5 )
                      {
                          
                           for(Integer i = 0;i<stl.size();i++)
                         {      
                            if(svalues.contains(stl[i].id) || skey.contains(stl[i].id))
                            {
                             string A =setletter.substring(counter,counter+1);
                                stl[i].IP_SplitTSSet__c = A;
                                stl[i].IP_TimesheetSplitCheck__c =true;
                            }
                        }
                        if(timeId.size()>0  )
                        {
                            Integer size = 0;
                            Integer totalgroup = timeId.size() + svalues.size(); 
                            Integer listsize = svalues.size();
                            for(Integer i = 0;i<stl.size();i++)
                             {
                                 if(timeId.contains(stl[i].id) )
                                {
                                   string A;
                                    if(listsize<5)
                                    {
                                  A =setletter.substring(0,1);
                                        listsize++;
                                    }
                                    else if (totalgroup <= 10)
                                    {
                                      A =setletter.substring(counter+1,counter+2);
                                       totalgroup++;
                                    }
                                    else if( totalgroup>10)
                                    {
                                        if(size<5)
                                        {
                                         A =setletter.substring(counter+1,counter+2);    size++;
                                        }
                                        else
                                        {
                                         A =setletter.substring(counter+2,counter+3);
                                        }
                                    }
                                    stl[i].IP_SplitTSSet__c = A;
                                    stl[i].IP_TimesheetSplitCheck__c= true;
                                    
                                }    
                             }
                        }
                        
                  }
                 else
                 {
                      if(timeId.size()>0)
                        {
                             Integer size = 0;
                             Integer totalgroup = timeId.size();
                              Integer listsize = timeId.size();
                            for(Integer i = 0;i<stl.size();i++)
                             {
                                 if(timeId.contains(stl[i].id) )
                                {
                                    String A;
                                     if(listsize<=5)
                                    {
                                        A =setletter.substring(0,1);
                                        listsize++;
                                    }
                                    else if (totalgroup <= 10)
                                    {
                                        System.debug('totalgroup '+totalgroup);
                                      if(size<5)
                                        {
                                         A =setletter.substring(0,1);    
                                        }
                                        else 
                                        {
                                         A =setletter.substring(counter+1,counter+2);
                                        }
                                      size++;
                                    }
                                     else if( totalgroup>10)
                                    {
                                        if(size<5)
                                        {
                                         A =setletter.substring(counter,counter+1);    
                                        }
                                        else if (size>=5 && size < 10)
                                        {
                                         A =setletter.substring(counter+1,counter+2);
                                        }
                                        else if (size>=10)
                                        {
                                             A =setletter.substring(counter+2,counter+3);
                                        }
                                        size++;
                                    }
                                    stl[i].IP_SplitTSSet__c = A;  
                                    stl[i].IP_TimesheetSplitCheck__c= true;  
                                    
                                    // totalgroup++;
                                }    
                             }
                        }
                 }
              }
               
           }
             else
             {
                     for(Integer i = 0;i<stl.size();i++)
                             {
                                stl[i].IP_TimesheetSplitCheck__c= true;  
                             } 
             }
             system.debug('stl update '+ stl);
             try{ 
             update stl;  
             }
             catch(Exception e)
             {
                if(e.getMessage().Contains('unable to obtain exclusive access'))
                 {
                 batchtime[0].IP_ErrorDetail__c = 'Failed to set Splitting '+e;                 update batchtime;
                 }
                 else
                 {
                 batchtime[0].IP_Error__c = True;  batchtime[0].IP_ErrorDetail__c = 'Failed to set Splitting '+e;      update batchtime;
                 } 
             }
             
         
         }
              
         
     }
    
    
     global void finish(Database.BatchableContext BC){
     super.finishBatch(BC);
     }
    
}