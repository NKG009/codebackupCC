public class orderdataerror400 {
    
    public Error error;
    
    public class Error {
        public Integer statusCode;
        public String message;
        public String name;
    }
    
    public static orderdataerror400 parse(String json) {
        return (orderdataerror400) System.JSON.deserialize(json, orderdataerror400.class);
    }
}