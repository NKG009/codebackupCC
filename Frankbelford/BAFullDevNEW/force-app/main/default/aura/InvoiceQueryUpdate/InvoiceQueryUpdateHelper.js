({
	 geterrordetails : function(cmp, evt) {
       /*   console.log('+++line 3+++');
        var myPageRef = cmp.get("v.pageReference");
         console.log('+++line 4+++');
        var accs = myPageRef.state.c__listofInvoices;
         console.log('+++list+++'+accs);*/
          var accs = cmp.get("v.listofInvoices");
      	var action = cmp.get("c.getInvoicedetails");
		action.setParams({"InvoiceIDS": accs});
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
            console.log('+++state+++263'+state);
			if(state === "SUCCESS") {				
				console.log('Success'+result);
                if(result == 'blankvalue')
                {
                     cmp.set("v.displayblankerror",true);
                }
                if(result == 'morethan1')
                {
                    cmp.set("v.displaymore1",true);
                }
                if(result == 'openpopup')
                {
                     cmp.set("v.displaydetails",true);
                }
                 
                // window.location.reload();    
            }
        })
        $A.enqueueAction(action);
     },
	
	getInvoicedetails123 : function(cmp,accs) {
       var action1 = cmp.get("c.getInvoicerecorddetails");
		action1.setParams({"InvoiceIDS": accs});
        action1.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				var result = response.getReturnValue();
				cmp.set("v.invoiceList",result);
                cmp.set("v.Accountnav",result[0].IP_Account__c);		}
            else
            {
                console.log('checkerror+++'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action1);
    }
    
})