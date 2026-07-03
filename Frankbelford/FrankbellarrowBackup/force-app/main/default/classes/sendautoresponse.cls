public class sendautoresponse {
    public static void sendmail(Set<id> sendapp){

        Id templateId;
        //Email_Template_Mapping__mdt
        //templateId = [select id, name from EmailTemplate where developername = 'Auto_Responder_e_mail'].id;
        Map<String, String> brandTemplate = new Map<String, String>();
        for(Email_Template_Mapping__mdt etm : [SELECT TemplateId__c, Brand_Logo__c, Brand__r.Label
                                                FROM Email_Template_Mapping__mdt
                                                WHERE Label = 'Auto rejection e-mail']){
            brandTemplate.put(etm.Brand__r.Label, etm.TemplateId__c);
        }
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(ts2__Application__c a: [Select id,ts2__Candidate_Contact__c,ts2__Candidate_Contact__r.Email, ts2__PrimaryRecruiter__r.Brand__c
                                        from ts2__Application__c where id in:sendapp]) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(brandTemplate.get(a.ts2__PrimaryRecruiter__r.Brand__c));
            mail.setTargetObjectId(a.ts2__Candidate_Contact__c);
            mail.setWhatid(a.id);
            mail.setSaveasActivity(true);
            emailList.add(mail);
        }
        if(emailList.size() > 0) {
            Messaging.sendEmail(emailList);
        }
    }
}