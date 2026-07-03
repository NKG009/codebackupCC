/**
 * Created by mrahman on 2020-11-24.
 * Expected message format:::: [{"response":{"message":"OK","statusLine":"200","status":"success","ruuid":"5f354e66730200ada3c1395c_a8e3b28f-f205-4f45-93b9-8fc4013a8a5d"}}]
 * Test Class: VmsSubmitCandidateTest
 */

public class VmsSnapLogicResParser {
    public static Response parseResponse(String respBody){
        try{
            respBody = respBody.remove('[');
            respBody = respBody.remove(']');
            respBody = respBody.remove('{"response":');
            respBody = respBody.removeEnd('}');
        } catch(Exception ex){
            System.debug('No especial char to remove \n' + ex.getMessage());
        }
        System.debug('respBody >> ' + respBody);
        return (Response) JSON.deserialize(respBody,Response.class);
    }

    public class Response {
        public String message;
        public String statusLine;
        public String status;
        public String ruuid;
        public String VmsCandidateRoleId; // Added For Jira Story # PT1-558.
    }
}