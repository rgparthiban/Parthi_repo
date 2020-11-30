public with sharing class PCServiceCall {//implements IPCServiceCall

   /* static OfferabilityConfig__c offerabilityConfig=OfferabilityConfig__c.getvalues('offerabilityApi');
    
    public static void setOfferabilityConfig(OfferabilityConfig__c offerability){
        offerabilityConfig = offerability;
    }
    
    public static OfferabilityConfig__c getOfferabilityConfig()
    {
        return offerabilityConfig;
    }
    
    // Method for calling the searchProducts PC service
    public  String searchProducts(List<Param_Configure__c>paramList,String srvcCatg) {
       SearchProductRequest reqBody = new SearchProductRequest();
         String responseStr = null;  
        String requestPayload = reqBody.generateJson(paramList,srvcCatg);
        System.debug('serviceCategoryin getPAck .. '+srvcCatg+requestPayload);
        String serviceName = '/searchProduct';
      //working url..commented for testing
      String url = 'callout:HOBS_PcProxyRest'+serviceName;
	 system.debug('ReqStr in searchProducts url' +url+ requestPayload);
        try{
            responseStr = HTTPUtility.getServiceResponse(requestPayload, url, 'POST');
          
        }
        catch(Exception e)
        {
            system.debug('exception'+e);
        }
      
      return responseStr;
  }
    
  public  PackageOffer getPackages(String serviceCategory) {
     PackageJSONRequest reqBody = new PackageJSONRequest();
     //DNArequestjsonbuilder reqBody= new DNArequestjsonbuilder();
    System.debug('serviceCategoryin getPAck .. ');
     String requestPayload = reqBody.generateJson(serviceCategory);//Changed ServiceCategory to serviceCategory by surya for PMD
     String serviceName = 'getPackages';
     String requestMethod = 'POST';
     system.debug('ReqStr in getpack' + requestPayload);
     String responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
     system.debug('RespStr-->'+responseStr );
     String responseStrAfter = responseStr.replace('currency', 'currency1');
     system.debug('RespStr after replace-->'+responseStrAfter);
     PackageOffer offer = PackageOffer.parse(responseStrAfter);
     //system.debug('PackageOffer-->'+offer);
     return offer;
  }
              
   public PackageOffer  getChildProdsForListOfPackages(String serviceCategory,List<String> pkgprodOfferids){
     PackageJSONRequest reqBody = new PackageJSONRequest();
     String requestPayload = reqBody.generateJsonForListOfPackages(serviceCategory,pkgprodOfferids);//Changed ServiceCategory to serviceCategory by surya for PMD
       String serviceName = '/getPackages';
       String requestMethod = 'POST';
		String responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
       system.debug('requestPayload-getChildProdsForListOfPackages->'+requestPayload);
        system.debug('RespStr-getChildProdsForListOfPackages->'+responseStr);
     	PackageOffer offer = PackageOffer.parse(responseStr);
     	return offer;
    }
    
   public ProductOffer  getProducts(List<String> cart){
        ProductJSONRequest reqBody = new ProductJSONRequest();
    	 //DNAProductJSONRequest reqBody= new DNAProductJSONRequest();
       
       String requestPayload = reqBody.generateJson(cart);//Changed Cart to cart by surya for PMD
       String serviceName = '/getProducts';
       String requestMethod = 'POST';
	
       String responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
       responseStr = responseStr.replace('currency', 'currency1');
       //System.debug('responseStr--> '+responseStr);
       ProductOffer offer = ProductOffer.parse(responseStr);
       return offer;
    }
    
    
    
   
    
  
	
    //not used currently
    public BundlePrice  getBundleOfBundlePrices(List<String> offeringIdList){
     BundlePriceJSONRequest reqBody = new BundlePriceJSONRequest();
       String requestPayload = reqBody.generateJsonForList(offeringIdList);//Changed OfferingIdList to offeringIdList by surya for PMD
       //system.debug('Payload-->'+requestPayload);
       String serviceName = '/getBundlePrice';
       String requestMethod = 'POST';

       String responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
       //system.debug('responseStr-->'+responseStr);
       responseStr = responseStr.replace('currency', 'currency1');
      // system.debug('new replaced responseStr-->'+responseStr);
       BundlePrice offer = BundlePrice.parse(responseStr);
      // system.debug('BundlePrice-->'+offer);
       return offer; 
    }
	
    public  ProductPrice  getProductPrice(List<String> productSpecList, Map<String,String> attributeMap){
        try{
            ProductPriceJSONRequest reqBody = new ProductPriceJSONRequest();
               String requestPayload = reqBody.generateJsonForList(productSpecList, attributeMap,'getProductPrice');
               //system.debug('Payload-->'+requestPayload);
               String serviceName = '/getProductPrice';
                //String serviceName = 'getProductPrice';
               String requestMethod = 'POST';
            system.debug('getProductPrice Request:'+requestPayload);
               String responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
              // system.debug('responseStr-->'+responseStr);
               responseStr = responseStr.replace('currency', 'currency1');
                responseStr = responseStr.replace('type', 'typeofCurrency');
             //  system.debug('new replaced responseStr-->'+responseStr);
               ProductPrice offer = ProductPrice.parse(responseStr);
             //  system.debug('BundlePrice-->'+offer);
               return offer;
        }
        catch(Exception e){
            system.debug('error in getProductPrice--'+e.getStackTraceString());
        }
      return null;
    }
    
    
    public  BundlePrice  getBundlePricePkgPricing(List<String> productSpecList,Map<String,String> attributeMapValues,String quoteId,String serviceType){
       ProductPriceJSONRequest reqBody = new ProductPriceJSONRequest();
        String customerSegment=null;
        String selectedSiteId=null;
        String quoteVersion='1.0';
        List<QuoteLine__c> quoteLineList=new List<QuoteLine__c>();
        List<Param_Configure__c>paramList=new List<Param_Configure__c>();
        if(serviceType!=null){
             quoteLineList=[SELECT Site_Id__c FROM QuoteLine__c WHERE Quote_Id__c =:quoteId AND Service_Type__c =:serviceType];
        
			 paramList = [select com_tcs_telecom__FieldName__c,com_tcs_telecom__FieldValue__c
                                              From com_tcs_telecom__Param_Configure__c 
                                              where com_tcs_telecom__Enabled__c  =: true and com_tcs_telecom__Service_Types__c =: serviceType];
        }
            if(quoteId!=null){
               OfferabilityConfig__c offerabilityConf=getOfferabilityConfig();
               String offerabilityApi=offerabilityConf.Offerability_Api_Name__c;
               Type t = Type.forName(offerabilityApi);
        	   OfferabilityMapInterface offerabilityObj = (OfferabilityMapInterface)t.newInstance();
                if(quoteLineList.size()>0){
                    for(QuoteLine__c qtline:quoteLineList){
                        selectedSiteId=qtline.Site_Id__c;
                        paramList=offerabilityObj.mapOfferabilityValue(paramList,quoteId,quoteVersion,selectedSiteId);
                        attributeMapValues=this.reConstructAttributeMap(paramList,attributeMapValues);
                    }
                }
               
            }
            
        String requestPayload = reqBody.generateJsonForBundlePriceList(productSpecList,attributeMapValues,'getBundlePrice',customerSegment);
       String serviceName = '/getBundlePrice';
        String requestMethod = 'POST';
		system.debug('getBundlePrice Request:'+requestPayload);
       String responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
       responseStr = responseStr.replace('currency', 'currency1');
        responseStr = responseStr.replace('type', 'typeofCurrency');
       BundlePrice offer = BundlePrice.parse(responseStr);
       System.debug('BundlePrice offer--'+JSON.serialize(offer));
       return offer;
    }
    
    public Map<String,String> reConstructAttributeMap(List<Param_Configure__c>paramList,Map<String,String>attributeMap){
         if(paramList.size()>0){
             for(Param_Configure__c param:paramList){
                 if(param.FieldName__c!=null && param.FieldValue__c!=null)
                 {
                     attributeMap.put(param.FieldName__c,param.FieldValue__c);
                 }
             } 
        }
        return attributeMap;
    }
    
public PackageOffer  getPackageDetails(List<String> productSpecList, Map<String,String> attributeMap){
    ProductPriceJSONRequest reqBody = new ProductPriceJSONRequest();
       String requestPayload = reqBody.generateJsonForList(productSpecList, attributeMap,'getPackageDetails');
       system.debug('Payload-->'+requestPayload);
       String serviceName = '/getPackageDetails';
     //String serviceName = 'getPackageDetails';
       String requestMethod = 'POST';
     String responseStr=null;
	system.debug('getProductPrice Request:'+requestPayload);
    try{
        responseStr = HTTPUtility.getCalloutResponse(requestPayload,serviceName,requestMethod);
       system.debug('responseStr getPackageDetails-->'+responseStr);
       responseStr = responseStr.replace('currency', 'currency1');
        responseStr = responseStr.replace('type', 'typeofCurrency');
     		//logStatus('getPackageRqst',requestPayload);
           // logStatus('getPackageResponse',responseStr);
       
    }
    catch(Exception e){
        System.debug('Exception'+e);
        //logStatus('getPackageRqst',requestPayload);
    }
     PackageOffer offer = PackageOffer.parse(responseStr);
     system.debug('getPackageDetails-->'+offer);
    return offer;
    } 
    public static void logStatus(String statusCode,String statusDesc){
        String statusDescSub=null;//Changed StatusDescSub to statusDescSub by surya for PMD
        if(statusDesc.length()>150)
        {
             statusDescSub=statusDesc.substring(0,100);
        }
        else
        {
            statusDescSub=statusDesc.substring(0,statusDesc.length()); 
        }
        com_tcs_telecom__Status__c s=new com_tcs_telecom__Status__c(); 
        s.statusCode__c=statusCode;
        s.statusDesc__c=statusDescSub;
        if(!Schema.sObjectType.com_tcs_telecom__Status__c.fields.statusCode__c.isCreateable())
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        insert s;
    }*/
        
}