@RestResource(urlmapping='/PaymentWebservice')
global class PaymentWebservice {
    
    @HttpPost
    global static void postdata(){
        PaymentResponseWrapper prw = new PaymentResponseWrapper();
        try{
            system.debug('Event Payload:: ' + RestContext.request.requestbody.toString());
            String replaced = RestContext.request.requestbody.toString().replace('object','objectz'); 
            system.debug('replaced:'+replaced);
            prw = (PaymentResponseWrapper)System.JSON.deserialize(replaced, PaymentResponseWrapper.class);
            handledata(prw,RestContext.request.requestbody.toString());
        }
        catch(Exception e){
            // creating error log for all errors  
            system.debug('exception:'+e);
            errorlogmethod('PaymentWebservice','postdata',RestContext.request.requestbody.toString(),e.getMessage() +' at line ' +e.getLineNumber() + ' '+ e.getStackTraceString() +' : '+prw.type);
        }
    }
    
    
    public static void handledata(PaymentResponseWrapper prw,string payloaddata){
        
        account acc = new account();
        Contact con = new contact();
        list<contact> exstcon = new list<contact>();
        Opportunity opp = new Opportunity();
        OpportunityLineItem oli = new OpportunityLineItem();
        map<String,Id> psLabeltoId = new map<String,Id>();
        boolean oppexist =false;
        date expdate ;
        String getOPSSRecordTypeID = Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPSS').getRecordTypeId();
        
        //checking product exist in SF or not
        list<product2> prd = [select id, name from product2 where name=:prw.data.objectz.lines.data[0].plan.nickname];
        if(prd.size()>0){
            if(prw.data.objectz.lines.data[0].plan.interval == 'month' ){
                expdate = system.today().adddays(30+2);
            }
            if(prw.data.objectz.lines.data[0].plan.interval == 'year' ){
                expdate = system.today().adddays(365+7);
            }
            exstcon =[select id,AccountId,firstname,lastname,email,name,(select id,name,StageName,createddate from Opportunities__r where StageName='Payment Failed' order by createddate desc limit 1) from contact where email=: prw.data.objectz.customer_email limit 1];
            if(exstcon.size()==0){
                // contact not existed in sf 
                if(prw.data.objectz.customer_name == null){
                   errorlogmethod('PaymentWebservice','handledata',RestContext.request.requestbody.toString(),'Customer name is coming as :'+prw.data.objectz.customer_name);
                    return;
                }
                else{
                    List<String> splitcustname = prw.data.objectz.customer_name.split(' ');
					system.debug('splitcustname size:'+splitcustname.size());
                    acc.name=prw.data.objectz.customer_name;
                    acc.Account_Status__c='Active';
                    acc.Business_Type__c ='Website Purchase';
                    acc.OwnerId='0057Q000004U2DPQA0';  //Emma Kehoe
                    insert acc;
                    system.debug('accid:'+acc.Id);
                    
                    con.AccountId=acc.Id;
                    con.firstname=splitcustname.size()==1?null:splitcustname[0];
                    con.LastName= splitcustname.size()==1?prw.data.objectz.customer_name:splitcustname[1];
                    con.Email=prw.data.objectz.customer_email;
                    con.Phone = prw.data.objectz.customer_phone;
                    con.OwnerId='0057Q000004U2DPQA0';
                    if (prw.data.objectz.customer_address != null) {
                        if(prw.data.objectz.customer_address.line1 !=null ){
                            con.MailingStreet =prw.data.objectz.customer_address.line1;
                        }
                        if(prw.data.objectz.customer_address.line2 !=null ){
                            con.MailingStreet =prw.data.objectz.customer_address.line2;
                        }
                        if(prw.data.objectz.customer_address.line2 !=null && prw.data.objectz.customer_address.line1 !=null ){
                            con.MailingStreet =prw.data.objectz.customer_address.line1 + prw.data.objectz.customer_address.line2; 
                        }
                        con.MailingState = prw.data.objectz.customer_address.state!=null? prw.data.objectz.customer_address.state:'' ;
                        con.MailingCity = prw.data.objectz.customer_address.city!=null? prw.data.objectz.customer_address.city:'' ;
                        con.MailingCountry=prw.data.objectz.customer_address.country!=null? prw.data.objectz.customer_address.country:'' ;
                        con.MailingPostalCode=prw.data.objectz.customer_address.postal_code!=null? prw.data.objectz.customer_address.postal_code:'';
                    }
                    insert con;
                    system.debug('conactins id:'+con.Id);
                }
            }
            // when contact created or exists in sf 
            if(exstcon.size() >0){
                system.debug('exstcon:'+exstcon);
                system.debug('exstcon[0].Opportunities.size():'+exstcon[0].Opportunities__r.size());
                con=exstcon[0];
                // when opp existed with failsed payment status 
                if(prw.type=='invoice.payment_succeeded' && exstcon[0].Opportunities__r.size() >0 && exstcon[0].Opportunities__r[0].name.contains(prw.data.objectz.lines.data[0].plan.nickname)){
                   system.debug('existing inside');
                    oppexist =true;
                    opp.Id = exstcon[0].Opportunities__r[0].id;
                    opp.StageName='Closed Won';
                    expdate = date.valueof(exstcon[0].Opportunities__r[0].createddate);
                    update opp;
                }
            }
            
            system.debug('oppexist:'+oppexist);
            if(oppexist == false){
            
            opp.RecordTypeId= getOPSSRecordTypeID; 
            opp.AccountId = exstcon.size()==0 ? acc.Id:exstcon[0].AccountId;
            opp.Opportunity_Contact__c =exstcon.size()==0?con.Id:exstcon[0].id;
            opp.Name= prw.data.objectz.lines.data[0].plan.nickname + ' '+ system.today();
            if(!test.isrunningtest()) {opp.Invoice_No_Required__c=true;}
            opp.CloseDate=system.today();
            opp.StageName= prw.type=='invoice.payment_failed'? 'Payment Failed' :'Closed Won';
            opp.Amount=amountcorrection(prw.data.objectz.lines.data[0].amount_excluding_tax);
            opp.Expiry_Date_New__c = expdate;
            opp.Payment_Method__c='Stripe Auto';
            if(prw.data.objectz.lines.data[0].plan.nickname.contains('HUB')){
                opp.Total_Time__c=180;
                
            }
            insert opp;
            system.debug ('oppinset id:====='+opp.id);
            
            PricebookEntry pbe = [
                SELECT Id 
                FROM PricebookEntry 
                WHERE Pricebook2.Name = 'Standard Price Book' 
                AND Product2Id = :prd[0].Id
                LIMIT 1
            ];
            oli.OpportunityId=opp.Id;
            oli.Product2Id=prd[0].id;
            oli.PricebookEntryId =pbe.Id;
            oli.Description=prw.data.objectz.lines.data[0].plan.nickname;
            oli.Quantity=1;
            oli.UnitPrice=opp.Amount;
            insert oli;
            system.debug('oliinserted id:===='+oli.Id);
            }
            system.debug('prw.type:'+prw.type );
            system.debug('con.FirstName:'+con.FirstName);
            system.debug('con.Name:'+con.Name);
            if(prw.type=='invoice.payment_succeeded'){
                
                list<User> PU = [select id from user where contactid=:con.id LIMIT 1];
                User portaluser = new User();
                if( PU.size()==0){
                    Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User Clone' Limit 1];
                    portaluser.UserName = con.Email;
                    portaluser.FirstName = con.FirstName!=null?con.FirstName:'';
                    portaluser.LastName = con.LastName;
                    portaluser.Alias = con.FirstName!=null?con.FirstName.substring(0,3)+con.LastName.substring(0,3):con.LastName;
                    portaluser.email = con.Email;
                    portaluser.ContactId = con.id;
                    portaluser.ProfileId = portalProfile.Id;
                    portaluser.EmailEncodingKey = 'UTF-8';
                    portaluser.CommunityNickname = 'CU'+portaluser.Alias;
                    portaluser.TimeZoneSidKey = 'Europe/Dublin';
                    portaluser.LocaleSidKey = 'en_IE_EURO';
                    portaluser.LanguageLocaleKey = 'en_US';
                    
                    insert portaluser;
                    system.debug('after portaluser inserted:===='+portaluser);
                }
                Id Userid = PU.size()==0?portaluser.Id:PU[0].Id;
                
                for( PermissionSet ps : [select id,label from PermissionSet where LicenseId =null]){
                    psLabeltoId.put(ps.label,ps.Id);
                }
                
                
                // Assigning permission sets
                if(prd[0].name.contains('CompaniesAct2014.com') || prd[0].name.contains('OmniHUB Ultimate')){
                    system.debug('matched 2 :CompaniesAct2014.com');
                    createpsarecord(Userid,psLabeltoId.get('CompaniesAct2014.com'),expdate); 
                    con.CompaniesAct2014_com_Member__c=true;
                }
                
                if(prd[0].name.contains('FRS102.com') || prd[0].name.contains('OmniHUB Ultimate')){
                    system.debug('matched 3 :FRS102.com');
                    createpsarecord(Userid,psLabeltoId.get('FRS102.com'),expdate); 
                    con.FRS102_com_Member__c=true;
                }
                if(prd[0].name.contains('KnowledgeHUB') || prd[0].name.contains('HUB')){
                    system.debug('matched 4 :KnowledgeHUB');
                    createpsarecord(Userid,psLabeltoId.get('KnowledgeHUB'),expdate); 
                    con.KnowledgeHUB_Member__c=true;
                }
                if(prd[0].name.contains('ARC Non Audit')){
                    system.debug('matched 1 :ARC Non Audit');
                    createpsarecord(Userid,psLabeltoId.get('ARC Non Audit'),expdate); 
                    con.Accountants_Resource_Centre__c=true;
                }
                if(prd[0].name.contains('ARC Premium Plus')){
                    system.debug('matched 5:ARC Premium Plus');
                    createpsarecord(Userid,psLabeltoId.get('ARC Premium Plus'),expdate);
                    con.Accountants_Resource_Centre__c=true;
                    
                }
                else if(prd[0].name.contains('ARC Premium')){
                    system.debug('matched 6:ARC Premium');
                    createpsarecord(Userid,psLabeltoId.get('ARC Premium'),expdate);
                    con.Accountants_Resource_Centre__c=true;
                }
                system.debug('before con update:'+con);
                update con;
            }
            
        }
        else{
            // adding error log for product not found in sf
            errorlogmethod('PaymentWebservice','handledata',RestContext.request.requestbody.toString(),'Product not found in salesforce :-'+prw.data.objectz.lines.data[0].plan.nickname);
        }
        
    }
    
    public static decimal amountcorrection(decimal totamt){
        
        String numberStr = String.valueOf(totamt);
        Integer length = numberStr.length();
        
        String resultStr = numberStr.substring(0, length - 2) + '.' + numberStr.substring(length - 2);
        
        Decimal resultDecimal = Decimal.valueOf(resultStr);
        System.debug('Result Decimal: ' + resultDecimal); 
        
        
        return resultDecimal;
    }
    
    @future
    public static void createpsarecord(id userid, id psid,datetime expdate){
        list<PermissionSetAssignment> psatoupsert = new list<PermissionSetAssignment>();
        PermissionSetAssignment psa = new PermissionSetAssignment ();
        list<PermissionSetAssignment> Epsarec = [SELECT Id,PermissionSetId,ExpirationDate, PermissionSet.Name FROM PermissionSetAssignment WHERE  AssigneeId =:userid AND PermissionSetId =:psid ALL ROWS] ;
        
        if(Epsarec.size()>0 ){
            if(expdate > Epsarec[0].ExpirationDate || Epsarec[0].ExpirationDate==null){
                psa.id =Epsarec[0].id; 
                psa.ExpirationDate  =expdate;
                psatoupsert.add(psa);
            }
            
        }
        else{
            psa.AssigneeId      =userid;
            psa.PermissionSetId =psid;
            psa.ExpirationDate  =expdate;
            psatoupsert.add(psa);
        }
        
        if(psatoupsert.size()>0){
            upsert psatoupsert;
        }
    }
    
    public static void errorlogmethod(string apexclass, string method, string responsebody, string errmsg){
        
        Error_log__c elo = new Error_log__c();
        elo.Apex_Class__c=apexclass;
        elo.Method__c=method;
        elo.Response_Body__c=responsebody;
        elo.Error_Message__c=errmsg;
        insert elo;
    }
}