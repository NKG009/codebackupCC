trigger OpportunityTrigger on Opportunity (Before Insert, Before update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        set<Id> OppIds= New  set<Id>();
        for(opportunity opp : Trigger.new){
            if(opp.Invoice_No__c ==null  && opp.Invoice_No_Required__c==true){
                OppIds.add(opp.id);
                system.debug('OppIds'+OppIds);
                InvoiceAutoNumberGeneration(OppIds);
    }
        }
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        set<Id> OppIds= New  set<Id>();
        for(opportunity opp : Trigger.new){
            if( opp.Invoice_No__c ==null  && opp.Invoice_No_Required__c==true){
                OppIds.add(opp.id);
                 InvoiceAutoNumberGeneration(OppIds);
            }
        } 
    }
    
    
       void InvoiceAutoNumberGeneration(set <Id> OppIdlist){
    
         map<string,decimal>TypeToNum = new map<string,decimal>();
      //  map<string,id>nametoid = new  map<string,id>();
        list<InvoiceAutoNumber__c>InvoiceCstmlistToUpdate= new  list<InvoiceAutoNumber__c>();
        Id rtpeConnext=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Connext').getRecordTypeId();
        Id rtpeOPCCCorporateConsultants=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPCC_Corporate_Consultants').getRecordTypeId();
        Id rtpeOPCCFormations=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPCC_Formations').getRecordTypeId();
        Id rtpeOPETCPDstore=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPET_CPDstore').getRecordTypeId();
        Id rtpeOPSS=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPSS').getRecordTypeId();
        Id rtpeProfitPro=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('ProfitPro').getRecordTypeId();
        Id rtpeOPTLTaxandLegal=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPTL_Tax_and_Legal').getRecordTypeId();
        Id rtpeOPPSPracticeSupport=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPPS_Practice_Support').getRecordTypeId();
        Id rtpeSales=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Sales').getRecordTypeId();
        
        for(InvoiceAutoNumber__c inv :[select id,name,Number__c from InvoiceAutoNumber__c]){
            TypeToNum.put(inv.name,inv.Number__c);
           // nametoid.put(inv.name,inv.Id);[select Id,Invoice_No__c, recordtypeid from opportunity where Id IN:OppIdlist]
        }
        system.debug('OppIdlist'+OppIdlist);
        if(OppIdlist.size()>0){
            for(opportunity oppupdate : trigger.new){
                if(OppIdlist.contains(oppupdate.Id)){
                system.debug('oppupdate.Invoice_No__c'+oppupdate.Invoice_No__c);
                if(oppupdate.recordtypeid==rtpeConnext){
                   
                    oppupdate.Invoice_No__c='CON'+TypeToNum.get('CON');
                    InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('CON');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                    
                }              
                if(oppupdate.recordtypeid==rtpeOPCCCorporateConsultants){
                   oppupdate.Invoice_No__c='CC'+TypeToNum.get('CC');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('CC');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeOPCCFormations){
                    oppupdate.Invoice_No__c='CC'+TypeToNum.get('CC');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('CC');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeOPETCPDstore){
                    oppupdate.Invoice_No__c='OP'+TypeToNum.get('OP');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('OP');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeOPPSPracticeSupport){
                    oppupdate.Invoice_No__c='PS'+TypeToNum.get('PS');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('PS');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeOPSS){
                    oppupdate.Invoice_No__c='SS'+TypeToNum.get('SS');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('SS');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeOPTLTaxandLegal){
                    oppupdate.Invoice_No__c='TL'+TypeToNum.get('TL');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('TL');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeProfitPro){
                     oppupdate.Invoice_No__c='PP'+TypeToNum.get('PP');
                     InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('PP');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                if(oppupdate.recordtypeid==rtpeSales){
                  oppupdate.Invoice_No__c='S'+TypeToNum.get('S');
                   InvoiceAutoNumber__c inv = InvoiceAutoNumber__c.getInstance('S');
                    inv.Number__c=inv.Number__c+1;
                    InvoiceCstmlistToUpdate.add(inv);
                }
                } 
            }
        } 
        system.debug('InvoiceCstmlistToUpdate'+InvoiceCstmlistToUpdate);
        if(InvoiceCstmlistToUpdate.size()>0){
            update InvoiceCstmlistToUpdate;
        } 
       }

   
}