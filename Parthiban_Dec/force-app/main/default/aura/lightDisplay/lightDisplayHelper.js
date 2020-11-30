({
    handleError : function(errors) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: errors.message,	
            type: 'Error',
        });
        toastEvent.fire();
        
    },
    
    handleSuccess : function(message) {
        
        var toastParams = {
            title: "Success",
            message: message,  
            type: "success"
        }; 
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }    
   
})