/**
 * Created by mrahman on 2020-11-28.
 */
({
    showSuccess: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : "success",
            "title": "Success!",
            "message": message
        });
        toastEvent.fire();
    },
    showError: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : "error",
            "title": "Error!",
            "message": message
        });
        toastEvent.fire();
    },
    showWarning: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : "warning",
            "title": "Warning!",
            "message": message
        });
        toastEvent.fire();
    },

    toggleView : function(component, event){
        //console.log("Toggle View");
        var toggleText = component.find("searchBox2");
        $A.util.toggleClass(toggleText, "slds-is-open");
    },

    findAddressX: function (component, event) {
        //console.log('finding address with findAddressX');
        var serConfig = component.get("v.serConfig");

        var Text = component.find("searchBox").get("v.value");
        if (Text === "") {
            this.showError("Please enter an postcode");
            return;
        }

        var Container = "";
        var displayList = component.get("v.displayList");
        var SecondFind = component.get("v.result");

        //console.log("search Params - Text::: " + Text);
        if (SecondFind.Id != undefined) {
            Container = SecondFind.Id;
            console.log("Container >> " + Container);
        }

        //console.log(serConfig.ServiceKey);
        var Key = serConfig.ServiceKey,
            IsMiddleware = false,
            Origin = "",
            Countries = "GBR",
            Limit = "10",
            Language = "en-gb",
            url = serConfig.BaseURL + serConfig.FindAddress;
        var params = '';
        params += "&Key=" + encodeURIComponent(Key);
        params += "&Text=" + encodeURIComponent(Text);
        params += "&IsMiddleware=" + encodeURIComponent(IsMiddleware);
        params += "&Container=" + encodeURIComponent(Container);
        params += "&Origin=" + encodeURIComponent(Origin);
        params += "&Countries=" + encodeURIComponent(Countries);
        params += "&Limit=" + encodeURIComponent(Limit);
        params += "&Language=" + encodeURIComponent(Language);
        var http = new XMLHttpRequest();
        http.open('POST', url, true);
        http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        http.onreadystatechange = function () {
            if (http.readyState == 4 && http.status == 200) {
                var response = JSON.parse(http.responseText);

                if (response.Items.length == 1 && typeof (response.Items[0].Error) != "undefined") {
                    this.showError(response.Items[0].Description);
                }
                else {
                    if (response.Items.length == 0)
                        this.showError("Sorry, there were no results");

                    else {
                        if (response.Items[0].Type === "Address") {
                            var items = component.get("v.options");

                            for (var i = 0; i < response.Items.length; i++) {
                                var item = {
                                    "label": response.Items[i].Text + " " + response.Items[i].Description,
                                    "value": response.Items[i].Id,
                                };
                                items.push(item);
                            }
                            if (items.length > 0) {
                                component.set("v.options", items);
                                component.set("v.displayOptions", true);
                                component.set("v.showSpinner",false);
                            }
                        }

                        if (response.Items[0].Type !== "Address") {
                            component.set("v.result", response.Items[0]);
                            var afEvent = component.getEvent("adrsFinderEevnt");
                            //console.log("eventFired >>> " + JSON.stringify(afEvent));
                            afEvent.setParams({ "size": response.Items.length });
                            afEvent.fire();
                        } else {
                            //console.log("Type is:: " + JSON.stringify(response.Items[0].Type) + " No more event is fired");
                            var toggleText = component.find("searchBox2");
                            $A.util.toggleClass(toggleText, "slds-is-open");
                        }
                    }
                }
            }
        }
        http.send(params);
    },

    retrieveAddress: function (component, event) {
        var serConfig = component.get("v.serConfig");
        var Key = serConfig.ServiceKey;
        var Id = event.getParam("value");
        //console.log("Id:: " + Id);

        var Field1Format = "";
        var url = serConfig.BaseURL + serConfig.RetrieveAddress;
        var params = '';
        params += "&Key=" + encodeURIComponent(Key);
        params += "&Id=" + encodeURIComponent(Id);
        params += "&Field1Format=" + encodeURIComponent(Field1Format);

        var http = new XMLHttpRequest();
        http.open('POST', url, true);
        http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        http.onreadystatechange = function () {
            if (http.readyState == 4 && http.status == 200) {
                var response = JSON.parse(http.responseText);

                if (response.Items.length == 1 && typeof (response.Items[0].Error) != "undefined") {
                    this.showError(response.Items[0].Description);
                }
                else {
                    if (response.Items.length == 0)
                        this.showError("Sorry, there were no results");
                    else {
                        var res = response.Items[0];
                        //console.log("working..." + JSON.stringify(res));
                        var resBox = document.getElementById("output");
                        resBox.innerText = res.Label;
                        document.getElementById("output").style.display = "block";
                        document.getElementById("separator").style.display = "block";
                        component.set("v.addressDetails",JSON.stringify(res));

                        var saEvent = component.getEvent("saveAddressEvent");
                        //console.log("eventFired >>> " + JSON.stringify(saEvent));
                        saEvent.setParams({ "size": response.Items.length });
                        saEvent.fire();
                    }
                }
            }
        }
        http.send(params);
    },

    getCurrentAddress : function(component, event){
        //console.log("getting current address");
        var recordId = component.get("v.recordId");
        var action = component.get("c.getAddressDetails");
        action.setParams({recordId : recordId});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var address = response.getReturnValue();
                //var res = address;
                var resBox = document.getElementById("output");
                console.log('address: ' + JSON.stringify(address));
                //console.log('state: ' + address.state);

                if(address !== null) {
                    console.log("Address is not null");
                    var adrState = address.state,
                        adrCountry = address.country === undefined ?"":address.country,
                        adrCity = address.city,
                        adrPostCode = address.postalCode,
                        adrStreet = address.street,
                        adrState = address.state === undefined ?"":address.state+"\n",
                        adrCompany = address.company === undefined ?"":address.company+"\n";

                    resBox.innerText =adrCompany + adrStreet +"\n"+ adrCity +"\n"+ adrPostCode +"\n"+ adrCountry;
                    document.getElementById("output").style.display = "block";
                    
                    //hasAddressEvent
                    var saEvent = component.getEvent("hasAddressEvent");
                    //console.log("eventFired >>> " + JSON.stringify(saEvent));
                    saEvent.setParams({ "size": 0, "canProceed": true, "showError": false });
                    saEvent.fire();

                } else {
                    var saEvent = component.getEvent("hasAddressEvent");
                    //console.log("eventFired >>> " + JSON.stringify(saEvent));
                    saEvent.setParams({ "size": 0, "canProceed": false, "msg": "Address is required!"});
                    saEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    } 
})