@isTest
public class GroupByHelperTC {
    @IsTest
    private static void test() {
        Account[] accounts = new Account[] {
            new Account(Name = 'Test'),
                new Account(Name = 'Test')
                };
                    
                    GroupByHelper.groupByField(accounts, 'Name');
        GroupByHelper.groupByFields(accounts, new List<String> {'Name'});
        GroupByHelper.groupByFieldKeyId(accounts, 'Id');
        GroupByHelper.groupByFieldReturnSingle(accounts, 'Name');
        GroupByHelper.groupByIdToObject(accounts, 'Id');
        GroupByHelper.getFieldValuesDates(accounts, 'CreatedDate');
        GroupByHelper.getFieldValuesIds(accounts, 'Id');
        GroupByHelper.getFieldValues(accounts, 'Name');
        GroupByHelper.getFieldValuesStrings(accounts, 'Name');
        GroupByHelper.filterBy(accounts, 'Name != null');
    }
}