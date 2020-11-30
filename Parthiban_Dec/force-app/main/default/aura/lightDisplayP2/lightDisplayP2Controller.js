({
	eventtest : function(component, event, helper) {
		var compdisplay = event.getParam("strname");
        component.set('v.message',compdisplay);
        alert("event action completed");
	}
})