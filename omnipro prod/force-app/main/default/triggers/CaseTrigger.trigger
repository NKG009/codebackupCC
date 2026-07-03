trigger CaseTrigger on Case (after insert, after update) {
	system.debug('Case Trigger Triggered');
      CaseTriggerHandler.updateTrackedTimeForOpportunities(Trigger.new);
}