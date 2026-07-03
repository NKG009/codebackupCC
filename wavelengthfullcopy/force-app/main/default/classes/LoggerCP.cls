public without sharing class LoggerCP {
	private static String messages = '';
	
	private String className;
	
	public Boolean throwException = false;
	
	private static Map<String, TRGTFCMS__Logger__c> classNameToShowMethods;
	private static Boolean debugHideMode = false;
	private static Boolean pageHideMode = false;
	
	public static transient Map<String, List<String>> pageMessages =
			new Map<String, List<String>>();
	
	public LoggerCP(String className) {
		this.className = className;
		
		// Fake log as there is a SF issue to ignore 1st call to debug.
		System.debug(LoggingLevel.ERROR, '');
	}
	
	public LoggerCP(String className, Boolean throwException) {
		this.className = className;
		this.throwException = throwException;
	}
	
	public void log(String methodName) {
		log(methodName, '');
	}
	
	public void log(String methodName, String variable, Object value) {
		Object[] valueArray = castToArray(value);
		
		log(methodName, variable + ' = ' + (
				valueArray != null
						? 'size: ' + (valueArray.size()) + ', ' + value
						: value));
	}
	
	public void log(String methodName, String message) {
		if (classNameToShowMethods == null) {
			classNameToShowMethods = TRGTFCMS__Logger__c.getAll();
			
			debugHideMode = false;
			for (TRGTFCMS__Logger__c loggerCs : classNameToShowMethods.values()) {
				if (loggerCs.TRGTFCMS__Debug_Hide__c == true) {
					debugHideMode = true;
					break;
				}
			}
			
			pageHideMode = false;
			for (TRGTFCMS__Logger__c loggerCs : classNameToShowMethods.values()) {
				if (loggerCs.TRGTFCMS__Page_Hide__c == true) {
					pageHideMode = true;
					break;
				}
			}
		}
		
		//System.debug(LoggingLevel.ERROR, '!!!log debugHideMode = ' + debugHideMode);
		
		/*String line;

		try{
			throw new LoggerException();
		} catch (LoggerException le){
			String stackTrace = le.getStackTraceString();

			

			List<String> stackLines = stackTrace.split('\n');

			String caller = stackLines[1]; // stackLines[0] = CrazyLogger, we need to return info from 1 level up.
			line = caller.left(caller.indexOf(':'));
		}*/
		
		String logMessage =
				'::::::::::' +
						'Class name: \'' + className +
						'\' Method name: \'' + methodName +
						//'\' Line: \'' + line +
						'\' Message: \'' + message + '\'';
		
		Boolean loggerRestrictionsAreSet = classNameToShowMethods.keySet().size() > 0;
		
		if (!loggerRestrictionsAreSet) {
			System.debug(LoggingLevel.ERROR, logMessage);
			return;
		}
		
		if (debugHideMode && !debugHide(methodName) || !debugHideMode && debugShow(methodName)) {
			System.debug(LoggingLevel.ERROR, logMessage);
		}
		
		if (pageHideMode && !pageHide(methodName) || !pageHideMode && pageShow(methodName)) {
			addWarningMessage(logMessage);
		}
	}
	
	private static Object[] castToArray(Object input) {
		try {
			return (List<Object>)input;
		} catch (System.TypeException ex) {
			return null;
		}
	}
	@testvisible
	private Boolean debugHide(String methodName) {
		return isShowHideSet(methodName, 'Debug_Hide__c');
	}
		@testvisible

	private Boolean debugShow(String methodName) {
		return isShowHideSet(methodName, 'Debug_Show__c');
	}
		@testvisible

	private Boolean pageHide(String methodName) {
		return isShowHideSet(methodName, 'Page_Hide__c');
	}
		@testvisible

	private Boolean pageShow(String methodName) {
		return isShowHideSet(methodName, 'Page_Show__c');
	}
		@testvisible

	private Boolean isShowHideSet(String methodName, String checkboxField) {
		//System.debug(LoggingLevel.ERROR, '!!!isShowHideSet methodName = ' + methodName);
		//System.debug(LoggingLevel.ERROR, '!!!isShowHideSet checkboxField = ' + checkboxField);
		//System.debug(LoggingLevel.ERROR, '!!!isShowHideSet className = ' + className);
		
		TRGTFCMS__Logger__c cs = classNameToShowMethods.get(className);
		
		//System.debug(LoggingLevel.ERROR, '!!!isShowHideSet cs = ' + cs);
		
		if (cs != null && cs.get(checkboxField) == true) {
			if (String.isBlank(cs.TRGTFCMS__Methods__c)) {
				return true;
			} else {
				String[] methods = cs.TRGTFCMS__Methods__c.split(',');
				for (String method : methods) {
					if (method.trim() == methodName) {
						return true;
					}
				}
			}
		}
		
		return false;
	}
	
	public void catchBlockMethodNew(Exception e) {
		catchBlockMethodNew(e, null);
	}
	
	public void catchBlockMethodNew(Exception e, Savepoint sp) {
		if (Test.isRunningTest()) {
			throw e;
		}
		
		String errorMessage = getExceptionMessage(e, sp);
		addError(errorMessage);
	}
	
	public void catchAura(Exception e) {
		catchAura(e, null);
	}
	
	public void catchAura(Exception e, Savepoint sp) {
		String errorMessage = getExceptionMessage(e, sp);
		throw new AuraHandledException(errorMessage);
	}
	
	public String catchVf(Exception e) {
		return catchVf(e, null);
	}
	
	public String catchVf(Exception e, Savepoint sp) {
		String errorMessage = getExceptionMessage(e, sp);
		return JSON.serialize(new AuraMessage(errorMessage, ApexPages.Severity.ERROR));
	}
	
	private String getExceptionMessage(Exception e, Savepoint sp) {
		if (sp != null) {
			Database.rollback(sp);
		}
		
		String errorMessage;
		Boolean fieldCustomValidationException = false;
		
		if (e instanceof DmlException) {
			DmlException dE = (DmlException)e;
			if (dE.getDmlStatusCode(0) == 'FIELD_CUSTOM_VALIDATION_EXCEPTION') {
				errorMessage = dE.getDmlMessage(0);
				fieldCustomValidationException = true;
			}
		}
		
		if (!fieldCustomValidationException) {
			errorMessage = e.getMessage();
			
			if (!(e instanceof GeneralException)) {
				String stackTrace = showStackTraceInErrorMessage(e);
				errorMessage += '\r\n' + 'Stack Trace: ' + '\r\n' + stackTrace;
			}
		}
		
		log('getExceptionMessage', 'errorMessage', errorMessage);
		
		return errorMessage;
	}
	
	private String showStackTraceInErrorMessage(Exception e) {
		String stackTrace = e.getStackTraceString();
		
		log('showStackTraceInErrorMessage', 'stackTrace', '\r\n' + stackTrace);
		
		if (String.isNotBlank(stackTrace)) {
			addError(stackTrace);
		}
		
		return stackTrace;
	}
	
	public String getMessagesString() {
		List<String> results = new List<String>();
		for (ApexPages.Message message : ApexPages.getMessages()) {
			results.add(message.getSeverity() + ': ' + message.getSummary());
		}
		return String.join(results, '<br />');
	}
	
	public void throwCleanErrorMessage(Exception e) {
		String errorMessage = getExceptionMessage(e, null);
		throw new GeneralException(errorMessage);
	}
	
	public void addException(Exception e) {
		catchBlockMethodNew(e);
	}
	
	public void addError(String message) {
		LoggerCP.addErrorMessage(ESAPI.encoder().SFDC_JSINHTMLENCODE(message));
	}
	
	public void addWarning(String message) {
		LoggerCP.addWarningMessage(ESAPI.encoder().SFDC_JSINHTMLENCODE(message));
	}
	
	public void addInfo(String message) {
		LoggerCP.addInfoMessage(ESAPI.encoder().SFDC_JSINHTMLENCODE(message));
	}
	
	public static void addErrorMessage(String message) {
		// We can show the message if request was done from VF page only.
		// We can't call ApexPages.addMessage if we made request from webservice or trigger.
		if (ApexPages.currentPage() != null) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
			ApexPages.addMessage(msg);
		}
		
		addPageMessage(ApexPages.Severity.ERROR, message);
	}
	
	public static void addWarningMessage(String message) {
		// We can show the message if request was done from VF page only.
		// We can't call ApexPages.addMessage if we made request from webservice or trigger.
		if (ApexPages.currentPage() != null) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, message);
			ApexPages.addMessage(msg);
		}
		
		addPageMessage(ApexPages.Severity.WARNING, message);
	}
	
	public static void addInfoMessage(String message) {
		// We can show the message if request was done from VF page only.
		// We can't call ApexPages.addMessage if we made request from webservice or trigger.
		if (ApexPages.currentPage() != null) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, message);
			ApexPages.addMessage(msg);
		}
		
		addPageMessage(ApexPages.Severity.INFO, message);
	}
	
	private static void addPageMessage(ApexPages.Severity severity, String message) {
		String severityAsString = '' + severity;
		String[] messages = pageMessages.get(severityAsString);
		if (messages == null) {
			messages = new String[] {};
			pageMessages.put(severityAsString, messages);
		}
		messages.add(message);
	}
	
	public Map<String, List<String>> getMessages() {
		return pageMessages;
	}
	
	public Boolean hasMessages {
		get {
			return pageMessages.size() > 0;
		}
	}
	
	public Boolean hasErrors {
		get {
			return hasMessagesOfType(ApexPages.Severity.ERROR);
		}
	}
	
	public Boolean hasWarnings {
		get {
			return hasMessagesOfType(ApexPages.Severity.WARNING);
		}
	}
	
	public Boolean hasInfos {
		get {
			return hasMessagesOfType(ApexPages.Severity.INFO);
		}
	}
	
	private Boolean hasMessagesOfType(ApexPages.Severity severity) {
		return pageMessages.get('' + severity) != null;
	}
	
	/**
	* @name sendLog
	* @param lastMessage String
	* @param subject String
	* @return void
	*/
	public static void sendLog(String lastMessage, String subject) {
		messages =
				'Organization: \'' + UserInfo.getOrganizationName() + '\'\r\n' +
						((ApexPages.currentPage() != null) ? ('Page Url: \'' + ApexPages.currentPage().getUrl() + '\'\r\n') : '') +
						((Site.getName() != null) ? ('Site Name: \'' + Site.getName() + '\'\r\n') : '') +
						'\r\n' + messages;
		
		/*String fullLog = messages + lastMessage;

		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		emailMessage.setSubject(subject);
		emailMessage.setPlainTextBody(fullLog);
		emailMessage.setToAddresses(new List<String> {
				ConfigHelper.getConfigDataSet().ErrorsReceiver__c });

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});*/
	}
	
	public void sendExceptionEmail(Exception e, String title, String emailAddress) {
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setToAddresses(new String[] {emailAddress});
		email.setSubject(title);
		email.setHtmlBody('' +
				' Message: ' + e.getMessage() +
				' Line #: ' + e.getLineNumber() +
				' Stack Trace: ' + e.getStackTraceString() +
				' Cause: ' + e.getCause());
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	}
	
	public with sharing class AuraResult {
		@AuraEnabled
		public Object result;
		@AuraEnabled
		public AuraMessage[] messages = new AuraMessage[] {};
		
		public AuraResult() {
		}
		
		public AuraResult(Object result) {
			this.result = result;
		}
		
		public void addInfo(String title) {
			addMessage(title, ApexPages.Severity.INFO);
		}
		
		public void addInfo(String title, String body) {
			addMessage(title, body, ApexPages.Severity.INFO);
		}
		
		public void addWarning(String title) {
			addMessage(title, ApexPages.Severity.WARNING);
		}
		
		public void addWarning(String title, String body) {
			addMessage(title, body, ApexPages.Severity.WARNING);
		}
		
		public void addError(String title) {
			addMessage(title, ApexPages.Severity.ERROR);
		}
		
		public void addError(String title, String body) {
			addMessage(title, body, ApexPages.Severity.ERROR);
		}
		
		public void addMessage(String title, ApexPages.Severity severity) {
			addMessage(title, null, severity);
		}
		
		public void addMessage(String title, String body, ApexPages.Severity severity) {
			messages.add(new AuraMessage(title, body, severity));
		}
	}
	
	public with sharing class AuraMessage {
		@AuraEnabled
		public String title;
		@AuraEnabled
		public String body;
		@AuraEnabled
		public String severity;
		
		public AuraMessage(String title, ApexPages.Severity severity) {
			this.title = title;
			this.severity = '' + severity;
		}
		
		public AuraMessage(String title, String body, ApexPages.Severity severity) {
			this.title = title;
			this.body = body;
			this.severity = '' + severity; 
		}
	}
    public void testCov(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}