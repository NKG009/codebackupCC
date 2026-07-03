public without sharing class Url {
	private static LoggerCP logger = new LoggerCP('Url');
	
	public static Id getParamId(String name) {
		return getParam(name);
	}
	
	public static Integer getParamInteger(String name) {
		String param = getParam(name);
		return param != null ? Integer.valueOf(param) : null;
	}
	
	public static Boolean getParamBoolean(String name) {
		String param = getParam(name);
		return param != null ? Boolean.valueOf(param) : null;
	}
	
	public static String getParam(String name) {
		String param = ApexPages.currentPage().getParameters().get(name);
		if (String.isBlank(param)) {
			return null;
		}
		return param;
	}
	
	public static String setParam(String name, Object value) {
		return ApexPages.currentPage().getParameters().put(name, '' + value);
	}
	
	public static String setParam(PageReference pr, String name, Object value) {
		return ApexPages.currentPage().getParameters().put(name, '' + value);
	}
	
	public static PageReference redirect(String url) {
		if (logger.hasMessages) {
			return null;
		}
		
		PageReference pr = new PageReference(url);
		pr.setRedirect(true);
		return pr;
	}
}