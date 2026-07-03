/**
 * Created by mrahman on 2020-08-21.
 * var urlRedirect = $A.get("$Label.c.Lightning_Component_URL")+"current-job-orders?site="+param;
 * iconName : 'utility:delete',
 */
({
    doInit: function (component, event, helper) {
        /*var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Cancel Request', name: 'cancel_request' }
        ];*/
        var actions = helper.getRowActions.bind(this, component);
        component.set('v.columns', [
            {
                label: 'Job Order Name',
                fieldName: 'Name',
                type: 'text'
            },
            { label: 'Start Date', fieldName: 'sirenum__StartDate__c', type: 'date-local', sortable: 'true'},
            { label: 'End Date', fieldName: 'sirenum__EndDate__c', type: 'date-local'},
            { label: 'Date Confirmed', fieldName: 'Date_Confirmed__C', type: 'date-local'},
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'date-local'},
            { label: 'Status', fieldName: 'sirenum__Status__c', type: 'text'},
            {
                type: 'action',
                typeAttributes: { rowActions: actions }

            }
        ]);
        helper.getJobOrders(component);
        $A.get('e.force:refreshView').fire();
    },

    handleRowAction: function(component, event, helper){
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                helper.goToRecordDetail(component, row);
                break;
            case 'cancel_booking':
                helper.makeCancelRequest(component, row);
                break;
        }
    },

    handleSort: function(component, event, helper) {
        helper.handleSort(component, event);
    }
})