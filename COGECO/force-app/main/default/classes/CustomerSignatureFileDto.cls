public without sharing class CustomerSignatureFileDto {
    @AuraEnabled public String base64 {get;set;}
    @AuraEnabled public String filename {get;set;}
    
    public CustomerSignatureFileDto() { }
    
    public CustomerSignatureFileDto(String base64, String filename) {
        this.base64 = base64;
        this.filename = filename;
    }
}