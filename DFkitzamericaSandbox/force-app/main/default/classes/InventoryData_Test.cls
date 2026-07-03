/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of InventoryData
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* @created        3/29/2023
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@IsTest
public class InventoryData_Test {
    
    static testMethod void testParse() {
        String json = '{'+
            '    \"ALLOCATION\": {'+
            '        \"ALLOCATION_Data\": ['+
            '            '+
            '            {'+
            '                \"VBAP_VBELN\": \"3000074805\",'+
            '                \"CANCEL_FLAG\": null,'+
            '                \"SOLD_TO\": \"30S0020\",'+
            '                \"SOLD_TO_NAME\": \"INDUSTRIAL VALCO INC\",'+
            '                \"ORDER_DATE\": \"2018-04-30T00:00:00.000Z\",'+
            '                \"DELIVERY_DATE\": \"2018-04-30T00:00:00.000Z\",'+
            '                \"ORDER_QTY\": 54,'+
            '                \"CUST_PO\": \"KZ048RA\",'+
            '                \"PURCHASE_ORDER_NO\": null,'+
            '                \"ROWNO\": 13'+
            '            }'+
            '        ],'+
            '        \"MTR_Number\": \"01K1A87063\",'+
            '        \"Message\": \"No data returned\",'+
            '        \"Message_Status\": \"NODATA\"'+
            '    },'+
            '    \"ETA\": {'+
            '        \"ETA_Data\": ['+
            '            {'+
            '                \"REC_REQD_QTY_ALT_UOM\": 180,'+
            '                \"AVAIL_DATE\": \"2020-12-28T00:00:00.000Z\",'+
            '                \"ROWNO\": 1'+
            '            }'+
            '        ],'+
            '        \"MTR_Number\": \"01K1A87063\"'+
            '    },'+
            '    \"INDENT\": {'+
            '        \"IDENT_Data\": ['+
            '            {'+
            '                \"VBAK_BSTNK\": \"test20191219-01\",'+
            '                \"ADRC_NAME2\": \"(DO NOT USE) NOV WILSON\",'+
            '                \"VBAP_POSEX\": \"1\",'+
            '                \"ORDER_QTY\": 5,'+
            '                \"DELIVERY_QTY\": 5,'+
            '                \"LIKP_WADAT\": \"2020-01-15T00:00:00.000Z\",'+
            '                \"VBAK_KUNNR\": \"30S0008\",'+
            '                \"ROWNO\": 20'+
            '            }'+
            '        ],'+
            '        \"MTR_Number\": \"01K1A87063\"'+
            '    },'+
            '    \"METHOD\": \"ALL\",'+
            '    \"MTR_NUMBER\": \"01K1A87063\",'+
            '    \"RESTOCK\": {'+
            '        \"MTR_Number\": \"01K1A87063\",'+
            '        \"RESTOCK_Data\": ['+
            '            {'+
            '                \"PO_NUMBER\": \"3071004645\",'+
            '                \"LINE_NUMBER\": \"00024\",'+
            '                \"REC_REQD_QTY_ALT_UOM\": 180,'+
            '                \"AVAIL_DATE\": \"2021-02-23T00:00:00.000Z\",'+
            '                \"ROWNO\": 1'+
            '            },'+
            '            {'+
            '                \"PO_NUMBER\": \"3071004666\",'+
            '                \"LINE_NUMBER\": \"00038\",'+
            '                \"REC_REQD_QTY_ALT_UOM\": 252,'+
            '                \"AVAIL_DATE\": \"2021-03-17T00:00:00.000Z\",'+
            '                \"ROWNO\": 2'+
            '            },'+
            '            {'+
            '                \"PO_NUMBER\": \"3071004685\",'+
            '                \"LINE_NUMBER\": \"00042\",'+
            '                \"REC_REQD_QTY_ALT_UOM\": 360,'+
            '                \"AVAIL_DATE\": \"2021-05-20T00:00:00.000Z\",'+
            '                \"ROWNO\": 3'+
            '            }'+
            '        ]'+
            '    },'+
            '    \"WAREHOUSE\": {'+
            '        \"MTR_Number\": \"01K1A87063\",'+
            '        \"WAREHOUSE_Data\": ['+
            '            {'+
            '                \"QTY\": 2627,'+
            '                \"WAREHOUSE_NAME\": \"STAFFORD\",'+
            '                \"WAREHOUSE_LOC\": \"Stafford, TX\",'+
            '                \"LGORT\": \"3008\",'+
            '                \"ROWNO\": 1'+
            '            },'+
            '            {'+
            '                \"QTY\": 180,'+
            '                \"WAREHOUSE_NAME\": \"INTRASIT\",'+
            '                \"WAREHOUSE_LOC\": \"INTRANSIT\",'+
            '                \"LGORT\": \"3099\",'+
            '                \"ROWNO\": 2'+
            '            },'+
            '            {'+
            '                \"QTY\": 45,'+
            '                \"WAREHOUSE_NAME\": \"WILLIAMS AND ASSOCIATES\",'+
            '                \"WAREHOUSE_LOC\": \"BIRMINGHAM, AL\",'+
            '                \"LGORT\": \"30W0003\",'+
            '                \"ROWNO\": 3'+
            '            }'+
            '        ]'+
            '    }'+
            '}';
        InventoryData r = InventoryData.parse(json);
        System.assert(r != null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.INDENT objINDENT = new InventoryData.INDENT(System.JSON.createParser(json));
        System.assert(objINDENT != null);
        System.assert(objINDENT.IDENT_Data == null);
        System.assert(objINDENT.MTR_Number == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.IDENT_Data objIDENT_Data = new InventoryData.IDENT_Data(System.JSON.createParser(json));
        System.assert(objIDENT_Data != null);
        System.assert(objIDENT_Data.VBAK_BSTNK == null);
        System.assert(objIDENT_Data.ADRC_NAME2 == null);
        System.assert(objIDENT_Data.VBAP_POSEX == null);
        System.assert(objIDENT_Data.ORDER_QTY == null);
        System.assert(objIDENT_Data.DELIVERY_QTY == null);
        System.assert(objIDENT_Data.LIKP_WADAT == null);
        System.assert(objIDENT_Data.VBAK_KUNNR == null);
        System.assert(objIDENT_Data.ROWNO == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.WAREHOUSE_Data objWAREHOUSE_Data = new InventoryData.WAREHOUSE_Data(System.JSON.createParser(json));
        System.assert(objWAREHOUSE_Data != null);
        System.assert(objWAREHOUSE_Data.QTY == null);
        System.assert(objWAREHOUSE_Data.WAREHOUSE_NAME == null);
        System.assert(objWAREHOUSE_Data.WAREHOUSE_LOC == null);
        System.assert(objWAREHOUSE_Data.LGORT == null);
        System.assert(objWAREHOUSE_Data.ROWNO == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.RESTOCK_Data objRESTOCK_Data = new InventoryData.RESTOCK_Data(System.JSON.createParser(json));
        System.assert(objRESTOCK_Data != null);
        System.assert(objRESTOCK_Data.PO_NUMBER == null);
        System.assert(objRESTOCK_Data.LINE_NUMBER == null);
        System.assert(objRESTOCK_Data.REC_REQD_QTY_ALT_UOM == null);
        System.assert(objRESTOCK_Data.AVAIL_DATE == null);
        System.assert(objRESTOCK_Data.ROWNO == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.ETA objETA = new InventoryData.ETA(System.JSON.createParser(json));
        System.assert(objETA != null);
        System.assert(objETA.ETA_Data == null);
        System.assert(objETA.MTR_Number == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.WAREHOUSE objWAREHOUSE = new InventoryData.WAREHOUSE(System.JSON.createParser(json));
        System.assert(objWAREHOUSE != null);
        System.assert(objWAREHOUSE.MTR_Number == null);
        System.assert(objWAREHOUSE.WAREHOUSE_Data == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.ETA_Data objETA_Data = new InventoryData.ETA_Data(System.JSON.createParser(json));
        System.assert(objETA_Data != null);
        System.assert(objETA_Data.REC_REQD_QTY_ALT_UOM == null);
        System.assert(objETA_Data.AVAIL_DATE == null);
        System.assert(objETA_Data.ROWNO == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.RESTOCK objRESTOCK = new InventoryData.RESTOCK(System.JSON.createParser(json));
        System.assert(objRESTOCK != null);
        System.assert(objRESTOCK.MTR_Number == null);
        System.assert(objRESTOCK.RESTOCK_Data == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.ALLOCATION_Data objALLOCATION_Data = new InventoryData.ALLOCATION_Data(System.JSON.createParser(json));
        System.assert(objALLOCATION_Data != null);
        System.assert(objALLOCATION_Data.VBAP_VBELN == null);
        System.assert(objALLOCATION_Data.CANCEL_FLAG == null);
        System.assert(objALLOCATION_Data.SOLD_TO == null);
        System.assert(objALLOCATION_Data.SOLD_TO_NAME == null);
        System.assert(objALLOCATION_Data.ORDER_DATE == null);
        System.assert(objALLOCATION_Data.DELIVERY_DATE == null);
        System.assert(objALLOCATION_Data.ORDER_QTY == null);
        System.assert(objALLOCATION_Data.CUST_PO == null);
        System.assert(objALLOCATION_Data.PURCHASE_ORDER_NO == null);
        System.assert(objALLOCATION_Data.ROWNO == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData.ALLOCATION objALLOCATION = new InventoryData.ALLOCATION(System.JSON.createParser(json));
        System.assert(objALLOCATION != null);
        System.assert(objALLOCATION.ALLOCATION_Data == null);
        System.assert(objALLOCATION.MTR_Number == null);
        System.assert(objALLOCATION.Message == null);
        System.assert(objALLOCATION.Message_Status == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        InventoryData objInventoryData = new InventoryData(System.JSON.createParser(json));
        System.assert(objInventoryData != null);
        System.assert(objInventoryData.ALLOCATION == null);
        System.assert(objInventoryData.ETA == null);
        System.assert(objInventoryData.INDENT == null);
        System.assert(objInventoryData.METHOD == null);
        System.assert(objInventoryData.MTR_NUMBER == null);
        System.assert(objInventoryData.RESTOCK == null);
        System.assert(objInventoryData.WAREHOUSE == null);
    }
}