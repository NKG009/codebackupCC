public class LapseCertificateFuture {

    @future
    Public static void method1(Set<ID> conid)
    {
        String a;
        String b;
        String c;
        List<ts2__Certification__c> existcertlist1 = [Select id,ts2__Contact__r.DVLA_Status_Check__c,RecordType.DeveloperName,IP_Status__c,DVLA_Check_Date__c,Next_Check_Due__c from ts2__Certification__c where ts2__Contact__c in : conid and IP_Status__c !='Lapsed' and (RecordType.DeveloperName = 'DVLA_Check') order by CreatedDate desc];
        List<ts2__Certification__c> existcertlist2 = [Select id,RecordType.DeveloperName,IP_Status__c from ts2__Certification__c where ts2__Contact__c in : conid and IP_Status__c !='Lapsed' and (RecordType.DeveloperName='Driving_Licence')order by CreatedDate desc];
        List<sirenum__TicketType__c> comptypelist = [Select id from sirenum__TicketType__c where name ='DVLA Licence Check'];
     	
        List<sirenum__Ticket__c> complist = [Select id,sirenum__Valid_from__c,sirenum__Valid_until__c from sirenum__Ticket__c where sirenum__Owner__c in : conid and sirenum__TicketType__c in : comptypelist];
        List<Contact> con = new List<Contact>();
        if(existcertlist1.size()>1)
        {
           existcertlist1[1].IP_Status__c='Lapsed';             update existcertlist1;
           existcertlist1[1].ts2__Contact__r.DVLA_Status_Check__c = 'Lapse';  
           con.add(existcertlist1[1].ts2__Contact__r);
           
            if(con.size()>0){
                update con;}
        }
    else if(existcertlist2.size()>1)
        {
            existcertlist2[1].IP_Status__c='Lapsed';             update existcertlist2;
        }
        If(complist.size()>0)
        {
            complist[0].sirenum__Valid_from__c =  Date.valueof(existcertlist1[0].DVLA_Check_Date__c);            complist[0].sirenum__Valid_until__c = existcertlist1[0].Next_Check_Due__c;
        //    update complist;
        }
        
    }
    
}