@isTest
public class ServiceAppointmentTriggerTest{
    @testSetup
    static void setup(){
        try{
            Manage_Triggers__c cs = new Manage_Triggers__c();
			cs.Name = 'AccountTrigger';
			cs.isActive__c = true;
			insert cs;
            Manage_Triggers__c cs1 = new Manage_Triggers__c();
			cs1.Name = 'ServiceAppointmentTrigger';
			cs1.isActive__c = true;
			insert cs1;
            // Create common test accounts
            List<Account> testAccts = new List<Account>();
            for (Integer i = 0; i < 2; i++){
                testAccts.add(new Account(Name = 'Test SA Account' + i));
            }
            insert testAccts;

            ServiceAppointment sa = new ServiceAppointment();
            sa.ParentRecordId = testAccts[0].ID;
            sa.EarliestStartTime = system.Today() + 10;
            sa.SchedStartTime = Datetime.newInstanceGmt(2040, 09, 09, 11, 30, 00);
            sa.DueDate = system.Today() + 20;
            sa.Comms__c = 'Key';
            //sa.Description = 'Trial Service Appointment';
            insert sa;
        } catch (Exception e){
            system.debug('Error: ' + e);
            // system.assert(e.getMessage().contains('Test Class Error'), e.getMessage());
        }
    }

    @isTest
    public static void testInsertCalculateBookingCount(){
        Test.startTest();
        try{
            List<Account> acctLst = [SELECT ID
                                     FROM Account];
            List<ServiceAppointment> saLst = [SELECT ID, Booking_Attempts_Count__c
                                              FROM ServiceAppointment];
            List<ServiceAppointmentHistory> sahLst = [SELECT ID
                                                      FROM ServiceAppointmentHistory];
            ServiceAppointment sa = new ServiceAppointment();
            sa.ParentRecordId = acctLst[0].ID;
            sa.EarliestStartTime = system.Today() + 10;
            sa.DueDate = system.Today() + 20;
            //sa.Booking_Attempts_Count__c = 12;
            sa.Comms__c = 'Tentative';
            //sa.Description = 'Test Case Description';
            insert sa;
            sa.Comms__c = 'Tentative';
            //sa.Booking_Attempts_Count__c = null;
            update sa;
        } catch (Exception e){
            system.debug('Error: ' + e);
            // system.assert(e.getMessage().contains('Test Class Error'), e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void testUpdateCalculateBookingCount(){
        try{
            List<Account> acctLst = [SELECT ID
                                     FROM Account];
            ServiceAppointment sa = new ServiceAppointment();
            sa.ParentRecordId = acctLst[0].ID;
            sa.EarliestStartTime = system.Today() + 10;
            sa.DueDate = system.Today() + 20;
            sa.Comms__c = 'Tentative';
            //sa.Booking_Attempts_Count__c = 12;
            //sa.Description = 'Test Case Description';
            insert sa;
            sa.Comms__c = 'Tentative';
            //sa.Booking_Attempts_Count__c = null;
            update sa;
        } catch (Exception e){
            // system.assert(e.getMessage().contains('Test Class Error'), e.getMessage());
        }
    }

    @isTest
    public static void testForCatchBlock(){
        //This TestMethod covers Catch block
        try{
            List<Account> acctLst = [SELECT ID
                                     FROM Account];
            List<ServiceAppointment> saLst = [SELECT ID
                                              FROM ServiceAppointment];
            List<ServiceAppointmentHistory> sahLst = [SELECT ID
                                                      FROM ServiceAppointmentHistory];
            ServiceAppointment sa = new ServiceAppointment();
            sa.ParentRecordId = acctLst[0].ID;
            sa.EarliestStartTime = system.Today() + 10;
            sa.DueDate = system.Today() + 20;
            sa.Comms__c = 'Tentative';
            //sa.Booking_Attempts_Count__c = 12;
            sa.Description = 'Test Case Description';
            insert sa;
            sa.Comms__c = 'Tentative';
            //sa.Booking_Attempts_Count__c = null;
            update sa;

        } catch (Exception e){
            system.debug('Error: ' + e);
            // system.assert(e.getMessage().contains('Test Class Error'), e.getMessage());

        }
    }

    @isTest
    public static void testForOldMap(){
        try{
            List<ServiceAppointment> saList = [SELECT ID
                                               FROM ServiceAppointment
                                               WHERE Comms__c = 'Key'];
            System.debug('110>saList' + saList);
            if (saList != null && saList.size() > 0){
                ServiceAppointment saObj = new ServiceAppointment();
                saObj.Comms__c = 'Tentative';
                saObj.Id = saList[0].Id;
                saObj.Description = 'Trial Service Appointment';
                update saObj;
            }
        } catch (Exception e){
            system.debug('Error: ' + e);
            system.assert(e.getMessage().contains('Test Class Error'), e.getMessage());
        }
    }
}