/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to Convert Json response in to Apex
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* @created        3/24/2023
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class InventoryData {
    
    public class INDENT {
        public List<IDENT_Data> IDENT_Data {get;set;} 
        public String MTR_Number {get;set;} 
        
        public INDENT(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'IDENT_Data') {
                            IDENT_Data = arrayOfIDENT_Data(parser);
                        } else if (text == 'MTR_Number') {
                            MTR_Number = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'INDENT consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class IDENT_Data {
        public String VBAK_BSTNK {get;set;} 
        public String ADRC_NAME2 {get;set;} 
        public String VBAP_POSEX {get;set;} 
        public Integer ORDER_QTY {get;set;} 
        public Integer DELIVERY_QTY {get;set;} 
        public String LIKP_WADAT {get;set;} 
        public String VBAK_KUNNR {get;set;} 
        public Integer ROWNO {get;set;} 
        
        public IDENT_Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'VBAK_BSTNK') {
                            VBAK_BSTNK = parser.getText();
                        } else if (text == 'ADRC_NAME2') {
                            ADRC_NAME2 = parser.getText();
                        } else if (text == 'VBAP_POSEX') {
                            VBAP_POSEX = parser.getText();
                        } else if (text == 'ORDER_QTY') {
                            ORDER_QTY = parser.getIntegerValue();
                        } else if (text == 'DELIVERY_QTY') {
                            DELIVERY_QTY = parser.getIntegerValue();
                        } else if (text == 'LIKP_WADAT') {
                            LIKP_WADAT = parser.getText();
                        } else if (text == 'VBAK_KUNNR') {
                            VBAK_KUNNR = parser.getText();
                        } else if (text == 'ROWNO') {
                            ROWNO = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'IDENT_Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class WAREHOUSE_Data {
        public Integer QTY {get;set;} 
        public String WAREHOUSE_NAME {get;set;} 
        public String WAREHOUSE_LOC {get;set;} 
        public String LGORT {get;set;} 
        public Integer ROWNO {get;set;} 
        
        public WAREHOUSE_Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'QTY') {
                            QTY = parser.getIntegerValue();
                        } else if (text == 'WAREHOUSE_NAME') {
                            WAREHOUSE_NAME = parser.getText();
                        } else if (text == 'WAREHOUSE_LOC') {
                            WAREHOUSE_LOC = parser.getText();
                        } else if (text == 'LGORT') {
                            LGORT = parser.getText();
                        } else if (text == 'ROWNO') {
                            ROWNO = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'WAREHOUSE_Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class RESTOCK_Data {
        public String PO_NUMBER {get;set;} 
        public String LINE_NUMBER {get;set;} 
        public Integer REC_REQD_QTY_ALT_UOM {get;set;} 
        public String AVAIL_DATE {get;set;} 
        public Integer ROWNO {get;set;} 
        
        public Integer ETA_REC_REQD_QTY_ALT_UOM {get;set;} 
        public String ETA_AVAIL_DATE {get;set;} 
        
        public RESTOCK_Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'PO_NUMBER') {
                            PO_NUMBER = parser.getText();
                        } else if (text == 'LINE_NUMBER') {
                            LINE_NUMBER = parser.getText();
                        } else if (text == 'REC_REQD_QTY_ALT_UOM') {
                            REC_REQD_QTY_ALT_UOM = parser.getIntegerValue();
                        } else if (text == 'AVAIL_DATE') {
                            AVAIL_DATE = parser.getText();
                        } else if (text == 'ROWNO') {
                            ROWNO = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'RESTOCK_Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ETA {
        public List<ETA_Data> ETA_Data {get;set;} 
        public String MTR_Number {get;set;} 
        
        public ETA(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'ETA_Data') {
                            ETA_Data = arrayOfETA_Data(parser);
                        } else if (text == 'MTR_Number') {
                            MTR_Number = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ETA consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class WAREHOUSE {
        public String MTR_Number {get;set;} 
        public List<WAREHOUSE_Data> WAREHOUSE_Data {get;set;} 
        
        public WAREHOUSE(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'MTR_Number') {
                            MTR_Number = parser.getText();
                        } else if (text == 'WAREHOUSE_Data') {
                            WAREHOUSE_Data = arrayOfWAREHOUSE_Data(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'WAREHOUSE consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ETA_Data {
        public Integer REC_REQD_QTY_ALT_UOM {get;set;} 
        public String AVAIL_DATE {get;set;} 
        public Integer ROWNO {get;set;} 
        
        public ETA_Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'REC_REQD_QTY_ALT_UOM') {
                            REC_REQD_QTY_ALT_UOM = parser.getIntegerValue();
                        } else if (text == 'AVAIL_DATE') {
                            AVAIL_DATE = parser.getText();
                        } else if (text == 'ROWNO') {
                            ROWNO = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ETA_Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class RESTOCK {
        public String MTR_Number {get;set;} 
        public List<RESTOCK_Data> RESTOCK_Data {get;set;} 
        
        public RESTOCK(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'MTR_Number') {
                            MTR_Number = parser.getText();
                        } else if (text == 'RESTOCK_Data') {
                            RESTOCK_Data = arrayOfRESTOCK_Data(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'RESTOCK consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ALLOCATION_Data {
        public String VBAP_VBELN {get;set;} 
        public Object CANCEL_FLAG {get;set;} 
        public String SOLD_TO {get;set;} 
        public String SOLD_TO_NAME {get;set;} 
        public String ORDER_DATE {get;set;} 
        public String DELIVERY_DATE {get;set;} 
        public Integer ORDER_QTY {get;set;} 
        public String CUST_PO {get;set;} 
        public Object PURCHASE_ORDER_NO {get;set;} 
        public Integer ROWNO {get;set;} 
        
        public ALLOCATION_Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'VBAP_VBELN') {
                            VBAP_VBELN = parser.getText();
                        } else if (text == 'CANCEL_FLAG') {
                            CANCEL_FLAG = parser.readValueAs(Object.class);
                        } else if (text == 'SOLD_TO') {
                            SOLD_TO = parser.getText();
                        } else if (text == 'SOLD_TO_NAME') {
                            SOLD_TO_NAME = parser.getText();
                        } else if (text == 'ORDER_DATE') {
                            ORDER_DATE = parser.getText();
                        } else if (text == 'DELIVERY_DATE') {
                            DELIVERY_DATE = parser.getText();
                        } else if (text == 'ORDER_QTY') {
                            ORDER_QTY = parser.getIntegerValue();
                        } else if (text == 'CUST_PO') {
                            CUST_PO = parser.getText();
                        } else if (text == 'PURCHASE_ORDER_NO') {
                            //PURCHASE_ORDER_NO = parser.readValueAs(Object.class);
                        } else if (text == 'ROWNO') {
                            ROWNO = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ALLOCATION_Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ALLOCATION {
        public List<ALLOCATION_Data> ALLOCATION_Data {get;set;} 
        public String MTR_Number {get;set;} 
        public String Message {get;set;} 
        public String Message_Status {get;set;} 
        
        public ALLOCATION(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'ALLOCATION_Data') {
                            ALLOCATION_Data = arrayOfALLOCATION_Data(parser);
                        } else if (text == 'MTR_Number') {
                            MTR_Number = parser.getText();
                        } else if (text == 'Message') {
                            Message = parser.getText();
                        } else if (text == 'Message_Status') {
                            Message_Status = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ALLOCATION consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public ALLOCATION ALLOCATION {get;set;} 
    public ETA ETA {get;set;} 
    public INDENT INDENT {get;set;} 
    public String METHOD {get;set;} 
    public String MTR_NUMBER {get;set;} 
    public RESTOCK RESTOCK {get;set;} 
    public WAREHOUSE WAREHOUSE {get;set;} 
    
    public InventoryData(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'ALLOCATION') {
                        ALLOCATION = new ALLOCATION(parser);
                    } else if (text == 'ETA') {
                        ETA = new ETA(parser);
                    } else if (text == 'INDENT') {
                        INDENT = new INDENT(parser);
                    } else if (text == 'METHOD') {
                        METHOD = parser.getText();
                    } else if (text == 'MTR_NUMBER') {
                        MTR_NUMBER = parser.getText();
                    } else if (text == 'RESTOCK') {
                        RESTOCK = new RESTOCK(parser);
                    } else if (text == 'WAREHOUSE') {
                        WAREHOUSE = new WAREHOUSE(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'InventoryData consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    public static InventoryData parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new InventoryData(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    private static List<WAREHOUSE_Data> arrayOfWAREHOUSE_Data(System.JSONParser p) {
        List<WAREHOUSE_Data> res = new List<WAREHOUSE_Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new WAREHOUSE_Data(p));
        }
        return res;
    }
    
    private static List<IDENT_Data> arrayOfIDENT_Data(System.JSONParser p) {
        List<IDENT_Data> res = new List<IDENT_Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new IDENT_Data(p));
        }
        return res;
    }
    
    private static List<ALLOCATION_Data> arrayOfALLOCATION_Data(System.JSONParser p) {
        List<ALLOCATION_Data> res = new List<ALLOCATION_Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ALLOCATION_Data(p));
        }
        return res;
    }
    
    private static List<ETA_Data> arrayOfETA_Data(System.JSONParser p) {
        List<ETA_Data> res = new List<ETA_Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ETA_Data(p));
        }
        return res;
    }
    
    private static List<RESTOCK_Data> arrayOfRESTOCK_Data(System.JSONParser p) {
        List<RESTOCK_Data> res = new List<RESTOCK_Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RESTOCK_Data(p));
        }
        return res;
    }
    
}