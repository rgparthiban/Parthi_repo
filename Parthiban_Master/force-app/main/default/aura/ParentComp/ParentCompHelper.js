({
	loadService: function (cmp, event) {
        console.log("Inside LoadService helper");
        $A.createComponent("com_tcs_telecom:serviceandSite", {
              
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
            	var target = cmp.get('v.body');
                var name = cmp.find("v.recordId").ServiceType__c;
                contentComponent.set('v.svcName', name);
                contentComponent.set('v.isCompVisible',true);
                target.push(contentComponent);
                cmp.set('v.body', target);
            } else {
                throw new Error(error);
            }
        });
    },
    getExistingAttributes : function(component){
          var quoteID = component.get("v.quoteId");
        console.log('quoteID in getExistingAttributes pkgGridCompHelper:'+quoteID+'version'+component.get('v.currentVersion'));
        
        var action = component.get("c.fetchExistingAttributes");
        action.setParams({
            'quoteId': quoteID,
            'currentVersion' :  component.get('v.currentVersion')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               console.log('in getExistingAttributes'+response.getReturnValue());
                console.log('in getExistingAttributes stringify'+JSON.stringify(response.getReturnValue()));
                var attrExisting = response.getReturnValue();
                console.log('attrExisting length'+attrExisting.length);
                  var items = [];
                  var innerItems = [];
                for(var key in attrExisting) 
                {
                    console.log('const key .. '+key);
                    var innerAttr = attrExisting[key];
                    console.log('innerAttr'+JSON.stringify(innerAttr));
                    for (var innerKey in innerAttr) {
                        var val = innerAttr[innerKey];
                        for ( var iikey in val ) {
                            innerItems.push({value:val[iikey], name:iikey}); 
                        }
                        console.log('iinnerItems'+JSON.stringify(innerItems));
                    }
                    items.push({value:innerItems, key:key});
                    innerItems = [];
                }

                 console.log('attrExisting items final'+JSON.stringify(items));
                component.set("v.attr",items)
                
            }});
        $A.enqueueAction(action); 
    },
    
    
   
    getPriceCartResponse_old : function(component, event, selServiceWithOffers){
        
         var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
            priceDataAction.setParams({
              'productLineItemMapStr': JSON.stringify(selServiceWithOffers)   
            });
            priceDataAction.setCallback(this, function(priceResponse) {
                console.log('response-data-price> at'+JSON.stringify(priceResponse.getReturnValue()));
               component.set('v.addToCart',true);             
                var priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
                priceEvent.setParams({
                    "priceData" : priceResponse.getReturnValue()
                });
                priceEvent.fire();
                component.set('v.isSending',false);
            });
            $A.enqueueAction(priceDataAction);
    },
    
    setQuantityToBigMap_old : function(component, event, contsdata){
        
        	
            	console.log('contsdata at  **   QuoteLineDataMap >   '+JSON.stringify(contsdata));
            	var offerQtyMap = new Map();
            	for(var i=0;i<contsdata.length;i++){
                var valList = contsdata[i].value;
                for(var j=0;j<valList.length;j++){
                    console.log('valList[j].quantity.. '+contsdata[i].key + '--'  +valList[j].quantity);
                    if(valList[j].Is_Package && valList[j].quantity!=null && valList[j].quantity!=undefined)
                    {
                        offerQtyMap.set(contsdata[i].key,valList[j].quantity);
                        break;
                        
                    }
                    
                }
            }
            var itemsNewList = [];
            for(var i=0;i<contsdata.length;i++){
                itemsNewList.push({value:contsdata[i].value, key:contsdata[i].key,quantity:offerQtyMap.get(contsdata[i].key)});
            }
            console.log('items in setCartData -after modified -itemsNewList in helper:'+JSON.stringify(itemsNewList));  
        	return itemsNewList;
    },
    
    fireEventForProdSelTab : function(component, event){
         		var servicebasedEve = $A.get("e.com_tcs_telecom:ServiceBasedOfferEvent");
                var bigFinalMap=component.get("v.CartMapDataForOffer");
                console.log('bigFinalMap .in fireEventForProdSelTab. '+JSON.stringify(bigFinalMap));
                servicebasedEve.setParams({
                    "serviceBasedData" : bigFinalMap
                });
                servicebasedEve.fire();
    },
    
   
    
    addToCartForMultipleServices : function(component, event, isAddToCart) {
      
         component.set('v.parentcompSpinner',true);
          var viewCartClickedYN = component.get('v.afetrClickOfViewCart');
            var quoteID = component.get("v.quoteId");
            var selectedAttr = component.get("v.attr");
            var selectedGridRowsMap =component.get('v.CartMapDataForOffer');
            var gridResponseMultiple= JSON.stringify(selectedGridRowsMap);          
            console.log('..selectedGridRowsMap in addToCart. '+gridResponseMultiple);
            console.log('viewCartClickedYN is.. '+viewCartClickedYN);
        	
        	var existselServiceWithOffers=component.get('v.QuoteLineDataMap');
            console.log('existselServiceWithOffers is.. '+JSON.stringify(existselServiceWithOffers));
                  component.set('v.selectPackageList', []);
                    var selectionAfterClick= component.get('v.selectPackageList');
                  
         			 console.log("selectedAttr in shoppingcartest" +selectedAttr);
                    var selectedPackage = component.get('v.Cart'); 
                    var gridResponse = JSON.stringify(component.get("v.gridOriginalData"));
                   console.log('..gridResponse in addToCart gridResponse. '+gridResponse);
                    console.log('QuoteID-->'+quoteID);
              		var action = component.get("c.getFinalMap");
                	var serviceType=component.get('v.selectedService');
                	action.setParams({
                    'selectedOffers': selectedPackage,
                    'gridJson':  gridResponseMultiple,
                    'quoteId':quoteID,
                    'attributeList':JSON.stringify(selectedAttr),
                   'existOfferMap': JSON.stringify(existselServiceWithOffers),
                    'currentVersion' : component.get('v.currentVersion')
                });
                    action.setCallback(this, function(response) {
                           
                        console.log('QuoteLines--response new map>'+JSON.stringify(response.getReturnValue()));
                        var resData=response.getReturnValue();
                        console.log('resData->'+resData);
                        var selServiceWithOffers = [];
                        for(var serviceName in resData){
                            console.log('serviceName key .. '+serviceName);
                            var resultData = resData[serviceName];
                            var selectedOffers = [];
                            for ( var key in resultData ) 
                            {
                                console.log('const key .. '+key);
                                selectedOffers.push({value:resultData[key], key:key});
                             }
                            var pkgAndProdCombo=this.setQuantityToBigMap(component, event,selectedOffers);
                            selServiceWithOffers.push({value:pkgAndProdCombo, key:serviceName});
                        }
                        console.log('selServiceWithOffers..'+JSON.stringify(selServiceWithOffers));
                        //commented to implement addo
                       //	this.getPriceCartResponse(component, event, isAddToCart,selServiceWithOffers);
                       // component.set('v.isSending',false);
                       this.mergeAddonToPackage(component,selServiceWithOffers);
                    });
                    $A.enqueueAction(action);
              
    },
    
    convertGridMapToFinalMap : function(component, event, isAddToCart,existselServiceWithOffers){
         		var selectedGridRowsMap =component.get('v.CartMapDataForOffer');
              	var gridResponseMultiple= JSON.stringify(selectedGridRowsMap); 
             	console.log('gridResponseMultiple in convert Grid.. '+gridResponseMultiple);
          		var quoteID = component.get("v.quoteId");
        		var selectedAttr = component.get("v.attr");
        		var action = component.get("c.getFinalMap");
               
                action.setParams({
                    'selectedOffers': null,
                    'gridJson':  gridResponseMultiple,
                    'quoteId':quoteID,
                    'attributeList':JSON.stringify(selectedAttr),
                    'existOfferMap': JSON.stringify(existselServiceWithOffers), //JSON.stringify(existselServiceWithOffers), //

                    'currentVersion' : component.get('v.currentVersion')
                });
        		action.setCallback(this, function(response) {
                       console.log('convertgrid--response new map>'+JSON.stringify(response.getReturnValue()));
                        var resData=response.getReturnValue();
                        console.log('resData at line no->'+resData);
                        var selServiceWithOffers = [];
                        for(var serviceName in resData){
                            console.log('serviceName key .. '+serviceName);
                            var resultData = resData[serviceName];
                            var selectedOffers = [];
                            for ( var key in resultData ) 
                            {
                                console.log('const key .. '+key);
                                selectedOffers.push({value:resultData[key], key:key});
                             }
                            var pkgAndProdCombo=this.setQuantityToBigMap(component, event,selectedOffers);
                            selServiceWithOffers.push({value:pkgAndProdCombo, key:serviceName});
                        }
                        console.log('selServiceWithOffers.from apex.>>'+JSON.stringify(selServiceWithOffers));
                      
                        
                       this.getPriceCartResponse(component, event, isAddToCart,selServiceWithOffers);
                    });
                    $A.enqueueAction(action);
       
    },

    
    setQuantityToBigMap : function(component, event, contsdata){
        
        	
            	console.log('contsdata at  **   QuoteLineDataMap  pkgGrid>   '+JSON.stringify(contsdata));
            	var offerQtyMap = new Map();
            	for(var i=0;i<contsdata.length;i++){
                var valList = contsdata[i].value;
                for(var j=0;j<valList.length;j++){
                    console.log('valList[j].quantity.. '+contsdata[i].key + '--'  +valList[j].quantity);
                 
                    if(valList[j].Is_Package && valList[j].quantity!=null && valList[j].quantity!=undefined)
                    {
                       
                        offerQtyMap.set(contsdata[i].key,valList[j].quantity);
                        break;
                        
                    }
                    
                }
            }
            var itemsNewList = [];
            for(var i=0;i<contsdata.length;i++){
                itemsNewList.push({value:contsdata[i].value, key:contsdata[i].key,quantity:offerQtyMap.get(contsdata[i].key)});
            }
            console.log('pkgGrid -after modified -itemsNewList in helper:'+JSON.stringify(itemsNewList));  
        	return itemsNewList;
    },
    

	

    
    getPriceCartResponse : function(component, event, isAddToCart,selServiceWithOffers){
         var selectedAttr = component.get("v.attr");
         var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
            priceDataAction.setParams({
              'productLineItemMapStr': JSON.stringify(selServiceWithOffers)   
            });
            priceDataAction.setCallback(this, function(priceResponse) {
                console.log('response-data-price> at'+JSON.stringify(priceResponse.getReturnValue()));
                if(isAddToCart) { 
                    component.set('v.addToCart',true);    
                    var compEvent = $A.get("e.com_tcs_telecom:CartEvent");
                    compEvent.setParams({
                        "cartData" : '',
                        "selectedAttributes" :  selectedAttr,
                        "serviceOfferData" : selServiceWithOffers,
                        "afetrClickOfViewCart": true
                    });
                    compEvent.fire();
                } else {

                }
                
                var priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
                priceEvent.setParams({
                    "priceData" : priceResponse.getReturnValue()
                });
                priceEvent.fire();
                component.set('v.isSending',false);
            });
            $A.enqueueAction(priceDataAction);
    },
     mergeAddonToPackage : function(component,selServiceWithOffers){
        			 	var addOnProductsMapJson = component.get('v.addonProductsMap');
                        console.log('addOnProductsMapJson in mergeaddon .. '+JSON.stringify(addOnProductsMapJson));
                         var selPackageOfferIdFromAddonPage=component.get('v.selPackageOfferIdFromAddonPage');
        				var addOnCall = JSON.stringify(addOnProductsMapJson);
        				console.log('addOnCall.. '+addOnCall);
        		//console.log('addOnCall.. '+addOnProductsMapJson.length);
        		var mapData = new Map();
           		var addOnSelect=component.get('v.addonSelect');	
                if(addOnSelect && addOnProductsMapJson!=undefined && addOnProductsMapJson!=null && addOnProductsMapJson.length > 0){
                    var selServiceName=component.get('v.selServiceforAddAddon');
        		var selPackageName = component.get('v.selPackageforAddAddon');
         		var orderId = component.get("v.orderId");
        	 	
				for(var i=0;i<selServiceWithOffers.length;i++){
                        console.log('selServiceWithOffers[i] key is.. '+selServiceWithOffers[i].key);
                        //if(selServiceWithOffers[i].key == selServiceName){
                        	var selSerKey = selServiceWithOffers[i].key;
                            var resDataVal= selServiceWithOffers[i].value;
                            for(var j=0;j<resDataVal.length;j++){
                                console.log('resDataVal[j].key is.. '+resDataVal[j].key);
                                var selSerPkgName = resDataVal[j].key;
                                
                                var selServAndPkg = selSerKey+"#"+selSerPkgName;
                                //if(resDataVal[j].key == selPackageName){
                                    for(var p=0;p<addOnProductsMapJson.length;p++){
                                        console.log('addOnProductsMapJson[p].key..'+addOnProductsMapJson[p].key);
                                        if(addOnProductsMapJson[p].key == selServAndPkg){
                                            var pkgQuantity = resDataVal[j].quantity;
                                            console.log('pkgQuantity..'+pkgQuantity);
                                            if(pkgQuantity == undefined){
                                                pkgQuantity = 1;
                                            }
                                             	var prodsList = [];
                                            	var allProdsList=[];
                                    			prodsList=resDataVal[j].value;
                                            	console.log('prodsList is.. '+ selServAndPkg + 'prodlist json ...'+JSON.stringify(prodsList))
                                            	console.log('addOnProductsMapJson[p].value .. '+JSON.stringify(addOnProductsMapJson[p].value));
                                            	var addOnList = addOnProductsMapJson[p].value;
                                            	
                                            	//var mapData = new Map();
                                            	var mapkey =selServAndPkg+'#';
                                            	console.log('mapkey is.. '+mapkey);
                                                for(var k=0;k<prodsList.length;k++){
                                                    mapData.set(mapkey+prodsList[k].productOfferingId,prodsList[k]);
                                                }
                                            	//console.log('selSerPkgName+selSerPkgName+prodsList[k].productOfferingId..'+selSerPkgName+selSerPkgName+prodsList[k].productOfferingId);
                                                //for(var p=0;p<prodsList.length;p++){
                                                   for(var x= 0; x< addOnList.length;x++){
                                                      // console.log('oferid..ordlist and addon.' +prodsList[p].productOfferingId  + '-' +addOnList[x].productOfferingId);
                                                    	//if(prodsList[p].productOfferingId == addOnList[x].productOfferingId) {
                                                        //prodsList.push(addOnList[x]);
                                                        	//addOnList.splice(x,1);
                                                    	//}
                                                       if(mapData.get(mapkey+addOnList[x].productOfferingId)==null){
                                                           addOnList[x].rcnetprice=(addOnList[x].rcnetprice)*pkgQuantity;
                                                           addOnList[x].rcnetprice=(addOnList[x].rcnetprice).toFixed(2);
                                                              addOnList[x].nrcnetprice=(addOnList[x].nrcnetprice)*pkgQuantity;
                                                               addOnList[x].nrcnetprice=(addOnList[x].nrcnetprice).toFixed(2);
                                                           prodsList.push(addOnList[x]);
                                                       }
                                                    
                                                	}
                                               //}
                                               
                                             }
                                    }
                                       
                           		 }
                        	
                    		} 
						console.log('mergeAddonToPackage.in addons after merge>> .'+JSON.stringify(selServiceWithOffers)); 
           				 component.set('v.addonSelect',false);
                		}
        				component.set("v.QuoteLineDataMap" , selServiceWithOffers); 
                        component.set('v.isSending',false);
                        ///component.set('v.parentcompSpinner',false);
                       
                        component.set("v.existOfferMap" , selServiceWithOffers);  
                        this.getPriceCartResponse(component, event, true,selServiceWithOffers);
				//}	);
        	//$A.enqueueAction(addonAction);	
               // }
        				
        
        
        
        
        
        				
    },
    getOffersAndAddonsMap : function(component, event, helper){
        console.log('inside getOffersAndAddonsMap');
         var items = event.getParam("serviceOfferData");
			if(items == 0){
            var currentTab = component.get("v.selTabId"); 
            console.log("currentTab.conts. "+currentTab);
                if(currentTab == '3'){ 
                    component.set("v.selTabId" , '1');
                }
			}
        else if(items!=undefined){
                var emptyList = [];
            	var offerQtyMap = new Map();
                var listofservices=component.get('v.listofservices');
          		for(var i=0;i<items.length;i++){
                    if(!listofservices.includes(items[i].key)){
                        console.log('services name are--->'+items[i].key);
                        listofservices.push(items[i].key);
                     }
              	}
            var itemsNewList = [];
            console.log('items[0].key.. '+items[0].key);
            component.set('v.listofservices',listofservices);
            var deffirstServOffer= items[0].value;
             if(deffirstServOffer!=undefined && deffirstServOffer!=null){
                 console.log('items[0].value.length.. '+items[0].value.length);
                 component.set("v.selectedOffersLength" , items[0].value.length);   
				console.log('afetr set decimals'+JSON.stringify(deffirstServOffer)); 
                }
            component.set('v.defFirstServiceOffer',deffirstServOffer);
			console.log('items in setCartData after modified items:'+JSON.stringify(items));  
            component.set("v.QuoteLineDataMap" , items);   
            component.set("v.ServiceAndOffersQuoteLineDataMap" , items);  
            component.set("v.QuoteLineDataMapForAddons" , items);
           
        }
        var currentTab = component.get("v.selTabId");
        console.log('currentTab.>>. '+currentTab );
		if(currentTab == '1' || currentTab == '2')
        {
               component.set("v.selTabId" , '3');   
        }
    },
     cartEventData : function(component, event, helper) {
        component.set('v.getPackage',[]);
        component.set("v.isTabHiddenForAddon",'slds-show');
        component.set("v.isTabHiddenForCart",'slds-show');
        var items = event.getParam("finalmap");
        //var afetrClickOfViewCart = event.getParam("afetrClickOfViewCart");
       // console.log('afetrClickOfViewCart is.carteventdata. '+afetrClickOfViewCart);
        //component.set('v.afetrClickOfViewCart',afetrClickOfViewCart);
		if(items == 0){
            var currentTab = component.get("v.selTabId"); 
            console.log("currentTab.conts. "+currentTab);
            if(currentTab == '3'){ 
                component.set("v.selTabId" , '1');
            }
        }else if(items!=undefined){
            console.log('items for multipleservice  ordeer helper..   '+JSON.stringify(items));
            var sleAtr = event.getParam("selectedAttributes");  
            console.log('selAtr is..>>> '+JSON.stringify(sleAtr));
            component.set("v.attr",sleAtr);
            component.set("v.existAttrData", sleAtr);
            var emptyList = [];
            component.set("v.overridenDataList",emptyList);
            var listinPArentComp=component.get("v.overridenDataList")
            console.log('listinPArentComp. '+listinPArentComp);
           
            var offerQtyMap = new Map();
            
            var listofservices=component.get('v.listofservices');
          
            for(var i=0;i<items.length;i++){
                if(!listofservices.includes(items[i].key)){
                    console.log('services name are--->'+items[i].key);
                    listofservices.push(items[i].key);
                 }
              }
            var itemsNewList = [];
            console.log('items[0].key.. '+items[0].key);
            component.set('v.listofservices',listofservices);
            var deffirstServOffer= items[0].value;
            
           
            if(deffirstServOffer!=undefined && deffirstServOffer!=null){
                 console.log('items[0].value.length.. '+items[0].value.length);
                component.set("v.selectedOffersLength" , items[0].value.length);   
            
            console.log('afetr set decimals'+JSON.stringify(deffirstServOffer)); 
                
                
            }
            component.set('v.defFirstServiceOffer',deffirstServOffer);
			console.log('items in setCartData after modified items:'+JSON.stringify(items));  
            component.set("v.QuoteLineDataMap" , items);   
            component.set("v.ServiceAndOffersQuoteLineDataMap" , items);  
            component.set("v.QuoteLineDataMapForAddons" , items);
            component.set("v.existOfferMap" , items);
        }
        var currentTab = component.get("v.selTabId");
        console.log('currentTab.>>.in cartevent '+currentTab );
        
        
        if(currentTab == '1' || currentTab == '2')
        {
                component.set("v.viewcartbutton",true);
            
            	component.set("v.selTabId" , '3');   
        }
      	else if(currentTab == '3'){
           
        }
         component.set('v.displayCart',true);
        component.set('v.parentcompSpinner',false);
        
    }
    
    
    
        
})