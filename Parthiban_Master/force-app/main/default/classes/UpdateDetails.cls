public class UpdateDetails {
    @AuraEnabled
    public static boolean updateAccounts(List<object> editedAccountList){
        try{
            system.debug(editedAccountList);
            return false;            
        } catch(Exception e){
            return false;
        }
    }
    
    @AuraEnabled
    public static Decimal roundofValues (decimal value){
        Decimal toRound = 3.1445;
        Decimal rounded = toRound.setScale(2, RoundingMode.CEILING);
        system.debug(rounded);
        return rounded;
    }
    public static string getErrorMsg(integer eCode){
        Exception_Messages__c objData  = new Exception_Messages__c();        
        objData = [SELECT Id, Description__c, code__c, Message__c, Name  FROM Exception_Messages__c where code__c =: eCode limit 1];        
        return objData.Description__c;
    }
    @AuraEnabled
    public static List<Account> getAccountDetails(string accountId){
        try{
            Map<string,object> mapSuccess = new Map<string,object>();
            //status object contains below fiellds
            //type,error_message
            mapSuccess.put('status', 'object');
            mapSuccess.put('response', 'object');
            List<Account> tstAcc = [Select Name, BillingCity, ShippingAddress, AccountNumber from Account limit 1];
            //system exception.
            integer d = 12/0;            
            //List<Account> tstAcc = new List<Account>();
            string eMsg;
            
            //-ve scenario - forcefully throw exception if you want to stop the operation.           
            if (tstAcc.size() == 0 ) {
                AuraHandledException e = new AuraHandledException('Validation error');
                eMsg= getErrorMsg(101);
                e.setMessage(eMsg);
                
                throw e;
            }            
            return tstAcc;
        }
        catch(Exception ex){            
            String allAccountHook='expImpl';
            string jsonExp;
            Type t = Type.forName(allAccountHook);
            expinterface expImplClass = (expinterface)t.newInstance();
            jsonExp = expImplClass.expMethod(ex);   
//insert error details
                         
            throw new AuraHandledException(jsonExp);
        }
        
    }
}