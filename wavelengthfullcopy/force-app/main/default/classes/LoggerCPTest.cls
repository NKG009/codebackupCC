@isTest
private class LoggerCPTest {

  @isTest
  private static void test() {  
    insert new AVTRRT__Logger__c(Name = 'Test', AVTRRT__Methods__c = 'Temp',AVTRRT__Debug_Hide__c = true,AVTRRT__Page_Hide__c = true);

    LoggerCP logger = new LoggerCP('Test');
    logger = new LoggerCP('Test', true);
        
    logger.log('Temp');
    logger.log('Temp', '');
    logger.log('Temp', '', '');

    logger.addError('');
    logger.addWarning('');
    logger.addInfo('');
    logger.addError('');
        logger.addWarning('');
        loggerCP.sendLog('Test','Test');
        logger.addInfo('');
        logger.testCov();
        logger.getMessagesString();
        LoggerCP.addErrorMessage('');
        
      try {
      // Generates an exception.
      Integer i = 100/0;
    } catch(Exception e) {
      try {
        logger.catchBlockMethodNew(e);
      } catch (Exception ex) {}
    }
  }
}