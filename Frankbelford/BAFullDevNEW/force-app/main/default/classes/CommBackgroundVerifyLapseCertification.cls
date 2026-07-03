public class CommBackgroundVerifyLapseCertification {
  
  private static final string LAPSED_STATUS = 'Lapsed';
  private static final string CURRENT_STATUS = 'Current';
  
    @AuraEnabled
    public Static String getCertificationVerified(String certificationId){
    Certification__c certification = [Select id,Verfied__c,RecordTypeId,Community_Background__c, 
                          Method_of_Determination__c,SOC__c,IP_Status__c 
                          from Certification__c where Id=:certificationId];
    try{       
      string rectypename= Schema.getGlobalDescribe().get('ts2__Certification__c').getDescribe().getRecordTypeInfosById().get(certification.RecordTypeId).getName();
      if(LAPSED_STATUS.equals(certification.IP_Status__c)){
        return Label.LapseCertificationVerifiedErrorMessage;        
      }
      else if(CURRENT_STATUS.equals(certification.IP_Status__c) && certification.Verfied__c){
        return Label.CertificationAlreadyVerified;
      }
      else if(String.IsBlank(certification.Community_Background__c) && rectypename =='Community Background Check (NI Only)'){
        return Label.CommunityBackgroundMandatory;
      }
      else if(String.IsBlank(certification.Method_of_Determination__c) && rectypename =='Community Background Check (NI Only)'){
        return Label.MODMandatory;
      }
      else if(String.IsBlank(certification.SOC__c) && rectypename =='Community Background Check (NI Only)'){
        return Label.SOCMandatory;
      }
      else{
        certification.IP_Status__c = 'Current';
        certification.Verfied__c = true;
        certification.Verfied_Record__c = UserInfo.getFirstname() + ' ' + UserInfo.getLastname() + ' ' +System.Now();
        update certification;
        return Label.CertificationVerifiedMessage;
      }
    }
    catch(Exception e){
      String message = 'Update failed. First exception on row 0 with id '+certification.id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION,';
      if(e.getmessage().contains(message)){message = e.getmessage().substringAfter(message);
        if(e.getmessage().contains(': []')){ message = message.substringBefore(': []');
        }
        return message;
      }
      else{
        return Label.CertificationErrorMessage;
      }
    }
    }
  
  @AuraEnabled
    public Static String getCertificationLapsed(String certificationId){
    try{
      Certification__c certification = [Select id,IP_Status__c 
                          from Certification__c where Id=:certificationId]; 
      system.debug('+++++++++++'+certification.IP_Status__c);
      //if(LAPSED_STATUS.equals(certification.IP_Status__c)){
      if(!CURRENT_STATUS.equals(certification.IP_Status__c)){
        return Label.VerifiedCertificationLapsedErrorMessage;
      }
      else{
        certification.IP_Status__c = 'Lapsed';
        update certification;
        system.debug('+++++++++++'+certification.IP_Status__c);
        return Label.CertificationLapseMessage;
      }
    }
    catch(Exception e){
      return Label.CertificationErrorMessage;
    }
    }
}