public without sharing class Shift_LogicHandler {
    public enum Action {Confirm, StartShift, EndShift, StartBreak, EndBreak, Ping, Log, Noop, TouchEvent, Checkin, Seen}
    public static Integer SHIFT_TOLERANCE_MINUTES  = 30; //the number of MINUTES in which a shift can still be associated to a touch
    public static final Integer MILIS_X_HOUR = 3600000; // number of miliseconds in an hour
    
    //the following 4 strings are used to return shift_status for the shift
    public static String SCHEDULED_SHIFT_START_STR = 'Shift Started (Scheduled)';
    public static String SCHEDULED_SHIFT_END_STR = 'Shift Finished (Scheduled)';
    public static String ADHOC_SHIFT_START_STR = 'Shift Started (Unplanned)';
    public static String ADHOC_SHIFT_END_STR = 'Shift Finished (Unplanned)';
    public static String START_STR = 'Started';
    public static String END_STR = 'Finished';
    private static final Map<String, Action> phrases;
    
    
    public enum Shift_Cases { Adhoc_Start, Adhoc_Finish,Scheduled_Start,Scheduled_End}

    /*public static sirenum__Shift__c associateTouchToShift2(sirenum__TouchEntry__c touch,sirenum.SirenumGate.TouchResult rc) {
        return associateTouchToShift2(touch,rc, null);
    }*/
    
    public static sirenum__Shift__c associateTouchToShift2(sirenum__TouchEntry__c touch,sirenum.SirenumGate.TouchResult rc, Action action) {
        return associateTouchToShift2(touch,rc,action,null);
    }
    
    public static sirenum__Shift__c associateTouchToShift2(sirenum__TouchEntry__c touch,sirenum.SirenumGate.TouchResult rc, Action action, String shiftId) {
        /* Input validation */
        boolean checkTags = false;
        system.assertNotEquals(null,touch,'No support for null touch');
        system.assertNotEquals(null,touch.sirenum__Contact_Touched__c,'No support for null Contact in the touch');
        system.assertNotEquals(null,touch.sirenum__TouchTime__c,'No support for null touchtime');
        
        sirenum__Shift_Logic__c settings = sirenumutils.getShiftLogic();
        
        /* Query for the most recent shift relevant for this touch */
        Decimal maxLength = settings.sirenum__Maximum_Shift_Length__c * 60; //In minutes
        Datetime early_cutoff_time = touch.sirenum__TouchTime__c.addMinutes(0 - Integer.valueOf(settings.sirenum__Early_Shift_Start_Minutes__c));
        Datetime late_cutoff_time = touch.sirenum__TouchTime__c.addMinutes(Integer.valueOf(settings.sirenum__Late_Shift_End_Minutes__c));
            
        //This touch can end adhoc shifts that have started at this time:
        DateTime minShiftStartTime = touch.sirenum__TouchTime__c.addMinutes((Integer)(0-maxLength));
         
        //assume the touch is closing an existing shift record. Try to find it
        //TODO make the following loop lock records for update. Problem: can't use ORDER BY
        //note that we are selecting the last entry by using sirenum__Actual_Start_Time__c DESC (which gives last date first)
        List<sirenum__Shift__c> shifts;
            if (shiftId == null) {
                shifts = [SELECT id,Name, sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Scheduled_Start_Time__c,
                sirenum__Scheduled_End_Time__c, sirenum__Must_End_Time__c, sirenum__Site__c, sirenum__Location__c, sirenum__Location__r.name, 
                sirenum__Location__r.sirenum__Site__c, sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Contact__r.Email, sirenum__Contact__r.HasOptedOutOfEmail, 
                sirenum__Rota__c, sirenum__Start_Touch__c, sirenum__Start_Touch__r.sirenum__Tag__c, sirenum__Team__c 
                         FROM sirenum__Shift__c 
                         WHERE sirenum__Contact__c =: touch.sirenum__Contact_Touched__c AND
                               sirenum__Actual_End_Time__c = null AND //We can't do anything in completed shifts
                               sirenum__Cancelled__c = false //Do not do anything to cancelled shifts
                        AND ((sirenum__Scheduled_Start_Time__c = null AND sirenum__Actual_Start_Time__c != null AND sirenum__Actual_Start_Time__c >= :minShiftStartTime AND sirenum__Actual_Start_Time__c <= :touch.sirenum__TouchTime__c) //Adhoc End
                           OR (sirenum__Scheduled_Start_Time__c != null AND sirenum__Actual_Start_Time__c != null AND sirenum__Actual_Start_Time__c >= :minShiftStartTime AND sirenum__Actual_Start_Time__c <= :touch.sirenum__TouchTime__c AND sirenum__Actual_End_Time__c = null) //Scheduled End
                           OR (sirenum__Scheduled_Start_Time__c != null AND sirenum__Actual_Start_Time__c = null AND sirenum__Scheduled_Start_Time__c < :late_cutoff_time AND sirenum__Scheduled_End_Time__c > :touch.sirenum__TouchTime__c)) //Scheduled Start
/*                          
                         AND ((sirenum__Actual_Start_Time__c != null AND sirenum__Actual_Start_Time__c >= :minShiftStartTime AND sirenum__Actual_Start_Time__c <= :touch.sirenum__TouchTime__c) //Adhoc End
                           OR (sirenum__Scheduled_End_Time__c != null AND sirenum__Scheduled_End_Time__c <= :late_cutoff_time) //Scheduled End
                           OR (sirenum__Scheduled_Start_Time__c != null AND sirenum__Actual_Start_Time__c = null AND sirenum__Scheduled_Start_Time__c < :late_cutoff_time AND sirenum__Scheduled_End_Time__c > :touch.sirenum__TouchTime__c)) //Scheduled Start*/
                           
                         ORDER BY sirenum__Actual_Start_Time__c DESC NULLS LAST, sirenum__Scheduled_Start_Time__c 
                         LIMIT 20];
            } else {
                shifts = [SELECT id,Name, sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c, 
                sirenum__Must_End_Time__c, sirenum__Site__c, sirenum__Location__c, sirenum__Location__r.name, sirenum__Location__r.sirenum__Site__c, 
                sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Contact__r.Email, sirenum__Contact__r.HasOptedOutOfEmail, sirenum__Rota__c, 
                sirenum__Start_Touch__c, sirenum__Start_Touch__r.sirenum__Tag__c, sirenum__Team__c
                         FROM sirenum__Shift__c 
                         WHERE Id =: shiftId AND sirenum__Cancelled__c = false];
            }
        

        /* Process query results to find what action needs to be taken */                                    
        if (shifts == null || shifts.size() == 0) {
            // CASE: Adhoc_start
            if (shiftId == null && actionAllowsStartShift(action))
                return createAdHocShift(touch, rc);
            //else if (shiftId == null && actionAllowsSeen(action))
              //  return createAdHocShiftSeen(touch,rc);
            else
                //throw new SirenumException (false, 'We tried ending your shift, but according to our records you are not currently working at one. If you have been on a shift, please contact an administrator and let them know.');
                return null;
        } 

        sirenum__Shift__c shift = null; //The resulting shift which we have processed
        String resultingAction = null;
        String chatterAction = null;

        //Find the first shift that we can perform an action with
        for (sirenum__Shift__c s: shifts) {
            //Ended shifts don't belong here
            if (s.sirenum__Actual_End_Time__c != null)
                continue;
            
            
            //Determine if the shift needs to be started or finished
            
            if (s.sirenum__Actual_Start_Time__c == null && (actionAllowsStartShift(action) || actionAllowsSeen(action))) {
                //Needs to be started
                
                //Prevent the same shift from being started twice (by using the shift ID parameter)
                if (s.sirenum__Actual_Start_Time__c != null) break;

                // Close any other started shifts if someone found...
                if (!closeAllOpenShiftsInList(shifts, touch)) {
                    return null; // found at least one shift started less than one hour ago: ignore touch!
                }

                shift = s;
                
                //Prepare result and chatter messages               
                resultingAction = (s.sirenum__Scheduled_Start_Time__c != null) ? SCHEDULED_SHIFT_START_STR : ADHOC_SHIFT_START_STR;
                chatterAction = START_STR;
                
                //Set the shift parameters to mark its start                
                shift.sirenum__Actual_Start_Time__c = touch.sirenum__TouchTime__c;
                
                shift.sirenum__Start_Touch__c = touch.id; //associate the starting touch with the shift
                shift.sirenum__Start_Touch__r = touch;
                
               
               
                
                checkTags = true;

                break;
            } else if (s.sirenum__Actual_Start_Time__c != null && actionAllowsEndShift(action)) {
                //Needs to be finished
                shift = s;
                
                //Prepare result and chatter messages
                resultingAction = (s.sirenum__Scheduled_End_Time__c != null) ? SCHEDULED_SHIFT_END_STR : ADHOC_SHIFT_END_STR;
                chatterAction = END_STR;
                
                //Set the shift parameters to mark its end
                
                shift.sirenum__Actual_End_Time__c = touch.sirenum__TouchTime__c; 
                shift.sirenum__End_Touch__c = touch.id;
                break;
            } /*else if (s.sirenum__Actual_Start_Time__c != null && actionAllowsSeen(action)){
                shift = s;
                
                if (shift.sirenum__Scheduled_Start_Time__c == null)
                    resultingAction = ADHOC_SHIFT_START_STR;
                else
                    resultingAction = SCHEDULED_SHIFT_START_STR;
                
                shift.sirenum__Last_Seen__c = touch.sirenum__TouchTime__c;
                touch.sirenum__Seen_In_Shift__c = shift.id;
                touch.sirenum__processed__c = true;

                Database.upsert(touch);
                Database.upsert(s);

                 List<sirenum__TouchEntry__c> touches_delete = [SELECT id FROM sirenum__TouchEntry__c WHERE sirenum__Seen_In_Shift__c != null AND 
                                                    sirenum__Contact_Touched__c =: touch.sirenum__Contact_Touched__c 
                                                    AND sirenum__TouchTime__c <: touch.sirenum__TouchTime__c];
                              
                Database.delete(touches_delete);
            }*/
        }
        
        /* Add touch data to shift, and save it */
        if (shift != null) {
            updateShiftFromTouch(shift, touch);
            Database.SaveResult ur;
                ur = Database.update(shift);
           
            if (!ur.isSuccess())
                throw new SirenumException ('Error updating');
            
           // writeShiftToReturnClass(shift, rc, resultingAction);
            SirenumUtils.sendShiftConfirmation(shift, chatterAction);
            
            
            
            return shift;
        }
        
        /* No action was found for the shift? Create new Ad-Hoc shift */
        if (shiftId == null && actionAllowsStartShift(action)) {
            if (!closeAllOpenShiftsInList(shifts, touch)) {
                return null; // found at least one shift started less than one hour ago: ignore touch!
            }
            return createAdHocShift(touch, rc);
        }
        else
            return null;
    }

    /**
        Starts a new AdHoc shift with the touch data.
    */
    public static sirenum__Shift__c createAdHocShift(sirenum__TouchEntry__c touch, sirenum.SirenumGate.TouchResult rc) {
        sirenum__Shift__c new_shift; // = SirenumUtils.createShiftFromTemplate(touch);
        String actionText;
        
        if (new_shift != null) {
            actionText = SCHEDULED_SHIFT_START_STR;
        } else {
            new_shift = new sirenum__Shift__c();
            actionText = ADHOC_SHIFT_START_STR;
        }
        
        new_shift.sirenum__Published__c = true;
        new_shift.sirenum__Actual_Start_Time__c = touch.sirenum__TouchTime__c; 
        new_shift.sirenum__contact__c = touch.sirenum__Contact_Touched__c; 
        new_shift.sirenum__Location__c = touch.sirenum__Location__c; //this works only if location is set using the gate and not in the trigger
        
        new_shift.sirenum__Start_Touch__c = touch.id; //associate the starting touch with the shift
        new_shift.sirenum__Start_Touch__r = touch;
        new_shift.sirenum__Event__c = touch.sirenum__Event__c;
        
        if (touch.sirenum__Location__r != null)
            new_shift.sirenum__Site__c = touch.sirenum__Location__r.sirenum__Site__c;

        insert new_shift;
        
       

        system.assertNotEquals(null, new_shift.id, 'failed to insert record');
        // If you can insert, you should be able to read so no security test needed here
        sirenum__Shift__c current_shift = [SELECT id, Name, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c, sirenum__Must_End_Time__c, sirenum__Site__c, sirenum__Site__r.Name, sirenum__Location__r.name, sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Contact__r.Email, sirenum__Contact__r.HasOptedOutOfEmail, sirenum__Actual_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Rota__c, sirenum__Start_Touch__c, sirenum__Start_Touch__r.sirenum__Tag__c, sirenum__Team__c
                                  FROM sirenum__Shift__c
                                  WHERE id=:new_shift.id LIMIT 1];
        
        try {
            SirenumUtils.sendShiftConfirmation(current_shift, START_STR);
        } catch (Exception e) {}
        
        
        return current_shift;
    }
    
    /**
        Starts a new AdHoc shift with bluetooth tag with the touch data.
    */
   /* public static sirenum__Shift__c createAdHocShiftSeen(sirenum__TouchEntry__c touch, sirenum.SirenumGate.TouchResult rc) {
        sirenum__Shift__c new_shift = SirenumUtils.createShiftFromTemplate(touch);
        String actionText;
        
        if (new_shift != null) {
            actionText = SCHEDULED_SHIFT_START_STR;
        } else {
            new_shift = new sirenum__Shift__c();
            actionText = ADHOC_SHIFT_START_STR;
        }

        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Published__c)) {
            new_shift.sirenum__Published__c = true;
        }
        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Actual_Start_Time__c)) {
            new_shift.sirenum__Actual_Start_Time__c = touch.sirenum__TouchTime__c;
        }
        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__contact__c)) {
            new_shift.sirenum__contact__c = touch.sirenum__Contact_Touched__c; //set the new contact
        }
        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Location__c)) {
            new_shift.sirenum__Location__c = touch.sirenum__Location__c; //this works only if location is set using the gate and not in the trigger
        }
        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Start_Touch__c)) {
            new_shift.sirenum__Start_Touch__c = touch.id; //associate the starting touch with the shift
            new_shift.sirenum__Start_Touch__r = touch;
        }

        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Event__c)) {
            new_shift.sirenum__Event__c = touch.sirenum__Event__c;
        }
        
        if (canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Last_Seen__c)) {
            new_shift.sirenum__Last_Seen__c = touch.sirenum__TouchTime__c;
        }
        if (canCreateField(Schema.SObjectType.sirenum__TouchEntry__c.fields.sirenum__seen_in_shift__c)) {
            touch.sirenum__Seen_In_Shift__c = new_shift.id;
        }

        if (canUpdateField(Schema.SObjectType.sirenum__TouchEntry__c.fields.sirenum__processed__c)) {
            touch.sirenum__processed__c = true;
        }

        if (touch.sirenum__Location__r != null && canCreateField(Schema.SObjectType.sirenum__Shift__c.fields.sirenum__Site__c))
            new_shift.sirenum__Site__c = touch.sirenum__Location__r.sirenum__Site__c;

        if (canCreateObject(Schema.SObjectType.sirenum__Shift__c)) {
            insert new_shift;
            system.assertNotEquals(null,new_shift.id,'failed to insert record');
        } else {
            throw new SirenumException('Error inserting shift');
        }

            Database.upsert(touch);
        

        sirenum__Shift__c current_shift = [SELECT id, Name, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c, sirenum__Must_End_Time__c, sirenum__Site__c, sirenum__Site__r.Name, sirenum__Location__r.name, sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Contact__r.Email, sirenum__Contact__r.HasOptedOutOfEmail, sirenum__Actual_Start_Time__c, sirenum__Actual_End_Time__c, sirenum__Rota__c, sirenum__Start_Touch__c, sirenum__Start_Touch__r.sirenum__Tag__c, sirenum__Team__c
                                  FROM sirenum__Shift__c
                                  WHERE id=:new_shift.id LIMIT 1];
        system.assertNotEquals(null,rc,'Null return object');
        //writeShiftToReturnClass(current_shift, rc, actionText);
        
        try {
            SirenumUtils.sendShiftConfirmation(current_shift, START_STR);
        } catch (Exception e) {}
        
        //Check H&S rules     TODO: ENABLE   
        //sirenumEngine controller = new SirenumEngine();
        //controller.checkTags(new List<sirenum__Shift__c>{current_shift});
                               
        
        return current_shift;
    }
    */
   /* private static void writeShiftToReturnClass(sirenum__Shift__c shift, sirenum.SirenumGate.TouchResult rc, String shiftStatus) {
        //rc.shift_status = shiftStatus;
       // rc.shift = shift.Name;
        rc.shift_id = shift.Id;
        rc.shift_start_time = shift.sirenum__Scheduled_Start_Time__c;
        rc.shift_end_time = shift.sirenum__Scheduled_End_Time__c;
        rc.shift_must_end_by = shift.sirenum__Must_End_Time__c;
      
    }*/
    
    private static void updateShiftFromTouch(sirenum__Shift__c shift, sirenum__TouchEntry__c touch) {
        //If shift has no location, but touch does have one - copy the location to the shift
        if (shift.sirenum__Location__c == null && shift.sirenum__Site__c == null && touch.sirenum__Location__c != null) {
                shift.sirenum__Location__c = touch.sirenum__Location__c;
                shift.sirenum__Site__c = touch.sirenum__Location__r.sirenum__Site__c;
        }
       
    }
    
    private static boolean actionAllowsStartShift(Action action) {
        return (action == null || action == Shift_LogicHandler.Action.StartShift);
    }
    
    private static boolean actionAllowsEndShift(Action action) {
        return (action == null || action == Shift_LogicHandler.Action.EndShift);
    }
    
    private static boolean actionAllowsSeen (Action action) {
        return (action == null || action == Shift_LogicHandler.Action.Seen);
    }
    
    private static Boolean closeAllOpenShiftsInList(List<sirenum__Shift__c> shifts, sirenum__TouchEntry__c touch) {
        List<sirenum__Shift__c> pendingUpdates = new List<sirenum__Shift__c>();
        for (sirenum__Shift__c shift: shifts) {
            if (shift.sirenum__Actual_Start_Time__c != null) {
                // If the shift has started less than one hour ago...
                if (shifts[0].sirenum__Actual_Start_Time__c.addHours(1) > touch.sirenum__TouchTime__c) {
                    return false;
                }
                    shift.sirenum__Actual_End_Time__c = touch.sirenum__TouchTime__c;
                    shift.sirenum__End_Touch__c = touch.id;
                updateShiftFromTouch(shift, touch);     
                pendingUpdates.add(shift);
            }
        }
        if (pendingUpdates.size() > 0) {
            Database.SaveResult[] sr = Database.update(pendingUpdates, true);
            for (Database.SaveResult saveResult: sr) {
                if (!saveResult.isSuccess()) {
                    throw new SirenumException ('Error closing');
                }
            }   
        }
        else {
            if (pendingUpdates.size() > 0) {
                throw new SirenumException ();
            }
        }
        return true;
    }
     
   
    public class SirenumException extends exception{}
}