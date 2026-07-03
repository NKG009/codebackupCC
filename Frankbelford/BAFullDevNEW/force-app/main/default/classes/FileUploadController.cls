/**
   *  @Name: FileUploadController>   
   *  @Date Created: <10/04/2019>
   *  @Description: <Class to Upload Image in User Object - User Image field>
 */
public without sharing class FileUploadController {
    
    @AuraEnabled
    public static Id saveTheChunk(String fileName, String base64Data, String contentType, String fileId) { 
        if (fileId == '') {
            fileId = saveTheFile(fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    @AuraEnabled
    public static Id saveTheFile(String fileName, String base64Data, String contentType) {
        Id userId = Userinfo.getUserId();
        string urler = URL.getSalesforceBaseUrl().toString();
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Document d= new Document();
        d.name = fileName;
        d.body=EncodingUtil.base64Decode(base64Data); // body field in document object which holds the file.
        //d.folderid='00l0Y000000QTRt'; //folderid where the document will be stored insert document;
        d.AuthorId = UserInfo.getUserId();
        d.FolderId = UserInfo.getUserId(); 
        insert d; 
        
        Organization oid = [Select id from organization limit 1];
        
        User usr = new User(id=userId);
        String url =Label.Salesforce_URL_For_Document+d.id+'&oid='+oid;
        usr.User_Image__c = url;
        usr.User_Image_Uploaded__c = '<img alt="User-added image" src='+url+'></img>';
        update usr;
        
        return d.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        Id userId = Userinfo.getUserId();
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Document d = [
            SELECT Id, Body
            FROM Document
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(d.Body);
 
        d.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update d;
        
        User usr = new User(id=userId);
        String url =Label.Salesforce_URL_For_Document+d.id;
        usr.User_Image__c = url;
        usr.User_Image_Uploaded__c = '<img alt="User-added image" src='+url+'></img>';
        update usr;
    }
    
    @AuraEnabled 
    public static user fetchUserDetail(){
        return [Select id,Name,SmallPhotoUrl, FullPhotoUrl,User_Image__c,User_Image_Uploaded__c
                From User
                Where Id =: Userinfo.getUserId()];
    }
}