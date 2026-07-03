trigger RateCardDeletePage on sirenum__Rate_Card_Page__c (before delete) {
    
    List<String> profileList = new List<String>();
    User user = [Select id , ProfileId, Profile.Name from User where Id=:UserInfo.getUserId()];
    
    for(ProfilesUsed__c profileUsed : ProfilesUsed__c.getall().values()){
        profileList.add(profileUsed.Name);
    }
  
    if(Trigger.IsDelete && !profileList.isEmpty() &&  profileList.contains(user.Profile.Name)){
            
        for(sirenum__Rate_Card_Page__c rt: [select Id, Name,sirenum__SortOrder__c, 
                                        sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c 
                                        from sirenum__Rate_Card_Page__c  WHERE Id IN :Trigger.oldMap.KeySet()]){
            
    //     if( rt.sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c == false && rt.Name=='Default'){ * defect -10275
            if(!rt.sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c && (rt.Name.equals(Label.Default) || rt.sirenum__SortOrder__c==0)){
                Trigger.oldMap.get(rt.Id).adderror(Label.RateCardErrorMessage);    
            }            
        }            
    }
}