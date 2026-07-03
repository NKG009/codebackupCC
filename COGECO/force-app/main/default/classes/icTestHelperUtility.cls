@isTest
public with sharing class icTestHelperUtility {
	static Integer s_num = 1;

	public static String getFakeId(Schema.SObjectType sot)
	{
		String result = String.valueOf(s_num++);
		String shortId = sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
		String longId = convertId(shortId);
		return longId;
	}

	private static String convertId(String inputId) {
		string suffix = '';
		integer flags;
		try{
			for (integer i = 0; i < 3; i++) {
				flags = 0;
				for (integer j = 0; j < 5; j++) {
					string c = inputId.substring(i * 5 + j,i * 5 + j + 1);
					if (c.toUpperCase().equals(c) && c >= 'A' && c <= 'Z') {
						flags = flags + (1 << j);
					}
				}
				
				if (flags <= 25) {
					suffix += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(flags,flags+1);
				} else {
					suffix += '012345'.substring(flags - 26, flags-25);
				}
			}
		} catch(Exception exc) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid 15 digit Id'));
		}
		String outputId = inputId+suffix;
		return outputId;
	}

	public static String generateRandomString(Integer len) {
		final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx+1);
		}
		return randStr; 
	}
}