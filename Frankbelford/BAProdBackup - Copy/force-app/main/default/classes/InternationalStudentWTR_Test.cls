/**
 * Created by Bullhorn on 20/10/2023.
 */

@IsTest
private class InternationalStudentWTR_Test {
    @IsTest
    static void testGetWeekStart() {
        Datetime mondayNoon = Datetime.newInstance(2023, 1, 16, 12, 0, 0);
        Datetime thursdayNoon = Datetime.newInstance(2023, 1, 19, 12, 0, 0);

        Assert.areEqual(
                InternationalStudentWTR.getWeekStart(mondayNoon, 0),
                Datetime.newInstance(2023, 1, 16, 0, 0, 0),
                'Monday value for week starts on Monday / ends on Sunday');
        Assert.areEqual(
                InternationalStudentWTR.getWeekStart(thursdayNoon, 0),
                Datetime.newInstance(2023, 1, 16, 0, 0, 0),
                'Thursday value for week starts on Monday / ends on Sunday');
        Assert.areEqual(
                InternationalStudentWTR.getWeekStart(mondayNoon, 2),
                Datetime.newInstance(2023, 1, 11, 0, 0, 0),
                'Monday value for week starts on Wednesday / ends on Tuesday');
        Assert.areEqual(
                InternationalStudentWTR.getWeekStart(thursdayNoon, 2),
                Datetime.newInstance(2023, 1, 18, 0, 0, 0),
                'Thursday value for week starts on Wednesday / ends on Tuesday');
        Assert.areEqual(
                InternationalStudentWTR.getWeekStart(mondayNoon, 6),
                Datetime.newInstance(2023, 1, 15, 0, 0, 0),
                'Monday value for week starts on Sunday / ends on Saturday');
        Assert.areEqual(
                InternationalStudentWTR.getWeekStart(thursdayNoon, 6),
                Datetime.newInstance(2023, 1, 15, 0, 0, 0),
                'Thursday value for week starts on Sunday / ends on Saturday');
    }

    @IsTest
    static void testIsShiftRelevantForRule() {
        Datetime monday = Datetime.newInstance(2023, 1, 16, 0, 0, 0);

        sirenum.SirenumEngine.Shift shift = new sirenum.SirenumEngine.Shift(new sirenum__Shift__c(
                sirenum__Scheduled_Start_Time__c = monday.addHours(9),
                sirenum__Scheduled_End_Time__c = monday.addHours(17)
        ));

        shift.isChecked = false;
        shift.finishDate = null;
        Assert.isFalse(InternationalStudentWTR.isShiftRelevantForRule(shift), 'Unchecked shift');

        shift.isChecked = true;
        shift.finishDate = null;
        Assert.isFalse(InternationalStudentWTR.isShiftRelevantForRule(shift), 'Checked shift with null value');

        shift.isChecked = true;
        shift.finishDate = 0;
        Assert.isFalse(InternationalStudentWTR.isShiftRelevantForRule(shift), 'Checked shift with zero value');

        shift.isChecked = true;
        shift.finishDate = -10;
        Assert.isFalse(InternationalStudentWTR.isShiftRelevantForRule(shift), 'Checked shift with negative value');

        shift.isChecked = true;
        shift.finishDate = 10;
        Assert.isTrue(InternationalStudentWTR.isShiftRelevantForRule(shift), 'Checked shift with positive value');
    }

