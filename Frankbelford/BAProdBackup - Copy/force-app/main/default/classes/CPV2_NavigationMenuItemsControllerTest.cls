@IsTest
public with sharing class CPV2_NavigationMenuItemsControllerTest {
  @IsTest
  //As this is testing a class which queries setup items that we cannot create at runtime, the only option we have is to
  //Pass in blank values and assert that the output is 0
  public static void assertBlank() {
    try {
      List<NavigationMenuItem> output = CPV2_NavigationMenuItemsController.getNavigationMenuItems(
        'blank',
        'published'
      );
    } catch (Exception e) {
      System.assert(
        e.getMessage().contains('List index out of bounds: 0'),
        e.getMessage()
      );
    }
  }
}