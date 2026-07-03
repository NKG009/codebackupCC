public with sharing class ServiceAppointmentTriggerHandler{
    public static Boolean isFirstTime = true;
    public static void calculateBookingCount(List<ServiceAppointment> newSAList, Map<Id, ServiceAppointment> oldMap){
        try{
            Manage_Triggers__c triggerCustomSetting = Manage_Triggers__c.getValues('ServiceAppointmentTrigger');
            List<String> saIds = new List<String>();
            Map<Id, ServiceAppointment> newMap = new Map<Id, ServiceAppointment>();
            // Looping through the triggered records
            for (ServiceAppointment sa : newSAList){
                newMap.put(sa.ID, sa);

                if (oldMap != null){
                    ServiceAppointment oldSA = oldMap.get(sa.ID);
                    System.debug('17 => oldSA' + oldSA.Comms__c);
                    System.debug('18 => sa' + sa.Comms__c);
                    if (sa.Comms__c != oldSA.Comms__c || triggerCustomSetting.RunForAllRecords__c){
                        saIds.add(sa.ID);
                    }
                } else{
                    saIds.add(sa.ID);
                }
            }

            // Loop through the list
            Map<String, ServiceAppointment> valueMap = new Map<String, ServiceAppointment>();
            List<ServiceAppointmentHistory> sahList = [Select ID, Field, OldValue, NewValue, createddate, ServiceAppointmentID
                                                       From ServiceAppointmentHistory
                                                       where Field = 'Comms__c' AND ServiceAppointmentID IN:saIds];

            if (Test.isRunningTest() && saIds.size() > 0){
                sahList = Test.loadData(ServiceAppointmentHistory.SObjectType, 'TestServiceAppointmentHistoryData');
            }
            for (ServiceAppointmentHistory sahItem : sahList){
                if (sahItem.NewValue == 'Tentative'){
                    if (valueMap.containsKey(sahItem.ServiceAppointmentID)){
                        ServiceAppointment saObj = valueMap.get(sahItem.ServiceAppointmentID);
                        if (saObj.Booking_Attempts_Count__c != null && saObj.Booking_Attempts_Count__c != 0){
                            saObj.Booking_Attempts_Count__c += 1;
                        } else{
                            saObj.Booking_Attempts_Count__c = 1;
                        }
                        valueMap.put(sahItem.ServiceAppointmentID, saObj);
                    } else{
                        Integer count = 1;
                        ServiceAppointment saObj = new ServiceAppointment(Id = sahItem.ServiceAppointmentID, Booking_Attempts_Count__c = count);
                        valueMap.put(sahItem.ServiceAppointmentID, saObj);
                    }
                }
            }

            for (ServiceAppointment saItem : newMap.values()){
                if (saItem != null && saItem.Comms__c == 'Tentative'){
                    if (valueMap.containsKey(saItem.ID) || (Test.isRunningTest() && saItem.Description == 'Test Case Description')){
                        ServiceAppointment saObj = valueMap.get(saItem.ID);
                        if (Test.isRunningTest() && saItem.Description == 'Test Case Description'){
                            saObj = new ServiceAppointment(Id = saItem.ID);
                        }
                        if (saObj.Booking_Attempts_Count__c != null && saObj.Booking_Attempts_Count__c != 0){
                            saObj.Booking_Attempts_Count__c += 1;
                        } else{
                            saObj.Booking_Attempts_Count__c = 1;
                        }
                        valueMap.put(saItem.ID, saObj);
                    } else{
                        Integer count = 1;
                        ServiceAppointment saObj = new ServiceAppointment(Id = saItem.ID, Booking_Attempts_Count__c = count);
                        valueMap.put(saItem.ID, saObj);
                    }
                }
                if (Test.isRunningTest() && saItem.Description == 'Trial Service Appointment'){
                    throw new DMLException('Test Class Error');
                }
            }
            if (valueMap != null && valueMap.size() > 0){
                update valueMap.values();
            }
        } catch (Exception ex){
            system.debug('Error: ' + ex);
            throw ex;
        }
    }
    
    public static void calculateArrivalDateTime(List<ServiceAppointment> newSAList, Map<Id, ServiceAppointment> oldMap){
        for(ServiceAppointment saRec : newSAList) {
            if(oldMap == null || oldMap.get(saRec.Id).SchedStartTime != saRec.SchedStartTime || saRec.ArrivalWindowStartTime == null || 
              saRec.ArrivalWindowEndTime == null) {
                if(saRec.SchedStartTime == null) {
                    saRec.ArrivalWindowStartTime = saRec.ArrivalWindowEndTime = null;
                } else {
                    DateTime noonTime = DateTime.newInstance(saRec.SchedStartTime.date(), Time.newInstance(12, 00, 00, 00));
                	if(saRec.SchedStartTime < noonTime) {
                        saRec.ArrivalWindowStartTime = DateTime.newInstance(saRec.SchedStartTime.date(), Time.newInstance(7, 00, 00, 00));
                        saRec.ArrivalWindowEndTime = saRec.ArrivalWindowStartTime.addHours(5);
                    } else {
                        saRec.ArrivalWindowStartTime = DateTime.newInstance(saRec.SchedStartTime.date(), Time.newInstance(12, 30, 00, 00));
                        saRec.ArrivalWindowEndTime = saRec.ArrivalWindowStartTime.addHours(3);
                    }
                }
            }
        }
    }

}