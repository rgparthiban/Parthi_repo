({  
    
    getPkgDetails : function (component,event) {
        var pkgName = event.getParam("pkgName");
        console.log('inside getpackageDetails json....'+pkgName);
        component.set('v.selpackageName',pkgName);
        var action = component.get("c.fetchPackageDetails");
        console.log("PkgName-->"+pkgName+"gridOriginalData"+component.get('v.gridOriginalData'));
        action.setParams({
            'pkgName': pkgName,
            'gridData' : JSON.stringify(component.get('v.gridOriginalData')),
            'calledFromTest' : false
            //'quoteid':component.get("v.recordId")

        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
               
                
                 var pageSize = component.get("v.pageSize");
                component.set('v.isSending',false);
                component.set("v.gridData", JSON.parse(response.getReturnValue()));
                component.set('v.gridOriginalData', JSON.parse(response.getReturnValue()));
                console.log('GridReponse-->'+response.getReturnValue());
               
                component.set('v.isSending',false);
                component.set('v.isGetPkgDetailsCalled',true); 
                console.log('isGetPkgDetailsCalled in getpkgDet..'+component.get('v.isGetPkgDetailsCalled'));
                this.checkOffers(component);
                
                 
                console.log('search key after getPkg'+component.get("v.searchKey"));
                if(component.get("v.searchKey") != null && component.get("v.searchKey") != undefined && component.get("v.searchKey") != '') {
                    this.searchProduct(component);
                    component.set('v.isGetPkgDetailsCalled',true); 
                     //this.checkOffers(component);
                }
            }
        });
        $A.enqueueAction(action);
    },
      /* fetching packages through the apex class method fetchPackages*/
      /*getPackageJSON : function (component) {
                console.log('inside fetch search product....');
        ////var action = component.get("c.fetchPackages");
         var action = component.get("c.fetchSearchProduct");
          console.log('action is '+action);
        console.log("packageService-->"+component.get("v.selectedService"));
        var serviceType = component.get("v.selectedService");
           console.log("serviceType-->"+serviceType);
         var serviceTypeMap = component.get("v.selectedSrvcMap");
          console.log("serviceTypeMap-111-"+serviceTypeMap);
          console.log("serviceTypeMap--"+JSON.stringify(serviceTypeMap));
        action.setParams({
            'serviceType': serviceType,
            'srvcTypeMap': JSON.stringify(serviceTypeMap)
        });
          console.log('we are getting serviceType'+serviceType);
        action.setCallback(this, function(response) {
            console.log('inside getPkgDetailsResponseREturnValue'+response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var pageSize = component.get("v.pageSize");
                 component.set('v.isSending',false);
                component.set("v.gridData", JSON.parse(response.getReturnValue()));
                component.set('v.gridOriginalData', JSON.parse(response.getReturnValue()));
               console.log('GridReponse-->'+JSON.parse(response.getReturnValue()));
               component.set("v.startPage",0);
                
                var PaginationList = [];
                var pageDataList = [];
                var gridResponse = component.get("v.gridOriginalData");
                var loopSize = pageSize;
                if (gridResponse.length <= pageSize) {
                    loopSize = gridResponse.length;
                    component.set("v.lastPageNumber",false);
                    
                }
                else {
                    component.set("v.lastPageNumber",true);
                     component.set('v.isSending',false);
                }
                component.set("v.endPage",pageSize);
                PaginationList.push(component.get('v.headerRow'));
                
                for(var i=0; i<loopSize; i++){
                    console.log(gridResponse[i]);
                    PaginationList.push(gridResponse[i]); 
                    pageDataList.push(gridResponse[i].ProductSpec)
                }
                component.set('v.paginationList', PaginationList);
                component.set('v.pageDataList', pageDataList);
                console.log('log..'+component.get('v.paginationList'));
                console.log('endpage--->'+pageSize-1);
                component.set('v.isSending',false);
                this.checkOffers(component);
             
            }else{
                console.log(response.getError());
            }
            
        });
        $A.enqueueAction(action);
    } ,*/
  
    
    
    
    //jagriti added //
      /* fetching packages through the apex class method fetchPackages*/
    getPackageJSON : function (component) {
          console.log('inside fetch search product....');
        ////var action = component.get("c.fetchPackages");
         var action = component.get("c.fetchSearchProduct");
          console.log('action is '+action);
        console.log("packageService-->"+component.get("v.selectedService"));
        var serviceType = component.get("v.selectedService");
           console.log("serviceType-->"+serviceType);
        var selectedSiteId = component.get("v.selectedSiteId");
         console.log("Siteid-->"+selectedSiteId);
        var selectedSiteId = component.get("v.selectedSiteId");
         console.log("Siteid-->"+selectedSiteId);
        var selectedSitetype = component.get("v.selectedSitetype");
         console.log("selectedSitetype-->"+selectedSitetype);
        
         var serviceTypeMap = component.get("v.selectedSrvcMap");
          console.log("serviceTypeMap-111-"+serviceTypeMap);
          console.log("serviceTypeMap--"+JSON.stringify(serviceTypeMap));
        action.setParams({
            'selectedSiteId' : selectedSiteId,
            'serviceType': serviceType,
            'srvcTypeMap': JSON.stringify(serviceTypeMap),
            'fromTest' : false,
            'quoteId':component.get("v.quoteRecId")
        });
          console.log('we are getting serviceType'+serviceType);
        action.setCallback(this, function(response) {
           
       //  console.log('inside getPkgDetailsResponseREturnValue we get'+JSON.parse(response.getReturnValue()).displayName);
            var state = response.getState();
            if (response.getReturnValue() == 'NoResponseError') {
                console.log('NoResponseError');
                 component.set('v.isSending',false);
                   var toastEvent = $A.get("e.force:showToast");
                                       //console.log('toastevent in  parentcomp'+toastEvent);
                                       toastEvent.setParams({
                                           title : 'Error Message',
                                           
                                           //message: 'Error occurred while calling search product service. Please change the service and try again or contact Administrator',
                                           type: 'error',
                                       });
                                       toastEvent.fire();
            }
              else if (response.getReturnValue() == 'ErrorCodeFromPC') {
                   component.set('v.isSending',false);
                   console.log('ErrorCodeFromPC'+response.getReturnValue());
                   var toastEvent = $A.get("e.force:showToast");
                                       //console.log('toastevent in  parentcomp'+toastEvent);
                                       toastEvent.setParams({
                                           title : 'Error Message',

                                           //message: 'Service has returned error. Please contact Administrator',
                                           type: 'error',
                                       });
                                       toastEvent.fire();
            }
             else if (response.getReturnValue().includes('exception')) {
                  component.set('v.isSending',false);
                  console.log('inside exception if'+response.getReturnValue());
                   var toastEvent = $A.get("e.force:showToast");
                                       console.log('toastevent in  parentcomp'+toastEvent);
                                       toastEvent.setParams({
                                           title : 'Error Message',
                                             
                                           //message: 'Some exception occurred. Please contact Administrator',
                                           type: 'error',
                                       });
                                       toastEvent.fire();
            }
           else if (response.getReturnValue() != null && component.isValid()) {
                // console.log('inside searchproduct response'+JSON.stringify(response.getReturnValue()));
                var pageSize = component.get("v.pageSize");
                 component.set('v.isSending',false);
                component.set("v.gridData", JSON.parse(response.getReturnValue()));
                component.set('v.gridOriginalData', JSON.parse(response.getReturnValue()));
               //console.log('GridReponse-data->'+response.getReturnValue());
             
               component.set("v.startPage",0);
                
                var PaginationList = [];
                var pageDataList = [];
                var gridResponse = component.get("v.gridOriginalData");
              
                var loopSize = pageSize;
                if (gridResponse.length <= pageSize) {
                    console.log('gridResponse.length...'+gridResponse.length);
                    console.log('pageSize...'+pageSize);
                    loopSize = gridResponse.length;
                    component.set("v.lastPageNumber",false);
                    
                }
                else {
                    component.set("v.lastPageNumber",true);
                     component.set('v.isSending',false);
                }
                component.set("v.endPage",pageSize);
                PaginationList.push(component.get('v.headerRow'));
                
                for(var i=0; i<loopSize; i++){
                    console.log(gridResponse[i]);
                    PaginationList.push(gridResponse[i]); 
                    pageDataList.push(gridResponse[i].ProductSpec)
                }
              // console.log('before setting pagination list');
                component.set('v.paginationList', PaginationList);
                console.log('after setting pagination list');
                component.set('v.pageDataList', pageDataList);
                //console.log('log..'+component.get('v.paginationList'));
                console.log('endpage--->'+pageSize-1);
                component.set('v.isSending',false);
               /*if(selectedSitetype == null ||selectedSitetype == '')
               {*/
                this.checkOffers(component);
              /* }
               else
               {
                this.checkOffersforsite(component);   
               }*/
            }else if(response.getReturnValue() == null || response.getReturnValue() == undefined){
                console.log(response.getError());
              var toastEvent = $A.get("e.force:showToast");
                                       console.log('toastevent in  parentcomp'+toastEvent);
                                       toastEvent.setParams({
                                           title : 'Error Message',
 										  
                                          // message: 'There are no products found with this service. Please change the service and try again ',
                                           type: 'error',
                                       });
                                       toastEvent.fire();
            
                component.set('v.isSending',false);
            }
            
        });
        $A.enqueueAction(action);
    } ,
    
    
    /*fetch existing attributes and get the currentversion */
    getExistingAttributes : function(component){
      
          var quoteID = component.get("v.quoteRecId");
        console.log('quoteID in getExistingAttributes pkgGridCompHelper:'+quoteID+'version'+component.get('v.currentVersion'));
        
        var action = component.get("c.fetchExistingAttributes");
        action.setParams({
            'quoteId': quoteID,
            'currentVersion' :  component.get('v.currentVersion')
        });
        console.log('quoteID getting'+quoteID);
        console.log('currentVersion getting'+ component.get('v.currentVersion'));

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
                 component.set('v.isSending',false);
                component.set("v.attr",items)
                
            }});
        $A.enqueueAction(action);
        
        
    },
     /*
     * filter all the packages and it will display given searchkey related offers
     */
   searchProduct_org : function(component) {
        console.log('inside search helper');
        var action = component.get("c.searchOffer");
        var gridResponse = JSON.stringify(component.get("v.gridOriginalData"));
        console.log('gridResponse-->'+gridResponse);
        action.setParams({
            'searchKey': component.get("v.searchKey"),
            'gridJson': gridResponse
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('GridReponse-->'+ JSON.stringify(data));
                if(response.getReturnValue().length <= 2 || response.getReturnValue() == null )
            {
               
                 var toastEvent = $A.get("e.force:showToast");
                                       console.log('toastevent in  parentcomp'+toastEvent);
                                       toastEvent.setParams({
                                           title : 'Error Message',
                                           message: 'No Package Found',
                                           type: 'error',
                                       });
                                       toastEvent.fire();
            }
               
            component.set('v.gridData', JSON.parse(data));
            
                component.set("v.startPage",0);
				var pageSize = component.get("v.pageSize");       
                
                
                var PaginationList = [];
                 var pageDataList = [];
                var gridResponse = component.get("v.gridData");
                var loopSize = pageSize;
                if (gridResponse.length <= pageSize) {
                    loopSize = gridResponse.length;
                    component.set("v.lastPageNumber",false);
                }
                else {
                    component.set("v.lastPageNumber",true);
                }
                component.set("v.endPage",pageSize);
                var searchSelPkgList= [];
                PaginationList.push(component.get('v.headerRow'));
                for(var i=0; i<loopSize; i++){
                    console.log(gridResponse[i]);
                    PaginationList.push(gridResponse[i]);  
                    pageDataList.push(gridResponse[i].ProductSpec);
                }
                component.set('v.paginationList', PaginationList);
                component.set('v.pageDataList', pageDataList);
                console.log('endpage--->'+pageSize-1);
             component.set('v.isSending',false);
               
         } 
         });
         $A.enqueueAction(action);
    },
    
    
    
    
      searchProduct : function(component) {
          //alert();
        console.log('inside search helper');
            component.set('v.isSending',true);
        var action = component.get("c.searchOffer");
        var gridResponse = JSON.stringify(component.get("v.gridOriginalData"));
        console.log('gridResponse-->'+gridResponse);
        action.setParams({
            'searchKey': component.get("v.searchKey"),
            'gridJson': gridResponse
        });
        action.setCallback(this, function(response) {
             //alert('1');
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data---'+data);
                //console.log('GridReponse-->'+ JSON.stringify(data));
                if(response.getReturnValue().length <= 2 || response.getReturnValue() == null )
            {
               
                 var toastEvent = $A.get("e.force:showToast");
                                       console.log('toastevent in  parentcomp'+toastEvent);
                                       toastEvent.setParams({
                                           title : 'Error Message',
                                           message: 'No Package Found',
                                           type: 'error',
                                       });
                                       toastEvent.fire();
            }
               
            component.set('v.gridData', JSON.parse(data));
            //component.set("v.gridOriginalData",JSON.parse(data));
                component.set("v.startPage",0);
				var pageSize = component.get("v.pageSize");       
                
                
                var PaginationList = [];
                 var pageDataList = [];
               //var gridResponse = component.get("v.gridData");
                //var gridResponse = component.get("v.gridOriginalData");
                //start
                var multicart = component.get('v.ServiceOfferMap');
                if(multicart.length == 0){
             	console.log('quoteid.in checkoffers.'+component.get('v.quoteRecId') + 'serviceType..'+component.get('v.selectedService')+
                   'currVersion.. '+component.get('v.currentVersion'));
          		var multicartaction = component.get("c.getExistingOffersForExistingServiceTypes");
            	multicartaction.setParams({
                    'resultMap': {},
                    'quoteId' : component.get('v.quoteRecId'),
                    'offerMap' : {},
                    'serviceType' : component.get('v.selectedService'),
                    'currentVersion' : component.get('v.currentVersion'),
                    'existingServiceOfferMap' : {}
                });
        		multicartaction.setCallback(this, function(response){
             
               	var resData=response.getReturnValue();
                console.log('resData getExistingOffersForExistingServiceTypes->'+resData);
                var resDataInString = JSON.stringify(response.getReturnValue());
             	console.log('getExistingOffers-checkOffers-response is >'+resDataInString);
            	if(resDataInString.length > 0){
                    console.log('resData.length->'+resDataInString.length);
                 var listOfPkgNamesAgainstToService = [];
                 for(var serviceName in resData){
                 console.log('serviceName .. '+serviceName);
                  var Pkges = resData[serviceName];
                  var listOfPkgNames = [];
                	for ( var packName in Pkges ) {
                    	 console.log('packName .. '+packName);
                        
                         listOfPkgNames.push(packName);
                	}
                 multicart.push({value:listOfPkgNames, key:serviceName});
            	}
               console.log('multicart in action->'+multicart);
                 
                }else{
                      console.log('getExistingOffers-checkOffers-resDataInString.length >'+resDataInString.length);
                }
        	});
        	$A.enqueueAction(multicartaction);
        	}
        	console.log('multicart in searchDisable.. 1111'+JSON.stringify(multicart));
       		var currentService =  component.get("v.selectedService");
        	console.log('currentService'+currentService);
      		var cart = [];
        	for(var i = 0; i < multicart.length; i++) {
            console.log('multicart[i].key..'+multicart[i].key);
            if(multicart[i].key == currentService) {
            cart = multicart[i].value;
            break;
           }
       	}
           var newcart=[];
          for(var i=0;i<cart.length;i++)
        {
           
            newcart.push(cart[i].replace(/\s/g, ""));
            
        }
         cart=newcart;
         var gridItems = component.get("v.gridData");
        for(var i = 0; i < gridItems.length; i++) {
            var gridItem = gridItems[i];
            var griditemName = gridItem.Name.trim();
            console.log('gridItem...'+gridItem +'cart is..'+cart);
            if(cart.indexOf(griditemName.replace(/\s/g, "")) != -1) {
                gridItems[i].isChecked = true;
                gridItems[i].isDisabled = true;
                console.log('inside if..'+gridItem);
            } else {
                gridItems[i].isChecked = false;
                gridItems[i].isDisabled = false;
            }
        }
        component.set('v.gridData', gridItems);
            
          
          this.searchDisable(component);  
          var gridResponse = component.get("v.gridData"); 
        //end
                var loopSize = pageSize;
                if (gridResponse.length <= pageSize) {
                    loopSize = gridResponse.length;
                    component.set("v.lastPageNumber",false);
                }
                else {
                    component.set("v.lastPageNumber",true);
                }
                component.set("v.endPage",pageSize);
                var searchSelPkgList= [];
                PaginationList.push(component.get('v.headerRow'));
                for(var i=0; i<loopSize; i++){
                    //console.log(gridResponse[i]);
                    PaginationList.push(gridResponse[i]);  
                    pageDataList.push(gridResponse[i].ProductSpec);
                }
                component.set('v.paginationList', PaginationList);//com
                component.set('v.pageDataList', pageDataList);
                console.log('endpage--->'+pageSize-1);
             component.set('v.isSending',false);
             //this.checkOffers(component);
         }
           
           
         });
         $A.enqueueAction(action);
    },
    
    searchDisable : function(component){
      	console.log('inside searchDisable');
        var multicart = component.get('v.ServiceOfferMap');
          if(multicart.length == 0){
             console.log('quoteid..'+component.get('v.quoteRecId') + 'serviceType..'+component.get('v.selectedService')+
                   'currVersion.. '+component.get('v.currentVersion'));
          var action = component.get("c.getExistingOffersForExistingServiceTypes");
            action.setParams({
                'resultMap': {},
                'quoteId' : component.get('v.quoteRecId'),
                'offerMap' : {},
                'serviceType' : component.get('v.selectedService'),
                'currentVersion' : component.get('v.currentVersion'),
                'existingServiceOfferMap' : {}
            });
        action.setCallback(this, function(response){
             
               var resData=response.getReturnValue();
                console.log('resData getExistingOffersForExistingServiceTypes->'+resData);
                var resDataInString = JSON.stringify(response.getReturnValue());
             console.log('getExistingOffers-checkOffers-response is >'+resDataInString);
            	if(resDataInString.length > 0){
                    console.log('resData.length->'+resDataInString.length);
                 var listOfPkgNamesAgainstToService = [];
                 for(var serviceName in resData){
                 console.log('serviceName .. '+serviceName);
                  var Pkges = resData[serviceName];
                  var listOfPkgNames = [];
                	for ( var packName in Pkges ) {
                    	 console.log('packName .. '+packName);
                       
                         listOfPkgNames.push(packName);
                	}
                 multicart.push({value:listOfPkgNames, key:serviceName});
            	}
               console.log('multicart in action->'+multicart);
                 
                }else{
                      console.log('getExistingOffers-checkOffers-resDataInString.length >'+resDataInString.length);
                }
        });
        $A.enqueueAction(action);
        }
        console.log('multicart in searchDisable.. '+JSON.stringify(multicart));
        var currentService =  component.get("v.selectedService");
        console.log('currentService'+currentService);
      	var cart = [];
        for(var i = 0; i < multicart.length; i++) {
            console.log('multicart[i].key..'+multicart[i].key);
            if(multicart[i].key == currentService) {
                cart = multicart[i].value;
                break;
            }
        }
         for(var i=0;i<cart.length;i++)
        {
            var newcart=[];
            newcart.push(cart[i].replace(/\s/g, ""));
            cart=newcart;
        }
         var gridItems = component.get("v.gridOriginalData");
        for(var i = 0; i < gridItems.length; i++) {
            var gridItem = gridItems[i];
            var griditemName = gridItem.Name.trim();
            console.log('gridItem...'+gridItem +'cart is..'+cart);
            if(cart.indexOf(griditemName.replace(/\s/g, "")) != -1) {
                gridItems[i].isChecked = true;
                gridItems[i].isDisabled = true;
                console.log('inside if..'+gridItem);
            } else {
                gridItems[i].isChecked = false;
                gridItems[i].isDisabled = false;
            }
        }
       
        component.set('v.gridOriginalData', gridItems);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        component.set('v.isGetPkgDetailsCalled', false);
       //var sObjectList = component.get("v.gridData");
         var sObjectList = component.get("v.gridOriginalData");
        //console.log('json stringify of.sObjectListgriddata. '+JSON.stringify(sObjectListgriddata));
         //console.log('json stringify of.sObjectList. '+JSON.stringify(sObjectList));
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var prevPaginationList = component.get("v.paginationList");
        var pageDataList = [];
        var selectedPackageInPage = [];
         var selectedPackage = component.get("v.Cart");;
        var counter = 0;
        paginationList.push(component.get('v.headerRow'));
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                paginationList.push(sObjectList[i]);
                pageDataList.push(sObjectList[i].ProductSpec);
                console.log("Paginationdata-->"+paginationList);
                counter ++;
            }else{
                start++;
            }
            component.set("v.lastPageNumber",true);
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.paginationList", paginationList);
        component.set('v.pageDataList', pageDataList);
         //this.checkOffers(component, event);
         
    },
    
    
        
    
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component, event){
        component.set('v.isGetPkgDetailsCalled', false);
       //var sObjectList = component.get("v.gridData");
          var sObjectList = component.get("v.gridOriginalData");
        var end = component.get("v.endPage");
        console.log('before end.. '+end);
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var prevPaginationList = component.get("v.paginationList");
        var pageDataList = [];
        var counter = 0;
        var selectedPackageInPage = [];
         var selectedPackage = component.get("v.Cart");
        paginationList.push(component.get('v.headerRow'));
        for(var i=end; i<end+pageSize; i++){
            if(sObjectList.length > i){
                paginationList.push(sObjectList[i]);
                pageDataList.push(sObjectList[i].ProductSpec);
            }
            counter ++ ; 
        }
        console.log("TotalRecords-->"+sObjectList.length);
        console.log("Next Button endpage-->"+end);
        console.log("Next Button pagesize-->"+pageSize);
        start = start + counter;
        end = end + counter;
        if(sObjectList.length < end+1){
            component.set("v.lastPageNumber",false);
        }
        //
        
        
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.paginationList", paginationList);
        component.set('v.pageDataList', pageDataList);
       //	this.checkOffers(component, event);
        
         
    },
    
    
    
    
    
    
    
    
    
            
    
  
    
    
    
    
    
    
    
      /*to disable the packages in the grid acc to cart list */
    checkOffers : function(component, event) {
        console.log('inside checkOffers');
        var cart = [];
        var multicart = component.get('v.ServiceOfferMap');
        console.log('multicart in checkoffers.. '+multicart);
        //added for disablement of carticons for revise time...
        if(multicart!=undefined && multicart.length == 0){
             console.log('quoteid..'+component.get('v.quoteRecId') + 'serviceType..'+component.get('v.selectedService')+
                   'currVersion.. '+component.get('v.currentVersion'));
          var action = component.get("c.getExistingOffersForExistingServiceTypes");
            action.setParams({
                'resultMap': {},
                'quoteId' : component.get('v.quoteRecId'),
                'offerMap' : {},
                'serviceType' : component.get('v.selectedService'),
                'currentVersion' : component.get('v.currentVersion'),
                'existingServiceOfferMap' : {}
            });
        action.setCallback(this, function(response){
             
               var resData=response.getReturnValue();
                console.log('resData getExistingOffersForExistingServiceTypes->'+resData);
                var resDataInString = JSON.stringify(response.getReturnValue());
             console.log('getExistingOffers-checkOffers-response is >'+resDataInString);
            	if(resDataInString.length > 0){
                    console.log('resData.length->'+resDataInString.length);
                 var listOfPkgNamesAgainstToService = [];
                 for(var serviceName in resData){
                 console.log('serviceName .. '+serviceName);
                  var Pkges = resData[serviceName];
                  var listOfPkgNames = [];
                	for ( var packName in Pkges ) {
                    	 console.log('packName .. '+packName);
                         listOfPkgNames.push(packName);
                	}
                 multicart.push({value:listOfPkgNames, key:serviceName});
            	}
               console.log('multicart in action->'+multicart);
                 
                }else{
                      console.log('getExistingOffers-checkOffers-resDataInString.length >'+resDataInString.length);
                }
            this.setDisable(component, event,multicart);   
        });
        $A.enqueueAction(action);
        }
        else{
             this.setDisable(component, event,multicart);
        }
        
        
       
},
    
    //This method to disable if offers already selected
    setDisable : function(component, event,multicart)
    {
       
       console.log('multicart value in setDisable ...'+JSON.stringify(multicart));
         var currentService =  component.get("v.selectedService");
       console.log('currentService'+currentService);
       this.setOfferDisable(component, event,multicart,currentService);
       
	},
    
    setOfferDisable : function(component, event,multicart,currentService){
        var cart = [];
      console.log('inside setOfferDisable');
         for(var i = 0; i < multicart.length; i++) {
            console.log('multicart[i].key..'+multicart[i].key);
            if(multicart[i].key == currentService) {
                cart = multicart[i].value;
                break;
            }
        }
         console.log('cart before  ... '+cart);
        var newcart=[];
        for(var i=0;i<cart.length;i++)
        {
            
            newcart.push(cart[i].replace(/\s/g, ""));
            //cart=newcart;
            //cart.push(cart);
        }
        cart=newcart;
        console.log('cart after newcart ... '+cart);
         var gridItems = component.get("v.gridOriginalData");
        for(var i = 0; i < gridItems.length; i++) {
            var gridItem = gridItems[i];
            //console.log('cart is..'+cart);
            //console.log('gridprodName--'+gridItem.Name.trim());
            var griditemName=gridItem.Name;
            if(cart.indexOf(griditemName.replace(/\s/g, "")) != -1) {
                gridItems[i].isChecked = true;
                gridItems[i].isDisabled = true;
                //console.log('inside if..'+JSON.stringify(gridItem));
            } else {
                gridItems[i].isChecked = false;
                gridItems[i].isDisabled = false;
            }
        }
        component.set('v.gridOriginalData', gridItems);
        var start = component.get('v.startPage');
        var end = component.get('v.endPage');
        //console.log('start .. '+start+ 'end.. '+end);
        var PaginationList = [];
        PaginationList.push(component.get('v.headerRow'));
        for(var i=start; i<end; i++){
            console.log(gridItems[i]);
            PaginationList.push(gridItems[i]); 
        }
        component.set('v.paginationList', PaginationList);
    },
    
    /* build quoteLine based on service type and quoteId */
    buildQuoteLine : function(component){
        var currentService =  component.get("v.selectedService");
        var quoteId = component.get("v.quoteRecId");
        var srvcMap = component.get("v.selectedSrvcMap");
        console.log('srvcMap------999--'+srvcMap);
        var action = component.get("c.buildQuoteLine");
            action.setParams({
                'quoteId': quoteId,
                'serviceTypeValue': currentService
            });
        action.setCallback(this, function(response){
             var resData=response.getReturnValue();
        });
        $A.enqueueAction(action);
    },
    
    /*  enable the offers after deleted offer from cart */
    setOfferEnable : function(component, event,multicart,currentService){
        var cart = [];
      
         for(var i = 0; i < multicart.length; i++) {
            console.log('multicart[i].key..'+multicart[i].key);
            if(multicart[i].key == currentService) {
                cart = multicart[i].value;
                break;
            }
        }
         var gridItems = component.get("v.gridOriginalData");
        for(var i = 0; i < gridItems.length; i++) {
            var gridItem = gridItems[i];
            console.log('gridItem...'+gridItem +'cart is..'+cart);
            if(cart.indexOf(gridItem.Name.trim()) != -1) {
                gridItems[i].isChecked = false;
                gridItems[i].isDisabled = false;
                console.log('inside if..'+gridItem);
            } 
        }
        component.set('v.gridOriginalData', gridItems);
        var start = component.get('v.startPage');
        var end = component.get('v.endPage');
        var PaginationList = [];
        PaginationList.push(component.get('v.headerRow'));
        for(var i=start; i<end; i++){
            console.log(gridItems[i]);
            PaginationList.push(gridItems[i]); 
        }
        component.set('v.paginationList', PaginationList);
    },
    //This method to disable if offers already selected for Site
    setDisableforsite : function(component, event,multicartsite)
    {
       
       console.log('multicartsite value in setDisableforsite ...'+JSON.stringify(multicartsite));
         var currentService =  component.get("v.selectedService");
         var currentsite = component.get('v.selectedsiteId');
         var siteandservice =currentsite+'#'+currentService;
       console.log('currentService'+currentService);
       console.log('currentsite'+currentsite);
       this.setOfferDisableforSite(component, event,multicartsite,currentService,currentsite,siteandservice);
       
	},
    
    setOfferDisableforSite : function(component, event,multicartsite,currentService,currentsite,siteandservice){
        var cart = [];
      console.log('inside setOfferDisable');
         for(var i = 0; i < multicartsite.length; i++) {
            console.log('multicartsite[i].key..'+multicartsite[i].key);
            if(multicartsite[i].key == siteandservice) {
                cart = multicartsite[i].value;
                break;
            }
        }
         console.log('cart before  ... '+cart);
        var newcart=[];
        for(var i=0;i<cart.length;i++)
        {
            
            newcart.push(cart[i].replace(/\s/g, ""));
            //cart=newcart;
            //cart.push(cart);
        }
        cart=newcart;
        console.log('cart after newcart ... '+cart);
         var gridItems = component.get("v.gridOriginalData");
        for(var i = 0; i < gridItems.length; i++) {
            var gridItem = gridItems[i];
            //console.log('cart is..'+cart);
            //console.log('gridprodName--'+gridItem.Name.trim());
            var griditemName=gridItem.Name;
            if(cart.indexOf(griditemName.replace(/\s/g, "")) != -1) {
                gridItems[i].isChecked = true;
                gridItems[i].isDisabled = true;
                //console.log('inside if..'+JSON.stringify(gridItem));
            } else {
                gridItems[i].isChecked = false;
                gridItems[i].isDisabled = false;
            }
        }
        component.set('v.gridOriginalData', gridItems);
        var start = component.get('v.startPage');
        var end = component.get('v.endPage');
        //console.log('start .. '+start+ 'end.. '+end);
        var PaginationList = [];
        PaginationList.push(component.get('v.headerRow'));
        for(var i=start; i<end; i++){
            console.log(gridItems[i]);
            PaginationList.push(gridItems[i]); 
        }
        component.set('v.paginationList', PaginationList);
    },
    
    
    mergerAddonsWithPkgProducts : function(component, event,addonoffer,addonSername,addonpkgname){
     				var cartDataMapForOffer=component.get('v.OrderCartDataMapForOffer');
         	 		var cartDataMap=component.get('v.ServiceOfferMap');
        			var offersList = [];
					var addoncartDataMap=component.get('v.addonServiceOfferMap');
					if(addoncartDataMap== null || addoncartDataMap==undefined || addoncartDataMap.length == 0)
					 {
						offersList.push(addonoffer.productOfferingId.trim());
						addoncartDataMap.push({value:offersList, key:addonSername+'#'+addonpkgname});
                     }else{
                        	console.log('in else cartDataMapForOffer');
            				var tmpFlag = false;
                         	var selAddonGorGivenServiceAndPkg = addonSername+'#'+addonpkgname;
            				for (var a in addoncartDataMap) {
                							console.log('selAddonGorGivenServiceAndPkg'+selAddonGorGivenServiceAndPkg+'addoncartDataMap[a].key'+addoncartDataMap[a].key);
                							if(addoncartDataMap[a].key == selAddonGorGivenServiceAndPkg) {
                                            offersList = addoncartDataMap[a].value;
                                           	if(!offersList.includes(addonoffer.productOfferingId.trim())) 
                                            {                          
												offersList.push(addonoffer.productOfferingId.trim());
                                                //cartDataMap.push({value:offersList, key:selService});
                                            }
                                    tmpFlag = true;
                                    break;   
                					}
            				}
                if(!tmpFlag) 
                {
                    console.log('in if !tmpFlag');
                    offersList.push(addonoffer.productOfferingId.trim());
                    addoncartDataMap.push({value:offersList, key:selAddonGorGivenServiceAndPkg});
                }
            	}
        	console.log('addoncartDataMap json .. '+JSON.stringify(addoncartDataMap));
        	/*for(var i=0;i<cartDataMapForOffer.length;i++){
                console.log('cartDataMapForOffer[i].key.. '+cartDataMapForOffer[i].key);
                if(cartDataMapForOffer[i].key == addonSername){
                    var selPkges=cartDataMapForOffer[i].value;
                    for(var j=0;j<selPkges.length;j++){
                        console.log('selPkges[j].Name.. '+selPkges[j].Name);
                        if(selPkges[j].Name == addonpkgname){
                            var prodList=selPkges[j]._children;
                            prodList.push(addonoffer);
                        }
                    }
                }
            }
        console.log('orderchangeCartForAddon ..datamap.after. '+JSON.stringify(cartDataMapForOffer));*/
        var updateCartMapEvent = $A.get("e.com_tcs_telecom:FromPkgGridToSelectPkgAddonEvent");
        updateCartMapEvent.setParams({
            //"CartMapData" : cartDataMap,
            //"CartMapDataForOffer": cartDataMapForOffer,
            "CartMapData" : null,
            "CartMapDataForOffer": null,
            "addoncartDataMap" : addoncartDataMap
        });
        updateCartMapEvent.fire();
        //this.addAddonProductsToMap(component,event,addonoffer,addonSername,addonpkgname); 
		},
    
    removeDeletedAddonFromMap : function (component, event,selectServName,packageName,addonproductOfferingId)
    {
        var addonProductsMap=component.get('v.addonProductsMap');
        var addoncartDataMap=component.get('v.addonServiceOfferMap');
        //console.log('before remove addon from map .. '+JSON.stringify(addonProductsMap));
        console.log('before remove valAddonCardDataMap from map .. '+JSON.stringify(addoncartDataMap));
        var key =selectServName+'#'+packageName;
        for(var i=0;i<addonProductsMap.length;i++){
            if(addonProductsMap[i].key == key){
                console.log('addonProductsMap[i].key.. '+addonProductsMap[i].key);
                var valList=addonProductsMap[i].value;
                var valAddonCardDataMap=addoncartDataMap[i].value;
                for(var j=0;j<valList.length;j++){
                    if(valList[j].productOfferingId == addonproductOfferingId){
                        console.log('valList[j].productOfferingId.. '+valList[j].productOfferingId +'> addonproductOfferingId'+addonproductOfferingId);
                        valList.splice(j,1);
                        valAddonCardDataMap.splice(j,1);
                    }
                }
            }
        }
        console.log('after remove addon from valAddonCardDataMap .. '+JSON.stringify(addoncartDataMap));
        
        
        //component.set('v.addoncartDataMap',valAddonCardDataMap);
       //console.log('after remove addon from map .. '+JSON.stringify(addonProductsMap)); 
       /*var updateCartMapEvent = $A.get("e.com_tcs_telecom:FromPkgGridToSelectPkgAddonEvent");
        updateCartMapEvent.setParams({
            //"CartMapData" : cartDataMap,
            //"CartMapDataForOffer": cartDataMapForOffer,
            //"CartMapData" : null,
            //"CartMapDataForOffer": null,
            "addoncartDataMap" : addoncartDataMap
        });
        updateCartMapEvent.fire(); 
        */
    },
    /*to disable the packages in the grid acc to cart list */
   checkOffersforsite : function(component, event) {
        console.log('inside checkOffersforsite');
        var serviceType = component.get("v.selectedService");
           console.log("serviceType-->"+serviceType);
        var selectedSiteId = component.get("v.selectedSiteId");
         console.log("Siteid-->"+selectedSiteId);
         var selectedSitetype =component.get("v.selectedSitetype");
         console.log("selectedSitetype--->"+selectedSitetype);
        var cart = [];
        var multicartsite = component.get('v.ServiceOfferMapSite');
        console.log('multicart in checkoffers.. '+multicartsite);
        if(multicartsite!=undefined && multicartsite.length == 0){
             /*console.log('quoteid..'+component.get('v.quoteRecId') + 'serviceType..'+component.get('v.selectedService')+'SiteId...'+component.get('v.selectedSiteId')
                   'currVersion.. '+component.get('v.currentVersion'));*/
                 
                // multicartsite.push({value:, key:serviceType+'#'+selectedSiteId});
            	}
               console.log('multicart in action->'+multicartsite);
                
            this.setDisableforsite(component, event,multicartsite);   
        /*else{
             this.setDisableforsite(component,event,multicartsite);
        }*/
        
        
       
},
    addAddonProductsToMap : function (component,event,addonProduct,addonSername,addonpkgname){
        	console.log('inside addAddonProductsToMap');
        	var offersList = [];
        	var addonoffersList = [];
        	var addoncartDataMap=component.get('v.addonServiceOfferMap');
    		var addonProductsMap = component.get('v.addonProductsMap');
        	if(addonProductsMap== null || addonProductsMap==undefined || addonProductsMap.length == 0)
					 {
						offersList.push(addonProduct);
                         addonoffersList.push(addonProduct.productOfferingId.trim());
                         addoncartDataMap.push({value:addonoffersList, key:addonSername+'#'+addonpkgname});
						addonProductsMap.push({value:offersList, key:addonSername+'#'+addonpkgname});
                     }else{
                           console.log('in else addonProductsMap');
            				var tmpFlag = false;
                         	var selAddonGorGivenServiceAndPkg = addonSername+'#'+addonpkgname;
            				for (var a in addonProductsMap) {
                							console.log('selAddonGorGivenServiceAndPkg'+selAddonGorGivenServiceAndPkg+'addoncartDataMap[a].key'+addonProductsMap[a].key);
                							if(addonProductsMap[a].key == selAddonGorGivenServiceAndPkg) {
                                            offersList = addonProductsMap[a].value;
                                            addonoffersList = addoncartDataMap[a].value;
                                           	if(!offersList.includes(addonProduct)) 
                                            {                          
												offersList.push(addonProduct);
                                                //cartDataMap.push({value:offersList, key:selService});
                                            }
                                            if(!addonoffersList.includes(addonProduct.productOfferingId.trim())) 
                                            {                          
												addonoffersList.push(addonProduct.productOfferingId.trim());
                                                //cartDataMap.push({value:offersList, key:selService});
                                            }    
                                    tmpFlag = true;
                                    break;   
                					}
            				}
                        if(!tmpFlag) 
                        {
                            console.log('in if !tmpFlag');
                            offersList.push(addonProduct);
                            addonoffersList.push(addonProduct.productOfferingId.trim());
                            addonProductsMap.push({value:offersList, key:selAddonGorGivenServiceAndPkg});
                            addoncartDataMap.push({value:addonoffersList, key:addonSername+'#'+addonpkgname});
                        }
                     }
         console.log('***addonProductsMap addonProductsMap***'+ JSON.stringify(addonProductsMap));
        console.log('***addoncartDataMap***'+ JSON.stringify(addoncartDataMap));
         var addonprodId=component.get('v.selPackageOfferIdFromAddonPage');
        var updateCartMapEvent = $A.get("e.com_tcs_telecom:OrderaddonProdMapEvent");
        updateCartMapEvent.setParams({
            //"CartMapData" : cartDataMap,
            "addonProductsMap": addonProductsMap,
            "addonProdId" : addonProduct.productOfferingId.trim(),
            "selServiceFromAddonPage":addonSername,
            "selPackageFromAddonPage":addonpkgname,
            "addoncartDataMap" : addoncartDataMap
        });
        updateCartMapEvent.fire();
        //this.mergerAddonsWithPkgProducts(component, event,addonProduct,addonSername,addonpkgname);
		}
    
})