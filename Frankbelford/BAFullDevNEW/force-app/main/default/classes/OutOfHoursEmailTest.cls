/**
 * @AUTHOR      Charlie Nash (RSSGlobal)
 * @DATE        12/07/2023
 *
 * @DESCRIPTION:
 *
 * ============================================== VERSION HISTORY ==============================================
 *
 * V1.0 - OutOfHoursEmailTest.cls created - 12/07/2023
 *
 * =============================================================================================================
 */

@IsTest
private class OutOfHoursEmailTest {

    @IsTest
    static void testOutOfHoursEmail() {

        OutOfHoursEmail.FlowInputs data = new OutOfHoursEmail.FlowInputs();

        data.bodyText = 'Test Body';
        data.subjectText = 'Test Subject';
        data.siteOwnerEmail = 'testowner@gmail.com';
        data.branchEmailAddress = 'testbranchaddress@gmail.com';

        Test.startTest();

        OutOfHoursEmail.createOutOfHoursEmail(new List<OutOfHoursEmail.FlowInputs>{data});

        Test.stopTest();

    }
}