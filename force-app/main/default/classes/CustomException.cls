public class CustomException extends Exception {
public String name;
    public String message;
    public String stackTrace;
    public Integer code;    
 
    public CustomException(String name, string stackTrace,String message,Integer code) {        
        this.name = name;
        this.message = message;
        this.code = code;
        this.stackTrace = stackTrace;        
    }
}