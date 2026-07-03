/*******************************************************************************************
* @Name         PropertyTree_Me_SchedulerTest
* @Author       Rajesh
@Description  This class contains all methods to provide code coverage for apex class 'PropertyTree_Me_Scheduler'.
*******************************************************************************************/
@isTest(seeAllData = false)
public class PropertyTree_Me_SchedulerTest {
    
    //Test method for Property Tree
    public static testMethod void testschedule1() {
         Integer i = 0;
        List<String> companyList = new  List<String>{'DiJONES_Real_Estate_Tenancies',
                                            'DiJONES_Real_Estate_Agents',
                                            'DiJONES_Real_Estate_Ownerships',
                                            'DiJONES_Real_Estate'                                            
                                            };      
		List<String> apiList = new  List<String>{'Tenancies','Agents','Ownerships','Properties'};   
             
        Test.StartTest();
        for(String cmp : companyList){           
            i++;
            String sch = '0 '+i+' 1 * * ?';            
            PropertyTree_Me_Scheduler testsche = new PropertyTree_Me_Scheduler('Property Tree',cmp,apiList.get(i-1),'','');
			system.debug('#####:'+cmp + ':'+apiList.get(i-1));            
            system.schedule('PT Test status Check'+i, sch, testsche );                      
        }
        Test.stopTest(); 
        
    }
    //Test method for Property me
    public static testMethod void testschedule2() {
         Integer i = 0;
        List<String> companyList = new  List<String>{'PM_Lots','PM_Tenants','PM_Members'};      
        List<String> apiList = new  List<String>{'PMLots','PMLotTenants','PMLotMembers'};
            
        Test.StartTest();
        for(String cmp : companyList){           
            i++;
            String sch = '0 '+i+' 1 * * ?';            
            PropertyTree_Me_Scheduler testsche = new PropertyTree_Me_Scheduler('Property Me',cmp,apiList.get(i-1),'Property_Me_NC','Property Services 360');            
            system.schedule('PM Test status Check'+i, sch, testsche );                      
        }
        Test.stopTest(); 
        
    }

}