@isTest
public class StaticVariablesTest {
@isTest
    public static void setBoolean(){
        System.assertEquals(false, StaticVariables.inContractTrigger,'test');
    }
    @isTest
    public static void booleanUpdate(){
        StaticVariables.inContractTrigger = true;
        
         System.assertEquals(true, StaticVariables.inContractTrigger,'test');
    }
    @isTest
    public static void booleanVariableReset() {
        StaticVariables.inContractTrigger = false;
        
         System.assertEquals(false, StaticVariables.inContractTrigger,'test');
    }
}