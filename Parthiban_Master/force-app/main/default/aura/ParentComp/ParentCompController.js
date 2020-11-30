({	
    //Currently Not in use
    tabClickwithViewcart: function (component, event,helper) {
         var QuoteLineDataMapvar = component.get("v.QuoteLineDataMapTest");
        

            console.log ('calling cart functions');
            var selectedGridRowsMap =component.get('v.CartMapDataForOffer');
            var quoteID = component.get("v.quoteId");
            console.log('QuoteID in .js-->'+quoteID);
            console.log('addToCartForMultipleServices in .js==selectedGridRowsMap::: '+JSON.stringify(selectedGridRowsMap));
           
            helper.addToCartForMultipleServices(component, event, true);
        

        component.set('v.isSending',false);
     
    },
    
    
    // Currently Not in use
    tabClick1: function (cmp, event,helper) {
          var currentTab = cmp.get("v.selTabId");
         if(cmp.get('v.btnViewCart')==true)
        {
         
        	if(currentTab == '3')
                    {
             			cmp.set("v.selTabId" , '1');  
                    }
            
      		 var toastEvent = $A.get("e.force:showToast");
       		 toastEvent.setParams({
           				 message: 'No Package Selected!',
           				 type: 'failure',
        						});
       		toastEvent.fire();
            
    	}
        else{
        
        console.log ('callingtabClick view cart functions');        
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case '3':  
                var afetrClickOfViewCart = cmp.get("v.afetrClickOfViewCart");  
                console.log ('afetrClickOfViewCart in parentcomp'+afetrClickOfViewCart);  
               
                   if (afetrClickOfViewCart == true)
                   {
                      
                       	console.log("shopping cart click through viewcart"); 
               			 var getPackage= cmp.get('v.getPackage');
                        if(getPackage.length>0)
                		{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                        toastEvent.setParams({
                        title : 'Warning Message',
                        message: 'There are some offers yet to be added',
                        type: 'warning',
                    });
                    toastEvent.fire();
                }
                
                console.log('inside  ,,in parentcomp controller');
                var servicebasedEve = $A.get("e.com_tcs_telecom:ServiceBasedOfferEvent");
                         
                var bigFinalMap=cmp.get("v.CartMapDataForOffer");
                console.log('bigFinalMap .in tabClickTest. '+JSON.stringify(bigFinalMap));
                servicebasedEve.setParams({
                    "serviceBasedData" : bigFinalMap
                });
                servicebasedEve.fire();
                 }
                else
                {        
                    var prodSeltabClicked=cmp.get('v.afetrClickOfProdSelTab');
                    console.log("shopping cart click directly");                    
                                     
                }
                
                break;
        }
        
        cmp.set('v.isSending',false);
        }
    },
    
   //This function using for moving to Product selection tab
    prodSelTab :  function (cmp, event,helper){
        
          var selPRodTab = cmp.get("v.forSelProdsTab");
         // cmp.set("v.viewcartbutton",false);
          var viewcartbutton = cmp.get("v.viewcartbutton");
          console.log('viewcartbutton.. '+viewcartbutton);
        		if(!viewcartbutton){
            			helper.addToCartForMultipleServices(cmp, event, true);
                       	}
        		else if(viewcartbutton){
                    
                   
                   cmp.set("v.viewcartbutton",false);
                }
         		
        
    },
    
    //not in use
     tabClick1_new: function (cmp, event,helper) {
          var currentTab = cmp.get("v.selTabId");
          
          var selPRodTab = cmp.get("v.forSelProdsTab");
         console.log('selPRodTab.. '+selPRodTab);
         if(cmp.get('v.btnViewCart')==true)
        {
         if(currentTab == '3')
                    {
             			cmp.set("v.selTabId" , '1');  
                    }
            	var toastEvent = $A.get("e.force:showToast");
       			 toastEvent.setParams({
            			 message: 'No Package Selected!',
           				 type: 'failure',
        						});
       				toastEvent.fire();
            
    			}
       		 else{
        		var tab = event.getSource();
        		switch (tab.get('v.id')) {
           		case '3':  
                if (!selPRodTab)
                   {
						console.log("shopping cart click through viewcart"); 
               			 var getPackage= cmp.get('v.getPackage');
                        if(getPackage.length>0)
                		{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                        toastEvent.setParams({
                        title : 'Warning Message',
                        message: 'There are some offers yet to be added',
                        type: 'warning',
                    });
                    toastEvent.fire();
                }
                console.log('inside  ,,in parentcomp controller');
                var servicebasedEve = $A.get("e.com_tcs_telecom:ServiceBasedOfferEvent");
                var bigFinalMap=cmp.get("v.CartMapDataForOffer");
                console.log('bigFinalMap .in tabClickTest. '+JSON.stringify(bigFinalMap));
                servicebasedEve.setParams({
                    "serviceBasedData" : bigFinalMap
                });
                servicebasedEve.fire();
                 }
                else
                { 
                    var prodSeltabClicked=cmp.get('v.afetrClickOfProdSelTab');
                    console.log("shopping cart click directly");                    
                    helper.addToCartForMultipleServices(cmp, event, true);
                }
                
        	}
        	cmp.set('v.isSending',false);
        }
    },
    
    
    
    
    
     getAllAddonData : function (component, event){
         var data = event.getParam("serviceOfferData");
          if (event.getParam("serviceOfferData") != undefined && event.getParam("serviceOfferData") != null){
                                                var bigDataMap= event.getParam("serviceOfferData");
                                                component.set('v.QuoteLineDataMapAfterAddonsAdded',bigDataMap);
        console.log('getAllAddonData Start Parent '+JSON.stringify(bigDataMap));              
             component.set('v.QuoteLineDataMap',bigDataMap); 
       
             var items = component.get('v.QuoteLineDataMap');    
            var selServiceWithOffers = items;
              var offerQtyMap = new Map();                
                   var listofservices=component.get('v.listofservices');
              
              
              
             if (items !=undefined && items !=null)
             {
                   for(var i=0;i<items.length;i++){
                       if(!listofservices.includes(items[i].key)){
                           listofservices.push(items[i].key);
                          
                       }
                       

                       
                   }
                    
             }
            
            
               console.log('listofservices are .. '+JSON.stringify(listofservices));
               component.set('v.listofservices',listofservices); 
         		component.set("v.ServiceAndOffersQuoteLineDataMap" , items);  
                component.set("v.QuoteLineDataMapForAddons" , items);
              console.log('getAllAddonData End ');
         }
       
     },
    //not in use
    tabClick1_New: function (cmp, event,helper) {
        
        cmp.set('v.isSending',true);
        console.log ('callingtabClick view cart functions');        
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case '3':
               
                var getPackage= cmp.get('v.getPackage');
                
                if(getPackage.length>0)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    console.log('toastevent in  parentcomp'+toastEvent);
                    toastEvent.setParams({
                        title : 'Warning Message',
                        message: 'There are some offers yet to be added',
                        type: 'warning',
                    });
                    toastEvent.fire();
                }
                
                console.log('inside  ,,in parentcomp controller');
                helper.addToCartForMultipleServices(cmp, event, true); 

                break;
        }
        
        cmp.set('v.isSending',false);
    },
    
 //   not in use
    tabClickAddon: function (cmp, event){
        if(cmp.get('v.btnViewCart')==true)
        {
           var currentTab = cmp.get("v.selTabId");
        	if(currentTab == '2')
                    {
             			cmp.set("v.selTabId" , '1');  
                    }
            
      		 var toastEvent = $A.get("e.force:showToast");
       		 toastEvent.setParams({
           				 message: 'No Package Selected!',
           				 type: 'failure',
        						});
       		toastEvent.fire();
            
    	}
    },
    
    
    //this function is useing for package selection tab
    tabClickPackage: function (cmp, event) {
        
        var servMap = cmp.get('v.CartMapDataForOffer');
        console.log('JSON.stringify(servMap) tabClickPackage' +JSON.stringify(servMap));
        
        cmp.set('v.isSending',true);

        
        var bigFinalMap=cmp.get("v.ServiceAndOffersQuoteLineDataMap");
        console.log('bigFinalMap is.. '+JSON.stringify(bigFinalMap))
        cmp.set('v.QuoteLineDataMap',bigFinalMap);
        cmp.set('v.isSending',false);
       var updMap = cmp.get('v.QuoteLineDataMap');
        console.log('updMap is.. '+JSON.stringify(updMap));
        console.log('length of updMap..'+updMap.length);
        var viewCartClicked=cmp.get('v.afetrClickOfViewCart');
        console.log('viewCartClicked is.. '+viewCartClicked);
        cmp.set('v.afetrClickOfViewCart',viewCartClicked);
        cmp.set("v.viewcartbutton",false);
    },
    
    
    
    // this function using for deleting offers
    deleteOffer : function (component, event, helper){
         var offerToDisable=event.getParam('offersToDelete');
         var packageName=event.getParam('packageName');
        console.log('packageName-'+packageName);
         var currentService=event.getParam('offerUnderServiceOf');
         var carDataMapOffers = component.get('v.CartMapDataForOffer');
        
        console.log('carDataMapOffers stringify .. '+JSON.stringify(carDataMapOffers));
        var breakouterloop = false;
        for(var i=0;i<carDataMapOffers.length;i++){
            console.log('carDataMapOffers key is.. '+carDataMapOffers[i].key);
            if(carDataMapOffers[i].key == currentService){
                console.log('currentService is.. '+currentService);
               var offers =  carDataMapOffers[i].value;
                 console.log('offers stringify .before delete. '+JSON.stringify(offers));
                for(var j=0;j<offers.length;j++){
                     console.log('offers key is.. '+offers[j].Name);
                    if(offers[j].Name.trim() == packageName){
                         console.log('offerToDisable is.. '+offers[j].Name);
                        offers.splice(j,1);
                        breakouterloop = true;
                        break;
                    }
                    
                } 
                console.log('offers stringify .after delete. '+JSON.stringify(offers)); 
                
            }
            // PMD Fix IfStmtsMustUseBraces
            if(breakouterloop)
            {
                    break;
            }
        }
      
        
        
    },
    
    
    //Currently not in use
    tabClick2:function (cmp, event, helper) {
        
        cmp.set('v.isSending',true);
        var packages= event.getParam("selectedPackagesAfter");
        
        cmp.set('v.getPackage',packages);
        cmp.set('v.isSending',false);
    },
    
    
    //Currently not in use
    showSearchProd: function (cmp, event, helper) {
        var showsearch = event.getParam("showSearch");
        var selectService = event.getParam("selectedService");
        console.log("SelectedService--isss>"+selectService)
        cmp.set('v.showSearch',showsearch);
        cmp.set('v.selectedService',selectService);
         var servMap = cmp.get('v.CartMapDataForOffer');
        console.log('JSON.stringify(servMap) showsearch prod PArent'  +JSON.stringify(servMap));
      
    },
    
    
    //currently not in use
     showSearchaddSiteEvent: function (cmp, event, helper) {
        var showsearch = event.getParam("showSearch");
        var selectService = event.getParam("selectedService");
        console.log("SelectedService--isss>"+selectService)
        cmp.set('v.showSearch',showsearch);
        cmp.set('v.selectedService',selectService);
         var servMap = cmp.get('v.CartMapDataForOffer');
        console.log('JSON.stringify(servMap) showsearch prod PArent'  +JSON.stringify(servMap));
        servMap = [];
          cmp.set('v.CartMapDataForOffer',servMap);
         console.log('JSON.stringify(servMap)after empty PArent showSearchaddSiteEvent'  +JSON.stringify(cmp.get('v.CartMapDataForOffer')));
    },
    
