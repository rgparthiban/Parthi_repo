({
	doinit : function(component, event, helper) {
        
        var compdisplay = $A.get("e.c:lightDisplayEvent");
        compdisplay.setParams({
            "strname":"parthiban event"
        });
        compdisplay.fire();        
        component.set('v.message',"Event fired already");
        component.set("v.selTabId","2");
	},
    selectTab : function(component, event, helper) { 
        /* General utility */
        
        var selected = component.get("v.key");
        
        var condition = component.get("v.condition");
        if (condition == false)
        {            
             component.set("v.key","1");            
            if (component.find("tabs").get("v.selectedTabId") == "2")
            {               
                component.find("tabs").set("v.selectedTabId","1");   
            }                
            
        }
        else
        {            
            component.find("tabs").set("v.selectedTabId",selected);  
        }
        
    },
    handleClick : function(component, event, helper){
        component.set("v.condition","true"); // value assignation
         component.set("v.key","3");
    },
    saveRound : function(component,event,helper){
         var mapAction = component.get("c.getSelectedQuoteServiceType");
         mapAction.setParams({
             'quoteId': quoteId
         });
         mapAction.setCallback(this,function(response){
             var mapResult = [];
                var result = response.getReturnValue();
                for(var key in result){
                    mapResult.push({value:result[key], key:key});
                }
            // component.set('v.defServiceType',mapResult[0].key);            
             component.set('v.quoteServiceTypes',mapResult);
         }
                               
                               );
        $A.enqueueAction(mapAction);  
    },
    tabclick : function(component, event, helper){
        alert('am here');
         component.find("tabs").set("v.selectedTabId","1");  
    },
    DiscTypeChange : function(component, event, helper) {
       
         var code = '4343.34343454';       
        var nameRegex;
        nameRegex= "(^(\+|\-)(0|([1-9][0-9]*))(\.[0-9]{1,2})?$)|(^(0{0,1}|([1-9][0-9]*))(\.[0-9]{1,6})?$)";
        var regex = new RegExp(nameRegex);
        if (!regex.test(code)){            
            alert('more than 6')
        }
        
        
        var attr = component.get('v.testvalue');
        var num = 30.12345678;
        var numcheck = 30.1234567;
        if (num != numcheck){
            alert('not matched');
        }
        var fixednum = num.toFixed(4);
        if (parseFloat(num) != parseFloat(fixednum)){
          alert(n);  
        }
        else{
            alert('not match');
        }
	 
        
	},
    testException: function(component,event,helper){

        var mapAction = component.get("c.getAccountDetails");
        mapAction.setParams({
            'accountId': 'quoteId'
        });
        mapAction.setCallback(this,function(response){
            var mapResult = [];
            let state = response.getState();
            if (state === "SUCCESS") {
                // Process server success response
                let returnValue = response.getReturnValue();
                helper.handleSuccess($A.get("$Label.c.qSuccess"));
                console.log('result....'+JSON.stringify(returnValue));
                //this.handleSuccess('Account Record listed successfully');
            }
            else if (state === "ERROR") {                
                var error = response.getError()[0];               
                var errors = JSON.parse(error.message);                   
                helper.handleError(errors);
                console.error(errors.name +" (stackTrace "+ errors.stackTrace +"): "+ errors.message);
            }               
        });
        
        $A.enqueueAction(mapAction); 
    },
    
    handleErrorsmsg : function(component,event,msg) {
    // Configure error toast
    var toastParams = {
        title: "Error",
        message: "Unknown error", // Default error message
        type: "error"
    };
    // Pass the error message if any
   // if (errors && Array.isArray(errors) && errors.length > 0) {
        toastParams.message = msg;
   // }
    // Fire error toast
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams(toastParams);
    toastEvent.fire();
},     
   
    onblur : function(component,event,helper){       
        alert('am here');
    },
    doKeyUp: function(component, event)
    {
         var getInputkeyWord = component.find("searchkeycontDelivery");
         var val=getInputkeyWord.get('v.value');
        
       // var code = event.getSource().get('v.value');       
        var nameRegex;
        //nameRegex= '(^(\+|\-)(0|([1-9][0-9]*))(\.[0-9]{1,2})?$)|(^(0{0,1}|([1-9][0-9]*))(\.[0-9]{1,6})?$)';
        //nameRegex = '^\d+\.\d{1,6}$';
        nameRegex = '^\d+\.\d{1,6}$';
        var regex = new RegExp(nameRegex);
        console.log('testval.1..'+regex.test(val));
        if (regex.test(val)){   
            return 'success';
        }	
        else{            
            alert(val+'........'+'not correct ');
        }
        
        var attr = component.get('v.search');
        var num = 30.12345678;
        var numcheck = 30.12345678;
        if (num != numcheck){
            //alert('not matched');
        }
        var fixednum = num.toFixed(4);
        var fixednum1 = num.toFixed(4);
       // alert(fixednum);
        
        if (parseFloat(num) != parseFloat(fixednum)){
         // alert(num+'.....not matched if');  
        }
        else{
            //alert('matched else');
        }
 		
    }
})