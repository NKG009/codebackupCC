({
	doInit : function(cmp, event, helper) {
        
        var recid = cmp.get("v.recordId");
        console.log('check in init--->'+cmp.get("v.recordId"));
		var action = cmp.get("c.querydetails");
		action.setParams({"InvoiceiD": recid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
			if(state === "SUCCESS") {				
				console.log('Success--->'+result);
                if(result == 'actioned')
                {
                     cmp.set("v.displayactioned",true);
                }
                if(result == 'openpopup')
                {
                     cmp.set("v.displaydetails",true);
                }
        }
	});
         $A.enqueueAction(action); 
         var delayInMilliseconds = 500;
            window.setTimeout(
            $A.getCallback(function() {
            helper.getinvoicedetails(cmp,recid); 
                 }), delayInMilliseconds
        );    
    },
	closeClick : function(cmp, evt, helper) {
        $A.get("e.force:closeQuickAction").fire();
         $A.get('e.force:refreshView').fire(); 
	},
     handleFilesChange: function(cmp, evt, helper) {
        var fileName = 'No File Selected..';
        if (evt.getSource().get("v.files").length > 0) {
            fileName = evt.getSource().get("v.files")[0]['name'];
        }
        cmp.set("v.fileName", fileName);
         console.log('check in first method'+fileName);
    },
    handleCloseModal: function(cmp, _evt, helper) {
        //For Close Modal, Set the "openModal" attribute to "fasle"      
          cmp.set("v.displaydetails", false);
         cmp.set("v.displaysucces", false);
         cmp.set("v.displayactioned",false);
         $A.get('e.force:refreshView').fire(); 
    },
	 Updateinvoicerecord: function(cmp, evt, helper) {
         console.log('inside method');
		var ponum = document.getElementById("ponumber").value;
        var comment = cmp.find("comments").get("v.value");
		var checkname = cmp.get("v.fileName");
		if(checkname == 'No File Selected..')
		{
            console.log('inside file if');
            if(comment == null || comment == '' || comment == 'undefined')
			{
				cmp.set("v.commentsnull",true);
			}
			else
			{
                cmp.set("v.processingText",true);
         	 cmp.set("v.displaydetails",false);
             var recid1 = cmp.get("v.recordId");
            var action1 = cmp.get("c.Updateinvoicerecordandemail");
            action1.setParams({"ponumber": ponum,"comments":comment,"invoiceid": recid1});
            action1.setCallback(this, function(response) {
			var state1 = response.getState();
            console.log('check state+++'+state1);
			if(state1 === "SUCCESS") {
                cmp.set("v.displaysucces",true);
                cmp.set("v.displaydetails",false);
                cmp.set("v.processingText",false);
            }
        
    });
        $A.enqueueAction(action1); 
                           }
           
		}
		else
		{
			  if(comment == null || comment == '' || comment == 'undefined')
			{
				cmp.set("v.commentsnull",true);
			}
			else
			{
            helper.uploadHelper(cmp, evt);
            }
	    }
     } 
   
})