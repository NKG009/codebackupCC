({
    checkMatched : function(component) {
        var matched = component.find("match").get("v.checked");
        if(matched && (component.find("site").get("v.value")!='' ||
                       component.find("contact").get("v.value")!='' ||
                       component.find("startDate").get("v.value")!='')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Match Shift can’t be used in conjunction with the filters.",
                "message": "Error!"
            });
            toastEvent.fire();
        }
        
        
    },
    siteChanged1: function(component,event){
        var siteSelected = component.find("site").get("v.value");
        var siteContactMap = component.get('v.SiteContactMap');
        var contactArray = siteContactMap[siteSelected];
        console.log('@@ '+contactArray);
        var optionsContact = [];
        optionsContact.push({
            class: "optionClass",
            label: "Select Candidate",
            value: ""
        });
        if(contactArray!=null){
            for (var i = 0; i < contactArray.length; i++) {
                optionsContact.push({
                    class: "optionClass",
                    label: contactArray[i].Name,
                    value: contactArray[i].Id
                });
            }
        }
        component.set("v.ContactList", optionsContact);
        component.find("contact").set("v.value","");
    },
})