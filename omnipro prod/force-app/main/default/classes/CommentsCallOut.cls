public class CommentsCallOut {
    
    public static void basicAuthCallout(List<Integer> ticketNumbers){  //460969 ,  last titket number 473082
        String jsonString = null;
        String firstReplacement = null;
        String secondReplacement = null;
        String thirdReplacement = null;
        Map<Id, Case> csMap;
        List<String> bdyStr;
        CommentsCallOutWrapper commentWR = null;
        try{
            
            List<Case> caseList = new List<Case>();
            List<ZD_Exception__c> zdNoRecList = new List<ZD_Exception__c>();
            for(Integer zendeskId : ticketNumbers){
                Case c = new Case();
                Decimal zdId = zendeskId;
                String tktDetailsResponse = TicketDetailsResponse.response(zdId);//it has respose from endpoint
                String postFromReplacement = tktDetailsResponse.replace('from', 'from1');
                System.debug(postFromReplacement);
                
                if(!postFromReplacement.contains('RecordNotFound')){
                    Map<String, Object> parsedJson = (Map<String, Object>)JSON.deserializeUntyped(postFromReplacement);
                    String ticketChannel = '';
                    String groupId = null;
                    String sub = null;
                    String status = null;
                    Id recordTypeID = null;
                    String reqId = null;
                    String RecordtypeName=null;
                    String brandId=null;
                    if (parsedJson.containsKey('ticket')) {
                        Map<String, Object> ticketDetails = (Map<String, Object>)parsedJson.get('ticket');
                        
                       // Collect tags safely with explicit casting
					    List<Object> tagsRaw = (List<Object>) ticketDetails.get('tags');
					    List<String> tags = new List<String>();
    
					  
                       
                        if(ticketDetails.get('subject') != null){
                            sub = (string)ticketDetails.get('subject');
                        }
                        if(ticketDetails.get('status') != null){
                            status = (string)ticketDetails.get('status');
                        }
                        
                        if(ticketDetails.get('requester_id') != null){
                            reqId = String.valueOf(ticketDetails.get('requester_id'));
                        }
                        if(ticketDetails.get('brand_id') != null){
                            brandId = String.valueOf(ticketDetails.get('brand_id'));
                            System.debug('brandId==>'+brandId);
                        }
                        
                    }
                    If(brandId=='360001203432'){
                        RecordtypeName='Knowledge Hub';
                    }
                    else If(brandId=='7651505943197'){
                        RecordtypeName='CPDStore IE';
                    }
                    else If(brandId=='7651544743325'){
                        RecordtypeName='CPDStore UK';
                    }
                    else If(brandId=='360000067012'){
                        RecordtypeName='OmniPro';
                    }
                    
                    
                    
                    
                    recordTypeID = [SELECT Id, Name FROM RecordType where name=:RecordtypeName].id;
                    c.OwnerId = [Select id,Name From User where Name ='Cathriona Bennett'].id;
                    System.debug('OwnerId==>'+c.OwnerId);
                     System.debug('recordTypeID==>'+recordTypeID);
                    Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(postFromReplacement);
                    System.debug(data);
                    Map<String, Object> ticket = (Map<String, Object>)data.get('ticket');
                    System.debug(ticket);
                    jsonString = ZendeskTicketCommentCallOutResponse.response(String.valueOf(zdId));//it has respose from endpoint
                    firstReplacement = jsonString.replace('public', 'isPublic');    
                    secondReplacement = firstReplacement.replace('from', 'from1');
                    thirdReplacement = secondReplacement.replace('system', 'systemDetails');
                    System.debug(thirdReplacement);
                    commentWR = (CommentsCallOutWrapper)JSON.deserialize(thirdReplacement, CommentsCallOutWrapper.class);
                    
                    csMap = new Map<Id, case>();
                    bdyStr = new List<String>();
                    //
                    System.debug('subject =>  '+sub);
                    System.debug('status =>  '+status);
                    System.debug('group id => '+groupId);
                    System.debug('requester id on contact => ' +reqId);
                    System.debug('recordtype id on account => ' +recordTypeID);
                       
                    
                    Id acc = null;
                   
                    Id con = null;
                    List<Contact> conObj = [select id,AccountId, Zendesk_Id__c from Contact Where Zendesk_Id__c =: String.valueOf(reqId)];
                    System.debug('Contact  ===>>>  '+conObj);
                    if(!conObj.isEmpty() && !String.isBlank(String.valueOf(reqId))){
                        System.debug('inside !conObj.isEmpty()');
                        con = conObj[0].id;
                        acc = conObj[0].AccountId;
                        System.debug('existing contact  ==>>   '+conObj[0].id);
                    }else if(reqId != null && conObj.isEmpty()){
                        System.debug('AT 125');
                        String conJson = TicketContactDetails.contactDetail(reqId);
                        String conName;
                        String conEmail;
                        if(!conJson.contains('RecordNotFound')){  
                            Map<String, Object> parsed =  (Map<String, Object>)JSON.deserializeUntyped(conJson);
                            Map<String, Object> conDetails = (Map<String, Object>)parsed.get('user');//(Map<String, Object>)parsedJson.get('ticket');
                            conName = (String)conDetails.get('name');
                            conEmail = (String)conDetails.get('email');
                            System.debug('NAME  ==>>  '+conName);
                            System.debug('EMAIL  ==>>  '+conEmail);
                            System.debug(!String.isBlank(conName));
                            List<Contact> conNameList;
                            List<Contact> conEMailList;
                            if(!String.isBlank(conName)){
                                conNameList = [Select id, Name, AccountId from Contact where Name =: conName];
                                System.debug('conList  ==>>   '+conNameList);
                                if(!conNameList.isEmpty()){
                                    con = conNameList[0].id;
                                    acc = conNameList[0].AccountId;
                                    System.debug('conList[0].id  ==>>   '+conNameList[0].id);
                                }
                            } 
                            if(!String.isBlank(conEmail)){
                                System.debug('AT 192  ==>>  '+con);
                                if(con == null){
                                    conEMailList = [Select id,AccountId, Email from Contact where Email =: conEmail];
                                    if(!conEMailList.isEmpty()){
                                        con = conEMailList[0].id;
                                        acc = conEMailList[0].AccountId;
                                        System.debug('conList[0].id  ==>>   '+conEMailList[0].id);
                                    }
                                }
                            }
                 
                        }else{
                            con = null;
                            acc = null;
                        }
                    }
                    if(status != null){
                        if(status=='closed'){
                            c.Status = 'Closed - Complete';
                            System.debug('status  ==>>  '+ c.Status);
                        }
                        else{
                            c.Status = status;
                        System.debug('status  ==>>  '+ c.Status);
                        }
                      
                    }
                   
                    if(sub != null){
                        c.Subject = sub;
                        System.debug('c.Subject  ==>>  '+ c.Subject);
                    }
                    if(con != null){
                        c.ContactId = con;
                        
                        System.debug('c.ContactId  ==>>  '+ c.ContactId);
                    }
                    System.debug('acc id 244 ==  '+acc);
                    if(acc != null){
                        c.AccountId = acc;
                        System.debug('c.AccountId  ==  '+c.AccountId);
                    }
                    if(recordTypeID != null){
                        c.RecordTypeId = recordTypeID;
                        System.debug('c.RecordTypeId   ==>>  '+c.RecordTypeId );
                    }

                    c.Zendesk_Ticket_Id__c = String.valueOf(zdId);
                    
                
                       
            
                integer i = 0;
                
                    if(zendeskId == Integer.valueOf(c.Zendesk_Ticket_Id__c)){
                        for(CommentsCallOutWrapper.comments com : commentWR.comments){
                            if(com.html_body != null){
                                i++;
                                CommentsCallOutWrapper.via v =  com.via;
                                CommentsCallOutWrapper.source s = v.source;
                                CommentsCallOutWrapper.from1 frm = s.from1;
                                if(v.channel == 'voice'){
                                    String str = com.html_body+'<b>'+' From : '+frm.formatted_phone +'</b>'+'<hr>';
                                    bdyStr.add(str);
                                    c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                    
                                    
                                }
                                if(v.channel == 'web'){
                                    String str = com.html_body+'<b>'+' Via Channel Web '+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                    c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                }
                                if(v.channel == 'email'){
                                    String str = com.html_body+'<b>'+' From : '+frm.address+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                    c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                }
                                if(v.channel == 'api'){
                                    String str = com.html_body+'<b>'+' Via Channel Api'+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                    c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                }
                                if(v.channel == 'sms'){
                                    String str = com.html_body+'<b>'+' Via Channel SMS'+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                    c.Zendesk_Comments__c = String.join(bdyStr, '\n');                                }
                                if(v.channel == 'mobile'){
                                    String str = com.html_body+'<b>'+' Via Channel Mobile'+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                   c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                }
                                if(v.channel == 'chat'){
                                    String str = com.html_body+'<b>'+' Via Channel Chat'+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                    c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                }
                                if(v.channel == 'system'){
                                    String str = com.html_body+'<b>'+' Via Channel System'+'</b>'+'<hr>';
                                    bdyStr.add(str);
                                   c.Zendesk_Comments__c = String.join(bdyStr, '\n');
                                }
                            }
                            System.debug('Comment count ==== '+i);
                            
                             List<String> contentUrls = new List<String>();
                            System.debug('Attachments ==== '+com.attachments);
                            for(CommentsCallOutWrapper.attachments a : com.attachments){
                                System.debug('Attachments ==== '+a.content_url);
                            String str = a.content_url;
                            contentUrls.add(a.content_url);     
                                c.Zendesk_Attachments__c = String.join(contentUrls, '\n');
                        }
                        
                        
                            
                           
                           
                        
                        }
                    } 
                    if(c.ContactId != null){
                        caseList.add(c);
                    }
                
                    System.debug('inside for loop   ==>>   '+caseList);
                }
            }
            System.debug('caseList  ==>>  '+caseList);
            if(!caseList.isEmpty()){
                insert caseList;
            } 
        }catch(Exception e){
            if(e.getMessage() != null){
                System.debug(e.getMessage());
                Decimal zdId = ticketNumbers[0];
                System.debug('Exception Zendesk Id  :: '+zdId);
                ZD_Exception__c zdException = new ZD_Exception__c();
                String zd = String.valueOf(zdId);
                zdException.Name = zd;
                if(e.getMessage().contains('Unrecognized token')){
                    zdException.Description__c = 'Record Not Found for '+zdId;
                }else{
                    zdException.Description__c = e.getMessage();
                }
                insert zdException;
                System.debug('Zd exception record :: '+zdException);
            }  
        }
    }
    
}