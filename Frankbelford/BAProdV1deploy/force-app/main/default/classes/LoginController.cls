global without sharing class LoginController {
    
    @AuraEnabled
    global static String checkPortal(String username, String password) {
        
        try {
            if(String.isEmpty(username)){
                return 'UserNameError';
            }else if(String.isEmpty(password)){
                return 'PasswordError';
            }
            ApexPages.PageReference lgn = Site.login(username,password,null);
            aura.redirect(lgn);
            if (lgn!=null) {
                return  lgn.getURL();
            } else {
                return 'login error';
            }
        }
        catch (Exception ex) {
            return ex.getMessage();
            
            
        }
    }
    
    @AuraEnabled
    global static String resetPasswordMethod(String userName) {
        if(String.isBlank(userName)){
            return 'EnterUserName';
        }
        List<User> lstUserToresetPassword = [SELECT id,username,email from User where UserName = :userName];
        if (lstUserToresetPassword.size()>0) {
            System.resetPasswordWithEmailTemplate(lstUserToresetPassword[0].id,true,'CommunityForgotPasswordEmailTemplate');
            return 'Reset';
        }else{
            return 'NotFound';
        }
    }
}