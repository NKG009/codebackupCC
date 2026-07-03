/**
 * MR: USE Schema classess to get RecordType Id instead of using SOQL as part of RJSPT-87 JIRA ticket.
 * CHANGE REQUIREMNTS: JIRA RJSPT-87: Reinstate Process - Not working for certain workers
 * DATE OF UPDATE: 23/07/2020
 */
trigger Createcert on ts2__Certification__c (after update,after insert) {
    Set<ID> conID = new Set<ID>();
    Map<String,Id> verify = new Map<String,Id>();
    Map<String,Date> validfrom = new Map<String,Date>();
    Map<String,Date> validTo = new Map<String,Date>();
    Map<String,Date> photoCardExpiryDate = new Map<String,Date>();
    Map<String,String> verificationdate = new Map<String,String>();
    Map<String,id> ticketmap = new Map<String,id>();
    String checkrec;
    
    Id rectypeid = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
    Id rectypeid2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('DVLA Licence Check').getRecordTypeId();
    
    for(integer i=0;i<trigger.new.size();i++)
    {    
        conID.add(trigger.new[i].ts2__Contact__c);
        if(trigger.isupdate && trigger.new[i].Verfied__c != trigger.old[i].Verfied__c && trigger.new[i].Verfied__c==True && (trigger.new[i].recordTypeID==rectypeid || trigger.new[i].recordTypeID == rectypeid2))
        {
            if(trigger.new[i].recordTypeID == rectypeid2)
            {
                checkrec='true';
            }
            for(ts2__Certification__c cert : trigger.new)
            {
                if(cert.Verfied__c==True && cert.Standard__c==True){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('Drivers Licence(Standard)',cert.ts2__Contact__c);  
                    validfrom.put('Drivers Licence(Standard)', cert.Valid_From__c);
                    validTo.put('Drivers Licence(Standard)', cert.Valid_To__c);
                    verificationdate.put('Drivers Licence(Standard)', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                
                /*** Defect -10386 
                Competency Type renamed from PCV Licence to LGV D Licence, 
                Competency Type renamed from PCV Licence (Minibus) to LGV D1 Licence and
                a Competency Condition is created for PCV Licence when PCV Licence is true ***/
                
                if(cert.Verfied__c==True && cert.PCV_Licence__c==true)
                {
                    conID.add(cert.ts2__Contact__c);
                    verify.put('PCV Licence',cert.ts2__Contact__c);  
                    validfrom.put('PCV Licence', cert.Valid_From__c);
                    validTo.put('PCV Licence', cert.Valid_To__c);
                    verificationdate.put('PCV Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                
                if(cert.Verfied__c==True && cert.Class_ADR_C1_Small_Lorries_7_5_tonnes__c)
                {
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV ADR C1 Licence',cert.ts2__Contact__c);  
                    validfrom.put('LGV ADR C1 Licence', cert.Valid_From__c);
                    validTo.put('LGV ADR C1 Licence', cert.Valid_To__c);
                    verificationdate.put('LGV ADR C1 Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c==True && cert.Class_ADR_C_Large_Lorries__c)
                {
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV ADR C Licence',cert.ts2__Contact__c);  
                    validfrom.put('LGV ADR C Licence', cert.Valid_From__c);
                    validTo.put('LGV ADR C Licence', cert.Valid_To__c);
                    verificationdate.put('LGV ADR C Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c==True && cert.Class_C_HIAB__c)
                {
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV HIAB C Licence',cert.ts2__Contact__c);  
                    validfrom.put('LGV HIAB C Licence', cert.Valid_From__c);
                    validTo.put('LGV HIAB C Licence', cert.Valid_To__c);
                    verificationdate.put('LGV HIAB C Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c==True && cert.Class_ADR_C1_E_Small_Lorry_Trailer__c)
                {
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV ADR C1+E Licence',cert.ts2__Contact__c);  
                    validTo.put('LGV ADR C1+E Licence', cert.Valid_To__c);
                    verificationdate.put('LGV ADR C1+E Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                
                //Added below code for JPC-1645
                //Added below code for JPC-1645
                if(cert.Verfied__c && cert.RecordTypeid==rectypeid2){
                    System.debug('@@Inside required loop@@');
                    // Add record for DVLA Licence Check
                    conID.add(cert.ts2__Contact__c);
                    verify.put('DVLA Licence Check',cert.ts2__Contact__c);  
                    validfrom.put('DVLA Licence Check', Date.valueOf(cert.DVLA_Check_Date__c));
                    validTo.put('DVLA Licence Check', Date.valueOf(cert.Next_Check_Due__c));
                    verificationdate.put('DVLA Licence Check', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.RecordTypeid==rectypeid){
                    // Add record for PhotoCard Expiry Date
                    verify.put('Driving Licence (Standard)',cert.ts2__Contact__c); 
                    validTo.put('Driving Licence (Standard)', cert.Valid_To__c);
                    verificationdate.put('Driving Licence (Standard)', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.Class_B_Car_Van__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('Car/Van Driver Skill',cert.ts2__Contact__c);
                    validTo.put('Car/Van Driver Skill', cert.Class_B_Car_Van_Expiry_Date__c);
                    verificationdate.put('Car/Van Driver Skill', cert.DVLA_Licence_Check_VerificationCode__c);
                    System.debug('++++++++='+verificationdate);
                    System.debug('++++++++='+verify);
                }
                if(cert.Verfied__c && cert.Class_C1_Small_Lorries_7_5_tonnes__c && cert.RecordTypeid==rectypeid)
                {
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV C1 Licence',cert.ts2__Contact__c);
                    validTo.put('LGV C1 Licence', cert.Class_C1_Small_Lorries_Expiry_Date__c);
                    verificationdate.put('LGV C1 Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                if(cert.Verfied__c && cert.Class_C_Large_Lorries__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c); 
                    verify.put('LGV C Licence',cert.ts2__Contact__c);
                    validTo.put('LGV C Licence', cert.Class_C_Large_Lorries_Expiry_Date__c);
                    verificationdate.put('LGV C Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                if(cert.Verfied__c && cert.Class_C1_E_Small_Lorry_Trailer__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c); 
                    verify.put('LGV C1+E Licence',cert.ts2__Contact__c);
                    validTo.put('LGV C1+E Licence', cert.Class_Small_Lorry_Trailer_Expiry_Date__c);
                    verificationdate.put('LGV C1+E Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                if(cert.Verfied__c && cert.Class_C_E_Articulated_Lorry__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV C + E Licence',cert.ts2__Contact__c);
                    validTo.put('LGV C + E Licence', cert.Class_C_E_Articulated_Lorry_Expiry_Date__c);
                    verificationdate.put('LGV C + E Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.Class_C_E_102_Draw_Bar_Only__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c); 
                    verify.put('LGV C + E Licence (102 Restriction)',cert.ts2__Contact__c);
                    validTo.put('LGV C + E Licence (102 Restriction)', cert.Class_C_E_102_Restriction_Expiry_Date__c);
                    verificationdate.put('LGV C + E Licence (102 Restriction)', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                if(cert.Verfied__c && cert.Class_D_Bus_Coach__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV D Licence',cert.ts2__Contact__c);
                    validTo.put('LGV D Licence', cert.Class_D_Bus_Coach_Expiry_Date__c);
                    verificationdate.put('LGV D Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                if(cert.Verfied__c && cert.Class_D_Minibus__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('LGV D1 Licence',cert.ts2__Contact__c);
                    validTo.put('LGV D1 Licence', cert.Class_D1_Minibus_Expiry_Date__c);
                    verificationdate.put('LGV D1 Licence', cert.DVLA_Licence_Check_VerificationCode__c);
                    
                }
                if(cert.Verfied__c && cert.Digicard__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('Digicard',cert.ts2__Contact__c);
                    validTo.put('Digicard', cert.Digicard_Expiry_Date__c);
                    verificationdate.put('Digicard', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.ADR__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('ADR',cert.ts2__Contact__c);
                    validTo.put('ADR', cert.ADR_Expiry_Date__c);
                    verificationdate.put('ADR', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.CPC__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('DQC (CPC) Card',cert.ts2__Contact__c);
                    validTo.put('DQC (CPC) Card', cert.CPC_Expiry_Date__c);
                    verificationdate.put('DQC (CPC) Card', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.PCV__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('PCV',cert.ts2__Contact__c);
                    validTo.put('PCV', cert.PCV_Expiry_Date__c);
                    verificationdate.put('PCV', cert.DVLA_Licence_Check_VerificationCode__c);
                }
                if(cert.Verfied__c && cert.HIAB__c && cert.RecordTypeid==rectypeid){
                    conID.add(cert.ts2__Contact__c);
                    verify.put('HIAB',cert.ts2__Contact__c);
                    validTo.put('HIAB', cert.HIAB_Expiry_Date__c);
                    verificationdate.put('HIAB', cert.DVLA_Licence_Check_VerificationCode__c);
                }
            }
        }
    }
    System.debug('verify  '+verify);

    if(checkRecursiveDriving.runOnce())
    {
        List<sirenum__TicketType__c> compitency = [Select id,name from sirenum__TicketType__c];
        System.debug('Compitency '+compitency);
        sirenum__Ticket__c[] updatelist = new sirenum__Ticket__c[] {};
            List<sirenum__Ticket__c> ticketlist = [Select id,name,sirenum__Owner__c ,sirenum__TicketType__c,sirenum__TicketType__r.Name from sirenum__Ticket__c where sirenum__Owner__c  in:conID];
        for(sirenum__Ticket__c tic:ticketlist)
        {
            ticketmap.put(tic.sirenum__TicketType__r.Name,tic.id);
        }
        System.debug('Ticket Map'+ticketmap);
        System.debug('All Ticket list'+ticketlist);
        Map<String, Id> comp = new Map<String,ID>();
        for(sirenum__TicketType__c compit : compitency)
        {
            comp.put(compit.name, compit.id);
            
        }
        System.debug('COMP '+comp);
        System.debug('verify  '+verify);
        List<sirenum__Ticket__c> comlist = new List<sirenum__Ticket__c>();
        List<ts2__Certification__c> certlist = new List<ts2__Certification__c>();

        If(verify.size()>0){
            system.debug('verify.keyset() '+verify.keyset());
            system.debug('comp.keyset() '+comp.keyset());
                
            for(String keyId: verify.Keyset())
            {   system.debug('1111111111keyId '+keyId);
                system.debug('comp.keyset().contains(keyId) '+comp.keyset().contains(keyId));
                system.debug('verificationdate.keySet().contains(keyId) '+verificationdate.keySet().contains(keyId));
                IF(comp.keyset().contains(keyId) && verificationdate.keySet().contains(keyId)){                 
                    //Competency Type for Driving Licence Vehicle Classes
                    if(keyid.equalsIgnoreCase('Car/Van Driver Skill') || keyid.equalsIgnoreCase('LGV C1 Licence') || keyid.equalsIgnoreCase('LGV C Licence') || keyid.equalsIgnoreCase('LGV C1+E Licence') || keyid.equalsIgnoreCase('LGV C + E Licence') || keyid.equalsIgnoreCase('LGV C + E Licence (102 Restriction)') || keyid.equalsIgnoreCase('LGV D1 Licence') || keyid.equalsIgnoreCase('LGV D Licence')){
                        if(!ticketmap.containskey(keyid)){
                            sirenum__Ticket__c newcomp = new sirenum__Ticket__c();
                            newcomp.sirenum__Owner__c = verify.get(Keyid);
                            newcomp.sirenum__TicketType__c = comp.get(keyid);
                            newcomp.sirenum__Valid_from__c = System.today();
                            newcomp.sirenum__Valid_until__c = validTo.get(keyid);
                            comlist.add(newcomp);
                            system.debug('newcomp '+newcomp);
                        }
                        else{    
                            updatelist.add(new sirenum__Ticket__c(Id = ticketmap.get(keyid),sirenum__Valid_until__c=validTo.get(keyid),sirenum__Valid_from__c = System.today()));                         
                            system.debug('**Update List'+updatelist);  
                        }
                    }
                    
                    //Competency Type for Other Licence
                    if(keyid.equalsIgnoreCase('PCV') || keyid.equalsIgnoreCase('Digicard') || keyid.equalsIgnoreCase('ADR') || keyid.equalsIgnoreCase('HIAB') || keyid.equalsIgnoreCase('DQC (CPC) Card')){
                        if(!ticketmap.containskey(keyid) ){
                            sirenum__Ticket__c newcomp = new sirenum__Ticket__c();
                            newcomp.sirenum__Owner__c = verify.get(Keyid);
                            newcomp.sirenum__TicketType__c = comp.get(keyid);
                            newcomp.sirenum__Valid_from__c = System.today();
                            newcomp.sirenum__Valid_until__c = validTo.get(keyid);
                            comlist.add(newcomp);
                            system.debug('newcomp '+newcomp);
                        }
                        else{ 
                            updatelist.add(new sirenum__Ticket__c(Id = ticketmap.get(keyid),sirenum__Valid_until__c=validTo.get(keyid),sirenum__Valid_from__c = System.today()));
                            system.debug('**Update List'+updatelist);  
                        }
                    }
                    
                    //Competency Type for PhotoCard Expiry Date
                    if(keyid.equalsIgnoreCase('Driving Licence (Standard)')){
                        if(!ticketmap.containskey(keyid) ){
                            sirenum__Ticket__c newcomp = new sirenum__Ticket__c();
                            newcomp.sirenum__Owner__c = verify.get(Keyid);
                            newcomp.sirenum__TicketType__c = comp.get(keyid);
                            newcomp.sirenum__Valid_from__c = System.today();
                            newcomp.sirenum__Valid_until__c = validTo.get(keyid);
                            comlist.add(newcomp);
                            system.debug('newcomp '+newcomp);
                        }
                        else{     
                            //updatelist.add(new sirenum__Ticket__c(Id = ticketmap.get(keyid), sirenum__Valid_from__c = validfrom.get(keyid),sirenum__Valid_until__c=validTo.get(keyid)));
                            updatelist.add(new sirenum__Ticket__c(Id = ticketmap.get(keyid),sirenum__Valid_until__c=validTo.get(keyid),sirenum__Valid_from__c = System.today()));
                            system.debug('**Update List'+updatelist);  
                        }
                    }
                    //Competency Type for DVLA Licence Check
                    if(keyid.equalsIgnoreCase('DVLA Licence Check')){
                        if(!ticketmap.containskey(keyid) ){
                            sirenum__Ticket__c newcomp = new sirenum__Ticket__c();
                            newcomp.sirenum__Owner__c = verify.get(Keyid);
                            newcomp.sirenum__TicketType__c = comp.get(keyid);
                            newcomp.sirenum__Valid_from__c = validfrom.get(keyid);
                            newcomp.sirenum__Valid_until__c = validTo.get(keyid);
                            system.debug('+++++++sirenum__Valid_until__c+++++++ '+newcomp.sirenum__Valid_until__c);
                            comlist.add(newcomp);
                            system.debug('newcomp '+newcomp);
                        }
                        else{
                            updatelist.add(new sirenum__Ticket__c(Id = ticketmap.get(keyid),sirenum__Valid_until__c=validTo.get(keyid),sirenum__Valid_from__c = validfrom.get(keyid)));
                            system.debug('**Update List'+updatelist);  
                        }
                    }
                }
                
            }
        }
        
        if(comlist.size()>0){
            insert comlist;}
        if(updatelist.size()>0)
        {
            update updatelist;
        }
        if(!certlist.isempty() && certlist!=null){
            System.debug('$$Cert List$$'+certlist);
            insert certlist[0];
        }
    }
    
    If(Trigger.IsInsert){ 
        LapseCertificateFuture.method1(conid);
    }
}