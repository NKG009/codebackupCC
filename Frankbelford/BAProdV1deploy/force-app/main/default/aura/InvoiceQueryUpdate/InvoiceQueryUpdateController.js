({
	doInit : function(cmp, evt, helper) {
       /*  var query = location.search.substr(1);
        console.log('query++++'+query);
       var result ;
        query.split("?").forEach(function(part) {
            var item = part.split("=");
            console.log('item++++'+item);
            //result[item[0]] = decodeURIComponent(item[1]);
            result = item[1];
            result = result.slice(0, -4);
        });
        console.log('result++++'+result);
        component.set("v.recordId",result);
        var recid = cmp.get("v.recordId");
        console.log('check in init--->'+cmp.get("v.recordId"))
        cmp.set("v.Accrecid",recid);*/
		var myPageRef = cmp.get("v.pageReference");
        var accs = myPageRef.state.c__listofAccounts;
        var idcheck = myPageRef.state.c__accid;
        cmp.set("v.Accrecid",idcheck);
        console.log('check id new--->'+idcheck);
         cmp.set("v.listofInvoices",accs);
        console.log('check accs id--->'+accs);
      	var action = cmp.get("c.getInvoicedetails");
		action.setParams({"InvoiceIDS": accs});
        action.setCallback(this, function(response) {
			var state = response.getState();
            var result = response.getReturnValue();
			if(state === "SUCCESS") {				
				console.log('Success--->'+result);
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
                 if(result == 'actioned')
                {
                     cmp.set("v.displayactioned",true);
                }
                 
                // window.location.reload();    
            }
        });
        $A.enqueueAction(action); 
       // helper.geterrordetails(cmp, evt);
         var delayInMilliseconds = 500;
            window.setTimeout(
            $A.getCallback(function() {
            helper.getInvoicedetails123(cmp,accs); 
                 }), delayInMilliseconds
        );    
		//helper.getInvoicedetails123(cmp);
        },
     handleCloseModal: function(cmp, _evt, helper) {
        //For Close Modal, Set the "openModal" attribute to "fasle"  
      /*  var recid = cmp.get("v.Accrecid");
         console.log('recordid'+recid);*/
        cmp.set("v.displayblankerror", false);
          cmp.set("v.displaymore1", false);
          cmp.set("v.displaydetails", false);
         cmp.set("v.displaysucces", false);
         cmp.set("v.displayactioned",false);
          var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
     "url": '/lightning/r/' + cmp.get("v.Accrecid")+'/related/Invoice_Queries__r/view'
            // "url" : '/lightning/r/0010Y00000nMJm2QAG/related/Invoice_Queries__r/view'
    });
    urlEvent.fire();
         $A.get('e.force:refreshView').fire(); 
        // window.location.reload();
          var delayInMilliseconds = 500;
            window.setTimeout(
            $A.getCallback(function() {
             window.location.reload();
                 }), delayInMilliseconds
        );
    },
    Updaterecord: function(cmp, evt, helper) {
        var ponum = document.getElementById("ponumber").value;
        var comment = cmp.find("comments").get("v.value");
        if(comment == null || comment == '' || comment == 'undefined')
        {
            cmp.set("v.commentsnull",true);
        }
        else
        {
        var myPageRef = cmp.get("v.pageReference");
        var accs1 = myPageRef.state.c__listofAccounts;
        console.log('check in req method+++');
        var action1 = cmp.get("c.Updaterecordandsendemail");
        action1.setParams({"ponumber": ponum,"comments":comment,"InvoiceIDS": accs1});
        action1.setCallback(this, function(response) {
			var state1 = response.getState();
            console.log('check state+++'+state1);
			if(state1 === "SUCCESS") {
                cmp.set("v.displaysucces",true);
                cmp.set("v.displaydetails",false);
            }
        
    });
        $A.enqueueAction(action1); 
                           }
    }
	
})