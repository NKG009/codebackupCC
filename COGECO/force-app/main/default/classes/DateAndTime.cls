public without sharing class DateAndTime {
    public static final String ENGLISH_DATE_FORMAT = 'dd/MM/YYYY';
    public static final String FRENCH_DATE_FORMAT = 'YYYY-MM-dd';

    public static String getFormattedDate(Date toBeConvertedDate, String language) {
        String format = ENGLISH_DATE_FORMAT;
        
        if (language == ApexConstants.FRENCH) {
            format = FRENCH_DATE_FORMAT;
        }
        
        String formattedDate = DateTime.newInstance(toBeConvertedDate.year(), toBeConvertedDate.month(), toBeConvertedDate.day()).format(format);
        
        return formattedDate;
    }
    
    public static String getFormattedCurrency(Decimal toBeConvertedValue, String format) {
        if (toBeConvertedValue == null) {
            return '0';
        }
        String formattedCurrency;
        Decimal scaledToTwoCharachters = toBeConvertedValue.setscale(2, System.RoundingMode.HALF_UP);
        String stringValueOfDecimal = String.valueOf(scaledToTwoCharachters);
        String integerValue;
        String decimalValue;
        Boolean isNegative = false;
        
        if (toBeConvertedValue < 0) {
            isNegative = true;
            stringValueOfDecimal = stringValueOfDecimal.remove('-');
        }
        
        if (stringValueOfDecimal.contains(ApexConstants.DOT)) {
            integerValue = stringValueOfDecimal.substringBefore(ApexConstants.DOT);
            decimalValue = stringValueOfDecimal.substringAfter(ApexConstants.DOT);
        } else {
            integerValue = stringValueOfDecimal;
            decimalValue = '';
        }
        
        String reverseIntegerValue = integerValue.reverse();
        
        switch on format {
            when 'English', 'en' {
                reverseIntegerValue = reverseIntegerValue.replaceAll('.{3}','$0,');
                reverseIntegerValue = reverseIntegerValue.removeEnd(ApexConstants.COMMA);
                integerValue = reverseIntegerValue.reverse();
                if (isNegative){
                	formattedCurrency = '-$' + integerValue + ApexConstants.DOT + decimalValue;
                }else{
                    formattedCurrency = '$'+integerValue + ApexConstants.DOT + decimalValue;
                }
            }
            when 'French', 'fr' {
                reverseIntegerValue = reverseIntegerValue.replaceAll('.{3}','$0.');
            	reverseIntegerValue = reverseIntegerValue.removeEnd(ApexConstants.DOT);
            	integerValue = reverseIntegerValue.reverse();
                
                if (isNegative) {
            		formattedCurrency = '-'+integerValue + ApexConstants.COMMA + decimalValue+'$';
                } else {
                    formattedCurrency = integerValue + ApexConstants.COMMA + decimalValue+'$';
                }
            }
        }
            
    	return formattedCurrency;
    }
}