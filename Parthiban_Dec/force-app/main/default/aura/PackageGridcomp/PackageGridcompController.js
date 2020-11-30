({
    
    /* for searching packages */
    searchFn:function(component,event,helper){
            helper.searchProduct(component);
        
    },
    
    associateAddons : function(component,event,helper){
        //component.set('v.setAddonFlag',true);
    },
    
    /* for checking key event for search */
    checkKey:function(component,event,helper){
         if(event.getParams().keyCode===13)
          {
            helper.searchProduct(component);
        }
    },
    
    /* for clearing search value */
    clearFn:function(component,event,helper){
        component.set("v.searchKey","");
        helper.searchProduct(component);
    },
    
    /* retrieve all packages against to serviceType,when we click on serviceType*/
    setSelectedService:function(component,event,helper){
        var showsearch = event.getParam("showSearch");
        var srvcMap = event.getParam("selectedServiceMap");
        console.log('srvcMap--->>>'+srvcMap);
        console.log("showsearch---->"+showsearch);
        var selectService = event.getParam("selectedService");
        console.log("SelectedServicepackageGrid1 event fired-->"+selectService);
        component.set('v.showSearch',showsearch);
        component.set('v.selectedService',selectService); 
        component.set('v.isSending',true);  
        component.set('v.selectedSrvcMap',srvcMap);
        var emptyList= {}; 
        var existDataservicewithoffergridmap = component.get('v.servicewithoffergridmap');
         console.log('existDataservicewithoffergridmap.selservice method pkgGrid. '+JSON.stringify(existDataservicewithoffergridmap));
       helper.getPackageJSON(component);
    },
    
    
     setSelectedServiceForFirstTimeFeasibility:function(component,event,helper){
        
        var selectService = event.getParam("selectedService");
        var selectedSiteId = event.getParam("selectedSiteId");
        var selectedCity   = event.getParam("selectedCity");
        var selectedSitetype =event.getParam("selectedSitetype");
         var sitetype="Sitetype";
         component.set('v.isSending',true); 
        console.log("SelectedServicepackageGrid1 event fired-->"+selectService);
          console.log("SelectedServicepackageGrid1 event fired-->"+selectedCity);
          console.log("SelectedSite Id-->"+selectedSiteId);
        component.set('v.selectedSiteId',selectedSiteId);          
        component.set('v.selectedService',selectService); 
        component.set('v.selectedCity',selectedCity);
         console.log("SelectedSite Id-->"+component.get('v.selectedSiteId'));
         component.set('v.selectedSitetype',sitetype);
         console.log("selectedSitetype-->"+component.get('v.selectedSitetype'));
         helper.getPackageJSON(component);
        //helper.getPackageJSON(component,selectedSiteId);
        //helper.getExistingAttributes(component);
        //component.set('v.isSending',false); 
    },
    
    
   /* retrieve all packages against to first serviceType*/
     setSelectedServiceForFirstTime:function(component,event,helper){
        var showsearch = event.getParam("showSearch");
         var requestType = event.getParam("requestType");
        console.log("showsearch---->"+showsearch + '>requestType< ' +requestType);
         component.set('v.requestType',requestType);
        var selectService = event.getParam("selectedService");
        console.log("SelectedServicepackageGrid1 event fired-->"+selectService);
        component.set('v.showSearch',showsearch);
        component.set('v.selectedService',selectService); 
        component.set('v.isSending',true); 
     
        var emptyList= []; 
        component.set("v.servicewithoffergridmap",emptyList);
        var existDataservicewithoffergridmap = component.get('v.servicewithoffergridmap');
        console.log('setSelectedServiceForFirstTime. method pkgGrid.after empty '+JSON.stringify(existDataservicewithoffergridmap));
         var emptyList= []; 
        component.set("v.servicewithoffergridmap",emptyList);
         component.set("v.ServiceOfferMap",emptyList);
         if (selectService != 'VPN'   )
             {
                 if (selectService != 'LEASEDLINE' )
             {
            helper.getPackageJSON(component);
        	helper.getExistingAttributes(component);             
             }
         }
         
         if (selectService == 'VPN' || selectService == 'LEASEDLINE')
    	{           
              component.set('v.isSending',false);         	
        }
     	
       
             
        
    },

    
    /* for setting new and existing attributes */
	setAttributeValue:function(component,event)
    {
        console.log("inside setAttributeValye  ...");
        var attrvalue= event.getParam("Attribute");
        console.log('Attribute in PKGGRIDCOMP New attributeEvent'+JSON.stringify(attrvalue));
        var attrList =  component.get("v.attr");
        var attrListNew = [];
        var items = [];
        for ( var key in attrvalue ) {
            attrListNew.push({value:attrvalue[key].attributes, key:attrvalue[key].product});
        }
       
        component.set('v.existAttrData',attrListNew);
        component.set('v.attr',attrListNew);
        console.log('Attribute in PKGGRIDCOMP New1 attributeEvent'+JSON.stringify(attrListNew));
        component.set("v.isOpen", false);
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
        
        
        
    },
  
    
    
    /* for setting grid cloumns of packagegrid */
    doinit : function(component, event, helper) {
        var existData = component.get('v.existOfferMap');
        console.log('existData i stringify .doinit. '+JSON.stringify(existData));
         var existDataservicewithoffergridmap = component.get('v.servicewithoffergridmap');
         console.log('existDataservicewithoffergridmap i stringify .doinit. '+JSON.stringify(existDataservicewithoffergridmap));
        component.set('v.gridColumns', [
            {label: 'Product Name', fieldName: 'Name', type: 'text'},
            {label: 'Currency', fieldName: 'currency', type: 'text'},
            {label: 'NRC', fieldName: 'NRC', type: 'text'},
            {label: 'RC', fieldName: 'RC', type: 'text'},
            
        ]);
            component.set('v.CartMap', []);
        component.set('v.headerRow', {'isHeader' : 'true', 'displayName' : 'NAME', 'ProductType' : 'TYPE', 'currency' : 'CURRENCY', 'NRC' : 'NRC', 'RC' : 'RC'});
        component.set('v.demodataProducts', []);
        component.set('v.democolumnsProduct', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'ServiceType',    fieldName: 'ServiceType', type: 'text'},
            {label: 'Currency', fieldName: 'currency', type: 'text'},
            {label: 'NRC', fieldName: 'NRC', type: 'number' },
            {label: 'RC',    fieldName: 'RC', type: 'number'},
            
        ]);
     
            
             
            },
            
            
     
            
           
    
    
     
    
       
         
       
     
    /* fetching previous pages data */
    previous: function (component, event, helper) {
        
        helper.previous(component, event);
    },
    
      /* fetching previous pages data */
    next: function (component, event, helper) {
            
        helper.next(component, event);
    },    
    
    
  callGetPackageDetails : function (component, event, helper) {
            
            helper.getPkgDetails(component, event);
           
            
    },     
    
   changeCart : function(component, event, helper) {
            var offer = event.getParam("selectedOffer");
            console.log('offer b442:'+JSON.stringify(offer));            
            var dataAction2 = component.get("c.getPkgDetailForOffer");
            dataAction2.setParams({
            'addedOffer': JSON.stringify(offer),
            'calledFromTest' : false
            });
            dataAction2.setCallback(this, function(response) {
            //  var offer;
            var state = response.getState();
            if (state === "SUCCESS") {
            console.log('response.getReturnValue()2'+response.getReturnValue());
            console.log('offer b42:'+JSON.stringify(offer));
             offer = JSON.parse(response.getReturnValue());
            component.set('v.offerFromPkgDetails', response.getReturnValue()); 
            
            }
            });
            $A.enqueueAction(dataAction2);
            //  if(component.get('v.offerFromPkgDetails') != undefined && component.get('v.offerFromPkgDetails') != ''){
            // offer = JSON.parse(component.get('v.offerFromPkgDetails'));}
            
            console.log('offer after new2**'+offer);
            
            var selectionAfter=component.get('v.selectPackageList');
            
            selectionAfter.push(offer.ProductSpec);
            component.set('v.selectPackageList',selectionAfter)
            
            var tabEvent = $A.get("e.com_tcs_telecom:TabEvent");       
            
            tabEvent.setParams({
            "selectedPackagesAfter" : component.get('v.selectPackageList')
            });
            tabEvent.fire();
            
            var offers = [];
                      console.log('offers953 '+offers);
        var multicart = component.get('v.ServiceOfferMap');
        var currentService =  component.get("v.selectedService");
        console.log('currentService'+currentService);
        
        for(var i = 0; i < multicart.length; i++) {
            if(multicart[i].key == currentService) {
                offers = multicart[i].value;
                break;
            }
        }
        
        
        var index = offers.indexOf(offer.Name);            
        var demodataProducts = component.get("v.demodataProducts");     
        if(index != -1 ) {
            
            offers.splice(index, 1);
            for(var i = 0; i < demodataProducts.length; i++) {
                
                if(demodataProducts[i].Name == offer.Name) {   
                    demodataProducts.splice(i, 1);
                    break;
                }
            }
            
        } else { 
            offers.push(offer.ProductSpec);
            var pkgObj = {};
            pkgObj['Name'] = offer.Name ;
            pkgObj['ServiceType'] = currentService;
            pkgObj['Currency'] = offer.currency ;
            pkgObj['NRC'] = offer.NRC ;
            pkgObj['RC'] = offer.RC ;
            
            demodataProducts.push(pkgObj);
            
        }
        component.set("v.demodataProducts", demodataProducts);
        
        console.log('offers '+offers);
        component.set('v.Cart', offers);
        
        var cartDataMap=[];
        var cartDataMap=component.get('v.ServiceOfferMap');
        var Services= component.get("v.selectedService");
        console.log('Services json stringify..before987 '+JSON.stringify(Services));
        console.log('cartDataMap json stringify..before986 '+JSON.stringify(cartDataMap));
        if(cartDataMap!= null || cartDataMap!=undefined || cartDataMap!=[] || cartDataMap.length>=0)
        {                      
            for (var Mulser in cartDataMap)
            {              
                if(cartDataMap[Mulser].key == Services)
                {              		 
                    cartDataMap.splice(Mulser, 1);
                    
                }
            }
        }
        console.log('cartDataMap json stringify..after '+JSON.stringify(cartDataMap));
        
        var cartDataMap=component.get('v.ServiceOfferMap');
        console.log('cartDataMap:'+JSON.stringify(cartDataMap));
        
        var offersList = [];
        console.log('offersList:'+JSON.stringify(offersList));
        var offersMap = component.get('v.CartMap');
        console.log('offersMap:'+JSON.stringify(offersMap));
        var selService = component.get("v.selectedService");
        if(offersMap== null || offersMap==undefined || offersMap==[] || offersMap.length<=0) {
            
            console.log('in if');
            offersList.push(offer.Name.trim());
            cartDataMap.push({value:offersList, key:selService});            
            
        } else {
            console.log('in else');
            var tmpFlag = false;
            for (var a in offersMap) {
                console.log('selService'+selService+'offersMap[a].key'+offersMap[a].key+'offersMap[a].value'+offersMap[a].value);
                if(offersMap[a].key == selService) {
                    offersList = offersMap[a].value;
                    console.log('in offersMap[a].key == selService '+offersList);
                    
                    if(!offersList.includes(offer.Name.trim())) 
                    {                          
                        offersList.push(offer.Name.trim());
                    }
                    tmpFlag = true;
                    cartDataMap.push({value:offersList, key:selService});
                    
                    break;   
                }
            }
            if(!tmpFlag) 
            {
                console.log('in if !tmpFlag');
                offersList.push(offer.Name.trim());
                cartDataMap.push({value:offersList, key:selService});
                
            }
            console.log('cartDataMap with service'+ JSON.stringify(cartDataMap));
        }
        component.set('v.CartMap', cartDataMap);     
        
        var cartDataMapForOffer=component.get('v.servicewithoffergridmap');
        console.log(' offer ................>'+JSON.stringify(offer));
        console.log('cartDataMapForOffer... '+JSON.stringify(cartDataMapForOffer));
        
        var offersListForOffer = [];
        var offerSecondTime = event.getParam("selectedOffer");
        var dataAction1 = component.get("c.getPkgDetailForOffer");
            dataAction1.setParams({
            'addedOffer': JSON.stringify(offerSecondTime),
             'calledFromTest' : false
            });
            dataAction1.setCallback(this, function(response1) {
              //var offerSecondTime;
            var state1 = response1.getState();
            if (state1 === "SUCCESS") {
            console.log('response1.getReturnValue()1'+response1.getReturnValue());
            console.log('offer b41:'+JSON.stringify(offerSecondTime));
             offerSecondTime = JSON.parse(response1.getReturnValue());
            component.set('v.offerFromPkgDetails', response1.getReturnValue()); 
            
            }
          ////  });
          ////  $A.enqueueAction(dataAction1);
        //if(component.get('v.offerFromPkgDetails') != undefined && component.get('v.offerFromPkgDetails') != ''){
        //   offer = JSON.parse(component.get('v.offerFromPkgDetails'));}
        console.log('offer at second'+JSON.stringify(offerSecondTime));
        if(cartDataMapForOffer== null || cartDataMapForOffer==undefined || cartDataMapForOffer==[] || cartDataMapForOffer.length<=0) {
            
            console.log('in if cartDataMapForOffer');
            offersListForOffer.push(offerSecondTime);
            cartDataMapForOffer.push({value:offersListForOffer, key:selService});            
            
            
        } else {
            console.log('selService is.. '+selService);
            console.log('in else cartDataMapForOffer');
            var tmpFlag = false;
            for (var a in cartDataMapForOffer) {
                console.log('selService'+selService+'cartDataMapForOffer[a].key'+cartDataMapForOffer[a].key+'cartDataMapForOffer[a].value'+cartDataMapForOffer[a].value);
                if(cartDataMapForOffer[a].key == selService) {
                    offersListForOffer = cartDataMapForOffer[a].value;
                    console.log('in offersMap[a].key == selService '+offersListForOffer);
                    if(!offersListForOffer.includes(offerSecondTime)) 
                    {                          
                        offersListForOffer.push(offerSecondTime);
                    }
                    tmpFlag = true;
                    break;   
                }
            }
            if(!tmpFlag) 
            {
                console.log('in if !tmpFlag');
                offersListForOffer.push(offerSecondTime);
                cartDataMapForOffer.push({value:offersListForOffer, key:selService});
            }
            
        }
        console.log('***cardatamap offer after select offer***'+ JSON.stringify(cartDataMapForOffer));
        component.set('v.CartMapDataForOffer',cartDataMapForOffer);
        
        var updateCartMapEvent = $A.get("e.com_tcs_telecom:CartMapEvent");
        updateCartMapEvent.setParams({
            "CartMapData" : cartDataMap,
            "CartMapDataForOffer": cartDataMapForOffer
        });
        updateCartMapEvent.fire();
                 });
            $A.enqueueAction(dataAction1);
         helper.buildQuoteLine(component);
        //});
        //   $A.enqueueAction(dataAction2);
    },  
   
            
  /*  changeCart_workingbkp_don't_remove: function(component, event, helper) {

        var offer = event.getParam("selectedOffer");

        var selectionAfter=component.get('v.selectPackageList');

        selectionAfter.push(offer.ProductSpec);
        component.set('v.selectPackageList',selectionAfter)

        var tabEvent = $A.get("e.com_tcs_telecom:TabEvent");       

        tabEvent.setParams({
            "selectedPackagesAfter" : component.get('v.selectPackageList')
        });
        tabEvent.fire();

        var offers = [];
        console.log('offers953 '+offers);
        var multicart = component.get('v.ServiceOfferMap');
        var currentService =  component.get("v.selectedService");

        console.log('currentService'+currentService);

        for(var i = 0; i < multicart.length; i++) {
            if(multicart[i].key == currentService) {
                offers = multicart[i].value;
                break;
            }
        }


        var index = offers.indexOf(offer.Name);            
        var demodataProducts = component.get("v.demodataProducts");     
        if(index != -1 ) {

            offers.splice(index, 1);
          for(var i = 0; i < demodataProducts.length; i++) {

               if(demodataProducts[i].Name == offer.Name) {   
                    demodataProducts.splice(i, 1);
                    break;
                }
            }

        } else { 
            offers.push(offer.ProductSpec);
            var pkgObj = {};
            pkgObj['Name'] = offer.Name ;
            pkgObj['ServiceType'] = currentService;
            pkgObj['Currency'] = offer.currency ;
            pkgObj['NRC'] = offer.NRC ;
            pkgObj['RC'] = offer.RC ;

            demodataProducts.push(pkgObj);

        }
        component.set("v.demodataProducts", demodataProducts);

        console.log('offers '+offers);
        component.set('v.Cart', offers);

        var cartDataMap=[];
        var cartDataMap=component.get('v.ServiceOfferMap');
        var Services= component.get("v.selectedService");
        console.log('Services json stringify..before987 '+JSON.stringify(Services));
        console.log('cartDataMap json stringify..before986 '+JSON.stringify(cartDataMap));
        if(cartDataMap!= null || cartDataMap!=undefined || cartDataMap!=[] || cartDataMap.length>=0)
        {                      
            for (var Mulser in cartDataMap)
            {              
                if(cartDataMap[Mulser].key == Services)
                {              		 
                    cartDataMap.splice(Mulser, 1);
                }
            }
        }
        console.log('cartDataMap json stringify..after '+JSON.stringify(cartDataMap));

        var cartDataMap=component.get('v.ServiceOfferMap');
        console.log('cartDataMap:'+JSON.stringify(cartDataMap));

        var offersList = [];
        console.log('offersList:'+JSON.stringify(offersList));
        var offersMap = component.get('v.CartMap');
        console.log('offersMap:'+JSON.stringify(offersMap));
        var selService = component.get("v.selectedService");
        if(offersMap== null || offersMap==undefined || offersMap==[] || offersMap.length<=0) {

            console.log('in if');
            offersList.push(offer.Name.trim());
            cartDataMap.push({value:offersList, key:selService});            

        } else {
            console.log('in else');
            var tmpFlag = false;
            for (var a in offersMap) {
                console.log('selService'+selService+'offersMap[a].key'+offersMap[a].key+'offersMap[a].value'+offersMap[a].value);
                if(offersMap[a].key == selService) {
                    offersList = offersMap[a].value;
                    console.log('in offersMap[a].key == selService '+offersList);

                   if(!offersList.includes(offer.Name.trim())) 
                    {                          
                        offersList.push(offer.Name.trim());
                    }
                    tmpFlag = true;
                    cartDataMap.push({value:offersList, key:selService});

                    break;   
                }
            }
            if(!tmpFlag) 
            {
                console.log('in if !tmpFlag');
                 offersList.push(offer.Name.trim());
                cartDataMap.push({value:offersList, key:selService});

            }
            console.log('cartDataMap with service'+ JSON.stringify(cartDataMap));
        }
        component.set('v.CartMap', cartDataMap);     

        var cartDataMapForOffer=component.get('v.servicewithoffergridmap');
        console.log(' offer ................>'+JSON.stringify(offer));
        console.log('cartDataMapForOffer... '+JSON.stringify(cartDataMapForOffer));

        var offersListForOffer = [];
        var offer = event.getParam("selectedOffer");
        if(cartDataMapForOffer== null || cartDataMapForOffer==undefined || cartDataMapForOffer==[] || cartDataMapForOffer.length<=0) {

            console.log('in if cartDataMapForOffer');
            offersListForOffer.push(offer);
            cartDataMapForOffer.push({value:offersListForOffer, key:selService});            


        } else {
            console.log('selService is.. '+selService);
            console.log('in else cartDataMapForOffer');
            var tmpFlag = false;
            for (var a in cartDataMapForOffer) {
                console.log('selService'+selService+'cartDataMapForOffer[a].key'+cartDataMapForOffer[a].key+'cartDataMapForOffer[a].value'+cartDataMapForOffer[a].value);
                if(cartDataMapForOffer[a].key == selService) {
                    offersListForOffer = cartDataMapForOffer[a].value;
                    console.log('in offersMap[a].key == selService '+offersListForOffer);
                    if(!offersListForOffer.includes(offer)) 
                    {                          
                        offersListForOffer.push(offer);
                    }
                    tmpFlag = true;
                    break;   
                }
            }
            if(!tmpFlag) 
            {
                console.log('in if !tmpFlag');
                offersListForOffer.push(offer);
                cartDataMapForOffer.push({value:offersListForOffer, key:selService});
            }

        }
        console.log('***cartmultiservicewithkey***'+ JSON.stringify(cartDataMapForOffer));


        var updateCartMapEvent = $A.get("e.com_tcs_telecom:CartMapEvent");
        updateCartMapEvent.setParams({
            "CartMapData" : cartDataMap,
            "CartMapDataForOffer": cartDataMapForOffer
        });
        updateCartMapEvent.fire();


    }, 
*/
    
   
    
   /* this will enable back to offer, when we click on delete button in shoppingCart */ 
    deleteOffer: function(component, event, helper){
        console.log('inside delete offer in pkgGrid.controller.... ');
        
         //var isAddonProduct = event.getParam('isAddon');
        // console.log('isAddonProduct in packagegrid component.. '+isAddonProduct);
        
          var packageName=event.getParam('packageName');
         var breakouterloop = false;
         console.log('packageName is .>. '+packageName);
        
        var offerToDisable=event.getParam('offersToDelete');
        var currentService=event.getParam('offerUnderServiceOf');
        console.log('offerToDisable is .>. '+JSON.stringify(offerToDisable) + 'and currentService is.. '+currentService);
          helper.setOfferEnable(component, event,offerToDisable,currentService);
        
         var ServiceOfferMap = component.get('v.ServiceOfferMap');
        

          console.log('ServiceOfferMap stringify .befor ein pkgGrid. '+JSON.stringify(ServiceOfferMap));
        console.log('currentService is.. '+currentService);
        for(var i=0;i<ServiceOfferMap.length;i++){
            if(ServiceOfferMap[i].key == currentService){
                  var offersNames =  ServiceOfferMap[i].value;
                console.log('offersNames stringify .. '+JSON.stringify(offersNames));
                console.log('offersNameslen.. '+offersNames.length);
                 for(var j=0;j<offersNames.length;j++){
                      console.log('offersNames[j].trim'+offersNames[j].trim());
                    if(offersNames[j].trim() == packageName){
                    	offersNames.splice(j,1);
                        breakouterloop = true;
                        break;
                	}
                }
                
            }
             console.log('ServiceOfferMap stringify .after pkgGrid. '+JSON.stringify(ServiceOfferMap));
             // PMD Fix IfStmtsMustUseBraces
             if(breakouterloop)
             {
                    break;
             }
            
            
        }
        
        
         var offerbreakouterloop = false;
        var cartDataMapForOffer=component.get('v.OrderCartDataMapForOffer');
        for(var i=0;i<cartDataMapForOffer.length;i++){
            if(cartDataMapForOffer[i].key == currentService){
                  var pkgoffers =  cartDataMapForOffer[i].value;
                //console.log('offersNames stringify .. '+JSON.stringify(offersNames));
                //console.log('offersNameslen.. '+offersNames.length);
                 for(var j=0;j<pkgoffers.length;j++){
                      //console.log('pkgoffersNames[j].trim'+pkgoffersNames[j].trim());
                    if(pkgoffers[j].Name.trim() == packageName){
                    	pkgoffers.splice(j,1);
                        offerbreakouterloop = true;
                        break;
                	}
                }
                
            }
             console.log('pkgoffers stringify .after pkgGrid. '+JSON.stringify(cartDataMapForOffer));
             // PMD Fix IfStmtsMustUseBraces
             if(offerbreakouterloop)
             {
                    break;
             }
            
            
        }
        
        var addoncartDataMap=component.get('v.addonServiceOfferMap');
         var addonProductsMap = component.get('v.addonProductsMap');
        console.log('addonProductsMap after before.. '+JSON.stringify(addonProductsMap));
        console.log('addonServiceOfferMap after before.. '+JSON.stringify(addoncartDataMap));
        var key = currentService+ '#' + packageName;
        for(var i=0;i<addonProductsMap.length;i++){
            if(addonProductsMap[i].key == key){
                addonProductsMap.splice(i,1);
                addoncartDataMap.splice(i,1);
            } 
        }
        console.log('addonProductsMap after del.. '+JSON.stringify(addonProductsMap));
         console.log('addoncartDataMap after del.. '+JSON.stringify(addoncartDataMap));
    },
    
    orderchangeCart : function(component, event, helper){
        	console.log(' inside orderchangeCart .. ');
         	var offersListForOffer = [];
        	var offersList = [];
         	var selService = component.get("v.selectedService");
        	var cartDataMapForOffer=component.get('v.OrderCartDataMapForOffer');
         	var cartDataMap=component.get('v.ServiceOfferMap');
  			var offerSecondTime = event.getParam("selectedOffer");
        	var getPkgDetOfferAction = component.get("c.getPkgDetailForOffer");
            getPkgDetOfferAction.setParams({
            'addedOffer': JSON.stringify(offerSecondTime),
            'calledFromTest' : false
            });
        getPkgDetOfferAction.setCallback(this, function(response1){
            var state1 = response1.getState();
            if (state1 === "SUCCESS") {
            		console.log('getPkgDetOfferAction.getReturnValue()1'+response1.getReturnValue());
            		console.log('getPkgDetOfferAction b41:'+JSON.stringify(offerSecondTime));
             		offerSecondTime = JSON.parse(response1.getReturnValue());
            		component.set('v.offerFromPkgDetails', response1.getReturnValue()); 
             if(cartDataMapForOffer== null || cartDataMapForOffer==undefined || cartDataMapForOffer==[] || cartDataMapForOffer.length<=0) {
						console.log('in if cartDataMapForOffer');
            			offersListForOffer.push(offerSecondTime);
             			offersList.push(offerSecondTime.Name.trim());
            			cartDataMapForOffer.push({value:offersListForOffer, key:selService});  
             			cartDataMap.push({value:offersList, key:selService});
           			}else {
            				console.log('selService is.. '+selService);
            				console.log('in else cartDataMapForOffer');
            				var tmpFlag = false;
            				for (var a in cartDataMapForOffer) {
                							console.log('selService'+selService+'cartDataMapForOffer[a].key'+cartDataMapForOffer[a].key+'cartDataMapForOffer[a].value'+cartDataMapForOffer[a].value);
                							if(cartDataMapForOffer[a].key == selService) {
                                            offersListForOffer = cartDataMapForOffer[a].value;
                                                 offersList = cartDataMap[a].value;
                                            console.log('in offersMap[a].key == selService '+offersListForOffer);
                                            if(!offersListForOffer.includes(offerSecondTime)) 
                                            {                          
                                                offersListForOffer.push(offerSecondTime);
                                                 offersList.push(offerSecondTime.Name.trim());
                                                //cartDataMap.push({value:offersList, key:selService});
                                            }
                                    tmpFlag = true;
                                    break;   
                					}
            		}
                if(!tmpFlag) 
                {
                    console.log('in if !tmpFlag');
                    offersListForOffer.push(offerSecondTime);
                    cartDataMapForOffer.push({value:offersListForOffer, key:selService});
                    offersList.push(offerSecondTime.Name.trim());
                    cartDataMap.push({value:offersList, key:selService});
                }
            
        }
        console.log('***cardatamap offer after select offer in order***'+ JSON.stringify(cartDataMapForOffer));
        console.log('***cardatamap cartDataMap***'+ JSON.stringify(cartDataMap));
        component.set('v.CartMapDataForOffer',cartDataMapForOffer);
		var updateCartMapEvent = $A.get("e.com_tcs_telecom:OrderCartMapEvent");
        updateCartMapEvent.setParams({
            "CartMapData" : cartDataMap,
            "CartMapDataForOffer": cartDataMapForOffer
        });
        updateCartMapEvent.fire();
                  }
        });
       $A.enqueueAction(getPkgDetOfferAction);
            
          
        },
    
    orderchangeCartForAddon : function(component, event, helper){
        	
        	console.log('inside orderchangeCartForAddon is.. ');
        	var servName=component.get('v.selServiceFromAddonPage');
       		var pkgName=component.get('v.selPackageFromAddonPage');
            console.log('-servName..'+servName + 'pkgName> '+pkgName);
        	var addonoffer=event.getParam('selectedOffer');
        	var addonSername=event.getParam('selServiceFromAddonPage');
        	var addonpkgname=event.getParam('selPackageFromAddonPage');
          	var orderId = event.getParam('orderId');
           var selPackageOfferIdFromAddonPage= event.getParam("selPackageOfferIdFromAddonPage");
        component.set('v.selPackageOfferIdFromAddonPage',selPackageOfferIdFromAddonPage);
            console.log('addonoffer.. '+addonoffer + '-addonSername.'+addonSername + 
                        '-addonpkgname '+addonpkgname  + 'selPackageOfferIdFromAddonPage -'+selPackageOfferIdFromAddonPage+
                       'orderId .. '+orderId);
        
        	 var addonAction = component.get("c.getPriceForGivenAddonForOrder");
              addonAction.setParams({
               	'addonAsString':  addonoffer,
                'prodOfferIdOfPackage':selPackageOfferIdFromAddonPage,
                'quoteID' : orderId
                  });
        		addonAction.setCallback(this, function(addonresponse){
                var addonProduct = addonresponse.getReturnValue();
                console.log('addonresponse resp'+JSON.stringify(addonProduct));
                 helper.addAddonProductsToMap(component,event,addonProduct,addonSername,addonpkgname);   
                 //helper.mergerAddonsWithPkgProducts(component,event,addonProduct,addonSername,addonpkgname);   
                    
                    
                    
				});
        	$A.enqueueAction(addonAction);	
        
        
        
        
       	
            //helper.mergerAddonsWithPkgProducts(component, event,addonoffer,addonSername,addonpkgname);
    },
    
    deleteAddonsFromPkg : function(component, event, helper){
       // component.set('v.CartMapDataForOffer'
        var selectServName = event.getParam('selServiceName');
 		var packageName = event.getParam('packageNameToDelete');
        var addonproductOfferingId = event.getParam('productIdToDelete');
         helper.removeDeletedAddonFromMap(component, event,selectServName,packageName,addonproductOfferingId);
    },
 		
    changeCartSite : function(component, event, helper) {
            var offer = event.getParam("selectedOffer");
            console.log('offer b442:'+JSON.stringify(offer));            
            var dataAction2 = component.get("c.getPkgDetailForOffer");
            dataAction2.setParams({
            'addedOffer': JSON.stringify(offer),
            'calledFromTest' : false
            });
            dataAction2.setCallback(this, function(response) {
            //  var offer;
            var state = response.getState();
            if (state === "SUCCESS") {
            console.log('response.getReturnValue()2'+response.getReturnValue());
            console.log('offer b42:'+JSON.stringify(offer));
             offer = JSON.parse(response.getReturnValue());
            component.set('v.offerFromPkgDetails', response.getReturnValue()); 
            
            }
            });
            $A.enqueueAction(dataAction2);
            //  if(component.get('v.offerFromPkgDetails') != undefined && component.get('v.offerFromPkgDetails') != ''){
            // offer = JSON.parse(component.get('v.offerFromPkgDetails'));}
            
            console.log('offer after new2**'+offer);
            
            var selectionAfter=component.get('v.selectPackageList');
            
            selectionAfter.push(offer.ProductSpec);
            component.set('v.selectPackageList',selectionAfter)
            
            var tabEvent = $A.get("e.com_tcs_telecom:TabEvent");       
            
            tabEvent.setParams({
            "selectedPackagesAfter" : component.get('v.selectPackageList')
            });
            tabEvent.fire();
            
            var offers = [];
                      console.log('offers953 '+offers);
        var multicartsite = component.get('v.ServiceOfferMapSite');
        var currentService =  component.get("v.selectedService");
		var currentsite =  component.get("v.selectedsiteId");
		var currentsiteandservice = currentsite+'#'+currentService;
        console.log('currentService'+currentService);
		console.log('currentsite'+currentsite);
        
        for(var i = 0; i < multicartsite.length; i++) {
            if(multicartsite[i].key == currentsiteandservice) {
                offers = multicartsite[i].value;
                break;
            }
        }
        
        
        
     
        var cartDataMapSite=[];
        var cartDataMapSite=component.get('v.ServiceOfferMapSite');
        var Services= component.get("v.selectedService");
		var SiteID =component.get("v.selectedsiteId");
		var SiteandService =SiteID+'#'+Services;
        console.log('SiteandService json stringify..before987 '+JSON.stringify(SiteandService));
        console.log('cartDataMap json stringify..before986 '+JSON.stringify(cartDataMapSite));
        /*if(cartDataMapSite!= null || cartDataMapSite!=undefined || cartDataMapSite!=[] || cartDataMapSite.length>=0)
        {                      
            for (var Mulser in cartDataMap)
            {              
                if(cartDataMapSite[Mulser].key == SiteandService)
                {              		 
                    cartDataMapSite.splice(Mulser, 1);
                }
            }
        }*/
        console.log('cartDataMapSite json stringify..after '+JSON.stringify(cartDataMapSite));
        
        var cartDataMapSite=component.get('v.ServiceOfferMapSite');
        console.log('cartDataMapSite:'+JSON.stringify(cartDataMapSite));
        
        var offersList = [];
        console.log('offersList:'+JSON.stringify(offersList));
        var offersMap = component.get('v.CartMapforsite');
        console.log('offersMap:'+JSON.stringify(offersMap));
        var selService = component.get("v.selectedService");
		var SiteID =component.get("v.selectedsiteId");
		var SiteandService =SiteID+'#'+selService;

        if(offersMap== null || offersMap==undefined || offersMap==[] || offersMap.length<=0) {
            
            console.log('in if');
            offersList.push(offer.Name.trim());
            cartDataMapSite.push({value:offersList, key:SiteandService});            
            
        } else {
            console.log('in else');
            var tmpFlag = false;
            for (var a in offersMap) {
                console.log('SiteandService'+SiteandService+'offersMap[a].key'+offersMap[a].key+'offersMap[a].value'+offersMap[a].value);
                if(offersMap[a].key == SiteandService) {
                    offersList = offersMap[a].value;
                    console.log('in offersMap[a].key == SiteandService '+offersList);
                    
                    if(!offersList.includes(offer.Name.trim())) 
                    {                          
                        offersList.push(offer.Name.trim());
                    }
                    tmpFlag = true;
                    cartDataMapSite.push({value:offersList, key:SiteandService});
                    
                    break;   
                }
            }
            if(!tmpFlag) 
            {
                console.log('in if !tmpFlag');
                offersList.push(offer.Name.trim());
                cartDataMapSite.push({value:offersList, key:SiteandService});
                
            }
            console.log('cartDataMapSite with service'+ JSON.stringify(cartDataMapSite));
        }
        component.set('v.CartMapforsite', cartDataMapSite);     
					
    },
       
    orderchangeCartForAddon_old : function(component, event, helper){
        	
        	console.log('inside orderchangeCartForAddon is.. ');
        	var servName=component.get('v.selServiceFromAddonPage');
       		var pkgName=component.get('v.selPackageFromAddonPage');
            console.log('-servName..'+servName + 'pkgName> '+pkgName);
        	var addonoffer=event.getParam('selectedOffer');
        	var addonSername=event.getParam('selServiceFromAddonPage');
        	var addonpkgname=event.getParam('selPackageFromAddonPage');
            var existOfferMapData=component.get('v.existOfferMap');
            console.log('existOfferMapData is.. '+JSON.stringify(existOfferMapData));
            var existOfferMap=event.getParam('existOfferMap');
         	console.log('existOfferMapData is.from event. '+JSON.stringify(existOfferMap));
            console.log('addonoffer.. '+addonoffer + '-addonSername.'+addonSername + '-addonpkgname '+addonpkgname);
       		
            helper.mergerAddonsWithPkgProducts(component, event,addonoffer,addonSername,addonpkgname);
    }
 		
})