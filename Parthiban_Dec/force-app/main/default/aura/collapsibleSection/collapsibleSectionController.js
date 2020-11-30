({
     display : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    
    displayOut : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },  

	myAction : function(component, event, helper) {
		
	},
    
     display : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    
     displayOut : function(component, event, helper) {
        helper.toggleHelper(component, event);
    }, 
    
    doInit : function(component, event, helper){
      	//component.set('v.expandIcon','utility:add');
       	//component.set('v.collapseIcon','utility:dash');
       	console.log('inside doinit of collapisbleSection');
       	component.set('v.expandIcon','utility:chevronright');
       	component.set('v.collapseIcon','utility:chevrondown');
        var offer=component.get('v.offer');
        console.log('offer -------->>>>>'+JSON.stringify(offer));
        /*console.log('inside do init.is. '+offer.Name);
        console.log('offer._children.. '+offer._children );*/
        if(offer!=undefined)
        {
        if(offer._children!=undefined){
           	console.log('offer._children.len. '+offer._children.length);
            helper.recursiveChildIteration(component, event,helper);
        }
        }
            
    },
    
     sectionOne : function(component, event, helper) {
     	console.log('inside section one ...');
        component.set('v.compSpinner',true); 
        var offer=component.get('v.offer');
         var parentExpandFlag=component.get('v.parentExpandFlag');
          console.log( 'parentExpandFlag is=n contrller.. '+parentExpandFlag);
        console.log('pkgDetailsCalled in section one collapse comp.controlelr. '+offer.pkgDetailsCalled);
         if((offer.pkgDetailsCalled ==null&&parentExpandFlag==null) || offer.pkgDetailsCalled || parentExpandFlag){
             var acc = component.find('articleOne');
  			acc.forEach(function(element) {
        	$A.util.toggleClass(element, "slds-hide");
    		});
    		$A.util.addClass(event.target, "slds-show"); 
             component.set('v.compSpinner',false);  
         }
         else{
             
             
            // if(!parentExpandFlag){
                  helper.getPackageDetails(component, event, helper);
            // }
            
         }
  		},
    
      changeCart : function(component, event, helper) {
        console.log('inside changeCart'+component.get('v.requestType'));      
        var offer = event.getSource().get('v.name');
        console.log('offer diablity before set..'+offer.isDisabled);
        console.log('offer in inner'+JSON.stringify(offer));
          
          
        var reqType=component.get('v.requestType');
        if(reqType == 'Order')
        {
            var compEvent = $A.get("e.com_tcs_telecom:OrderSelectedOfferEvent");
            compEvent.setParams({
                "selectedOffer" : offer
            });
            compEvent.fire();
        }else{
            var compEvent = $A.get(component.get('v.onclickEventName'));
            compEvent.setParams({
                "selectedOffer" : offer
            });
            compEvent.fire();
              
          
        }
          
          var target = event.getSource();
            
            var toastEvent = $A.get("e.force:showToast");
            console.log('toastevent in  parentcomp'+toastEvent);
            toastEvent.setParams({
               
               
                type: 'success',
            });
            toastEvent.fire();
          	let button = event.getSource();
            button.set('v.disabled',true); 
          
      	
          
           /* let button = event.getSource();
            button.set('v.disabled',true);    
        	var btnflg = false;
          	var ViewcartbtnEvt = $A.get("e.com_tcs_telecom:btnVisibility");
            ViewcartbtnEvt.setParams({
                "disablestatus" : btnflg
            });
            ViewcartbtnEvt.fire();*/
 	           //console.log('offer diablity afetr set..'+offer.isDisabled);
    },
    
    /*buildQuoteLine : function(component, event, helper) {
        
    },*/
    
    
  

})