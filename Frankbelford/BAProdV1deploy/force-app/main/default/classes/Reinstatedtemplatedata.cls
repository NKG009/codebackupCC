public class Reinstatedtemplatedata{

public id con_Id{get; set;}
public boolean certcount{get;set;}
public boolean portwcount{get;set;}
public boolean payecount{get;set;}
public boolean ltdcount{get;set;}
public List<ts2__Certification__c> certlist = new List<ts2__Certification__c>();
public List<ts2__Certification__c> certlistall = new List<ts2__Certification__c>();
public List<ts2__Certification__c> portwcertlist = new List<ts2__Certification__c>();
public Contact conrec;
public Contact conrec1;
public integer allpaycount{get;set;}
public Date today = System.today();
public Date future = System.today().addDays(30);

public boolean getcertcount123()
{
certlist = [Select id,ts2__Contact__c from ts2__Certification__c where ts2__Contact__c = :con_Id and RecordType.name in ('Driving Licence') ];
certlistall = [Select id,ts2__Contact__c from ts2__Certification__c where ts2__Contact__c = :con_Id and RecordType.name in ('Driving Licence') and IP_Status__c = 'Lapsed'];

if(certlist.size()>0 && certlistall.size()>0)
{
if(certlist.size()==certlistall.size())
{
    certcount = true;
}
else
{
    certcount = false;
}
}
System.debug('check dvla count'+certcount);
return certcount;
}

public integer getallpaycount123()
{
conrec1 = [Select id,IP_ActivePAYEPayProfiles__c,IP_ActivePayProfiles__c,IP_LTDPayProfileCount__c,IP_Allpayprofiles__c from Contact where id=:con_Id];
allpaycount = Integer.valueOF(conrec1.IP_Allpayprofiles__c);

System.debug('paycount'+allpaycount);

return allpaycount;
}


public boolean getltdcount123()
{

conrec = [Select id,IP_ActivePAYEPayProfiles__c,IP_Allpayprofiles__c,IP_LTDPayProfileCount__c from Contact where id=:con_Id];
if(conrec.IP_LTDPayProfileCount__c == 1)
{
  ltdcount = true;  
}
else
{
    ltdcount = false;  
}
return payecount;
}

public boolean getpayecount123()
{

conrec = [Select id,IP_ActivePAYEPayProfiles__c,IP_ActivePayProfiles__c,IP_LTDPayProfileCount__c,IP_Allpayprofiles__c from Contact where id=:con_Id];
if(conrec.IP_ActivePAYEPayProfiles__c == 1)
{
  payecount = true;  
}
else
{
    payecount = false;  
}
return payecount;
}


public boolean getportwcount123()
{

portwcertlist = [Select id,ts2__Contact__r.IP_EarliestExpiringComplianceDate__c,ts2__Contact__c from ts2__Certification__c where ts2__Contact__c = :con_Id and RecordType.name = 'Right to Work' and (VISA_Type__c in ('Work Visa','Student Visa','Resident Card (with time limit)') OR Identification_Type__c  in ('Non EEA Passport','Leave to remain (Migration status document)','Certificate of Application or Application registration card and ECS check','ECS check') ) and ((ts2__Contact__r.IP_EarliestExpiringComplianceDate__c >=:today and  ts2__Contact__r.IP_EarliestExpiringComplianceDate__c <: future) OR ts2__Contact__r.IP_EarliestExpiringComplianceDate__c <:today) ];
if(portwcertlist.size()>0)
{
    portwcount = true;
}
else
{
    portwcount = false;
}
return portwcount;
}



}