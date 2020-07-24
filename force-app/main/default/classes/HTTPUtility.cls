public class HTTPUtility {
    
  /*  static OrgDefaults__c configGlobal =OrgDefaults__c.getvalues('RestVariables');
    
    
    public static void setOrgDefaults(OrgDefaults__c orgDefaults){
        configGlobal = orgDefaults;
    }
    
    public static OrgDefaults__c getOrgDefaults()
    {
        return configGlobal;
    }
    
    public static String getCalloutResponse(String requestPayload, String serviceName, String requestMethod) {
       
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        ///OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
        OrgDefaults__c config =getOrgDefaults();
        req.setHeader('Authorization', config.authorization__c);
       
       
        String url = 'callout:HOBS_PcProxyRest'+serviceName;
        // For pcproxy test
         //String url='callout:HOBS_PCProxyTestService'+serviceName;
        
        req.setEndpoint(url);
        req.setBody(requestPayload);
        System.debug('url in HTTPUtility getCalloutResponse getcall out-->'+url+'requestPayload '+requestPayload.deleteWhitespace());
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setMethod(requestMethod);
        Decimal timeOut = config.defaultTimeOut__c;
        Integer customTimeOut=timeOut.intValue();
        req.setTimeout(customTimeOut);
        HttpResponse res = h.send(req);
        String responseStr = String.valueOf(res.getBody());
        System.debug('responseStr '+responseStr);
        
        return responseStr;
    }
    
  
    
    public Static String getServiceResponse(String requestPayload, String url, String requestMethod) {
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        String responseStr;
      // try{
            ///OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
             OrgDefaults__c config =getOrgDefaults();
        	//System.debug('RestVariables---------------->'+config.authorization__c);
        	req.setEndpoint(url);
        	req.setBody(requestPayload);
          	System.debug('url in HTTPUtility-->'+url);
        	req.setHeader('Content-Type', 'application/json;charset=UTF-8');
          	req.setHeader('Authorization', config.authorization__c);
        	req.setMethod(requestMethod);
        //String customTimeOut = configGlobal.xxxx;////
        	Decimal timeOut = config.defaultTimeOut__c;
        	Integer customTimeOut=timeOut.intValue();
        	req.setTimeout(customTimeOut);
        	System.debug('req in httputil.. '+requestPayload);
        	res = h.send(req);
        	responseStr = String.valueOf(res.getBody());
        	System.debug('responseStr in httputil.. '+responseStr);
         // }
     
        
        return responseStr;
    }
    
    public static TemplatDetails getTemplateDetails(String prodId){
        //  System.debug('Inside getTemplateDetails');
        Http h = new Http();
        OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
        System.debug('RestVariables---------------->'+config);
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Authorization', config.authorization__c);
        //String productID = 'productId=';
        String productID = 'productId='+prodId;
        // System.debug('productID...'+productID);
        String context='&templateContext=DEFAULT';
        //System.debug('productID-' +productID + ' - ' + context) ;
        //String url = 'https://hobs.tcs.com/hobsrestgateway/servicetemplateservice/getTemplateDetails?'+productID+Context;
        String url = 'callout:Template_Details'+'?'+productID+context;
        
        req.setEndpoint(url);
        req.setHeader('opId','HOB');
        req.setHeader('buId','DEFAULT');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        Decimal timeOut = config.defaultTimeOut__c;
        Integer customTimeOut=timeOut.intValue();
        req.setTimeout(customTimeOut);
        HttpResponse res = h.send(req);
         System.debug('res.getBody() is.. '+res.getBody());
        String responseStr = String.valueOf(res.getBody()).replaceall('type','type1');
        TemplatDetails templateResponse = TemplatDetails.parse(String.valueOf(res.getBody()));
        
        //TemplatDetails templateResponse = TemplatDetails.parse(String.valueOf('{"templateId":"ST225","templateName":"VonageT","colSize":1,"templateContext":"DEFAULT","productId":"PRD_161","status":{"statusCode":"0000","statusName":"Informational"},"groupDetails":[{"attrGrpId":"ATTR_GRP_237","showGrpLabel":true,"attrGrpLabel":"DN_Number","colSize":2,"displayOrder":1,"itemId":"ST_ITM1102","attributeList":[{"dependencyElements":[],"itemElementMapId":"ST_ELE1277","isRepeat":"N","repeatMinLimit":0,"repeatMaxLimit":0,"valueList":{"value":[null]},"attributeName":"DN_1","attributeId":"PPM_ATTR_372","uiDisplayCode":"DN","type":"text","attrMetaInfo":{"seqNum":2,"valueType":"Text","editable":"Y","mandatory":"N"}},{"dependencyElements":[],"itemElementMapId":"ST_ELE1278","isRepeat":"N","repeatMinLimit":0,"repeatMaxLimit":0,"valueList":{"value":["getPrefix"]},"attributeName":"PREFIX_1","attributeId":"PPM_ATTR_100","uiDisplayCode":"PREFIX_1","type":"DROPDOWN","attrMetaInfo":{"seqNum":1,"valueType":"List","editable":"Y","mandatory":"N"}}]}]}'));
        system.debug('templateObject--->'+templateResponse);
        // TemplatDetails templateResponse = null;
        return templateResponse;
    }
    public static List<TemplatDetails> getTemplateDetailsForProductList(List<String> prodId){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        Map<String,String> request = new  Map<String,String>();
        for(String prod:prodId){
            request.put(prod,'DEFAULT');
        }
         //OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
        OrgDefaults__c config =getOrgDefaults();
        req.setHeader('Authorization', config.authorization__c);
       	String url ='callout:getTempDetList';
        
       //String url = 'https://hobs.tcs.com/hobsrestgateway/servicetemplateservice/getTemplateDetailsList';
       System.debug('url is.. '+url);
        req.setEndpoint(url);
        req.setHeader('opId','HOB');
        req.setHeader('buId','DEFAULT');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(Json.serialize(request));
        Decimal timeOut = config.defaultTimeOut__c;
        Integer customTimeOut=timeOut.intValue();
        req.setTimeout(customTimeOut);
        System.debug('Json.serialize(request) templateService.. '+Json.serialize(request));
        HttpResponse res = h.send(req);
        System.debug('res.getBody() is.. '+res.getBody());
        String responseStr = String.valueOf(res.getBody()).replaceall('type','type1');
        //List<TemplatDetails> templateResponse = TemplatDetails.parseList(String.valueOf('[{"templateId":"ST225","templateName":"VonageT","colSize":1,"templateContext":"DEFAULT","productId":"Voice300","status":{"statusCode":"0000","statusName":"Informational"},"groupDetails":[{"attrGrpId":"ATTR_GRP_237","showGrpLabel":true,"attrGrpLabel":"DN_Number","colSize":2,"displayOrder":1,"itemId":"ST_ITM1102","attributeList":[{"dependencyElements":[],"itemElementMapId":"ST_ELE1277","isRepeat":"N","repeatMinLimit":0,"repeatMaxLimit":0,"valueList":{"value":[null]},"attributeName":"DN_1","attributeId":"PPM_ATTR_372","uiDisplayCode":"DN","type":"text","attrMetaInfo":{"seqNum":2,"valueType":"Text","editable":"Y","mandatory":"N"}},{"dependencyElements":[],"itemElementMapId":"ST_ELE1278","isRepeat":"N","repeatMinLimit":0,"repeatMaxLimit":0,"valueList":{"value":["044","330","111"]},"attributeName":"PREFIX_1","attributeId":"PPM_ATTR_100","uiDisplayCode":"PREFIX_1","type":"DROPDOWN","attrMetaInfo":{"seqNum":1,"valueType":"List","editable":"Y","mandatory":"N"}}]}]},{"colSize":0,"productId":"PRD_161","status":{"statusCode":"1111","statusName":"Error","statusDescription":"No Data"}}]'));
        List<TemplatDetails> templateResponse = TemplatDetails.parseList(String.valueOf(res.getBody()));
        return templateResponse;
    }
   
    
    public Static String createOrderSubmit(String requestPayload){
        OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
         Http h = new Http();
       	 HttpRequest req = new HttpRequest();
         String url='callout:Create_sales_order';
         req.setEndpoint(url);
         req.setBody(requestPayload);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Authorization', config.authorization__c);
         
         req.setMethod('POST');
        
         HttpResponse res = h.send(req);
         String responseStr = String.valueOf(res.getBody());
         system.debug('createOrderSubmit responseStr'+responseStr);
         return responseStr;
    }*/
    
}