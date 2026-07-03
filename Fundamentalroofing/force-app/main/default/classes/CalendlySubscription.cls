public with sharing class CalendlySubscription {

    public static void createWebhook() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.calendly.com/webhook_subscriptions');
        req.setMethod('POST');
        //req.setHeader('Authorization', 'Bearer eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiUEFUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzU2MTA1MjUxLCJqdGkiOiIxMGU4ODc1Ni04YzA3LTQ2N2QtYmE3NS1mY2NhZDAwZDAwMTEiLCJ1c2VyX3V1aWQiOiJiYmI5NzM1Zi1lMTQyLTQ0ZGQtOWUxOC1kODAwZTBkOTlhYjcifQ.r_juY7f3PPC3Oc9tpLWDtkv4NdT6lJD7S6vHFXYtLs_BT3wiYtXWXn6oaFsU0HwIRRVbONdt7qDd-oRWmjbGbQ');
        req.setHeader('Authorization', 'Bearer eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiUEFUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzU2MTI2MzE5LCJqdGkiOiI1MzkzM2JmNC1jMmE1LTQ2Y2YtYjQ0My0xZjRjNWZlZjUzOWIiLCJ1c2VyX3V1aWQiOiJkN2UyN2ZiZi0wOWI2LTRkNWEtYjc5Yi03YzlhYzBhNzE3NzUifQ.aEQfstPoPVdaQLn7HH_pCNhH4FWjmvHhETU8EdqI8ktWjHsppxdpwsrpZYQayW5L4uKdqcgXtO_OGO5YiC2q-w');
        req.setHeader('Content-Type', 'application/json');
        
        String body = JSON.serialize(new Map<String, Object>{
    'url' => 'https://force-saas-4448--devsandbox.sandbox.my.salesforce-sites.com/services/apexrest/CalendlyWebhook',
    'events' => new List<String>{'invitee.created'},
    'scope' => 'organization',
           'organization' => 'https://api.calendly.com/organizations/d7e27fbf-09b6-4d5a-b79b-7c9ac0a71775'
    //'organization' => 'https://api.calendly.com/organizations/c07ad202-f4a7-4353-8a60-490a6749629c'
});

        
        req.setBody(body);
        
        HttpResponse res = http.send(req);
        System.debug('Status: ' + res.getStatusCode() + ', Body: ' + res.getBody());
    }
}