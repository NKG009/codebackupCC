global class Five9ReportingAutomation implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Messaging.InboundEmail.BinaryAttachment[] tAttachments = email.binaryAttachments; // // Since Attachment is CSV we are taking as BinaryAttachments. 
        list<Five9_Call_Data__c> lstFive9_Call_Data = new list<Five9_Call_Data__c>(); // list of Five9.
        String csvbody='';
        
        list<list<String>> allFields = new list<list<String>>(); // list of rows in csv
        list<String> lines = new list<String>(); // Rows of CSV
        list<String> headers = new list<String>(); // Field names   
        list<String> fields = new list<String>(); // list of fields 
        
        if(tAttachments !=null){
            for(Messaging.InboundEmail.BinaryAttachment btt : tAttachments){
                if(btt.filename.endsWith('.csv')){
                    csvbody = btt.body.toString();//Take the blob body of the CSV binary attachment and extract it to a string object, then process it.
                    try {                                                
                        // Replace instances where a double quote begins a field containing a comma    
                        // In this case you get a double quote followed by a doubled double quote    
                        // Do this for beginning and end of a field 
                        csvbody = csvbody.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
                        // now replace all remaining double quotes - we do this so that we can reconstruct    
                        // fields with commas inside assuming they begin and end with a double quote 
                        csvbody = csvbody.replaceAll('""','DBLQT');
                        csvbody = csvbody.replace('"ALTSales - Support Call - Ops, CSSS, Collections"','ALTSales - Support Call - Ops CSSS Collections');                                              
                        csvbody = csvbody.replace('"ALTSales - Accepted - Customer was happy, no issues"','ALTSales - Accepted - Customer was happy no issues');  
                                          
                        lines = csvbody.split('\n');
                    }catch (System.listException e){
                        System.debug('Limits exceeded?' + e.getMessage());
                    }
                }
            }
            
            integer rowNumber = 0;
            
            for(String line : lines) {
                // check for blank CSV lines (only commas) 
                if (line.replaceAll(',','').trim().length() == 0) break;
                fields = line.split(',', -1);
                allFields.add(fields);
                if(rowNumber == 0){
                    // for getting the field names. 
                    for(list<String> rows : allFields){    
                        for(String header : rows){
                            headers.add(String.valueof(header.trim()));
                        }   
                        break;
                    }
                    
                    rowNumber++;
                    continue;
                }
                
            }
            
            for(Integer i = 1 ; i < lines.size() ; i++){
                Five9_Call_Data__c a = new Five9_Call_Data__c();
                a.put('DATE__c' , allFields[i][0]);
                a.put('HALF_HOUR__c' , allFields[i][1]);
                a.put('ABANDONED1__c' , allFields[i][2]);
                a.put('ANI__c' , allFields[i][3]);
                a.put('CALL_ID__c' , allFields[i][4]);
                a.put('CALL_TYPE__c' , allFields[i][5]);
                a.put('CALLS1__c' , allFields[i][6]);
                a.put('CAMPAIGN__c' , allFields[i][7]);
                a.put('CAMPAIGN_TYPE__c' , allFields[i][8]);
                a.put('CONTACTED__c' , allFields[i][9]);
                a.put('DISCONNECTED_FROM_HOLD__c' , allFields[i][10]);
                a.put('DISPOSITION1__c' , allFields[i][11]);
                a.put('DNIS__c' , allFields[i][12]);
                a.put('SERVICE_LEVEL1__c' , allFields[i][13]);
                a.put('SESSION_ID__c' , allFields[i][14]);
                a.put('SKILL__c' , allFields[i][15]);
                a.put('SPEED_OF_ANSWER__c' , allFields[i][16]);
                a.put('AFTER_CALL_WORK_TIME__c' , allFields[i][17]);
                a.put('HOLD_TIME__c' , allFields[i][18]);
                a.put('HOLDS1__c' , allFields[i][19]);
                a.put('QUEUE_WAIT_TIME__c' , allFields[i][20]);
                a.put('TALK_TIME_LESS_HOLD_AND_PARK__c' , allFields[i][21]);
                a.put('TRANSFERS1__c' , allFields[i][22]);
                a.put('AGENT_GROUP__c' , allFields[i][23]);
                a.put('AGENT_ID__c' , allFields[i][24]);
                a.put('AGENT_NAME__c' , allFields[i][25]);
                a.put('Salesforce_TFNDescription__c' , allFields[i][26]);
                lstFive9_Call_Data.add(a);
            }
            insert lstFive9_Call_Data;
        }
        return result;
    }
}