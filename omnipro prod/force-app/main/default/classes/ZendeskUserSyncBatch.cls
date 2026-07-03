public class ZendeskUserSyncBatch implements Database.Batchable<ZendeskUserSyncBatch.ZendeskUser>, Database.AllowsCallouts,Database.Stateful {

   // These are your Zendesk API credentials
    private static final String ZENDESK_URL = 'https://omnipro.zendesk.com/api/v2/';
    private static final String API_TOKEN = 'JsKfoxUDt3DJtjgqtH6CSGiu0Srxeu4w7zdvBQX2';
    private static final String USER_EMAIL = 'ekehoe@omnipro.ie';
    private String nextPageUrl;
    
     // A list to store unmatched contact emails
    public List<String> unmatchedContactEmails = new List<String>();


    // Constructor: Set the initial page URL for Zendesk API
    public ZendeskUserSyncBatch() {
        nextPageUrl = ZENDESK_URL + 'users.json';  // First page of users
    }
    
    // Start method: Fetches users page by page using pagination
    public Iterable<ZendeskUser> start(Database.BatchableContext bc) {
        List<ZendeskUser> zendeskUsersList = new List<ZendeskUser>();
        
        // Fetch users from Zendesk using the next page URL
        while (nextPageUrl != null && zendeskUsersList.size() < 200) { // Limit to 200 users per batch
            HttpResponse response = makeZendeskCallout(nextPageUrl);
            if (response != null && response.getStatusCode() == 200) {
                nextPageUrl = parseZendeskUsers(response.getBody(), zendeskUsersList);
            } else {
                System.debug('Error fetching users: ' + response.getBody()+'Status code==>'+ response.getStatusCode());
                nextPageUrl = null;
            }
        }
        
        return zendeskUsersList;
    }

    // Execute method: Checks if each Zendesk user exists as a contact in Salesforce by email
    public void execute(Database.BatchableContext bc, List<ZendeskUser> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Contact> contactsToCreate = new List<Contact>();

        for (ZendeskUser user : scope) {
            // Split the user's name into first and last name
            String firstName = '';
            String lastName = '';

            String[] nameParts = user.fullName.split(' ', 2);

            if (nameParts.size() == 1) {
                // If there's only one part, assign it to lastName and leave firstName empty
                lastName = nameParts[0];
            } else if (nameParts.size() > 1) {
                // If there are two parts, assign the first part to firstName and the second to lastName
                firstName = nameParts[0];
                lastName = nameParts[1];
            }

            // Check if the contact exists in Salesforce by email
            List<Contact> matchingContacts = [SELECT Id, Email, Zendesk_Id__c FROM Contact WHERE Email = :user.email LIMIT 1];
            
            if (!matchingContacts.isEmpty()) {
                // If contact exists, update the Zendesk_Id__c field with the Zendesk user ID
                Contact existingContact = matchingContacts[0];
                existingContact.Zendesk_Id__c = user.id;
                contactsToUpdate.add(existingContact);
            } else {
                
                // If contact does not exist, collect the email address
                unmatchedContactEmails.add(user.email);

                // If contact does not exist, create a new one
                Contact newContact = new Contact();
                newContact.FirstName = firstName;
                newContact.LastName = lastName;
                newContact.Email = user.email;
                newContact.Zendesk_Id__c = user.id;
                contactsToCreate.add(newContact);
            }
        }

        // Update existing contacts and insert new contacts
        if (!contactsToUpdate.isEmpty()) {
           // update contactsToUpdate;
            Database.SaveResult[] saveResults = Database.update(contactsToUpdate, false);
        
        // Handle errors from the save results
        for (Integer i = 0; i < saveResults.size(); i++) {
            if (!saveResults[i].isSuccess()) {
                // Log or process the error
                Database.Error error = saveResults[i].getErrors()[0];
                System.debug('Failed to insert contact: ' + contactsToCreate[i].Email + ' Error: ' + error.getMessage());
            }
        }
        }

        if (!contactsToCreate.isEmpty()) {/*
            //insert contactsToCreate;
             // Perform partial insert to avoid complete failure if some records fail
        Database.SaveResult[] saveResults = Database.insert(contactsToCreate, false);
        
        // Handle errors from the save results
        for (Integer i = 0; i < saveResults.size(); i++) {
            if (!saveResults[i].isSuccess()) {
                // Log or process the error
                Database.Error error = saveResults[i].getErrors()[0];
                System.debug('Failed to insert contact: ' + contactsToCreate[i].Email + ' Error: ' + error.getMessage());
            }
        }*/
        }
    }

    // Finish method: Log completion of the batch job
    public void finish(Database.BatchableContext bc) {
        System.debug('Zendesk User Sync Batch Job Completed');
        
        // Log the unmatched email addresses
        if (!unmatchedContactEmails.isEmpty()) {
            
            System.debug('Unmatched contact emails: ' + String.join(unmatchedContactEmails, ', '));
            String emailRecipient = 'vikrant.gore@cloudcacheconsulting.com';
        String subject = 'Unmatched Contact Emails from Zendesk User Sync';
        
        // Build the email body
        String body = 'The following email addresses from Zendesk did not match any contacts in Salesforce:\n\n';
        body += String.join(unmatchedContactEmails, '\n');

        // Create the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { emailRecipient });
        email.setSubject(subject);
        email.setPlainTextBody(body);

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
        }
        
        // Optionally, schedule another instance of the batch if there are more pages
        if (nextPageUrl != null) {
            ZendeskUserSyncBatch nextBatch = new ZendeskUserSyncBatch();
            nextBatch.nextPageUrl = this.nextPageUrl;  // Continue with the next page
            Database.executeBatch(nextBatch, 100);  // Adjust batch size if necessary
        }
    }

    // Make a callout to the Zendesk API to fetch users
    private HttpResponse makeZendeskCallout(String url) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');

        String authHeader = USER_EMAIL + '/token:' + API_TOKEN;
        String encodedAuthHeader = EncodingUtil.base64Encode(Blob.valueOf(authHeader));
        request.setHeader('Authorization', 'Basic ' + encodedAuthHeader);
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);

        return response;
    }

    // Parse the Zendesk response and add users to the list, return the next page URL
    private String parseZendeskUsers(String responseBody, List<ZendeskUser> zendeskUsersList) {
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        List<Object> users = (List<Object>) result.get('users');

        for (Object userObj : users) {
            Map<String, Object> userMap = (Map<String, Object>) userObj;
            ZendeskUser user = new ZendeskUser();
            user.id = String.valueOf(userMap.get('id'));
            user.fullName = String.valueOf(userMap.get('name'));
            user.email = String.valueOf(userMap.get('email'));
            zendeskUsersList.add(user);
        }

        // Return the next page URL, if available
        return (String) result.get('next_page');
    }

    // Inner class to represent a Zendesk User
    public class ZendeskUser {
        public String id;
        public String fullName;
        public String email;
    }
}