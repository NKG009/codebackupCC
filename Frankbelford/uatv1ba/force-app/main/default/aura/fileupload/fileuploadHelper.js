({
    MAX_FILE_SIZE: 1000000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;       
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.messageinred",true);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size+'\n'+'Please upload another image');
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 		component.set("v.messageinred",true);
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
       var fromPos = 0;
       var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
		
        // start with the initial chunk
       this.uploadChunk(component, file, fileContents, fromPos, toPos, '');
       /*var action = component.get("c.saveTheFile"); 
 
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
 
        action.setCallback(this, function(a) {
            var attachId = a.getReturnValue();
            console.log(attachId);
        });
        //this.openActionWindow(component);
		$A.enqueueAction(action);  */      
    },
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId) {
        var action = component.get("c.saveTheChunk"); 
        var chunk = fileContents.substring(fromPos, toPos);

        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        });
       
        var self = this;
        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);    
            if (fromPos < toPos) {
            	self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            }
        });
            
        $A.enqueueAction(action);
    },
    openActionWindow : function(component, event, helper) {
		event.preventDefault();
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"myprofileedit";
        /*urlEvent.setParams({
            "url": "/myprofileedit"
        });
        urlEvent.fire();*/
        window.location.replace(urlRedirect);
        return false;
    }
})