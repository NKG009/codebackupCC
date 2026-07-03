public class UpdateRelateddateLink{
@future

public static void deleteupdatedata(Set<ID> deleterelatedsset)
{
List<sirenum__placement__c> Assignmentupdate = new List<sirenum__placement__c>();
List<IP_PayProfile__c> Profileupdate = new List<IP_PayProfile__c>();
List<Contact> Contactupdate = new List<Contact>();
    List<IP_OutboundDataTransfer__c> oblist1 = [Select id,IP_OriginRecordID__c,IP_TransferType__c from IP_OutboundDataTransfer__c where id in: deleterelatedsset];
    for(IP_OutboundDataTransfer__c ob: oblist1)
    {
        if(ob.IP_TransferType__c == 'Assignment')
        {
            sirenum__placement__c sp = new sirenum__placement__c(id=ob.IP_OriginRecordID__c,IP_TimesheetIDLink__c = '');
            Assignmentupdate.add(sp);
        }
        if(ob.IP_TransferType__c == 'Internal Worker')
        {
            IP_PayProfile__c sp = new IP_PayProfile__c(id=ob.IP_OriginRecordID__c,IP_TimesheetIDLink__c = '');
            Profileupdate.add(sp);
        }
        if(ob.IP_TransferType__c == 'External Worker')
        {
            Contact sp = new Contact(id=ob.IP_OriginRecordID__c,IP_TimesheetIDLink__c = '');
            Contactupdate.add(sp);
        }
    }
    delete oblist1;
    Update Assignmentupdate;
    Update Profileupdate;
    Update Contactupdate;
}

}