trigger t2placementTrigger on TR1__Closing_Report__c (before insert,before update,after insert,after update, before delete,after delete,after undelete) {
    
    /* Process Builder - " t2placement pass to tempest field lock "     deactivated for this trigger */
        Set<id> placementid = new Set<id>();
        list<Contact> Contactlist = new list<Contact>();
        set<ID> conIds = new set<ID>();
        set<ID> conIdblank = new set<ID>();
        map<id,Date> Maxdate= new map<id,Date>();

    if(Trigger.isAfter){ 
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete)
        {
        Set<ID> idsTrue = new Set<ID>(); 
        Set<ID> idsfalse = new Set<ID>();
        for(TR1__Closing_Report__c t2d:Trigger.new){
            if(t2d.IP_PassToTempest__c==true){
                idsTrue.add(t2d.tr1__Job__r.tr1__Hiring_Manager__c); 
                         
            }else {
                idsfalse.add(t2d.tr1__Job__r.tr1__Hiring_Manager__c);                    
            }
            if(Trigger.isInsert)
            {
                 if(t2d.IP_PassToTempest__c==true){
                 placementid.add(t2d.id);   
                 } 
                 if(t2d.IP_DateAvailableforRecontact__c != null)
                 {
                     conIds.add(t2d.Employee__c);
                 }
                
            }
            if(Trigger.isUpdate)
            {
                TR1__Closing_Report__c oldplace = Trigger.oldMap.get(t2d.Id);
                if(oldplace.IP_PassToTempest__c != t2d.IP_PassToTempest__c && t2d.IP_PassToTempest__c==true)
                {
                    placementid.add(t2d.id);  
                }
                if(oldplace.IP_DateAvailableforRecontact__c != t2d.IP_DateAvailableforRecontact__c)
                {
                    conIds.add(t2d.Employee__c);
                }
              
            }
            if(trigger.isundelete)
            {
                conIds.add(t2d.Employee__c);
            }
        }
        
        system.debug('true values1---'+idsTrue);
        system.debug('true values2---'+idsfalse);
        
        if(!idsTrue.isEmpty() )
        { system.debug('in true section----');
         List<Contact> allcon = new List<Contact>();
         List<Contact> trueContacts = [select Id,t2placement_PassToTempest__c from contact where id in :idsTrue];
         for(contact ct:trueContacts){
             ct.t2placement_PassToTempest__c=true;
             allcon.add(ct);
         }
         system.debug('allcon----'+allcon);
         try{
             update allcon;
         }catch(Exception e){              
             Trigger.new[0].addError('Candidate :'+e);
         }
         
        } 
        
        if(!idsfalse.isEmpty())
        {
            system.debug('in false section----'+idsfalse);
            List<Contact> allcon2 = new List<Contact>();
            List<Contact> trueContacts2 = [select Id,t2placement_PassToTempest__c from contact where id in :idsfalse];
            system.debug('in false query data----'+trueContacts2);
            for(contact ct2:trueContacts2){
                ct2.t2placement_PassToTempest__c=false;
                allcon2.add(ct2);
            }
            system.debug('in false before update----'+allcon2);
            try{
                update allcon2;
            }catch(exception e){
                Trigger.new[0].addError('Candidate : '+e);
            } 
        }
        if(!placementid.isEmpty())
        {
            Placementprocessupdate.senddata(placementid);
        }
        }
        if(Trigger.isDelete)
        {
            for(TR1__Closing_Report__c p: Trigger.old)
            {
                conIds.add(p.Employee__c);
            }
        }
    }
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
            {
                for(TR1__Closing_Report__c t2d:Trigger.new){
                if(t2d.IP_PassToTempest__c==true){
                 placementid.add(t2d.id);   
                 }    
                
              //  if(t2d.IP_DateAvailableforRecontact__c != null)
              //  {
                if(t2d.Substatus__c == 'Hired')
                {
                    t2d.IP_StatuschangedtoHired__c = System.today();
                    if(t2d.tr1__Start_Date__c != null)
                    {
                        t2d.IP_DateAvailableforRecontact__c = t2d.tr1__Start_Date__c+365;
                    }
                    else
                    {
                        t2d.IP_DateAvailableforRecontact__c = System.today()+365;
                    }
                }
                if(t2d.Substatus__c == 'Placed: Cancelled by Candidate' || t2d.Substatus__c == 'No Show')
                {
                    t2d.IP_DateAvailableforRecontact__c = System.today();
                }
                }
              //  }
                
            }
        if(Trigger.isUpdate)
        {
            for(TR1__Closing_Report__c t2d:Trigger.new){
                TR1__Closing_Report__c oldplace = Trigger.oldMap.get(t2d.Id);
                if(oldplace.Substatus__c != t2d.Substatus__c)
                {
                    if(t2d.Substatus__c == 'Hired')
                    {
                           t2d.IP_StatuschangedtoHired__c = System.today();
                         if(t2d.tr1__Start_Date__c != null)
                        {
                            t2d.IP_DateAvailableforRecontact__c = t2d.tr1__Start_Date__c+365;
                        }
                    else
                        {
                            t2d.IP_DateAvailableforRecontact__c = System.today()+365;
                        }
                    }
                    if(t2d.Substatus__c == 'Placed: Cancelled by Candidate' || t2d.Substatus__c == 'No Show')
                    {
                        t2d.IP_DateAvailableforRecontact__c = System.today();
                    }
                }
                if(oldplace.tr1__Start_Date__c != t2d.tr1__Start_Date__c && t2d.tr1__Start_Date__c != null)
                {
                    t2d.IP_DateAvailableforRecontact__c = t2d.tr1__Start_Date__c+365;
                }
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.IsDelete)
    {
        for(TR1__Closing_Report__c  creditrec : [SELECT Id FROM TR1__Closing_Report__c WHERE RecordType.Name = 'Perm Credits' and Id IN :Trigger.oldMap.KeySet()]){
            
            Trigger.oldMap.get(creditrec.Id).adderror('Once created Perm Credit record cannot be deleted');
            
        }
    }
    
     if(!conIDs.isEmpty())
     {
     list<AggregateResult > Outputvalues = [select Employee__c Con,Max(IP_DateAvailableforRecontact__c) Maxdata from TR1__Closing_Report__c where Employee__c IN:conIds group by Employee__c];
    for(AggregateResult Ar:Outputvalues)
    {
        Maxdate.put((id)Ar.get('Con'),(Date)Ar.get('Maxdata'));

    }
    for(Contact acc1:[select id,IP_DateAvailableforRecontact__c from Contact where ID IN:conIds])
    {
      System.debug('check date'+Maxdate.get(acc1.ID));
       acc1.IP_DateAvailableforRecontact__c = Maxdate.get(acc1.ID);
       acc1.IP_AvailableforRecontact__c = false;
       Contactlist.add(acc1);
       }
    update Contactlist;
     }
   
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        for(TR1__Closing_Report__c placemnt : Trigger.New){
            TR1__Closing_Report__c oldpl = Trigger.oldMap.get(placemnt.Id);
            if(oldpl.GUID_Placement_js__c == placemnt.GUID_Placement_js__c && oldpl.IP_LastPassedToTempest__c == placemnt.IP_LastPassedToTempest__c )
            {  
                if(placemnt.Substatus__c == 'Rebate Period' && placemnt.Name !=NULL && placemnt.tr1__Start_Date__c  != NULL && (placemnt.Fee_Pct__c !=NULL || placemnt.IP_Fixed_Fee__c != 0 )&& ( placemnt.tr1__Salary__c !=0 && placemnt.tr1__Salary__c != NULL) 
                   && placemnt.Filled_By__c != NULL && placemnt.IP_PermID__c !=NULL && placemnt.Filled_Pct__c !=0  
                   && placemnt.Candidate_First_Name__c != NULL && placemnt.Candidate_Last_Name__c != NULL && placemnt.IP_TempestDepartment__c !=NULL && placemnt.IP_ClientIDLegacy__c !=NULL &&  placemnt.Sirenum_Job_Role__c !=NULL && placemnt.IP_TempestDivision__c !=NULL && placemnt.IP_LastPassedToTempest__c ==NULL)
                {
                    placemnt.IP_PassToTempest__c =True;
                }
            }
        }
        
        
        
    }
}