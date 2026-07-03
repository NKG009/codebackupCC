global without sharing class B2BLeadController {
    @AuraEnabled
    public static Lead createLead(
        String firstName, 
        String lastName, 
        String email, 
        String phone, 
        String company,
        String street,
        String city,
        String state,
        String zip,
        String country,
         String agentEmail
    ) {
        

        Lead newLead = new Lead(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone,
            Company = company,
            Street = street,
            City = city,
            State = state,
            PostalCode = zip,
            Country = country,
            LeadSource = 'B2B',
            Agent_Email__c = agentEmail    
                );

try {
    insert newLead;
} catch (DmlException e) {
    throw new AuraHandledException('Failed to create Lead: ' + e.getMessage());
}
        return newLead;
    }
}