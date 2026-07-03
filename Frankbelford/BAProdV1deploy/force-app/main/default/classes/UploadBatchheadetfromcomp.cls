/**
 * Created by Espier Team on
 * Updated by Musaddekur Rahman on 21/10/2020 as Part of https://impellam.atlassian.net/browse/PT1-3 JIRA Story
 * Update Details:
 *          1) Added checkDuplicateFileLoad method to check whether the given file is already uploaded
 *          2) Updated insertData method signature from 3 string param to 4 string param to include file name
 */

public class UploadBatchheadetfromcomp {
    @Auraenabled
    public static List<sirenum__Site__c> getsitesList(String jsonString) {
        Account acc = (Account) JSON.deserialize(jsonString, Account.class);
        ID accid = acc.id;
        System.debug('check acc id'+accid);
        List <Id> siteIds = new List <Id> ();
        List <sirenum__Site__c> sitesList = [ SELECT id, Brand__c, name, sirenum__Operating_Company__c
        FROM sirenum__Site__c
        WHERE sirenum__Operating_Company__c =:accid  ORDER BY name ASC];
        return sitesList;
    }

    @AuraEnabled
    public static Integer checkDuplicateFileLoad(String fileName){
        System.debug('Checking duplicate File name for given file >>> ' + fileName);
        Integer fileNameCount = [SELECT COUNT() FROM Batch_header__c WHERE Uploaded_File_Name__c=:fileName];
        return fileNameCount > 0 ? 1 : 0;
    }

