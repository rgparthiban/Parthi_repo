({
    display : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    
    displayOut : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    
    /* for accordion functionality */
    sectionOne : function(component, event, helper) {
        console.log('inside sectionOne');
        helper.helperFun(component,event,'articleOne');
        
    },
    /* loading the shopping cart initially */
    doInit: function(component,event,helper){
        
        // component.set('v.SpinnerToStop',true);
        var overrideLists=component.get('v.overrideList');
        if(overrideLists!=undefined && overrideLists.length>0)
        {
            component.set('v.decimalFlag',false);
        }
        console.log('attr in doInit'+JSON.stringify(component.get("v.attr")));
        
        var packageKey=component.get('v.packageKeyofFirstLevel');
        console.log('packageKey at rec comp.. '+packageKey);
        console.log('packageKey at rec value.. '+JSON.stringify(component.get("v.con")));
        var backAndFwdSatus = component.get('v.backAndFwd');
        var checkstatsinit = component.get('v.initCheck');
        
        console.log('backAndFwdSatus.>>. '+backAndFwdSatus);
        component.set('v.backAndFwd',backAndFwdSatus);
        if(backAndFwdSatus){
            component.set('v.classCheck','slds-hide slds-p-around--xx_small');
        }else{
            component.set('v.classCheck','slds-show slds-p-around--xx_small');
            
        }
        var bigmapLength=component.get('v.bigmapLength');
        var bigmapIndex=component.get('v.bigmapIndex');
        console.log('bigmapLength is..reccomp  chn'+bigmapLength + 'and bigmapIndex is.. '+bigmapIndex);
        var flag =false;
        if(bigmapLength!=undefined)
        {
            var lastElementofSize = bigmapLength-1;
            console.log('lastElementofSize.. '+lastElementofSize + '-'+component.get('v.bigmapSpinner'));
            if(lastElementofSize == bigmapIndex){
                console.log('stop spinner..in if..');
                flag=true;
            }
        }
        console.log('flag,,'+flag);
        if(flag){
            component.set('v.bigmapSpinner',false);
        }
        console.log('spinner status.... '+component.get('v.bigmapSpinner'));
        component.set('v.initCheck','true');
		console.log('v.con.key---'+JSON.stringify(component.get('v.con')));
        helper.getCustomSettingsData(component, event);	
        
        
        
        

        //Nancy 
       /*var action =component.get("c.setPackagePricingFlag1");
        var conMap= component.get("v.con");
        console.log('conMap----------'+JSON.stringify(conMap));
        action.setParams({
            'conMap':conMap
        });
        
        action.setCallback(this, function(response) {
            console.log('response conMap=---->'+JSON.stringify(response.getReturnValue()));
            if(response.getReturnValue() != null) {
                component.set("v.con", response.getReturnValue());
            }
        });
        $A.enqueueAction(action); */ 
        
        
        
        /*
 * var spinnerEvent =
 * $A.get("e.com_tcs_telecom:AccRecToOrderParentSpinnerEvent");
 * spinnerEvent.setParams({ "accRecToOrderParent" : true
 * 
 * }); spinnerEvent.fire();
 */
    
    
    
},
    
    
    
    /*
 * fetching attributes based on the packages and services calling the
 * AttributeDisplay component
 */
    loadAttribute : function(component,event) {
        var firstLevelPkgkey=component.get('v.packageKeyofFirstLevel');
        var bigMap =component.get('v.QLIMap');
        console.log('bigmap before attr display .. '+JSON.stringify(bigMap));
        // console.log('bigma'+JSON.stringify(component.get("v.con")))
        console.log('prodOfferingID'+event.getSource().get("v.value")+'pkgName'+event.getSource().get("v.name")+'selected attr'+JSON.stringify(component.get("v.attr")));
        component.set('v.body','');
        $A.createComponent("com_tcs_telecom:AttributeDisplay", {
            "prodSpecIdData" : event.getSource().get("v.value"),
            "pkgName" : event.getSource().get("v.name"),
            "selAttributes" : component.get("v.attr"),
            "bigMap" : bigMap,
            "firstLevelPkgName" : firstLevelPkgkey,
            "selectedService" : component.get("v.selectedService"),
            "quoteId" : component.get("v.quoteRecId")
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                var target = component.get('v.body');
                target.push(contentComponent);
                component.set('v.body', target);
                component.set('v.isOpen', true);
                console.log('target resp.. '+JSON.stringify(target));
                
            } else {
                console.log('in error');
                throw new Error(error);
            }
        });
    },
    
    
    
    
    
    
    
    /* closing the attribute modal */
    closeAttr:function(component,event,helper)
    {
        component.set("v.isOpen", false);
    },
    
    
    /*
 * getting the attribute value through attribute event and setting the value to
 * existing list
 */
    setAttributeValue:function(component,event,helper)
    {
        var attrListNew = [];
        var attrvalue= event.getParam("Attribute");
        console.log('Attribute is..  '+JSON.stringify(attrvalue));
        var bigMapfromAttrDisp= event.getParam("bigMap");
        console.log('bigMapfromAttrDisp is..  '+JSON.stringify(bigMapfromAttrDisp));
        for ( var key in attrvalue ) {
            attrListNew.push({value:attrvalue[key].attributes, key:attrvalue[key].product});
        }
        component.set('v.attr',attrListNew);
        component.set("v.isOpen", false);
        helper.updateAttributePrice(component,event,attrvalue,bigMapfromAttrDisp); 
        
        console.log('QLIMap after updateAttributePrice'+JSON.stringify(component.get("v.QLIMap")));
        
    },
    
  
    /*
 * it will calculate and update back netresultValue after priceOverride
 */
    priceOverrideRC:function(component,event,helper)
    {
        console.log('inside priceOverrideRC-..');
        var priceType= 'RC';					  		
        var listofoffersandprods=[];
        var revpricedatatoupdate=[];
        var valueList = [];
        var discountType= component.find('priceOverrideRCDiscType');
        var priceRC= component.find('priceOverrideRC');
        var hiddenPriceRC= component.find('hiddenForPriceRC');
        var customSetData=component.get('v.customSetDetails');
        
      var NegativeDiscountsAllowed = 'YES';  
      var nameRegex ='';
      //if(customSetData.com_tcs_telecom__NegativeDiscountsAllowed__c == 'YES'){
      if(NegativeDiscountsAllowed == 'YES'){
          nameRegex  = '((^(?!-$)|^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))'; 
      }  
      else{
          nameRegex  = '((^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))';
      }
      var genRegEx = '((^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))'; 
          var genRegexExp = new RegExp(genRegEx);
        	var regex = new RegExp(nameRegex);
        if(priceRC != undefined){
            if(priceRC instanceof Array) {
                console.log('inside array override..');
                for (var i=0;i<priceRC.length;i++) {
                    var discVal;
                    var priceVal;
                    var prodName;
                     var discType;
                       if(priceRC[i] != undefined && discountType[i]!= undefined){
                    discVal=priceRC[i].get('v.value');
                    discType=discountType[i].get('v.value');
                    console.log('discVal.. '+discVal+'------'+discType);
                    for (var j=i;j<=i;j++){
                     console.log('hiddenPriceRC[j].. '+hiddenPriceRC[j]);
                      if(hiddenPriceRC[j] != undefined){
                        priceVal=hiddenPriceRC[j].get('v.value');
                        prodName=hiddenPriceRC[j].get('v.name');
                        }
                    }
                    if(discType!='Override' && (discVal== undefined || discVal == '' ||(discVal != undefined && regex.test(discVal)))){
                        helper.discountValidation(priceVal,prodName,discVal,priceType,component,discType);
                     }else if(discType == 'Override' && (discVal== undefined || discVal == '' ||(discVal != undefined && genRegexExp.test(discVal)))){
                        helper.discountValidation(priceVal,prodName,discVal,priceType,component,discType);
                     }
                     else{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                       if(discVal != undefined && !regex.test(discVal)) {
                        toastEvent.setParams({
                            title : 'error',
                            message: 'Enter only numerical discount value up to 2  digits',
                            type: 'error',
                        });
                        toastEvent.fire();
                        }
                    }
                    }
                }
            }
            else if(hiddenPriceRC != undefined && priceRC != undefined){
                var discVal;
                var priceVal;
                var prodName;
                var discType;
                discVal=priceRC.get('v.value');
                priceVal=hiddenPriceRC.get('v.value');
                prodName=hiddenPriceRC.get('v.name');            
                discType=discountType.get('v.value');
                console.log('discType..'+discType);
                
                    if(discVal== undefined || discVal == '' ||(discVal != undefined && regex.test(discVal)) ){
                        helper.discountValidation(priceVal,prodName,discVal,priceType,component,discType);
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                        if(discVal != undefined && !regex.test(discVal)) {
                        toastEvent.setParams({
                            title : 'error',
                            message: 'Enter only numerical discount value up to 2  digits',
                            type: 'error',
                        });
                        toastEvent.fire();
                        }
                    }
              
            }
        }
    },
    
    
    
    /*
 * it will calculate and update back netresultValue after priceOverride for NRC
 */
   
 priceOverrideNRC:function(component,event,helper)
  {
    var customSetData=component.get('v.customSetDetails');
    //console.log('com_tcs_telecom__NegativeDiscountsAllowed__c..'+customSetData.com_tcs_telecom__NegativeDiscountsAllowed__c);
    var priceType= 'NRC';					  		
    var listofoffersandprods=[];
    var revpricedatatoupdate=[];
    var valueList = [];
    var priceNRC= component.find('priceOverrideNRC');
    var hiddenPriceNRC= component.find('hiddenForPriceNRC');
    var discountType= component.find('priceOverrideNRCDiscType');
    var NegativeDiscountsAllowed = 'YES';  
      var nameRegex ='';
      //if(customSetData.com_tcs_telecom__NegativeDiscountsAllowed__c == 'YES'){
      if(NegativeDiscountsAllowed == 'YES'){
          nameRegex  = '((^(?!-$)|^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))'; 
      }  
      else{
          nameRegex  = '((^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))';
      }

     
//    //changed decimal value from two decimals to four decimals
 			var genRegEx = '((^101$|\\b(?!0+(?:\\.0+)?%)(^\\d{0,3}(\\.\\d{1,2})? *%?$))|(^[0-9]+(\\.[0-9]{1,2})?$))'; 
           var genRegexExp = new RegExp(genRegEx);   
    var regex = new RegExp(nameRegex);
    if(priceNRC != undefined){
        if(priceNRC instanceof Array) {
            console.log('inside array override.NRC.'+discountType);
            for (var i=0;i<priceNRC.length;i++) {
                var discVal;
                var priceVal;
                var prodName;
                var discType;
                discVal=priceNRC[i].get('v.value');
                discType=discountType[i].get('v.value');
                 console.log('discType..'+discType +"--"+discVal);
                for (var j=i;j<=i;j++){
                    priceVal=hiddenPriceNRC[j].get('v.value');
                    prodName=hiddenPriceNRC[j].get('v.name');
                }   if(discVal== undefined || discVal == '' ||(discVal != undefined && regex.test(discVal)) ){
                        helper.discountValidation(priceVal,prodName,discVal,priceType,component,discType);
                    }
                else if(discType == 'Override' && (discVal== undefined || discVal == '' ||(discVal != undefined && genRegexExp.test(discVal)))){
                        helper.discountValidation(priceVal,prodName,discVal,priceType,component,discType);
                     }
                else{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                        if(discVal != undefined && !regex.test(discVal)) {
                        toastEvent.setParams({
                            title : 'error',
                            message: 'Enter only numerical discount value up to 2 digits',
                            type: 'error',
                        });
                        toastEvent.fire();
                        }
                    }
                
            }
        }
        else if(hiddenPriceNRC != undefined && priceNRC != undefined){
            
            console.log('inside else override..'+discountType.get('v.value'));
            var discVal;
            var priceVal;
            var prodName;
            var discType;
            discVal=priceNRC.get('v.value');
            priceVal=hiddenPriceNRC.get('v.value');
            prodName=hiddenPriceNRC.get('v.name');
            discType=discountType.get('v.value');
            console.log('discType..'+discType +"--"+discVal);
              if(discVal== undefined || discVal == '' ||(discVal != undefined && regex.test(discVal)) )
                { 
                    helper.discountValidation(priceVal,prodName,discVal,priceType,component,discType); 
                 }else{
                        var toastEvent = $A.get("e.force:showToast");
                        console.log('toastevent in  parentcomp'+toastEvent);
                         if(discVal != undefined && !regex.test(discVal)) {
                        toastEvent.setParams({
                            title : 'error',
                            message: 'Enter only numerical discount value up to 2  digits',
                            type: 'error',
                        });
                        toastEvent.fire();
                        }
                    }
            
        }
    }
},
    
    
    
    /*
 * this is to delete Addons/alakata products
 */
    onDeleteInner : function(component, event, helper) {
        console.log('inside onDeleteInner');
        var pkgNameTobeDelete =event.getSource().get('v.name');
        var productOfferingId =event.getSource().get('v.value');
        console.log('inside onDelete'+pkgNameTobeDelete+' productOfferingId '+productOfferingId);
        helper.deleteInner(component, event,pkgNameTobeDelete, productOfferingId);
    },
        
        
        
        /*
 * apply quantity for addons/alakata prods
 */  
    quantityValidationInner : function(component, event, helper) {
        var quantityValArray = component.find("quantityInner");
        var qtyForSelPkgName = component.find("quantityInnerHidden");
        console.log('inside quantityValidationInner..'+quantityValArray);
        console.log('inside qtyForSelPkgName1..'+qtyForSelPkgName);
        if (quantityValArray instanceof Array)
        {
            for(var i=0;i<quantityValArray.length;i++){
                var breakflag=false;
                var quanvalue=quantityValArray[i].get("v.value");
                // PMD Fix IfStmtsMustUseBraces
                if(quanvalue == null || quanvalue == undefined || quanvalue == '')
                {
                    quanvalue = '1';
                }
                if(quanvalue.indexOf('.')!= -1)
                {
                    quanvalue='1';
                    var toastEvent = $A.get("e.force:showToast");
                    console.log('toastevent in  parentcomp'+toastEvent);
                    toastEvent.setParams({
                        title : 'error',
                       
                        // message: 'Decimal value is not accepted',
                        type: 'error',
                        
                    });
                    toastEvent.fire();
                    breakflag=true;
                    
                }
                var pkgNameOfQuantity, productOfferingId;
                for (var j=i;j<=i;j++){
                    console.log('qtyForSelPkgName[j] '+qtyForSelPkgName[0]);
                    pkgNameOfQuantity = qtyForSelPkgName[j].get("v.name");
                    productOfferingId = qtyForSelPkgName[j].get("v.value");
                    console.log('pkgNameOfQuantity-->'+pkgNameOfQuantity);
                    console.log('productOfferingId-->'+productOfferingId);
                }
                console.log('quanvalue .. '+quanvalue+'value');
                if(quanvalue!=undefined && quanvalue!=null && quanvalue != ''){
                    helper.updateQuantityForAddons(component,event,pkgNameOfQuantity,productOfferingId,quanvalue);
                    
                }
                if(breakflag){
                    break;
                }
            }
        } else{
            console.log('inside else for quantity--'+qtyForSelPkgName);
            var quanvalue=quantityValArray.get("v.value");
            // PMD Fix IfStmtsMustUseBraces
            if(quanvalue == null || quanvalue == undefined || quanvalue == '')
            {
                quanvalue = 1;
            }
            var pkgNameOfQuantity = qtyForSelPkgName.get("v.name");
            var productOfferingId = qtyForSelPkgName.get("v.value");
            console.log('quanvalue-'+quanvalue+'-'+pkgNameOfQuantity+'--'+productOfferingId);
            if(quanvalue!=undefined && quanvalue!=null && quanvalue != ''){
                helper.updateQuantityForAddons(component,event,pkgNameOfQuantity,productOfferingId,quanvalue);
            }
        }
        
        var orderType;
        
        var finalmap = component.get('v.bigconMapUpdate');
        for(var i=0;i<finalmap.length;i++){
            orderType = finalmap[i].orderType;
        }
        console.log('addon quantity order type.. '+orderType);
        console.log('json final map for addons.. '+JSON.stringify(component.get('v.bigconMapUpdate')));
        
        var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
        priceDataAction.setParams({
            'productLineItemMapStr': JSON.stringify(component.get('v.bigconMapUpdate'))
        });
        priceDataAction.setCallback(this, function(priceResponse) {
            console.log('priceResponse.getReturnValue() in accRec.. '+priceResponse.getReturnValue());
            
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
            
            
            var bigMap =component.get('v.QLIMap');
            var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
            compEvent.setParams({
                "shoppingCartData" : bigMap,
                "selectedAttributes" :  component.get("v.attr")
            });
            compEvent.fire();
            
            
        });
        $A.enqueueAction(priceDataAction);
    },
        
        
        
        /*
 * apply quantity for products
 */  
    quantityValidation : function(component,event,helper)
{
    var orderType;
    var finalmap = component.get('v.bigconMapUpdate');
    console.log('quantityValidation'+JSON.stringify(finalmap));  
    for(var i=0;i<finalmap.length;i++){
        orderType = finalmap[i].orderType;
    }
    console.log('quantityValidation service '+JSON.stringify(component.get('v.selectedService')));  
    
    var quantityValArray = component.find("quantity");
    var qtyForSelPkgName = component.find("quantityHidden");
    console.log('inside quantityValidation..'+quantityValArray);
    console.log('inside qtyForSelPkgName..'+qtyForSelPkgName);
    var bigMap =component.get('v.QLIMap');  
    var pkgNameOfQuantity;
    if (quantityValArray instanceof Array)
    {
        for(var i=0;i<quantityValArray.length;i++){
            var quanvalue=quantityValArray[i].get("v.value");
            // PMD Fix IfStmtsMustUseBraces
            if(quanvalue == null || quanvalue == undefined || quanvalue == '')
            {
                quanvalue = 1;
            }
            if(quanvalue.indexOf('.')!= -1)
            {
                quanvalue='1';
                var toastEvent = $A.get("e.force:showToast");
                console.log('toastevent in  parentcomp'+toastEvent);
                toastEvent.setParams({
                    title : 'error',
                    
                    type: 'error',
                    
                });
                toastEvent.fire();
                
            }
            for (var j=i;j<=i;j++)
            {
                pkgNameOfQuantity = qtyForSelPkgName[j].get("v.value");
                console.log('pkgNameOfQuantity-->'+pkgNameOfQuantity);
            }
            console.log('quanvalue .. '+quanvalue);
            if(quanvalue!=undefined && quanvalue!=null){
                helper.updateQuantityToPrice(component,event,pkgNameOfQuantity,quanvalue,bigMap);
            }
        }
        
    } else{
        var quanvalue=quantityValArray.get("v.value");
        // PMD Fix IfStmtsMustUseBraces
        if(quanvalue == null || quanvalue == undefined || quanvalue == '')
        {
            quanvalue = 1;
        }
        pkgNameOfQuantity = qtyForSelPkgName.get("v.value");
        console.log('quanvalue-'+quanvalue+'-'+pkgNameOfQuantity);
        if(quanvalue!=undefined && quanvalue!=null){
            helper.updateQuantityToPrice(component,event,pkgNameOfQuantity,quanvalue,bigMap);
        }
    }
    console.log('quantit val ..bigMaPPPPpKKKKKK in cntroller ..' + JSON.stringify(component.get('v.bigconMapUpdate')));
    component.set('v.QLIMap',bigMap);
    
    var priceDataAction = component.get("c.getPriceCalculationRevampForBOB");
    priceDataAction.setParams({
        'productLineItemMapStr': JSON.stringify(component.get('v.bigconMapUpdate'))
    });
    priceDataAction.setCallback(this, function(priceResponse) {
        console.log('priceResponse.getReturnValue() in accRec.. '+priceResponse.getReturnValue());
        console.log('orderType in qty .. '+orderType);
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
        
        component.set('v.priceSpinner',false);
        var offerOverridenDataList=component.get('v.overridenOfferList');
        console.log('offerOverridenDataList in controller.. '+ JSON.stringify(component.get('v.bigconMapUpdate')));
        var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
        compEvent.setParams({
            "shoppingCartData" : bigMap,
            "selectedAttributes" :  component.get("v.attr"),
            "pkgOverridenList": offerOverridenDataList,
            "bigconMapUpdate" : component.get('v.bigconMapUpdate'),
            "selectedService" : component.get('v.selectedService')
        });
        compEvent.fire();
        
    });
    $A.enqueueAction(priceDataAction);
},
    
    
    /* for Optin and Optout products */
    checkBoxChange : function(component,event,helper){
        var finalmap = component.get('v.bigconMapUpdate');
          console.log('packageKey--->'+component.get('v.packageKeyofFirstLevel'));
        console.log('check box validation new'+JSON.stringify(component.get('v.bigconMapUpdate'))+'selected service'+component.get('v.selectedService'));  
        var checkboxData= component.find('checkbox');
        
        if(checkboxData instanceof Array){
            console.log('inside array checkbox');
            for (var i=0;i<checkboxData.length;i++){
                console.log(checkboxData[i]+'v.text'+checkboxData[i].get('v.text')+'v.value'+checkboxData[i].get('v.value'));
                var prodName=checkboxData[i].get('v.text');
                console.log("prodName"+prodName);
                var checkboxStatus=checkboxData[i].get('v.value');
                helper.commonMethodForCheckBox(component,event,prodName,checkboxStatus); 
            }
        }else{
            console.log('inside not array of check box..');
            var prodName=checkboxData.get('v.text');
            var checkboxStatus=checkboxData.get('v.value');
            helper.commonMethodForCheckBox(component,event,prodName,checkboxStatus); 
        }
        var bigMap =component.get('v.QLIMap');
        console.log('commonMethodForCheckBox val shoppingcart helper..bigMap' + JSON.stringify(bigMap));
        var attrvalue = component.get("v.attr");
        var finalmap = component.get('v.bigconMapUpdate');
        console.log('****FINALMAP***'+JSON.stringify(component.get('v.bigconMapUpdate')));
        
        var orderType;
        for(var i=0;i<finalmap.length;i++){
            orderType = finalmap[i].orderType;
        }
        
        var priceDataActionn = component.get("c.getPriceCalculationRevampForBOB");
        priceDataActionn.setParams({
            'productLineItemMapStr': JSON.stringify(finalmap)
        });
        priceDataActionn.setCallback(this, function(priceResponse) {
            component.set('v.priceSpinner',false);
            console.log('commonMethodForCheckBox.getReturnValue().at inner Helper. '+JSON.stringify(priceResponse.getReturnValue()));
            
            
            var priceEvent;
            console.log('orderType in accRec .checkbox.> '+orderType);
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
            console.log('offerOverridenDataList.after.checkbox>' + JSON.stringify(offerOverridenDataList));
            var compEvent = $A.get("e.com_tcs_telecom:NewShoppingCartInnerToCartEvent");
            
            compEvent.setParams({
                "shoppingCartData" : bigMap,
                "selectedAttributes" :  attrvalue,
                "eventCheck" : true,
                "pkgOverridenList":offerOverridenDataList,
                "bigconMapUpdate" : component.get('v.bigconMapUpdate'),
                "selectedService" : component.get('v.selectedService')
            });
            compEvent.fire(); 
            
        });
        $A.enqueueAction(priceDataActionn); 
        component.set('v.priceSpinner',false);
    },
        
        
        
        
        
        /* to delete packages from shoppingcart */
        onDeleteForMultipleServices : function(component, event, helper){
            
            var txt='';
            if (confirm("Are you sure you want to delete selected packages!")) {
                txt = "OK";
            } else {
                txt = "Cancel";
            }
            console.log('txt...'+txt);
            
            
            
            
            
            if(txt == 'OK'){
                component.set('v.deletespinner',true);
                console.log('inside onDeleteForMultipleServices >>>>>>>>>');
                var selServiceName = component.get('v.selectedService'); 
                // var selServiceName =event.getSource().get('v.name');
                var pkgNameTobeDelete =event.getSource().get('v.value');
                // alert('selServiceName.. '+selServiceName);
                console.log('selServiceName .>> . '+selServiceName + 'pkgNameTobeDelete..'+pkgNameTobeDelete);
                helper.delete(component, event,pkgNameTobeDelete);
                var offerTobeDelete = [];
                offerTobeDelete.push({value:pkgNameTobeDelete, key:selServiceName});
                console.log('offerTobeDelete stringify .. '+JSON.stringify(offerTobeDelete));
                var currService=component.get('v.currentselectedService');
                console.log('currService stringify .. '+currService);
                
                
                var compEvent = $A.get("e.com_tcs_telecom:deleteOfferEvent");
                compEvent.setParams({
                    "offersToDelete" : offerTobeDelete,
                    // "offerUnderServiceOf" : selServiceName,
                    "offerUnderServiceOf" :   currService,
                    "packageName" : pkgNameTobeDelete
                });
                compEvent.fire();
            }
            else{
                console.log('inside cancel....');
            }
            
        },
            
            
            
            loadAttribute_new : function(component,event) {
                var firstLevelPkgkey=component.get('v.packageKeyofFirstLevel');
                var bigMap =component.get('v.QLIMap');
                console.log('bigmap before attr display .. '+JSON.stringify(bigMap));
                console.log('prodOfferingID'+event.getSource().get("v.value")+'pkgName'+event.getSource().get("v.name")+'selected attr'+JSON.stringify(component.get("v.attr")));
                component.set('v.body','');
                $A.createComponent("com_tcs_telecom:AttributeDisplay", {
                    "prodSpecIdData" : event.getSource().get("v.value"),
                    "pkgName" : event.getSource().get("v.name"),
                    // "selAttributes" : component.get("v.attr"),
                    "bigMap" : bigMap,
                    "firstLevelPkgName" : firstLevelPkgkey,
                    "selectedService" : component.get("v.selectedService"),
                    "quoteId" : component.get("v.quoteRecId")
                }, function (contentComponent, status, error) {
                    if (status === "SUCCESS") {
                        var target = component.get('v.body');
                        target.push(contentComponent);
                        component.set('v.body', target);
                        component.set('v.isOpen', true);
                        console.log('target resp.. '+JSON.stringify(target));
                        
                    } else {
                        console.log('in error');
                        throw new Error(error);
                    }
                });
            },
                
                
                
})