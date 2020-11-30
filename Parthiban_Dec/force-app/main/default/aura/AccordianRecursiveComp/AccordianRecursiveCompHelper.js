({
     toggleHelper : function(component,event) {
    var toggleText = component.find("tooltip");
    $A.util.toggleClass(toggleText, "toggle");
   },
    /* for showing and hiding accordion data */
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    
    /* To delete addon*/
    deleteInner : function(component, event,pkgNameTobeDelete, productOfferingId){
        console.log('inside delete...'+pkgNameTobeDelete);
        console.log('productOfferingId '+productOfferingId);
        component.set('v.priceSpinner',true);
         var selServiceName = component.get('v.selectedService'); 
        console.log('selServiceName in delete inner.. '+selServiceName);
        /*var deleteEvent = $A.get("e.com_tcs_telecom:UncheckDeletedAddons");
        deleteEvent.setParams({
            "packageNameToDelete" : pkgNameTobeDelete,
            "productIdToDelete" :  productOfferingId
        });
        deleteEvent.fire();*/
        console.log('inside delete...'+pkgNameTobeDelete);
        console.log('productOfferingId '+productOfferingId);
        component.set('v.priceSpinner',true);
        var bigMap =component.get('v.QLIMap');
        var allProdArray = new Map();
        var parentOfferingId;
        //console.log('map stringify. bigmap> before.delete '+JSON.stringify(bigMap));
        if(bigMap!=null){
            for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
                console.log('bigMap map itr'+bigMap[mapListCtr].key );
                if(bigMap[mapListCtr].key == pkgNameTobeDelete){
                    console.log('matched pkg. '+bigMap[mapListCtr].key);
                    var prodItems = bigMap[mapListCtr].value;
                    for (var prodCtr = 0; prodCtr < prodItems.length; prodCtr++) {
                        if(prodItems[prodCtr].name == pkgNameTobeDelete) {
                            parentOfferingId = prodItems[prodCtr].productOfferingId;
                        }
                        if(prodItems[prodCtr].productOfferingId == productOfferingId) {
                            console.log('matched pkg. '+prodItems[prodCtr]);
                            prodItems.splice(prodCtr,1);
                            bigMap[mapListCtr].value = prodItems;
                            break;
                        }
                    }
                }
            }
        }
        //console.log('after delete..bigMap' + JSON.stringify(bigMap));
        component.set('v.priceSpinner',false);
        var attrvalue = component.get("v.attr");
        console.log('attrvalue in delete b4'+attrvalue);
        if(attrvalue!=undefined) {
            for (var i=attrvalue.length-1; i>=0;i--) {
                if(pkgNameTobeDelete!= undefined &&  (attrvalue[i].key).indexOf(pkgNameTobeDelete) != -1) {
                    attrvalue.splice(i,1);
                }
            }
        }
        console.log('attrvalue after'+attrvalue);
        component.set("v.attr",attrvalue);
        
     var selServiceName = component.get('v.selectedService'); 
     console.log('selServiceName in delete addon .. '+selServiceName);   
     var finalmap = component.get('v.bigconMapUpdate');
        var orderType;
	for(var i=0;i<finalmap.length;i++){
    	console.log('finalmap in delete [i].key..'+finalmap[i].key);
    	component.set('v.currentselectedService',finalmap[i].key);
    	if(finalmap[i].key == selServiceName){
            orderType = finalmap[i].orderType;
       		console.log('inside if ..'+finalmap[i].key);
        	finalmap[i].value = bigMap;
        	break;
    		}
	}
     component.set("v.QLIMap",bigMap);    
	//component.set('v.bigconMapUpdate',finalmap);
       
      
        var priceDataActionn = component.get("c.getPriceCalculationRevampForBOB");
        priceDataActionn.setParams({
            'productLineItemMapStr': JSON.stringify(finalmap)
        });
        priceDataActionn.setCallback(component, function(response) {
               console.log('priceResponse.getReturnValue().at delete Helper '+response.getReturnValue());
               var priceEvent;
               if(orderType!=undefined && orderType!=null && orderType=='createOrder'){
                    priceEvent = $A.get("e.com_tcs_telecom:OrderPriceEvent");
                }else{
                    priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
                }
           	    priceEvent.setParams({
            		    "priceData" : response.getReturnValue()
            	});
                priceEvent.fire();
            
            	var deleteEvent = $A.get("e.com_tcs_telecom:UncheckDeletedAddons");
        	deleteEvent.setParams({
            "packageNameToDelete" : pkgNameTobeDelete,
            "productIdToDelete" :  productOfferingId,
            "selServiceName" : selServiceName
        });
        deleteEvent.fire();  
            
            
       /* var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
        compEvent.setParams({
            "shoppingCartData" : bigMap,
            "selectedAttributes" :  attrvalue
        });
        compEvent.fire();*/
        
            
            
				});
          $A.enqueueAction(priceDataActionn);
        
        
        
        
 	 
        
    },  
        
        
    
    /*applying validation rules on discount values 
     * and showing toast message accordingly
     */
    discountValidation :  function(priceVal,prodName,discVal,priceType,component,discType){
        var nameRegex  = '((^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))';
       // changed decimal value from two decimals to four decimals
        //var nameRegex  = '((^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,4})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))';
        var netResultVal;
        var regex = new RegExp(nameRegex);
        var variablePrice;
        var firstLevelPkgName = component.get('v.packageKeyofFirstLevel');
        console.log('component con key.firstLevelPkgName.'+ firstLevelPkgName);
        var pkgofferList=[];
        var pkgAndprodName=prodName.split('#');
        var pkgname=pkgAndprodName[0];
        console.log('pkgname.. '+pkgname);
        pkgofferList.push({value:pkgname,key:firstLevelPkgName});
        component.set('v.overridenOfferList',pkgofferList);
        if(discVal!=undefined && discVal.length>0){
            console.log('priceVal.before. '+priceVal + 'prodName' + prodName);
            var priceandVarPrice=priceVal.split('#');
            priceVal=priceandVarPrice[0];
            variablePrice=priceandVarPrice[1];
            console.log('discVal->' + discVal + 'priceVal-' +priceVal + 'variablePrice-'+variablePrice);
            console.log('discVal.regex matches. '+regex.test(discVal));
           /* if(!regex.test(discVal) && discType == 'Absolute'){
                netResultVal=parseFloat(priceVal);
                discVal='';
                var toastEvent = $A.get("e.force:showToast");
                console.log('toastevent in  parentcomp'+toastEvent);
                toastEvent.setParams({
                    title : 'error',
                    message: 'Invalid Value',
                    type: 'error',
                    
                });
                toastEvent.fire();
                this.commonMethodForPriceOverride(component,prodName,netResultVal,priceType,
                                                  discVal); 
            }*/
            /*else  
            {*/
            
            	 //var customSetData=component.get('v.customSetDetails');
             	 //var negDisAllowFlag=customSetData.com_tcs_telecom__NegativeDiscountsAllowed__c;
                 //console.log('negDisAllowFlag.. '+negDisAllowFlag);
            
                var disc1;    
            	var variablePriceCheckFlag=true;
                if(discType == '%')
                {
                     console.log('discType disc1 hereattt '+discType);
                    disc1=(parseFloat(priceVal)*parseFloat(discVal)/100);
                    console.log('disc1 after Perc... '+disc1);
                    if(discVal.includes('-')){
                         variablePriceCheckFlag=false;
                         netResultVal= parseFloat(priceVal)-(parseFloat(disc1));
                    }else{
                         netResultVal= parseFloat(priceVal)-parseFloat(disc1);
                    }
                    console.log('netResultVal disc1 attt>> '+netResultVal);
                }
                else if(discType == ''){
                    disc1=discVal;
                    console.log('priceVal at else.. '+priceVal);
                    netResultVal=parseFloat(priceVal);
                } else if(discType == 'Absolute'){ 
                    disc1=discVal;
                    console.log('priceVal at else.. '+priceVal);
                    if(disc1.includes('-')){
                        variablePriceCheckFlag=false;
                        netResultVal=parseFloat(priceVal) - (parseFloat(disc1));
                    }else{
                        netResultVal=parseFloat(priceVal) - parseFloat(disc1);
                    }
                    
                }else if(discType == 'Override'){
					netResultVal = parseFloat(discVal);
                }
            
            	console.log('netResultVal after disc suptraction.. '+netResultVal);
                if(variablePrice!=null && variablePriceCheckFlag){
                    var vpriceRC = variablePrice;
                    console.log('vpriceRC.. '+vpriceRC);
                    if(parseFloat(disc1) > parseFloat(vpriceRC)){
                        netResultVal=parseFloat(priceVal);
                        discVal='';
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                        toastEvent.setParams({
                            title : 'error',
                            message: 'Discount should not be more than variable price('+vpriceRC+')',
                            type: 'error',
                        });
                        toastEvent.fire();
                    }
                } 
                this.commonMethodForPriceOverride(component,prodName,netResultVal,priceType,
                                                  discVal); 
            //}
        }
        else if(discVal!=undefined && discVal.length == 0)
        {
            var priceandVarPrice=priceVal.split('#');
            priceVal=priceandVarPrice[0];
            console.log('priceVal.>else. '+priceVal + 'prodName' + prodName);
            netResultVal=parseFloat(priceVal);
            console.log('priceVal is.>>.. '+netResultVal);
            this.commonMethodForPriceOverride(component,prodName,netResultVal,priceType,
                                              discVal); 
        }
    },
    
    
    
    /* doing the price override for RC and NRC */
    commonMethodForPriceOverride : function(component,prodName,netResultVal,priceType,
                                            discVal){
        var orderType;
        console.log('inside testtttt...'+prodName + '-' +netResultVal +
                    '-discVal' +discVal+'-prodName-'+prodName);
        component.set('v.priceSpinner',true); 
        console.log('component.get spinner..'+component.get('v.priceSpinner')); 
        var attrCmpString;
        var bigMap =component.get('v.QLIMap');
        //console.log('map stringify. bigmap before>. '+JSON.stringify(bigMap));
        this.updateOrOverrideBigMap(bigMap,prodName,netResultVal,priceType,discVal,component);
        console.log(' before update beack..>. '+JSON.stringify(bigMap));
        component.set('v.QLIMap',bigMap);//to update back check
        var finalmap = component.get('v.bigconMapUpdate');
          console.log('finalmap stringify. bigmap before>. '+JSON.stringify(finalmap));
        var selServiceName = component.get('v.selectedService'); 
        for(var i=0;i<finalmap.length;i++){
             orderType = finalmap[i].orderType;
            console.log('finalmap[i].key..'+finalmap[i].key+'selServiceName'+selServiceName);
            if(finalmap[i].key == selServiceName){
                finalmap[i].value = bigMap;
                break;
            }
        }
          for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
            console.log('bigMap map itr'+bigMap[mapListCtr].key);
            var bigPkgKey = bigMap[mapListCtr].key;
            var pkgAndprodName=prodName.split('#');
              if(pkgAndprodName[0]== bigPkgKey){
                    console.log('setting bigMap to conMap----'+JSON.stringify(bigMap[mapListCtr]));
                  component.set('v.con',bigMap[mapListCtr]);
              }
          }
        console.log('commonprice val shoppingcart helper.after.bigMap' + JSON.stringify(finalmap));
        var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
        priceDataAction.setParams({
            'productLineItemMapStr': JSON.stringify(finalmap)
        });
        priceDataAction.setCallback(this, function(priceResponse) {
            
            component.set('v.priceSpinner',false);
            console.log('priceResponse.getReturnValue().at inner Helper. '+priceResponse.getReturnValue());
             var priceEvent;
            console.log('orderType in accRec ..> '+orderType);
            if(orderType!=undefined && orderType!=null && orderType=='createOrder'){
                    priceEvent = $A.get("e.com_tcs_telecom:OrderPriceEvent");
                }else{
                    priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
                }
           
            priceEvent.setParams({
                "priceData" : priceResponse.getReturnValue()
            });
            priceEvent.fire();
            var offerOverridenDataList=component.get('v.overridenOfferList');
            console.log('offerOverridenDataList.after.bigMap>' + JSON.stringify(offerOverridenDataList));
            var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
            compEvent.setParams({
                "shoppingCartData" : bigMap,
                "selectedAttributes" :  component.get("v.attr"),
                "eventCheck" : true,
                "pkgOverridenList":offerOverridenDataList,
                "bigconMapUpdate" : component.get('v.bigconMapUpdate'),
                "selectedService" : component.get('v.selectedService'),
                "finalmap" : finalmap
            });
            compEvent.fire(); 
            
        });
        $A.enqueueAction(priceDataAction);
        
    },
    
    
    
    /* upadting the big map after price ovveride  
     * with the new values
     */
    updateOrOverrideBigMap : function(bigMap,prodName,netResultVal,priceType,discVal,component)
    {
        
        console.log('inside ..updateOrOverrideBigMa p  bigMap'+JSON.stringify(bigMap));
        
        for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
            console.log('bigMap map itr'+bigMap[mapListCtr].key);
            var bigPkgKey = bigMap[mapListCtr].key;
            var pkgAndprodName=prodName.split('#');
            
            console.log('bigMap[mapListCtr].key-'+bigMap[mapListCtr].key+'prodname is.. '+prodName+'-pkgAndprodName[0]-'+pkgAndprodName[0]);
            if(bigMap[mapListCtr].key == pkgAndprodName[0]){
                console.log('val.mapToList. '+bigMap[mapListCtr].value);
                var offerValues=bigMap[mapListCtr].value;
                var pkgquantity = bigMap[mapListCtr].quantity;
                var pkgquan = 1;
                if(pkgquantity!=undefined) {
                    pkgquan = pkgquantity;
                    
                }
                console.log('pkgquantity is.. '+pkgquantity);
                
                for(var ctr=0;ctr<offerValues.length;ctr++)
                {
                    var offerValueEach = offerValues[ctr];
                    if(offerValueEach.name!=undefined){
                        this.updateBigMap(offerValueEach,pkgquan,pkgAndprodName[1],discVal,netResultVal,priceType);
                    }
                    else if(offerValueEach.name == undefined){
                        var items = [];
                        //this.ifChildIsParent(offerValueEach,items);
                        this.childItselfMap(offerValueEach,items,pkgquan)
                        this.updateOrOverrideBigMap(items,prodName,netResultVal,priceType,discVal,component);
                    }
                    
                }
                break;
            }else{
                var offerValues=bigMap[mapListCtr].value;
                var items = [];
                for(var ctr=0;ctr<offerValues.length;ctr++)
                {
                    var offerValueEach = offerValues[ctr];
                    this.ifChildIsParent(offerValueEach,items);
                    var offerQtyMap = new Map();
                    for(var i=0;i<items.length;i++){
                        var valList = items[i].value;
                        for(var j=0;j<items.length;j++){
                            console.log('valList[j].quantity.accordian. '+items[i].key + '--'  +valList[j].quantity);
                            if(valList[j].Is_Package && valList[j].quantity!=null && valList[j].quantity!=undefined)
                            {
                                offerQtyMap.set(items[i].key,valList[j].quantity);
                                break;
                                
                            }else if(valList[j].Is_Package  && valList[j].quantity==undefined){
                                offerQtyMap.set(items[i].key,1);
                                break;
                            }
                        }
                    }
                    var  itemsNewList= [];
                    for(var i=0;i<items.length;i++){
                        itemsNewList.push({value:items[i].value, key:items[i].key,quantity:offerQtyMap.get(items[i].key)});
                    }
                    this.updateOrOverrideBigMap(itemsNewList,prodName,netResultVal,priceType,discVal,component);
                }
                
            }
        }
        
        
    },
    
    
   
    
    
    /* if Child Product itself as PArent
     */
    ifChildIsParent : function(offerValueEach,items)
    {
        console.log('inside ifChildIsParent.');
        if(offerValueEach.name == undefined){
            var response = offerValueEach;
            
            for( var key in response) 
            {
                console.log('offerval key .. '+key);
                items.push({value:response[key], key:key}); 
            }
            
        }
        console.log('items in json string.else condi. '+JSON.stringify(items));
    },
    
    
    
    /* updating the Big Map with the new prices*/
    updateBigMap : function(offerValueEach,pkgquan,prodName,discVal,netResultVal,priceType)
    {
        var tempQuan = pkgquan;
        if(offerValueEach.isAddon == true && offerValueEach.quantity != null && offerValueEach.quantity != undefined && offerValueEach.quantity != '') {
            tempQuan = pkgquan * offerValueEach.quantity;
        }
        console.log('offerValues[ctr].name.. '+offerValueEach.name + '>' +prodName + 'netresval>' +netResultVal);
        if(offerValueEach.name ==prodName){
            //previous decimal value is two decimals
            netResultVal=netResultVal.toFixed(2); 
            console.log('netResultVal is.a. '+netResultVal); 
            var matchedObj=offerValueEach;
            if(priceType == 'RC'){
                matchedObj.rcnetprice = netResultVal;
                matchedObj.rcdiscountedValue=discVal;
                matchedObj.rcnetprice = (matchedObj.rcnetprice)*(tempQuan);
                //previous decimal value is two decimals
                matchedObj.rcnetprice =  (matchedObj.rcnetprice).toFixed(2);
                
                //changed decimal value from two decimals to four decimals
                //matchedObj.rcnetprice =  (matchedObj.rcnetprice).toFixed(4);
                console.log('matchedObj.netprice.rc. '+matchedObj.rcnetprice +
                            '-'+ matchedObj.rcdiscountedValue);
            }else if(priceType == 'NRC'){
                matchedObj.nrcnetprice = netResultVal;
                matchedObj.nrcdiscountedValue=discVal;
                matchedObj.nrcnetprice = (matchedObj.nrcnetprice)*(tempQuan);
                 //previous decimal value is two decimals
                matchedObj.nrcnetprice =  (matchedObj.nrcnetprice).toFixed(2);
                //changed decimal value from two decimals to four decimals
               // matchedObj.nrcnetprice = (matchedObj.nrcnetprice).toFixed(4);
                console.log('matchedObj.netprice.nrc. '+matchedObj.nrcnetprice+
                            '-'+ matchedObj.nrcdiscountedValue);
            }
        }
    },
    
    
    
    /*update quantity 
     */
    updateQuantityForAddons : function(component,event,pkgNameOfQuantity,productOfferingId,quanvalue)
    {
        
        component.set('v.priceSpinner',true);
        var bigMap =component.get('v.QLIMap');
        console.log('map stringify. updateQuantityForAddons bigmap>. '+JSON.stringify(bigMap));
        if(bigMap!=null){
            for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
                console.log('bigMap map itr'+bigMap[mapListCtr].key);
                console.log('pkgNameOfQuantity is.. '+pkgNameOfQuantity);
                if(bigMap[mapListCtr].key == pkgNameOfQuantity){
                    console.log('val.mapToList. '+bigMap[mapListCtr].value);
                    var offerValues=bigMap[mapListCtr].value;
                    var packageQuan = 1;
                    for(var ctr=0;ctr<offerValues.length;ctr++)
                    {
                        var matchedObj=offerValues[ctr];
                        
                        if(matchedObj.name == pkgNameOfQuantity && matchedObj.quantity != undefined && matchedObj.quantity != null) {
                            packageQuan = matchedObj.quantity;
                        }
                        
                        else if(matchedObj.productOfferingId == productOfferingId){
                            if(quanvalue <= 0) {
                                matchedObj.quantity = 1;
                                quanvalue = 1;
                                var toastEvent = $A.get("e.force:showToast");
                                console.log('toastevent in  parentcomp'+toastEvent);
                                toastEvent.setParams({
                                    title : 'error',
                                    message: matchedObj.name+' quantity should not be zero or negative',
                                    type: 'error',
                                });
                                toastEvent.fire();
                            }
                            else if(quanvalue < matchedObj.minQuantity || quanvalue > matchedObj.maxQuantity) {
                                matchedObj.quantity = 1;
                                quanvalue = 1;
                                var toastEvent = $A.get("e.force:showToast");
                                console.log('toastevent in  parentcomp'+toastEvent);
                                toastEvent.setParams({
                                    title : 'error',
                                    message: matchedObj.name+' quantity should be in the range of '+matchedObj.minQuantity+' and '+matchedObj.maxQuantity,
                                    type: 'error',
                                });
                                toastEvent.fire();
                            } else {           
                                matchedObj.quantity = quanvalue;
                            }
                            quanvalue = quanvalue * packageQuan;
                            if(matchedObj.recurringCharge!=null && matchedObj.recurringCharge!=undefined){
                                matchedObj.rcnetprice = (matchedObj.recurringCharge)*quanvalue;
                                console.log('matchedObj.rcdiscountedValue s.. '+matchedObj.rcdiscountedValue);
                                if(matchedObj.rcdiscountedValue!=null && matchedObj.rcdiscountedValue!=undefined){
                                    if( matchedObj.rcdiscountedValue.includes("%")){
                                        matchedObj.rcdiscountedValue=matchedObj.rcdiscountedValue.substr
                                        (0,matchedObj.rcdiscountedValue.length-1);
                                        console.log('matchedObj.rcnetprice is.. '+matchedObj.rcnetprice);
                                        var discValue=(parseFloat(matchedObj.recurringCharge)*parseFloat(matchedObj.rcdiscountedValue)/100);
                                        console.log('discValue is.. '+discValue);
                                        matchedObj.rcnetprice =(matchedObj.recurringCharge)-discValue;
                                        matchedObj.rcnetprice =  (matchedObj.rcnetprice)*quanvalue;
                                        matchedObj.rcnetprice = (matchedObj.rcnetprice).toFixed(2);
                                        matchedObj.rcdiscountedValue= matchedObj.rcdiscountedValue+'%';
                                        console.log('matchedObj.rcdiscountedValue s.after. '+matchedObj.rcdiscountedValue + '->matchedObj.rcnetprice'+
                                                    matchedObj.rcnetprice);
                                    }else{
                                        console.log('discValue is..else '+  matchedObj.rcdiscountedValue);
                                        matchedObj.rcnetprice =(matchedObj.recurringCharge)-matchedObj.rcdiscountedValue;
                                        matchedObj.rcnetprice =  (matchedObj.rcnetprice)*quanvalue;
                                        matchedObj.rcnetprice = (matchedObj.rcnetprice).toFixed(2); 
                                        console.log('matchedObj.netprice.rc.else '+matchedObj.rcnetprice+
                                                    '-'+matchedObj.rcdiscountedValue + '-'+ matchedObj.recurringCharge);
                                    }
                                }else{
                                }
                            }
                            if(matchedObj.price!=null && matchedObj.price!=undefined){
                                matchedObj.nrcnetprice = (matchedObj.price)*quanvalue;
                                if(matchedObj.nrcdiscountedValue!=null && matchedObj.nrcdiscountedValue!=undefined){
                                    if( matchedObj.nrcdiscountedValue.includes("%")){
                                        matchedObj.nrcdiscountedValue=matchedObj.nrcdiscountedValue.substr
                                        (0,matchedObj.nrcdiscountedValue.length-1);
                                        var discValue=(parseFloat(matchedObj.price)*parseFloat(matchedObj.nrcdiscountedValue)/100);
                                        console.log('discValue is.. '+discValue);
                                        matchedObj.nrcnetprice =(matchedObj.price)-discValue;
                                        matchedObj.nrcnetprice =  (matchedObj.nrcnetprice)*quanvalue;
                                        matchedObj.nrcnetprice = (matchedObj.nrcnetprice).toFixed(2); 
                                        matchedObj.nrcdiscountedValue= matchedObj.nrcdiscountedValue+'%';
                                        console.log('matchedObj.rcdiscountedValue s.after. '+matchedObj.nrcdiscountedValue + '->matchedObj.nrcnetprice'+
                                                    matchedObj.nrcnetprice);
                                    }else{
                                        console.log('discValue is..else nrccc'+  matchedObj.nrcdiscountedValue);
                                        matchedObj.nrcnetprice =(matchedObj.price)-matchedObj.nrcdiscountedValue;
                                        matchedObj.nrcnetprice =  (matchedObj.nrcnetprice)*quanvalue;
                                        matchedObj.nrcnetprice = (matchedObj.nrcnetprice).toFixed(2);
                                        console.log('matchedObj.netprice.nnrc.else '+matchedObj.nrcnetprice+
                                                    '-'+matchedObj.nrcdiscountedValue + '-'+ matchedObj.price);
                                    }
                                }else{
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        var bigMap =component.get('v.QLIMap'); 
        component.set('v.QLIMap',bigMap);//to update back
        console.log('quantit val ..bigMap' + JSON.stringify(bigMap));
        
        
        var finalmap = component.get('v.bigconMapUpdate');
            var selServiceName = component.get('v.selectedService'); 
            for(var i=0;i<finalmap.length;i++){
                console.log('finalmap in qty[i].key..'+finalmap[i].key+'selServiceName'+selServiceName);
                if(finalmap[i].key == selServiceName){
                    console.log('b4 finalmap[i].value'+JSON.stringify(finalmap[i].value));
                    finalmap[i].value = bigMap;
                    console.log('after finalmap[i].value'+JSON.stringify(finalmap[i].value));
                }
            }
            console.log('after qty change after update into newbigmap'+JSON.stringify(finalmap));
            component.set('v.bigconMapUpdate',finalmap); 
        
        
        //component.set('v.bigconMapUpdate',finalmap); 
        component.set('v.priceSpinner',false);
        /*var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
        compEvent.setParams({
            "shoppingCartData" : bigMap,
            "selectedAttributes" :  component.get("v.attr")
        });
        compEvent.fire();*/
    },
    
    
    
   
    
    
    /*updating the attribute price */
    UpdateAttributePriceRec : function (bigMap,packageName,priceDetails)
    {
        if(packageName != null && packageName != undefined && priceDetails != null && priceDetails != undefined ) {
            var priceDetailObj = priceDetails[0];
            console.log('priceDetails[0].key'+priceDetailObj.key+'val'+priceDetailObj.value);
            var rcNrcVal  = priceDetailObj.value;
            var productSpec = priceDetailObj.key;
            var rc = rcNrcVal[0];
            var nrc = rcNrcVal[1];
            console.log('productSpec'+productSpec+'rc'+rc+'nrc'+nrc);
            for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
                var bigPkgKey = bigMap[mapListCtr].key;
                console.log('bigMap[mapListCtr].key-'+bigMap[mapListCtr].key+'prodname is.. '+productSpec+'-pkgAndprodName[0]-'+packageName);
                if(bigMap[mapListCtr].key == packageName){
                    var offerValues=bigMap[mapListCtr].value;
                    var pkgquantity = bigMap[mapListCtr].quantity;
                    var pkgquan = 1;
                    if(pkgquantity!=undefined) {
                        pkgquan = pkgquantity;
                    }
                    for(var ctr=0;ctr<offerValues.length;ctr++)
                    {
                        var offerValueEach = offerValues[ctr];
                        if(offerValueEach.name!=undefined){
                            if(offerValueEach.productOfferingId ==productSpec) {
                                var netResultVal = rc;
                                var priceType = 'RC';
                                var discVal = '0';
                                offerValueEach.rcnetprice = rc;
                                offerValueEach.nrcnetprice = nrc;
                                //added
                                	offerValueEach.price = nrc.toFixed(2);
                                 	offerValueEach.recurringCharge = rc.toFixed(2);
                                 console.log('offerValueEach.nrcdiscountedValue .. '+offerValueEach.nrcdiscountedValue);
                                
                                    if(offerValueEach.nrcdiscountedValue!=undefined){
                                          offerValueEach.nrcnetprice = offerValueEach.nrcnetprice-offerValueEach.nrcdiscountedValue;
                                    }
                                    console.log('pkgquan .. '+pkgquan);
                                    if(pkgquan!=undefined){
                                        offerValueEach.nrcnetprice  = offerValueEach.nrcnetprice * pkgquan;
                                    }
                                if(offerValueEach.rcdiscountedValue!=undefined){
                                          offerValueEach.rcnetprice = offerValueEach.rcnetprice-offerValueEach.rcdiscountedValue;
                                    }
                                   
                                    if(pkgquan!=undefined){
                                        offerValueEach.rcnetprice  = offerValueEach.rcnetprice * pkgquan;
                                    }
                                  	offerValueEach.nrcnetprice = (offerValueEach.nrcnetprice).toFixed(2);
                                    offerValueEach.rcnetprice = (offerValueEach.rcnetprice).toFixed(2);
                                //end
                                netResultVal = nrc;
                                priceType = 'NRC';
                            }
                        }
                        else if(offerValueEach.name == undefined){
                            var items = [];
                            this.childItselfMap(offerValueEach,items,pkgquan)
                            this.UpdateAttributePriceRec(items,packageName,priceDetails);
                        }
                    }
                    break;
                }else{
                    var offerValues=bigMap[mapListCtr].value;
                    var items = [];
                    for(var ctr=0;ctr<offerValues.length;ctr++)
                    {
                        var offerValueEach = offerValues[ctr];
                        this.ifChildIsParent(offerValueEach,items);
                        var  itemsNewList= [];
                        for(var i=0;i<items.length;i++){
                            itemsNewList.push({value:items[i].value, key:items[i].key,quantity:undefined});
                        }
                    }
                    
                    this.UpdateAttributePriceRec(itemsNewList,packageName,priceDetails);
                }
            }
            
        }
    },
    
    
    /*updating the attribute price */
    updateAttributePrice:function(component,event,attrListNew,bigMapfromAttrDisp)
    {  
        var orderType;
        //console.log('bigMapfromAttrDisp.attribute'+ JSON.stringify(bigMapfromAttrDisp));
        var packageName = event.getParam("pkgName");
        var firstLevelPkgName = component.get('v.packageKeyofFirstLevel');
        console.log('component con key.firstLevelPkgName.attribute'+ firstLevelPkgName);
        var pkgofferList=[];
        pkgofferList.push({value:packageName,key:firstLevelPkgName});
        component.set('v.overridenOfferList',pkgofferList);
        var  priceDetails = event.getParam("priceMap"); 
        var bigMap =component.get('v.QLIMap');  
       
        if(packageName != null && packageName != undefined && priceDetails != null && priceDetails != undefined && bigMap != null && bigMap != undefined) {
            this.UpdateAttributePriceRec(bigMap,packageName,priceDetails);
            component.set('v.QLIMap',bigMap);
            var finalmap = component.get('v.bigconMapUpdate');
            var selServiceName = component.get('v.selectedService'); 
            for(var i=0;i<finalmap.length;i++){
                  console.log('finalmap[i].orderType..'+finalmap[i].orderType);
                orderType = finalmap[i].orderType;
                console.log('finalmap[i].key..'+finalmap[i].key+'selServiceName'+selServiceName);
                if(finalmap[i].key == selServiceName){
                    finalmap[i].value = bigMap;
                    break;
                }
            }
            component.set('v.bigconMapUpdate',finalmap);
            var attrvalue = component.get("v.attr");
            console.log("b4 calling NewShoppingCartInnerToCartEvent"+JSON.stringify(attrvalue));
            component.set('v.priceSpinner',false);
            var offerOverridenDataList=component.get('v.overridenOfferList');
            console.log('commonprice val shoppingcart helper.after.bigMap' + JSON.stringify(finalmap));
            var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
            priceDataAction.setParams({
                'productLineItemMapStr': JSON.stringify(finalmap)
            });
            priceDataAction.setCallback(this, function(priceResponse) {
                component.set('v.priceSpinner',false);
                console.log('priceResponse.getReturnValue().at inner Helper. '+priceResponse.getReturnValue());
                console.log('orderType in accrecrsive.. '+orderType);
                var priceEvent;
                if(orderType!=undefined && orderType!=null && orderType=='createOrder'){
                    priceEvent = $A.get("e.com_tcs_telecom:OrderPriceEvent");
                }else{
                    priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
                }
                priceEvent.setParams({
                    "priceData" : priceResponse.getReturnValue()
                });
                priceEvent.fire();
                
                var offerOverridenDataList=component.get('v.overridenOfferList');
                
                var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
                compEvent.setParams({
                    "shoppingCartData" : bigMap,
                    "selectedAttributes" :  component.get("v.attr"),
                    "eventCheck" : true,
                    "pkgOverridenList":offerOverridenDataList,
                    "bigconMapUpdate" : component.get('v.bigconMapUpdate'),
                    "selectedService" : component.get('v.selectedService'),
                    "finalmap" : finalmap
                });
                compEvent.fire(); 
                
            });
            $A.enqueueAction(priceDataAction);
            
        }
        component.set('v.priceSpinner',false);
    },
    
    
    /*updating the  price according to quantity change*/
    
    updateQuantityToPrice : function(component,event,pkgNameOfQuantity,quanvalue,bigMap)
    {
        component.set('v.priceSpinner',true);
        console.log('map stringify. updateQuantityToPrice bigmap>. '+JSON.stringify(bigMap));
        if(bigMap!=null){
            for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
                console.log('bigMap map itr'+bigMap[mapListCtr].key +'pkgNameOfQuantity are.. '+pkgNameOfQuantity);
                console.log('pkgNameOfQuantity is.. '+pkgNameOfQuantity);
                if(bigMap[mapListCtr].key == pkgNameOfQuantity){
                    console.log('quanvalue is.. '+quanvalue);
                    bigMap[mapListCtr].quantity=quanvalue;
                    console.log('val.mapToList. '+bigMap[mapListCtr].value);
                    var offerValues=bigMap[mapListCtr].value;
                    for(var ctr=0;ctr<offerValues.length;ctr++)
                    {
                        var tempQuan = quanvalue;
                        var matchedObj=offerValues[ctr];
                        console.log('matchedObj.quantity->- ' +matchedObj.quantity );
                        if(matchedObj.name == pkgNameOfQuantity){
                            matchedObj.quantity = tempQuan;
                        }
                        if(matchedObj.name != undefined && matchedObj.name != pkgNameOfQuantity) {
                            if(matchedObj.quantity != null && matchedObj.quantity != undefined && matchedObj.quantity != '') {
                                tempQuan = quanvalue * matchedObj.quantity;
                            }
                        }
                        console.log('matchedObj.tempQuan->- ' +tempQuan);
                        console.log('matchedObj.name.. '+matchedObj.name);
                        if(matchedObj.name!=undefined){
                            this.setRCData(matchedObj,tempQuan);
                            this.setNRCData(matchedObj,tempQuan);
                        }
                        else if(matchedObj.name == undefined){
                            var items = [];
                            this.childItselfMap(matchedObj,items,tempQuan);
                            var pkgKey;
                            for(var i=0;i<items.length;i++)
                            {
                                pkgKey =items[i].key;
                            }
                            console.log('pkgKey is.. '+pkgKey + ' tempQuan' +tempQuan);
                            this.updateQuantityToPrice(component,event,pkgKey,tempQuan,items);
                        }
                    }
                    
                }
                
            }
            console.log('after qty change b4 update into newbigmap'+JSON.stringify(bigMap));
            var finalmap = component.get('v.bigconMapUpdate');
            var selServiceName = component.get('v.selectedService'); 
            for(var i=0;i<finalmap.length;i++){
                console.log('finalmap in qty[i].key..'+finalmap[i].key+'selServiceName'+selServiceName);
                if(finalmap[i].key == selServiceName){
                    console.log('b4 finalmap[i].value'+JSON.stringify(finalmap[i].value));
                    finalmap[i].value = bigMap;
                    console.log('after finalmap[i].value'+JSON.stringify(finalmap[i].value));
                }
            }
            console.log('after qty change after update into newbigmap'+JSON.stringify(finalmap));
            component.set('v.bigconMapUpdate',finalmap); 
            var firstLevelPkgName = component.get('v.packageKeyofFirstLevel');
            console.log('component con key.firstLevelPkgName.'+ firstLevelPkgName);
            var pkgofferList=[];
            console.log('pkgNameOfQuantity..at '+pkgNameOfQuantity);
            var existOfferList = component.get('v.overrideList');
            console.log('existOfferList is.. '+existOfferList);
            if(existOfferList!=undefined && existOfferList.length > 0){
                console.log('existOfferList is o val.. '+existOfferList[0].key);
                if(existOfferList[0].key == firstLevelPkgName){
                    component.set('v.overridenOfferList',existOfferList);
                }else{
                    pkgofferList.push({value:pkgNameOfQuantity,key:firstLevelPkgName});
                    component.set('v.overridenOfferList',pkgofferList);
                }
            }else{
                pkgofferList.push({value:pkgNameOfQuantity,key:firstLevelPkgName});
                component.set('v.overridenOfferList',pkgofferList);
            }	
        }
    },
    
    
    /*checking whether its BOB or normal product */
    childItselfMap : function(offerValueEach,items,tempQuan)
    {
        console.log('inside ifChildIsParent.');
        if(offerValueEach.name == undefined){
            var response = offerValueEach;
            
            for( var key in response) 
            {
                console.log('offerval key .. '+key);
                items.push({value:response[key], key:key,quantity:tempQuan}); 
            }
            
        }
        console.log('items in json string.else condi. '+JSON.stringify(items));
    },
    
    /*setting the RC prices */
    setRCData : function(matchedObj,tempQuan){
        if(matchedObj.recurringCharge!=null && matchedObj.recurringCharge!=undefined){
            matchedObj.rcnetprice = (matchedObj.recurringCharge)*tempQuan;
            
            console.log('matchedObj.rcdiscountedValue s.. '+matchedObj.rcdiscountedValue);
            if(matchedObj.rcdiscountedValue!=null && matchedObj.rcdiscountedValue!=undefined){
                if( matchedObj.rcdiscountedValue.includes("%")){
                    matchedObj.rcdiscountedValue=matchedObj.rcdiscountedValue.substr
                    (0,matchedObj.rcdiscountedValue.length-1);
                    console.log('matchedObj.rcnetprice is.. '+matchedObj.rcnetprice);
                    var discValue=(parseFloat(matchedObj.recurringCharge)*parseFloat(matchedObj.rcdiscountedValue)/100);
                    console.log('discValue is.. '+discValue);
                    matchedObj.rcnetprice =(matchedObj.recurringCharge)-discValue;
                    matchedObj.rcnetprice =  (matchedObj.rcnetprice)*tempQuan;
                    matchedObj.rcnetprice = (matchedObj.rcnetprice).toFixed(2); 
                    matchedObj.rcdiscountedValue= matchedObj.rcdiscountedValue+'%';
                    console.log('matchedObj.rcdiscountedValue s.after. '+matchedObj.rcdiscountedValue + '->matchedObj.rcnetprice'+
                                matchedObj.rcnetprice);
                }else{
                    
                    console.log('discValue is..else '+  matchedObj.rcdiscountedValue);
                    matchedObj.rcnetprice =(matchedObj.recurringCharge)-matchedObj.rcdiscountedValue;
                    matchedObj.rcnetprice =  (matchedObj.rcnetprice)*tempQuan;
                    matchedObj.rcnetprice = (matchedObj.rcnetprice).toFixed(2);
                    console.log('matchedObj.netprice.rc.else '+matchedObj.rcnetprice+
                                '-'+matchedObj.rcdiscountedValue + '-'+ matchedObj.recurringCharge);
                }
            }else{
                matchedObj.rcnetprice = (matchedObj.rcnetprice).toFixed(2);
            }
        }
        
    },
    
    
    /*setting the NRC prices */
    setNRCData : function(matchedObj,tempQuan){
        if(matchedObj.price!=null && matchedObj.price!=undefined){
            matchedObj.nrcnetprice = (matchedObj.price)*tempQuan;
            if(matchedObj.nrcdiscountedValue!=null && matchedObj.nrcdiscountedValue!=undefined){
                if( matchedObj.nrcdiscountedValue.includes("%")){
                    matchedObj.nrcdiscountedValue=matchedObj.nrcdiscountedValue.substr
                    (0,matchedObj.nrcdiscountedValue.length-1);
                    var discValue=(parseFloat(matchedObj.price)*parseFloat(matchedObj.nrcdiscountedValue)/100);
                    console.log('discValue is.. '+discValue);
                    matchedObj.nrcnetprice =(matchedObj.price)-discValue;
                    matchedObj.nrcnetprice =  (matchedObj.nrcnetprice)*tempQuan;
                    matchedObj.nrcnetprice = (matchedObj.nrcnetprice).toFixed(2); 
                    matchedObj.nrcdiscountedValue= matchedObj.nrcdiscountedValue+'%';
                    console.log('matchedObj.rcdiscountedValue s.after. '+matchedObj.nrcdiscountedValue + '->matchedObj.nrcnetprice'+
                                matchedObj.nrcnetprice);
                }else{
                    console.log('discValue is..else nrccc'+  matchedObj.nrcdiscountedValue);
                    matchedObj.nrcnetprice =(matchedObj.price)-matchedObj.nrcdiscountedValue;
                    matchedObj.nrcnetprice =  (matchedObj.nrcnetprice)*tempQuan;
                    matchedObj.nrcnetprice = (matchedObj.nrcnetprice).toFixed(2); 
                    console.log('matchedObj.netprice.nnrc.else '+matchedObj.nrcnetprice+
                                '-'+matchedObj.nrcdiscountedValue + '-'+ matchedObj.price);
                }
            }else{
                matchedObj.nrcnetprice = (matchedObj.nrcnetprice).toFixed(2); 
            }
        }
    },
    
    
    /* for  Opt_In and Opt_Out products
     */
    commonMethodForCheckBox:function(component,event,prodName,checkboxStatus)
    {
        console.log('in commonMethodForCheckBox attr:'+JSON.stringify(component.get("v.attr")));
        console.log('commonMethodForCheckBox prodName .. '+prodName + '-' +checkboxStatus);
        component.set('v.priceSpinner',true);
        var pkgAndprodName=prodName.split('#');
        console.log('pkgAndprodName.commonMethodForCheckBox.'+pkgAndprodName);
        var firstLevelPkgName = component.get('v.packageKeyofFirstLevel');
        console.log('component con key.firstLevelPkgName.'+ firstLevelPkgName);
        var pkgofferList=[];
        var pkgname=pkgAndprodName[0];
        console.log('pkgname.. '+pkgname);
        pkgofferList.push({value:pkgname,key:firstLevelPkgName});
        component.set('v.overridenOfferList',pkgofferList);
        var attrCmpString='';
        var bigMap =component.get('v.QLIMap');
        if(bigMap!=null && bigMap!=undefined && prodName!=null && prodName!=undefined ){
            attrCmpString = this.updateCheckboxRec(bigMap,prodName,checkboxStatus,firstLevelPkgName);
            console.log('attrCmpString'+attrCmpString);
            var attrvalue = component.get("v.attr");
            console.log("attr b4 splice"+JSON.stringify(attrvalue));
            for (var i= 0; i<attrvalue.length;i++) {
                console.log('commonMethodForCheckBox attrvalue[a].key'+attrvalue[i].key+'   attrCmpString'+attrCmpString);
                if(attrCmpString!= undefined && attrCmpString == attrvalue[i].key) {
                    attrvalue.splice(i,1);
                }
            }
            console.log("attr after splice"+JSON.stringify(attrvalue));
        }
        component.set('v.QLIMap',bigMap);
        component.set('v.attr',attrvalue);
        var finalmap = component.get('v.bigconMapUpdate');
        console.log('BIGMAP $$$$$$#'+JSON.stringify(bigMap));
        console.log('bigconMapUpdate before TTTTTT'+JSON.stringify(component.get('v.bigconMapUpdate')));
        var selServiceName = component.get('v.selectedService'); 
        for(var i=0;i<finalmap.length;i++){
            console.log('finalmap[i].key..'+finalmap[i].key+'selServiceName in checkbox'+selServiceName);
            if(finalmap[i].key == selServiceName){
                finalmap[i].value = bigMap;
                break;
            }
        }
        console.log('bigconMapUpdate after TTTTTT'+JSON.stringify(finalmap));
        component.set('v.bigconMapUpdate',finalmap);
    },
    
    
    
    updateCheckboxRec : function (bigMap,prodName,checkboxStatus,firstLevelPkgName)
    {
        var attrCmpString;
        console.log('inside ..updateCheckboxRec MAP'+JSON.stringify(bigMap));
        console.log(' in updateCheckboxRec packageName'+prodName+'attrCmpString:'+attrCmpString);
        var pkgAndprodName=prodName.split('#');
        for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
            console.log('bigMap map itr'+bigMap[mapListCtr].key);
            var bigPkgKey = bigMap[mapListCtr].key;
            console.log('packageKey---------'+firstLevelPkgName+'---'+pkgAndprodName[2]);
            if(firstLevelPkgName == pkgAndprodName[2]){
            if(bigMap[mapListCtr].key == pkgAndprodName[0]){
                console.log('val.mapToList. '+bigMap[mapListCtr].value);
                var offerValues=bigMap[mapListCtr].value;
                var pkgquantity = bigMap[mapListCtr].quantity;
                var pkgquan = 1;
                if(pkgquantity!=undefined) {
                    pkgquan = pkgquantity;
                    
                }
                console.log('pkgquantity is.. '+pkgquantity);
                
                for(var ctr=0;ctr<offerValues.length;ctr++)
                {
                    var offerValueEach = offerValues[ctr];
                      console.log('OOOOO offerValues[ctr]*** '+offerValues[ctr]);
                    console.log('OOOOO offerValues[ctr].name'+offerValues[ctr].name+'pkgAndprodName[1]' +pkgAndprodName[1]);
                    if(offerValueEach.name!=undefined && offerValues[ctr].name == pkgAndprodName[1]){
                        var matchedObj=offerValues[ctr];
                        console.log('offerValueEach.name'+offerValueEach.name+'pkgAndprodName[1] after'+pkgAndprodName[1]+'mandatory:'+matchedObj.mandatory+'checkboxStatus'+checkboxStatus);
                        attrCmpString = pkgAndprodName[0]+matchedObj.productOfferingId;
                        console.log('attrCmpString inside'+attrCmpString);
                        if(matchedObj.mandatory  == 'OptIn' && checkboxStatus) {
                            matchedObj.mandatory  = 'OptOut';
                            matchedObj.rcnetprice = matchedObj.recurringCharge*pkgquan;
                            matchedObj.nrcnetprice = matchedObj.price;
                        }  
                        else if(matchedObj.mandatory  == 'OptOut' && !checkboxStatus)
                        {
                            matchedObj.mandatory  = 'OptIn';
                            matchedObj.rcnetprice = matchedObj.recurringCharge*pkgquan;
                            matchedObj.nrcnetprice = matchedObj.price;
                           /* matchedObj.nrcdiscountedValue=0;
                            matchedObj.rcdiscountedValue=0;
                            matchedObj.nrcdiscountType="";
                            matchedObj.rcdiscountType=""; */
                            
                        }
                        console.log('offerValueEach'+JSON.stringify(offerValueEach));
                        break;      
                    }
                    else if(offerValueEach.name == undefined){
                        console.log('in inner else');
                        var items = [];
                        this.childItselfMap(offerValueEach,items,pkgquan);
                        attrCmpString = this.updateCheckboxRec(items,prodName,checkboxStatus,firstLevelPkgName);
                    }
                    
                }
                break;
            }else{
                console.log('in outer else');
                var offerValues=bigMap[mapListCtr].value;
                var items = [];
                for(var ctr=0;ctr<offerValues.length;ctr++)
                {
                    var offerValueEach = offerValues[ctr];
                    this.ifChildIsParent(offerValueEach,items);
                    var offerQtyMap = new Map();
                    for(var i=0;i<items.length;i++){
                        var valList = items[i].value;
                        for(var j=0;j<items.length;j++){
                            console.log('valList[j].quantity.accordian. '+JSON.stringify(valList[j]));
                            if(valList[j]!=null && valList[j]!=undefined){
                               if(valList[j].Is_Package && valList[j].quantity!=null && valList[j].quantity!=undefined)
                            	{
                                    offerQtyMap.set(items[i].key,valList[j].quantity);
                                    break;
                                
                            	}else if(valList[j].Is_Package  && valList[j].quantity==undefined){
                                    offerQtyMap.set(items[i].key,1);
                                    break;
                            	}
                            }
                            
                            
                        }
                    }
                    var  itemsNewList= [];
                    for(var i=0;i<items.length;i++){
                        itemsNewList.push({value:items[i].value, key:items[i].key,quantity:offerQtyMap.get(items[i].key)});
                    }
                    
                }
                
                attrCmpString =  this.updateCheckboxRec(itemsNewList,prodName,checkboxStatus,firstLevelPkgName);
            }
            }
        }
        console.log('AAA attrCmpString'+attrCmpString);
        return attrCmpString;   
    }, 
    
    getPriceData : function(component, event,finalmap,bigMap,selParentProdOfferId){
        console.log('inside getpricedata..>'+JSON.stringify(finalmap)); 
        	 var orderType;
        	 var finalmap = component.get('v.bigconMapUpdate');
            for(var i=0;i<finalmap.length;i++){
             orderType = finalmap[i].orderType;
            }

        var priceDataActionn = component.get("c.getPriceCalculationRevampForBOB");
        priceDataActionn.setParams({
            'productLineItemMapStr': JSON.stringify(finalmap)
        });
        priceDataActionn.setCallback(component, function(response) {
            
            
            console.log('priceResponse.getReturnValue().at delete Helper '+response.getReturnValue());
           
            
            	var priceEvent;
               if(orderType!=undefined && orderType!=null && orderType=='createOrder'){
                    priceEvent = $A.get("e.com_tcs_telecom:OrderPriceEvent");
                }else{
                    priceEvent = $A.get("e.com_tcs_telecom:PriceEvent");
                }
           	    priceEvent.setParams({
            		    "priceData" : response.getReturnValue()
            	});
                priceEvent.fire();

            var quoteID = component.get("v.quoteRecId");
            var currentVersion = component.get("v.currentVersion");
            var selServiceName = component.get('v.selectedService'); 
            console.log('before delete .in getprice. '+JSON.stringify(bigMap))
            console.log('selParentProdOfferId is.. '+selParentProdOfferId + '-quoteID- '+quoteID
                        +'currentVersion.. '+currentVersion + 'selServiceName.. '+selServiceName);
           //
            var deleteaAction = component.get("c.deleteOfferFromDBAgainstToServiceTypeFromUI");
            deleteaAction.setParams({
                'parentProdOfferId': selParentProdOfferId,
                'quoteID' : quoteID,
                'quoteVersion':currentVersion,
                'serviceType':selServiceName
            });
            deleteaAction.setCallback(this, function(deleteOfferResponse) {
                
                console.log('response.state.. '+deleteOfferResponse.getState());    
                console.log('response-deleteaAction ->'+JSON.stringify(deleteOfferResponse.getReturnValue()));
                console.log('bigMap.length ->'+bigMap.length);
                console.log('finalMap.length ->'+finalmap.length);
                if(bigMap.length == 0)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'No Offers Available To Delete,Please Select Other Service',
                        type: 'success',
                    });
                    toastEvent.fire();
                }   
                
            });
            $A.enqueueAction(deleteaAction); 
            //
            component.set("v.QLIMap",bigMap);
            component.set('v.deletespinner',false);
        });
        $A.enqueueAction(priceDataActionn);
    },
    
    
    /* getting the packages name which should be deleted 
        * delete it from the big Map and update the Map 
        * after deleting
        */
    
 delete : function(component, event,pkgNameTobeDelete){
    var selServiceName = component.get('v.selectedService'); 
    console.log('inside delete..>>.'+pkgNameTobeDelete);
    var bigMap =component.get('v.QLIMap');
    var allProdArray = new Map();
    console.log('map stringify. bigmap> before.delete '+JSON.stringify(bigMap));
    if(bigMap!=null){
    console.log('map stringify. bigmap> before.delete length'+bigMap.length);
    for(var mapListCtr=0;mapListCtr<bigMap.length;mapListCtr++){
    console.log('bigMap map itr'+bigMap[mapListCtr].key );
    allProdArray.set(bigMap[mapListCtr].key,bigMap[mapListCtr].value);
    if(bigMap[mapListCtr].key == pkgNameTobeDelete){
    console.log('matched pkg. '+bigMap[mapListCtr].key);
    bigMap.splice(mapListCtr,1);
    console.log('after splicelength'+bigMap.length);
    break;
		}
 	}
 }
 var pkgProdMapValues=allProdArray.get(pkgNameTobeDelete);
    var selProdOfferId;    
    var selParentProdOfferId;
for (var i = 0; i < pkgProdMapValues.length; i++)
{
    console.log('pkgProdMapValues[i] .. '+pkgProdMapValues[i].name);
    if(pkgProdMapValues[i].name == pkgNameTobeDelete){
        console.log('pkgProdMapValues[i].productOfferingId__c[i] .. '+pkgProdMapValues[i].productOfferingId);
        selProdOfferId=pkgProdMapValues[i].productOfferingId;
        selParentProdOfferId=pkgProdMapValues[i].parentproductOfferingId;
        break;  
    }
}
console.log('after delete..bigMap' + JSON.stringify(bigMap));
var attrvalue = component.get("v.attr");
console.log('in delete NEW'+JSON.stringify(attrvalue));
if(attrvalue!=undefined) {
    for (var i=attrvalue.length-1; i>=0;i--) {
        if(pkgNameTobeDelete!= undefined &&  (attrvalue[i].key).indexOf(pkgNameTobeDelete) != -1) {
            attrvalue.splice(i,1);
        }
    }
}
var finalmap = component.get('v.bigconMapUpdate');
console.log('final map before...'+JSON.stringify(finalmap));
for(var i=0;i<finalmap.length;i++){
    console.log('finalmap in delete [i].key..'+finalmap[i].key+'selectedservicename'+selServiceName);
    component.set('v.currentselectedService',finalmap[i].key);
    if(finalmap[i].key == selServiceName){
       console.log('inside if ..'+finalmap[i].key);
        finalmap[i].value = bigMap;
        break;
    }
}
component.set('v.bigconMapUpdate',finalmap);
console.log('final map after...'+JSON.stringify(finalmap));
this.getPriceData(component, event,finalmap,bigMap,selParentProdOfferId); 

},
    
getCustomSettingsData : function(component, event)
{
    var customSetDetailsAction=component.get('c.getCustomSettings');
   
    customSetDetailsAction.setCallback(this, function(actionResult) {
    console.log('actionResult.getReturnValue..'+actionResult.getReturnValue());
    component.set("v.customSetDetails", actionResult.getReturnValue());
    });
   $A.enqueueAction(customSetDetailsAction);
}
    
})