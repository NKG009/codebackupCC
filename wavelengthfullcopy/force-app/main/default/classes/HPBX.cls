public class HPBX {
    @RemoteAction
    public static String getTasks () {
        List<String> picklistValues = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Task.Type.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : entries) {
            if (entry.isActive()) {
                picklistValues.add(entry.getValue());
            }
        }
        
        return JSON.serialize(picklistValues);
    }
}