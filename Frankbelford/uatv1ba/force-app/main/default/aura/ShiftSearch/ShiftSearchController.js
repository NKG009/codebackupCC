({
    doInit: function(component,event,helper){
        var siteList = component.get("c.getSites");
        siteList.setCallback(this, function(response) {
            var state = response.getState();
            var optsSite = [];
            if(component.isValid() && state == "SUCCESS") {
                var SiteArray = response.getReturnValue();
                optsSite.push({
                    class: "optionClass",
                    label: "Select Site",
                    value: ""
                });
                for (var i = 0; i < SiteArray.length; i++) {
                    optsSite.push({
                        class: "optionClass",
                        label: SiteArray[i].Name,
                        value: SiteArray[i].Id
                    });
                }
                component.set("v.SiteList", optsSite);
                
                var optionsContact = [];
                optionsContact.push({
                    class: "optionClass",
                    label: "Select Candidate",
                    value: ""
                });
                component.set("v.ContactList", optionsContact);
            }
        });
        
        var siteContactMap = component.get("c.getsiteContactMap");
        siteContactMap.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                var siteContactMap = response.getReturnValue();
                component.set('v.SiteContactMap',siteContactMap);
            }
        });
        $A.enqueueAction(siteList);
        $A.enqueueAction(siteContactMap);
        
    },
    siteChanged: function(component,event,helper){
        helper.siteChanged1(component,event);
    },
    SearchShifts: function(component,event,helper){
           var toastEvent = $A.get("e.force:showToast");
        component.find("match").set("v.checked",false);
        var myEvent = $A.get("e.c:ShiftSearchEvent");
        myEvent.setParams({ "site": component.find("site").get("v.value")});
        myEvent.setParams({ "contact": component.find("contact").get("v.value")});
        myEvent.setParams({ "startDate": component.find("startDate").get("v.value")});
        myEvent.setParams({ "endDate": component.find("endDate").get("v.value")});
        var inputCmp1  	= component.find("startDate");
        var inputCmp2 	= component.find("endDate");
        var date1  		= inputCmp1.get("v.value");
        var date2 		= inputCmp2.get("v.value");  
        if(date1>date2 && date2!="")
        {
             
                toastEvent.setParams({
                  
                    "title" : "Error!!",
                    "message": "From Date cannot be greater than To date"
                    
                });

             toastEvent.fire();
        }
        myEvent.fire();
        
    },
    ClearAllfilter: function(component,event,helper){
        component.find("match").set("v.checked",false);
        component.find("site").set("v.value",null);
        component.find("contact").set("v.value",null);
        component.find("startDate").set("v.value",null);
        component.find("endDate").set("v.value",null);
        component.find("site").set("v.value",'')
        helper.siteChanged1(component,event);
        var myEvent = $A.get("e.c:ShiftSearchEvent");
        myEvent.setParams({ "site": component.find("site").get("v.value")});
        myEvent.setParams({ "contact": component.find("contact").get("v.value")});
        myEvent.setParams({ "startDate": component.find("startDate").get("v.value")});
        myEvent.setParams({ "endDate": component.find("endDate").get("v.value")});
        myEvent.fire();
        
    },
    ApproveAll: function(component,event,helper){
        component.find("match").set("v.checked",false);
        var myEvent = $A.get("e.c:ShiftApproveAllEvent");
        myEvent.fire();
    },
    Matched: function(component,event,helper){
        var myEvent = $A.get("e.c:ShiftMatchedOnly");
        myEvent.setParams({ "MatchedOnly": component.find("match").get("v.checked")});
        myEvent.fire();
    }
})