// this function fetching exixting data for revise time
    loadExistingOffers_org : function (component, event, helper) {
        console.log('quote id in init parentcomp_loadExisOffers'+component.get('v.quoteId'));
        var servMap = component.get('v.CartMapDataForOffer');
        console.log('JSON.stringify(servMap) parent init' +JSON.stringify(servMap));
        var serviceAction = component.get("c.getQuoteServiceType");
        serviceAction.setParams({
            'quoteId': component.get('v.quoteId')
        });
        serviceAction.setCallback(this, function(resp) {
            console.log('status is .. '+resp.getState());
            if (resp.getState() == 'SUCCESS'){
                console.log(' resp.getReturnValue()is.. '+ resp.getReturnValue());
              var responseData = JSON.stringify(resp.getReturnValue());
            console.log('responseData is.. '+responseData);
            var data = resp.getReturnValue();
            console.log('QuoteService--iss>'+data[0])
            component.set('v.selectedService',data[0]);
            
            var action = component.get("c.getExistingOffers");
                var neWMap=component.get("v.neWMap");
                neWMap['quoteId']=component.get("v.quoteId");
                neWMap['serviceType']= data[0];
                neWMap['currentVersion']=component.get("v.currentVersion");
            action.setParams({
                'completeMap': {},
                'offerMap' : {},
               // 'quoteId' : component.get('v.quoteId'),
              //  'serviceType' : data[0],
              //  'currentVersion' : component.get('v.currentVersion'),
                'offerListvalue':neWMap
            });
                console.log('offerListvalues...'+JSON.stringify(neWMap));
            action.setCallback(this, function(response){
                console.log('getExistingOffers--response is >'+JSON.stringify(response.getReturnValue()));
                var state = response.getState();
                var resData=response.getReturnValue();
                console.log('resData->'+resData);
                var contsdata = [];
                for ( var key in resData ) 
                {
                    console.log('const key .. '+key);
                    contsdata.push({value:resData[key], key:key});
                }
                console.log('contsdata .after merge. '+JSON.stringify(contsdata));
                
                var offerQtyMap = new Map();
                var keyList = [];
                for(var i=0;i<contsdata.length;i++){
                    keyList.push(contsdata[i].key);
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
                
                console.log('items in setCartData -after modified -itemsNewList>>:'+JSON.stringify(itemsNewList));  
                component.set("v.QuoteLineDataMap" , itemsNewList);
                console.log('keyList '+keyList);
                component.set("v.Cart" , keyList); 
                
                            var compEvent = $A.get("e.com_tcs_telecom:findserviceEvent");
                var showsearch = false;
                compEvent.setParams({
                    "showSearch" : true,
                    "selectedService":data[0]
                });
                compEvent.fire();
                
                
            });
            $A.enqueueAction(action);
            }
            
        });
        $A.enqueueAction(serviceAction);
        helper.getExistingAttributes(component);
       
    },
    
    
    
    // this function fetching exixting data for revise time
    loadExistingOffers : function (component, event, helper) {
        var data;        
        console.log('quote id in init parentcomp_loadExisOffers'+component.get('v.quoteId'));
        var servMap = component.get('v.CartMapDataForOffer');
        console.log('JSON.stringify(servMap) parent init' +JSON.stringify(servMap));
        var serviceAction = component.get("c.getQuoteServiceType");
        serviceAction.setParams({
            'quoteId': component.get('v.quoteId')
        });
        serviceAction.setCallback(this, function(resp) {
            console.log('status is .. '+resp.getState());
            if (resp.getState() == 'SUCCESS'){
                console.log(' resp.getReturnValue()is.. '+ resp.getReturnValue());
              var responseData = JSON.stringify(resp.getReturnValue());
            console.log('responseData is.. '+responseData);
            data = resp.getReturnValue();
            console.log('QuoteService--iss>'+data[0]);
            component.set('v.selectedService',data[0]);
          /*  var servicename;    
            if(resp.getReturnValue().length > 0){
                servicename = data[0];
              }
                else 
                {
                    servicename='ANY';
                   
                }
                component.set('v.selectedService',servicename);*/
            }             
            
                 console.log('inside condition--iss>'+data[0]);
            var compEvent = $A.get("e.com_tcs_telecom:findserviceEvent");
                var showsearch = false;
            	var quoteId = component.get('v.quoteId');
                compEvent.setParams({
                    "showSearch" : true,
                    //"selectedService":servicename
                    "selectedService":data[0]
                    
                }) ;
                compEvent.fire(); 
                 
           
        });
        $A.enqueueAction(serviceAction);
        helper.getExistingAttributes(component);
       
    },
    
  
// this function is use for loading existing data in shoping cart 
    setStoredData : function(component, event, helper) {
        var items = event.getParam("bigconMapUpdate");
        console.log('items in setCartData parentcomp-->>:'+JSON.stringify(items));
        if(items != undefined) {
        if(items == 0){
            var currentTab = component.get("v.selTabId"); 
            console.log("currentTab.conts. "+currentTab);
            if(currentTab == '3'){ 
                component.set("v.selTabId" , '1');
            }
        }
        else{
            var itemsNewListServices = [];
            for(var i=0;i<items.length;i++){
                var contsdata=items[i].value;
                if(contsdata!=undefined){
                    var pkgAndProdCombo=helper.setQuantityToBigMap(component, event,contsdata);
                itemsNewListServices.push({value:pkgAndProdCombo, key:items[i].key})
                }
                
            }
            console.log('items in setCartData after modified itemsNewList in controller:'+JSON.stringify(itemsNewListServices));  
             console.log('items in quoteLinedatamap in controller:'+JSON.stringify(component.get('v.QuoteLineDataMap')));  
            var currentTab = component.get("v.selTabId");
            console.log('currentTab is.. '+currentTab);
            component.set("v.ServiceAndOffersQuoteLineDataMap",itemsNewListServices);
             component.set("v.existOfferMap" , items);
        
        }
        }
            
    },
    
    
    //this function for fetching offer to Addon page 
    offerToAddonPage : function(component, event, helper) {
        var storedata = event.getParam("shoppingCartData");
        var selAttr = event.getParam("selectedAttributes");
        console.log('storedata ... '+JSON.stringify(storedata));
        component.set("v.QuoteLineDataMap", storedata);
        component.set("v.existAttrData", selAttr);
        component.set("v.attr",selAttr);
    },
    
    
    //currently not in use
    loadEventData_Oct12 :  function(component, event, helper) {
        var offervalue= event.getParam("selectedOffer");
        var selAttr = event.getParam("selectedAttributes");
        var items = [];
        console.log('offervalue at  **   ..   '+JSON.stringify(offervalue)+'attr:'+JSON.stringify(selAttr));
        for ( var key in offervalue ) 
        {
            console.log('const key .. '+key);
            items.push({value:offervalue[key], key:key});
        }
        component.set("v.existAttrData", selAttr);
        component.set("v.attr",selAttr);
        
        
        console.log('items in offervalue parentcompctrlr -->>:'+JSON.stringify(items));
        component.set("v.QuoteLineDataMap",items);
        
        var currentTab = component.get("v.selTabId");
        console.log("currentTab.conts. "+currentTab);
        if(currentTab == '1'){
            
            component.set("v.selTabId" , '2');   
            
        }
        
    },
    
    
    //this function for fetching addon data 
    loadEventData :  function(component, event, helper) {
        
        var selAttr = event.getParam("selectedAttributes");
        var serviceOfferData = event.getParam("serviceOfferData");
        
        component.set("v.existAttrData", selAttr);
        component.set("v.attr",selAttr);
        var currentTab = component.get("v.selTabId");
        console.log("currentTab.conts. "+currentTab);
        var addonData= component.get('v.QuoteLineDataMapForAddons');
         console.log("QuoteLineDataMapForAddons_ParentComp "+JSON.stringify(addonData));
        if(currentTab == '1'){
            component.set("v.QuoteLineDataMap" , serviceOfferData);
            component.set("v.selTabId" , '2');   
            
        }
        
    },
    
    
    
    
    
    //this function for fetching addon data to cart data
    loadEventDataAddonSToCart :  function(component, event, helper) {
        var currentTab = component.get("v.selTabId");
        if(currentTab == '2'){
            component.set("v.selTabId" , '3');   
        }
    },
    
    
    //this function for fetching map for selected addons
    setAddonsMap : function(component, event, helper) {
        var addonsMap = event.getParam("addonsMap");
        component.set("v.addonsMap" , addonsMap);   
    },
    /*selected offers with service */
    ServiceOffer : function(component, event, helper) {
        
        var CartMapData = event.getParam("CartMapData"); 
        component.set("v.ServiceOfferMap" , CartMapData);   
        component.set("v.CartMapData" , CartMapData);
        var CartMapDataForOffer = event.getParam("CartMapDataForOffer"); 
        component.set("v.CartMapDataForOffer" , CartMapDataForOffer);   
        console.log(' selected offers with service -->>:'+JSON.stringify(component.get('v.ServiceOfferMap')));
        console.log(' selected offers with service -CartMapDataForOffer->>:'+JSON.stringify(component.get('v.CartMapDataForOffer')));
         for(var i=0;i<CartMapDataForOffer.length;i++){
            var servName = CartMapDataForOffer[i].key;
            var pkgList =  CartMapDataForOffer[i].value;
            var pkgname =  pkgList[0].Name;
            var defSelPkg = pkgname+'#'+servName;
            console.log('defSelPkg  ..  '+defSelPkg);
            component.set('v.defSelPkg',defSelPkg);
            break;
        }
    },
    
    
    
    //this function using for next button  to fetching next page data
    next : function(component, event, helper) {
       
        component.set('v.getPackage',[]);
        component.set("v.isTabHiddenForAddon",'slds-show');
        component.set("v.isTabHiddenForCart",'slds-show');
        var items = event.getParam("cartData");
        //  var eventData = event.getParam("Attribute");
        console.log("Map.conts. "+JSON.stringify(items) + 'items.length > '+items.length);
        if(items == 0){
            
            var currentTab = component.get("v.selTabId"); 
            console.log("currentTab.conts. "+currentTab);
            if(currentTab == '3'){ 
                component.set("v.selTabId" , '1');
                //
            }
        }else{
            
            console.log('conts at  ** >>  ..   '+JSON.stringify(items));
            
            var sleAtr = event.getParam("selectedAttributes");     
            console.log('items in setCartData -->>:'+JSON.stringify(items)+'sleAtr'+sleAtr);
            
            component.set("v.QuoteLineDataMap",items);
            component.set("v.attr",sleAtr);
            component.set("v.existAttrData", sleAtr);
            var emptyList = [];
            component.set("v.overridenDataList",emptyList);
            var listinPArentComp=component.get("v.overridenDataList")
            console.log('listinPArentComp. '+listinPArentComp);
       
            var contsdata = component.get("v.QuoteLineDataMap");
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
            
            console.log('items in setCartData -after modified -itemsNewList>>:'+JSON.stringify(itemsNewList));  
            component.set("v.QuoteLineDataMap" , itemsNewList);   
            
          
        }
        
    },
    
    
   // currently not in use
    cartEventData_17nov : function(component, event, helper) {
        component.set('v.getPackage',[]);
        component.set("v.isTabHiddenForAddon",'slds-show');
        component.set("v.isTabHiddenForCart",'slds-show');
        var items = event.getParam("serviceOfferData");
        var afetrClickOfViewCart = event.getParam("afetrClickOfViewCart");
        console.log('afetrClickOfViewCart is.carteventdata. '+afetrClickOfViewCart);
        component.set('v.afetrClickOfViewCart',afetrClickOfViewCart);
        if(items == 0){
            var currentTab = component.get("v.selTabId"); 
            console.log("currentTab.conts. "+currentTab);
            if(currentTab == '3'){ 
                component.set("v.selTabId" , '1');
            }
        }else if(items!=undefined){
            console.log('items for multipleservice  ..   '+JSON.stringify(items));
            var sleAtr = event.getParam("selectedAttributes");     
            component.set("v.attr",sleAtr);
            component.set("v.existAttrData", sleAtr);
            //added
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
            var contsdata= items[0].value;

          
            console.log('items in setCartData after modified items:'+JSON.stringify(items));  
            component.set("v.QuoteLineDataMap" , items);   
            component.set("v.ServiceAndOffersQuoteLineDataMap" , items);  
            component.set("v.QuoteLineDataMapForAddons" , items);
        }
        var currentTab = component.get("v.selTabId");
        console.log('currentTab.>>. '+currentTab + 'afetrClickOfViewCart. '+afetrClickOfViewCart);
        if(currentTab == '1' || currentTab == '2')
        {
                component.set("v.viewcartbutton",true);
            	component.set("v.selTabId" , '3');   
        }
        
      	else if(currentTab == '3'){
          
        }
        component.set("v.viewcartbutton",true);
        
        
    },
    
    
    // this function using for fetching data from package selection to shopping cart
     cartEventData : function(component, event, helper) {
        component.set('v.getPackage',[]);
        component.set("v.isTabHiddenForAddon",'slds-show');
        component.set("v.isTabHiddenForCart",'slds-show');
        var items = event.getParam("serviceOfferData");
        var afetrClickOfViewCart = event.getParam("afetrClickOfViewCart");
        console.log('afetrClickOfViewCart is.carteventdata. '+afetrClickOfViewCart);
        component.set('v.afetrClickOfViewCart',afetrClickOfViewCart);
		if(items == 0){
            var currentTab = component.get("v.selTabId"); 
            console.log("currentTab.conts. "+currentTab);
            if(currentTab == '3'){ 
                component.set("v.selTabId" , '1');
            }
        }else if(items!=undefined){
            console.log('items for multipleservice  ..   '+JSON.stringify(items));
            var sleAtr = event.getParam("selectedAttributes");     
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
            console.log('items[0].key.. '+items[0].key+'listofservices'+listofservices);
            component.set('v.listofservices',listofservices);
             console.log('v.listofservices..797'+component.get('v.listofservices'));
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
            
            
            //
             var currentTab = component.get("v.selTabId");
        console.log('currentTab.>>. '+currentTab + 'afetrClickOfViewCart. '+afetrClickOfViewCart);
        
        
        if(currentTab == '1' || currentTab == '2')
        {
                component.set("v.viewcartbutton",true);
            
            	component.set("v.selTabId" , '3');   
        }
      	else if(currentTab == '3'){
           
        }
       
        component.set("v.viewcartbutton",true);
           
        }
        component.set('v.parentcompSpinner',false);
    },
    
    
   // this function using for going back to  package selection page 
    
    back : function(component, event, helper) {
        // get the current selected tab value  
        var currentTab = component.get("v.selTabId");
        
        if(currentTab == '3'){
            component.set("v.selTabId" , '1');     
        } 
    },
    
    
    //this function we are using for going back to addon selection page
    backCartToAddons : function(component, event, helper) {
        // get the current selected tab value  
        var currentTab = component.get("v.selTabId");
        
        if(currentTab == '3'){
            
            component.set("v.selTabId" , '2');     
        } 
    },
    
    //this function we are using for going back from addon page to package selection page
    
    backAddonsToOffer : function(component, event, helper) {
        // get the current selected tab value  
        var currentTab = component.get("v.selTabId");
        var selAttr = event.getParam("selectedAttributes");
        component.set("v.existAttrData", selAttr);
        component.set("v.attr",selAttr);
        if(currentTab == '2'){
            component.set("v.selTabId" , '1');     
        } 
    },

    
    
    
    
    
    // this function using for showing user success toast msg after submit
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            //title : 'Success',           
          
            
            //message: 'The cart is submitted!',
            type: 'success',
        });
        toastEvent.fire();
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": "0Q07F000000goTASAY",
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    
    
    //currently not in use
    setAttributeValue:function(component,event)
    {
        console.log("inside setAttributeValye  ...");
        var attrvalue= event.getParam("Attribute");
        console.log('Attribute is'+JSON.stringify(attrvalue));
        var attrList =  component.get("v.attr");
        var attrListNew = [];
        var items = [];
        for ( var key in attrvalue ) {
            
            attrListNew.push({value:attrvalue[key].attributes, key:attrvalue[key].product});
            
        }
        console.log('attrListNew PArentcomp Attribute is'+JSON.stringify(attrListNew));
        component.set("v.attr",attrListNew);
        
        var currentTab = component.get("v.selTabId");
        console.log('currenttab after..'+currentTab);
    },
    
    
    //this function use for Showing toast msg after adding in to cart
    addtoCartToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            //title : 'Success',
           
             //message: 'Items added to cart successfully!',
            type: 'success',
        });
        toastEvent.fire();
    },
    
    
    
    //currently not in use
         Vcartbtnvisible: function(component, event, helper)
    {
         var Paramstatus= event.getParam("disablestatus");
         component.set("v.btnViewCart", Paramstatus);
        
    },
    
    
    
    //not in use
    tabClickNew: function (cmp, event,helper) {
          var currentTab = cmp.get("v.selTabId");
       
         if(cmp.get('v.btnViewCart')==true)
        {
         
        	if(currentTab == '3')
                    {
             			cmp.set("v.selTabId" , '1');  
                    }
            
      		 var toastEvent = $A.get("e.force:showToast");
       		 toastEvent.setParams({
            //title : 'Success',
           				 message: 'No Package Selected!',
           				 type: 'failure',
        						});
       		toastEvent.fire();
            
    	}
        else{
        
        console.log ('callingtabClick view cart functions');        
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case '3':  
                var afetrClickOfViewCart = cmp.get("v.afetrClickOfViewCart");  
                console.log ('afetrClickOfViewCart in parentcomp'+afetrClickOfViewCart);  
               
                   if (afetrClickOfViewCart == true)
                   {
                      
                       	console.log("shopping cart click through viewcart"); 
               			 var getPackage= cmp.get('v.getPackage');
                        if(getPackage.length>0)
                		{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                        toastEvent.setParams({
                        title : 'Warning Message',
                        message: 'There are some offers yet to be added',
                        type: 'warning',
                    });
                    toastEvent.fire();
                }
                
                console.log('inside  ,,in parentcomp controller');
                var servicebasedEve= $A.get("e.com_tcs_telecom:ServiceBasedOfferEvent");
                var bigFinalMap=cmp.get("v.CartMapDataForOffer");
                console.log('bigFinalMap .in tabClickTest. '+JSON.stringify(bigFinalMap));
                servicebasedEve.setParams({
                    "serviceBasedData" : bigFinalMap
                });
                servicebasedEve.fire();
                 }
                else
                {        
                    alert('else...');
                    var prodSeltabClicked=cmp.get('v.afetrClickOfProdSelTab');
                    console.log("shopping cart click directly");       
                                
                }
                
                break;
        }
        
        cmp.set('v.isSending',false);
        }
    },
    
    
    //this function use for fetching selected packages
    addToCartForMultipleServices : function(component,event,helper){
        helper.addToCartForMultipleServices(component,event,true);
    },

