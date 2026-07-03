/**
 * Apex controller class for fetching NavigationMenuItems.
 */
public with sharing class CPV2_NavigationMenuItemsController {
  /**
   * Perform two SOQL queries to determine all the children NavigationMenuItems
   * belonging to the provided menuName and publishedState. This method uses the
   * NavigationLinkSet.MasterLabel for the menuName. We could also use the
   * NavigationLinkSet.Id to ensure referential integrity if the MasterLabel changes.
   *
   * NavigationLinkSet contains both Draft and Live versions of the NavigationMenuItems.
   * Use the publishedState enumeration to filter between them.
   *
   * Cacheable = true allows this function to be wired.
   */
  @AuraEnabled(cacheable=true)
  public static List<NavigationMenuItem> getNavigationMenuItems(
    String menuName,
    String publishedState
  ) {
    System.assert(menuName != null);
    System.assert(publishedState != null);

    String networkId = Network.getNetworkId();
    // System.assert(networkId != null);

    // Find the link set belonging to the navigation menuName and active networkId.
    List<NavigationLinkSet> linkSets = [
      SELECT Id
      FROM NavigationLinkSet
      WHERE MasterLabel = :menuName AND NetworkId = :networkId
    ];

    // System.assert(linkSets.size() == 1);
   // Id linkSetId = linkSets.get(0).Id;
   	Id linkSetId = (!linkSets.isEmpty())?linkSets.get(0).Id:null;//918

    // Collect all the menu items belonging to the link set. Published state is either Draft or Live.
    //918.start
    /*return [
      SELECT
        toLabel(Label),
        Target,
        Type,
        DefaultListViewId,
        AccessRestriction,
        ParentId,
        Position,
        Status,
        TargetPrefs
      FROM NavigationMenuItem
      WHERE NavigationLinkSetId = :linkSetId AND Status = :publishedState
      ORDER BY Position
    ];*/
    String query = 'SELECT toLabel(Label), Target, Type, DefaultListViewId, AccessRestriction, ParentId, Position, Status, TargetPrefs ';
    query += ' FROM NavigationMenuItem WHERE NavigationLinkSetId = :linkSetId AND Status = :publishedState ';
    
    USER cUser = [SELECT Id,AccountId,Account.Enable_Worker_Endorsement__c from User Where Id=: UserInfo.getUserId()];

    if(cUser.AccountId != null && !cUser.Account.Enable_Worker_Endorsement__c ){
      query += ' And Label != \'Preferred Worker\' ';
    }
    query += ' ORDER BY Position';
    List<NavigationMenuItem> navigationMenuItems = Database.query(query);
    
    return navigationMenuItems;
    //918.stop
  }
}