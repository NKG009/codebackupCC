Public class HomePageTilecont {
    @AuraEnabled
    Public static String getuserId()
    {
         String userId = UserInfo.getUserId();
       
        return userId;
    }

}