public class BatchUserCreationHistorical implements Database.Batchable<sObject> {
    
    public Database.QueryLocator Start(Database.BatchableContext bc){
        
	 return database.getquerylocator('select id, name from OppIDForUserCreation__c');
        
    }
    public void execute (Database.BatchableContext bc,List<OppIDForUserCreation__c> customsettinglist){
        
        System.debug('customsettinglist:'+customsettinglist.size());
        Set<Id> TargetedOppIds = new Set<Id>();
        List<user> userstoinsert = new list<user>();
        Set<Id> conidsusercreated = new Set<Id>();
        Map<Id,Id> EcontoEuser = new Map<Id,Id>();
        map<String,Id> psLabeltoId = new map<String,Id>();  
        Map<Id,Id> newcontoNewuser = new Map<Id,Id>();
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> psaupdate = new List<PermissionSetAssignment>();
        list<OppIDForUserCreation__c> cstodelete = new list<OppIDForUserCreation__c>();
        date todaydate = system.today();
        
        for(OppIDForUserCreation__c csrec : customsettinglist){
            TargetedOppIds.add(csrec.name);
        }
        list<Opportunity> TargetedOppList = [select id,Expiry_Date__c,Opportunity_Contact__c,Opportunity_Contact__r.email,Opportunity_Contact__r.firstname,Opportunity_Contact__r.lastname,(select OpportunityId,product2id,product2.name from opportunitylineitems) from opportunity where Opportunity_Contact__c !=null and Id IN:TargetedOppIds ];
        System.debug('TargetedOppList:'+TargetedOppList.size());
        
        
        if(TargetedOppList.size()>0){ 
            for( User u : [select Id,contactid from user where contactid !=null]){
                EcontoEuser.put(u.ContactId,u.Id);
            }
            
            // user creation based on existing + user created from this code      
            Profile CCportalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User Clone' Limit 1];
            for(opportunity opp :TargetedOppList){
                if(!conidsusercreated.contains(opp.Opportunity_Contact__c) && !EcontoEuser.containsKey(opp.Opportunity_Contact__c)){
                    User portaluser = new User();
                    string alisan =opp.Opportunity_Contact__r.FirstName+opp.Opportunity_Contact__r.LastName;
                    if(alisan.length() >8){
                       alisan=alisan.substring(0,8); 
                    }
                    portaluser.UserName = opp.Opportunity_Contact__r.Email;
                    portaluser.FirstName = opp.Opportunity_Contact__r.FirstName;
                    portaluser.LastName = opp.Opportunity_Contact__r.LastName;
                    portaluser.Alias = alisan;
                    portaluser.email = opp.Opportunity_Contact__r.Email;
                    portaluser.ContactId = opp.Opportunity_Contact__c;
                    portaluser.ProfileId = CCportalProfile.Id;
                    portaluser.EmailEncodingKey = 'UTF-8';
                    portaluser.CommunityNickname = 'CU'+portaluser.Alias;
                    portaluser.TimeZoneSidKey = 'Europe/Dublin';
                    portaluser.LocaleSidKey = 'en_IE_EURO';
                    portaluser.LanguageLocaleKey = 'en_US';
                    userstoinsert.add(portaluser);
                    conidsusercreated.add(opp.Opportunity_Contact__c);
                }
                else{
                    if(EcontoEuser.containsKey(opp.Opportunity_Contact__c)){
                        
                       newcontoNewuser.put(opp.Opportunity_Contact__c,EcontoEuser.get(opp.Opportunity_Contact__c));
                    }
                    
                }
            }
            system.debug('newcontoNewuserbf:'+newcontoNewuser);
            system.debug('userstoinsert:'+ userstoinsert.size()+'data' +userstoinsert );
            if(userstoinsert.size()>0){
                insert userstoinsert;
                
                for(user u : userstoinsert){
                    newcontoNewuser.put(u.ContactId,u.Id);
                }
            }
            for( PermissionSet ps : [select id,label from PermissionSet where label='CompaniesAct2014.com' OR label='FRS102.com' OR label='KnowledgeHUB' 
												OR label='ARC Non Audit' OR label='ARC Premium Plus' OR label='ARC Premium']){
                psLabeltoId.put(ps.label,ps.Id);
            }
            system.debug('psLabeltoId:'+psLabeltoId.keyset().size());
            system.debug('psLabeltoId:'+psLabeltoId );
            system.debug('newcontoNewuser:'+newcontoNewuser);
            // permission set assignment
            for(opportunity opp :TargetedOppList){
                for(opportunitylineitem oli :opp.opportunitylineitems){
                    string permissionsetlabel='';
                    if(oli.product2.name.containsIgnoreCase('CompaniesAct')){
                        permissionsetlabel='CompaniesAct2014.com';                    
                    }
                    if(oli.product2.name.containsIgnoreCase('FRS102.com')){
                        permissionsetlabel='FRS102.com'; 
                    }
                    if(oli.product2.name.containsIgnoreCase('KnowledgeHUB') || oli.product2.name.containsIgnoreCase('OmniHUB')){
                        permissionsetlabel='KnowledgeHUB';
                    }
                    if(oli.product2.name.containsIgnoreCase('ARC Non Audit') || oli.product2.name.containsIgnoreCase('ARC Non-Audit')){
                        permissionsetlabel='ARC Non Audit';
                   }
                    if(oli.product2.name.containsIgnoreCase('ARC Premium Plus')){
                        permissionsetlabel='ARC Premium Plus';
                    }
                    else if(oli.product2.name.containsIgnoreCase('ARC Premium')){
                        permissionsetlabel='ARC Premium';
                    }
                      
                    
                    list<PermissionSetAssignment> Epsarec = [SELECT Id,PermissionSetId,ExpirationDate, PermissionSet.Name FROM PermissionSetAssignment WHERE  AssigneeId =:newcontoNewuser.get(opp.Opportunity_Contact__c) AND PermissionSetId =:psLabeltoId.get(permissionsetlabel)] ;
                    system.debug('permissionsetlabel:'+permissionsetlabel +Epsarec.size() +psLabeltoId.get(permissionsetlabel));
                    if(Epsarec.size()>0){
                        //update psaupdate.add
                        if(opp.Expiry_Date__c > Epsarec[0].ExpirationDate){
                          psaupdate.add(new PermissionSetAssignment (id=Epsarec[0].id ,ExpirationDate=opp.Expiry_Date__c)); 
                        }
                    }
                    else{
                        
                       psalist.add(createpsarecord(newcontoNewuser.get(opp.Opportunity_Contact__c),psLabeltoId.get(permissionsetlabel),opp.Expiry_Date__c)); 
 
                    }
                    
                }
            }
            system.debug('psalist:'+ psalist.size()+'data:' +psalist );
            if(psalist.size()>0){
                insert psalist;
            }
            system.debug('psaupdate:'+ psaupdate.size()+'data:' +psaupdate );
            if(psaupdate.size()>0){
                update psaupdate;
            }
            
            
        }
    }
    
    public void finish (Database.BatchableContext bc){
        
    }
    
    public static PermissionSetAssignment createpsarecord(id userid, id psid,datetime expdate){
        PermissionSetAssignment psa = new PermissionSetAssignment ();
        psa.AssigneeId      =userid;
        psa.PermissionSetId =psid;
        psa.ExpirationDate  =expdate;
        return psa;
    }
}