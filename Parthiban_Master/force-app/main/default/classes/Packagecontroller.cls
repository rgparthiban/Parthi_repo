public with sharing class Packagecontroller {
    public static Integer nameLength = 40;
    public static Integer age=20;
    /*setter injection for OrgDefault config */
/*    static OrgDefaults__c configGlobal =OrgDefaults__c.getvalues('RestVariables');
    
    
    public static void setOrgDefaults(OrgDefaults__c orgDefaults){
        configGlobal = orgDefaults;
    }
    
    public static OrgDefaults__c getOrgDefaults()
    {
        return configGlobal;
    }
    
    static OfferabilityConfig__c offerabilityConfig=OfferabilityConfig__c.getvalues('offerabilityApi');
    
    public static void setOfferabilityConfig(OfferabilityConfig__c offerability){
        offerabilityConfig = offerability;
    }
    
    public static OfferabilityConfig__c getOfferabilityConfig()
    {
        return offerabilityConfig;
    }
    
 
    
 @AuraEnabled
 public static String getActionButtonsForQuote(){
  String response=null;
  try{
          List<Quote_Action_Button__c> actionBtnList = new List<Quote_Action_Button__c>();
          List<QuoteActionObject> actionObjList=new List<QuoteActionObject>();
          actionBtnList=[SELECT Name,Button_Label__c,Button_component__c,Display_Order__c,Quote_Status__c,Opportunity_Stage__c FROM Quote_Action_Button__c WHERE Button_Enabled__c =: true ORDER BY Display_Order__c ASC];
             for(Quote_Action_Button__c action:actionBtnList){
                 QuoteActionObject obj=new QuoteActionObject();
                 obj.buttonLabel=action.Button_Label__c;
                 obj.componentName=action.Button_component__c;
                 obj.buttonName=action.Name;
                 system.debug('action.Quote_Status__c---'+action.Quote_Status__c);
                 if(action.Quote_Status__c!=null){
                   obj.quoteStatus.addAll(action.Quote_Status__c.split(';'));
                }
                 if(action.Opportunity_Stage__c!=null){
                   obj.OpportunityStage.addAll(action.Opportunity_Stage__c.split(';'));
                 }
                 actionObjList.add(obj);
             }
          response=JSON.serialize(actionObjList);
     }
     catch(Exception e){
         system.debug('exception in action btn--'+e.getStackTraceString());
     }
 
  return response;
}
    
 
    @AuraEnabled   
    public static String fetchSearchProduct(String selectedSiteId,String serviceType, String srvcTypeMap,boolean fromTest,String quoteId){
        system.debug('inside fetch searchProduct...'+serviceType+'  srvcTypeMap'+srvcTypeMap+selectedSiteId);
        system.debug('Inside Site details'+selectedSiteId);
        try{
            if(serviceType == null)
            {
                serviceType='ANY' ;  
            }  
            PCServiceCall pccall = new PCServiceCall();
            
            String srvcCatg=null;
            
            Map<String,String>srvcMap;
            System.debug('srvcTypeMaps-new-'+srvcTypeMap);
            if(srvcTypeMap!=null)
            {
                srvcMap = (Map<String,String>)System.JSON.deserialize(srvcTypeMap, Map<String,String>.class);
                System.debug('srvcMap-new-'+srvcMap);
                srvcCatg=srvcMap.get(serviceType);
                
                System.debug('srvcCatg in if -->>'+srvcCatg);
            }
            else
            {
                srvcCatg=serviceType;
                System.debug('srvcCatg in else-->>'+srvcCatg);
            }
            //srvcCatg =srvcCatg.replaceAll('[^a-zA-Z0-9\\s+]', '');
            String srvcCatg1;
            srvcCatg1=srvcCatg;
            srvcCatg1=srvcCatg.replaceAll('[^a-zA-Z0-9\\s+]', '');
            System.debug('srvcCatg-->>'+srvcCatg);
            System.debug('srvcCatg1-->>'+srvcCatg1);
            String jsonStr;
            SearchProductResponse offer;
            String quoteVersion='1.0';
            //getting list of offerability criteria dynamically from config
            List<Param_Configure__c>paramList=new List<Param_Configure__c>();
            paramList = [select com_tcs_telecom__FieldName__c,com_tcs_telecom__FieldValue__c
                                              From com_tcs_telecom__Param_Configure__c 
                                              where com_tcs_telecom__Enabled__c  =: true and com_tcs_telecom__Service_Types__c =: srvcCatg];
            if(quoteId!=null){
               OfferabilityConfig__c offerabilityConf=getOfferabilityConfig();
               String offerabilityApi=offerabilityConf.Offerability_Api_Name__c;
               Type t = Type.forName(offerabilityApi);
        	   OfferabilityMapInterface offerabilityObj = (OfferabilityMapInterface)t.newInstance();
               paramList=offerabilityObj.mapOfferabilityValue(paramList,quoteId,quoteVersion,selectedSiteId);
            }


            if(fromTest == null) {
                fromTest = false;
            }
            // WO cache
            if(fromTest) {
                
                try{
                    
                    
                    jsonStr = pccall.searchProducts(paramList,srvcCatg);
                    system.debug('fetchproduct jsonStr'+jsonStr);
                    offer = SearchProductResponse.parse(jsonStr);
                }catch(Exception ee) {
                    system.debug('exception in calling fetchproduct'+ee.getMessage()+ee.getStackTraceString());
                    return 'NoResponseError';
                }
                
            } else {
                //with cache
                offer = (SearchProductResponse)Cache.Org.get('com_tcs_telecom.getProdPriceCache.'+srvcCatg1.deleteWhitespace());
                if(offer==null) {
                    system.debug('data not available in cache making actual call');
                    ////PackageOffer offer = pccall.getPackages(serviceType);
                    jsonStr = pccall.searchProducts(paramList,srvcCatg);
                    if(jsonStr==null) {
                        return 'NoResponseError';
                    }
                    System.debug('jsonStr----'+JSON.serialize(jsonStr));
                    offer = SearchProductResponse.parse(jsonStr);
                    Cache.Org.put('com_tcs_telecom.getProdPriceCache.'+srvcCatg1.deleteWhitespace(),offer);
                } 
                //end cache
            } 
            String status = offer.statusList.get(0).statusCode;
            if(status.equals('0000')) {
                JSONGenerator gen = JSON.createGenerator(true);
                //// boolean childbundleflag=false;
                List<SearchProductResponse.cls_ProductItem> productItem = offer.getProductItem();
                gen.writeStartArray();     
                Integer i=0;
                        
                for(SearchProductResponse.cls_ProductItem item:productItem){
                   //i++;  
                    // if (i <5){
                    if(item.productType == 'Package') {   
                        
                        gen.writeStartObject(); 
                        //String name = item.productDesc; // commented for DNA defect 597
                        String name = item.label; // added for DNA defect 597
                        if(name!=null && name.length() > nameLength) {
                            name = name.substring(0, nameLength);
                            name = name + '...';
                        }
                        gen.writeStringField('hiddenName',name+item.productDesc);
                        gen.writeStringField('displayName', name);
                        gen.writeStringField('Name', item.productDesc);
                        //gen.writeStringField('Name', item.label);
                        // gen.writeStringField('ProductType', item.getserviceType());comm
                        gen.writeStringField('ProductType', item.productType);
                        gen.writeStringField('ProductSpec', item.productSpecID);
                        //gen.writeStringField('RC', item.productRecurringCharges.amount);
                        // gen.writeStringField('NRC', item.productNonRecurringCharges.amount);
                        //gen.writeStringField('currency', prc.currencyy);
                        gen.writeBooleanField('isChecked', false);
                        gen.writeBooleanField('isDisabled', false);
                        
                        gen.writeBooleanField('pkgDetailsCalled', false);
                        
                        ////   List<Object> productsSpec =item.getproductSpec();
                        ////	List<Object> productOfferingList = item.getproductOffering();
                        gen.writeFieldName('_children');
                        gen.writeStartArray();
                        ////     fetchChilds(item, gen,name);
                        gen.writeEndArray(); 
                        gen.writeEndObject(); 
                        }
                  // }
                }
                gen.writeEndArray();   
                String responseStr = gen.getAsString();
                System.debug('-response--' +responseStr);
                return responseStr;
            }
            else {
                return 'ErrorCodeFromPC';
            }
        }catch(Exception e) {
            System.debug('-Exception in search product --' +e.getMessage()+e.getStackTraceString());
            return 'exception'+e.getMessage()+e.getStackTraceString();
        }
    } 
    /*
* This is used to retrieve Products/Bundles under expanded package
* calling getPackageDetails from pc
*/
    
    
    
    ///jagriti added
    /*   @AuraEnabled   
public static String fetchSearchProduct(String serviceType, String srvcTypeMap){
system.debug('inside fetch searchProduct...'+serviceType+'  srvcTypeMap'+srvcTypeMap);
if(serviceType == null)
{
serviceType='ANY' ;  
}  
PCServiceCall pccall = new PCServiceCall();
////PackageOffer offer = pccall.getPackages(serviceType);
String jsonStr = pccall.searchProducts(serviceType,srvcTypeMap);
//// String jsonStr = '{"interactionID":"I6887935","interactionDate":"2016-02-02T18:30:00.000+0000","interactionDateComplete":"2018-12-31T11:49:36.030+0000","interactionStatus":"Success","sourceApplicationID":"devtest","serviceName":"searchProduct","triggeredBy":"dev","uuid":"app_ppm_user","channel":"SALES","opID":"HOB","buID":"DEFAULT","serviceKeyList":{"attribute":[{"attributeName":"ID"},{"attributeName":"DESC"},{"attributeName":"TYPE"},{"attributeName":"CATEGORY"}]},"statusList":[{"statusCode":"0000","statusType":"Informational"}],"productItem":[{"productSpecID":"PRD_12","productDesc":"100 Min Talk Time","isPrimary":false,"isAlacarte":true,"productType":"VAS","productCategory":"VAS","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"50.0"},"productNonRecurringCharges":{"currency":"INR","amount":"500.0"}},{"productSpecID":"PRD_15","productDesc":"suspend","isPrimary":false,"isAlacarte":true,"productType":"SUSPENDCHARGE","productCategory":"BARALL","serviceType":"/account","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"20.0"}},{"productSpecID":"15GBTurboPlus","productDesc":"15GBTurboPlus","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"330.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_114","productDesc":"3wayConference","isPrimary":false,"isAlacarte":true,"productType":"VAS","productCategory":"VAS","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"60.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_123","productDesc":"EventDiscount","isPrimary":false,"isAlacarte":true,"productType":"Discount","productCategory":"DISCOUNT","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"10.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_124","productDesc":"ChangeTNCharge","isPrimary":false,"isAlacarte":true,"productType":"NUMBER","productCategory":"OTHER","serviceType":"/service/telco/gsm/telephony","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"10.0"}},{"productSpecID":"CISCO_IP","productDesc":"CISCO_IP","isPrimary":false,"isAlacarte":true,"productType":"CPE","productCategory":"HOMEPHONE","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"VonageTalk","productDesc":"Vonage Talk","isPrimary":true,"isAlacarte":false,"productType":"Package","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"900.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"VonagePremium","productDesc":"Vonage Premium","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"250.0"},"productNonRecurringCharges":{"currency":"INR","amount":"101.0"}},{"productSpecID":"PRD_180","productDesc":"Deposit","isPrimary":false,"isAlacarte":true,"productType":"DEPOSIT","productCategory":"GLOBAL","serviceType":"/service/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"BREEZE","productDesc":"BREEZE","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"699.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Airtel_Broadband","productDesc":"Airtel_Broadband","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"500.0"}},{"productSpecID":"ISDN_Extension","productDesc":"ISDN_Extension","isPrimary":false,"isAlacarte":false,"productType":"Bundle","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"100.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1166","productDesc":"DATASERVICESUSPEND","isPrimary":false,"isAlacarte":true,"productType":"BAR","productCategory":"BROADBAND","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1104","productDesc":"Antivirus","isPrimary":false,"isAlacarte":true,"productType":"VAS","productCategory":"VAS","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"150.0"}},{"productSpecID":"BLAZE","productDesc":"BLAZE","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"699.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"25GBTurboPlus","productDesc":"25GB Turbo Plus","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"250.0"},"productNonRecurringCharges":{"currency":"INR","amount":"2500.0"}},{"productSpecID":"ISDN2","productDesc":"ISDN2.0","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"100.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1328","productDesc":"Number Of Units","isPrimary":false,"isAlacarte":false,"productType":"Data","productCategory":"DATA","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BLAZE100","productDesc":"BLAZE","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Broadband_Upgrade","productDesc":"Broadband_Upgrade","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"75.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"IPVPNClassic","productDesc":"IP VPN Classic","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"VPN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"4000.0"},"productNonRecurringCharges":{"currency":"INR","amount":"4000.0"}},{"productSpecID":"HomeTalk_Unlimited","productDesc":"HomeTalk_Unlimited","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"150.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"DualPlayPackage","productDesc":"Dual Play Package ","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"2200.0"},"productNonRecurringCharges":{"currency":"INR","amount":"600.0"}},{"productSpecID":"1015P","productDesc":"HOVEDNUMMER","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"PSTN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"1500.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Airtel_BB","productDesc":"Airtel_BB","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"1500.0"},"productNonRecurringCharges":{"currency":"INR","amount":"500.0"}},{"productSpecID":"PRD_1461","productDesc":"VAS_RPS","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"VAS","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"400.0"}},{"productSpecID":"PRD_1462","productDesc":"CPE_PRA","isPrimary":true,"isAlacarte":true,"productType":"CPE","productCategory":"CPE","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1466","productDesc":"SS_ACCOUNT","isPrimary":true,"isAlacarte":true,"productType":"PRODUCT","productCategory":"GLOBAL","serviceType":"/account","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"60.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1456","productDesc":"MODEM_1.0_AT","isPrimary":true,"isAlacarte":true,"productType":"CPE","productCategory":"CPE","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"200.0"}},{"productSpecID":"DSLHOME","productDesc":"DSLHOME","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"DSL","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"200.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1516","productDesc":"10468_Broadband","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"BROADBAND","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"20.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"CPE_Modem","productDesc":"CPE_Modem","isPrimary":false,"isAlacarte":true,"productType":"CPE","productCategory":"HOMEPHONE","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"200.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"10063BUNDLE","productDesc":"10063BUNDLE","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1532","productDesc":"10246_CPE","isPrimary":true,"isAlacarte":true,"productType":"CPE","productCategory":"BROADBAND","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"350.0"},"productNonRecurringCharges":{"currency":"INR","amount":"200.0"}},{"productSpecID":"ISDN_BASIC","productDesc":"ISDN_BASIC","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"ISDN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"500.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BB350MBPS","productDesc":"BB350MBPS","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"LEASEDLINE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"40.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BB1","productDesc":"BB1","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"800.0"},"productNonRecurringCharges":{"currency":"INR","amount":"1500.0"}},{"productSpecID":"PRD_1735","productDesc":"ActiveFamilyDiscount","isPrimary":true,"isAlacarte":true,"productType":"Discount","productCategory":"DISCOUNT","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"CampAAPack","productDesc":"CampAAPack","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"500.0"},"productNonRecurringCharges":{"currency":"INR","amount":"1000.0"}},{"productSpecID":"PRD_1737","productDesc":"CampAAAddon","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"BROADBAND","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"300.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1738","productDesc":"CampAddDiscountRC_10P","isPrimary":true,"isAlacarte":true,"productType":"Discount","productCategory":"BROADBAND","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1749","productDesc":"AddonDisHp_NRC50AB","isPrimary":true,"isAlacarte":true,"productType":"Discount","productCategory":"HOMEPHONE","serviceType":"/service/telco/gsm/telephony","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"0.0"}},{"productSpecID":"PRD_1668","productDesc":"DP30PRC_HP","isPrimary":false,"isAlacarte":true,"productType":"Discount","productCategory":"HOMEPHONE","serviceType":"/service/telco/gsm/telephony","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Airtel_MyPlan199","productDesc":"Airtel-MyPlan199","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"199.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1692","productDesc":"DP45ABNRC_HP","isPrimary":false,"isAlacarte":true,"productType":"Discount","productCategory":"HOMEPHONE","serviceType":"/service/telco/gsm/telephony","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"0.0"}},{"productSpecID":"SERVICES_M","productDesc":"SERVICES M","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"LEASEDLINE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"322.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Broadband_L","productDesc":"Broadband L","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"322.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_1732","productDesc":"MultipleDiscount","isPrimary":true,"isAlacarte":true,"productType":"Discount","productCategory":"DISCOUNT","serviceType":"/service/telco/gsm/telephony","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"11650_Pack","productDesc":"11650_Pack","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BB_NEW_05","productDesc":"BB_NEW_05","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"700.0"},"productNonRecurringCharges":{"currency":"INR","amount":"1000.0"}},{"productSpecID":"PSTN_PACKAGE","productDesc":"PSTN_PACKAGE","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"PSTN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"1500.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"ISDN_10","productDesc":"ISDN_10","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"ISDN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"500.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DSL_PACK","productDesc":"DSL_PACK","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"DSL","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"250.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BB10","productDesc":"BB10","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"1000.0"}},{"productSpecID":"PRD_2026","productDesc":"20Percent Discount_Addon","isPrimary":true,"isAlacarte":true,"productType":"Discount","productCategory":"DISCOUNT","serviceType":"/service/telco/ip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"0.0"}},{"productSpecID":"POPCF018","productDesc":"Package_Testing","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"PSTN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"100.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Deposit_Product_1","productDesc":"Deposit_Product_1","isPrimary":true,"isAlacarte":true,"productType":"DEPOSIT","productCategory":"GLOBAL","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"12Month_CID","productDesc":"12MonthContract_Desc","isPrimary":false,"isAlacarte":false,"productType":"Contract","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD0193","productDesc":"100 Min Talktime_1","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"VAS","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"150.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"150MinTT","productDesc":"150MinTT","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"USD","amount":"100.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BOB_BULK_VS","productDesc":"BOB BULK VS","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"PSTN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"525.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"HOBSMobilePlan","productDesc":"HOBS Mobile Plan","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"678.0"},"productNonRecurringCharges":{"currency":"INR","amount":"130.0"}},{"productSpecID":"VoiceBundle","productDesc":"Voice Bundle","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"153.0"},"productNonRecurringCharges":{"currency":"INR","amount":"30.0"}},{"productSpecID":"150MBAdditionalBundle","productDesc":"150MB Additional Bundle","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"SIMCard","productDesc":"SIM Card","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PO_VPBX","productDesc":"VPBX Service","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"SwitchBoard","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"30000.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PRD_8693","productDesc":"AttrBsdPricing","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"20.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"VPBX","productDesc":"Virtual PBX","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"VPBX","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"RC_DISCOUNT","productDesc":"RC_DISCOUNT","isPrimary":true,"isAlacarte":true,"productType":"DISCOUNT","productCategory":"DISCOUNT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"NRC_DISCOUNT","productDesc":"NRC_DISCOUNT","isPrimary":true,"isAlacarte":true,"productType":"DISCOUNT","productCategory":"DISCOUNT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"CableTV","productDesc":"Cable TV","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"TV","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"140.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BroadbandTV","productDesc":"Broadband Plus TV","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"270.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"TestOff","productDesc":"TestOff","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"CPE_Dish","productDesc":"Satellite Dish","isPrimary":true,"isAlacarte":true,"productType":"INVENTORY","productCategory":"CPE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"850.0"}},{"productSpecID":"NVision_Small","productDesc":"NVision Small","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"Mobile","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"100.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Product_Test_1","productDesc":"Product_Test_1","isPrimary":true,"isAlacarte":true,"productType":"DEVICE","productCategory":"BROADBAND","isCompositeService":"Y","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"15000.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"CP_pck","productDesc":"CP_pck","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"1000.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Account_Product","productDesc":"Account Product","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"ACCOUNT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"200.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Cloudstorage","productDesc":"Cloud Storage","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"39.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Pac_BOB_Test2","productDesc":"Pac_BOB_Test2","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"100.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"CC_Document_Charge","productDesc":"CC_Document_Charge","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"GLOBAL","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"dnatest","productDesc":"dnatest","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"voip","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Pac_ReID_Test1","productDesc":"Pac_ReID_Test1","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"200.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Bundle_ReID_test1","productDesc":"Bundle_ReID_test1","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"300.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Discount20Ab","productDesc":"Discount20Ab","isPrimary":true,"isAlacarte":true,"productType":"Discount","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DataPlan","productDesc":"DataPlan","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DISCOUNT_USG","productDesc":"DISCOUNT_USG","isPrimary":true,"isAlacarte":true,"productType":"PRODUCT","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DISCOUNT_BILL","productDesc":"DISCOUNT_BILL","isPrimary":true,"isAlacarte":true,"productType":"PRODUCT","productCategory":"HOMEPHONE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BILL_DISC","productDesc":"BILL_DISC","isPrimary":true,"isAlacarte":true,"productType":"DISCOUNT","productCategory":"DISCOUNT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Pac_OfferTest_5","productDesc":"Pac_OfferTest_5","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"USG_DISC1","productDesc":"USG_DISC1","isPrimary":true,"isAlacarte":true,"productType":"DISCOUNT","productCategory":"DISCOUNT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"ReleaseID_Check","productDesc":"ReleaseID_Check","isPrimary":true,"isAlacarte":false,"productType":"VAS","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DNATextValProd","productDesc":"DNATextValProd","isPrimary":true,"isAlacarte":true,"productType":"VAS","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"CPE","productDesc":"CPE","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"VPN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DNA","productDesc":"DNA","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"VPN","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"POSwitchBoard","productDesc":"HOBS Virtual PBX","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"VPBX_COMPANY","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"DNA_VALO_FLEX","productDesc":"DNA Valo Flex","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"678.0"},"productNonRecurringCharges":{"currency":"INR","amount":"130.0"}},{"productSpecID":"SKYdirect_KIT","productDesc":"SKYdirect KIT","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"TVT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"2599.0"}},{"productSpecID":"SKYdirect_BOX","productDesc":"SKYdirect BOX ONLY","isPrimary":true,"isAlacarte":true,"productType":"INVENTORY","productCategory":"CPE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"currency":"INR","amount":"1499.0"}},{"productSpecID":"POGroupAssistant","productDesc":"DNA Virtual PBX Service Assistant Group","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"VPBX_COMPANY","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"HB_PACKAGE","productDesc":"HOBS DATA Plan","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"Mobile","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"BOB_DOWNGRADE","productDesc":"BOB DOWNGRADE","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"153.0"},"productNonRecurringCharges":{"currency":"INR","amount":"30.0"}},{"productSpecID":"option","productDesc":"option","isPrimary":true,"isAlacarte":false,"productType":"CORE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"Mandatory","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"tv","productDesc":"tv","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"TVT","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"Pac_BOB_Test_1","productDesc":"Pac_BOB_Test_1","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"100.0"},"productNonRecurringCharges":{"currency":"INR","amount":"100.0"}},{"productSpecID":"OfferabilityBundle","productDesc":"OfferabilityBundle","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"TestPack790","productDesc":"TestPack790","isPrimary":true,"isAlacarte":false,"productType":"BUNDLE","productCategory":"MOBILE BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"ClearChannel","productDesc":"Clear Channel","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"BROADBAND","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"15000.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"PartnerVoicePack7+","productDesc":"PartnerPackage7+","isPrimary":false,"isAlacarte":false,"productType":"PACKAGE","productCategory":"PARTNER","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"currency":"INR","amount":"150.0"},"productNonRecurringCharges":{"amount":"0.0"}},{"productSpecID":"AccessPackage","productDesc":"AccessPackage","isPrimary":true,"isAlacarte":false,"productType":"PACKAGE","productCategory":"MOBILE","isCompositeService":"N","catalogID":"DEF_CATALOG","defaultState":"OptIn","associatedOfferInstance":[],"productRecurringCharges":{"amount":"0.0"},"productNonRecurringCharges":{"amount":"0.0"}}]}';
SearchProductResponse offer = SearchProductResponse.parse(jsonStr);
JSONGenerator gen = JSON.createGenerator(true);
List<SearchProductResponse.cls_statusList> statusList = offer.getstatusList();
List<SearchProductResponse.cls_ProductItem> productItem = offer.getProductItem();
gen.writeStartArray();  
for(SearchProductResponse.cls_statusList itemStatus:statusList){
gen.writeStartObject(); 
gen.writeStringField('statusCode',itemStatus.statusCode);
gen.writeStringField('statusType', itemStatus.statusType);
gen.writeEndObject(); 
} 

for(SearchProductResponse.cls_ProductItem item:productItem){
gen.writeStartObject(); 
String name = item.productDesc;
if(name.length() > nameLength) {
name = name.substring(0, nameLength);
name = name + '...';
}
gen.writeStringField('hiddenName',name+item.productDesc);
gen.writeStringField('displayName', name);
gen.writeStringField('Name', item.productDesc);
// gen.writeStringField('ProductType', item.getserviceType());comm
gen.writeStringField('ProductType', item.productType);
gen.writeStringField('ProductSpec', item.productSpecID);
gen.writeBooleanField('isChecked', false);
gen.writeBooleanField('isDisabled', false);

gen.writeBooleanField('pkgDetailsCalled', false);

////   List<Object> productsSpec =item.getproductSpec();
////	List<Object> productOfferingList = item.getproductOffering();
gen.writeFieldName('_children');
gen.writeStartArray();
////     fetchChilds(item, gen,name);
gen.writeEndArray(); 
gen.writeEndObject(); 
}

gen.writeEndArray();   
String responseStr = gen.getAsString();
System.debug('-response--' +responseStr);
return responseStr;
/*ResponseObject responseObject = (ResponseObject)System.JSON.deserialize(responseStr, ResponseObject.class);
List<Status> statusLst = responseObject.statusList;
Status ss = null;
if(statusLst != null && statusLst.size()>0) {
ss = statusLst.get(0);
}
if(ss != null && ss.statusCode == '0000') {
} 

} *//*
    
    
    ///jagriti ended
    
    @AuraEnabled   
    public static String fetchPackageDetails(String pkgName,String gridData,boolean calledFromTest){
        System.debug('in fetchPackageDetails'+gridData);
        gridData = gridData.replaceAll('_children', 'childrnObject');
        gridData = gridData.replaceAll('currency', 'currency1');
        List<GridJSON> gridObject;
        gridObject = (List<GridJSON>)System.JSON.deserialize(gridData, List<GridJSON>.class);
        system.debug('gridObject'+gridObject.size());
        PCServiceCall pccall = new PCServiceCall();
        List<String> productSpecList = new List<String>();
        Map<String,String> attributeMap = new Map<String,String>();
        String prdSpec;
        for(GridJSON grid : gridObject) {
            System.debug('pkgName..'+pkgName + '-grid.Name-'+grid.Name);
            if(pkgName.equals(grid.Name)) {
                productSpecList.add(grid.ProductSpec);
                prdSpec = grid.ProductSpec;
            }
        }
        //WO cache
        //// PackageOffer offer = pccall.getPackageDetails(productSpecList,attributeMap);
        
        PackageOffer offer;
        if(calledFromTest == null){ 
            calledFromTest = false;
        }
        //With cache
        if(!calledFromTest) {
            String prdSpecRemove = prdSpec.replaceAll('[^a-zA-Z0-9+]','');
            offer = (PackageOffer)Cache.Org.get('com_tcs_telecom.getProdPriceCache.pkgDetails'+prdSpecRemove);
            if(offer==null) {
                system.debug('fetchPackageDetails - cache miss. actual call is made');
                offer = pccall.getPackageDetails(productSpecList,attributeMap);
                Cache.Org.put('com_tcs_telecom.getProdPriceCache.pkgDetails'+prdSpecRemove,offer);
            }
        } else {
            offer = pccall.getPackageDetails(productSpecList,attributeMap);
        }
        system.debug('offer before1'+offer);
        ////ProductPrice offer = pccall.getPackageDetails(productSpecList,attributeMap);
        JSONGenerator gen = JSON.createGenerator(true);
        boolean childbundleflag=false;
        List<ProductOffering> productItem = offer.getPackages();
        //gen.writeStartArray();      
        for(ProductOffering item:productItem){
            gen.writeStartObject(); 
            String name = item.getlabel(); // added for DNA defect 597
            //String name = item.getname(); //commented for DNA defect 597
            if(name.length() > nameLength) {
                name = name.substring(0, nameLength);
                name = name + '...';
            }
            gen.writeStringField('hiddenName',name+item.getname());
            gen.writeStringField('displayName', name);
            gen.writeStringField('Name', item.getname());
            //gen.writeStringField('Name', item.getlabel());
            // gen.writeStringField('ProductType', item.getserviceType());comm
            gen.writeStringField('ProductType', item.getProductType());
            gen.writeStringField('ProductSpec', item.getproductOfferingId());
            gen.writeBooleanField('isChecked', false);
            gen.writeBooleanField('isDisabled', false);
            
            gen.writeBooleanField('pkgDetailsCalled', true);
            
            List<Object> productsSpec =item.getproductSpec();
            List<Object> productOfferingList = item.getproductOffering();
            gen.writeFieldName('childrnObject');
            gen.writeStartArray();
            fetchChilds(item, gen,name);
            gen.writeEndArray(); 
            gen.writeEndObject(); 
        }
        // gen.writeEndArray();   
        String responseStr = null;
        responseStr =  gen.getAsString();
        if(responseStr == null || responseStr.equals('') ) {
            gridData = gridData.replaceAll('childrnObject', '_children');
            gridData = gridData.replaceAll('currency1', 'currency');
            return gridData;
        } else {
            System.debug('-responseStr b42:' +responseStr);
            responseStr = responseStr.replaceAll('_children', 'childrnObject');
            responseStr = responseStr.replaceAll('currency', 'currency1');
            //responseStr = responseStr.replaceAll('INR', 'EUR');
            System.debug('-responseStr after' +responseStr);
            GridJSON gridRespObject;
            gridRespObject = (GridJSON)System.JSON.deserialize(responseStr, GridJSON.class);
            System.debug('-response--' +gridRespObject);
            Integer i = 0;
            List<GridJSON> gridObjectCopy = new List<GridJSON>();
            
            for(GridJSON grid : gridObject) {
                i++;
                if(pkgName.equals(grid.Name)) {
                    system.debug('in if pkgName'+pkgName+'grid.Name'+grid.Name);
                    gridObjectCopy.add(gridRespObject);
                    //system.debug('gridObjectCopy[i]'+gridObjectCopy[i]);
                    //break;
                }
                else {
                    gridObjectCopy.add(grid);
                }
            }
            
            //  System.debug('-gridObject--' +gridObjectCopy);
            String s = JSON.serialize(gridObjectCopy);
            s  = s.replaceAll('childrnObject', '_children');
            s  = s.replaceAll('currency1', 'currency');
            System.debug('return stringK'+s);
            return s;
        }
    }
    
    /*
* calling getPackageDetails from pc if not called while expand

    @AuraEnabled   
    public static String getPkgDetailForOffer(String addedOffer,boolean calledFromTest){
        System.debug('in fetchPackageDetailsfor an addedOffer'+addedOffer);
        addedOffer = addedOffer.replaceAll('_children', 'childrnObject');
        addedOffer = addedOffer.replaceAll('currency', 'currency1');
        GridJSON gridObject;
        gridObject = (GridJSON)System.JSON.deserialize(addedOffer, GridJSON.class);
        system.debug('gridObject'+gridObject);
        if(gridObject.pkgDetailsCalled) {
            addedOffer = addedOffer.replaceAll('childrnObject', '_children');
            addedOffer = addedOffer.replaceAll('currency1', 'currency');
            return addedOffer;
        } else {
            PCServiceCall pccall = new PCServiceCall();
            List<String> productSpecList = new List<String>();
            Map<String,String> attributeMap = new Map<String,String>();
            // for(GridJSON grid : gridObject) {
            //    if(PkgName.equals(grid.Name)) {
            productSpecList.add(gridObject.ProductSpec);
            //   }
            //  }
            //With cache
            //// CODE WITH CACHE. PLS DONT REMOVE
            PackageOffer offer;
            if(calledFromTest == null){
                calledFromTest = false;
            }
            if(calledFromTest) {
                offer = pccall.getPackageDetails(productSpecList,attributeMap);
            } else {
                String prdSpecBefore = gridObject.ProductSpec;
                String prdSpecRemove = (prdSpecBefore).replaceAll('[^a-zA-Z0-9+]','');
                offer = (PackageOffer)Cache.Org.get('com_tcs_telecom.getProdPriceCache.pkgDetails'+prdSpecRemove);
                if(offer==null) {
                    offer = pccall.getPackageDetails(productSpecList,attributeMap);
                    Cache.Org.put('com_tcs_telecom.getProdPriceCache.pkgDetails'+prdSpecRemove,offer);
                }
            }
            //end
            
            ////PackageOffer offer = pccall.getPackageDetails(productSpecList,attributeMap); // WO cache
            
            JSONGenerator gen = JSON.createGenerator(true);
            boolean childbundleflag=false;
            List<ProductOffering> productItem = offer.getPackages();
            //gen.writeStartArray();      
            for(ProductOffering item:productItem){
                gen.writeStartObject(); 
                //// String name = item.getname();  // commented for DNA defect 597 
                String name = item.getlabel();  // added for DNA defect 597
                if(name.length() > nameLength) {
                    name = name.substring(0, nameLength);
                    name = name + '...';
                }
                gen.writeStringField('hiddenName',name+item.getname());
                gen.writeStringField('displayName', name);
                gen.writeStringField('Name', item.getname());
                //gen.writeStringField('Name', item.getLabel());
                // gen.writeStringField('ProductType', item.getserviceType());comm
                gen.writeStringField('ProductType', item.getProductType());
                gen.writeStringField('ProductSpec', item.getproductOfferingId());
                gen.writeBooleanField('isChecked', false);
                gen.writeBooleanField('isDisabled', false);
                
                gen.writeBooleanField('pkgDetailsCalled', true);
                
                
                List<Object> productsSpec =item.getproductSpec();
                List<Object> productOfferingList = item.getproductOffering();
                gen.writeFieldName('childrnObject');
                gen.writeStartArray();
                fetchChilds(item, gen,name);
                gen.writeEndArray(); 
                gen.writeEndObject(); 
            }
            // gen.writeEndArray();   
            String responseStr = gen.getAsString();
            // System.debug('-responseStr b4:' +responseStr);
            responseStr = responseStr.replaceAll('childrnObject', '_children');
            responseStr = responseStr.replaceAll('currency1', 'currency');
            System.debug('-responseStr after' +responseStr);
            /*GridJSON gridRespObject;
gridRespObject = (GridJSON)System.JSON.deserialize(responseStr, GridJSON.class);
System.debug('-response--' +gridRespObject);
Integer i = 0;
List<GridJSON> gridObjectCopy = new List<GridJSON>();

for(GridJSON grid : gridObject) {
i++;
if(PkgName.equals(grid.Name)) {
system.debug('in if PkgName'+PkgName+'grid.Name'+grid.Name);
gridObjectCopy.add(gridRespObject);
//system.debug('gridObjectCopy[i]'+gridObjectCopy[i]);
//break;
}
else {
gridObjectCopy.add(grid);
}
}


            System.debug('before return stringK'+responseStr);
            responseStr =  responseStr.replaceAll('\n','');
            ////  responseStr =  responseStr.replaceAll('\\s+', '');
            system.debug('removing space'+responseStr);
            return responseStr;
        }
    }
    
    

    @AuraEnabled   
    public static String fetchPackages(String serviceType){
        system.debug('inside fetch packages...'+serviceType);
        if(serviceType == null)
        {
            serviceType='ANY' ;  
        }  
        PCServiceCall pccall = new PCServiceCall();
        PackageOffer offer = pccall.getPackages(serviceType);
        JSONGenerator gen = JSON.createGenerator(true);
        boolean childbundleflag=false;
        List<ProductOffering> productItem = offer.getPackages();
        gen.writeStartArray();      
        for(ProductOffering item:productItem){
            gen.writeStartObject(); 
            String name = item.getname();
            if(name.length() > nameLength) {
                name = name.substring(0, nameLength);
                name = name + '...';
            }
            gen.writeStringField('hiddenName',name+item.getname());
            gen.writeStringField('displayName', name);
            gen.writeStringField('Name', item.getname());
            // gen.writeStringField('ProductType', item.getserviceType());comm
            gen.writeStringField('ProductType', item.getProductType());
            gen.writeStringField('ProductSpec', item.getproductOfferingId());
            gen.writeBooleanField('isChecked', false);
            gen.writeBooleanField('isDisabled', false);
            
            List<Object> productsSpec =item.getproductSpec();
            List<Object> productOfferingList = item.getproductOffering();
            gen.writeFieldName('_children');
            gen.writeStartArray();
            fetchChilds(item, gen,name);
            gen.writeEndArray(); 
            gen.writeEndObject(); 
        }
        gen.writeEndArray();   
        String responseStr = gen.getAsString();
        
        System.debug('-response--' +responseStr);
        return responseStr;
    }
    

    @AuraEnabled 
    public static void fetchChilds(ProductOffering item, JSONGenerator gen,String pkgName
                                  )
    {
        
        List<Object> productsSpec =item.getproductSpec();
        List<Object> productOfferingList = item.getproductOffering();
        ////String RC = '', NRC = '', currencyObj = '';
        for(Integer i=0; i<productsSpec.size(); i++){
            String rc = '', nrc = '', currencyObj = '';
            if(item.getproductOfferingId() != item.productSpec[i].productSpecID) {
                gen.writeStartObject();
                String name = item.productSpec[i].Name;
                if(name.length() >= nameLength) {
                    name = name.substring(0, nameLength);
                    name = name + '...';
                }
                gen.writeStringField('hiddenName',pkgName+item.productSpec[i].Name);
                gen.writeStringField('displayName', name);
                gen.writeStringField('Name', item.productSpec[i].Name);
                
                //gen.writeStringField('ProductType', item.productSpec[i].productCategory);comm
                gen.writeStringField('ProductType', item.productSpec[i].productType);
                gen.writeStringField('ProductSpec', item.productSpec[i].productSpecID);
                gen.writeBooleanField('isChecked', false);
                gen.writeBooleanField('isDisabled', false);
                gen.writeStringField('Mandatory',item.productSpec[i].defaultState);
                ProductOffering.cls_productSpecPrice[] productSpecPrice = item.productSpec[i].productSpecPrice;
                if(productSpecPrice!=null){
                    for(Integer j = 0 ; j < productSpecPrice.size(); j++) {
                        if(productSpecPrice[j].price != null) {
                            if(productSpecPrice[j].priceType == 'RC') {
                                rc = productSpecPrice[j].price.amount;
                                currencyObj = productSpecPrice[j].price.currency1;
                            }
                            if(productSpecPrice[j].priceType == 'NRC') {
                                nrc = productSpecPrice[j].price.amount;
                                currencyObj = productSpecPrice[j].price.currency1;
                            }
                        }
                    }
                }
                gen.writeStringField('RC', rc);
                gen.writeStringField('NRC', nrc);
                gen.writeStringField('currency', currencyObj);
                gen.writeEndObject(); 
            }
        }
        system.debug('productOfferingList:'+productOfferingList+'size:'+productOfferingList.size());
        if(productOfferingList!=Null){
            for(Integer i=0; i<productOfferingList.size(); i++) {
                gen.writeStartObject();
                String name = item.productOffering[i].Name;
                if(name.length() > nameLength) {
                    name = name.substring(0, nameLength);
                    name = name + '...';
                }
                gen.writeStringField('hiddenName',pkgName+item.productOffering[i].Name);
                gen.writeStringField('displayName', name);
                gen.writeStringField('Name', item.productOffering[i].Name);
                // gen.writeStringField('ProductType', item.productOffering[i].productCategory); comm
                gen.writeStringField('ProductType', item.productOffering[i].productType);
                gen.writeStringField('ProductSpec', item.productOffering[i].productOfferingId);
                gen.writeBooleanField('isChecked', false);
                gen.writeBooleanField('isDisabled', false);
                gen.writeStringField('Mandatory',item.productOffering[i].productSpec[0].defaultState);
                if(item.productOffering[i].productType!='BUNDLE') {
                    ProductOffering.cls_productSpec[] productsSpecPO =item.productOffering[i].getproductSpec();
                    system.debug('productsSpecPO'+productsSpecPO);
                    
                    String rcPo = '', nrcPo = '', currencyObjPO = '';
                    for(Integer ii=0; ii<productsSpecPO.size(); ii++){
                        system.debug('productsSpecPO.get(ii)'+productsSpecPO.get(ii));
                        if((productsSpecPO.get(ii)).getProductSpecPrice() != null) {
                            ProductOffering.cls_productSpecPrice[] productSpecPrice = (productsSpecPO.get(ii)).getProductSpecPrice();
                            if(productSpecPrice!=null){
                                system.debug('productSpecPrice size::'+productSpecPrice.size()+'item.productOffering[i].Name'+item.productOffering[i].Name);
                                for(Integer j = 0 ; j < productSpecPrice.size(); j++) {
                                    if(productSpecPrice[j].price != null) {
                                        if(productSpecPrice[j].priceType == 'RC') {
                                            rcPo = productSpecPrice[j].price.amount;
                                            currencyObjPO = productSpecPrice[j].price.currency1;
                                        }
                                        if(productSpecPrice[j].priceType == 'NRC') {
                                            nrcPo = productSpecPrice[j].price.amount;
                                            currencyObjPO = productSpecPrice[j].price.currency1;
                                        }
                                        system.debug('***productSpecPrice***'+productSpecPrice+'item.productOffering[i].Name'+item.productOffering[i].Name);
                                        
                                    }
                                }
                            }
                        }
                    }
                    gen.writeStringField('RC', rcPo);
                    gen.writeStringField('NRC', nrcPo);
                    gen.writeStringField('currency', currencyObjPO);
                }  
                if(item.productOffering[i].productType=='BUNDLE')
                {
                    gen.writeFieldName('_children');
                    gen.writeStartArray();
                    fetchChilds(item.productOffering[i], gen,pkgName);
                    gen.writeEndArray(); 
                }
                gen.writeEndObject(); 
            }
        }
        
    }
    
    
    
    

    @AuraEnabled 
    public static String fetchProducts(List<String> packageId, String offersMap){
        system.debug('inside fetchProducts');
        system.debug('Entered fetchProducts>> ' +packageId);
        PCServiceCall pccall = new PCServiceCall();
        
        //IPCServiceCall pccall = getpcServiceCall();
        System.debug('after type casting..');
        ProductOffer offer = pccall.getProducts(packageId);
        JSONGenerator gen = JSON.createGenerator(true);
        List<ProductOffering> productItems = offer.getproducts();
        gen.writeStartArray();
        system.debug('productItems ::'+JSON.serialize(productItems));
        for(ProductOffering item:productItems){
            gen.writeStartObject();
            String rc = '0', nrc = '0', currencyObj = 'INR';
            String name = item.getname();
            if(name.length() > nameLength) {
                name = name.substring(0, nameLength);
                name = name + '..';
            }
            gen.writeStringField('displayName', name);
            gen.writeStringField('Name', item.getname());
            if(item.getProductType()!=null) {
                gen.writeStringField('ProductType', item.getProductType());
            }
            else { 
                gen.writeStringField('ProductType','NONE');
            }
            gen.writeStringField('ProductSpec', item.getproductOfferingId());
            Integer minCardinality = 0, maxCardinality = 100;
            List<Object> productsSpec =item.getProductSpec();
            List<Object> productOfferingList = item.getproductOffering();
            for(Integer i=0; i<productsSpec.size(); i++)
            {
                if(item.getproductOfferingId() == item.productSpec[i].productSpecID)
                {
                    if(item.productSpec[i].minCardinality != null){
                        minCardinality = item.productSpec[i].minCardinality;
                    }
                    if(item.productSpec[i].maxCardinality != null){
                        maxCardinality = item.productSpec[i].maxCardinality;
                    }
                    ProductOffering.cls_productSpecPrice[] productSpecPrice = item.productSpec[i].productSpecPrice;
                    if(productSpecPrice!=null){
                        for(Integer j = 0 ; j < productSpecPrice.size(); j++) {
                            if(productSpecPrice[j].price != null) {
                                if(productSpecPrice[j].priceType == 'RC') {
                                    rc = productSpecPrice[j].price.amount;
                                    currencyObj = productSpecPrice[j].price.currency1;  
                                }
                                if(productSpecPrice[j].priceType == 'NRC') {
                                    nrc = productSpecPrice[j].price.amount;
                                    currencyObj = productSpecPrice[j].price.currency1;
                                }
                            }
                        }
                    }
                }
            }
            
            gen.writeStringField('RC', rc);
            gen.writeStringField('NRC', nrc);
            gen.writeStringField('currency', currencyObj);
            gen.writeNumberField('minQuantity', minCardinality);
            gen.writeNumberField('maxQuantity', maxCardinality);
            
            gen.writeBooleanField('isChecked', false);
            gen.writeBooleanField('isDisabled', false);
            gen.writeBooleanField('isAddon', true);
            
            if(item.productSpec[0].productCategory=='BUNDLE')
            {
                gen.writeFieldName('_children');
                gen.writeStartArray();
                for(Integer i=0; i<productsSpec.size(); i++)
                {
                    if(item.getproductOfferingId() != item.productSpec[i].productSpecID)
                    {
                        gen.writeStartObject();
                        gen.writeStringField('Name', item.productSpec[i].Name);
                        gen.writeStringField('ProductType', item.productSpec[i].productCategory);
                        gen.writeStringField('ProductSpec', item.productSpec[i].productSpecID);
                        gen.writeEndObject();   
                    }
                }
                
                if(productOfferingList!=Null)
                {
                    system.debug('Inside product offering-->'+item.getname());
                    for(Integer i=0; i<productOfferingList.size(); i++)
                    {
                        gen.writeStartObject();
                        gen.writeStringField('Name', item.productOffering[i].Name);
                        gen.writeStringField('ProductType', item.productOffering[i].productCategory);
                        gen.writeStringField('ProductSpec', item.productOffering[i].productOfferingId);
                        gen.writeEndObject(); 
                    }
                }
                gen.writeEndArray();
            }
            gen.writeEndObject(); 
        }           
        gen.writeEndArray();    
        String responseStr = gen.getAsString();
        system.debug('fetchprod response..'+responseStr.deleteWhitespace());
        return responseStr;
    } 
    
    

    @AuraEnabled
    public static String searchOffer(String searchKey, String gridJson){
        List<Object> m =   (List<Object>)JSON.deserializeUntyped(gridJson);
        List<Object> temp = new List<Object>();
        //system.debug('GridRespone-->'+gridJson);
        //system.debug('m data -->'+m);
        for(Integer i=0; i<m.size();i++){
            map<String, Object> item = (map<String, Object>)m[i];
            string prodName = (String)item.get('Name');
            system.debug('prodName--'+prodName);
            system.debug('searchKey--'+searchKey);
            if(prodName.containsIgnoreCase(searchKey)){
                system.debug('inside if prodName--'+prodName+' searchKey--'+searchKey);
                temp.add(item);               
            }
        }       
        
        String responseStr = JSON.serialize(temp);
        System.debug('responseStr for search'+responseStr);
        
        return responseStr;
    }
    
    /*
* This is to capture all childProducts productOfferIds/ProdSpecs
* 
    private static void addProduct(map<String, Object> eachChildQuote, List<String> childProductSpecList)
    {
        childProductSpecList.add((String)eachChildQuote.get('ProductSpec'));
    }
    
    /*
* This is used to take the children products from Package 
* 
    private static void getEachChildren(map<String, Object> childQuote,List<String> childProductSpecList)
    {
        List<Object> childrenAsParentList=(List<Object>)childQuote.get('_children');
        System.debug('childrenAsParentList.. '+childrenAsParentList);
        if(childrenAsParentList == null)
        {
            addProduct(childQuote,childProductSpecList);
        }else{
            List<Object>  childQuotes = (List<Object>)childQuote.get('_children');
            childQuoteStrData(childQuotes,childProductSpecList);
        }
    }	
    
    public static void childQuoteStrData( List<Object> childQuotes, List<String> childProductSpecList)
    {
        for(Integer k=0;k<childQuotes.size();k++){
            map<String, Object> childQuote = (map<String, Object>)childQuotes[k];
            getEachChildren(childQuote,childProductSpecList);
        }
    }
    
    

    public static void forParentProducts(Map<String,Boolean> evMap,map<String, Object> item,List<Object> allObjList,String quoteId,
                                         List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts,
                                         String firstLevelparentProdOfferId,List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedPkgg)
    {
        String parentProdOfferId=(String)item.get('ProductSpec');
        addQuoteLine(evMap,item,allObjList,true,quoteId,bundlePriceForSelectedProducts,parentProdOfferId,firstLevelparentProdOfferId,bundlePriceForSelectedPkgg);
        List<Object> childQuotes = (List<Object>)item.get('_children');
        iterateChilds(evMap,childQuotes,allObjList,quoteId,bundlePriceForSelectedProducts,parentProdOfferId,parentProdOfferId);
        
    } 
    
    
    private static void iterateChilds(Map<String,Boolean> evMap,List<Object> childQuotes, List<Object> allObjList,
                                      String quoteId,List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts,
                                      String parentProdOfferId,String firstLevelparentProdOfferId)
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
                
                forParentProducts(evMap,childQuoteEach,nextLevelList,quoteId,bundlePriceForSelectedProducts,firstLevelparentProdOfferId,null);
                //SiterateChilds(childQuotesNextLevel,nextLevelList,quoteId,bundlePriceForSelectedProducts);
            }else{
                addQuoteLine(evMap,childQuoteEach,allObjList,false,quoteId,bundlePriceForSelectedProducts,parentProdOfferId,
                             firstLevelparentProdOfferId,null);
            }
        }
    }			
    
    private static void addQuoteLine(Map<String,Boolean> evMap,map<String, Object> item,List<Object> quoteLineItems,boolean isPkg,String quoteId,
                                     List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts,
                                     String parentProdOfferId,String firstLevelparentProdOfferId,List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedPkgg) 
    { 
        QuoteLineItemPkgWrapper packageItemWrapper = new QuoteLineItemPkgWrapper();
        packageItemWrapper.Is_Package = isPkg;
        if(!isPkg){
            // packageItemWrapper.mandatory =(String)item.get('Mandatory');
            getProductPriceOfAOffer((String)item.get('ProductSpec'), bundlePriceForSelectedProducts, 
                                    packageItemWrapper,null);
            packageItemWrapper.parentproductOfferingId= parentProdOfferId;
            
        }else{
            packageItemWrapper.parentproductOfferingId= firstLevelparentProdOfferId; ////SQL Limit exception
            //packageItemWrapper.parentproductOfferingId= null;
            if(bundlePriceForSelectedPkgg!=null){
                getPkgPriceOfAOffer((String)item.get('ProductSpec'), bundlePriceForSelectedPkgg, 
                                    packageItemWrapper,null);
            }
            //commented as existing code flow breaking for this change

            
            
            
        }
       
        packageItemWrapper.mandatory =(String)item.get('Mandatory');
        packageItemWrapper.name = (String)item.get('Name');
        packageItemWrapper.productOfferingId = (String)item.get('ProductSpec');
        packageItemWrapper.quote = quoteId;
        packageItemWrapper.ProductType = (String)item.get('ProductType');
        System.debug('(String)item.getProductType...'+(String)item.get('ProductType'));
         System.debug('evMap--->packageItemWrapper.parentproductOfferingId--->'+packageItemWrapper.parentproductOfferingId+'----'+packageItemWrapper.name);
        System.debug('evMap.get(packageItemWrapper.parentproductOfferingId)---->'+evMap.get(packageItemWrapper.parentproductOfferingId));
        if(evMap.get(packageItemWrapper.parentproductOfferingId)!=null && evMap.get(packageItemWrapper.parentproductOfferingId)== true){
        	packageItemWrapper.packagedPriced= true;
        }else
        {
            packageItemWrapper.packagedPriced= false;
        }
        quoteLineItems.add(packageItemWrapper);
    }
    
    
    
    
    
    

    @AuraEnabled
    public static Map<String,Map<String, List<Object>>> getFinalMap
        (List<String> selectedOffers, String gridJson, String quoteId, String attributeList, String existOfferMap,
         Decimal currentVersion){
             Map<String,Map<String, List<Object>>> resultMap =  new Map<String,Map<String, List<Object>>>();
             try{
                 
                 List<Object> existingServiceOfferMap = new List<Object>();
                 if(existOfferMap != null && existOfferMap.length() > 0) {
                     System.debug('existOfferMap....'+existOfferMap);
                     existingServiceOfferMap = (List<Object>)JSON.deserializeUntyped(existOfferMap);
                     System.debug('existingServiceOfferMap....'+existingServiceOfferMap);
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
                         getQuotelineMapWithPrice
                             (resultMap,quoteLineMap,objValue,quoteId,attributeList,existingOffer,  
                              serviceType,currentVersion,existingServiceOfferMap);
                         //resultMap.put((String)eachMap.get('key'),resObj);
                     }
                 }else if(finalList!=null && finalList.isEmpty())
                 {
                     map<String, List<Object>> quoteLineMap = new  Map<String,List<Object>>();
                     List<Object> emptygridResponse = new List<Object>();
                     List<Object> existingServiceOfferMapEmpty = new List<Object>();
                     getQuotelineMapWithPrice
                         (resultMap,quoteLineMap,emptygridResponse,quoteId,attributeList,null,  
                          null,currentVersion,existingServiceOfferMap);
                 }
                 System.debug('resultMap in getfinalMap .. '+resultMap); 
             }
             catch(Exception e){
                 System.debug('exception in getfinal map .. '+e.getLineNumber());
                 System.debug('exception in getfinal map message.. '+e.getMessage());
             }
             return resultMap;
         }
    
    

    @AuraEnabled
    public static void getQuotelineMapWithPrice
        (Map<String,Map<String, List<Object>>> resultMap,map<String, List<Object>> quoteLineMap,
         List<Object> gridResponse, String quoteId, 
         String attributeList,List<Object>  existOfferMap,
         String serviceType,Decimal currentVersion,
         List<Object> existingServiceOfferMap){
             // System.debug('selectedOffers '+JSON.serialize(selectedOffers));
             System.debug('existOfferMap >>'+existOfferMap);
             System.debug('gridResponse in getQuotelineMapWithPrice--> '+ gridResponse);
             System.debug('attributeList--> '+ attributeList);
             System.debug('serviceType--> '+ serviceType);
             
             try{
                 String attrString = '<table style="width:74%"><th>AttributeName</th><th>Value</th>';
                 List<AttributeMapConverter> attributeMapp = new List<AttributeMapConverter>();
                 Map<String, List<QuoteLineItemPkgWrapper>> existingAddonsMap;
                 Map<String,List<Object>> attriMap = new Map<String,List<Object>>();
                 Map<String, String> attributeMapValues = new Map<String, String>();
                 List<String> prodOfferIdsOfPkges = new List<String>();
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
                 ////String attributeString = '{"attributes":[{"value":"100GB","name":"BackUpData"}],"product":"PRD_9353"}';
                 //Creating a new map out of the grid json for ease of getting the details of the selected items 
                 List<String> childProductSpecList = new List<String>();
                 List<String> pkgSpec = new List<String>();
                 for(Integer i=0;i<gridResponse.size();i++){
                     map<String, Object> item = (map<String, Object>)gridResponse[i];
                     gridJsonMap.put((String)item.get('ProductSpec'),item);
                     
                     pkgSpec.add((String)item.get('ProductSpec'));
                     List<Object> childQuotes = (List<Object>)item.get('_children');
                     childQuoteStrData(childQuotes,childProductSpecList);//changed for BOB
                     
                 }
                 System.debug('gridJsonMap in packagecontroller' + gridJsonMap);
                 //List<ProductPrice.cls_productPriceDetails> bundlePriceForSelectedProducts = new List<ProductPrice.cls_productPriceDetails>();
                 List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts = new List<BundlePrice.cls_bundlePriceDetails>();
                 List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedPkgs = new List<BundlePrice.cls_bundlePriceDetails>();
                 List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedPkgg = new List<BundlePrice.cls_bundlePriceDetails>();
                 
                 
                 boolean offercheck = false;
                 system.debug('childProductSpecList ::'+childProductSpecList);
                 //ProductPrice priceForSelectedProducts = pccall.getProductPrice(childProductSpecList, attributeMapValues);
                 BundlePrice priceForSelectedProducts = pccall.getBundlePricePkgPricing(childProductSpecList, attributeMapValues,quoteId,serviceType);
                 System.debug('priceForSelectedProducts--'+JSON.serialize(priceForSelectedProducts));
                 bundlePriceForSelectedProducts = priceForSelectedProducts.getBundlePriceDetails();
                 
                 system.debug('pkgSpec'+pkgSpec);
                 BundlePrice priceForSelectedProducts1 = pccall.getBundlePricePkgPricing(pkgSpec, attributeMapValues,quoteId,serviceType);
                 bundlePriceForSelectedPkgg = priceForSelectedProducts1.getBundlePriceDetails();
                 system.debug('bundlePriceForSelectedPkgg new'+bundlePriceForSelectedPkgg);
                 
                 //// BundlePrice priceForSelectedPkgs = pccall.getBundleOfBundlePrices(pkgSpec);
                 ////bundlePriceForSelectedPkgs = priceForSelectedPkgs.getBundlePriceDetails();
                 ////system.debug('bundlePriceForSelectedPkgs'+bundlePriceForSelectedPkgs);
                 Map<String,Boolean> evMap= new  Map<String,Boolean>();
                 evMap= checkPkgPrice(evMap,bundlePriceForSelectedProducts,bundlePriceForSelectedPkgg);
                 List<String> optIn = new List<String>();
                 for(Integer i=0;i<gridResponse.size();i++){
                     
                     map<String, Object> item = (map<String, Object>)gridResponse[i];
                     String pkgName = (String)item.get('Name');
                     System.debug(' pkgName '+pkgName);
                     if(existingOfferMap.containsKey(pkgName)) {
                         System.debug('Inside If');
                         List<Object> valueList = (List<Object>)existingOfferMap.get(pkgName);
                         quoteLineMap.put(pkgName, valueList);
                     }
                     else {
                         System.debug('Inside else');
                         List<Object> firstLevelquoteLineItemsList = new List<Object>();
                         quoteLineMap.put((String)item.get('Name'),firstLevelquoteLineItemsList);
                         String firstLevelparentProdOfferId=(String)item.get('ProductSpec');
                         forParentProducts(evMap,item,firstLevelquoteLineItemsList,quoteId,bundlePriceForSelectedProducts,firstLevelparentProdOfferId,bundlePriceForSelectedPkgg);
                     }
                     
                 }
                 system.debug('New QuoteLineMap After new map construction->'+JSON.serialize(quoteLineMap));
                 
                 if(!gridResponse.isEmpty()){
                
                     resultMap.put(serviceType,quoteLineMap);  
                 }
                 system.debug('before formmap method called->'+JSON.serialize(resultMap));
                 system.debug('existingServiceOfferMap before formmap method called->'+JSON.serialize(existingServiceOfferMap));
                 system.debug('existingOfferMap before formmap method called->'+JSON.serialize(existingOfferMap));
                 system.debug('currentVersion before formmap method called->'+currentVersion);
                 FormMap.getExistingOffersForExistingServiceTypes(resultMap, quoteId, 
                                                                  existingOfferMap,serviceType,currentVersion,existingServiceOfferMap);   
                 
                 System.debug('New resultMap After adding existing offers->'+JSON.serialize(resultMap));
                 //return quoteLineMap;
             }
             catch(Exception e)
             {
                 System.debug('exception in getQuotelineMapWithPrice'+e.getStackTraceString());
             }
             
             
         }
    
    
  

    
    public static Map<String,Boolean>  checkPkgPrice(Map<String,Boolean> evMap,List<BundlePrice.cls_bundlePriceDetails> productPriceList,List<BundlePrice.cls_bundlePriceDetails> bundlePriceList){
        system.debug('checkPkgPrice------------>'+evMap);
        if(productPriceList!=null){
            for(BundlePrice.cls_bundlePriceDetails priceDetail : productPriceList) {
                for(BundlePrice.cls_productOfferingPrice offeringPrice : priceDetail.getProductOfferingPrice()) {
                    if(offeringPrice.price!=null && offeringPrice.price.amount!=null) {
                        evMap.put(priceDetail.getProductId() ,true);
                    }
                }
            } 
        } if(bundlePriceList!=null){
            for(BundlePrice.cls_bundlePriceDetails priceDetail : bundlePriceList) {
                for(BundlePrice.cls_productOfferingPrice offeringPrice : priceDetail.getProductOfferingPrice()) {
                    if(offeringPrice.price!=null && offeringPrice.price.amount!=null && offeringPrice.externalID == priceDetail.getProductId()) {
                        evMap.put(priceDetail.getProductId() ,true);
                    }
                }
            }
        }
        
        system.debug('evMap------------>'+evMap);
        return evMap;
    }
    
    @AuraEnabled
    public static boolean getProductPriceOfAOffer(String offerId, List<BundlePrice.cls_bundlePriceDetails> productPriceList,QuoteLineItemPkgWrapper packageItem,Decimal pkgQunatity) 
    {
        System.debug('inside prodprice offer pkgcontroler..');
        if(productPriceList!=null){
            for(BundlePrice.cls_bundlePriceDetails priceDetail : productPriceList) {
                if(priceDetail.getProductId() == offerId) {
                    system.debug('match found '+offerId);
                    system.debug('priceDetail '+priceDetail);
                    //BundlePrice.cls_summaryOfCharges chargesSummary = priceDetail.getSummaryOfCharges();
                    List<BundlePrice.cls_productOfferingPrice> productOfferingPrice = priceDetail.getProductOfferingPrice();
                    for(BundlePrice.cls_productOfferingPrice offeringPrice : productOfferingPrice) {
                        if(offeringPrice.priceType == 'RC') {
                            packageItem.rcProductOfferingPriceID = offeringPrice.productOfferingPriceID;
                            packageItem.rcPricingClassifier = offeringPrice.pricingClassifier;
                            packageItem.rcBillingComponentType = offeringPrice.billingComponentType;
                            if(offeringPrice.price != Null) {          
                                System.debug('offeringPrice.price.amount in rc. '+offeringPrice.price.amount);
                                //packageItem.recurringCharge = decimal.valueOf(offeringPrice.price.amount);
                                packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                //changed decimal value from two decimals to four decimals
                                //packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));
                                System.debug('offeringPrice.price.amount in rc.after decimal> '+packageItem.recurringCharge);
                                if(pkgQunatity!=null){
                                    packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                    //changed decimal value from two decimals to four decimals
                                    //packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(4));//revamp
                                }else{
                                    packageItem.rcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                    //changed decimal value from two decimals to four decimals
                                    //packageItem.rcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));//revamp
                                }
                                packageItem.currencyObj = offeringPrice.price.currency1;
                                if(offeringPrice.variablePrice != Null){
                                    packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                }
                                else if(offeringPrice.variablePrice == Null){
                                    packageItem.rcvariableprice =0;
                                }
                            } 
                            else if(offeringPrice.fixedPrice != Null && offeringPrice.variablePrice != Null) {
                                packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.fixedPrice.amount) + decimal.valueOf(offeringPrice.variablePrice.amount));
                                packageItem.currencyObj = offeringPrice.fixedPrice.currency1;
                                if(offeringPrice.price != Null){ 
                                    if(pkgQunatity!=null){
                                        packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));//revamp
                                    }
                                    else{
                                        packageItem.rcnetprice = String.valueOf(offeringPrice.price.amount);//revamp
                                    }}
                                if(offeringPrice.variablePrice != Null){
                                    packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                }
                            } else  if(offeringPrice.price != Null && offeringPrice.variablePrice != Null){
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
                            if(offeringPrice.price != Null) {
                                System.debug('offeringPrice.price.amount in nnnrc. '+offeringPrice.price.amount);
                               packageItem.price = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));
                               // changed decimal value from two decimals to four decimals
                               // packageItem.price = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));
                                System.debug('Decimal price--'+packageItem.price);
                                if(pkgQunatity!=null){
                                    // packageItem.nrcnetprice = pkgQunatity*decimal.valueOf(offeringPrice.price.amount);//revamp
                                    // packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));
                                    packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                    //changed decimal value from two decimals to four decimals
                                    //packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(4));
                                }else{
                                    //packageItem.nrcnetprice = decimal.valueOf(offeringPrice.price.amount);//revamp
                                    packageItem.nrcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                    //changed decimal value from two decimals to four decimals
                                    //packageItem.nrcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));//revamp
                                }
                                
                                packageItem.currencyObj = offeringPrice.price.currency1;
                                if(offeringPrice.variablePrice != Null){ 
                                    packageItem.nrcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                }
                                else if(offeringPrice.variablePrice == Null){
                                    packageItem.nrcvariableprice =0;
                                }
                            } else if(offeringPrice.variablePrice != Null) {
                                packageItem.price = String.valueOf(offeringPrice.variablePrice.amount);
                                packageItem.currencyObj = offeringPrice.variablePrice.currency1;
                                packageItem.nrcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                            } else if(offeringPrice.fixedPrice != Null){
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
    
    @AuraEnabled
    public static boolean getPkgPriceOfAOffer(String offerId, List<BundlePrice.cls_bundlePriceDetails> productPriceList,
                                              QuoteLineItemPkgWrapper packageItem,Decimal pkgQunatity) {
                                                  if(productPriceList!=null){
                                                      for(BundlePrice.cls_bundlePriceDetails priceDetail : productPriceList) {
                                                          if(priceDetail.getProductId() == offerId) {
                                                              system.debug('match found '+offerId);
                                                              system.debug('priceDetail '+priceDetail);
                                                              //BundlePrice.cls_summaryOfCharges chargesSummary = priceDetail.getSummaryOfCharges();
                                                              List<BundlePrice.cls_productOfferingPrice> productOfferingPrice = priceDetail.getProductOfferingPrice();
                                                              for(BundlePrice.cls_productOfferingPrice offeringPrice : productOfferingPrice) {
                                                                  if(offeringPrice.priceType == 'RC' && offeringPrice.externalID == offerId)  {  //offeringPrice.externalID == offerId - means pkg pricing
                                                                      packageItem.rcProductOfferingPriceID = offeringPrice.productOfferingPriceID;
                                                                      packageItem.rcPricingClassifier = offeringPrice.pricingClassifier;
                                                                      packageItem.rcBillingComponentType = offeringPrice.billingComponentType;
                                                                      if(offeringPrice.price != Null) {
                                                                          
                                                                          System.debug('offeringPrice.price.amount in rc. '+offeringPrice.price.amount);
                                                                          //packageItem.recurringCharge = decimal.valueOf(offeringPrice.price.amount);
                                                                          packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                                                          //changed decimal value from two decimals to four decimals
                                                                          //packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));
                                                                          System.debug('offeringPrice.price.amount in rc.after decimal> '+packageItem.recurringCharge);
                                                                          if(pkgQunatity!=null){
                                                                              packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                                                              //changed decimal value from two decimals to four decimals
                                                                              // packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(4));//revamp
                                                                          }else{
                                                                              packageItem.rcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                                                              //changed decimal value from two decimals to four decimals
                                                                              //packageItem.rcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));//revamp
                                                                          }
                                                                          packageItem.currencyObj = offeringPrice.price.currency1;
                                                                          if(offeringPrice.variablePrice != Null){
                                                                              packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                          }
                                                                          else if(offeringPrice.variablePrice == Null){
                                                                              packageItem.rcvariableprice =0;
                                                                          }
                                                                      } 
                                                                      else if(offeringPrice.fixedPrice != Null && offeringPrice.variablePrice != Null) {
                                                                          packageItem.recurringCharge = String.valueOf(decimal.valueOf(offeringPrice.fixedPrice.amount) + decimal.valueOf(offeringPrice.variablePrice.amount));
                                                                          packageItem.currencyObj = offeringPrice.fixedPrice.currency1;
                                                                          if(offeringPrice.price != Null){ 
                                                                              if(pkgQunatity!=null){
                                                                                  packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));//revamp
                                                                              }
                                                                              else{
                                                                                  packageItem.rcnetprice = String.valueOf(offeringPrice.price.amount);//revamp
                                                                              }}
                                                                          if(offeringPrice.variablePrice != Null){
                                                                              packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                          }
                                                                      } else  if(offeringPrice.price != Null && offeringPrice.variablePrice != Null){
                                                                          packageItem.recurringCharge = String.valueOf(offeringPrice.price.amount);
                                                                          if(pkgQunatity!=null){
                                                                              packageItem.rcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));//revamp
                                                                          }else{
                                                                              packageItem.rcnetprice = String.valueOf(offeringPrice.price.amount);//revamp
                                                                          }
                                                                          
                                                                          packageItem.currencyObj = offeringPrice.price.currency1;
                                                                          packageItem.rcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                      }
                                                                  } else if(offeringPrice.priceType == 'NRC'  && offeringPrice.externalID == offerId) {
                                                                      
                                                                      packageItem.nrcProductOfferingPriceID = offeringPrice.productOfferingPriceID;
                                                                      packageItem.nrcPricingClassifier = offeringPrice.pricingClassifier;
                                                                      packageItem.nrcBillingComponentType = offeringPrice.billingComponentType;
                                                                      if(offeringPrice.price != Null) {
                                                                          System.debug('offeringPrice.price.amount in nnnrc. '+offeringPrice.price.amount);
                                                                          packageItem.price = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                                                          //changed decimal value from two decimals to four decimals
                                                                          //packageItem.price = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));
                                                                          System.debug('Decimal price--'+packageItem.price);
                                                                          if(pkgQunatity!=null){
                                                                              // packageItem.nrcnetprice = pkgQunatity*decimal.valueOf(offeringPrice.price.amount);//revamp
                                                                              // packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount));
                                                                              packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(2));
                                                                              //changed decimal value from two decimals to four decimals
                                                                              //packageItem.nrcnetprice = String.valueOf(pkgQunatity*decimal.valueOf(offeringPrice.price.amount).setScale(4));
                                                                          }else{
                                                                              //packageItem.nrcnetprice = decimal.valueOf(offeringPrice.price.amount);//revamp
                                                                              packageItem.nrcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(2));//revamp
                                                                              //changed decimal value from two decimals to four decimals
                                                                              //packageItem.nrcnetprice = String.valueOf(decimal.valueOf(offeringPrice.price.amount).setScale(4));//revamp
                                                                          }
                                                                          
                                                                          packageItem.currencyObj = offeringPrice.price.currency1;
                                                                          if(offeringPrice.variablePrice != Null){ 
                                                                              packageItem.nrcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                          }
                                                                          else if(offeringPrice.variablePrice == Null){
                                                                              packageItem.nrcvariableprice =0;
                                                                          }
                                                                      } else if(offeringPrice.variablePrice != Null) {
                                                                          packageItem.price = String.valueOf(offeringPrice.variablePrice.amount);
                                                                          packageItem.currencyObj = offeringPrice.variablePrice.currency1;
                                                                          packageItem.nrcvariableprice =decimal.valueOf(offeringPrice.variablePrice.amount);//for priceoverride
                                                                      } else if(offeringPrice.fixedPrice != Null){
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
    
    
    

    @AuraEnabled
    public static Map<String,String> getInitialQuotePrice(String quoteId) {
        System.debug('Inside method getInitialPriceAtQuoteLevel'+quoteId);
        //added for PMD fix- apex crud violation by RIMI
        if(!Schema.sObjectType.Quote.fields.Name.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        Quote quote = [SELECT Id,Name,Recurring_Charges__c,Non_Recurring_Charges__c,CurrentVersion__c,quote.Account.Id FROM Quote WHERE Id=:quoteId];
        System.debug('quote '+quote);
        QuoteWrapper quoteWrapper = new QuoteWrapper();
        if(quote.Non_Recurring_Charges__c == Null) {
            quote.Non_Recurring_Charges__c = 0;
            quoteWrapper.nonRecurringCharges = 0;
        }
        else 
        { quoteWrapper.nonRecurringCharges = quote.Non_Recurring_Charges__c;
        }
        
        if(quote.Recurring_Charges__c == Null) {
            quote.Recurring_Charges__c = 0; 
            quoteWrapper.recurringCharges = 0; 
        }
        
        else 
        { quoteWrapper.recurringCharges = quote.Recurring_Charges__c;
        }
        
        if(quote.CurrentVersion__c == Null) {
            quote.CurrentVersion__c = 1.0; 
        }
        
        Map<String,String> priceTypeWithValue = new Map<String,String>();
        priceTypeWithValue.put('NRC', String.valueOf(quote.Non_Recurring_Charges__c));
        priceTypeWithValue.put('RC', String.valueOf(quote.Recurring_Charges__c));
        priceTypeWithValue.put('version', String.valueOf(quote.CurrentVersion__c));
        priceTypeWithValue.put('PurchaseAccountId',String.valueOf(quote.Account.Id));
        System.debug('priceTypeWithValue '+priceTypeWithValue);
        return priceTypeWithValue;
    } 
    
    
    
    
    private static void constructQuoteItemWrapper(QuoteLineItemPkgWrapper packageItemWrapper,
                                                  map<String,Object> objFromValList)
    {
        
        packageItemWrapper.Is_Package = (Boolean)objFromValList.get('Is_Package');
        packageItemWrapper.name = (String)objFromValList.get('name');
        packageItemWrapper.productOfferingId = (String)objFromValList.get('productOfferingId');
        packageItemWrapper.quote = (String)objFromValList.get('quote');
        packageItemWrapper.parentproductOfferingId= (String)objFromValList.get('parentproductOfferingId');
        if(String.valueOf(objFromValList.get('rcnetprice'))!=null){
            packageItemWrapper.rcnetprice= String.valueOf(objFromValList.get('rcnetprice'));
        }
        else{
            packageItemWrapper.rcnetprice=  String.valueOf(objFromValList.get('rcnetprice'));
        } 
        if(String.valueOf(objFromValList.get('nrcnetprice'))!=null){
            //packageItemWrapper.nrcnetprice= Decimal.valueof(String.valueOf(objFromValList.get('nrcnetprice')));
            packageItemWrapper.nrcnetprice= String.valueOf(objFromValList.get('nrcnetprice'));
        }
        else{
            //packageItemWrapper.nrcnetprice= (Decimal)objFromValList.get('nrcnetprice');
            packageItemWrapper.nrcnetprice= String.valueOf(objFromValList.get('nrcnetprice'));
        }
        
        packageItemWrapper.currencyObj= (String)objFromValList.get('currencyObj');
        packageItemWrapper.mandatory= (String)objFromValList.get('mandatory');
        System.debug('(String)objFromValList.get prodType.. line no 1403..'+(String)objFromValList.get('ProductType')) ;
        packageItemWrapper.ProductType = (String)objFromValList.get('ProductType');
        
        
    }
    
    private static void getQuoteLineItemObject(List<Object> valList,
                                               List<QuoteLineItemPkgWrapper> listOfProductsforEachOffer)
    {
        System.debug('inside getQuoteLineItemObject---'+JSON.serialize(valList));
        try{
             for(Integer i=0;i<valList.size();i++){
                System.debug('inside vallist loop--'+valList.size()+' loop counter--'+i);
                map<String,Object> objFromValList = (map<String,Object>)valList[i];
                System.debug('(String)objFromValList.get(name)..'+(String)objFromValList.get('name'));
                if((String)objFromValList.get('name')!=null){
                    QuoteLineItemPkgWrapper packageItemWrapper = new QuoteLineItemPkgWrapper();
                    if(objFromValList.get('Is_Package') == true && objFromValList.get('ProductType') == 'Package' && ( objFromValList.get('price') != null ||  objFromValList.get('recurringCharge') != null)) {
                        constructQuoteItemWrapper(packageItemWrapper,objFromValList);
                        listOfProductsforEachOffer.add(packageItemWrapper);
                        break;
                    }
                    
                    constructQuoteItemWrapper(packageItemWrapper,objFromValList);
                    listOfProductsforEachOffer.add(packageItemWrapper);
                }else if((String)objFromValList.get('name') == null){
                    for (String key : objFromValList.keySet()){
                        System.debug('key is of objFromValList-' + key);
                        List<Object> nextLevelValList =(List<Object>)objFromValList.get(key);
                        map<String,Object> childBundleParentobj = (map<String,Object>)nextLevelValList.get(0);
                        System.debug('nextLevelValList.get(0).getmandatory.. '+(String)childBundleParentobj.get('mandatory'));
                        if((String)childBundleParentobj.get('mandatory')!='OptIn'){
                            getQuoteLineItemObject(nextLevelValList,listOfProductsforEachOffer);
                        }
                    }             
                    
                }
            }
        }
        catch(Exception e){
            System.debug('exception in getQuoteLineItemObject'+e.getStackTraceString());
            System.debug('exception in getQuoteLineItemObject msg'+e.getMessage());
        }
       
    }
    

    private static void constructRequestForGetProposition(List<Object> valList,
                                                          List<QuoteLineItemPkgWrapper> listOfProductsforEachOffer)
    {
        System.debug('valList.key.. '+valList);
        getQuoteLineItemObject(valList,listOfProductsforEachOffer);
    }
    

    @AuraEnabled
    public static Map<String,String> getPriceCalculationRevampForBOB(String productLineItemMapStr) {
        
        String quoteId;
        System.debug('Inside method getPriceCalculation Revamp BOB> '+productLineItemMapStr);
        Map<String, List<QuoteLineItemPkgWrapper>> afterIteratorMap = new Map<String, List<QuoteLineItemPkgWrapper>>();
        List<Object> serviceMapList =   (List<Object>)JSON.deserializeUntyped(productLineItemMapStr);
        String keyForService;
        System.debug('serviceMapList-------'+JSON.serialize(serviceMapList));
        for(Integer j=0;j<serviceMapList.size();j++){
            map<String, Object> serviceItem = (map<String, Object>)serviceMapList[j];
            keyForService=(String)serviceItem.get('key');
            System.debug('keyForService.. '+keyForService);
            List<Object> offerItemWrapperMapList =   (List<Object>)(serviceItem.get('value'));
            system.debug('offerItemWrapperMapList'+JSON.serialize(offerItemWrapperMapList));
            
            for(Integer i=0;i<offerItemWrapperMapList.size();i++){
                map<String, Object> item = (map<String, Object>)offerItemWrapperMapList[i];
                String keyForOffer=(String)item.get('key');
                System.debug('keyForOffer.. '+keyForOffer);
                List<QuoteLineItemPkgWrapper> listOfProductsforEachOffer = new List<QuoteLineItemPkgWrapper>();
                constructRequestForGetProposition((List<Object>)item.get('value'),listOfProductsforEachOffer);
                afterIteratorMap.put(keyForOffer+keyForService,listOfProductsforEachOffer);
            }
        }
        List<String> prodOfferIdList = new List<String>();
        set<String> wrapperKeys = afterIteratorMap.keySet();
        System.debug('wrapperKeys keys..'+wrapperKeys);
        for (String wkey:wrapperKeys) {
            
            System.debug('hobsItemQuoteList keyy.. '+wkey);
            System.debug('hobsItemQuoteList val.. '+afterIteratorMap.get(wkey));
            for (QuoteLineItemPkgWrapper eachChild:afterIteratorMap.get(wkey)){
                System.debug('hobsItemQuoteList val.. '+eachChild.productOfferingId);
                prodOfferIdList.add(eachChild.productOfferingId);
                quoteId = eachChild.quote;
            }
        }
        System.debug('prodOfferIdList data.. '+prodOfferIdList + '-quoteId-' + quoteId);
        Map<String,String> priceTypeWithValue = new Map<String,String>();
        try{
            PropositionPriceJSONRequest propositionReq = new PropositionPriceJSONRequest();
            String jsonString = propositionReq.generateJsonForList(afterIteratorMap, 'update');//'new'
            System.debug('jsonString tibcart getProposition before access service:'+jsonString);
            String url = 'callout:TibCart_Service';
            System.debug('tibcart url:'+url);
            String responseStr = HTTPUtility.getServiceResponse(jsonString, url, 'POST');
            responseStr = responseStr.replace('currency', 'currency1');
            system.debug('responseStr '+responseStr);
            getPropositionPrice propositionResp = getPropositionPrice.parse(responseStr);
            system.debug('getPropositionPrice-->'+propositionResp);
            getPriceSummationRevamp(propositionResp,priceTypeWithValue,quoteId);
            System.debug('returned val is.. '+priceTypeWithValue);          
        }
        catch(Exception e) {
            System.debug('Error in priceCalrevamp '+  e.getStackTraceString());
            
        }
        return priceTypeWithValue;
    }
    
    

    @AuraEnabled
    public static Map<String,String> getPriceSummationRevamp(getPropositionPrice propositionResp,
                                                             Map<String,String> priceTypeWithValue, String quoteId) 
    {
        System.debug('quoteId in pkgCtrler getPriceSummation:'+quoteId);
        if(propositionResp != Null && propositionResp.pricedCart != Null && propositionResp.pricedCart.size() >0 && propositionResp.pricedCart[0].totalPrice != Null && propositionResp.pricedCart[0].totalPrice.chargeLine != Null) {
            List<getPropositionPrice.cls_chargeLine> chargeLines = propositionResp.pricedCart[0].totalPrice.chargeLine;
            system.debug('chargeLines -->'+chargeLines);
            for(getPropositionPrice.cls_chargeLine chargeLine : chargeLines) {
                if(chargeLine.chargeType == 'NRC_ORIGINAL' ) {
                    getPropositionPrice.cls_charge charge = chargeLine.charge;
                    system.debug('NRC_ORIGINAL Charge-getPriceSummation->'+charge.amount);
                    priceTypeWithValue.put('NRC', String.valueOf(Decimal.valueof(charge.amount)));
                }
                if(chargeLine.chargeType == 'RC_ORIGINAL') {
                    getPropositionPrice.cls_charge charge = chargeLine.charge;
                    system.debug('RC_ORIGINAL Charge-getPriceSummation->'+charge.amount);
                    priceTypeWithValue.put('RC', String.valueOf(Decimal.valueof(charge.amount)));
                    
                }
            }                                                     
        }
        else {
            priceTypeWithValue.put('NRC', '0.0');
            priceTypeWithValue.put('RC', '0.0');
        }
        System.debug('After changes in getPriceSummation->'+priceTypeWithValue);
        return priceTypeWithValue;
    }
    
    
    
    
    
    

    @AuraEnabled
    public static List<String> validate(String quoteId,List<String> productOfferingId) 
    {
        system.debug('productOfferingId is at  .. '+productOfferingId + 'quoteId .. '+quoteId);
        List<String> listOfPkgNames  = new List<String>();
        for(String prodId : productOfferingId){
            system.debug('prodId is at  .. '+prodId);
        }
        //added for PMD fix- apex crud violation by RIMI
        if(!Schema.sObjectType.Quote_Line_Item__c.fields.Name.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        List<Quote_Line_Item__c> itemList = [SELECT Name FROM Quote_Line_Item__c WHERE Quote__c =:quoteId AND productOfferingId__c IN :productOfferingId ];
        if(itemList!=null){
            System.debug('itemList is'+itemList.size());
        }
        for(Quote_Line_Item__c eachItem : itemList)
        {
            System.debug('eachItem is'+eachItem);
            System.debug('eachItem is'+eachItem.Name);
            listOfPkgNames.add(eachItem.Name);
        }
        
        return listOfPkgNames;
        
    }

    @AuraEnabled
    public static boolean emptyCheck(String quoteId) 
    {
        System.debug('QuoteId is'+quoteId);
        //added for PMD fix- apex crud violation by RIMI
        if (!Schema.sObjectType.Quote_Line_Item__c.fields.Name.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        List<Quote_Line_Item__c> itemListPackages = [SELECT Name FROM Quote_Line_Item__c WHERE Quote__c =:quoteId ];
        System.debug('itemListPackages name'+itemListPackages);
        System.debug('itemListPackages size'+itemListPackages.size());
        if(itemListPackages!=null && itemListPackages.size()>0){
            System.debug('itemListPackages is'+itemListPackages.size());
            return true;
        }
        
        return false;
    }
    

    @AuraEnabled
    public static  Map<String,List<Map<String,String>>> fetchExistingAttributes(String quoteId,decimal currentVersion) 
    {
        system.debug('quoteId in fetchExistingAttributes'+quoteId+'currentVersion'+currentVersion);
        List<AttributeMapConverter> existingAttrList = new List<AttributeMapConverter>();
        //added for PMD fix- apex crud violation by RIMI
        if(!Schema.sObjectType.Attribute__c.fields.Attribute_value__c.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        List<Attribute__c> itemList = [SELECT Name,Attribute_value__c,ProductSpec__c FROM Attribute__c WHERE QuoteId__c =:quoteId and QuoteVersion__c=:currentVersion];
        Map<String,List<Map<String,String>>> attrMap = new  Map<String,List<Map<String,String>>>();
        system.debug('itemList in fetchExistingAttributes '+itemList);
        if(itemList!=null && !itemList.isEmpty()){
            for(Attribute__c attribute : itemList)
            {
                System.debug('attrMap1'+attrMap);
                if(attrMap.get(attribute.ProductSpec__c) == null) {
                    System.debug('attrMap2'+attrMap);
                    List<Map<String,String>> attrLst = new List<Map<String,String>>();
                    Map<String,String> m = new Map<String,String>();
                    m.put(attribute.Name,attribute.Attribute_value__c);
                    attrLst.add(m);
                    attrMap.put(attribute.ProductSpec__c,attrLst);
                }else {
                    System.debug('attrMap.get(attribute.ProductSpec__c)'+attrMap.get(attribute.ProductSpec__c));
                    List<Map<String,String>> attrList = attrMap.get(attribute.ProductSpec__c);
                    Map<String,String> mm = new Map<String,String>();
                    mm.put(attribute.Name,attribute.Attribute_value__c);
                    attrList.add(mm);
                    attrMap.put(attribute.ProductSpec__c,attrList);
                }
                
            }          
        }
        System.debug('attrMap'+attrMap);
        return attrMap;
    }

    @AuraEnabled
    public static  String checkQuoteStatus(String quoteId) 
    {
        try{
            Quote quote = [SELECT Id,Status FROM Quote WHERE Id=:quoteId];
            system.debug('quote.Status'+quote.Status);
            return quote.Status;
        } Catch(Exception e) {
            System.debug('Error while fetching quote'+quoteId);
            return 'ERROR';
        }
        
    }

    @AuraEnabled
    public static decimal getQuoteCurrentVersion(String quoteId){
        Quote q = [SELECT Name,CurrentVersion__c FROM Quote WHERE Id=:quoteId];
        return q.CurrentVersion__c;
    } 
    
    

    
    @AuraEnabled
    public static String getAccountIdFromQuote(String quoteId){
        Quote q = [SELECT AccountId FROM Quote WHERE Id=:quoteId];
        String tinNo=getTINFromAccount(q.AccountId);
        System.debug('tinNo is'+tinNo +'Id- '+q.AccountId);
        //added by surya to get url
        //OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
        OrgDefaults__c config =getOrgDefaults();
        String urlmap=config.tcare_url__c+ tinNo;
        System.debug('url in getacccount.. '+urlmap);
        return urlmap;
    }
    
    public static String getTINFromAccount(String accountId){
        //added for PMD fix- apex crud violation by RIMI
        if (!Schema.sObjectType.Account.fields.Business_Identifier__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        Account q = [SELECT Business_Identifier__c  FROM Account  WHERE Id=:accountId];
        return q.Business_Identifier__c;
    }
    
    public class QuoteLineItemPkgWrapper {
        
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public Decimal quantity {get; set;}
        @AuraEnabled public String currencyObj {get; set;}
        @AuraEnabled public String price {get; set;}   //Decimal
        @AuraEnabled public String recurringCharge {get; set;} //Decimal
        @AuraEnabled public String attribute {get; set;}
        @AuraEnabled public boolean Is_Package {get; set;}
        @AuraEnabled public boolean isAddon {get; set;}	
        @AuraEnabled public String productOfferingId {get; set;}
        @AuraEnabled public String mandatory {get; set;}
        @AuraEnabled public String quote {get; set;}
        @AuraEnabled public Decimal rcvariableprice {get; set;}//for priceoverride
        @AuraEnabled public Decimal nrcvariableprice {get; set;}//for priceoverride
        @AuraEnabled public String ProductType {get; set;} //for addons
        @AuraEnabled public String rcnetprice {get; set;} //for code revamp - Decimal
        @AuraEnabled public String nrcnetprice {get; set;} //for code revamp - Decimal
        @AuraEnabled public String rcdiscountedValue {get; set;} //for code revamp
        @AuraEnabled public String nrcdiscountedValue {get; set;} //for code revamp
        @AuraEnabled public String parentproductOfferingId {get; set;}//for existing offers
        @AuraEnabled public String existingLineItem {get; set;}//for existing offers
        @AuraEnabled public Integer minQuantity {get; set;}//for cardinality check
        @AuraEnabled public Integer maxQuantity {get; set;}//for cardinality check
        @AuraEnabled public Boolean fromDB {get; set;}//for checking the item is from db or not
        @AuraEnabled public Boolean packagedPriced {get; set;}//for bundle level pricing 
        @AuraEnabled public String rcProductOfferingPriceID {get; set;} 
        @AuraEnabled public String rcPricingClassifier {get; set;} 
        @AuraEnabled public String rcBillingComponentType {get; set;}
        @AuraEnabled public String nrcdiscountType {get; set;}
        @AuraEnabled public String rcdiscountType {get; set;}
        @AuraEnabled public String nrcProductOfferingPriceID {get; set;} 
        @AuraEnabled public String nrcPricingClassifier {get; set;} 
        @AuraEnabled public String nrcBillingComponentType {get; set;}
        @AuraEnabled public cls_summaryOfCharges summaryOfCharges {get; set;}
        @AuraEnabled public String status {get; set;}
    } 
    
    public class cls_summaryofCharges{
        @AuraEnabled  public cls_attribute[] attribute;
    }
    
    
    public class cls_attribute {
        @AuraEnabled public String attributeName;	// RC
        @AuraEnabled public String attributeId;   // RC
        @AuraEnabled public String attrValue;  // 0
        @AuraEnabled public String typeofCurrency; 
    }
    public class QuoteLineItem {
        
        public String key;	
        public List<QuoteLineItemPkgWrapper> value;	
        
    } 
    
    public class QuoteWrapper {
        @AuraEnabled public Decimal nonRecurringCharges {get; set;}
        @AuraEnabled public Decimal recurringCharges {get; set;}
    } 
    public class  VersionWrapper {
        @AuraEnabled public Decimal quoteVersion {get; set;}
    }
    

    @AuraEnabled
    public Static  List<VersionWrapper> getQuotetVersionlist(String quoteId)
    {
        List<VersionWrapper> versionWrapperList = new  List<VersionWrapper>();
        //added for PMD fix- apex crud violation by RIMI
        if(!Schema.sObjectType.Version__c.fields.VQuoteVersion__c.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        List<Version__c> versionList = [SELECT VQuoteVersion__c  FROM Version__c WHERE VQuote__c=:quoteId];
        if(versionList != null && versionList.size()>0) {
            for(Version__c ver : versionList) {
                VersionWrapper vw = new VersionWrapper();
                vw.quoteVersion = ver.VQuoteVersion__c;
                versionWrapperList.add(vw);
            }
        } else {
            VersionWrapper vw1 = new VersionWrapper();
            vw1.quoteVersion = 1.0;
            versionWrapperList.add(vw1);
        }
        System.debug('result is'+ versionWrapperList);
        return versionWrapperList;   
    } 
   
    

    @AuraEnabled
    public static Map<String,String> getVersionPrice(String quoteId,Decimal versionId) {
        System.debug('Inside method getInitialPriceAtQuoteLevel'+quoteId);
        //added for PMD fix- apex crud violation by RIMI
        if (!Schema.sObjectType.Version__c.fields.VRecurring_Charge__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        Version__c quote = [SELECT Id,VRecurring_Charge__c,VPrice__c  FROM Version__c WHERE VQuote__c=:quoteId and VQuoteVersion__c=:versionId];
        System.debug('quote '+quote);
        QuoteWrapper quoteWrapper = new QuoteWrapper();
        if(quote.VPrice__c == Null) {
            quote.VPrice__c = 0;
            quoteWrapper.nonRecurringCharges = 0;
        }
        else{
            quoteWrapper.nonRecurringCharges = quote.VPrice__c;
        }
        
        if(quote.VRecurring_Charge__c == Null) {
            quote.VRecurring_Charge__c = 0; 
            quoteWrapper.recurringCharges = 0; 
        }
        else {
            quoteWrapper.recurringCharges = quote.VRecurring_Charge__c;
        }
        
        Map<String,String> priceTypeWithValue = new Map<String,String>();
        priceTypeWithValue.put('NRC', String.valueOf(quote.VPrice__c));
        priceTypeWithValue.put('RC', String.valueOf(quote.VRecurring_Charge__c));
        System.debug('priceTypeWithValue '+priceTypeWithValue);
        return priceTypeWithValue;
    }
    
    

    
    @AuraEnabled
    public static Object getPriceForGivenAddon(Map<String,Object> addonAsString,String prodOfferIdOfPackage,
                                               String quoteID){
                                                   System.debug('addonAsString in packageController.. '+addonAsString);
                                                   return AddonController.getPriceForGivenAddonNew(addonAsString,prodOfferIdOfPackage,quoteID);
                                               } 
    
    
    @AuraEnabled
    public static Object getPriceForGivenAddonForOrder(Map<String,Object> addonAsString,String prodOfferIdOfPackage,
                                                       String quoteID){
                                                           System.debug('addonAsString in packageController.. '+addonAsString);
                                                           return AddonController.getPriceForGivenAddonForOrder(addonAsString,prodOfferIdOfPackage,quoteID);
                                                       } 

    @AuraEnabled
    public static String createAgreement(String quoteId, Decimal version,String agreementName,Date startdate, Date expdate,String agreementDesc,integer agreementTerm) {
        try{
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.Agreement__c.fields.Name.isAccessible()&&
               !Schema.sObjectType.Agreement__c.fields.Name.isCreateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Quote.fields.Name.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Opportunity.fields.CurrencyIsoCode.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            List<Agreement__c> oldAgrmnt = [SELECT Id,Name FROM Agreement__c WHERE com_tcs_telecom__Quote__c=:quoteId];
            if(oldAgrmnt != null && oldAgrmnt.size()>=1) {return 'AgrmntExistError';}
            Quote quote = [SELECT Id,Name,AccountId,BillingCity,BillingCountry,BillingState,BillingPostalCode,OpportunityId FROM Quote WHERE Id=:quoteId];
            Opportunity opp = [SELECT Id,CurrencyIsoCode FROM Opportunity WHERE Id=:quote.OpportunityId];
            System.debug('quote '+quote);
            Agreement__c agrmnt=new Agreement__c(); 
            //    agrmnt.Quote_Id__c = quoteId;
            agrmnt.com_tcs_telecom__Quote__c = quoteId;
            //   agrmnt.Quote_Version__c = version;
            // agrmnt.com_tcs_telecom__Agreement_End_Date__c = quote.ExpirationDate;
            agrmnt.Name = agreementName;
            agrmnt.com_tcs_telecom__Agreement_Description__c = agreementDesc;
            agrmnt.com_tcs_telecom__Agreement_Start_Date__c = startdate;
            agrmnt.com_tcs_telecom__Agreement_End_Date__c = startdate.addMonths(agreementTerm).addDays(-1);
            agrmnt.CurrencyIsoCode   = opp.CurrencyIsoCode;
            //agrmnt.com_tcs_telecom__Agreement_Status__c = 'In Progress';
            agrmnt.com_tcs_telecom__Account__c=quote.AccountId;
            insert agrmnt;
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.Contract.fields.AccountId.isCreateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            
            Contract cntrt = new Contract();
            cntrt.AccountId = quote.AccountId;
            cntrt.com_tcs_telecom__Agreement__c = agrmnt.Id;
            cntrt.StartDate = startdate;
            ////  cntrt.EndDate = expdate;
            cntrt.BillingCity = quote.BillingCity;
            cntrt.BillingCountry = quote.BillingCountry;
            cntrt.BillingStreet = quote.BillingState;
            cntrt.BillingState = quote.BillingState;
            cntrt.BillingPostalCode = quote.BillingPostalCode;
            cntrt.ContractTerm = agreementTerm;
            cntrt.CurrencyIsoCode = opp.CurrencyIsoCode;
            insert cntrt;
            
        }
        catch(Exception e){
            System.debug('-Exception in createAgreement --' +e.getMessage()+e.getStackTraceString());
            return 'error';
        }
        return 'success';
    }

   
    
    
    @AuraEnabled
    public static String formQuoteToOrder(String quoteId, Decimal version) {
        ////String jsonString = QuoteToOrderConverter.formQuoteToOrder(quoteId,version);
         String jsonString = null;
        try{
            
            ////if(versionObj==null) {
            //    return 'submiterror';
            //   }
             jsonString = QuoteToOrderConverterNew.formQuoteToOrder(quoteId,version);
            jsonString = jsonString.replace('currency1', 'currency');
            system.debug('jsonStringnew'+jsonString);
            String url = 'callout:Create_sales_order';
            //String zuoraAcc = 'callout:Zuora_Account';
			//String ZuoraContact = 'callout:Zuora_Contact';
			//String ZuoraSubscription = 'callout:Zuora_Subscription';
            //	https://hobs.tcs.com/hobsrestgateway/salesordergatewayservices/salesordergateway/order/create
            ////String url = 'https://hobs.tcs.com/dev-hobsrestgateway/salesordergatewayservices/salesordergateway/order/create';
            
            //call Zuora for createAccount
            //Zuora for createContact
            //Zuora for createOrder
         
            if(jsonString.equals('error')) {
                return 'emptyerror';
            } else if(jsonString.equals('NoContact')) {
                return 'NoContact';
            } else {
                //added for PMD fix- apex crud violation by RIMI
                if(!Schema.sObjectType.Quote.fields.Name.isAccessible()&&
                   !Schema.sObjectType.Quote.fields.Name.isCreateable() &&
                   !Schema.sObjectType.Quote.fields.Name.isUpdateable())
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                    
                }
                if(!Schema.sObjectType.Version__c.fields.SALES_ORDER_ID__c.isAccessible()&&
                   !Schema.sObjectType.Version__c.fields.SALES_ORDER_ID__c.isCreateable() &&
                   !Schema.sObjectType.Version__c.fields.SALES_ORDER_ID__c.isUpdateable())
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                    
                }
                Version__c versionObj = [SELECT Id,SALES_ORDER_ID__c  FROM Version__c WHERE VQuote__c=:quoteId and VQuoteVersion__c=:version];
                System.debug('versionObj'+versionObj);   
                //String zuoraAccResp = HTTPUtility.getServiceResponse(ZuoraIntegration.createAccount( quoteId), zuoraAcc, 'POST');
                //System.debug('zuoraAccResp'+zuoraAccResp);
                //String zuoraContactResp = HTTPUtility.getServiceResponse(ZuoraIntegration.createContact(quoteId), ZuoraContact, 'POST');
                //System.debug('zuoraContactResp'+zuoraContactResp);
                //String zuoraSubs = HTTPUtility.getServiceResponse(ZuoraIntegration.createSubscription(quoteId), ZuoraSubscription, 'POST');
                //System.debug('zuoraSubs'+zuoraSubs);
                String responseStr = HTTPUtility.getServiceResponse(jsonString, url, 'POST');
                System.debug('responseStr'+responseStr);
                ResponseObject responseObject = (ResponseObject)System.JSON.deserialize(responseStr, ResponseObject.class);
                List<Status> statusLst = responseObject.statusList;
                Status ss = null;
                if(statusLst != null && statusLst.size()>0) {
                    ss = statusLst.get(0);
                }
                if(ss != null && ss.statusCode == '0000') {
                    Quote quoteObj = [SELECT Id,Name,Status FROM Quote WHERE Id=:quoteId];
                    quoteObj.Status = 'Closed';
                    upsert quoteObj;
                    //  Version__c versionObj = [SELECT Id,SALES_ORDER_ID__c  FROM Version__c WHERE VQuote__c=:quoteId and VQuoteVersion__c=:version];
                    if(versionObj!=null) {
                        versionObj.SALES_ORDER_ID__c = responseObject.salesOrderID;
                        upsert versionObj;
                    }
                    return responseObject.salesOrderID;
                }
                else {
                    return 'error';
                }
            }
        }catch (Exception e) {
            system.debug('Exception in creating sales order'+e.getMessage());
            System.debug('e.getStackTraceString()'+e.getStackTraceString());
            system.debug('e'+e);
            return e.getMessage()+e.getStackTraceString();
        }finally{
            CommonUtilDao.setStatus(jsonString,quoteId);
        }
    } 
    
    

    class ResponseObject {
        String interactionID;
        String description;
        String triggeredBy;
        String    opID;
        String    buID;
        String    partnerID;
        List<Status>   statusList;
        String   salesOrderID;
    }
    class Status {
        String statusCode;
        String statusType;
        String statusDescription;
    }
    

    @AuraEnabled
    public Static map<String,map<String,List<Object>>> getExistingOffersForExistingServiceTypes(map<String,map<String,List<Object>>> resultMap, 
                                                                                                String quoteId, 
                                                                                                Map<String, Object> offerMap,String serviceType,
                                                                                                Decimal currentVersion,
                                                                                                List<Object> existingServiceOfferMap) 
    { 
        
        return FormMap.getExistingOffersForExistingServiceTypes(resultMap, quoteId, offerMap, serviceType,currentVersion,
                                                                existingServiceOfferMap);
        
    }
    // Description: The below method is used to reterive account details based on salesorder id to display in sales order page.
    // Date: 1-2-2019
    
   
    

    @AuraEnabled
    public static String getName(String quoteId){
        Quote q = [SELECT Name FROM Quote WHERE Id=:quoteId];
        return q.Name;
        //return null;
    } 
     @AuraEnabled
    public static List<Quote> getCreatedateandby(String quoteId){
        
       //List<Quote> qlist = [SELECT Name,Owner.Name,CreatedDate,AccountId,OpportunityId,ExpirationDate FROM Quote WHERE Id=:quoteId];
       List<Quote> qlist = [SELECT Name,Owner.Name,CreatedDate,AccountId,Account.Name,OpportunityId,Opportunity.Name,ExpirationDate FROM Quote WHERE Id=:quoteId];       
        return qlist;     
      
    }
   
    public class packagewrapper{
        public string name;
        public string age;
        //public cls_item items;
    }
    public class cls_item{
        public string itemname;
        public string itemage;
    }
     @AuraEnabled
    public static packagewrapper testwrapper(){
        packagewrapper pkg = new packagewrapper();
        pkg.name = 'test';
        pkg.age = '23';
        cls_item it = new cls_item();
        it.itemname = 'itemtest';
        it.itemage = '34';
        //pkg.items = it;
        system.debug('object..'+JSON.serialize(pkg));
        return pkg;
    }
    
    @AuraEnabled
    public static String getCurrency(String quoteId){
        Quote q = [SELECT OpportunityId FROM Quote WHERE Id=:quoteId];
        Opportunity opp=[SELECT CurrencyIsoCode FROM Opportunity where Id=:q.OpportunityId];
        System.debug('currency---'+opp.CurrencyIsoCode);
        return opp.CurrencyIsoCode;
        //return null;
    } 
    
    @AuraEnabled
    public static String getOrderName(String orderId){
        //added for PMD fix- apex crud violation by RIMI
        if(!Schema.sObjectType.com_tcs_telecom__SubmitOrder__c.fields.Name.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        com_tcs_telecom__SubmitOrder__c order = [SELECT Name FROM com_tcs_telecom__SubmitOrder__c WHERE Id=:orderId];
        return order.Name;
        //return null;
    } 
    
    @AuraEnabled
    public static String buildQuoteLine(String quoteId,String serviceTypeValue){
        String srvcCatg=null;
        String response=null;
        boolean flag=true;
         List<QuoteLine__c> quoteLineList = new List<QuoteLine__c>();
        system.debug('serviceTypeValue---'+serviceTypeValue);
        system.debug('quoteId---'+quoteId);
        try{
            srvcCatg=QuoteController.getSrvcNameBySrvcValue(serviceTypeValue,quoteId);
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.QuoteLine__c.fields.Service_Type__c.isCreateable() &&
               !Schema.sObjectType.QuoteLine__c.fields.Service_Type__c.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }else{
                  quoteLineList = [SELECT Service_Type__c  FROM QuoteLine__c WHERE Quote_Id__c=:quoteId];
            }
           
            List<String> srvcTypeList = new List<String>();
            if(quoteLineList!=null && quoteLineList.size()!=0)
            {
                flag=checkServiceTypeforQuoteLine(quoteLineList,srvcCatg);
                System.debug('flag=='+flag);
            }
            if(flag)
            {
                if(!Schema.sObjectType.QuoteLine__c.fields.Service_Type__c.isCreateable() &&
               !Schema.sObjectType.QuoteLine__c.fields.Service_Type__c.isAccessible() && 
                    !Schema.sObjectType.QuoteLine__c.fields.Quote_Id__c.isCreateable() &&
                    !Schema.sObjectType.QuoteLine__c.fields.Quote_Id__c.isAccessible())
            	{
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                	return null;
                }
                else{
                    QuoteLine__c quoteLine= new QuoteLine__c();
               		 quoteLine.Service_Type__c=srvcCatg;
                	quoteLine.Quote_Id__c=quoteId;
                	insert quoteLine;
               	 	response='inserted quoteLine' ;
                	}
                
            }
            else
            {
                response='quoteLine exists';
            }
        }
        catch(Exception e){
            System.debug('exception'+e);
        }
        System.debug('response----'+response);
        return response;
    } 
    
    private static boolean checkServiceTypeforQuoteLine(List<QuoteLine__c> quoteLineList, String srvcCatg){
        System.debug('inside checkServiceTypeforQuoteLine--'+srvcCatg);
        System.debug('quoteLineList size--'+quoteLineList.size());
        List<String> srvcTypeList = new List<String>(); 
        boolean flag=false;
        for(QuoteLine__c qt:quoteLineList)
        {
            System.debug('qt.Service_Type__c--'+qt.Service_Type__c);
            srvcTypeList.add(qt.Service_Type__c);
        }
        System.debug('srvcTypeList-----'+srvcTypeList.size());
        if(srvcTypeList.contains(srvcCatg))
        {
            flag=false;
        }
        else{
            flag=true;
        }
        return flag;
    }
    //Added by Surya for Syncing
    @AuraEnabled
    public static  Map<String,String> persistGrandTotalForQuote(String quoteId)
    {
        Map<String,String> resMap = new Map<String,String>();    
        try{
            Decimal grandTotal;
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.Quote.fields.Quote_Grand_Total__c.isAccessible()&&
               !Schema.sObjectType.Quote.fields.Quote_Grand_Total__c.isCreateable() &&
               !Schema.sObjectType.Quote.fields.Quote_Grand_Total__c.isUpdateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Opportunity.fields.QuoteInSync__c.isAccessible()&&
               !Schema.sObjectType.Opportunity.fields.QuoteInSync__c.isCreateable() &&
               !Schema.sObjectType.Opportunity.fields.QuoteInSync__c.isUpdateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(quoteId!=null)
            {
                System.debug(' quoteId ::'+quoteId);
                Quote quote1 = [SELECT Quote_Grand_Total__c,OpportunityId,IsSync__c FROM Quote WHERE Id=:quoteId];
                grandTotal= quote1.Quote_Grand_Total__c ;
                System.debug('Opportunity Id is:'+quote1.OpportunityId);
                
                if(grandTotal!=null){
                    Opportunity totalpriceupdate = [SELECT Amount,QuoteInSync__c FROM Opportunity WHERE id=:quote1.OpportunityId];
                    
                    if(totalpriceupdate.QuoteInSync__c==null)
                    {  
                        totalpriceupdate.Amount= grandTotal;
                        totalpriceupdate.QuoteInSync__c=quoteId;
                        quote1.IsSync__c=True;
                        System.debug('Opportunity amount is'+totalpriceupdate.Amount);
                        upsert totalpriceupdate;//updation of opportunity
                        upsert quote1; //updation of quote
                        //return 'success';
                    }else{
                        Quote quote2 = [SELECT Name FROM Quote WHERE Id=:totalpriceupdate.QuoteInSync__c];
                        System.debug('Quote which already exist is:'+quote2.Name);
                        resMap.put('quoteexisterror','Quote ' + quote2.Name +' ');
                        return resMap;
                    }
                }
                else
                {
                    resMap.put('submitquoteerror','submitquoteerror');
                    return resMap;
                }
            }
        }catch(Exception e)
        {
            e.getMessage();
            System.debug('-Exception in updating grand total --' +e.getMessage());
            resMap.put('error','error');
            return resMap;
        }
        resMap.put('success','success');
        System.debug('resMap is'+JSON.serialize(resMap));
        return resMap;
    }
    
    //Stop Sync
    @AuraEnabled
    public static String stopSyncForQuote(String quoteId)
    {
        try{
            if(quoteId!=null)
            {
                Quote quote1 = [SELECT Id,OpportunityId,IsSync__c FROM Quote WHERE Id=:quoteId];
                System.debug('Opportunity Id  is:'+quote1.OpportunityId);
                Opportunity quoteSyncUpdate = [SELECT QuoteInSync__c FROM Opportunity WHERE id=:quote1.OpportunityId];
                if(quote1.IsSync__c==true){
                    quote1.IsSync__c=false;
                    quoteSyncUpdate.QuoteInSync__c=null;
                    if(!Schema.sObjectType.Quote.fields.IsSync__c.isUpdateable()){
                        return null;
                    }else{
                         upsert quote1;
                    }
                    if(!Schema.sObjectType.Opportunity.fields.QuoteInSync__c.isUpdateable()){
                         return null;
                    }else{
                         upsert quoteSyncUpdate;
                    }
                   
                }else
                {
                    return 'error';
                }
            } 
        }catch(Exception e)
        {
            e.getMessage();
            System.debug('-Exception in stop sync --' +e.getMessage());
            return 'error';
        }
        return 'success';
    }
    
    @AuraEnabled
    public static String submitForApprovalForQuote(String quoteId){
        System.debug('inside submitForApproval');
        try{
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.Quote.fields.Name.isAccessible()&&
               !Schema.sObjectType.Quote.fields.Name.isCreateable() &&
               !Schema.sObjectType.Quote.fields.Name.isUpdateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                return null;
                
            }
            else {
            Quote quoteObj=[SELECT Id,Name,Status,Approval_Triggered__c FROM Quote WHERE Id=:quoteId];
            if(quoteObj!=null){
                System.debug('submitForApproval quoteName--'+quoteObj.Name);
                quoteObj.Approval_Triggered__c=true;
                quoteObj.Status='In Review';
                upsert quoteObj;
            }
            else
            {
                System.debug('error in submit');
                return 'error';
            }
            }
        }
        catch(Exception e){
            System.debug('Exception in submitForApproval'+e.getMessage());
            return e.getMessage();
        }
        
        return 'success';
    }
    
    
    
    @AuraEnabled
    public static String cloneQuoteDetails(String quoteId,String quoteVersion){
        String response=null;
        // This is the object for which we required data.
        Map<String, Schema.SObjectField> objfieldMap = Quote.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for quote--------'+strfieldName);
        // Build a Dynamic Query String.
        Quote quote = Database.query('select ' + strfieldName + ' from Quote where Id=:quoteId');
        System.debug('quoteId----'+quote.Id+'  opportunityId'+quote.OpportunityId);
        Quote cloneQuote =quote.clone(false,true,false,false); 
        if(cloneQuote.Approval_Triggered__c==true){
            System.debug('approval triggered true');
            cloneQuote.Approval_Triggered__c=false;
        }
        if(System.today()>cloneQuote.ExpirationDate){
            System.debug('inside current date greater than expiration date');
            cloneQuote.ExpirationDate=System.today();
        }
        cloneQuote.Status='New';
        cloneQuote.CurrentVersion__c=1.0;
        insert cloneQuote;
        System.debug('clone quote id--'+cloneQuote.Id+'  clone quote opportunity id---'+cloneQuote.OpportunityId);
        cloneVersion(quoteId,Decimal.valueOf(quoteVersion),cloneQuote.Id);
        cloneQuoteLineAndSite(quoteId,Decimal.valueOf(quoteVersion),cloneQuote.Id);
        cloneQuoteLineItem(quoteId,Decimal.valueOf(quoteVersion),cloneQuote.Id,cloneQuote.CurrentVersion__c);
        cloneAttribute(quoteId,quoteVersion,cloneQuote.Id,cloneQuote.CurrentVersion__c);
        return cloneQuote.Id;
    }
    
    public static String cloneVersion(String quoteId,Decimal quoteVersion,String clonedQuoteId){
        Map<String, Schema.SObjectField> objfieldMap = Version__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for version--------'+strfieldName);
        // Build a Dynamic Query String.
        Version__c version = Database.query('select ' + strfieldName + ' from Version__c where VQuote__c=:quoteId and VQuoteVersion__c=:quoteVersion');
        Version__c clonedVersion=version.clone(false,true,false,false);
        if(!Schema.sObjectType.Version__c.fields.VQuote__c.isAccessible() &&
               !Schema.sObjectType.Version__c.fields.VQuote__c.isCreateable() &&
           		!Schema.sObjectType.Version__c.fields.VQuoteVersion__c.isAccessible()&&
               !Schema.sObjectType.Version__c.fields.VQuoteVersion__c.isCreateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                return null;
             }else{
                 clonedVersion.VQuote__c=clonedQuoteId;
        		 clonedVersion.VQuoteVersion__c=1.0;
       			 insert clonedVersion;
            }
       return null;
    }
    
    public static String cloneQuoteLineAndSite(String quoteId,Decimal quoteVersion,String clonedQuoteId){
        Map<String, Schema.SObjectField> objfieldMap = QuoteLine__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for quoteLine--------'+strfieldName);
        // Build a Dynamic Query String.
        List<QuoteLine__c> quoteLineList = Database.query('select ' + strfieldName + ' from QuoteLine__c where Quote_Id__c=:quoteId');
        System.debug('quoteLineList size--'+quoteLineList.size());
        for(QuoteLine__c quoteLine:quoteLineList){
            quoteLine.Quote_Id__c=clonedQuoteId;
            quoteLine.Parent_QuoteLine_Ref__c=quoteLine.Id;
            System.debug('cloned quote id in quoteLine--'+quoteLine.Quote_Id__c);
        }
        List<QuoteLine__c> clonedQuoteLineList= quoteLineList.deepClone();
        if(!Schema.sObjectType.QuoteLine__c.isAccessible())
        {
            return null;
        }else{
             insert clonedQuoteLineList;
        }
        return null;
    }
    
    public static String cloneQuoteLineItem(String quoteId,Decimal quoteVersion,String clonedQuoteId,Decimal clonedQuoteVersion){
        List<QuoteLine__c> newQuoteLineList=[SELECT Id,Parent_QuoteLine_Ref__c FROM QuoteLine__c WHERE Quote_Id__c=:clonedQuoteId];
        Map<String,String> quoteLineMap = new Map<String,String>();
        for(QuoteLine__c ql:newQuoteLineList){
            quoteLineMap.put(ql.Parent_QuoteLine_Ref__c,ql.Id);
        }
        Map<String, Schema.SObjectField> objfieldMap = Quote_Line_Item__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for quoteLineItem--------'+strfieldName);
        // Build a Dynamic Query String.
        List<Quote_Line_Item__c> quoteLineItemList = Database.query('select ' + strfieldName + ' from Quote_Line_Item__c where Quote__c=:quoteId and QuoteVersion__c=:quoteVersion');
        for(Quote_Line_Item__c qli:quoteLineItemList){
            qli.Parent_QuoteLineItem_Ref__c=qli.Id;
        }
        
        List<Quote_Line_Item__c> clonedQuoteLineItemList = quoteLineItemList.deepClone(); 
        
        for(Quote_Line_Item__c quoteLineItem:clonedQuoteLineItemList){
            quoteLineItem.Quote__c=clonedQuoteId;
            quoteLineItem.QuoteVersion__c=clonedQuoteVersion;
            if(quoteLineItem.quoteLineId__c!=null){
                System.debug('quoteId--->>>>'+quoteLineItem.Quote__c);
                System.debug('updating quotelineid');
                quoteLineItem.quoteLineId__c=quoteLineMap.get(quoteLineItem.quoteLineId__c);
            }
        }
        System.debug('clonedQuoteLineItemList size--'+clonedQuoteLineItemList.size());
        if(!Schema.sObjectType.Quote_Line_Item__c.isAccessible()){
            return null;
        }else{
             insert clonedQuoteLineItemList;
        	updateParentItemId(clonedQuoteId,clonedQuoteVersion);
        }
       return null; 
    }
    
    public static String updateParentItemId(String clonedQuoteId,Decimal clonedQuoteVersion){
        System.debug('inside updateParentItemId');
        //added for PMD fix- apex crud violation by RIMI
        if(!Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isAccessible() &&
           !Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isCreateable() &&
           !Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isUpdateable())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        List<Quote_Line_Item__c> qliList=[SELECT Id,Parent_Item__c,productOfferingId__c,parentproductofferingid__c FROM Quote_Line_Item__c WHERE Quote__c=:clonedQuoteId AND QuoteVersion__c=:clonedQuoteVersion];   
        Map<String,String> parentProdMap = new Map<String,String>();
        for(Quote_Line_Item__c qli:qliList){
            parentProdMap.put(qli.productOfferingId__c,qli.Id);
        }
        for(Quote_Line_Item__c ql:qliList){
            if(ql.Parent_Item__c!=null)
            {
                ql.Parent_Item__c= parentProdMap.get(ql.parentproductofferingid__c);
            }
        }
        if (!Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isUpdateable())
        {
            return null;
        }else{
             upsert qliList;
        }
       return null;
    }
    
    public static void cloneAttribute(String quoteId,String quoteVersion,String clonedQuoteId,Decimal clonedQuoteVersion){
        List<Quote_Line_Item__c> newQuoteLineItemList=[SELECT Id,Parent_QuoteLineItem_Ref__c FROM Quote_Line_Item__c WHERE Quote__c=:clonedQuoteId];
        Map<String,String> quoteLineItemMap = new Map<String,String>();
        for(Quote_Line_Item__c qli:newQuoteLineItemList){
            quoteLineItemMap.put(qli.Parent_QuoteLineItem_Ref__c,qli.Id);
        }
        Map<String, Schema.SObjectField> objfieldMap = Attribute__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for Attribute--------'+strfieldName);
        // Build a Dynamic Query String.
        //added for PMD fix- apex crud violation by RIMI
        if (!Schema.sObjectType.Attribute__c.fields.QuoteId__c.isCreateable() &&
            !Schema.sObjectType.Attribute__c.fields.QuoteVersion__c.isCreateable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
        List<Attribute__c> attributeList = Database.query('select ' + strfieldName + ' from Attribute__c where Quote__c=:quoteId');
        List<Attribute__c> clonedAttributeList = attributeList.deepClone();
        for(Attribute__c attr:clonedAttributeList){
            attr.Quote__c=clonedQuoteId;
            attr.QuoteId__c=clonedQuoteId;
            attr.QuoteVersion__c=clonedQuoteVersion;
            if(attr.Quote_LineItem__c!=null){
                System.debug('Updating quoteLineitem---'+attr.Quote__c);
                attr.Quote_LineItem__c=quoteLineItemMap.get(attr.Quote_LineItem__c);
            }
        }
        insert clonedAttributeList;
    }
    
    public static String getAllObjectFields(Map<String, Schema.SObjectField> objfieldMap){
        String strfieldName = '';
        for(Schema.SObjectField field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            strfieldName += fieldResult.getName() + ',';
        }
        System.debug('strfieldName1----'+strfieldName);
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        System.debug('strfieldName2--------'+strfieldName);
        return strfieldName;
    } 
    @AuraEnabled
    public static List<sobject> addsalesorder(){
        System.debug('Enter into the salesordercreation');
        //added for PMD fix- apex crud violation by RIMI
         List<salesorder__c> salesorderlist=new List<salesorder__c>();
        if (!Schema.sObjectType.salesorder__c.fields.SalesorderID__c.isCreateable())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        else{
           for (integer i=0; i<=10; i++)
        	{
            	salesorder__c salesobj =new salesorder__c();
            	salesobj.SalesorderID__c='salesorder000'+i;
            	salesorderlist.add(salesobj);
           	}
            insert salesorderlist;
        }
       return salesorderlist;
    }
    
  @AuraEnabled
    public static Quote getQuoteDetails(String quoteId,String quoteVersion){
        String response=null;
        // This is the object for which we required data.
        Map<String, Schema.SObjectField> objfieldMap = Quote.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for quote--------'+strfieldName);
        // Build a Dynamic Query String.
        Quote quote = Database.query('select ' + strfieldName + ' from Quote where Id=:quoteId');
        System.debug('quoteId----'+quote.Id+'  opportunityId'+quote.OpportunityId);
        return quote;
    }

   @AuraEnabled
    //public static String createpurchaseOrder(String quoteId, Decimal version,String PONumber,Date CustomerPODate, Date POReceivedDate,Date startdate,integer agreementTerm,String BillFrequency,String BillEntity,String TaxationType,String TaxExemptReason,String BillingReferenceNo,Date ExpectedDeliveryDate,String billingContact,String shippingContact,String deliveryContact,Boolean saveCheck) {
    public static String createpurchaseOrder(Map<string,string> purchaseOrderlist) {
        try{
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.PurchaseOrder__c.fields.Name.isAccessible()&&
               !Schema.sObjectType.PurchaseOrder__c.fields.Name.isCreateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Quote.fields.Name.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Opportunity.fields.CurrencyIsoCode.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
           // List<PurchaseOrder__c> purchaseordlist = [SELECT Id,Name FROM PurchaseOrder__c WHERE com_tcs_telecom__Quote__c=:quoteId AND com_tcs_telecom__POAutogenerate__c=:PONumber];
            List<PurchaseOrder__c> purchaseordlist = [SELECT Id,Name FROM PurchaseOrder__c WHERE com_tcs_telecom__Quote__c=:purchaseOrderlist.get('quoteId') AND com_tcs_telecom__PO_Status__c='Submitted'];
            System.debug('purchaseordlist size..'+purchaseordlist.size());
            if(purchaseordlist != null && purchaseordlist.size()>=1) {return 'PurchaseorderexistError';}
            else {
            //Quote quote = [SELECT Id,Name,AccountId,BillingCity,BillingCountry,BillingState,BillingPostalCode,OpportunityId,com_tcs_telecom__Non_Recurring_Charges__c,com_tcs_telecom__Recurring_Charges__c FROM Quote WHERE Id=:purchaseOrderlist.get('quoteId')];
            //Opportunity opp = [SELECT Id,CurrencyIsoCode FROM Opportunity WHERE Id=:quote.OpportunityId];
            //System.debug('quote '+quote);
            PurchaseOrder__c prcorder=new PurchaseOrder__c();
            prcorder.Id=purchaseOrderlist.get('pcid');
            prcorder.com_tcs_telecom__Quote__c = purchaseOrderlist.get('quoteId');
            prcorder.com_tcs_telecom__Customer_PO_Date__c = Date.valueOf(purchaseOrderlist.get('CustomerPODate'));
            prcorder.com_tcs_telecom__PO_Received_Date__c = Date.valueOf(purchaseOrderlist.get('POReceivedDate'));
            prcorder.com_tcs_telecom__Contract_Start_Date__c=Date.valueOf(purchaseOrderlist.get('startdate'));
            prcorder.com_tcs_telecom__Contract_Period_months__c=String.valueof(purchaseOrderlist.get('agreementTerm'));
            //prcorder.com_tcs_telecom__Contract_End_Date__c = Date.valueOf(purchaseOrderlist.get('poendDateValue'));
            prcorder.com_tcs_telecom__Contract_End_Date__c = Date.valueOf(purchaseOrderlist.get('startdate')).addMonths(Integer.valueOf(purchaseOrderlist.get('agreementTerm'))).addDays(-1);
            prcorder.com_tcs_telecom__Bill_Frequency__c=purchaseOrderlist.get('BillFrequency');
            //prcorder.com_tcs_telecom__Billing_Entity__c=purchaseOrderlist.get('BillEntity');
            prcorder.com_tcs_telecom__Taxation_Type__c=purchaseOrderlist.get('TaxationType');
            prcorder.com_tcs_telecom__Tax_Exempt_Reason__c=purchaseOrderlist.get('TaxExemptReason');
            prcorder.com_tcs_telecom__Billing_Ref_No__c=purchaseOrderlist.get('BillingReferenceNo');
            prcorder.com_tcs_telecom__Expected_Delivery_Date__c=Date.valueOf(purchaseOrderlist.get('ExpectedDeliveryDate'));
            prcorder.com_tcs_telecom__Non_Recurring_Charges__c=Decimal.valueOf(purchaseOrderlist.get('NonRecurringcharges'));
            prcorder.com_tcs_telecom__Recurring_Charges__c=Decimal.valueOf(purchaseOrderlist.get('Recurringcharges'));
            prcorder.com_tcs_telecom__purchaseorderCheck__c=true;
            prcorder.com_tcs_telecom__Quote_Version_c__c=Decimal.valueOf(purchaseOrderlist.get('version'));
            prcorder.com_tcs_telecom__purchaseorderBillingAccount__c=purchaseOrderlist.get('BillEntityAccount');
            prcorder.com_tcs_telecom__Customer_PO_Number__c=purchaseOrderlist.get('CustomerPONumber');
            prcorder.com_tcs_telecom__PO_Status__c=purchaseOrderlist.get('postatus');    
           // if(Boolean.valueOf(purchaseOrderlist.get('saveCheck'))==false){
            id uid=UserInfo.getUserId();
            User username= [select name from User where id=:uid];
            prcorder.com_tcs_telecom__CurrentOwners__c=uid;

           
            prcorder.com_tcs_telecom__BillingContact__c=purchaseOrderlist.get('billingContact'); 
            prcorder.com_tcs_telecom__ShippingContact__c=purchaseOrderlist.get('shippingContact');
            prcorder.com_tcs_telecom__DeliveryContact__c=purchaseOrderlist.get('deliveryContact');
            
           


            
           // purchaseordlist.add(prcorder);   
            upsert prcorder;
        if(purchaseOrderlist.get('postatus')=='Submitted')
                {
                 System.debug('going for approvalprocess');   
            approvalPO(prcorder.Id);
                }
        }
        }
        catch(Exception e){
            System.debug('-Exception in createPurchaseorder --' +e.getMessage()+e.getStackTraceString());
            return 'error';
        }
        return 'success';
    }
    
   @AuraEnabled
   public static List<sobject> checkPurchaseorder(String quoteId)
    {
       List<com_tcs_telecom__PurchaseOrder__c> purchaslistfirst= [select com_tcs_telecom__POAutogenerate__c,
                                                                  com_tcs_telecom__purchaseorderCheck__c,
                                                                  com_tcs_telecom__Bill_Frequency__c,
                                                                  com_tcs_telecom__purchaseorderBillingAccount__c,com_tcs_telecom__purchaseorderBillingAccount__r.Name,
                                                                  com_tcs_telecom__BillingContact__c,com_tcs_telecom__BillingContact__r.Name,
                                                                  com_tcs_telecom__Billing_Ref_No__c,
                                                                  com_tcs_telecom__Contract_End_Date__c,
                                                                  com_tcs_telecom__Contract_Period_months__c,
                                                                  com_tcs_telecom__Contract_Start_Date__c,
                                                                  com_tcs_telecom__Customer_PO_Date__c,
                                                                  com_tcs_telecom__Customer_PO_Number__c,
                                                                  com_tcs_telecom__DeliveryContact__c,com_tcs_telecom__DeliveryContact__r.Name,
                                                                  com_tcs_telecom__Expected_Delivery_Date__c,
                                                                  com_tcs_telecom__Non_Recurring_Charges__c,
                                                                  com_tcs_telecom__PO_Received_Date__c,
                                                                  com_tcs_telecom__Recurring_Charges__c,
                                                                  com_tcs_telecom__ShippingContact__c,com_tcs_telecom__ShippingContact__r.Name,
                                                                  com_tcs_telecom__Tax_Exempt_Reason__c,
                                                                  com_tcs_telecom__Taxation_Type__c,
                                                                  com_tcs_telecom__PO_Status__c	
                                                                  from com_tcs_telecom__PurchaseOrder__c where  
                                                                  Quote__c=:quoteId];
        system.debug('purchaslistfirstsize..'+purchaslistfirst.size());
        if(purchaslistfirst.size()==0)
        {
            PurchaseOrder__c prcordertest=new PurchaseOrder__c();
            prcordertest.com_tcs_telecom__Quote__c=quoteId;
            prcordertest.com_tcs_telecom__PO_Status__c='New';
            insert prcordertest; 
            List<com_tcs_telecom__PurchaseOrder__c> purchaslistsecond= [select Id,com_tcs_telecom__POAutogenerate__c,com_tcs_telecom__purchaseorderCheck__c,com_tcs_telecom__PO_Status__c	 from com_tcs_telecom__PurchaseOrder__c where  Quote__c=:quoteId]; 
            return purchaslistsecond;  
        }
        
       return purchaslistfirst;  
    }
 
    @AuraEnabled  
   public static List<ContentDocument> UpdateFiles(string documentId,string Description,string documenttype,string recordId){  
     //system.debug('title: ' +title);
     system.debug('Description:'+Description);  
     ContentDocument cd = [select id,title,Description,FileType from ContentDocument where Id=:documentId]; // Getting files from Parent record 
     //cd.Title = title;// Changing file Title with user entered title
     cd.Description=Description;
     cd.title=documenttype;  
     try{  
       update cd;  // Update ContentDocument (File)
     }  
     catch(DMLException e){  
       system.debug('Exception has occurred! ' +e.getMessage());  
     }
      List<ContentDocument> DocumentList = new List<ContentDocument>();  
     Set<Id> documentIds = new Set<Id>();  
     List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
     for(ContentDocumentLink cdLink:cdl){  
       documentIds.add(cdLink.ContentDocumentId);  
     }      
     DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
     return DocumentList;  // Return list of files on parent record
   } 
   public static void approvalPO(string recordId){
       id uid=UserInfo.getUserId();
       Group grp=[select Id from Group where Name='POApproval_EAST' AND Type =: 'Regular'];       
       Integer count =[select COUNT() from GroupMember where GroupId =: grp.Id];
       Integer rand = Math.floor(Math.random() * count).intValue();
       GroupMember grpId=[select UserOrGroupId from GroupMember where GroupId =:grp.Id LIMIT 1 OFFSET :rand];
       User uname=[select id,Name,Email from User where id =:grpId.UserOrGroupId];
       User sendername=[select id,Email from User where id =:uid];
       com_tcs_telecom__POApproval__c POApproval = new com_tcs_telecom__POApproval__c();       
       POApproval.com_tcs_telecom__SubmitterId__c =  uid;        
       POApproval.com_tcs_telecom__PurchaseOrder__c = recordId;
       POApproval.com_tcs_telecom__POStatus__c = 'Submitted';      
       POApproval.com_tcs_telecom__AssigneId__c = grpId.UserOrGroupId; 
       POApproval.com_tcs_telecom__SubmittedDate__c=System.now();
       insert POApproval; 
       
       PurchaseOrder__c purOrder=new PurchaseOrder__c();
       purOrder.Id = recordId;
       purOrder.OwnerId = grpId.UserOrGroupId;
       update purOrder;
       com_tcs_telecom__POApproval__c poappmaillist= [select id from com_tcs_telecom__POApproval__c where com_tcs_telecom__POStatus__c='Submitted' and com_tcs_telecom__PurchaseOrder__c=:recordId];
       com_tcs_telecom__PurchaseOrder__c polist=[select id,com_tcs_telecom__Quote__r.Account.Name,CreatedDate from com_tcs_telecom__PurchaseOrder__c where com_tcs_telecom__PO_Status__c='Submitted' and Id=:recordId];
       sendMail(sendername.Email,uname.Email,recordId,polist.com_tcs_telecom__Quote__r.Account.Name,polist.CreatedDate,uname.Name);
   }
   
     public static void sendMail(string sender,string receiver,string poId,String AccountName,DateTime CreateDate,String username){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        EmailTemplate et = [SELECT Id,Body,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName ='POApproval']; 
        String subject = et.Subject;
        System.debug('Inside Email'); 
        subject = subject.replace(' {!com_tcs_telecom__PurchaseOrder__c.Id}',poId);
         
       
        String plainBody = et.Body;
        plainBody = plainBody.replace('{!com_tcs_telecom__PurchaseOrder__c.OwnerFullName}', username); 
        plainBody = plainBody.replace('{!Account.Name}', AccountName);
        plainBody = plainBody.replace('{!com_tcs_telecom__PurchaseOrder__c.Link}', poId);
        plainBody = plainBody.replace('{!com_tcs_telecom__PurchaseOrder__c.CreatedDate}', String.valueOf(CreateDate));   
        String[] toAddresses = new String[] {receiver};
       // String[] toAddresses = new String[] {'nandini.pera@tcs.com'};
        mail.setTemplateId(et.Id);
        mail.setToAddresses(toAddresses); 
        mail.setSubject(subject);
       // mail.setHtmlBody(et.Body);
       // mail.setHtmlBody(htmlBody);
        mail.setPlainTextBody(plainBody); 

       // mail.setTargetObjectId(primaryContact);
        //mail.setWhatId(primaryAccount);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
         List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
       try {
       Messaging.sendEmail(allmsg,false);
       return;
        } catch (Exception e) {
    System.debug(e.getMessage());
        }
    }
  
    @AuraEnabled
    public static List<com_tcs_telecom__POApproval__c> getPOApprovalList(){
        List<com_tcs_telecom__POApproval__c> poAppr = new List<com_tcs_telecom__POApproval__c>();
        id uid=UserInfo.getUserId();
        System.debug('UserID..'+UserInfo.getUserId());
      
         poAppr= [select Id,com_tcs_telecom__PurchaseOrder__c,com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__POAutogenerate__c,com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Quote__r.account.id,
            com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Quote__r.account.Name,com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Quote__r.com_tcs_telecom__ServiceType__c,com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Recurring_Charges__c,
            com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Non_Recurring_Charges__c,com_tcs_telecom__PurchaseOrder__r.CurrencyIsoCode,
            com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Quote__r.id,com_tcs_telecom__POStatus__c,com_tcs_telecom__SubmittedDate__c,createdBy.Name,
                  com_tcs_telecom__PurchaseOrder__r.com_tcs_telecom__Quote__r.QuoteNumber from com_tcs_telecom__POApproval__c
                  where com_tcs_telecom__AssigneId__c =: uid and com_tcs_telecom__POStatus__c!='Saved'];
            return poAppr;        
    }                                             
    
    @AuraEnabled
    public static Object getPODetails(string poId){
        List<com_tcs_telecom__PurchaseOrder__c> poDetails = new List<com_tcs_telecom__PurchaseOrder__c>();       
        poDetails= [select com_tcs_telecom__POAutogenerate__c,
                    com_tcs_telecom__purchaseorderCheck__c,
                    com_tcs_telecom__Bill_Frequency__c,
                    com_tcs_telecom__purchaseorderBillingAccount__c,com_tcs_telecom__purchaseorderBillingAccount__r.Name,
                    com_tcs_telecom__BillingContact__c,com_tcs_telecom__BillingContact__r.Name,
                    com_tcs_telecom__Billing_Ref_No__c,
                    com_tcs_telecom__Contract_End_Date__c,
                    com_tcs_telecom__Contract_Period_months__c,
                    com_tcs_telecom__Contract_Start_Date__c,
                    com_tcs_telecom__Customer_PO_Date__c,createdBy.Name,
                    com_tcs_telecom__Customer_PO_Number__c,com_tcs_telecom__Quote__r.Opportunity.CurrencyIsoCode,
                    com_tcs_telecom__DeliveryContact__c,com_tcs_telecom__DeliveryContact__r.Name,
                    com_tcs_telecom__Expected_Delivery_Date__c,com_tcs_telecom__Quote__r.Name,com_tcs_telecom__Quote__r.Status,
                    com_tcs_telecom__Quote__r.Account.Name,com_tcs_telecom__Quote__r.Account.Industry,
                    com_tcs_telecom__Quote__r.Account.com_tcs_telecom__Customer_Segment__c,com_tcs_telecom__Quote__r.com_tcs_telecom__Legal_Entity__c,
                    com_tcs_telecom__Quote__r.Opportunity.Name,com_tcs_telecom__Quote__r.Opportunity.StageName,
                    com_tcs_telecom__Non_Recurring_Charges__c,
                    com_tcs_telecom__PO_Received_Date__c,
                    com_tcs_telecom__Recurring_Charges__c,
                    com_tcs_telecom__ShippingContact__c,com_tcs_telecom__ShippingContact__r.Name,
                    com_tcs_telecom__Tax_Exempt_Reason__c,
                    com_tcs_telecom__Taxation_Type__c                                                                 
                    from com_tcs_telecom__PurchaseOrder__c where
                    Id =:poId];
        System.debug('Podetails..'+poDetails);
            return poDetails; 
        
    } 
     @AuraEnabled
    public static Object getFileDetails(string poId){
     List<ContentDocument> DocumentList = new List<ContentDocument>();  
     Set<Id> documentIds = new Set<Id>();  
     List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:poId];  
     for(ContentDocumentLink cdLink:cdl){  
       documentIds.add(cdLink.ContentDocumentId);  
     }      
     DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
     return DocumentList;  // Return list of files on parent record
    }
   @AuraEnabled
    public static string updatepoorder(string poId,String comment,Boolean status,String recurringcharges,String Nonrecurringcharges){
        com_tcs_telecom__POApproval__c poAppr = [select Id,com_tcs_telecom__PurchaseOrder__c,com_tcs_telecom__ApprovedDate__c,com_tcs_telecom__SubmitterId__c,com_tcs_telecom__PurchaseOrder__r.Name,com_tcs_telecom__POStatus__c,com_tcs_telecom__AssigneId__c from com_tcs_telecom__POApproval__c 
                  where com_tcs_telecom__PurchaseOrder__c =: poId];
       com_tcs_telecom__PurchaseOrder__c poDetails= [select com_tcs_telecom__PO_Status__c,OwnerId,com_tcs_telecom__Non_Recurring_Charges__c,com_tcs_telecom__Recurring_Charges__c,com_tcs_telecom__Comments__c from com_tcs_telecom__PurchaseOrder__c where Id =:poId];
        if(status==true)
        {
        poAppr.com_tcs_telecom__POStatus__c='Approved';
        poAppr.com_tcs_telecom__ApprovedDate__c=System.now();    
        poDetails.com_tcs_telecom__PO_Status__c='Approved';
        poDetails.com_tcs_telecom__Comments__c=comment;   
        poDetails.com_tcs_telecom__Non_Recurring_Charges__c=Decimal.Valueof(recurringcharges);
        System.debug('rc charges..'+Decimal.Valueof(recurringcharges));
        poDetails.com_tcs_telecom__Recurring_Charges__c=Decimal.Valueof(Nonrecurringcharges);
        }
         else
           {
            poAppr.com_tcs_telecom__POStatus__c='Saved';
            poDetails.com_tcs_telecom__PO_Status__c='Saved';
            poDetails.OwnerId=poAppr.com_tcs_telecom__SubmitterId__c;
            poDetails.com_tcs_telecom__Comments__c=comment;    
           }
        update poAppr; 
        update poDetails;
        return poDetails.com_tcs_telecom__PO_Status__c;
    }  
    
   @AuraEnabled
    public static String updatepurchaseOrder(Map<string,string> purchaseOrderlist) {
        try{
            //added for PMD fix- apex crud violation by RIMI
            if(!Schema.sObjectType.PurchaseOrder__c.fields.Name.isAccessible()&&
               !Schema.sObjectType.PurchaseOrder__c.fields.Name.isCreateable())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Quote.fields.Name.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
            if(!Schema.sObjectType.Opportunity.fields.CurrencyIsoCode.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                
            }
           
            PurchaseOrder__c prcorder = [SELECT Id,Name,com_tcs_telecom__Customer_PO_Date__c,com_tcs_telecom__Comments__c,com_tcs_telecom__PO_Status__c,com_tcs_telecom__PO_Received_Date__c,com_tcs_telecom__purchaseorderBillingAccount__c,com_tcs_telecom__BillingContact__c,com_tcs_telecom__ShippingContact__c,com_tcs_telecom__DeliveryContact__c,com_tcs_telecom__Tax_Exempt_Reason__c,
                                         com_tcs_telecom__Billing_Ref_No__c,com_tcs_telecom__Customer_PO_Number__c FROM PurchaseOrder__c WHERE Id=:purchaseOrderlist.get('pcid')];
            com_tcs_telecom__POApproval__c poAppr = [select Id,com_tcs_telecom__PurchaseOrder__c,com_tcs_telecom__ApprovedDate__c,com_tcs_telecom__SubmitterId__c,com_tcs_telecom__PurchaseOrder__r.Name,com_tcs_telecom__POStatus__c,com_tcs_telecom__AssigneId__c from com_tcs_telecom__POApproval__c 
                  where com_tcs_telecom__PurchaseOrder__c =:purchaseOrderlist.get('pcid')];
            prcorder.com_tcs_telecom__Customer_PO_Date__c = Date.valueOf(purchaseOrderlist.get('CustomerPODate'));
            prcorder.com_tcs_telecom__PO_Received_Date__c = Date.valueOf(purchaseOrderlist.get('POReceivedDate'));
            prcorder.com_tcs_telecom__Tax_Exempt_Reason__c=purchaseOrderlist.get('TaxExemptReason');
            prcorder.com_tcs_telecom__Billing_Ref_No__c=purchaseOrderlist.get('BillingReferenceNo');
            prcorder.com_tcs_telecom__Customer_PO_Number__c=purchaseOrderlist.get('CustomerPONumber');
            prcorder.com_tcs_telecom__Comments__c=purchaseOrderlist.get('comments');
            prcorder.com_tcs_telecom__PO_Status__c=purchaseOrderlist.get('statuspicklist');
            if(purchaseOrderlist.get('statuspicklist')=='Approve')
                
            {
            System.debug('Inside Approve');
            poAppr.com_tcs_telecom__POStatus__c='Approved';
            poAppr.com_tcs_telecom__ApprovedDate__c=System.now();    
            prcorder.com_tcs_telecom__PO_Status__c='Approved';
            prcorder.com_tcs_telecom__Comments__c=purchaseOrderlist.get('comments'); 
            }
            else if(purchaseOrderlist.get('statuspicklist')=='Reject')
           {
            poAppr.com_tcs_telecom__POStatus__c='Saved';
            prcorder.com_tcs_telecom__PO_Status__c='Saved';
            prcorder.OwnerId=poAppr.com_tcs_telecom__SubmitterId__c;
            prcorder.com_tcs_telecom__Comments__c=purchaseOrderlist.get('comments');   
           }
            
            if(purchaseOrderlist.get('editaccount')=='true')
            {
              prcorder.com_tcs_telecom__purchaseorderBillingAccount__c=purchaseOrderlist.get('BillEntityAccount');   
            }
            if(purchaseOrderlist.get('editbillingcontact')=='true')
            {
            prcorder.com_tcs_telecom__BillingContact__c=purchaseOrderlist.get('billingContact'); 
            }
            if(purchaseOrderlist.get('editshippingcontact')=='true')
            {
            prcorder.com_tcs_telecom__ShippingContact__c=purchaseOrderlist.get('shippingContact');
            }
            if(purchaseOrderlist.get('editdeliverycontact')=='true')
            {
            prcorder.com_tcs_telecom__DeliveryContact__c=purchaseOrderlist.get('deliveryContact'); 
            }
            upsert prcorder;
            upsert poAppr;
            }
        catch(Exception e){
            System.debug('-Exception in Submissionofpoorder --' +e.getMessage()+e.getStackTraceString());
            return 'error';
        }
        return 'success';
    

	
    }
    */
}