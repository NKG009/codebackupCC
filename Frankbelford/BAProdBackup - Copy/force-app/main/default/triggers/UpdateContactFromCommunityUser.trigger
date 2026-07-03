trigger UpdateContactFromCommunityUser on User (after update) {
    //We only want to run on the single item that the user edited 
    Id clientPortalUserProfileId = User_Profile_Id__c.getValues(System.Label.Client_Portal_User_Profile).Profile_Id__c;
    Id workerPortalProfileId = User_Profile_Id__c.getValues(System.Label.Candidate_Portal_User_Portal).Profile_Id__c;

    System.debug('@@Profile Name*** '+clientPortalUserProfileId);
    Boolean MStreet = false;
    Boolean MCity = false;
    Boolean MState = false; 
    Boolean Mcountry = false;
    Boolean MPCode = false;
    Boolean Ph = false;
    Boolean Mph = false;
    Boolean fname = false;
    Boolean lname = false;
    Boolean titl = false;
    Boolean eml = false;
    
    if (Trigger.isUpdate && Trigger.new.size()==1 && (userinfo.getProfileId()==clientPortalUserProfileId || userinfo.getProfileID()==workerPortalProfileId))
    { 
    for(User us: Trigger.new)
    {
        User olduser = Trigger.oldMap.get(us.ID);
        if(us.Street != olduser.Street )
        { MStreet = true; }
        if(us.City != olduser.City )
        {MCity = true;}
        if(us.State != olduser.State )
        {MState = true;}
        if(us.Country != olduser.Country)
        {Mcountry = true;}
        if(us.PostalCode != olduser.PostalCode )
        {MPCode = true;}
        if(us.Phone != olduser.Phone)
        {ph= true;}
        if(us.MobilePhone != olduser.MobilePhone) 
        {Mph = true;}
        if(us.FirstName != olduser.FirstName) 
        {fname = true;}
        if(us.LastName != olduser.LastName) 
        {lname = true;}
        if(us.Title != olduser.Title) 
        {titl = true;}
    if(us.Email != olduser.Email) 
        {eml = true;}
 
  
     }
        User u = Trigger.new[0];
        System.debug('In UpdateContactFromCommunityUser Trigger u=== ' + u);
        //And only if it's a portal user 
        if (u.ContactId!=null && (MStreet == True || MCity  == True || MState == True || Mcountry  == True || MPCode == True ||  ph == True || Mph ==True || fname == True || lname == True || titl == True || eml == True)) { 
            UpdateContactFromCommunityClass.updateContacts(u.Id,MStreet,MCity,MState,Mcountry,MPCode,ph,Mph,fname,lname,titl,eml   ); 
        } 
    }
if(Trigger.isUpdate)
    {
        Set<id> Userid = new Set<id>();      
        for(User u: Trigger.new)
        {
        user olduser = Trigger.oldMap.get(u.Id);
            if(olduser.IP_PassToTempest__c== FALSE && u.IP_PassToTempest__c == TRUE)
            {
                Userid.add(u.id);
            }
        }
        System.debug('check userID'+Userid);
        if(!UserID.isEmpty())
        {

            UserProcessupdate.senduserdata(Userid);
          
        }
    }   
}