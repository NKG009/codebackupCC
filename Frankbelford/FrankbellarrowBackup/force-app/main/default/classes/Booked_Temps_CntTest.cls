@isTest
public class Booked_Temps_CntTest{
    
    @testSetup 
    static void shiftSetup() {
        TestDataFactory.setupShifts();
    }
    
    @isTest
    static void testGetAllShifts() {
        Test.startTest();
        Contact worker = [SELECT Id, FirstName, LastName, Email, Account.Id FROM Contact WHERE RecordType.Name='Candidate' LIMIT 1];
        sirenum__Shift__c shiftOriginal = [SELECT Id, Name
                ,sirenum__Job_Type__r.Id
                ,sirenum__Team__r.Id
                ,sirenum__Site__r.Id
                ,sirenum__Site__r.sirenum__Operating_Company__r.Id
                ,sirenum__Rota__r.Id
                ,sirenum__Published__c
        FROM sirenum__Shift__c
        WHERE sirenum__Cancelled__c != True
        AND sirenum__Published__c = True
        LIMIT 1];
        sirenum__Shift__c shift = shiftOriginal.clone();
        shift.sirenum__Scheduled_Start_Time__c = Datetime.now().addDays(1);
        shift.sirenum__Scheduled_End_Time__c = Datetime.now().addDays(1).addHours(8);
        insert shift;
        System.debug('shift >>>> '+shift);

        List<Booked_Temps_Cnt.shiftwrapper> shifts = Booked_Temps_Cnt.getAllShifts(shift.sirenum__Site__r.Id);
        System.assert(shifts.size()>0, 'No shift returned');
        Test.stopTest();
    }

    @istest
    static void testGetContactCompetencies() {

        Contact worker = [SELECT Id, FirstName, LastName, Email, Account.Id FROM Contact WHERE RecordType.Name='Candidate' LIMIT 1];
        sirenum__TicketType__c objTktType = new sirenum__TicketType__c();
        objTktType.Name = 'Drivers Mate Skill';
        objTktType.sirenum__Searchable_Name__c = 'Drivers Mate Skill';
        insert objTktType;

        sirenum__Ticket__c objTkt = new sirenum__Ticket__c();
        objTkt.sirenum__TicketType__c = objTktType.id;
        objTkt.sirenum__Owner__c = worker.Id;
        insert objTkt;

        sirenum__Shift__c shift = [SELECT Id, Name
                                            ,sirenum__Job_Type__r.Id
                                            ,sirenum__Team__r.Id
                                            ,sirenum__Site__r.Id
                                            ,sirenum__Site__r.sirenum__Operating_Company__r.Id
                                            ,sirenum__Rota__r.Id
                                     FROM sirenum__Shift__c
                                    WHERE sirenum__Contact__c =: worker.Id LIMIT 1];

        sirenum__Sirenum_Condition_Membership__c conditionmem = new sirenum__Sirenum_Condition_Membership__c();
        conditionmem.sirenum__TicketType__c = objTktType.Id;
        conditionmem.sirenum__Client__c = shift.sirenum__Site__r.sirenum__Operating_Company__r.Id;
        conditionmem.sirenum__Job_Type__c = shift.sirenum__Job_Type__r.Id;
        conditionmem.sirenum__Team__c = shift.sirenum__Team__r.Id;
        conditionmem.sirenum__Site__c = shift.sirenum__Site__r.Id;
        conditionmem.sirenum__Rota__c = shift.sirenum__Rota__r.Id;
        insert conditionmem;

        Test.startTest();
        List<sirenum__Ticket__c> competencies = Booked_Temps_Cnt.getContactCompetencies(shift.Id);
        System.assert(competencies.size()>0, 'No competencies found');
        Test.stopTest();

    }
 }