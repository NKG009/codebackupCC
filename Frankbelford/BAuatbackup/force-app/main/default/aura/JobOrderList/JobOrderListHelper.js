/**
 * Created by mrahman on 2020-08-21.
 */
({
    getJobOrders : function(component) {
        console.log(">>> getJobOrders--->>>");
        var action = component.get("c.getJobOrders");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var status = component.get("v.status");
        console.log("User:" + userId + " status:"+status);
        action.setParams({"userId":userId, "status":status});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Job Order List>> ' + JSON.stringify(response.getReturnValue()));
                component.set('v.data', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            } else {
                console.error("I'M SORRY, I DON'T UNDERSTAND THE SITUATION");
            }
        }));
        $A.enqueueAction(action);
    },

    getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        //alert('row.sirenum__Status__c:: ' + row.sirenum__Status__c);
        if (row.sirenum__Status__c === 'Pending') {
            actions.push({ 'label': 'Show details', 'name': 'show_details' },
                         { 'label': 'Cancel Booking', 'name': 'cancel_booking' });
        } else {
            actions.push({
                'label': 'Show details',
                'name': 'show_details'
            });
        }
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },

    goToRecordDetail : function(component, row) {
        console.log("In goToRecordDetail");
        //alert('Showing Details: ' + JSON.stringify(row));
        //alert('RecordId: ' + row.Id);
        //var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"job-order-details?recordId="+row.Id;
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"joborder/"+row.Id+"/"+row.Name;//"joborder/:recordId(/:recordName)"
        window.location.replace(urlRedirect);
        return false;

    },

    makeCancelRequest : function(component, row) {
        console.log("In makeCancelRequest");
        //alert('Your quest is our command! \n Sorry comeback later \n\n Booking Details: ' + JSON.stringify(row));
        var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"cancel-booking?recordId="+row.Id;
        window.location.replace(urlRedirect);
        return false;
    },

    setData: function(component) {
        cmp.set('v.data', this.DATA);
    },

    sortBy: function(field, reverse, primer) {
        var key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },

    handleSort : function(component, event) {
        console.log("In handleSort");
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var cloneData = component.get("v.data").slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
        component.set('v.data', cloneData);
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
    }
})