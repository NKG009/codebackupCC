@RestResource(urlMapping='/CalendlyWebhook/*')
global without sharing class CalendlyWebhookService {

    @HttpPost
    global static void handleWebhook() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            String body = req.requestBody.toString();
            System.debug('RAW Calendly Payload: ' + body);

            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(body);

            Map<String, Object> payload;
            if (data.containsKey('payload')) {
                payload = (Map<String, Object>) data.get('payload');
            } else if (data.containsKey('resource')) {
                payload = (Map<String, Object>) data.get('resource');
            } else {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"Invalid Calendly payload"}');
                return;
            }

            String email = (payload.containsKey('email')) ? (String) payload.get('email') : null;
            if (String.isBlank(email)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"Missing email"}');
                return;
            }
            email = email.trim().toLowerCase();

            String firstName = (payload.containsKey('first_name')) ? (String) payload.get('first_name') : '';
            String lastName  = (payload.containsKey('last_name'))  ? (String) payload.get('last_name')  : '';
            if (String.isBlank(firstName) && String.isBlank(lastName) && payload.containsKey('name')) {
                String name = (String) payload.get('name');
                if (!String.isBlank(name)) {
                    List<String> parts = name.split(' ', 2);
                    firstName = parts[0];
                    lastName  = (parts.size() > 1) ? parts[1] : '';
                }
            }

            List<Lead> leads = [SELECT Id, OwnerId, Status, ConvertedOpportunityId, ConvertedAccountId FROM Lead WHERE Email = :email];
            if (leads.isEmpty()) {
                res.statusCode = 404;
                res.responseBody = Blob.valueOf('{"error":"Lead not found"}');
                return;
            }

            Lead l = leads[0];

            l.FirstName = firstName;
            l.LastName  = lastName;
            l.Status    = 'Working - Contacted';
            update l;

            Id oppId;

            if (l.ConvertedOpportunityId == null) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id);
                lc.setDoNotCreateOpportunity(false);
                lc.setConvertedStatus('Qualified'); 
                Database.LeadConvertResult lcr = Database.convertLead(lc, true);
                oppId = lcr.getOpportunityId();
            } else {
                Account acc = [SELECT Id FROM Account WHERE Id = :l.ConvertedAccountId LIMIT 1];
                Opportunity opp = new Opportunity(
                    Name = 'Opportunity from Calendly',
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addDays(30),
                    AccountId = acc.Id
                );
                insert opp;
                oppId = opp.Id;
            }
String startStr = (String) payload.get('start_time');
String endStr   = (String) payload.get('end_time');

if (String.isBlank(startStr) || String.isBlank(endStr)) {
    res.statusCode = 400;
    res.responseBody = Blob.valueOf('{"error":"Missing start_time or end_time from Calendly"}');
    return;
}

Datetime startDt = Datetime.valueOf(startStr.replace('Z','').replace('T',' '));
Datetime endDt   = Datetime.valueOf(endStr.replace('Z','').replace('T',' '));
/*
            String startStr = (String) payload.get('start_time');
            String endStr   = (String) payload.get('end_time');
            Datetime startDt = (startStr != null) ? Datetime.valueOf(startStr.replace('Z','').replace('T',' ')) : Datetime.now();
            Datetime endDt   = (endStr != null) ? Datetime.valueOf(endStr.replace('Z','').replace('T',' ')) : startDt.addMinutes(30);*/
           /* Datetime startDt = parseCalendlyDatetime((String) payload.get('start_time'));
            Datetime endDt   = parseCalendlyDatetime((String) payload.get('end_time'));
            if (startDt == null) startDt = Datetime.now();
            if (endDt == null) endDt = startDt.addMinutes(30);

        if (startDt == null) startDt = Datetime.now();
        if (endDt == null) endDt = startDt.addMinutes(30);*/

            Event ev = new Event(
                Subject       = 'Calendly Meeting',
                WhatId        = oppId,
                StartDateTime = startDt,
                EndDateTime   = endDt,
                Description   = 'Meeting scheduled via Calendly',
                OwnerId       = (l.OwnerId != null) ? l.OwnerId : UserInfo.getUserId()
            );
            insert ev;

            res.statusCode = 200;
            res.addHeader('Content-Type','application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{
                'status' => 'success', 
                'leadId' => l.Id,
                'opportunityId' => oppId,
                'eventId' => ev.Id
            }));

        } catch (Exception e) {
            System.debug(' Error: ' + e.getMessage());
            res.statusCode = 500;
            res.addHeader('Content-Type','application/json');
            res.responseBody = Blob.valueOf('{"error":"' + e.getMessage() + '"}');
        }
    }
}
/*   private static Datetime parseCalendlyDatetime(String dtStr) {
        if (dtStr == null || dtStr.trim() == '') return null;

        // Remove fractional seconds if present
        Integer dotIndex = dtStr.indexOf('.');
        if (dotIndex > 0) {
            dtStr = dtStr.substring(0, dotIndex) + 'Z';
        }

        try {
            return Datetime.valueOfGmt(dtStr); // Salesforce will show in user timezone
        } catch(Exception e) {
            System.debug('️ Failed to parse datetime: ' + dtStr);
            return null;
        }
    }
}*/

