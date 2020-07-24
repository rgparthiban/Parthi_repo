public with sharing class QuoteController {
	
  /*
    
    @AuraEnabled
    //public Static Map <String,List<Object>> getExistingOffers(Map<String,List<Object>> completeMap, String quoteId, 
     //                                                         Map<String, Object> offerMap,String serviceType,Decimal currentVersion) //, Map<String,List<Object>> updatedMapFromUI)

    public Static Map <String,List<Object>> getExistingOffers(Map<String,List<Object>> completeMap,Map<String, Object> offerMap,Map<String,String> offerListvalue) //, Map<String,List<Object>> updatedMapFromUI)
    
    { 
        
       return FormMap.getExistingOffers(completeMap,offerMap,offerListvalue);
         //map<String,map<String,List<Object>>> completeMapWithServiceType = new map<String,map<String,List<Object>>>();
        //return FormMap.getExistingOffers(completeMapWithServiceType,completeMap, quoteId, offerMap, serviceType,currentVersion);
       
    }
    
    
    
    @AuraEnabled
     //New Query for multiple Services
    public static list<String> getQuoteServiceType(String quoteId){
        System.debug('quoteId is .. '+quoteId);
        //added for PMD fix- apex crud violation by RIMI
       if (!Schema.sObjectType.Quote.fields.Id.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
       Quote quote = [SELECT id,Opportunity.Multiple_Service__c FROM Quote WHERE Id=:quoteId];
       System.debug('multiple service---'+quote.Opportunity.Multiple_Service__c);
        string serv = quote.Opportunity.Multiple_Service__c;
        if(serv == null) {
            serv = 'ANY';
        }
        List<String> arr=  serv.split(';');
        system.debug('arr before->'+arr);
        list<string> multiServiceKey = buildMultipleServiceList(arr);
        //list<string> multi =  buildMultipleServiceList(arr);
        system.debug('multiServiceKey..services.data..'+multiServiceKey);
        Quote qt = [SELECT toLabel(Opportunity.com_tcs_telecom__Multiple_Service__c) FROM Quote WHERE Id=:quoteId];
        string srvValue = qt.Opportunity.Multiple_Service__c;
         if(srvValue == null) {
            srvValue = 'ANY';
        }
        List<String>arrValue= srvValue.split(';');
        system.debug('arrValue before->'+arrValue);
        list<string> multiServiceValue = buildMultipleServiceList(arrValue);
        insertQuoteServiceType(multiServiceKey,multiServiceValue,quoteId);
        return multiServiceKey;
    }
    
     @AuraEnabled
     //New Query for multiple Services
    public static list<String> getOrderServiceTypeNew(String quoteId){
        String orderId=quoteId;
        System.debug('orderId is .. '+orderId);
        //added for PMD fix- apex crud violation by RIMI
        if (!Schema.sObjectType.SubmitOrder__c.fields.Multi_Service_Types__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        SubmitOrder__c q = [SELECT Multi_Service_Types__c FROM SubmitOrder__c WHERE Id=:orderId];
        system.debug('Multiple_Service__c-->'+q.com_tcs_telecom__Multi_Service_Types__c);
		System.debug('multiple service quote---'+q.com_tcs_telecom__Multi_Service_Types__c);
        string serv = q.com_tcs_telecom__Multi_Service_Types__c;
        if(serv == null) {
            serv = 'ANY';
        }
        List<String> arr=  serv.split(';');
        system.debug('arr before->'+arr);
        list<string> multiServiceKey = buildMultipleServiceList(arr);
        system.debug('multi..services.data..'+multiServiceKey);
        //added for PMD fix- apex crud violation by RIMI
        if (!Schema.sObjectType.SubmitOrder__c.fields.Multi_Service_Types__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        SubmitOrder__c qt = [SELECT toLabel(SubmitOrder__c.Multi_Service_Types__c) FROM SubmitOrder__c WHERE Id=:orderId];
        string srvValue = q.Multi_Service_Types__c;
         if(srvValue == null) {
            srvValue = 'ANY';
        }
        list<string> multiServiceValue =processResponse(srvValue);
        System.debug('multiServiceValue data for order.. '+multiServiceValue);
        return multiServiceValue;
        
        
    }
    
    
     @AuraEnabled
     //New Query for multiple Services
    public static list<String> getQuoteServiceTypeNew(String quoteId){
        System.debug('quoteId is .. '+quoteId);
        Quote quote = [SELECT Opportunity.com_tcs_telecom__Multiple_Service__c FROM Quote WHERE Id=:quoteId];
        System.debug('multiple service quote---'+quote.Opportunity.Multiple_Service__c);
        string serv = quote.Opportunity.Multiple_Service__c;
        if(serv == null) {
            serv = 'ANY';
        }
        List<String> arr=  serv.split(';');
        system.debug('arr before->'+arr);
        list<string> multiServiceKey = buildMultipleServiceList(arr);
        system.debug('multi..services.data..'+multiServiceKey);
        Quote qt = [SELECT toLabel(Opportunity.com_tcs_telecom__Multiple_Service__c) FROM Quote WHERE Id=:quoteId];
        string srvValue = qt.Opportunity.Multiple_Service__c;
         if(srvValue == null) {
            srvValue = 'ANY';
        }
        list<string> multiServiceValue =processResponse(srvValue);
        insertQuoteServiceType(multiServiceKey,multiServiceValue,quoteId);
        return multiServiceValue;
        
        
    }
    
    public static list<String> processResponse(string srvValue){
       
        List<String>arrValue= srvValue.split(';');
        system.debug('arrValue before->'+arrValue);
        list<string> multiServiceValue = buildMultipleServiceList(arrValue);
        system.debug('multiServiceValue..'+multiServiceValue);
        //buildSrvcTypeMap(multiServiceKey,multiServiceValue);
        return multiServiceValue;
    }
    
    public static list<String> buildMultipleServiceList(List<String> arr)
    {
       list<String>multipleServiceList = new list<string>();
       boolean flag=false;
        for(Integer i=0;i<arr.size();i++){
            System.debug('arr[i] '+arr[i]);
            if(arr[i] != ' ' && arr[i].length()>0){
               system.debug('arr[i]is here3-->'+arr[i]); 
                String serviceType = arr[i].normalizeSpace();
                System.debug('serviceType>'+serviceType);
              //multipleServiceList.add(serviceType.deleteWhitespace());  
              multipleServiceList.add(serviceType);
              multipleServiceList.sort();
                flag=true;
            }
        }
        if(!flag){
             multipleServiceList.add('ANY');
        }
        System.debug('multipleServiceList ..'+multipleServiceList);
        return multipleServiceList;
    }
    
     @AuraEnabled
    public static Map<String,String> buildSrvcTypeMap(list<String>srvcValue,String quoteId,String reqType){
        Map<String,String> multiSrvcTypeMap = new Map<String,String>();
        System.debug('inside buildSrvcTypeMap... '+reqType);
        string serv=null;
        if(reqType == 'Order'){
            String orderId=quoteId;
            //added for PMD fix- apex crud violation by RIMI
            if (!Schema.sObjectType.com_tcs_telecom__SubmitOrder__c.fields.com_tcs_telecom__Multi_Service_Types__c.isAccessible()){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            	return null;
        	}
            com_tcs_telecom__SubmitOrder__c q = [SELECT com_tcs_telecom__Multi_Service_Types__c FROM com_tcs_telecom__SubmitOrder__c WHERE Id=:orderId];
            serv = q.com_tcs_telecom__Multi_Service_Types__c;
        }else{
        	Quote quote = [SELECT Opportunity.com_tcs_telecom__Multiple_Service__c FROM Quote WHERE Id=:quoteId];
        	System.debug('multiple service quote---'+quote.Opportunity.Multiple_Service__c);
         	serv = quote.Opportunity.Multiple_Service__c;
        }
     	
        
        if(serv!=null){
        List<String> arr=  serv.split(';');
        system.debug('arr before->'+arr);
        list<string> srvcKey = buildMultipleServiceList(arr);
        system.debug('multi..services.data..'+srvcKey);
        for(Integer i=0;i<srvcValue.size();i++)
        {
            multiSrvcTypeMap.put(srvcValue[i],srvcKey[i]);   
        }
        Utility.multiSrvcTypeMap=multiSrvcTypeMap;
        System.debug('test map--'+Utility.multiSrvcTypeMap);
        }
        
        return multiSrvcTypeMap;
    }
    
    public static String insertQuoteServiceType(List<String>srvcNameList,List<String>srvcValueList,String quoteId){
        System.debug('inside insertQuoteServiceType');
        
        List<Quote_Service_Type_List__c> quoteSrvcList = new list<Quote_Service_Type_List__c>();
        try{
            //added for PMD fix- apex crud violation by RIMI
        	if (!Schema.sObjectType.Quote_Service_Type_List__c.fields.Service_Type_Name__c.isAccessible()){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            	//return null;
        	}
            List<Quote_Service_Type_List__c> oldList=[SELECT quoteId__c,Service_Type_Name__c,Service_Type_Value__c,CreatedById
        											,CurrencyIsoCode,LastModifiedById,OwnerId,Name FROM Quote_Service_Type_List__c
        											WHERE quoteId__c=:quoteId];
        	if (!Quote_Service_Type_List__c.sObjectType.getDescribe().isDeletable()){
      			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            	//return null; 
     		}
            System.debug('oldList size..'+oldList.size());
            delete oldList;
            for(Integer i=0;i<srvcNameList.size();i++)
         	{
            
                Quote_Service_Type_List__c listObj = new Quote_Service_Type_List__c();
             	listObj.quoteId__c=quoteId;
             	listObj.Service_Type_Name__c=srvcNameList[i];
             	listObj.Service_Type_Value__c=srvcValueList[i];
                System.debug('Servicetype name..'+listObj.Service_Type_Name__c);
                System.debug('Servicetype Value..'+listObj.Service_Type_Value__c);
             	quoteSrvcList.add(listObj); 
         	}
            //added for PMD fix- apex crud violation by RIMI
         	if (!Schema.sObjectType.Quote_Service_Type_List__c.fields.Service_Type_Name__c.isCreateable() &&
                        !Schema.sObjectType.Quote_Service_Type_List__c.fields.Service_Type_Value__c.isCreateable()){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                            return null;
                            
                        }else{
                            insert quoteSrvcList;
                        }
        	
        }
        catch(Exception e){
           System.debug('exception'+e); 
        }
       	return null; 
    }
    
    public static String getSrvcNameBySrvcValue(String serviceType,String quoteId){
        String serviceTypeName=null;
        try{
             Quote_Service_Type_List__c quoteSrvc= [SELECT Service_Type_Name__c FROM Quote_Service_Type_List__c WHERE quoteId__c=:quoteId AND Service_Type_Value__c=:serviceType];
        	if(quoteSrvc!=null)
       		 {
          		serviceTypeName=quoteSrvc.Service_Type_Name__c;
       		 }
        }
        catch(Exception e){
            System.debug('exception in getSrvcNameBySrvcValue'+e);
        }
       
        return serviceTypeName;
    }
    
    @AuraEnabled
    public static Map<String,List<Map<String,String>>> fetchExistingAttributes(String quoteId,decimal currentVersion) {
        return PackageController.fetchExistingAttributes(quoteId, currentVersion);
    }
    
    
    
    
    @AuraEnabled
     public static Map<String,Map<String, List<Object>>> getFinalMap(List<String> selectedOffers, String gridJson, String quoteId, String attributeList, String existOfferMap,
        Decimal currentVersion){
        return PackageController.getFinalMap(selectedOffers,  gridJson,  quoteId,  attributeList,  existOfferMap,
         currentVersion);
    } 
    
    @AuraEnabled
    
    public static Map<String,String> getPriceCalculationRevampForBOB(String productLineItemMapStr){
        return PackageController.getPriceCalculationRevampForBOB(productLineItemMapStr);
    }
    
     @AuraEnabled
    public static list<String> getOrderServiceType(String quoteId){
        return OrderController.getOrderServiceType(quoteId);
    }
    */
    
}