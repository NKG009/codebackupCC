trigger DVLACheckTask on ts2__Certification__c (after insert, after Update,before delete,before insert,before update) {
    if(trigger.isbefore && trigger.isdelete)
    {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        for(ts2__Certification__c checkdelete:trigger.old)
        {
            if(checkdelete.Verfied__c==true && profileName !='System Administrator' && profileName!='JS Admin tier 1')
            {
                checkdelete.addError('Verified/Lapsed certificate cannot be deleted. Please lapse the existing certificate and create a new one instead.');
            }
            
        }
        
    }
    //=====JPC-2553 Start=========
    List<ts2__Certification__c> Listforlaps = new List<ts2__Certification__c>();
    set<id> contactid = new set<id>();
    set<id> certiList = new set<id>();
    Map<string,ts2__Certification__c> maptocompair = new map<string,ts2__Certification__c>();
    set<id> contactidPORTW = new set<id>();
    set<id> certiListPORTW = new set<id>();
    
    if(Trigger.isbefore && trigger.isinsert)
    {
        for(ts2__Certification__c c: trigger.new) 
        {
            string rectypename= Schema.getGlobalDescribe().get('ts2__Certification__c').getDescribe().getRecordTypeInfosById().get(c.RecordTypeId).getName();
            if(c.Verfied__c && rectypename != 'Right to Work' ){
                contactid.add(c.ts2__Contact__c);
                certiList.add(c.id);
                string key = string.valueof(c.ts2__Contact__c)+ string.valueof(c.RecordTypeId);
                maptocompair.put(key,c);
            }
        }
    }
    if(Trigger.isbefore && trigger.isupdate)
    {
        for(ts2__Certification__c c: trigger.new) 
        {
            ts2__Certification__c oldrec = Trigger.OldMap.get(c.id);
            string rectypename= Schema.getGlobalDescribe().get('ts2__Certification__c').getDescribe().getRecordTypeInfosById().get(c.RecordTypeId).getName();
            if(oldrec.Verfied__c!= c.Verfied__c && c.Verfied__c && rectypename != 'Right to Work'){
                contactid.add(c.ts2__Contact__c);
                certiList.add(c.id);
                string key =string.valueof(c.ts2__Contact__c)+ string.valueof(c.RecordTypeId);
                maptocompair.put(key,c);
            }
        }
    }
    Listforlaps = [Select id,IP_Status__c,Verfied__c,ts2__Contact__c,RecordTypeId from ts2__Certification__c where IP_Status__c = 'Current' and ts2__Contact__c in:contactid and id not in:certiList];
    list<ts2__Certification__c> listtoupdate = new list<ts2__Certification__c>();
    for(ts2__Certification__c laps :Listforlaps)
    {
        string keytocomp = string.valueof(laps.ts2__Contact__c)+ string.valueof(laps.RecordTypeId);
        if(maptocompair.containskey(keytocomp))
        {
            laps.IP_Status__c = 'Lapsed';
            listtoupdate.add(laps);
            
        }
        
    } 
    if(listtoupdate.size() > 0)
    {
        update listtoupdate;
    }
    
    
    //========JPC-2553 End ===========
    if(trigger.isAfter && trigger.isUpdate)
    {
        // Spira - '1111'. Make Candidate non compliant in case of lapsed certificate
        // 03/02/2020 
        // Modified By - TJ
        Set<Id> conId = new Set<Id>();
        Map<Id,Id> conmap = new Map<Id,Id>();
        List<String> recordtypeName = new  List<String>();
        List<Contact> conList = new List<Contact>();
        set<id> lapsecertids = new set<id>();
        for(ts2__Certification__c cert : trigger.new){
            if(cert.IP_Status__c == 'Lapsed')
            {
                conmap.put(cert.ts2__Contact__c,cert.recordtypeId);
                conId.add(cert.ts2__Contact__c);
                lapsecertids.add(cert.id);
            }
            
        }
        system.debug('Test@@ '+conmap);
        if(conId.size()>0)
        {
            for(RecordType rt: [Select id,name from RecordType where Id in: conmap.values()]){
                recordtypeName.add(rt.name);
                
            }
            system.debug('Test@@ recordtypeName '+recordtypeName);
            list<contact> lapseconlist = [Select id,PORTW_Completed__c,(select id,IP_IdentificationValidFromDate__c,Citizenship_group__c,VISA_Expiration_Date__c,
                                                                        IP_PORTWStartDate__c,VISA_Type__c,Identification_Expiry_Date__c,Identification_Type__c 
                                                                        from ts2__Certifications__r where IP_Status__c = 'Current' and recordtypeid in:conmap.values() and
                                                                        id not in:lapsecertids and (Verify_Date__c != null or Verify_Date__c!='')  order by Verify_Date__c Asc limit 1 )
                                          from Contact where id in: conId];
            for(Contact c: lapseconlist){
                if(recordtypeName.contains('Right to Work'))
                {
                    
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        
                        c.PORTW_Completed__c = TRUE;
                        c.IP_CitizenshipGroup__c = c.ts2__Certifications__r[0].Citizenship_group__c;
                        if(c.ts2__Certifications__r[0].IP_PORTWStartDate__c == NULL)
                        {
                            c.IP_PORTWStartDate__c=c.ts2__Certifications__r[0].IP_IdentificationValidFromDate__c;
                        }
                        else
                        {
                            c.IP_PORTWStartDate__c=c.ts2__Certifications__r[0].IP_PORTWStartDate__c;
                        }
                        if(c.ts2__Certifications__r[0].VISA_Type__c == 'Resident Card (with time limit)')
                        {
                            c.Passport_Expiration_Date__c=c.ts2__Certifications__r[0].VISA_Expiration_Date__c;
                        }
                        else
                        {
                            c.Passport_Expiration_Date__c=c.ts2__Certifications__r[0].Identification_Expiry_Date__c;
                        }
                        
                        if(c.ts2__Certifications__r[0].Identification_Type__c == 'ECS check')
                        {
                            c.VISA_Expiration_Date__c=NULL;
                        }
                        else
                        {
                            c.VISA_Expiration_Date__c=c.ts2__Certifications__r[0].VISA_Expiration_Date__c;
                        }
                        System.debug('conList====>>'+conList);
                        conList.add(c);
                        
                    }
                    else{
                        c.PORTW_Completed__c = False;
                        c.Passport_Expiration_Date__c = NULL;
                        c.VISA_Expiration_Date__c = NULL;
                        c.IP_PORTWStartDate__c = NULL;
                        c.IP_CitizenshipGroup__c = '';
                        conList.add(c);
                    }
                    
                }
                if(recordtypeName.contains('Compliance Confirmed by 2nd Tier'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.IP_ComplianceConfirmedBy2ndTier__c = TRUE;
                    }
                    else
                    {
                        c.IP_ComplianceConfirmedBy2ndTier__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('Declaration'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.Declaration_Completed__c = TRUE;
                    }
                    else
                    {
                        c.Declaration_Completed__c = False; 
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('Equal Opportunities Question'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.Equal_Opportunity_Completed__c = TRUE;
                    }
                    else
                    {
                        c.Equal_Opportunity_Completed__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('Limited Company Contract'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.IP_LCC__c = TRUE;
                    }
                    else
                    {
                        c.IP_LCC__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('Medical'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.Medical_Completed__c = TRUE;
                    }
                    else
                    {
                        c.Medical_Completed__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('New Starter Declaration Form'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.New_Starter_Form__c = TRUE;
                    }
                    else
                    {
                        c.New_Starter_Form__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('Perm Disclaimer (Perm Only)'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.IP_PermDisclaimer__c = TRUE;
                    }
                    else
                    {
                        c.IP_PermDisclaimer__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('TOE'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.TOE_Completed__c = TRUE;
                    }
                    else
                    {
                        c.TOE_Completed__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('WTR'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.WTR_Completed__c = TRUE;
                    }
                    else
                    {
                        c.WTR_Completed__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('WTRT- Driving'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.WTRT_Driving_Completed__c = TRUE;
                    }
                    else
                    {
                        c.WTRT_Driving_Completed__c = False;
                    }
                    
                    conList.add(c);
                }
                if(recordtypeName.contains('Study Timetable'))
                {
                    if(c.ts2__Certifications__r.size() >0)
                    {
                        c.IP_StudyComplete__c = TRUE;
                    }
                    else
                    {
                        c.IP_StudyComplete__c = False;
                    }
                    
                    conList.add(c);
                }
            }
            system.debug('Test@@ conList '+conList);
            if(conList.size()>0){
                update conList;
                
            }
            
        }  
        
        /*  List<Task> tsklist = new List<Task>();
List<Task> inserttsklist = new List<Task>();
List<Task> updatelist = new List<Task>();
Set<id> certid = new Set<id>();
Id rectypeid = [Select Id, Name from RecordType where name = 'DVLA Licence Check' limit 1].Id;
for(integer i=0;i<trigger.new.size();i++)
{
if(trigger.new[i].RecordTypeID == rectypeid)
{
certid.add(trigger.new[i].id);  
}
}
tsklist = [Select id,Whatid from Task where Whatid in:certid];
for(integer i=0;i<trigger.new.size();i++)
{
if(trigger.isInsert && trigger.new[i].RecordTypeID == rectypeid)
{
System.debug('Inside if loop'+trigger.new[i].RecordType.Name);
Task tsk = new Task();
tsk.Subject  = 'DVLA Licence Check';
tsk.ActivityDate = trigger.new[i].Next_Check_Due__c.adddays(-14);
tsk.whoid = trigger.new[i].ts2__Contact__c;
tsk.Status = 'Not Started';
tsk.Priority = 'Normal';
tsk.Whatid = trigger.new[i].id;
inserttsklist.add(tsk);
System.debug('Task List'+inserttsklist);
}
if(trigger.isUpdate && trigger.new[i].Next_Check_Due__c != trigger.old[i].Next_Check_Due__c)
{
for(Task t:tsklist)
{
if(t.Whatid == trigger.new[i].id)
{
t.activityDate = trigger.new[i].Next_Check_Due__c.adddays(-14);
updatelist.add(t);
}
}
}
}
if(inserttsklist.size()>0)
{
insert inserttsklist;
}
if(updatelist.size()>0)
{
update updatelist;
}
*/
    }
    
}