/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class is Mock API callout (used in test class)
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* @created        3/29/2023
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
global class InventoryCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
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
        response.setBody(json);
        response.setStatusCode(200);
        return response; 
    }
}