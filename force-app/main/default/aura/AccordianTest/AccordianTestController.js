({  
    /* by default selecting the first  servise */
    defaultServiceInit: function(component,event,helper){
       // alert();
        component.set('v.priceSpinner',true);
        var servList=[];
        servList =  component.get('v.listofservices');
        console.log('servList'+servList+JSON.stringify(servList)+'servList[0]'+servList[0]);
        component.set('v.selectedService',servList[0]);
        var finalmap = component.get('v.allServicesMap'); 
        console.log('lenghtt of finlmap..'+finalmap.length);
        console.log('JSON.stringify(finalmap)' +JSON.stringify(finalmap));
        component.set('v.bigconMap',finalmap);
        component.set('v.bigconMapUpdate',finalmap);
        component.set('v.initCheck',true);
        console.log('initcheckglag..'+component.get('v.initCheck'));
        var orderType;
        for(var i=0;i<finalmap.length;i++){
               	console.log('key of finalmap. '+finalmap[i].key);
            	orderType = finalmap[i].orderType;
                component.set('v.orderType',orderType);
                break;
        }
    },
    
  
    
    moveToNextService : function(component,event,helper){
        var deleteOfferService= event.getParam("selectedService");
        console.log('deleteOfferService is.. '+deleteOfferService); 
        var finalmap =  component.get('v.allServicesMap');
        console.log('finalmap length ..before splice.. '+finalmap.length)
        console.log('JSON.stringify(finalmap) before splice' +JSON.stringify(finalmap));
        for(var i=0;i<finalmap.length;i++){
            console.log('finalmap[i].key..>>>>'+finalmap[i].key);
            if(finalmap[i].key == deleteOfferService){
                finalmap.splice(i,1);
                console.log('finalmap length ..after splice.. '+finalmap.length)
                console.log('JSON.stringify(finalmap) afetr splice' +JSON.stringify(finalmap));
                if(finalmap.length!=undefined && finalmap.length > 0){
                    console.log('finalmap[i].key.in if.>>>>'+finalmap[i].key);
                    component.set('v.selectedService',finalmap[i].key); 
                    console.log('finalmap[i].value.in if.>>>>'+JSON.stringify(finalmap[i].value));
                    component.set('v.conMap',finalmap[i].value); 
                    component.set('v.allServicesMap',finalmap); 
                    component.set('v.orgMap',finalmap); 
                    
                }
                break;
            }
        }
        
        
        
    },
    
    
    
    
    /**
     Display list of offers of serviceType which we selected
     * */
    showSearch : function(component,event,helper){
        component.set('v.switchspinner',true);
        var finalmap = component.get('v.allServicesMap');
        var selServiceName = 	event.target.title;
        component.set('v.selectedService',selServiceName);
        console.log('selServiceName.'+selServiceName);
        //console.log('value.classname. '+ document.getElementById(selServiceName).className);
        for(var i=0;i<finalmap.length;i++)
        {
            if(finalmap[i].key == selServiceName)
            {
                
                document.getElementById(finalmap[i].key +'-a').className = "hcompStyleColor";
            }
            else
            {
                
                document.getElementById(finalmap[i].key +'-a').className = "compStyle";  
            }
        }
        
        for(var i=0;i<finalmap.length;i++){
            console.log('finalmap[i].key..>>>>'+finalmap[i].key);
            if(finalmap[i].key == selServiceName){
                component.set('v.conMap',finalmap[i].value); 
                break;
            }
        }
        component.set('v.switchspinner',false); 
    },
    
    
    
    
    
    
    
    
    submit_test : function(component,event) { 
        component.set('v.switchspinner',true);
        component.get("c.submit").run();
      //  submit(component,event);
       component.set('v.switchspinner',false);
        
    },
    
    /* for persisting the QuoteLineItems of a Quote */
    submit : function(component,event) { 
        //component.set('v.initCheck',true);
        var fldg=component.get('v.switchspinner');
        console.log('valuein flg...'+fldg);
        component.set('v.switchspinner',true);
        console.log('bigconMapUpdate in submit '+JSON.stringify(component.get('v.bigconMapUpdate')));
       var mapItemsCartData = component.get('v.allServicesMap');
        console.log('createNewVersion in submit'+component.get("v.createNewVersion"));
        console.log('in submit'+JSON.stringify(mapItemsCartData));
        var mapItems = JSON.stringify(mapItemsCartData);
        //Added for submit validation
        
        var cartCounter=0;
        for (var cartItemMap=0;cartItemMap< mapItemsCartData.length;cartItemMap++)
        {
            var cartMap= mapItemsCartData[cartItemMap].value;
            console.log('cartItemmap length'+cartMap.length);
            if(cartMap.length>0)
            {
            cartCounter+=1;
            console.log('cartCounter value'+cartCounter);
             break;
            }
           if(cartCounter>0){
               console('In exit loop..');
           break;
           }
        }
        // 
        if(cartCounter>0){           
        var action = component.get("c.persistMultipleQuoteLinesBOB");
         component.set('v.switchspinner',true);
        action.setParams({   
            'cartItemsMap':  mapItems,
            'quoteId' : component.get("v.quoteRecId"),
            'attributes': JSON.stringify(component.get("v.attr")),
            'createNewVersion' : component.get("v.createNewVersion")
        });
        action.setCallback(this, function(response) {
            console.log(response.getState());
            var state = response.getState();
            if(response.getReturnValue() != 'Error') {
                console.log('price call...nkewww'+response.getReturnValue());
                var priceDataAction = component.get("c.updatePriceForSubmit");
                component.set('v.switchspinner',true);
                priceDataAction.setParams({
                    'cartItemsMap':  mapItems,
                    'quoteId' : component.get("v.quoteRecId"),
                    'quoteVersion' : response.getReturnValue()
                });   
                priceDataAction.setCallback(this, function(priceResponse) {
                    console.log('priceResponse'+priceResponse);
                    if(priceResponse.getReturnValue() != 'error') {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                           
                            type: 'success',
                        });
                        toastEvent.fire();
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: 'Error while updating price. Please check after sometime or contact Administrator!',
                            type: 'error',
                        });
                        toastEvent.fire(); 
                    }      
                    console.log('Quote id before navigation '+component.get("v.quoteRecId"));
                    var navEvt = $A.get("e.force:navigateToSObject");
                    console.log('navEvt '+navEvt);
                    navEvt.setParams({
                        "recordId": component.get("v.quoteRecId")
                    });
                    navEvt.fire();
                    
                    
                });
                $A.enqueueAction(priceDataAction);
            }  
            
            
        });
        $A.enqueueAction(action);
        }else if(cartCounter == 0) 
        {
       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: 'There are no offers added to the Quote!!Please select offers before Submit',
                            type: 'error',
                        });
                        toastEvent.fire();
       }
         component.set('v.switchspinner',false);
       
        
    },
    
    
    /* getting the attribute values and price updation fpr attributes  */
    setAttributeValue:function(component,event)
    {
        console.log("inside setAttributeValye  ...");
        var overridenList = event.getParam("pkgOverridenList");
        console.log('pkgOverridenList .overridenList in acctest. '+JSON.stringify(overridenList));
        component.set('v.overrideData',overridenList);
        
        
        var attrvalue= event.getParam("Attribute");
        console.log('Attribute is'+JSON.stringify(attrvalue));
        var attrList =  component.get("v.attr");
        var attrListNew = [];
        var items = [];
        for ( var key in attrvalue ) {
            
            attrListNew.push({value:attrvalue[key].attributes, key:attrvalue[key].product});
            
        }
        console.log('attrListNew Attribute is'+JSON.stringify(attrListNew));
        component.set("v.isOpen", false);
        component.set("v.attr",attrListNew);
        
        var bigMapdata = event.getParam("bigMap");
        
        var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
        priceDataAction.setParams({
            'productLineItemMapStr': JSON.stringify(bigMapdata)
        });
        priceDataAction.setCallback(this, function(priceResponse) {
            component.set('v.priceSpinner',false);
            
            console.log('updateAttributePrice.getReturnValue().at AccTEst Helper. '+JSON.stringify(priceResponse.getReturnValue()));
            var priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
            priceEvent.setParams({
                "priceData" : priceResponse.getReturnValue()
            });
            priceEvent.fire();
            component.set('v.priceSpinner',false);
        });
        $A.enqueueAction(priceDataAction);
        component.set('v.conMap',bigMapdata);
        
        
        
    },
    
  nextToPayer : function(component, event, helper) {
      var mapToPersist = component.get('v.allServicesMap');
      console.log('mapToPersist value not define.....'+mapToPersist);
      if (mapToPersist != ''){
     var addPayerEvent = $A.get("e.com_tcs_telecom:FromAccTestToOrderParent");
            addPayerEvent.setParams({
            });
            addPayerEvent.fire();
      }
      else{
          var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Information',
                            message: 'Please select ateast one package',
                            type: 'Information',
                        });
                        toastEvent.fire(); 
      }
    },
    
    saveOrder : function(component, event, helper){
    		var mapToPersist = component.get('v.allServicesMap');
        	var mapToPersistJson = JSON.stringify(mapToPersist); 
        	var attributedata=component.get('v.attr');
            var attrjson = JSON.stringify(attributedata);
            console.log('in saveOrder ..'+mapToPersistJson);
        	console.log('in save attr .. '+attrjson);
            console.log('in save orderid.. '+component.get("v.quoteRecId"));            
            var action = component.get("c.persistOrderLines");
            action.setParams({   
            'mapToPersistJson':  mapToPersistJson,
            'orderId' : component.get("v.quoteRecId"),
            'attributes': JSON.stringify(component.get("v.attr"))
            //'createNewVersion' : component.get("v.createNewVersion")
        });
        action.setCallback(this, function(response) {
            console.log('response.. '+response.getReturnValue());
            var toastEvent = $A.get("e.force:showToast"); 
           if(response.getReturnValue()) 
           {         
         		toastEvent.setParams({
             	message: "Order saved successfully",               
                                       type: 'success',
                                   });
        			
           }
            else{
                        
         		toastEvent.setParams({
             	message: "Error in saving order ",               
                                       type: 'error',
                                   });
        				
                
            }
            toastEvent.fire();
        });
       $A.enqueueAction(action);  
}
    
    
    
    
})