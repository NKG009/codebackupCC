public class OrderData {
    public String OrderID;
    public Error error;
    
    public class Error {
        public String message;
        public String name;
        public Integer statusCode;
    }
    
    public static Orderdata parse(String json) {
        return (Orderdata) System.JSON.deserialize(json, Orderdata.class);
    }
}