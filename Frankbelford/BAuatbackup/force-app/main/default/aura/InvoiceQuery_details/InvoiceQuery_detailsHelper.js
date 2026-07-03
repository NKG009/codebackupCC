({
getTaskdetails : function(cmp,recid) {
       var action1 = cmp.get("c.getTaskrecdetails");
		action1.setParams({"Taskid": recid});
        action1.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				var result = response.getReturnValue();
				cmp.set("v.invoiceList",result);		
            }
            else
            {
                console.log('checkerror+++'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action1);
    },
    
   CHUNK_SIZE: 750000,
    uploadHelper :  function(cmp,evt)
    {
       // cmp.set("v.processingText",true);
       // cmp.set("v.displaydetails",false);
        console.log('inside file else');
            var fileInput = cmp.find("fileId").get("v.files");
        	var file = fileInput[0];
            var self = this;
            var fr = new FileReader();
       		fr.onload = $A.getCallback(function() {
            /*const base64Mark = 'base64,';
			const dataStart = base64.indexOf(base64Mark) + base64Mark.length;
			base64 = base64.substring(dataStart);*/
                
           var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
    	    self.uploadprocess(cmp, file, fileContents);
	    });
          fr.readAsDataURL(file);
    },
    uploadprocess: function(cmp, file, fileContents) {
      // cmp.set("v.processingText",true);
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.updateinvoicewithfile(cmp, file, fileContents, startPosition, endPosition, '');
    },
    updateinvoicewithfile: function(cmp, file, fileContents,startPosition, endPosition, attachId) {
       cmp.set("v.processingText",true);
        cmp.set("v.displaydetails",false);
        console.log('inside next methiod');
        var getchunk = fileContents.substring(startPosition, endPosition);
        var recid1 = cmp.get("v.recordId");
        var ponum = document.getElementById("ponumber").value;
        var comment = cmp.find("comments").get("v.value");
        var action2 = cmp.get("c.Updateinvoicewithfile");
        console.log('check state+++226732');
        action2.setParams({"ponumber": ponum,"comments":comment,"taskid": recid1,"filename":file.name,"base64Data":encodeURIComponent(getchunk),"contentType":file.type});
            action2.setCallback(this, function(a) {
			var state2 = a.getState();
            console.log('check state+++222'+state2);
			if(state2 === "SUCCESS") {
                cmp.set("v.displaysucces",true);
               	cmp.set("v.processingText",false);
                cmp.set("v.displaydetails",false);
               
            }
        
    });            
            $A.enqueueAction(action2); 
    }
    
    })