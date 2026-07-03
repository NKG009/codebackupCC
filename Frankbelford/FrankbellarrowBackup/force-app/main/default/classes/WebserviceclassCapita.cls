global with sharing class WebserviceclassCapita {
  WebService static string Capitabatch(){
  
     CapitaBatchHeaderclass b = new CapitaBatchHeaderclass();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
   }
WebService static string Netivebatch(){
  
     NetiveBatchHeaderclass b = new NetiveBatchHeaderclass();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
   }
WebService static string SiteUpdatebatch(){
  
     SiteB2FUpdate b = new SiteB2FUpdate();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
   }
WebService static string TopazUpdatebatch(){
  
     TopazGlobalB2FUpdate b = new TopazGlobalB2FUpdate();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
   }
WebService static string LTDCompanyUpdatebatch(){
  
     LTDpayprofileB2FUpdate b = new LTDpayprofileB2FUpdate();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
}
WebService static string PlacementUpdatebatch(){
  
     permplacementB2FUpdate b = new permplacementB2FUpdate();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
   }
WebService static string UmbrellaListUpdatebatch(){
  
     UmbrellaListB2FUpdate b = new UmbrellaListB2FUpdate();
        ID batchprocessid=Database.executeBatch(b,1); 
        return batchprocessid;
     
   }
}