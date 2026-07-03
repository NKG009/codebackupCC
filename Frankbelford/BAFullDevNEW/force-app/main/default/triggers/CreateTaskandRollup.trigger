trigger CreateTaskandRollup on IP_InvoiceQuery__c (before insert,before update,after insert,after update,after delete) {

Map<String,String> queuemap = new Map<String,String>();
Map<String,String> existingTaskMap = new Map<String,String>();
List<Task> Tasklistinsert = new List<Task>();
List<Task> Tasklistupdate = new List<Task>();
List<Group> grplist = [Select id,Name,Related.Name,Type from Group where type = 'Queue'];
Set<id> queryvaluecount  = new Set<id>();
Set<id> accset = new Set<id>();
Map<id,String> accmap = new Map<id,String>();
for(Group g:grplist)
{
        String str = g.name.SubStringbefore('-');
        queuemap.put(str,g.id);
}

   id recID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Invoice Query').getRecordTypeId();
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            List<Task> existingTask = [Select id,WhatID from Task where IP_TaskType__c = 'Invoice Query' and Status != 'Completed'and Whatid in: Trigger.New]; 
            for(Task t: existingTask)
                {
                    existingTaskMap.put(t.WhatID,t.id);
                }
            for(IP_InvoiceQuery__c c: Trigger.New)
            {
                accset.add(c.IP_Account__c);
            }
           List<Account> acclist = [Select id,name from Account where id in: accset];
           for(account a: acclist)
           {
               accmap.put(a.id,a.Name);
           }
            for(IP_InvoiceQuery__c c: Trigger.New)
            {
                if(Trigger.isInsert)
                {
                    queryvaluecount.add(c.IP_Account__c);
                    if(queuemap.get(c.IP_BranchCode__c) != null && accmap.get(c.IP_Account__c) != null)
                    {
                    Task t = new Task();
                    t.recordtypeid = recID;
                    t.Subject = accmap.get(c.IP_Account__c) +' - Invoice Query';
                    t.WhatID = c.id;
                    t.IP_BranchCostCode__c = c.IP_BranchCode__c;
                    t.IP_BranchName__c = c.IP_BranchName__c;
                    t.IP_TaskType__c = 'Invoice Query';
                        if(!test.isrunningTest())                        
                        { 
                            t.OwnerId = queuemap.get(c.IP_BranchCode__c);
                        }
                        else
                        {
                            t.OwnerId = UserInfo.getUserid();
                        }
                    t.ActivityDate = System.today().addDays(1);
                    t.Account__c = c.IP_Account__c;
                    t.IP_Accountumber__c = c.IP_AccountNumber__c;
                    t.IP_Invoice_Date__c = c.IP_Invoice_Date__c;
                    t.IP_InvoiceNumber__c = c.IP_InvoiceNumber__c;
                    if(c.IP_QueryDescription__c.length()>255)                    
                    {                   
                     t.IP_QueryDescription__c = (c.IP_QueryDescription__c).substring(0,255);
                    }
                    else
                    {
                    t.IP_QueryDescription__c = c.IP_QueryDescription__c;
                    }
                    
                    t.IP_QueryValue__c = c.IP_QueryValue__c;
                    t.IP_Status__c = c.IP_Status__c;
                    t.IP_AgeofQuery__c = c.IP_AgeofQuery__c;
                    Tasklistinsert.add(t);
                    }
                }
                if(Trigger.isUpdate)
                {
                    queryvaluecount.add(c.IP_Account__c);
                     IP_InvoiceQuery__c  oldcon = Trigger.newMap.get(c.Id);
                 //   if(!existingTaskMap.keySet().contains(c.id) && (oldcon.IP_Actioned__c == c.IP_Actioned__c) && c.IP_Actioned__c == false )
                 //   {
                        if(queuemap.get(c.IP_BranchCode__c) != null && accmap.get(c.IP_Account__c) != null && (oldcon.IP_Actioned__c == c.IP_Actioned__c) && c.IP_Actioned__c == false)
                        {
                            if(!existingTaskMap.keySet().contains(c.id))
                            {
                                Task t = new Task(); 
                                t.Subject = accmap.get(c.IP_Account__c)+' - Invoice Query'; 
                                t.WhatID = c.id;          
                                t.recordtypeid = recID;   
                                t.IP_TaskType__c = 'Invoice Query'; 
                                t.IP_BranchCostCode__c = c.IP_BranchCode__c;
                                t.IP_BranchName__c = c.IP_BranchName__c;
                                if(!test.isrunningTest())
                                {
                                    t.OwnerId = queuemap.get(c.IP_BranchCode__c);
                                }
                                else
                                {
                                    t.OwnerId = UserInfo.getUserid();
                                }
                                t.ActivityDate = System.today().addDays(1); 
                                t.Account__c = c.IP_Account__c; 
                                t.IP_Accountumber__c = c.IP_AccountNumber__c;
                                t.IP_Invoice_Date__c = c.IP_Invoice_Date__c;    
                                t.IP_InvoiceNumber__c = c.IP_InvoiceNumber__c;     
                                if(c.IP_QueryDescription__c.length()>255)
                                    {
                                    t.IP_QueryDescription__c = (c.IP_QueryDescription__c).substring(0,255);
                                    }
                                    else
                                    {
                                    t.IP_QueryDescription__c = c.IP_QueryDescription__c;
                                    }
                                t.IP_QueryValue__c = c.IP_QueryValue__c; 
                                t.IP_Status__c = c.IP_Status__c;   
                                t.IP_AgeofQuery__c = c.IP_AgeofQuery__c; 
                                Tasklistinsert.add(t);
                            }
                            else
                            {
                                Task t1 = new Task(); 
                                t1.id = existingTaskMap.get(c.id);
                                t1.Subject = accmap.get(c.IP_Account__c)+' - Invoice Query'; 
                                t1.WhatID = c.id;          
                                t1.recordtypeid = recID;   
                                t1.IP_TaskType__c = 'Invoice Query'; 
                                t1.IP_BranchCostCode__c = c.IP_BranchCode__c;
                                t1.IP_BranchName__c = c.IP_BranchName__c;
                                if(!test.isrunningTest())
                                {
                                    t1.OwnerId = queuemap.get(c.IP_BranchCode__c);
                                }
                                else
                                {
                                    t1.OwnerId = UserInfo.getUserid();
                                }
                                t1.ActivityDate = System.today().addDays(1); 
                                t1.Account__c = c.IP_Account__c; 
                                t1.IP_Accountumber__c = c.IP_AccountNumber__c;
                                t1.IP_Invoice_Date__c = c.IP_Invoice_Date__c;    
                                t1.IP_InvoiceNumber__c = c.IP_InvoiceNumber__c;     
                                if(c.IP_QueryDescription__c.length()>255)
                                    {
                                    t1.IP_QueryDescription__c = (c.IP_QueryDescription__c).substring(0,255);
                                    }
                                    else
                                    {
                                    t1.IP_QueryDescription__c = c.IP_QueryDescription__c;
                                    }
                                t1.IP_QueryValue__c = c.IP_QueryValue__c; 
                                t1.IP_Status__c = c.IP_Status__c;   
                                t1.IP_AgeofQuery__c = c.IP_AgeofQuery__c; 
                                Tasklistupdate.add(t1);
                            }
                        }
                   // }
                }
            }
        }
        if(Trigger.isDelete)       
        { 
        for(IP_InvoiceQuery__c c1: Trigger.Old) 
            queryvaluecount.add(c1.IP_Account__c);
        }
    }
    
    if(!queryvaluecount.isEmpty())
    {
        Updatequeryvalue.calculatevalue(queryvaluecount);
    }       
    if(Tasklistinsert.size()>0)
    {
        database.insert(Tasklistinsert,false);
    }
    if(Tasklistupdate.size()>0)
    {
        database.update(Tasklistupdate,false);
    }
    
}