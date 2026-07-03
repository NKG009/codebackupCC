public class InspectionFormLWCController {
    @AuraEnabled
    public static List<Forms_Picklist_Options__mdt> getallpicklistvalues() {
        return [
            SELECT Picklist_Group__c, Label__c, Value__c, Parent_Value__c,MultiSelect__c
            FROM Forms_Picklist_Options__mdt
            WHERE Active__c = true
            ORDER BY MasterLabel
        ];
    }
    
    @AuraEnabled
    public static List<Forms_Repair_Items__mdt> getrepairitemlist() {
        return [
            SELECT Label,Unit__c,Price__c
            FROM Forms_Repair_Items__mdt
            WHERE Active__c = true
            ORDER BY SystemModstamp
     ];
    }
    
    
    
    @AuraEnabled
    public static string getContentVersion(Id cdid) {
        return [SELECT Id, ContentDocumentId, FileExtension, Title, VersionData 
                FROM ContentVersion 
                WHERE ContentDocumentId =:cdid 
                AND IsLatest = true].id;
    }
    
    @AuraEnabled
    public static Forms__c getformJSON (Id OpprecordId, String formType) {
        
        list<Forms__c> formlist = new list<Forms__c>();
        Forms__c formrec;
        formlist= [SELECT Id, Form_JSON__c,Opportunity__c,Form_Type__c,IsPDFGenerated__c
                   FROM Forms__c 
                   WHERE Opportunity__c =:OpprecordId 
                   AND Form_Type__c =:formType order by createddate desc limit 1];
        
        if(formlist.size()>0){
            formrec =formlist[0];
        }
        
        return formrec;
    }
    
    
    @AuraEnabled
    Public static OpportunityContactRole getprefilldata (Id OpprecordId){
        list<OpportunityContactRole> ocrlist = new list<OpportunityContactRole>();
        OpportunityContactRole ocr;
        
        ocrlist=[SELECT Id, ContactId,OpportunityId,IsPrimary, contact.Name,contact.email,contact.account.billingaddress
                 FROM OpportunityContactRole 
                 WHERE IsPrimary = True 
                 AND OpportunityId=:OpprecordId
                ];
        
        if(ocrlist.size()>0){
            ocr=ocrlist[0];
        }
        
        return ocr;
    }
    
    
    
    @AuraEnabled
    public static Forms__c createupdateFormRecord (Id OpprecordId, Id formid, String formType,String formJSON) {
        Forms__c formrec;
        if (String.isNotBlank(formid)) {
            formrec = [SELECT Id FROM Forms__c WHERE Id = :formid LIMIT 1];
        } else {
            formrec = new Forms__c();
        }
        formrec.Opportunity__c = OpprecordId;
        formrec.Form_Type__c = formType;
        formrec.Form_JSON__c = formJSON;
        upsert formrec;
        
        return formrec;
    }
    
    @AuraEnabled
    public static void createPDF(Id OpprecordId, Id formid, String formType,String formJSON){
        Forms__c formRec = createupdateFormRecord(OpprecordId,formid,formType,formJSON);
        formrec.IsPDFGenerated__c=true;
        update formrec;
        
        Map<String, String> formTypeMap = getFormTypeMap();
        system.debug('formRec.Id'+[SELECT Id, Form_JSON__c, Opportunity__c, Form_Type__c FROM Forms__c WHERE id=:formRec.id]);
        PageReference pdfPage = Page.FormPdfGeneratorVF;
        pdfPage.getParameters().put('formid', formRec.Id);
        pdfPage.getParameters().put('formTitle', formTypeMap.get(formRec.Form_Type__c));
        
        Blob pdfContent;
        try {
            pdfContent = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            throw new AuraHandledException('Failed to generate PDF: ' + e.getMessage());
        }

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = formRec.Form_Type__c;
        contentVersion.PathOnClient = formRec.Form_Type__c+'.pdf';
        contentVersion.VersionData = pdfContent;
        insert contentVersion;
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId, LinkedEntityId = formRec.Opportunity__c, ShareType = 'V', Visibility = 'AllUsers' );
        insert contentDocumentLink;

    }
    
    public static string createbody(Id formid){
        Forms__c formRec = [
            SELECT Id, Form_JSON__c, Opportunity__c, Form_Type__c
            FROM Forms__c
            WHERE id=:formid
            LIMIT 1
        ];
        String footer = 
            '<div style="font-size:12px; font-family:Arial; margin-top:20px;">' +
            '<table style="width:100%;  solid #ccc; padding-top:5px;">' +
            '<tr>' +
            '<td style="text-align:left;">123 Main Street, Suite 100, City, State ZIP</td>' +
            '<td style="text-align:right;">(123) 456-7890</td>' +
            '</tr>' +
            '</table>' +
            '</div>';
        
        string clientaddress='';
        string clientname='';
        string formtype;
        string inspectionnotes='';
        string notes='';
        string RoofLifeExpectancy;
        // formRec.Form_Type__c will send in params in vf call 
        InspectionFormWrapperClass fw = (InspectionFormWrapperClass) JSON.deserialize(formRec.Form_JSON__c, InspectionFormWrapperClass.class);
        for (InspectionFormWrapperClass.FieldDef f : fw.GeneralInformation) {
            String val = String.isNotBlank(String.valueOf(f.value)) ? String.valueOf(f.value): '';
            if(f.label=='Client Name'){
                clientname=val;
            }
            if(f.label=='Form Type'){
                formtype=val;
            }
            if(f.label =='Client Address' || f.label =='City' || f.label =='State' ||f.label =='Zip Code'){
                clientaddress +=val;
            }
        }
        for(InspectionFormWrapperClass.FieldDef f : fw.otherinfo){
            system.debug('label'+f.label +'--value:'+f.value);
            String val = String.isNotBlank(String.valueOf(f.value)) ? String.valueOf(f.value) : '';
            if(f.label =='Inspection Notes'){
              inspectionnotes = val;
            }
            if(f.label =='Notes'){
              notes = val;
            }
            if(f.label =='Roof Life Expectancy'){
              RoofLifeExpectancy = val;
            }
            
        }
        
        
        String html = '<div style="font-family:Arial; font-size:14px;">';
        
        
		/*---------------Page 1-------------------*/
        html += '<h3>Front Of Property:</h3>';
        if (fw.frontphoto != null && fw.frontphoto.isfileuploaded) {
            html += '<img src="' + fw.frontphoto.fileurl + '" style="width:70%; height:70%;"/> ';
        }
        
        html += '<br/><table cellspacing="0" cellpadding="5" width="100%">';
        html += '<tr><td><b>Client Address:</b></td><td>' + clientaddress + '</td></tr>';
        html += '<tr><td><b>Client Name:</b></td><td>' + clientname + '</td></tr>';
        for (InspectionFormWrapperClass.FieldDef f : fw.GeneralInformation) {
            String val = String.isNotBlank(String.valueOf(f.value)) ? String.valueOf(f.value) : '';
            if(f.label =='Inspector Name' || f.label =='Inspection Date' || f.label =='Inspector Phone'){
                html += '<tr><td><b>' + f.label + ':</b></td><td>' + val + '</td></tr>';
            }
        }
        html += '</table>';
        html +=getLineBreaks(12);
        html +=footer;
        html += '<div style="page-break-after: always;"></div>';
        
        /*---------------Page 2-------------------*/
        html +='<h3>Disclaimer:</h3>';
        html +='<p>The above named requested an evaluation of the roofing system for the referenced address. Our '+
            'evaluation will take into consideration the overall condition of the roofing system, its design and'+
            'expected performance over time. We cannot be liable for determining insurability. This falls under the'+
            'purview of a qualified underwriter. If the property is under contract, we recommend the buyer contact'+
            'their insurance carrier and request an inspection by an underwriter to determine whether or not the roof'+
            'is insurable prior to the end of the option period if possible or at least prior to closing.</p>';
        
        
        html += '<h3>General Property Description:</h3>';  //string imgtext = f.selectedOption =='Other' ? f.valOther : f.selectedOption;
        html += '<table cellspacing="0" cellpadding="5" width="100%">';
        for (InspectionFormWrapperClass.FieldDef f : fw.GeneralPropertyDescription) {
            String val = f.type=='multiselectpicklist'? getselectedvalues(f):String.isNotBlank(String.valueOf(f.value)) ? String.valueOf(f.value) : '';
            if(formRec.Form_Type__c =='Repair Inspection Form'){
               html += '<tr><td><b>' + f.label + ':</b></td><td>' + val + '</td></tr>'; 
            }
            else if(f.label !='The roof appears to be approximately' && 
                    f.label !='Layers of Shingles Installed' && 
                    f.label !='Underlayment' && 
                    f.label !='Chimneys Appear To Be' &&
                    f.label !='Pipe Jacks Appear To Be' &&
                    f.label !='Vent Stacks Appear To Be' &&
                    f.label !='Ventilation Appears To Be' ){
                html += '<tr><td><b>' + f.label + ':</b></td><td>' + val + '</td></tr>';
            }
            
        }
        html += '</table><br/>';
        
        if(formRec.Form_Type__c =='Cash Full Replacement Inspection Form'){
        html += '<h3>Inspection:</h3>';
        html +='<p>The inspection yielded the following results:</p><p>'+inspectionnotes +'</p>';
        }
        
        html += formRec.Form_Type__c =='Repair Inspection Form'? getLineBreaks(22): formRec.Form_Type__c =='Cash Full Replacement Inspection Form'? getLineBreaks(28):getLineBreaks(35);
        html +=footer;
        html += '<div style="page-break-after: always;"></div>';
        
        
        /*---------------Page 3-------------------*/
        if(formRec.Form_Type__c !='Cash Full Replacement Inspection Form'){
        html += '<h3>Inspection:</h3>';
        html +='<p>The inspection yielded the following results:</p><p>'+inspectionnotes +'</p>';
        }
        
        html += '<h3>Conclusions & Recommendations:</h3>';
        html +='<p>Based upon my visual inspection, these are my findings:</p>';
        
        if(formRec.Form_Type__c =='Repair Inspection Form'){
        html += '<h5>Itemized list of repairs</h5>';
        html += '<table  cellspacing="0" cellpadding="5" width="100%">';
        html += '<tr><th>Name</th><th>Unit</th><th>Price</th><th>Qty</th><th>Total</th></tr>';
        Decimal repairTotal = 0;
        for (InspectionFormWrapperClass.RepairDef r : fw.repairs) {
            if (r.isChecked) {
                repairTotal += r.total;
                html += '<tr>' +
                    '<td>' + r.name + '</td>' +
                    '<td>' + r.unit + '</td>' +
                    '<td>' + r.price + '</td>' +
                    '<td>' + r.quantity + '</td>' +
                    '<td>' + r.total + '</td>' +
                    '</tr>';
            }
        }
        html += '<tr><td colspan="4"><b>Grand Total</b></td><td><b>' + repairTotal + '</b></td></tr>';
        html += '</table><br/>';
        
        html += '<h5>Notes:</h5><p>'+notes+'</p>';
        html +='<p style="font-size: medium;"><b>With the recommended repairs, we would estimate the roof has a remaining life expectancy of approximately:   </b>'+RoofLifeExpectancy+'</p>';
        }
        if(formRec.Form_Type__c =='Passes Inspection Form'){
           html+=fw.passRecommendation.instructions;
           html+=fw.passRecommendation.Other;
           html +='<p style="font-size: medium;"><b>Assuming no major weather events,this roof is expected to last another:   </b>'+RoofLifeExpectancy+'</p>';
           html +=getLineBreaks(22);

        }
        if(formRec.Form_Type__c =='Insurance Full Replacement Inspection Form'){
           html+=fw.InsuranceRecommendation.instructions;
           html+=fw.InsuranceRecommendation.Other;
           html +='<p style="font-size: medium;"><b>Date of Loss::   </b>'+fw.InsuranceRecommendation.dateOfLoss+'</p>';
           html +=getLineBreaks(26);

        }
        
        if(formRec.Form_Type__c =='Cash Full Replacement Inspection Form'){
            html += '<table cellspacing="0" cellpadding="5" width="100%">';
            html += '<tr><td><b>Shingle Line:</b></td><td>' + fw.cashRecommendation.shingleLine.manufacturer + ' ' + fw.cashRecommendation.shingleLine.series +'</td></tr>';
            html += '<tr><td><b>Shingle Colour:</b></td><td>' + fw.cashRecommendation.shingleColor.manufacturer + fw.cashRecommendation.shingleColor.color + '</td></tr>';
            integer i=1;
            for(InspectionFormWrapperClass.formField cr: fw.cashRecommendation.formFields){
                if(String.isNotBlank(cr.value)){
                html += '<tr><td><b>'+ i +'</b></td><td>' + cr.value + '</td></tr>'; 
                i++;
                }
            }
            html += '<tr><td><b>Squares:</b></td><td>' + fw.cashRecommendation.Squares + '</td></tr>';
            html += '<tr><td><b>Base Rate:</b></td><td>$' + fw.cashRecommendation.BaseRate + '</td></tr>';
            html += '<tr><td><b>Steep Roof Charge:</b></td><td>$' + fw.cashRecommendation.SteepRoofCharge + '</td></tr>';
            html += '<tr><td><b>2-Story Charge:</b></td><td>$' + fw.cashRecommendation.TwoStoryCharge + '</td></tr>';
            html += '<tr><td><b>Total:</b></td><td>$' + fw.cashRecommendation.Total + '</td></tr>';
            html += '<tr><td><b>Date of Loss:</b></td><td>' + fw.cashRecommendation.DateOfLoss + '</td></tr>';
            html += '</table><br/>';
            html +=getLineBreaks(10);
        }
        
        

        html +=footer;
        html += '<div style="page-break-after: always;"></div>';
        
        /*---------------Page 4 & last pages-------------------*/
        
        if (fw.alluploadedfiles != null && fw.alluploadedfiles.size() > 0) {
            html += '<h3>The photographs that follow are intended to be a representative'+
                'sample of the kind of flaws that exist at the property. This is not '+
                'an exhaustive cataloging of every imperfection needing '+
                'addressed:</h3>';
            for (InspectionFormWrapperClass.FileDef f : fw.alluploadedfiles) {
                if (f.isfileuploaded) {
                    string imgtext = f.selectedOption =='Other' ? f.valOther : f.selectedOption;
                    html += '<div style="margin:10px;">' +
                        '<b>Photo Of:  </b>'+ imgtext + '<br/>' +
                        '<img src="' + f.fileurl + '" style="width:80%; height:80%;margin-top: 10px;"/>' +
                        '</div>';
                }
            }
        }
        
        
        html +=footer;
        html += '</div>';
        
       return html; 
    }
    
     public static Map<String, String> getFormTypeMap() {
        Map<String, String> formTypeMap = new Map<String, String>();

        formTypeMap.put('Passes Inspection Form', 'Inspection Report - PASSES INSPECTION');
        formTypeMap.put('Repair Inspection Form', 'Inspection Report - REQUIRES REPAIRS');
        formTypeMap.put('Cash Full Replacement Inspection Form', 'Inspection Report - FULL REPLACEMENT');
        formTypeMap.put('Insurance Full Replacement Inspection Form', 'Inspection Report - FULL REPLACEMENT');

        return formTypeMap;
    }
    public static String getLineBreaks(Integer count) {
        String breaks = '';
        for (Integer i = 0; i < count; i++) {
            breaks += '<br/>';
        }
        return breaks;
    }
    
    public static string getselectedvalues(InspectionFormWrapperClass.FieldDef f){
        List<String> selectedValues = new List<String>();
         List<InspectionFormWrapperClass.Option> options = (List<InspectionFormWrapperClass.Option>) JSON.deserialize(JSON.serialize(f.values), List<InspectionFormWrapperClass.Option>.class);
        for (InspectionFormWrapperClass.Option opt : options) {
            if (opt.selected == true) {
                selectedValues.add(opt.value);
            }
        }
        
        if (f.isOtherSelected == true && String.isNotBlank(f.valOther)) {
            selectedValues.add(f.valOther);
        }
        return String.join(selectedValues, ', ');
    }
}