@isTest
private class DateAndTimeTest {

    @isTest
    static void testGetFormattedDate() {
        // Test with English format
        Date inputDate = Date.today();
        String expectedEnglish = DateTime.newInstance(inputDate.year(), inputDate.month(), inputDate.day()).format(DateAndTime.ENGLISH_DATE_FORMAT);
        String expectedFrench = DateTime.newInstance(inputDate.year(), inputDate.month(), inputDate.day()).format(DateAndTime.FRENCH_DATE_FORMAT);
        
        String formattedDateResultEnglish = DateAndTime.getFormattedDate(inputDate, ApexConstants.ENGLISH);
        System.assertEquals(expectedEnglish, formattedDateResultEnglish);

        // Test with French format
        String formattedDateResultFrench = DateAndTime.getFormattedDate(inputDate, ApexConstants.FRENCH);
        System.assertEquals(expectedFrench, formattedDateResultFrench);
    }

    @isTest
    static void testGetFormattedCurrency() {
        // Test with English format
        Decimal inputValue = 1234567.89;
        String formattedCurrency = DateAndTime.getFormattedCurrency(inputValue, ApexConstants.ENGLISH);
        System.assertEquals('$1,234,567.89', formattedCurrency);

        // Test with French format
        formattedCurrency = DateAndTime.getFormattedCurrency(inputValue, ApexConstants.FRENCH);
        System.assertEquals('1.234.567,89$', formattedCurrency);
    }
}