public without sharing class PortfolioViewerController {

    @AuraEnabled
    public static PortfolioWrapper getMyPortfolio(String aUsrId, String aDefaultUsrId){

        String usr1 = null;
        User tmp1 = [SELECT Id, UserType FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        if('PowerCustomerSuccess'.equalsIgnorecase(tmp1.UserType)){
            usr1 = aUsrId;            
        }
        else{
            usr1 = aDefaultUsrId;
        }

        PortfolioWrapper myPortfolio = new PortfolioWrapper();
        Id currentUsrId = null;        
        Set<Id> usrIdSet = new Set<Id>();
        if(String.isblank(usr1)){
            currentUsrId = UserInfo.getUserId();            
            usrIdSet.add(UserInfo.getUserId());
        }
        else{
            currentUsrId = usr1;            
            usrIdSet.add(usr1);
        }
        Contact currentCon = null;        
        List<User> usrList =  UserTriggerHelper.getUsersById(usrIdSet);
        Map<Id, Id> userMap = new Map<Id, Id>();
        for(User usr : usrList){
            if(usr.Contact != null
            && usr.Contact.AccountId != null){
                userMap.put(usr.Contact.AccountId, usr.Id);
            }
            if(usr.Id == currentUsrId){
                currentCon = usr.Contact;
            }
        }
        System.debug('UserID' + userMap.keySet() );

        if(!userMap.isEmpty()){ 
            Map<String, Decimal> portfolioMap = new Map<String, Decimal>();
            Set<String> propertyManagerSet = new Set<String>();
            Decimal total = 0;
            for(AccountContactRelation acr :  [SELECT Contact.Name, 
                                                      ComplianceMaintainedBy__c 
                                                FROM AccountContactRelation  
                                                WHERE Contact.AccountId =: userMap.keySet()
                                                  AND IsActive = true
                                                  AND Account.Archived__c = FALSE
                                                  AND Roles INCLUDES('Property Manager')]){                                                    
                if(acr.ComplianceMaintainedBy__c != null){    
                    String key = acr.Contact.Name + '_' + acr.ComplianceMaintainedBy__c;                          
                    if(portfolioMap.get(key) == null){
                        portfolioMap.put(key, 0);
                    }                                     
                    portfolioMap.put(key, portfolioMap.get(key) + 1);  
                }
                String key2 = acr.Contact.Name;             
                if(portfolioMap.get(key2) == null){
                    portfolioMap.put(key2, 0);
                }                                              
                portfolioMap.put(key2, portfolioMap.get(key2) + 1);           
                if(acr.Contact.Name != null){
                    propertyManagerSet.add(acr.Contact.Name);
                }
                total += 1;
            }

            for(String propertyManager : propertyManagerSet){  
                try{
                    Decimal propertyService360Value = (Decimal) portfolioMap.get(propertyManager + '_Property Services 360');
                    Decimal propertyService360Total = (Decimal) portfolioMap.get(propertyManager);
                    if(propertyService360Value == null){
                        propertyService360Value = 0;
                    }
                    if(propertyManager == currentCon.Name){
                        myPortfolio.value = propertyService360Value;
                        myPortfolio.total = propertyService360Total;
                        myPortfolio.percentage = myPortfolio.value.divide(myPortfolio.total, 2, System.RoundingMode.HALF_EVEN) * 100;                       
                    }
                    else{
                        myPortfolio.myPortfolioList.add(new PortfolioWrapper(propertyManager, propertyService360Value, propertyService360Total));
                    }
                }catch(Exception e){
                    System.debug('error: ' + e.getLineNumber() + ' : ' + e.getMessage());
                }
            }
            System.debug('myPortfolioList: ' + myPortfolio.myPortfolioList);

            try{
                myPortfolio.teamValue = myPortfolio.value;
                myPortfolio.teamTotal = myPortfolio.total;
                for(PortfolioWrapper myPortfolio1 : myPortfolio.myPortfolioList){
                    myPortfolio.teamValue += myPortfolio1.value;
                    myPortfolio.teamTotal += myPortfolio1.total; 
                }
                System.debug('teamValue: ' + myPortfolio.teamValue);
                System.debug('teamTotal: ' + myPortfolio.teamTotal);
                myPortfolio.teamPercentage = myPortfolio.teamValue.divide(myPortfolio.teamTotal, 2, System.RoundingMode.HALF_EVEN) * 100;            
                myPortfolio.teamMessage = myPortfolio.teamValue + ' / ' + myPortfolio.teamTotal;
            }catch(Exception e){
                System.debug('error: ' + e.getLineNumber() + ' : ' + e.getMessage());
            }                
  
        }  
        return myPortfolio;
    }        

    public static List<AccountContactRelation> getAccountContactRelationshipsByContactAccountId(Set<Id> aAccIdSet, String aRole){
        return [
            SELECT 
                Id,
                AccountId,
                Account.Name,
                ContactId,
                Contact.Name,
                Contact.AccountId,
                Contact.Account.Name,
                IsActive
            FROM AccountContactRelation 
            WHERE Contact.AccountId =: aAccIdSet            
              AND IsActive = true
              AND Roles =: aRole ORDER BY Contact.Name ASC
        ];
    }       
    
}