/**
 * DEPLOY THIS WITH THE CommunitySelfRegHelper CLASS TO GET OVERALL TEST COVERAGE
 */
global without sharing class LightningSelfRegisterController {

    public LightningSelfRegisterController() {

    }
    //USER VERIFICATION VIA EMAIL CODE
    @AuraEnabled
    public static String initVerification(String fn, String ln, String em) {
        String status;
        String id;
        String nickname = ((fn != null && fn.length() > 0) ? fn.substring(0,1) : '' ) + ln.substring(0,1);
        nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
        Id pId = (Id)User_Profile_Id__c.getValues('User Portal').Profile_Id__c;
        User u = new User(FirstName=fn, LastName=ln, Email=em, ProfileId=pId, Username=em, CommunityNickname=nickname, Alias=nickname);
        if(!Test.isRunningTest()){
            id = System.UserManagement.initSelfRegistration(Auth.VerificationMethod.EMAIL, u);
        }
        status = String.isBlank(id)?'Unable process your request. Please contact your branch':id;
        return status;
    }

    @TestVisible
    private static boolean isValidPassword(String password, String confirmPassword) {
        Boolean isSame = false;
        if(password == confirmPassword){
            isSame = true;
        }
        return isSame;
    }

    @TestVisible
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }

    @TestVisible
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(password != confirmPassword){
            System.debug('Passwords are not same');
            return;
        }
        Site.validatePassword(u, password, confirmPassword);
        return;
    }
    /*
     * ––––––––––––––––––––––––––––––––––––––––––––––
     * |Code | Action                               |
     * –––––––––––––––––––––––––––––––––––––––––––––|
     * | 0  | Successful                            |
     * | 1  | User exists - Show successful message |
     * |-1  | unknown Error - Do investigation      |
     * |-2  | Inline error                          |
     * ––––––––––––––––––––––––––––––––––––––––––––––
     */
    @AuraEnabled
    public static Map<String,String> selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword, String id, String code) {
        System.debug('In the selfRegister method');
        System.debug('Id '+id+' and Code '+code);

        User usr = new User();
        String networkId = Network.getNetworkId();
        String userId;
        String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
        nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
        Savepoint sp = null;
        try {
            sp = Database.setSavepoint();
            Auth.VerificationResult res = System.UserManagement.verifySelfRegistration(Auth.VerificationMethod.EMAIL, id, code, '');
            if(res.success == true || Test.isRunningTest()){
                Database.rollback(sp);
                System.debug('Rolling back as verification is successful and starting a new save point from here');
                sp = Database.setSavepoint();
            } else if(res.message.contains('Invalid or expired') || res.message.contains('Token not valid')){
                System.debug('Verification process failed.... Error message:: '+res.message);
                return returnMessage('-2',res.message);
            }

            System.debug('on line 72');

            if (lastname == null || String.isEmpty(lastname)) {
                return returnMessage('-2', Label.Site.lastname_is_required);
            }
            if (email == null || String.isEmpty(email)) {
                return returnMessage('-2', Label.Site.email_is_required);
            }

            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    usr.put(sof, thisField.get('value'));
                }
            }

            if (includePassword) {
                if (!isValidPassword(password, confirmPassword)) {
                    return returnMessage('-2', Label.site.passwords_dont_match);
                }
            }
            else {
                password = null;
            }

            //CALL HELPER CLASS
            userId = CommunitySelfRegHelper.selfRegCandidate(firstname, lastname, email, password, nickname);

            System.debug('reconfirmUrl = ' + regConfirmUrl + ' startUrl = ' + startUrl  + ' password = ' + password);
            if ((userId != null && userId instanceof Id) || Test.isRunningTest()){
                System.debug('Checking conditions >> 1=' + (password != null) +' 2=' + (password.length() > 1));
                if (password != null && password.length() > 1) {
                    System.debug('Found password and preceding to login >> ' + startUrl);
                    try{
                        ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                        aura.redirect(lgn);
                    } catch(Exception ex){
                        System.debug('Login attempt failure Type >> '+ ex.getTypeName() + ' Error message >> '+ ex.getMessage());
                        return returnMessage('1', ex.getMessage());
                    }
                }
                else {
                    System.debug('Password not set, redirecting to regConfirmUrl = ' + regConfirmUrl);
                    ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                    aura.redirect(confirmRef);
                }
            } else if(userId == '1') {
                System.debug('Redirect user as the user already exists code ' + userId);
                return  returnMessage(userId, 'Are you registered with us? If so, please log in via Login page.');
            } else if(userId == '2') {
                System.debug('Redirect user to the login page ' + userId);
                return  returnMessage(userId, 'Are you registered with us? If so, please check your email for Login instruction.');
            }

			insert new PermissionSetAssignment(
                PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Sirenum_Engage_Permission_Set'].Id,
                AssigneeId = userId
            );

            return returnMessage('0', 'Registration Completed.');
        } catch(DmlException de){
            System.debug('Found DmlException, record fail count >> ' + de.getNumDml() + ' \nException >>' + de);
            return returnMessage('1', 'Something went wrong! Please contact your branch with error code "Community REG-DMLEx"');
        }
        catch (Exception ex) {
            System.debug('Candidate Registration Error!!' + ex);
            return returnMessage('-1', 'Something went wrong! Please contact your branch with error code "Community REG-GNEx"');
        }
    }

    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) {
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.Contact.fieldSets.getMap().get(extraFieldsFieldSet);
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
            }
        }
        return extraFields;
    }

    @TestVisible
    private static Map<String,String> returnMessage(String code, String msg){
        Map<String,String> statusMap = new Map<String, String>(); // code AND message
        statusMap.put(code,msg);
        return statusMap;
    }

    @AuraEnabled
    public static Contact getCandidateFromId(String id){
    Contact candidate = null;
        candidate = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id=:id LIMIT 1];
        return candidate;
    }
}