    @IsTest
    static void testGetEffectiveWork() {
        Datetime monday9am = Datetime.newInstance(2023, 1, 16, 9, 0, 0);
        Datetime monday5pm = Datetime.newInstance(2023, 1, 16, 17, 0, 0);

        sirenum.SirenumEngine.Shift shift9to5 = new sirenum.SirenumEngine.Shift(new sirenum__Shift__c(
                sirenum__Scheduled_Start_Time__c = monday9am,
                sirenum__Scheduled_End_Time__c = monday5pm
        ));

        Assert.areEqual(shift9to5.startDT, monday9am);
        Assert.areEqual(shift9to5.finishDT, monday5pm);
        Assert.areEqual(shift9to5.paidBreakLength, 0);

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(-1), monday5pm.addHours(1)),
                8.0, 'The shift is fully included in the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(2), monday5pm.addHours(1)),
                6.0, 'The shift start before the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(-1), monday5pm.addHours(-2)),
                6.0, 'The shift end after the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(2), monday5pm.addHours(-2)),
                4.0, 'The shift start before and end after the interval');

        // With 30 minutes break
        shift9to5.paidBreakLength = 0.5;

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(-1), monday5pm.addHours(1)),
                7.5, 'The shift is fully included in the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(2), monday5pm.addHours(1)),
                5.5, 'The shift start before the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(-1), monday5pm.addHours(-2)),
                5.5, 'The shift end after the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(2), monday5pm.addHours(-2)),
                3.5, 'The shift start before and end after the interval');

        Assert.areEqual(
                InternationalStudentWTR.getEffectiveWork(shift9to5, monday9am.addHours(7), monday5pm.addMinutes(-40)),
                0.0, 'The intersection with the interval is less than the break');
    }

    final static Integer UNCHECKED = -1;
    final static Integer CHECKED_UNLIMITED = 0;

    static sirenum.SirenumEngine.Shift createShift(String aDate, Integer start, Integer finish, Decimal paidBreaks, Integer ruleLimit, Id contactId, Long groupId) {
        Datetime shiftDate = Datetime.newInstance(Date.valueOf(aDate), Time.newInstance(0,0,0,0));

        sirenum.SirenumEngine.Shift shift = new sirenum.SirenumEngine.Shift(new sirenum__Shift__c(
                sirenum__Scheduled_Start_Time__c = shiftDate.addHours(start),
                sirenum__Scheduled_End_Time__c = shiftDate.addHours(finish),
                sirenum__Contact__c = contactId
        ));

        shift.paidBreakLength = paidBreaks;
        shift.isChecked = ruleLimit >= 0;
        shift.finishDate = ruleLimit > 0 ? ruleLimit : null;
        shift.startDate = groupId;

        return shift;
    }

    static void assertAlertExists(List<sirenum__LogEntry__c> alerts, Id contactId, String shiftDate, Integer ruleLimit) {
        Date shiftDateValue = Date.valueOf(shiftDate);

        for (sirenum__LogEntry__c alert : alerts) {
            if (alert.sirenum__Contact__c == contactId &&
                    alert.sirenum__Shift__r.sirenum__Scheduled_Start_Time__c.date() == shiftDateValue) {
                Assert.areEqual(alert.sirenum__Details__c, String.format(
                        'International student exceeding {0} working hrs limit',
                        new Object[] { ruleLimit }
                ));
                Assert.areEqual(alert.sirenum__Severity__c, 'Fatal');
                Assert.areEqual(alert.sirenum__Category__c, 'International Student Weekly Hours');
                return;
            }
        }

        Assert.fail('No alert found for shift with a date of ' + shiftDate);
    }

    @IsTest
    static void testEvaluateTimeline() {
        // Week start on Monday (end on Sunday)
        Integer weekEndingDay = 0;

        // Create a timeline with shifts in not chronological order to ensure the code sort correctly
        List<sirenum.SirenumEngine.Shift> timeline = new List<sirenum.SirenumEngine.Shift>{
                // W/C Jan 16 - 2 shifts with 10 hours limit (the second shift violate the rule)
                createShift('2023-01-18', 9, 17, 0.5, 10),
                createShift('2023-01-17', 9, 17, 0.5, 10),
                // W/C Jan 9 - unchecked shift with 3 work hours on monday (4 hours - 1 hour break),
                // 1st checked shift with 10 hours limit and 5 hours duration does not violate rule
                // 2nd checked shift with 10 hours limit and 5 hours duration violate the rule
                createShift('2023-01-08', 20, 28, 1, UNCHECKED),
                createShift('2023-01-11', 10, 15, 0, 10),
                createShift('2023-01-10', 10, 15, 0, 10),
                // Checked shift that split across weeks does not violate when both parts are below
                createShift('2023-02-05', 18, 30, 0, 10),
                // Checked shift that split across weeks violate when fist part is over
                createShift('2023-02-19', 18, 25, 0, 5),
                // Checked shift that split across weeks violate when second part is over
                createShift('2023-03-12', 20, 30, 0, 5)
        };

        List<sirenum__LogEntry__c> alerts = new List<sirenum__LogEntry__c>();

        InternationalStudentWTR.evaluateTimeline(timeline, alerts, weekEndingDay);

        Assert.areEqual(4, alerts.size(), 'Unexpected number of alerts');
        assertAlertExists(alerts, null, '2023-01-18', 10);
        assertAlertExists(alerts, null, '2023-01-11', 10);
        assertAlertExists(alerts, null, '2023-02-19', 5);
        assertAlertExists(alerts, null, '2023-03-12', 5);
    }

    static sirenum.SirenumEngine.Shift createShift(String aDate, Integer start, Integer finish, Decimal paidBreaks, Integer ruleLimit) {
        return createShift(aDate, start, finish, paidBreaks, ruleLimit, null, null);
    }

    static void assertTimelineExists(List<List<sirenum.SirenumEngine.Shift>> timelines, Id contactId, String[] shiftDates) {
        for (List<sirenum.SirenumEngine.Shift> timeline : timelines) {
            if (timeline.isEmpty()) {
                Assert.fail('Unexpected empty timeline');
            }

            Set<String> shiftDatesSet = new Set<String>(shiftDates);

            if (timeline[0].shift.sirenum__Contact__c == contactId && timeline.size() == shiftDates.size()) {
                for (sirenum.SirenumEngine.Shift shift : timeline) {
                    shiftDatesSet.remove(shift.shift.sirenum__Scheduled_Start_Time__c.format('yyyy-MM-dd'));
                }

                if (shiftDatesSet.isEmpty()) {
                    return;
                }
            }
        }

        Assert.fail('No timeline for contact id ' + contactId + ' and shift dates of ' + String.join(shiftDates, ', '));
    }

    @IsTest
    static void testSplitShiftsIntoTimelines() {
        Id contactId1 = '003000000000001';
        Id contactId2 = '003000000000002';

        List<sirenum.SirenumEngine.Shift> shifts = new List<sirenum.SirenumEngine.Shift>{
                createShift('2023-01-10', 9, 17, 0.5, CHECKED_UNLIMITED, contactId1, null),
                createShift('2023-01-11', 9, 17, 0.5, CHECKED_UNLIMITED, contactId2, null),
                createShift('2023-01-12', 9, 17, 0.5, 10, contactId1, null),
                createShift('2023-01-13', 9, 17, 0.5, UNCHECKED, contactId2, null),
                createShift('2023-01-14', 9, 17, 0.5, UNCHECKED, contactId1, 1),
                createShift('2023-01-15', 9, 17, 0.5, 10, contactId1, 1),
                createShift('2023-01-16', 9, 17, 0.5, UNCHECKED, contactId2, 1),
                createShift('2023-01-17', 9, 17, 0.5, 10, contactId2, 1),
                createShift('2023-01-18', 9, 17, 0.5, UNCHECKED, contactId1, 2),
                createShift('2023-01-19', 9, 17, 0.5, 10, contactId1, 2)
        };

        List<List<sirenum.SirenumEngine.Shift>> timelines = InternationalStudentWTR.splitShiftsIntoTimelines(shifts);

        Assert.areEqual(4, timelines.size(), 'Unexpected number of timelines');
        assertTimelineExists(timelines, contactId1, new String[]{'2023-01-10', '2023-01-12'});
        assertTimelineExists(timelines, contactId1, new String[]{'2023-01-14', '2023-01-15'});
        assertTimelineExists(timelines, contactId2, new String[]{'2023-01-16', '2023-01-17'});
        assertTimelineExists(timelines, contactId1, new String[]{'2023-01-18', '2023-01-19'});
    }

    private static Contact[] createContacts() {
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        insert candidateAccount;

        TestDataFactory.setupCustomSettings(candidateAccount.Id);

        List<Contact> contacts = TestDataFactory.createCandidate(candidateAccount.Id, 2);

        Contact student = contacts[0];
        student.Student__c = true;
        student.IP_CitizenshipGroup__c = 'Citizen of a Non-UK/Republic of Ireland Country';
        student.IP_StudyComplete__c = false;
        student.IP_FirstRecordedTermDate__c = Date.newInstance(2023, 1, 1);
        student.IP_LastRecordedTermDate__c = Date.newInstance(2023, 2, 1);
        student.VISA_Expiration_Date__c = Date.newInstance(2023, 2, 1);
        student.IP_Term1StartDate__c = Date.newInstance(2023, 1, 1);
        student.IP_Term1EndDate__c = Date.newInstance(2023, 1, 15);
        student.IP_Term2StartDate__c = Date.newInstance(2023, 1, 23);
        student.IP_Term2EndDate__c = Date.newInstance(2023, 1, 30);
        student.IP_StudentWorkHours__c = '10';

        insert contacts;

        return contacts;
    }

    @IsTest
    static void testRecalculateFormulasOnCheckedShifts() {
        List<Contact> contacts = createContacts();
        Contact student = contacts[0];
        Contact nonStudent = contacts[1];
        Long studentWorkLimit = Long.valueOf(student.IP_StudentWorkHours__c);

        List<sirenum.SirenumEngine.Shift> shifts = new List<sirenum.SirenumEngine.Shift>{
                createShift('2023-01-10', 9, 17, 0, CHECKED_UNLIMITED, student.Id, null),
                createShift('2023-01-20', 9, 17, 0, CHECKED_UNLIMITED, student.Id, null),
                createShift('2023-01-31', 9, 17, 0, CHECKED_UNLIMITED, student.Id, null),
                createShift('2023-01-15', 9, 17, 0, CHECKED_UNLIMITED, nonStudent.Id, null)
        };

        List<Long> shiftHashCodes = new List<Long>();

        for (sirenum.SirenumEngine.Shift shift : shifts) {
            shiftHashCodes.add(System.hashCode(shift.shift));
        }

        Test.startTest();
        InternationalStudentWTR.recalculateFormulasOnCheckedShifts(shifts);
        Test.stopTest();

        // Ensure no change to hash codes
        for (Integer i = 0; i < shifts.size(); i++) {
            Assert.areEqual(shiftHashCodes[i], System.hashCode(shifts[i].shift), 'Shift ' + i + ' hash code is different');
        }

        Assert.areEqual(studentWorkLimit, shifts[0].finishDate); // student during term
        Assert.areEqual(null, shifts[1].finishDate); // student between terms
        Assert.areEqual(studentWorkLimit, shifts[2].finishDate); // student after last term
        Assert.areEqual(null, shifts[3].finishDate); // Not a student
    }

    @IsTest
    static void testExecute() {
        List<Contact> contacts = createContacts();
        Contact student = contacts[0];
        Contact nonStudent = contacts[1];
        Integer studentWorkLimit = Integer.valueOf(student.IP_StudentWorkHours__c);

        // Set the week ending to Sunday to start week on Monday
        sirenum__Shift_Logic__c shiftLogic = sirenum__Shift_Logic__c.getInstance();
        shiftLogic.sirenum__Week_Ending__c = 0;
        upsert shiftLogic;

        // Assuming week start at Monday (2032-01-09)
        List<sirenum.SirenumEngine.Shift> shifts = new List<sirenum.SirenumEngine.Shift>{
                // W/C Jan 9 (student group null) - 2 shifts with 10 hours length and 1/2 hour break (the second shift violate the rule)
                createShift('2023-01-10', 9, 19, 0.5, CHECKED_UNLIMITED, student.Id, null),
                createShift('2023-01-11', 9, 19, 0.5, CHECKED_UNLIMITED, student.Id, null),
                // W/C Jan 9 (student group 1) - unchecked shift with 3 work hours on monday (4 hours - 1 hour break),
                // 1st checked shift with 10 hours limit and 5 hours duration does not violate rule
                // 2nd checked shift with 10 hours limit and 5 hours duration violate the rule
                createShift('2023-01-08', 20, 28, 1, CHECKED_UNLIMITED, student.Id, 1),
                createShift('2023-01-13', 10, 15, 0, CHECKED_UNLIMITED, student.Id, 1),
                createShift('2023-01-12', 10, 15, 0, CHECKED_UNLIMITED, student.Id, 1),
                // W/C Jan 16 (student out of term time) - no alerts
                createShift('2023-01-17', 10, 18, 0, CHECKED_UNLIMITED, student.Id, null),
                createShift('2023-01-18', 10, 18, 0, CHECKED_UNLIMITED, student.Id, null),
                // W/C Jan 23 (student in term) - only alerts for checked shift, e.g. the first shift is 11 hours with no alert
                createShift('2023-01-24', 10, 21, 0, UNCHECKED, student.Id, null),
                createShift('2023-01-25', 10, 15, 0, CHECKED_UNLIMITED, student.Id, null),
                // Non-student contact - no alerts
                createShift('2023-01-08', 20, 28, 1, CHECKED_UNLIMITED, nonStudent.Id, 1),
                createShift('2023-01-13', 10, 15, 0, CHECKED_UNLIMITED, nonStudent.Id, 1),
                createShift('2023-01-12', 10, 15, 0, CHECKED_UNLIMITED, nonStudent.Id, 1),
                createShift('2023-01-17', 10, 18, 0, CHECKED_UNLIMITED, nonStudent.Id, null),
                createShift('2023-01-18', 10, 18, 0, CHECKED_UNLIMITED, nonStudent.Id, null)
        };

        List<Long> shiftHashCodes = new List<Long>();

        for (sirenum.SirenumEngine.Shift shift : shifts) {
            shiftHashCodes.add(System.hashCode(shift.shift));
        }

        Test.startTest();
        List<sirenum__LogEntry__c> alerts = new InternationalStudentWTR().execute(shifts);
        Test.stopTest();

        // Ensure no change to hash codes
        for (Integer i = 0; i < shifts.size(); i++) {
            Assert.areEqual(shiftHashCodes[i], System.hashCode(shifts[i].shift), 'Shift ' + i + ' hash code is different');
        }

        Assert.areEqual(3, alerts.size(), 'Unexpected number of alerts');
        assertAlertExists(alerts, student.Id, '2023-01-11', studentWorkLimit);
        assertAlertExists(alerts, student.Id, '2023-01-13', studentWorkLimit);
        assertAlertExists(alerts, student.Id, '2023-01-25', studentWorkLimit);
    }
}