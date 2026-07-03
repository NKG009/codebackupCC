/**
 * @AUTHOR      Charlie Nash (RSSGlobal)
 * @DATE        12/07/2023
 *
 * @DESCRIPTION:
 *
 * ============================================== VERSION HISTORY ==============================================
 *
 * V1.0 - OutOfHoursEmail.cls created - 12/07/2023
 *
 * =============================================================================================================
 */

public class OutOfHoursEmail {

    public class FlowInputs {

        @InvocableVariable
        public string bodyText;
        @InvocableVariable
        public string subjectText;
        @InvocableVariable
        public string siteOwnerEmail;
        @InvocableVariable
        public string branchEmailAddress;

    }

    @InvocableMethod(Label='Send an Out of Hours Email')
    public static void createOutOfHoursEmail (List<FlowInputs> inputs){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //Out of hours email is set in a custom label.
        OrgWideEmailAddress orgEmailAddressId = [SELECT id,Address from OrgWideEmailAddress where address='no.reply@bluearrow.co.uk'];
        email.setOrgWideEmailAddressId(orgEmailAddressId.Id);
        email.setToAddresses(new String[] {Label.OutOfHoursBlueArrowEmail});
        email.setCcAddresses(new String[] {inputs[0].siteOwnerEmail,inputs[0].branchEmailAddress});
        //email.setSenderDisplayName('Job Science');
        email.setsubject(inputs[0].subjectText);
        String body = inputs[0].bodyText;
        email.setHtmlBody(body);
        Messaging.SendEmailResult [] mrs = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        for (Messaging.SendEmailResult mr : mrs) {
            if (mr.isSuccess()) {
                System.debug('Email Sent Successfully');
            }  else {
                // Operation failed, so get all errors                
                for(Messaging.SendEmailError err : mr.getErrors()) {
                    System.debug('fields that affected this error: ' + err.getMessage()+'???'+err.getFields());
                }
            }
		}

    }


}