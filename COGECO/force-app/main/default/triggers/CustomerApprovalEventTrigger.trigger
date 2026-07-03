trigger CustomerApprovalEventTrigger on Customer_Approval_Event__e(after insert) {
	CustomerAppprovalEventTriggerHandler.setCustomerApprovalDetails(Trigger.new);
}