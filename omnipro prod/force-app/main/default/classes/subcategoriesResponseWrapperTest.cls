@isTest
public class subcategoriesResponseWrapperTest {
    @isTest
    static void testWrapperStructure() {
      
        subcategoriesResponseWrapper wrapper = new subcategoriesResponseWrapper();
        wrapper.name = 'Test Wrapper Name';
        wrapper.url = 'https://testurl.com';
        wrapper.label = 'Test Wrapper Label';
        wrapper.childCategories = new List<subcategoriesResponseWrapper.childCategories>();
        
        
        subcategoriesResponseWrapper.childCategories childCategory = new subcategoriesResponseWrapper.childCategories();
        childCategory.name = 'Test Child Name';
        childCategory.url = 'https://childtesturl.com';
        childCategory.label = 'Test Child Label';
        childCategory.childCategories = 'Child Category Data';
        
        
        wrapper.childCategories.add(childCategory);
   
    }
}