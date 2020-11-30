public class expImpl implements expInterface{
    
    public static String expMethod(Exception ex)
    {       
        
        string name = ex.getTypeName();
        string msg = ex.getMessage();
        integer eCode;
        
        if (name == 'System.MathException'){            
            msg = getErrorMessage(102);
            eCode = 102;
        }
        else if (name == 'System.DmlException'){
            msg = getErrorMessage(103);
            eCode = 103;
        }
        else if (name == 'System.QueryException'){
            msg = getErrorMessage(104);
            eCode = 104;
        }        
        CustomException data = new CustomException(name,ex.getStackTraceString(),msg, eCode);   
        return JSON.serialize(data);
    }
    
    public static string getErrorMessage(integer eCode)
    {
        Exception_Messages__c objData  = new Exception_Messages__c();        
        objData = [SELECT Id, Description__c  FROM Exception_Messages__c where code__c =: eCode limit 1];        
        return objData.Description__c;
    }
    
}