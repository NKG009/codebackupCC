global class TopazGlobalB2FUpdate extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>, Database.Stateful {
  Set<ID> headerId = new Set<ID>();
  Map<id, IP_TopazGlobalClientInformation__c> TopazMap1 = new Map<id, IP_TopazGlobalClientInformation__c>();
  global Database.QueryLocator start(Database.BatchableContext BC) {
    String query = 'select id,IP_TextField1__c,IP_TextField2__c,IP_Number12d4Field1__c,IP_TextField6__c,IP_TextField7__c,IP_TextField8__c,IP_TextField9__c,IP_TextField10__c,IP_CurrencyField1__c,IP_Number12d4Field2__c,IP_TextField3__c,IP_TextField4__c,IP_Number12d4Field3__c,IP_TextField5__c,IP_CurrencyField2__c,IP_LinkField1__c,IP_Status__c,IP_BatchHeader__r.name from IP_BatchLine__c where IP_Status__c = \'open\' and IP_BatchHeader__r.IP_BatchType__c=\'Topaz Global Account\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\'))';
    return Database.getQueryLocator(query);
  }
  global void execute(
    Database.BatchableContext BC,
    List<IP_BatchLine__c> batchlinelist
  ) {
    Database.SaveResult[] sList;
    Database.SaveResult[] sList1;
    Map<Id, String> Errmsg = new Map<Id, String>();
    Map<Id, String> Errmsg1 = new Map<Id, String>();
    list<String> topaznumber = new List<String>();
    List<IP_TopazGlobalClientInformation__c> topazupdatelist = new List<IP_TopazGlobalClientInformation__c>();
    List<IP_TopazGlobalClientInformation__c> topazinsertlist = new List<IP_TopazGlobalClientInformation__c>();
    Map<String, IP_TopazGlobalClientInformation__c> topazmap = new Map<String, IP_TopazGlobalClientInformation__c>();
    for (IP_BatchLine__c bline : batchlinelist) {
      headerId.add(bline.IP_BatchHeader__c);
      if (bline.IP_TextField2__c == null) {
        bline.IP_Status__c = 'Errored';
        bline.IP_ErrorReason__c = 'Topaz Unique Number (Text Field 2) is blank';
      } else {
        topaznumber.add(bline.IP_TextField2__c);
      }
    }
    System.debug('check list-->' + topaznumber);
    for (IP_TopazGlobalClientInformation__c topazgloballist : [
      SELECT
        id,
        IP_TopazUniquenumber__c,
        IP_SalesLedgerNumber__c,
        Name,
        IP_AddressLine1__c,
        IP_AddressLine2__c,
        IP_Town__c,
        IP_County__c,
        IP_Postcode__c,
        IP_CreditLimit__c,
        IP_AccountBalance__c,
        IP_PaymentTerms__c,
        IP_NetMonthlySettlementCode__c,
        IP_CompanyRegNo__c,
        IP_StatusID__c,
        IP_DivisionCode__c
      FROM IP_TopazGlobalClientInformation__c
      WHERE
        IP_SalesLedgerNumber__c IN :topaznumber
        AND IP_SalesLedgerNumber__c != NULL
    ]) {
      topazmap.put(topazgloballist.IP_SalesLedgerNumber__c, topazgloballist);
    }
    System.debug('topaz map-->' + topazmap);
    for (IP_BatchLine__c batchline2 : batchlinelist) {
      if (batchline2.IP_Status__c != 'Errored') {
        if (
          topazmap.size() > 0 &&
          batchline2.IP_TextField2__c != null &&
          topazmap.containskey(batchline2.IP_TextField2__c)
        ) {
          String str = String.valueOf(
            topazmap.get(batchline2.IP_TextField2__c).id
          );
          batchline2.IP_LinkField1__c = str;
          batchline2.IP_Status__c = 'Linking';
          IP_TopazGlobalClientInformation__c topaz1 = new IP_TopazGlobalClientInformation__c();
          topaz1.id = String.valueOf(
            topazmap.get(batchline2.IP_TextField2__c).id
          );
          topaz1.IP_SalesLedgerNumber__c = batchline2.IP_TextField2__c;
          topaz1.Name = batchline2.IP_TextField1__c;
          topaz1.IP_AddressLine1__c = batchline2.IP_TextField6__c;
          topaz1.IP_AddressLine2__c = batchline2.IP_TextField7__c;
          topaz1.IP_Town__c = batchline2.IP_TextField8__c;
          topaz1.IP_County__c = batchline2.IP_TextField9__c;
          topaz1.IP_Postcode__c = batchline2.IP_TextField10__c;
          topaz1.IP_CreditLimit__c = batchline2.IP_CurrencyField1__c;
          topaz1.IP_AccountBalance__c = batchline2.IP_CurrencyField2__c;
          topaz1.IP_PaymentTerms__c = batchline2.IP_Number12d4Field2__c;
          topaz1.IP_NetMonthlySettlementCode__c = batchline2.IP_TextField3__c;
          topaz1.IP_CompanyRegNo__c = batchline2.IP_TextField4__c;
          topaz1.IP_StatusID__c = batchline2.IP_Number12d4Field3__c;
          topaz1.IP_DivisionCode__c = batchline2.IP_TextField5__c;
          if (!TopazMap1.containskey(topaz1.id)) {
            TopazMap1.put(topaz1.id, topaz1);
          }
        } else {
          IP_TopazGlobalClientInformation__c topaz2 = new IP_TopazGlobalClientInformation__c();
          topaz2.IP_TopazUniquenumber__c = Integer.valueOf(
            batchline2.IP_Number12d4Field1__c
          );
          topaz2.IP_SalesLedgerNumber__c = batchline2.IP_TextField2__c;
          topaz2.Name = batchline2.IP_TextField1__c;
          topaz2.IP_AddressLine1__c = batchline2.IP_TextField6__c;
          topaz2.IP_AddressLine2__c = batchline2.IP_TextField7__c;
          topaz2.IP_Town__c = batchline2.IP_TextField8__c;
          topaz2.IP_County__c = batchline2.IP_TextField9__c;
          topaz2.IP_Postcode__c = batchline2.IP_TextField10__c;
          topaz2.IP_CreditLimit__c = batchline2.IP_CurrencyField1__c;
          topaz2.IP_AccountBalance__c = batchline2.IP_CurrencyField2__c;
          topaz2.IP_PaymentTerms__c = batchline2.IP_Number12d4Field2__c;
          topaz2.IP_NetMonthlySettlementCode__c = batchline2.IP_TextField3__c;
          topaz2.IP_CompanyRegNo__c = batchline2.IP_TextField4__c;
          topaz2.IP_StatusID__c = batchline2.IP_Number12d4Field3__c;
          topaz2.IP_DivisionCode__c = batchline2.IP_TextField5__c;
          topazinsertlist.add(topaz2);
        }
      } else {
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Topaz Unique Number (Number Field 1) is blank';
      }
    }
    // topazupdatelist = [Select id,IP_TopazUniquenumber__c,IP_SalesLedgerNumber__c,Name,IP_AddressLine1__c,IP_AddressLine2__c,IP_Town__c,IP_County__c,IP_Postcode__c,IP_CreditLimit__c,IP_AccountBalance__c,IP_PaymentTerms__c,IP_NetMonthlySettlementCode__c,IP_CompanyRegNo__c,IP_StatusID__c,IP_DivisionCode__c from IP_TopazGlobalClientInformation__c where id in:TopazMap1.KeySet()];
    topazupdatelist.addAll(TopazMap1.values());
    if (topazupdatelist.size() > 0) {
      try {
        sList = Database.update(topazupdatelist, false);
      } catch (Exception DMLException) {
      }
      for (integer i = 0; i < sList.size(); i++) {
        if (sList[i].isSuccess()) {
          System.debug('Successfully updated topaz: ' + topazupdatelist[i].id);
          Errmsg.put(topazupdatelist[i].id, 'Success');
        } else {
          for (Database.Error err : sList[i].getErrors()) {
            Errmsg.put(topazupdatelist[i].id, err.getMessage());
          }
        }
      }

      for (IP_BatchLine__c batchstatus : batchlinelist) {
        for (IP_TopazGlobalClientInformation__c t : topazupdatelist) {
          System.debug('***Inside for loop***');
          if (
            batchstatus.IP_Status__c != 'Errored' &&
            batchstatus.IP_LinkField1__c == t.id
          ) {
            System.debug('***Inside if statement 1***');
            if (Errmsg.get(t.Id) != 'Success') {
              batchstatus.IP_Status__c = 'Errored';
              if (Errmsg.get(t.Id).length() > 255) {
                batchstatus.IP_ErrorReason__c = Errmsg.get(t.Id)
                  .substring(0, 255);
              } else {
                batchstatus.IP_ErrorReason__c = Errmsg.get(t.Id);
              }
            } else {
              System.debug('***Inside else***');
              batchstatus.IP_Status__c = 'Processed';
            }
          }
        }
      }
    }
    if (topazinsertlist.size() > 0) {
      try {
        sList1 = Database.insert(topazinsertlist, false);
      } catch (Exception DMLException) {
      }

      for (Database.SaveResult sr : sList1) {
        if (sr.isSuccess()) {
          System.debug('Successfully inserted Topaz: ' + sr.getId());
          Errmsg1.put(sr.getId(), 'Success');
        } else {
          for (Database.Error err : sr.getErrors()) {
            Errmsg1.put(sr.getId(), err.getMessage());
          }
        }
      }
      for (IP_BatchLine__c batchstatus : batchlinelist) {
        for (IP_TopazGlobalClientInformation__c t : topazinsertlist) {
          System.debug('***Inside for loop***');
          if (
            batchstatus.IP_Status__c != 'Errored' &&
            batchstatus.IP_TextField2__c == t.IP_SalesLedgerNumber__c
          ) {
            System.debug('***Inside if statement 1***');
            if (Errmsg1.get(t.Id) != 'Success') {
              batchstatus.IP_Status__c = 'Errored';
              if (Errmsg1.get(t.Id).length() > 255) {
                batchstatus.IP_ErrorReason__c = Errmsg1.get(t.Id)
                  .substring(0, 255);
              } else {
                batchstatus.IP_ErrorReason__c = Errmsg1.get(t.Id);
              }
            } else {
              System.debug('***Inside else***');
              batchstatus.IP_Status__c = 'Processed';
              batchstatus.IP_LinkField1__c = t.id;
            }
          }
        }
      }
    }
    update batchlinelist;
    TopazMap1.clear();
  }
  global void finish(Database.BatchableContext BC) {
    Map<Id, Integer> mapUnprocessedBatchHeader = new Map<Id, Integer>();
    Map<Id, Integer> mapErroredBatchHeader = new Map<Id, Integer>();
    for (Batch_header__c openStatusBatchHeader : [
      SELECT
        id,
        IP_Status__c,
        IP_State__c,
        Check_status__c,
        (
          SELECT id, IP_Status__c
          FROM Batch_Lines__r
          WHERE IP_Status__c = 'Open'
        )
      FROM Batch_header__c
      WHERE id = :headerId
    ]) {
      if (
        !openStatusBatchHeader.Batch_Lines__r.isEmpty() &&
        openStatusBatchHeader.Batch_Lines__r.size() > 0
      ) {
        mapUnprocessedBatchHeader.put(
          openStatusBatchHeader.id,
          openStatusBatchHeader.Batch_Lines__r.size()
        );
      }
    }
    System.debug('mapUnprocessedBatchHeader -- ' + mapUnprocessedBatchHeader);

    for (Batch_header__c erroredBatchHeader : [
      SELECT
        id,
        IP_Status__c,
        IP_State__c,
        Check_status__c,
        (
          SELECT id, IP_Status__c
          FROM Batch_Lines__r
          WHERE IP_Status__c = 'Errored'
          LIMIT 1
        )
      FROM Batch_header__c
      WHERE id = :headerId
    ]) {
      if (
        !erroredBatchHeader.Batch_Lines__r.isEmpty() &&
        erroredBatchHeader.Batch_Lines__r.size() > 0
      ) {
        mapErroredBatchHeader.put(
          erroredBatchHeader.id,
          erroredBatchHeader.Batch_Lines__r.size()
        );
      }
    }
    System.debug('mapErroredBatchHeader -- ' + mapErroredBatchHeader);

    List<Batch_header__c> listBatchHeaderUpdate = new List<Batch_header__c>();

    for (Batch_header__c batchHeader : [
      SELECT
        id,
        IP_BatchTitle__c,
        Name,
        IP_Status__c,
        IP_State__c,
        Check_status__c
      FROM Batch_header__c
      WHERE id = :headerId
    ]) {
      if (
        !mapUnprocessedBatchHeader.isEmpty() &&
        mapUnprocessedBatchHeader.get(batchHeader.id) > 0
      ) {
        batchHeader.IP_Status__c = 'Partial Complete';
        batchHeader.IP_State__c = 'Processing';
      } else if (
        !mapErroredBatchHeader.isEmpty() &&
        mapErroredBatchHeader.get(batchHeader.id) > 0
      ) {
        batchHeader.IP_Status__c = 'Errored';
        batchHeader.IP_State__c = 'Processing';
      } else {
        batchHeader.IP_Status__c = 'Processed';
        batchHeader.IP_State__c = 'Closed';
      }
      //  batchHeader.Check_status__c = '';
      listBatchHeaderUpdate.add(batchHeader);
    }
    System.debug('listBatchHeaderUpdate -- ' + listBatchHeaderUpdate);

    if (!listBatchHeaderUpdate.isEmpty()) {
      update listBatchHeaderUpdate;
    }
    super.finishBatch(BC);
  }
}