/*@RestResource(urlMapping='/CalendlyWebhook/*')
global with sharing class CalendlyWebhookService {

    @HttpPost
    global static void handleWebhook() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            String body = req.requestBody.toString();
            System.debug(' Calendly Payload: ' + body);

            // Parse incoming payload
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(body);

            Map<String, Object> payload;
            if (data.containsKey('payload')) {
                payload = (Map<String, Object>) data.get('payload');
            } else if (data.containsKey('resource')) {
                payload = (Map<String, Object>) data.get('resource');
            } else {
                res.statusCode = 400;
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{
                    'status' => 'error',
                    'message' => 'Invalid Calendly payload format'
                }));
                return;
            }

            // Extract invitee details
            Map<String, Object> invitee = (Map<String, Object>) payload.get('invitee');
            String email = (invitee != null && invitee.containsKey('email')) ? (String) invitee.get('email') : null;
            if(email == null) {
                res.statusCode = 400;
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{
                    'status' => 'error',
                    'message' => 'Invitee email missing'
                }));
                return;
            }

            String name  = (invitee != null && invitee.containsKey('name')) ? (String) invitee.get('name') : '';
            String firstName = '';
            String lastName  = name;
            if (name.contains(' ')) {
                List<String> parts = name.split(' ', 2);
                firstName = parts[0];
                lastName  = (parts.size() > 1) ? parts[1] : '';
            }

            List<Lead> existing = [SELECT Id, OwnerId, FirstName, LastName, Company FROM Lead WHERE Email = :email LIMIT 1];

            if (!existing.isEmpty()) {
                Lead l = existing[0];
                l.FirstName = firstName;
                l.LastName  = lastName;
                //l.Company   = 'Calendly Meeting'; // update fields as needed
                update l;
                System.debug(' Existing Lead updated: ' + l.Id);

                String startStr = (String) payload.get('start_time');
                String endStr   = (String) payload.get('end_time');
                Datetime startDt = (startStr != null) ? Datetime.valueOf(startStr.replace('Z','').replace('T',' ')) : Datetime.now();
                Datetime endDt   = (endStr != null) ? Datetime.valueOf(endStr.replace('Z','').replace('T',' ')) : startDt.addMinutes(30);

                Event ev = new Event(
                    Subject       = 'Calendly Meeting Scheduled',
                    WhoId         = l.Id,
                    StartDateTime = startDt,
                    EndDateTime   = endDt,
                    Description   = 'Meeting scheduled via Calendly',
                    OwnerId       = (l.OwnerId != null) ? l.OwnerId : UserInfo.getUserId()
                );
                insert ev;

                res.statusCode = 200;
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{
                    'status' => 'success',
                    'leadId' => l.Id,
                    'eventId' => ev.Id,
                    'message' => 'Existing Lead updated and Event created'
                }));
            } else {
                res.statusCode = 404;
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{
                    'status' => 'error',
                    'message' => 'No existing Lead found with this email'
                }));
            }

        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            res.statusCode = 500;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{
                'status' => 'error',
                'message' => e.getMessage()
            }));
        }
    }
}*/