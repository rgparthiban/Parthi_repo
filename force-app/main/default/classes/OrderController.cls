public with sharing class OrderController {
    
   /* @AuraEnabled
    public static Object getPriceForGivenAddonForOrder(Map<String,Object> addonAsString,String prodOfferIdOfPackage,
                                               String orderId){
                                                   String quoteID=orderId;
                                                   System.debug('addonAsString in packageController.. '+addonAsString);
                                                   return AddonController.getPriceForGivenAddonForOrder(addonAsString,prodOfferIdOfPackage,quoteID);
                                               } 

    
    
   @AuraEnabled
     public static Map<String,String> getPriceCalculationRevampForBOB(String productLineItemMapStr)
    {
       
        return PackageController.getPriceCalculationRevampForBOB(productLineItemMapStr);
    }	
    
    
    @AuraEnabled
     //New Query for multiple Services
    public static list<String> getOrderServiceType(String orderId){
        System.debug('orderid in getOrderServiceType.. '+orderId);
        if(!Schema.sObjectType.com_tcs_telecom__SubmitOrder__c.fields.com_tcs_telecom__Multi_Service_Types__c.isAccessible())
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        com_tcs_telecom__SubmitOrder__c q = [SELECT com_tcs_telecom__Multi_Service_Types__c FROM com_tcs_telecom__SubmitOrder__c WHERE Id=:orderId];
        system.debug('Multiple_Service__c-->'+q.com_tcs_telecom__Multi_Service_Types__c);
        string serv = q.com_tcs_telecom__Multi_Service_Types__c;        
        if(serv == null) {
            serv = 'ANY';
        }
        
        List<String> arr=  serv.split(';');
        list<string> multi = new  list<string>();
        
        for(Integer i=0;i<arr.size();i++){
            System.debug('arr[i] '+arr[i]);
            if(arr[i] != ' ' && arr[i].length()>0){
               system.debug('arr[i]is here3-->'+arr[i]); 
                String serviceType = arr[i].normalizeSpace();
                System.debug('serviceType>'+serviceType);
              multi.add(serviceType.deleteWhitespace());   
            }
                
            	
        }
        system.debug('multi..services.data..'+multi);
        return multi;
      
    }
    
    
    
    
    @AuraEnabled
    public static Map<String,Map<String, List<Object>>> getFinalMapforOrder
        (String gridJson, String orderId, String attributeList, String existOfferMap
        ){
             Map<String,Map<String, List<Object>>> resultMap =  new Map<String,Map<String, List<Object>>>();
             try{
                 
                 List<Object> existingServiceOfferMap = new List<Object>();
                 if(existOfferMap != null && existOfferMap.length() > 0) {
                     System.debug('existOfferMap....'+existOfferMap);
                     existingServiceOfferMap = (List<Object>)JSON.deserializeUntyped(existOfferMap);
                     System.debug('existingServiceOfferMap.in order flow...'+existingServiceOfferMap);
                 }
                 
                 System.debug('inside getFinalMap....'+gridJson);
                 List<Object> finalList = (List<Object>)JSON.deserializeUntyped(gridJson);
                 if(finalList!=null && !finalList.isEmpty()){
                   	for(Integer i=0;i<finalList.size();i++){
                         Map<String,Object> eachMap = (Map<String,Object>)finalList[i];
                         String serviceType = (String)eachMap.get('key');
                         System.debug('serviceType ..>'+serviceType);
                         List<Object> objValue=(List<Object>)eachMap.get('value');
                         System.debug('eachmap value.. '+objValue);
                         List<Object> existingOffer = null;
                         
                         if(existingServiceOfferMap!=null){
                             System.debug('existingServiceOfferMap.size() value.. '+existingServiceOfferMap.size());
                             for(Integer j=0;j<existingServiceOfferMap.size();j++){
                                 Map<String,Object> existingMap = new Map<String, Object>();
                                 existingMap = (Map<String,Object>)existingServiceOfferMap[j];
                                 System.debug('serviceType .existingMap. '+existingMap);
                                 String serviceTypeOfExisting = (String)existingMap.get('key');
                                 System.debug('serviceType .serviceTypeOfExisting. '+serviceTypeOfExisting);
                                 if(serviceTypeOfExisting == serviceType) {
                                     existingOffer=(List<Object>)existingMap.get('value');
                                     //existingOffer =  ''+existingMap.get(serviceType);
                                     System.debug('existingOffer is. '+existingOffer);
                                 }
                             }
                         }
                         map<String, List<Object>> quoteLineMap = new  Map<String,List<Object>>();
                         getOrdeLineItemMapWithPrice
                             (resultMap,quoteLineMap,objValue,orderId,attributeList,existingOffer,  
                              serviceType,existingServiceOfferMap);
                         //resultMap.put((String)eachMap.get('key'),resObj);
                     }
                 }else if(finalList!=null && finalList.isEmpty())
                 {
                     map<String, List<Object>> quoteLineMap = new  Map<String,List<Object>>();
                     List<Object> emptygridResponse = new List<Object>();
                     List<Object> existingServiceOfferMapEmpty = new List<Object>();
                     getOrdeLineItemMapWithPrice
                         (resultMap,quoteLineMap,emptygridResponse,orderId,attributeList,null,  
                          null,existingServiceOfferMap);
                 }
                 System.debug('resultMap in getfinalMap .. '+resultMap); 
             }
             catch(Exception e){
                 System.debug('exception in getfinal map .. '+e.getLineNumber());
                 System.debug('exception in getfinal map message.. '+e.getMessage());
             }
             return resultMap;
         }
    
    
   
    //@AuraEnabled
    private static void getOrdeLineItemMapWithPrice
        (Map<String,Map<String, List<Object>>> resultMap,map<String, List<Object>> quoteLineMap,
         List<Object> gridResponse, String orderId, 
         String attributeList,List<Object>  existOfferMap,
         String serviceType,
         List<Object> existingServiceOfferMap){
             System.debug('serviceType--> '+ serviceType);
             String attrString = '<table style="width:74%"><th>AttributeName</th><th>Value</th>';
             List<AttributeMapConverter> attributeMapp = new List<AttributeMapConverter>();
             Map<String, List<OrderLineItemPkgWrapper>> existingAddonsMap;
             Map<String,List<Object>> attriMap = new Map<String,List<Object>>();
             Map<String, String> attributeMapValues = new Map<String, String>();
             List<String> prodOfferIdsOfPkges = new List<String>();
             try{
                     if(attributeList != null && attributeList.length() > 0) {
                     attributeMapp =   (List<AttributeMapConverter>)System.JSON.deserialize(attributeList,List<AttributeMapConverter>.class);
                     for(AttributeMapConverter mapConverterObj : attributeMapp)
                     {
                         attriMap.put(mapConverterObj.key, mapConverterObj.value);
                         List<AttributeMapConverter.ValueList> valList = (List<AttributeMapConverter.ValueList>)mapConverterObj.value;
                         if(valList != null) {
                             for(AttributeMapConverter.ValueList v : valList) {
                                 attributeMapValues.put(v.name,v.value);
                             }
                         }
                     }
                 } 
                 Map<String, Object> existingOfferMap = new Map<String, Object>();
                 if(existOfferMap != null) {
                     for(Integer i=0;i<existOfferMap.size();i++){
                         map<String, Object> item = (map<String, Object>)existOfferMap[i];
                         existingOfferMap.put((String)item.get('key'),item.get('value'));
                     }
                 }
                 System.debug('existingOfferMap after added .. '+existingOfferMap);
                 map<String, Object> gridJsonMap = new map<String, Object>();
                 List<Object> temp = new List<Object>();
                 PCServiceCall pccall = new PCServiceCall();
                  
                 List<String> childProductSpecList = new List<String>();
                 for(Integer i=0;i<gridResponse.size();i++){
                     map<String, Object> item = (map<String, Object>)gridResponse[i];
                     gridJsonMap.put((String)item.get('ProductSpec'),item);
                     List<Object> childQuotes = (List<Object>)item.get('_children');
                     PackageController.childQuoteStrData(childQuotes,childProductSpecList);//changed for BOB
                     
                 }
                 System.debug('gridJsonMap in packagecontroller' + gridJsonMap);
                 List<ProductPrice.cls_productPriceDetails> bundlePriceForSelectedProducts = new List<ProductPrice.cls_productPriceDetails>();
                 boolean offercheck = false;
                 system.debug('childProductSpecList ::'+childProductSpecList);
                 ProductPrice priceForSelectedProducts = pccall.getProductPrice(childProductSpecList, attributeMapValues);
                 system.debug('priceForSelectedProducts---'+priceForSelectedProducts);
                bundlePriceForSelectedProducts = priceForSelectedProducts.getProductPriceDetails();
                 List<String> optIn = new List<String>();
                 
                 for(Integer i=0;i<gridResponse.size();i++){
                     
                     map<String, Object> item = (map<String, Object>)gridResponse[i];
                     String pkgName = (String)item.get('Name');
                     List<Object> childQuotesChildren = (List<Object>)item.get('_children');
                     System.debug(' pkgName is '+pkgName);
                     
                     if(existingOfferMap.containsKey(pkgName)) {
                         System.debug('Inside If');
                         List<Object> valueList = (List<Object>)existingOfferMap.get(pkgName);
                         //System.debug('valueList is.before.'+JSON.serialize(valueList));
                           //merge selected Children
                                //List<Object> afterRemove = new List<Object>();
                                //mergeExistingPackageProducts(valueList,afterRemove,quoteLineMap,item,orderId,bundlePriceForSelectedProducts);
                                //quoteLineMap.put((String)item.get('Name'),afterRemove);
                                quoteLineMap.put((String)item.get('Name'),valueList);
                            
                        }
                     else {
                         System.debug('Inside else');
                         List<Object> firstLevelquoteLineItemsList = new List<Object>();
                         quoteLineMap.put((String)item.get('Name'),firstLevelquoteLineItemsList);
                         String firstLevelparentProdOfferId=(String)item.get('ProductSpec');
                         forParentProducts(item,firstLevelquoteLineItemsList,orderId,bundlePriceForSelectedProducts,firstLevelparentProdOfferId);
                     }
                     
                 }
                 system.debug('New QuoteLineMap After new map construction->'+JSON.serialize(quoteLineMap));
                 
                 if(!gridResponse.isEmpty()){
                     resultMap.put(serviceType,quoteLineMap);  
                 }
                 system.debug('before formmap method called->'+JSON.serialize(resultMap));
                 system.debug('existingServiceOfferMap before formmap method called->'+JSON.serialize(existingServiceOfferMap));
                 system.debug('existingOfferMap before formmap method called->'+JSON.serialize(existingOfferMap));
                 //system.debug('currentVersion before formmap method called->'+currentVersion);
               
                 
                 System.debug('New resultMap After adding existing offers->'+JSON.serialize(resultMap));
                 //return quoteLineMap;
             }
             catch(Exception e){
                 System.debug('Exception in getOrdeLineItemMapWithPrice--'+e.getStackTraceString());
             }
             
         }
    
    
  
    
    private static void forParentProducts(map<String, Object> item,List<Object> allObjList,String orderId,
                                          List<ProductPrice.cls_productPriceDetails> bundlePriceForSelectedProducts,
                                          String firstLevelparentProdOfferId)
    {
        String parentProdOfferId=(String)item.get('ProductSpec');
        addQuoteLine(item,allObjList,true,orderId,bundlePriceForSelectedProducts,parentProdOfferId,firstLevelparentProdOfferId);
        List<Object> childQuotes = (List<Object>)item.get('_children');
        iterateChilds(childQuotes,allObjList,orderId,bundlePriceForSelectedProducts,parentProdOfferId,parentProdOfferId);
        
    } 
    
    
    private static void iterateChilds(List<Object> childQuotes, List<Object> allObjList,String orderId,List<ProductPrice.cls_productPriceDetails> bundlePriceForSelectedProducts,String parentProdOfferId,String firstLevelparentProdOfferId)
    {
        for(Integer k=0;k<childQuotes.size();k++)
        {
            map<String, Object> childQuoteEach = (map<String, Object>)childQuotes[k];
            List<Object> childQuotesNextLevel = (List<Object>)childQuoteEach.get('_children');
            if(childQuotesNextLevel!=null && !childQuotesNextLevel.isEmpty()){
                map<String,List<Object>> nextLevelMap = new map<String,List<Object>>();
                List<Object> nextLevelList = new List<Object>();
                nextLevelMap.put((String)childQuoteEach.get('Name'),nextLevelList);
                allObjList.add(nextLevelMap);
                
                forParentProducts(childQuoteEach,nextLevelList,orderId,bundlePriceForSelectedProducts,firstLevelparentProdOfferId);
                //SiterateChilds(childQuotesNextLevel,nextLevelList,quoteId,bundlePriceForSelectedProducts);
            }else{
                addQuoteLine(childQuoteEach,allObjList,false,orderId,bundlePriceForSelectedProducts,parentProdOfferId,
                             firstLevelparentProdOfferId);
            }
        }
    }			
    
    
    private static void addQuoteLine(map<String, Object> item,List<Object> quoteLineItems,boolean ispkg,String orderId, List<ProductPrice.cls_productPriceDetails> bundlePriceForSelectedProducts,String parentProdOfferId,String firstLevelparentProdOfferId)
        
    { 
        OrderLineItemPkgWrapper orderLineItemWrapper = new OrderLineItemPkgWrapper();
        orderLineItemWrapper.isPackage = ispkg;
        if(!ispkg){
            // packageItemWrapper.mandatory =(String)item.get('Mandatory');
            boolean resultflag=getProductPriceOfAOffer((String)item.get('ProductSpec'), bundlePriceForSelectedProducts, 
                                    orderLineItemWrapper,null);
            orderLineItemWrapper.parentproductOfferingId= parentProdOfferId;
            
        }else{
            orderLineItemWrapper.parentproductOfferingId= firstLevelparentProdOfferId; ////SQL Limit exception
            //packageItemWrapper.parentproductOfferingId= null;
        }
        orderLineItemWrapper.mandatory =(String)item.get('Mandatory');
        orderLineItemWrapper.name = (String)item.get('Name');
        orderLineItemWrapper.productOfferingId = (String)item.get('ProductSpec');
        orderLineItemWrapper.orderId = orderId;
        orderLineItemWrapper.ProductType = (String)item.get('ProductType');
         if((Boolean)item.get('isAddon')!=null){
            orderLineItemWrapper.isAddon = (Boolean)item.get('isAddon');
        }
        
        quoteLineItems.add(orderLineItemWrapper);
    }
    
    
    
    
    public static boolean getProductPriceOfAOffer(String offerId, List<ProductPrice.cls_productPriceDetails> productPriceList, OrderLineItemPkgWrapper packageItem,Decimal pkgQunatity) {
                                                      if(productPriceList!=null){
                                                          for(ProductPrice.cls_productPriceDetails priceDetail : productPriceList) {
                                                              if(priceDetail.getProductId() == offerId) {
                                                                  system.debug('match found '+offerId);
                                                                  system.debug('priceDetail '+priceDetail);
                                                                  //BundlePrice.cls_summaryOfCharges chargesSummary = priceDetail.getSummaryOfCharges();
                                                                  List<ProductPrice.cls_productOfferingPrice> productOfferingPrice = priceDetail.getProductOfferingPrice();
                                                                  for(ProductPrice.cls_productOfferingPrice offeringPrice : productOfferingPrice) {
                                                                      if(offeringPrice.priceType == 'RC') {
                                                                          packageItem.rcProductOfferingPriceID = offeringPrice.productOfferingPriceID;
                                                                          packageItem.rcPricingClassifier = offeringPrice.pricingClassifier;
                                                                          packageItem.rcBillingComponentType = offeringPrice.billingComponentType;
                                                                          if(offeringPrice.price != null) {
                                                                              
                                                                              System.debug('offeringPrice.price.amount in rc. '+offeringPrice.price.amount);
                                                                              //packageItem.recurringCharge = decimal.valueOf(offeringPrice.price.amount);
                                                                              packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                                                              System.debug('offeringPrice.price.amount in rc.after decimal> '+packageItem.recurringCharge);
                                                                              if(pkgQunatity!=null){
                                                                                  packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                                                              }else{
                                                                                  packageItem.rcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                                                              }
                                                                              packageItem.currencyObj = offeringPrice.price.currency1;
                                                                              if(offeringPrice.variablePrice != null){
                                                                                  packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                              }
                                                                              else if(offeringPrice.variablePrice == null){
                                                                                  packageItem.rcvariableprice =0;
                                                                              }
                                                                          } 
                                                                          else if(offeringPrice.fixedPrice != null && offeringPrice.variablePrice != null) {
                                                                              packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.fixedPrice.amount) + decimal.valueOf(offeringPrice.variablePrice.amount));
                                                                              packageItem.currencyObj = offeringPrice.fixedPrice.currency1;
                                                                              if(offeringPrice.price != null){
                                                                                  if(pkgQunatity!=null){
                                                                                      packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));//revamp
                                                                                  }
                                                                              else{
                                                                                  packageItem.rcnetprice = String.valueOf(offeringPrice.price.amount);//revamp
                                                                              }
                                                                              }
                                                                              if(offeringPrice.variablePrice != null){
                                                                                  packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                              }
                                                                          } else  if(offeringPrice.price != null && offeringPrice.variablePrice != null){
                                                                              packageItem.recurringCharge = String.valueOf(offeringPrice.price.amount);
                                                                              if(pkgQunatity!=null){
                                                                                  packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));//revamp
                                                                              }else{
                                                                                  packageItem.rcnetprice = String.valueOf(offeringPrice.price.amount);//revamp
                                                                              }
                                                                              
                                                                              packageItem.currencyObj = offeringPrice.price.currency1;
                                                                              packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                          }
                                                                      } else if(offeringPrice.priceType == 'NRC') {
                                                                          
                                                                          packageItem.nrcProductOfferingPriceID = offeringPrice.productOfferingPriceID;
                                                                          packageItem.nrcPricingClassifier = offeringPrice.pricingClassifier;
                                                                          packageItem.nrcBillingComponentType = offeringPrice.billingComponentType;
                                                                          if(offeringPrice.price != null) {
                                                                              System.debug('offeringPrice.price.amount in nnnrc. '+offeringPrice.price.amount);
                                                                              packageItem.price = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                                                              System.debug('Decimal price--'+packageItem.price);
                                                                              if(pkgQunatity!=null){
                                                                                  // packageItem.nrcnetprice = pkgQunatity*decimal.valueOf(offeringPrice.price.amount);//revamp
                                                                                  // packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));
                                                                                  packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                                                              }else{
                                                                                  //packageItem.nrcnetprice = decimal.valueOf(offeringPrice.price.amount);//revamp
                                                                                  packageItem.nrcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                                                              }
                                                                              
                                                                              packageItem.currencyObj = offeringPrice.price.currency1;
                                                                              if(offeringPrice.variablePrice != null){
                                                                                  packageItem.nrcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                              }
                                                                              else if(offeringPrice.variablePrice == null){ 
                                                                                  packageItem.nrcvariableprice =0;
                                                                              }
                                                                          } else if(offeringPrice.variablePrice != null) {
                                                                              packageItem.price = String.valueOf(offeringPrice.variablePrice.amount);
                                                                              packageItem.currencyObj = offeringPrice.variablePrice.currency1;
                                                                              packageItem.nrcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                          } else if(offeringPrice.fixedPrice != null){
                                                                              packageItem.price = String.valueOf(offeringPrice.fixedPrice.amount);
                                                                              packageItem.currencyObj = offeringPrice.fixedPrice.currency1; 
                                                                          }
                                                                          System.debug('Decimal price-new-'+packageItem.price);
                                                                      }
                                                                  }
                                                                  system.debug('packageItem '+packageItem);
                                                                  return true;
                                                              }
                                                          }
                                                      }
                                                      return false;
                                                  }
    
    
     public class OrderLineItemPkgWrapper {
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public Decimal quantity {get; set;}
        @AuraEnabled public String currencyObj {get; set;}
        @AuraEnabled public String price {get; set;}   //Decimal
        @AuraEnabled public String recurringCharge {get; set;} //Decimal
        @AuraEnabled public String attribute {get; set;}
        @AuraEnabled public boolean isPackage {get; set;}	
        @AuraEnabled public boolean isAddon {get; set;}	
        @AuraEnabled public String productOfferingId {get; set;}
        @AuraEnabled public String mandatory {get; set;}
        @AuraEnabled public String orderId {get; set;}
        @AuraEnabled public Decimal rcvariableprice {get; set;}//for priceoverride
        @AuraEnabled public Decimal nrcvariableprice {get; set;}//for priceoverride
        @AuraEnabled public String ProductType {get; set;} //for addons
        @AuraEnabled public String rcnetprice {get; set;} //for code revamp - Decimal
        @AuraEnabled public String nrcnetprice {get; set;} //for code revamp - Decimal
        @AuraEnabled public String rcdiscountedValue {get; set;} //for code revamp
        @AuraEnabled public String nrcdiscountedValue {get; set;} //for code revamp
         @AuraEnabled public String rcdiscountType {get; set;} //for code revamp
         @AuraEnabled public String nrcdiscountType {get; set;} //for code revamp
        @AuraEnabled public String parentproductOfferingId {get; set;}//for existing offers
        @AuraEnabled public String existingLineItem {get; set;}//for existing offers
        @AuraEnabled public Integer minQuantity {get; set;}//for cardinality check
        @AuraEnabled public Integer maxQuantity {get; set;}//for cardinality check
        @AuraEnabled public Boolean fromDB {get; set;}//for checking the item is from db or not
        
        @AuraEnabled public String rcProductOfferingPriceID {get; set;} 
        @AuraEnabled public String rcPricingClassifier {get; set;} 
        @AuraEnabled public String rcBillingComponentType {get; set;}
        
        @AuraEnabled public String nrcProductOfferingPriceID {get; set;} 
        @AuraEnabled public String nrcPricingClassifier {get; set;} 
        @AuraEnabled public String nrcBillingComponentType {get; set;}
        //@AuraEnabled public cls_summaryOfCharges summaryOfCharges {get; set;}
        @AuraEnabled public String status {get; set;}
    } 
    
  /*  public void SubmitOrderConstruction(String bigMap,String payerJson){
        SubmitOrderConstruction orderConstruction = new SubmitOrderConstruction();
        ///orderConstruction.formSubmitOrder(bigMap,payerJson);
    } */
    
}