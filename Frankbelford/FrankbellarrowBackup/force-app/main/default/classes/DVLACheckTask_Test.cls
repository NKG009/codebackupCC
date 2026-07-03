@isTest
public class DVLACheckTask_Test {
    public static testmethod void updatecertificate()
    {
        
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        User user = new User();
        DateTime dt2 = DateTime.newInstance(2018, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data198';
        user.FirstName='TestUser5464';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = Prof.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        // user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1062';
        // user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        system.runAs(user){
            id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();
            id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Right to Work').getRecordTypeId();
            id certId3 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Compliance Confirmed by 2nd Tier').getRecordTypeId();
            id certId4 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Declaration').getRecordTypeId();
            id certId5 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Equal Opportunities Question').getRecordTypeId();
            id certId6 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
            id certId7 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('New Starter Declaration Form').getRecordTypeId();
            id certId8= Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Perm Disclaimer (Perm Only)').getRecordTypeId();
            id certId9 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
            id certId10 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('WTR').getRecordTypeId();
            id certId11 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('WTRT- Driving').getRecordTypeId();
            id certId12 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Study Timetable').getRecordTypeId();
            
            
            Contact cand = TestDataFactory.createCandidate(account1.id, 1)[0];
            insert cand;
            
            list<ts2__Certification__c > certilist = new list<ts2__Certification__c>();
            ts2__Certification__c cert1 = new ts2__Certification__c();
            cert1.ts2__Contact__c = cand.id;
            cert1.RecordTypeId = certId1;
            cert1.Verfied__c = true;
            certilist.add(cert1);
            
            ts2__Certification__c cert2 = new ts2__Certification__c();
            cert2.ts2__Contact__c = cand.id;
            cert2.RecordTypeId = certId2;
            cert2.Citizenship_group__c='Citizen of the UK';
            cert2.Identification_for_a_UK_citizen__c='UK Passport';
            cert2.IP_UK_ID_Expiry_Date_c__c=date.newInstance(2019,06,05);
            cert2.Verfied__c = true;
            cert2.IP_Original_Seen_on__c = true;
            certilist.add(cert2);
            
            
            ts2__Certification__c cert21 = new ts2__Certification__c();
            cert21.ts2__Contact__c = cand.id;
            cert21.RecordTypeId = certId2;
            cert21.Identification_Type__c='Non EEA Passport';
            cert21.Citizenship_group__c='Citizen of a EU Country that is Not the UK';
            cert21.IP_IdentificationValidFromDate__c=date.newInstance(2019,06,05);
            cert21.Identification_Expiry_Date__c =date.newInstance(2021,06,05);
            cert21.VISA_Type__c='Work Visa';
            cert21.IP_PORTWApprovedDate__c=date.newInstance(2019,06,05);
            cert21.IP_PORTWStartDate__c=date.newInstance(2019,06,05);
            cert21.VISA_Expiration_Date__c =date.newInstance(2021,06,05);
            cert21.Verfied__c = true;
            cert21.IP_Original_Seen_on__c = true;
            certilist.add(cert21);
            ts2__Certification__c cert3 = new ts2__Certification__c();
            cert3.ts2__Contact__c = cand.id;
            cert3.RecordTypeId = certId3;
            cert3.Verfied__c = true;
            certilist.add(cert3);
            ts2__Certification__c cert4 = new ts2__Certification__c();
            cert4.ts2__Contact__c = cand.id;
            cert4.RecordTypeId = certId4;
            cert4.Verfied__c = true;
            certilist.add(cert4);
            ts2__Certification__c cert5 = new ts2__Certification__c();
            cert5.ts2__Contact__c = cand.id;
            cert5.RecordTypeId = certId5;
            cert5.Verfied__c = true;
            certilist.add(cert5);
            ts2__Certification__c cert6 = new ts2__Certification__c();
            cert6.ts2__Contact__c = cand.id;
            cert6.RecordTypeId = certId6;
            cert6.Verfied__c = true;
            certilist.add(cert6);
            ts2__Certification__c cert7 = new ts2__Certification__c();
            cert7.ts2__Contact__c = cand.id;
            cert7.RecordTypeId = certId7;
            cert7.Verfied__c = true;
            certilist.add(cert7);
            ts2__Certification__c cert8 = new ts2__Certification__c();
            cert8.ts2__Contact__c = cand.id;
            cert8.RecordTypeId = certId8;
            cert8.Verfied__c = true;
            certilist.add(cert8);
            ts2__Certification__c cert9 = new ts2__Certification__c();
            cert9.ts2__Contact__c = cand.id;
            cert9.RecordTypeId = certId9;
            cert9.Verfied__c = true;
            cert9.TOE_Agreement__c = true;
            certilist.add(cert9);
            ts2__Certification__c cert10 = new ts2__Certification__c();
            cert10.ts2__Contact__c = cand.id;
            cert10.RecordTypeId = certId10;
            cert10.Verfied__c = true;
            certilist.add(cert10);
            ts2__Certification__c cert11 = new ts2__Certification__c();
            cert11.ts2__Contact__c = cand.id;
            cert11.RecordTypeId = certId11;
            cert11.Verfied__c = true;
            certilist.add(cert11);
            ts2__Certification__c cert12 = new ts2__Certification__c();
            cert12.ts2__Contact__c = cand.id;
            cert12.RecordTypeId = certId12;
            cert12.Verfied__c = true;
            certilist.add(cert12);
            
            insert certilist;
            
            ts2__Certification__c cert = new ts2__Certification__c();
            cert.ts2__Contact__c = cand.id;
            cert.RecordTypeId = certId1;
            
            insert cert;
            cert.Verfied__c = true;
            update cert;
            cert.IP_Status__c ='Lapsed';
            update cert;
            
            certilist[1].IP_Status__c ='Lapsed';
            update certilist[1];
            try{
                delete cert;
            }
            catch(exception e)
            {}
            
            
        }
        
    }
    public static testmethod void updatecertificate2()
    {
        
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        User user = new User();
        DateTime dt2 = DateTime.newInstance(2018, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data198';
        user.FirstName='TestUser5464';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = Prof.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        // user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1062';
        // user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        system.runAs(user){
            Contact cand = TestDataFactory.createCandidate(account1.id, 1)[0];
            insert cand;
            id certId3 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Compliance Confirmed by 2nd Tier').getRecordTypeId();
            id certId4 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Declaration').getRecordTypeId();
            id certId5 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Equal Opportunities Question').getRecordTypeId();            
            list<ts2__Certification__c > certilist = new list<ts2__Certification__c>();
            ts2__Certification__c cert3 = new ts2__Certification__c();
            cert3.ts2__Contact__c = cand.id;
            cert3.RecordTypeId = certId3;
            cert3.Verfied__c = true;
            certilist.add(cert3);
            ts2__Certification__c cert23 = new ts2__Certification__c();
            cert23.ts2__Contact__c = cand.id;
            cert23.RecordTypeId = certId3;
            cert23.Verfied__c = true;
            certilist.add(cert23);
            ts2__Certification__c cert24 = new ts2__Certification__c();
            cert24.ts2__Contact__c = cand.id;
            cert24.RecordTypeId = certId4;
            cert24.Verfied__c = true;
            certilist.add(cert24);
            ts2__Certification__c cert4 = new ts2__Certification__c();
            cert4.ts2__Contact__c = cand.id;
            cert4.RecordTypeId = certId4;
            cert4.Verfied__c = true;
            certilist.add(cert4);
            
            ts2__Certification__c cert5 = new ts2__Certification__c();
            cert5.ts2__Contact__c = cand.id;
            cert5.RecordTypeId = certId5;
            cert5.Verfied__c = true;
            certilist.add(cert5);
            ts2__Certification__c cert25 = new ts2__Certification__c();
            cert25.ts2__Contact__c = cand.id;
            cert25.RecordTypeId = certId5;
            cert25.Verfied__c = true;
            certilist.add(cert25);
            insert certilist;
            certilist[1].IP_Status__c ='Lapsed';
            update certilist[1];
            certilist[3].IP_Status__c ='Lapsed';
            update certilist[3];
            certilist[5].IP_Status__c ='Lapsed';
            update certilist[5];
            
        }
    }
    public static testmethod void updatecertificate3()
    {
        
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        User user = new User();
        DateTime dt2 = DateTime.newInstance(2018, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data198';
        user.FirstName='TestUser5464';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = Prof.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        // user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1062';
        // user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        system.runAs(user){
            Contact cand = TestDataFactory.createCandidate(account1.id, 1)[0];
            insert cand;
            id certId3 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('WTR').getRecordTypeId();
            id certId4 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('WTRT- Driving').getRecordTypeId();
            id certId5 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Study Timetable').getRecordTypeId();
            list<ts2__Certification__c > certilist = new list<ts2__Certification__c>();
            ts2__Certification__c cert3 = new ts2__Certification__c();
            cert3.ts2__Contact__c = cand.id;
            cert3.RecordTypeId = certId3;
            cert3.Verfied__c = true;
            certilist.add(cert3);
            ts2__Certification__c cert23 = new ts2__Certification__c();
            cert23.ts2__Contact__c = cand.id;
            cert23.RecordTypeId = certId3;
            cert23.Verfied__c = true;
            certilist.add(cert23);
            ts2__Certification__c cert24 = new ts2__Certification__c();
            cert24.ts2__Contact__c = cand.id;
            cert24.RecordTypeId = certId4;
            cert24.Verfied__c = true;
            certilist.add(cert24);
            ts2__Certification__c cert4 = new ts2__Certification__c();
            cert4.ts2__Contact__c = cand.id;
            cert4.RecordTypeId = certId4;
            cert4.Verfied__c = true;
            certilist.add(cert4);
            
            ts2__Certification__c cert5 = new ts2__Certification__c();
            cert5.ts2__Contact__c = cand.id;
            cert5.RecordTypeId = certId5;
            cert5.Verfied__c = true;
            certilist.add(cert5);
            ts2__Certification__c cert25 = new ts2__Certification__c();
            cert25.ts2__Contact__c = cand.id;
            cert25.RecordTypeId = certId5;
            cert25.Verfied__c = true;
            certilist.add(cert25);
            insert certilist;
            certilist[1].IP_Status__c ='Lapsed';
            update certilist[1];
            certilist[3].IP_Status__c ='Lapsed';
            update certilist[3];
            certilist[5].IP_Status__c ='Lapsed';
            update certilist[5];
            
        }
    }
    public static testmethod void updatecertificate4()
    {
        
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        User user = new User();
        DateTime dt2 = DateTime.newInstance(2018, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data198';
        user.FirstName='TestUser5464';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = Prof.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        // user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1062';
        // user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        system.runAs(user){
            Contact cand = TestDataFactory.createCandidate(account1.id, 1)[0];
            insert cand;
            id certId3 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('New Starter Declaration Form').getRecordTypeId();
            id certId4= Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Perm Disclaimer (Perm Only)').getRecordTypeId();
            id certId5 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
            list<ts2__Certification__c > certilist = new list<ts2__Certification__c>();
            ts2__Certification__c cert3 = new ts2__Certification__c();
            cert3.ts2__Contact__c = cand.id;
            cert3.RecordTypeId = certId3;
            cert3.Verfied__c = true;
            certilist.add(cert3);
            ts2__Certification__c cert23 = new ts2__Certification__c();
            cert23.ts2__Contact__c = cand.id;
            cert23.RecordTypeId = certId3;
            cert23.Verfied__c = true;
            certilist.add(cert23);
            ts2__Certification__c cert24 = new ts2__Certification__c();
            cert24.ts2__Contact__c = cand.id;
            cert24.RecordTypeId = certId4;
            cert24.Verfied__c = true;
            certilist.add(cert24);
            ts2__Certification__c cert4 = new ts2__Certification__c();
            cert4.ts2__Contact__c = cand.id;
            cert4.RecordTypeId = certId4;
            cert4.Verfied__c = true;
            certilist.add(cert4);
            
            ts2__Certification__c cert5 = new ts2__Certification__c();
            cert5.ts2__Contact__c = cand.id;
            cert5.RecordTypeId = certId5;
            cert5.Verfied__c = true;
            cert5.TOE_Agreement__c = true;
            certilist.add(cert5);
            ts2__Certification__c cert25 = new ts2__Certification__c();
            cert25.ts2__Contact__c = cand.id;
            cert25.RecordTypeId = certId5;
            cert25.Verfied__c = true;
            cert25.TOE_Agreement__c = true;
            certilist.add(cert25);
            insert certilist;
            certilist[1].IP_Status__c ='Lapsed';
            update certilist[1];
            certilist[3].IP_Status__c ='Lapsed';
            update certilist[3];
            certilist[5].IP_Status__c ='Lapsed';
            update certilist[5];
            
        }
    }
}