    @AuraEnabled
    public static string insertData(String strfromlex,String jsonString1,String ClientRef, String fileName) {
        sirenum__Site__c siteref;
        String clientidref;
        if(String.isBlank(fileName)){
            System.debug('File name missing');
            throw new AuraHandledException(':: Missing file name');
        } else if (checkDuplicateFileLoad(fileName)==1){
            System.debug('File name missing');
            throw new AuraHandledException(':: This File ('+fileName+') was imported previously');
        }
        System.debug('check client ref from Comp'+ClientRef);
        if(ClientRef != null && ClientRef !='') {
            siteref = [Select id,IP_ClientIDLegacy__c from sirenum__Site__c where id=:ClientRef limit 1];
            clientidref =  siteref.IP_ClientIDLegacy__c;
        }
        System.debug('check client id'+clientidref);
        Account acc = (Account) JSON.deserialize(jsonString1, Account.class);
        String accname = acc.Name;
        ID accID = acc.ID;
        String returnresponse ='';
        Batch_header__c b = new Batch_header__c();
        b.IP_BatchType__c = 'Generic';
        b.IP_Status__c = 'Approved';
        b.IP_State__c = 'Closed';
        b.IP_Account__c = accname;
        b.IP_AccountID__c = accID;
        b.Uploaded_File_Name__c = fileName;
        System.debug('b >>> '+ b);
        try{
            insert b;
        } catch (Exception ex) {
            System.debug('Caught exception >>> ' + ex);
            returnresponse = 'ERROR - Batch Header Creation Failed!';
            return returnresponse;
        }
        IP_BatchLine__c bl =new  IP_BatchLine__c();
        List<IP_BatchLine__c> batchlineListtoInsert = new List<IP_BatchLine__c>();
        System.debug('check string'+strfromlex);
        JSONParser parser = JSON.createParser(strfromlex);
        while(parser.nextToken()!= null) {
            if(parser.getCurrentToken()== JSONToken.START_OBJECT)
            {
                while (parser.nextToken()!=null)
                {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                        parser.nextToken();
                        if(parser.getCurrentName() == 'Candidate_ID') {
                            if(parser.getText()!=null && parser.getText()!='') {
                                bl.IP_TextField2__c = parser.getText();
                            }
                        } else if (parser.getCurrentName() == 'Candidate_Name') {
                            if(parser.getText()!=null && parser.getText()!='') {
                                bl.IP_TextField1__c = parser.getText();
                            }
                        } else if (parser.getCurrentName() == 'Hours') {
                            if(parser.getText()!=null && parser.getText() != '') {
                                bl.IP_Number12d4Field1__c = Decimal.ValueOf(parser.getText());
                            }
                        } else if(parser.getCurrentName() == 'Pay_Rate') {
                            if(parser.getText()!=null && parser.getText() != '') {
                                bl.IP_CurrencyField1__c = Decimal.ValueOf(parser.getText());
                            }
                        } else if(parser.getCurrentName() == 'Charge_Rate') {
                            if(parser.getText()!=null && parser.getText() != '') {
                                bl.IP_CurrencyField2__c = Decimal.ValueOf(parser.getText());
                            }
                        } else if(parser.getCurrentName() == 'Rate_Code') {
                            if(parser.getText()!=null && parser.getText()!='') {
                                bl.IP_TextField3__c = parser.getText();
                            }
                        } else if(parser.getCurrentName() == 'Shift_Date') {
                            System.debug('shift date'+parser.getText());
                            if(parser.getText() != null && parser.getText() != '') {
                                Integer mymonth;
                                Integer mydate;
                                List<String> str = parser.getText().split('/');
                                System.debug('shift date 123'+str);
                                if(Integer.valueOf(str[0])<10) {
                                    String dt = '0'+str[0];
                                    mydate = Integer.valueOf(dt);
                                } else {
                                    mydate = Integer.valueOf(str[0]);
                                }
                                if(Integer.valueOf(str[1]) <10) {
                                    String dt1 = '0'+str[1];
                                    mymonth = Integer.valueOf(dt1);
                                } else {
                                    mymonth = Integer.valueOf(str[1]);
                                }
                                Integer myyear = Integer.valueOf(str[2]);
                                bl.IP_DateField1__c = Date.newInstance(myyear,mymonth,mydate);
                            }
                        } else if(parser.getCurrentName() == 'Weekending') {
                            System.debug('Weekending'+parser.getText());
                            if(parser.getText() != null && parser.getText() != '') {
                                Integer mydate;
                                Integer mymonth;
                                List<String> str = parser.getText().split('/');
                                System.debug('Weekending 123'+str);
                                if(Integer.valueOf(str[0])<10) {
                                    String dt = '0'+str[0];
                                    mydate = Integer.valueOf(dt);
                                } else {
                                    mydate = Integer.valueOf(str[0]);
                                }
                                if(Integer.valueOf(str[1]) <10) {
                                    String dt1 = '0'+str[1];
                                    mymonth = Integer.valueOf(dt1);
                                } else {
                                    mymonth = Integer.valueOf(str[1]);
                                }
                                Integer myyear = Integer.valueOf(str[2]);
                                bl.IP_DateField2__c = Date.newInstance(myyear,mymonth,mydate);
                            }
                        } else if(parser.getCurrentName() == 'PO_Number') {
                            if(parser.getText()!=null && parser.getText()!='') {
                                bl.IP_TextField4__c = parser.getText();
                            }
                        } else if(parser.getCurrentName() == 'Job_Role') {
                            if(parser.getText()!=null && parser.getText()!='') {
                                bl.IP_TextField5__c = parser.getText();
                            }
                        } else if(parser.getCurrentName() == 'Client_Ref') {
                            if(clientidref != null && clientidref != '') {
                                bl.IP_TextField6__c =   clientidref;
                            } else {
                                if(parser.getText()!=null && parser.getText()!='') {
                                    bl.IP_TextField6__c = parser.getText();
                                }
                            }
                        } else if(parser.getCurrentName() == 'External_Assignment_ID') {
                            if(parser.getText()!=null && parser.getText()!='') {
                                bl.IP_TextField7__c = parser.getText();
                            }
                            bl.IP_BatchHeader__c = b.id;
                            batchlineListtoInsert.add(bl);
                            bl = new IP_BatchLine__c();
                        }
                    }
                }
            }
        }
        system.debug('check insert list'+batchlineListtoInsert);
        if(batchlineListtoInsert.size() > 0) {
            try {
                insert batchlineListtoInsert;
                system.debug('batchlineListtoInsert'+batchlineListtoInsert);
                returnresponse = 'SUCCESS';
            } catch(Exception ex) {
                system.debug('excepttion1111111'+ex);
                returnresponse = 'ERROR';
            }
        }
        return returnresponse;
    }
}