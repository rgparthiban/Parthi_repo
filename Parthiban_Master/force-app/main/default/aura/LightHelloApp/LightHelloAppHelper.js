({
	helperMethod : function(component,event,errors) {
        
		var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : errors.name,
 				message: errors.message,	
                type: 'Error',
                                });
             toastEvent.fire();
	}
})