createRecord : function(component, event, helper){
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact"
        });
        createRecordEvent.fire();
    },     
 associateAddons : function(component,event,helper){
         var currentTab = component.get("v.selTabId");
         console.log('currentTab is.. '+currentTab);
          var selectedOffers=component.get("v.CartMapDataForOffer"); 
          //var selectedOffers=component.get("v.QuoteLineDataMap");
         console.log('selectedOffers len addon.. '+JSON.stringify(selectedOffers));
         // && currentTab == '1'
        // var assocAddon=component.get('v.fromAssocAddon');
         //console.log('in assocAddon ' +assocAddon);
         if(selectedOffers.length>0){
             
             //helper.addToCartForMultipleServices(component,event,helper,selectedOffers);
             component.set('v.displayAddons',true);
             //component.set('v.fromAssocAddon',true);
             component.set("v.selTabId" , '2');  
         }else if(selectedOffers.length>0){
             component.set('v.fromAssocAddon',false);
         }
         else if(selectedOffers.length == 0){
              
              		var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": 'please select atlease one offer to assciate addons!!',
                        "type": "error"
                    });
                    toastEvent.fire();
         	}
         
    	},
addAddonsToCartByTabClick : function(component,event,helper){
        
         	var viewcartbutton = component.get("v.viewcartbutton");
          	console.log('viewcartbutton.. '+viewcartbutton);
        	var selectedOffers=component.get('v.CartMapDataForOffer');
    		console.log('inside addAddonsToCartByTabClick' + JSON.stringify(selectedOffers));
        	if(!viewcartbutton){
            			helper.addToCartForMultipleServices(component,event,helper,selectedOffers);
                       	}
        		else if(viewcartbutton){
                    component.set("v.viewcartbutton",false);
                    
                }
        
       
 
	},
    
    getProductsAndAddonData : function(component,event,helper){
         var bigDataMap= event.getParam("CartMapDataForOffer");
         var addoncartDataMap=event.getParam("addoncartDataMap");
        component.set('v.CartMapDataForOffer',bigDataMap);
    },
    
    addAddonsToCartNew : function(component,event,helper){
            var selectedOffers=event.getParam('CartMapDataForOffer');
            console.log('totle data .. '+JSON.stringify(selectedOffers));
        	component.set("v.selTabId" , '3');  
    },
    
    addAddonsToCart : function(component,event,helper){
        
         var currentTab = component.get("v.selTabId");
         console.log('currentTab is.. '+currentTab);
          var selectedOffers=event.getParam('CartMapDataForOffer');
          var afetrClickOfViewCart=component.get('v.afetrClickOfViewCart');
        
        console.log('selectedOffers is ... '+selectedOffers);
          component.set('v.CartMapDataForOffer',selectedOffers); 
         console.log('selectedOffers len .. '+JSON.stringify(selectedOffers));
        
         if(selectedOffers.length>0){
             
             component.set('v.addToCartInvoked',true);
             helper.addToCartForMultipleServices(component,event,helper,selectedOffers);
			}else if(selectedOffers.length == 0){
              		var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": 'please select atlease one offer to assciate addons',
                        "type": "error"
                    });
                    toastEvent.fire();
         	}
         
        
        
    },
    
    
    getAlreadySelectedOffers : function(component,event,helper){
       var existOfferMap = event.getParam("existOfferMap");
        console.log('existOfferMap.. '+JSON.stringify(existOfferMap));
        
	},
    
    getAddonProdsMap : function(component, event, helper) {
         
        var addonProductsMapData = event.getParam("addonProductsMap");     
        console.log('getAddonProdsMap event is fired is1.. '+JSON.stringify(addonProductsMapData));
        component.set('v.addonProductsMap',addonProductsMapData);
         console.log('getAddonProdsMap event is fired is.. '+JSON.stringify(component.get('v.addonProductsMap')));
        var selPackageOfferIdFromAddonPage = event.getParam("selPackageOfferIdFromAddonPage");
        var selServiceFromAddonPage = event.getParam("selServiceFromAddonPage");
        var selPackageFromAddonPage = event.getParam("selPackageFromAddonPage");
        var addoncartDataMap = event.getParam("addoncartDataMap");
        console.log('addoncartDataMap is.. '+JSON.stringify(addoncartDataMap));
        component.set('v.addoncartDataMap',addoncartDataMap);
        component.set('v.selServiceforAddAddon',selServiceFromAddonPage);
        component.set('v.selPackageforAddAddon',selPackageFromAddonPage);
        component.set('v.selProdSpecIdforAddAddon',selPackageOfferIdFromAddonPage);
        
        component.set('v.addonSelect',true);
	},
    
    deleteAddonsFromPkg : function(component, event, helper){
        var existDataMap = component.get('v.existOfferMap');
        //console.log('existDataMap  json .before. '+JSON.stringify(existDataMap));
        var selectServName = event.getParam('selServiceName');
 		var packageName = event.getParam('packageNameToDelete');
 		var addonproductOfferingId = event.getParam('productIdToDelete');  
       // component.set('v.',addonproductOfferingId);
        console.log('selectServName is.. '+selectServName + 'pkgname.' +packageName+
                   ' ---  '+addonproductOfferingId);
        component.set('v.selectServiceName',selectServName);
        var breakflag = false;
        var addonsTobeRemoveList = [];
        addonsTobeRemoveList.push({value:addonproductOfferingId,key:selectServName+'#'+packageName});
        console.log('addonsTobeRemoveList.. '+JSON.stringify(addonsTobeRemoveList));
        component.set('v.addonsToBeRemoveList',addonsTobeRemoveList);
        for(var i=0;i<existDataMap.length;i++){
            console.log('key is.. '+existDataMap[i].key);
            if(existDataMap[i].key == selectServName){
                var pkgList=existDataMap[i].value;
                
                for(var j=0;j<pkgList.length;j++){
                    console.log('pkgList key .. '+pkgList[j].key);
                    if(pkgList[j].key == packageName){
                        var prodList = pkgList[j].value;
                        for(var k=0;k<prodList.length;k++){
                            console.log('prodList productOfferingId.. '+prodList[k].productOfferingId);
                            if(prodList[k].productOfferingId == addonproductOfferingId){
                                prodList.splice(k,1);
                                breakflag = true;
                                break;
                            }
                        }
                    }
                    if(breakflag){
                        break;
                    }
                }
                if(breakflag){
                        break;
                    }
            }
        }
        //console.log('existDataMap  json .after. '+JSON.stringify(existDataMap));
      
    },
    //this function we are using for going back to addon selection page
    backCartToAddons : function(component, event, helper) {
        // get the current selected tab value  
        var currentTab = component.get("v.selTabId");
        
        if(currentTab == '3'){
            
            component.set("v.selTabId" , '2');     
        } 
    },
    
    //this function we are using for going back from addon page to package selection page
    
    backAddonsToOffer : function(component, event, helper) {
        // get the current selected tab value  
        var currentTab = component.get("v.selTabId");
        var selAttr = event.getParam("selectedAttributes");
        component.set("v.existAttrData", selAttr);
        component.set("v.attr",selAttr);
        if(currentTab == '2'){
            component.set("v.selTabId" , '1');     
        } 
    }

    
    
})