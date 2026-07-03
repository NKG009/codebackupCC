public without sharing class AddressSearchController {
    public String searchText { get; set; }
    public List<Account> searchResults { get; set; }
    public Account selectedAccount { get; set; } 
    
    public AddressSearchController() {
        searchResults = new List<Account>();
    }

    public void searchShippingAddress() {
        if (String.isNotBlank(searchText)) {
            searchResults = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry 
                             FROM Account 
                             WHERE ShippingStreet LIKE :('%' + searchText + '%') 
                             LIMIT 100];
        } else {
            searchResults.clear();
        }
    }
    
    public void populateAddress() {
        String selectedId = ApexPages.currentPage().getParameters().get('selectedId');
        if (selectedId != null) {
            selectedAccount = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry 
                               FROM Account 
                               WHERE Id = :selectedId 
                               LIMIT 1];
        }
    }

}