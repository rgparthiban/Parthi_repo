public with sharing class FormMap {
    
   /* public class FormMapException extends Exception {}
   
    static DataSourceConfig__c configGlobal =DataSourceConfig__c.getvalues('ApiConfig');
    
    
    
    public static void setDataSourceConfig(DataSourceConfig__c orgDefaults){
        configGlobal = orgDefaults;
    }
    
    public static DataSourceConfig__c getDataSourceConfig()
    {
        return configGlobal;
    }
    
    
    
    
    @AuraEnabled
    public static decimal getQuoteCurrentVersion(String quoteId){
        if (!Schema.sObjectType.Quote.fields.CurrentVersion__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        else
        {
            Quote q = [SELECT CurrentVersion__c FROM Quote WHERE Id=:quoteId]; //need to add
            system.debug('CurrentVersion -->' + q.CurrentVersion__c);
            return q.CurrentVersion__c;
        }
    }
    

    @AuraEnabled
    public static Quote_Line_Item__c convertQuoteForBOB(String servicename,Map<String, Object> value,string quoteId) {
        System.debug('in  convertQuoteForBOB '+value);
        Quote_Line_Item__c quote = null;
        try{
            if(value != null) {
                quote = new Quote_Line_Item__c();
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.ServiceType__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.ServiceType__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-ServiceType__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.ServiceType__c = servicename;
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.Name.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Name.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Name not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.Name = (String)value.get('name');
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.Quantity__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Quantity__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Quantity__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if(String.valueOf(value.get('quantity')) != null)
                    {
                        quote.Quantity__c = Decimal.valueOf(String.valueOf(value.get('quantity')));   //added by jagriti for PMD
                    }
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.Currency__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Currency__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Currency__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.Currency__c = (String)value.get('currencyObj');
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.Price__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Price__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Price__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.Price__c = String.valueOf(value.get('price'));
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.Recurring_Charge__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Recurring_Charge__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Recurring_Charge__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.Recurring_Charge__c = String.valueOf(value.get('recurringCharge'));
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.Attribute__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Attribute__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Attribute__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.Attribute__c = (String)value.get('attribute');
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.Is_Package__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Is_Package__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Is_Package__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if (value.get('Is_Package')!= null){
                        quote.Is_Package__c = (boolean)value.get('Is_Package'); 
                    }
                    else if (value.get('isAddon') != null && (boolean)value.get('isAddon') == true){
                        quote.Is_Package__c = false;
                    }
                    else{
                        quote.Is_Package__c = false;
                    }
                }
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.ProductType__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.ProductType__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-ProductType__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.ProductType__c = (String)value.get('ProductType');
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.com_tcs_telecom__packagedPriced__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.com_tcs_telecom__packagedPriced__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-com_tcs_telecom__packagedPriced__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if (value.get('packagedPriced')!= null){
                        quote.com_tcs_telecom__packagedPriced__c = (boolean)value.get('packagedPriced'); 
                    }
                    else if (value.get('isAddon') != null && (boolean)value.get('isAddon') == true){
                        quote.com_tcs_telecom__packagedPriced__c = false;
                    }
                    else{
                        quote.com_tcs_telecom__packagedPriced__c = false;
                    }
                }
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.IsAddon__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.IsAddon__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-IsAddon__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if(value.get('isAddon') != null)
                    {
                        quote.IsAddon__c = (boolean)value.get('isAddon');    //added by jagriti for PMD
                    }
                    
                    else 
                    {
                        quote.IsAddon__c = false;   //added by jagriti for PMD
                    }
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.productOfferingId__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.productOfferingId__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-productOfferingId__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.productOfferingId__c = (String)value.get('productOfferingId');
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.parentproductofferingid__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.parentproductofferingid__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-parentproductofferingid__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.parentproductofferingid__c = (String)value.get('parentproductOfferingId');
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.Mandatory__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Mandatory__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Mandatory__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.Mandatory__c = (String)value.get('mandatory');    
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.Quote__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.Quote__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-Quote__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if (value.get('isAddon') != null && (boolean)value.get('isAddon') == true){
                        quote.Quote__c = quoteId;    
                    }
                    else{
                        quote.Quote__c = (String)value.get('quote');
                    }
                }
                
                
                System.debug('NEW INFO'+(String)value.get('rcBillingComponentType')+(String)value.get('rcPricingClassifier')+(String)value.get('rcProductOfferingPriceID'));
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcBillingComponentType__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcBillingComponentType__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcBillingComponentType__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.rcBillingComponentType__c = (String)value.get('rcBillingComponentType'); 
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcPricingClassifier__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcPricingClassifier__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcPricingClassifier__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.rcPricingClassifier__c = (String)value.get('rcPricingClassifier'); 
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcProductOfferingPriceID__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcProductOfferingPriceID__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcProductOfferingPriceID__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.rcProductOfferingPriceID__c =  (String)value.get('rcProductOfferingPriceID');
                }
                
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcdiscountType__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcdiscountType__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcdiscountType__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.rcdiscountType__c= (String)Value.get('rcdiscountType');
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcBillingComponentType__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcBillingComponentType__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcBillingComponentType__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.nrcBillingComponentType__c = (String)value.get('nrcBillingComponentType'); 
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcPricingClassifier__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcPricingClassifier__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcPricingClassifier__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.nrcPricingClassifier__c = (String)value.get('nrcPricingClassifier'); 
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcProductOfferingPriceID__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcProductOfferingPriceID__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcProductOfferingPriceID__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.nrcProductOfferingPriceID__c =  (String)value.get('nrcProductOfferingPriceID');
                }
                
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcdiscountType__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcdiscountType__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcdiscountType__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.nrcdiscountType__c= (String)value.get('nrcdiscountType');
                }
                
                // quote.rcnetprice__c= (Decimal)value.get('rcnetprice'); 
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcnetprice__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcnetprice__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcnetprice__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if(String.valueOf(value.get('rcnetprice'))!=null){
                        quote.rcnetprice__c=String.valueOf(value.get('rcnetprice')); 
                    }else{
                        quote.rcnetprice__c=String.valueOf(value.get('rcnetprice')); 
                    }
                }
                //quote.nrcnetprice__c= (Decimal)value.get('nrcnetprice');
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcnetprice__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcnetprice__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcnetprice__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if(String.valueOf(value.get('nrcnetprice'))!=null){
                        //quote.nrcnetprice__c= Decimal.valueof(String.valueOf(value.get('nrcnetprice'))); 
                        quote.nrcnetprice__c=String.valueOf(value.get('nrcnetprice')); 
                    }
                    else{
                        // quote.nrcnetprice__c= (Decimal)value.get('nrcnetprice');
                        quote.nrcnetprice__c= String.valueOf(value.get('nrcnetprice'));
                    }
                }
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcdiscountvalue__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcdiscountvalue__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcdiscountvalue__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.rcdiscountvalue__c= (String)value.get('rcdiscountedValue');
                }
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcdiscountvalue__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcdiscountvalue__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcdiscountvalue__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                	quote.nrcdiscountvalue__c= (String)value.get('nrcdiscountedValue'); 
                }
                // quote.rcvariableprice__c= (Decimal)value.get('rcvariableprice');
                 if(!Schema.sObjectType.Quote_Line_Item__c.fields.rcvariableprice__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.rcvariableprice__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-rcvariableprice__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                else{
                    if(String.valueOf(value.get('rcvariableprice'))!=null){
                        //quote.rcvariableprice__c= Decimal.valueof(String.valueOf(value.get('rcvariableprice')));
                        quote.rcvariableprice__c = Decimal.valueof(String.valueOf(value.get('rcvariableprice'))).setScale(2);
                        //changed decimal value from two decimals to four decimals
                        // quote.rcvariableprice__c = Decimal.valueof(String.valueOf(value.get('rcvariableprice'))).setScale(4);
                        System.debug('quotercvariablepricevalue in quotelineitem...'+quote.rcvariableprice__c);
                    }else{
                        quote.rcvariableprice__c= (Decimal)value.get('rcvariableprice');
                    }
                }
                
                //quote.nrcvariableprice__c= (Decimal)value.get('nrcvariableprice'); 
                if(!Schema.sObjectType.Quote_Line_Item__c.fields.nrcvariableprice__c.isCreateable() &&
                   !Schema.sObjectType.Quote_Line_Item__c.fields.nrcvariableprice__c.isUpdateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                	System.debug('quote-nrcvariableprice__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       return null;
                }
                   else{                      
                   
                       if(String.valueOf(value.get('nrcvariableprice'))!=null){
                           //quote.nrcvariableprice__c=  Decimal.valueof(String.valueOf(value.get('nrcvariableprice')));
                           quote.nrcvariableprice__c = Decimal.valueof(String.valueOf(value.get('nrcvariableprice'))).setScale(2);
                           //changed decimal value from two decimals to four decimals
                           //quote.nrcvariableprice__c = Decimal.valueof(String.valueOf(value.get('nrcvariableprice'))).setScale(4);
                           System.debug('quotenrcvariablepricevalue in quotelineitem...'+quote.nrcvariableprice__c);
                       }else{
                           quote.nrcvariableprice__c= (Decimal)value.get('nrcvariableprice'); 
                       }
                   }
                //added for approvalprocess
                OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
                String discLimitOnRC=config.rcpricediscLimit__c;
                System.debug('discLimitOnRC is.. '+discLimitOnRC);
                Decimal rcPriceAfterApplied = null;
                String substrDiscLimit = null;
                String rcDiscValEntered = null;
                if(quote.rcdiscountvalue__c!=null){
                    if(quote.rcdiscountvalue__c.contains('%')){
                        
                        System.debug('inside if..'+discLimitOnRC.substring(discLimitOnRC.length()-1));
                        //substrDiscLimit = discLimitOnRC.substring(0,discLimitOnRC.length()-1);
                        System.debug('substrDiscLimit if..'+substrDiscLimit + 'quote.rcdiscountvalue__c..-'+quote.rcdiscountvalue__c);
                        rcDiscValEntered = quote.rcdiscountvalue__c.substring(0,quote.rcdiscountvalue__c.length()-1);
                        
                        
                    }else{
                        system.debug('else block.. '+quote.rcdiscountvalue__c);
                        rcDiscValEntered=quote.rcdiscountvalue__c;
                        //
                    }
                    substrDiscLimit = discLimitOnRC.substring(0,discLimitOnRC.length()-1);
                    if(Decimal.valueOf(rcDiscValEntered) >= Decimal.valueOf(substrDiscLimit)){
                        if(!Schema.sObjectType.Quote_Line_Item__c.fields.com_tcs_telecom__status__c.isCreateable()
                          && !Schema.sObjectType.Quote_Line_Item__c.fields.com_tcs_telecom__status__c.isUpdateable()){
                        	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access-convertQuoteForBOB()'));
                			 System.debug('quote-com_tcs_telecom__status__c not updateable due to Insufficient Access in formmap.apx/convertQuoteForBOB()');
                       		 return null;
                              
                        }
                        else{
                            quote.com_tcs_telecom__status__c='InReview';
                        }
                    }
                    
                }
                
                
            }
        }
        catch(Exception e){
            System.debug('exception.. '+e.getStackTraceString());
            System.debug('exception.1. '+e.getMessage());
        }
        return quote;
    }
    
    @AuraEnabled
    public static Quote_Line_Item__c convertQuote(PackageController.QuoteLineItemPkgWrapper wrappedQuote) {
        System.debug('in  convertQuote '+wrappedQuote);
        Quote_Line_Item__c quote = null;
        if(wrappedQuote != null) {
            quote = new Quote_Line_Item__c();
            quote.Name = wrappedQuote.name;
            quote.Quantity__c = wrappedQuote.quantity;
            quote.Currency__c = wrappedQuote.currencyObj;
            quote.Price__c = wrappedQuote.price; 
            quote.Recurring_Charge__c = wrappedQuote.recurringCharge;
            quote.Attribute__c = wrappedQuote.attribute;
            quote.Is_Package__c = wrappedQuote.Is_Package;
            quote.productOfferingId__c = wrappedQuote.productOfferingId;
            quote.parentproductofferingid__c = wrappedQuote.parentproductOfferingId;
            quote.Mandatory__c = wrappedQuote.mandatory;
            quote.Quote__c = wrappedQuote.quote;
            quote.rcnetprice__c=wrappedQuote.rcnetprice;  
            quote.nrcnetprice__c=wrappedQuote.nrcnetprice;
            quote.rcdiscountvalue__c=wrappedQuote.rcdiscountedValue;
            quote.nrcdiscountvalue__c=wrappedQuote.nrcdiscountedValue; 
            quote.rcvariableprice__c=wrappedQuote.rcvariableprice;
            quote.nrcvariableprice__c= wrappedQuote.nrcvariableprice; 
            
        }
        return quote;
    }
    
    
    

    @AuraEnabled
    public static PackageController.QuoteLineItemPkgWrapper convertQuoteToWrapper(Quote_Line_Item__c quote) {
        System.debug('in  convertQuoteToWrapper '+quote);
        PackageController.QuoteLineItemPkgWrapper wrappedQuote = null;
        if(quote != null) {
            wrappedQuote = new PackageController.QuoteLineItemPkgWrapper();
            wrappedQuote.name = quote.Name;
            wrappedQuote.ProductType = quote.ProductType__c;
            wrappedQuote.quantity = quote.Quantity__c;
            wrappedQuote.currencyObj = quote.Currency__c;
            wrappedQuote.price = quote.Price__c;
            wrappedQuote.recurringCharge = quote.Recurring_Charge__c;
            wrappedQuote.attribute = quote.Attribute__c;
            wrappedQuote.Is_Package = quote.Is_Package__c;
            wrappedQuote.productOfferingId = quote.productOfferingId__c;
            wrappedQuote.parentproductOfferingId = quote.parentproductofferingid__c;
            wrappedQuote.mandatory = quote.Mandatory__c;
            wrappedQuote.quote = quote.Quote__c;
            wrappedQuote.isAddon = quote.IsAddon__c;
            wrappedQuote.rcnetprice=quote.rcnetprice__c;  
            wrappedQuote.nrcnetprice=quote.nrcnetprice__c;
            wrappedQuote.rcdiscountedValue=quote.rcdiscountvalue__c;
            wrappedQuote.nrcdiscountedValue=quote.nrcdiscountvalue__c; 
            wrappedQuote.rcvariableprice=quote.rcvariableprice__c;
            wrappedQuote.nrcvariableprice= quote.nrcvariableprice__c; 
            wrappedQuote.fromDB = true;
            
            System.debug('quote.rcProductOfferingPriceID__c...'+quote.com_tcs_telecom__rcProductOfferingPriceID__c);
           wrappedQuote.rcProductOfferingPriceID = quote.com_tcs_telecom__rcProductOfferingPriceID__c;
             wrappedQuote.rcPricingClassifier = quote.com_tcs_telecom__rcPricingClassifier__c;
             wrappedQuote.rcBillingComponentType = quote.com_tcs_telecom__rcBillingComponentType__c;
             
          	wrappedQuote.nrcProductOfferingPriceID= quote.com_tcs_telecom__nrcProductOfferingPriceID__c;
        	wrappedQuote.nrcPricingClassifier= quote.com_tcs_telecom__nrcPricingClassifier__c;
         	wrappedQuote.nrcBillingComponentType= quote.com_tcs_telecom__nrcBillingComponentType__c;
             wrappedQuote.packagedPriced=quote.com_tcs_telecom__packagedPriced__c;
            wrappedQuote.rcdiscountType=quote.com_tcs_telecom__rcdiscountType__c;
            wrappedQuote.nrcdiscountType=quote.com_tcs_telecom__nrcdiscountType__c;
            
            
            
        }
        return wrappedQuote;
    }
    

    @AuraEnabled
    public static String insertBOBProducts(String servicename,String packageName, List<Object> valList, Id parentId,String quoteId, 
                                           boolean recursiveFlag, String attributes,decimal quoteVersion, List<Quote_Line_Item__c> pkgListQLIs) {
        // createNewVersion = false;                     
        Id packageId;
        String quoteservicename = servicename;
        String quoteLineId=null;
        // decimal quoteVersion = 1.0;
        System.debug('packageName '+packageName+' valList '+JSON.serialize(valList)+'attributes'+attributes);
        System.debug('quoteservicename-->'+quoteservicename+' quoteId-->'+quoteId);
        String srvcCatg=QuoteController.getSrvcNameBySrvcValue(quoteservicename,quoteId);
        try{
            // PMD Check if the user has read access on the Opportunity.ExpectedRevenue field
            if (!Schema.sObjectType.QuoteLine__c.fields.Id.isAccessible()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                return null;
            }
          else{
            QuoteLine__c quoteLineObj = [SELECT Id from QuoteLine__c WHERE Quote_Id__c=:quoteId AND Service_Type__c=:srvcCatg AND Site_Id__c=:null];
            if(quoteLineObj!=null){
                quoteLineId=quoteLineObj.Id;
                System.debug('quoteLineId==='+quoteLineId);
            	}
            
           for(Integer i = 0; i < valList.size(); i++) {            
            Map<String,Object> value = (Map<String,Object>)valList[i];
            System.debug('value '+value);
            if((String)value.get('name') != null){
                    if(packageName.equals((String)value.get('name'))) {
                    System.debug('Package product found');
                    // Jagriti added for PMD                  
                    
                        System.debug('inside inserting package');
                        Quote_Line_Item__c pkg = convertQuoteForBOB(quoteservicename,value,quoteId);
                        
                         if(!Schema.sObjectType.Quote_Line_Item__c.fields.quoteLineId__c.isCreateable() &&
                            !Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isCreateable() &&
                        !Schema.sObjectType.Quote_Line_Item__c.fields.QuoteVersion__c.isCreateable()                            
                          )
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access '));
                                System.debug('Quote_Line_Item__c not inserted due to Insufficient Access in Formmap.apx/QLinesData()');
                                return null;
                            }
                        else{
                            pkg.Parent_Item__c = parentId;
                            pkg.QuoteVersion__c = quoteVersion;
                            pkg.quoteLineId__c= quoteLineId;
                        	System.debug('isPackage--'+pkg.Is_Package__c+'  prodId---'+pkg.productOfferingId__c);
                        	insert pkg; //need to remove for SQL limit exception
                        }
                        pkgListQLIs.add(pkg);
                        packageId = pkg.Id;
                        System.debug('packageId '+packageId+'pkg.productOfferingId__c'+pkg.productOfferingId__c);
                        QLinesData(valList,packageName,quoteservicename,quoteId,packageId,quoteLineId,quoteVersion,
                                 pkgListQLIs,attributes);
                   
                } 
            }
        	}
          
			}   
            
        }
        catch(Exception e){
            System.debug('exception in quote line'+e.getStackTraceString());
        }
        
       return null;
       
        //// insert childListQLIs;
    }
    
    public static void QLinesData(List<Object> valList,String packageName,String quoteservicename,String quoteId,
                                 Id packageId,String quoteLineId,decimal quoteVersion,List<Quote_Line_Item__c> pkgListQLIs,
                                 String attributes)
    {
        String servicename = quoteservicename;
        for(Integer i = 0; i < valList.size(); i++) {           
            Map<String,Object> value = (Map<String,Object>)valList[i];
            System.debug('value1 '+value);
            
            if((String)value.get('name') != null){
                if(!packageName.equals((String)value.get('name'))) {                    
                    System.debug('product found');
                    // Jagriti added for PMD
                    if (!Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isCreateable() &&
                        !Schema.sObjectType.Quote_Line_Item__c.fields.QuoteVersion__c.isCreateable()){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                            
                        }
                    //ends
                    else{
                        Quote_Line_Item__c child = convertQuoteForBOB(quoteservicename,value,quoteId);                      
                           
                       
                        if(child.Mandatory__c!='OptIn') {
                             if(!Schema.sObjectType.Quote_Line_Item__c.fields.Parent_Item__c.isCreateable()
                           		&& !Schema.sObjectType.Quote_Line_Item__c.fields.quoteLineId__c.isCreateable()
                                && !Schema.sObjectType.Quote_Line_Item__c.fields.QuoteVersion__c.isCreateable()
                          )
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access '));
                                System.debug('Quote_Line_Item__c not inserted due to Insufficient Access in Formmap.apx/QLinesData()');
                            }
                        else{
                            child.Parent_Item__c = packageId;
                            child.quoteLineId__c= quoteLineId;
                            child.QuoteVersion__c = quoteVersion;
                        } 
                            
                            ////  childListQLIs.add(child);
                            Id childId;
                            insert child;//need to remove - commented by Gayathri for SQL limit exception  
                            
                            pkgListQLIs.add(child);
                            childId = child.Id;
                            System.debug('child'+child+'prodSpec'+child.productOfferingId__c);
                            List<AttributeMapConverter> attributeMapp = new List<AttributeMapConverter>();
                            if(attributes != null) {
                                attributeMapp =   (List<AttributeMapConverter>)System.JSON.deserialize(attributes,List<AttributeMapConverter>.class);
                                List<Attribute__c> attrbList = new List<Attribute__c>();
                                for(AttributeMapConverter mapConverterObj : attributeMapp)
                                {
                                    String atrKey = mapConverterObj.key;
                                    String cmpStr = servicename+packageName+child.productOfferingId__c; 
                                    System.debug('####atrKey####'+atrKey+'cmpStr'+cmpStr);
                                    if(atrKey.contains(cmpStr)){  //insert only attributes of products which are inserted
                                        system.debug('condition matched KEY'+mapConverterObj.key+'value'+mapConverterObj.value);
                                        List<AttributeMapConverter.ValueList> valuList = (List<AttributeMapConverter.ValueList>)mapConverterObj.value;
                                        if(valuList != null) {
                                            system.debug('valuList != null'+valuList);
                                            for(AttributeMapConverter.ValueList v : valuList) {
                                                system.debug('b4 fetch');
                                                // PMD Check if the user has read access on the Opportunity.ExpectedRevenue field
                                                if (!Schema.sObjectType.Attribute__c.fields.Name.isAccessible()){
                                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                                                    
                                                }
                                                //
                                                Attribute__c[] existAttributesFromDB = [SELECT Name,Attribute_value__c FROM Attribute__c  WHERE  
                                                                                        ProductSpec__c=:mapConverterObj.key and QuoteId__c =:quoteId and Name=:v.name and QuoteVersion__c = :quoteVersion];
                                                System.debug('existAttributesFromDB is.. '+existAttributesFromDB);
                                                if(existAttributesFromDB!=null && !existAttributesFromDB.isEmpty()){
                                                    //added for PMD fix- apex crud violation by RIMI
                                                    if(!Schema.sObjectType.Attribute__c.fields.Attribute_value__c.isCreateable() &&
                                                       !Schema.sObjectType.Attribute__c.fields.Attribute_value__c.isUpdateable())
                                                    {
                                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                                                        
                                                    }
                                                    else
                                                    {
                                                        existAttributesFromDB[0].Attribute_value__c = v.value;
                                                        upsert existAttributesFromDB;
                                                        System.debug('attrs updated');
                                                    }
                                                    
                                                    
                                                } else {
                                                    Attribute__c attr = new Attribute__c();
                                                    if(!Schema.sObjectType.Attribute__c.fields.QuoteId__c.isCreateable()
                                                       && !Schema.sObjectType.Attribute__c.fields.ProductSpec__c.isCreateable()
                                                       && !Schema.sObjectType.Attribute__c.fields.Name.isCreateable()
                                                       && !Schema.sObjectType.Attribute__c.fields.Attribute_value__c.isCreateable()
                                                       && !Schema.sObjectType.Attribute__c.fields.QuoteVersion__c.isCreateable()
                                                       && !Schema.sObjectType.Attribute__c.fields.Quote__c.isCreateable()
                                                       && !Schema.sObjectType.Attribute__c.fields.Quote_LineItem__c.isCreateable()){
                                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access -Attribute__c'));
                                                           System.debug('Attribute__c not inserted due to Insufficient Access');
                                                           
                                                       }
                                                    else{
                                                         attr.QuoteId__c =  quoteId;
                                                    	 attr.ProductSpec__c = mapConverterObj.key; //serviceName+PackageName+productSpec
                                                    	 attr.Name = v.name;
                                                    	 attr.Attribute_value__c = v.value;
                                                    	 attr.QuoteVersion__c = quoteVersion;
                                                    	 attr.Quote__c =  quoteId;
                                                    	 attr.Quote_LineItem__c = childId;
                                                    	 System.debug('attr'+attr);
                                                    	 insert(attr); //need to add
                                                    	 System.debug('attrs inserted');
                                                    }
                                                   
                                                }
                                                
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                }
            } else {
                System.debug('Bundle product found');
                for(String bundleName : value.keySet()){                    
                    List<Object> childBundleData=(List<Object>)value.get(bundleName);
                    System.debug('childBundleData product found' +childBundleData);
                    Map<String,Object> childBundleInParentLevel = (Map<String,Object>)childBundleData.get(0);
                    System.debug('childBundleInParentLevel product found' +childBundleInParentLevel);
                    System.debug('childBundleInParentLevel mandatory status..' +childBundleInParentLevel.get('mandatory'));
                    if(childBundleInParentLevel.get('mandatory')!='OptIn'){    
                        insertBOBProducts(quoteservicename,bundleName, (List<Object>)value.get(bundleName), packageId,quoteId,true,attributes,quoteVersion,pkgListQLIs);
                    }
                }
            }
        }
    }
    
    
    
  
    @AuraEnabled
    public static String persistMultipleQuoteLinesBOB(String cartItemsMap, String quoteId,String attributes,boolean createNewVersion) {
        
        createNewVersion = false;                     
        
        decimal quoteVersion = 1.0;
        System.debug('createNewVersion'+createNewVersion);
        System.debug('cartitemsmap'+cartItemsMap);
        if('Approved'.equals(PackageController.checkQuoteStatus(quoteId))) 
        {
            createNewVersion = true;   //added by jagriti for PMD 
        }  
        List<Quote_Line_Item__c> quoteLineList = [SELECT Name,QuoteVersion__c FROM Quote_Line_Item__c WHERE  Quote__c=:quoteID  order by QuoteVersion__c desc limit 1];
        if(quoteLineList.size()>0) {
            Quote_Line_Item__c qli = quoteLineList.get(0);
            if(createNewVersion) 
            { quoteVersion  = qli.QuoteVersion__c + 0.1;  //added by jagriti for PMD
            }
            
            else 
            {
                quoteVersion  = qli.QuoteVersion__c;  //added by jagriti for PMD
            }
            
        }
        // PMD Check if the user has read access on the field
        if (!Schema.sObjectType.Attribute__c.fields.Name.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null; 
        }
        //
        Attribute__c[] delAttr =   [SELECT Name FROM Attribute__c WHERE QuoteId__c=:quoteId and QuoteVersion__c = :quoteVersion]; 
        //need to add
        System.debug('delAttr in persistQuoteLinesBOB:'+delAttr);  
        //added for PMD fix- apex crud violation by RIMI
        if (!Attribute__c.sObjectType.getDescribe().isDeletable()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null; 
        }
        for(Attribute__c itemTobeDeleted : delAttr)
        {
            delete itemTobeDeleted;
        } 
        
        string result;
        try { 
            deleteExistingQliFromDb(quoteId,quoteVersion);//added
            List<Object> productLineItemWrapperMapList = (List<Object>)JSON.deserializeUntyped(cartItemsMap);
            System.debug('cartItemsMap size '+productLineItemWrapperMapList.size());
            for(Integer j=0;j<productLineItemWrapperMapList.size();j++) {
                Map<String, Object> item = (Map<String, Object>)productLineItemWrapperMapList[j];                
                System.debug('persistMultipleQuote Key '+(String)item.get('key')); 
                System.debug('persistMultipleQuote value '+String.valueof(item.get('value')));   
                result = persistQuoteLinesBOB((String)item.get('key'), (List<Object>)item.get('value'),quoteId,attributes,createNewVersion,quoteVersion);
                //added for PMD fix- apex crud violation by RIMI
                if (!Schema.sObjectType.QUOTE.fields.QuoteType__c.isAccessible()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                    return null; 
                }
                Quote quoteObj=[SELECT QuoteType__c FROM QUOTE WHERE Id=:quoteId];
                System.debug('quoteType---'+quoteObj.QuoteType__c);
                if(quoteObj.QuoteType__c=='Agreement')
                {
                    updateAgreementDetails(quoteId,quoteVersion);
                }
                
            }
            System.debug('quoteId'+quoteId+'quoteVersion'+quoteVersion+'createNewVersion'+createNewVersion+'cartItemsMap'+cartItemsMap);
            
        } catch(Exception e) {
            System.debug('Error in persisting quote'+e.getMessage());
            return 'Error';
        }
        result = ''+quoteVersion;
        return result;
    }
    
  
    public static String updateAgreementDetails(String quoteId,decimal quoteVersion){
        System.debug('inside updateAgreementDetails');
        try{
            //added for PMD fix- apex crud violation by RIMI
            if (!Schema.sObjectType.Agreement__c.fields.Quote_Id__c.isCreateable() &&
                !Schema.sObjectType.Agreement__c.fields.Quote_Version__c.isCreateable()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                    return null;
                }else{
                     Agreement__c agrmnt=new Agreement__c(); 
            		 agrmnt.Quote_Id__c = quoteId;
            		agrmnt.Quote_Version__c = quoteVersion;
            		insert agrmnt;
                }
           
        }
        catch(Exception e){
            System.debug('-Exception in updateAgreement --' +e.getMessage()+e.getStackTraceString());
        }
        return null;
    }
    
    
 
    @AuraEnabled
    public static String updatePriceForSubmit(String cartItemsMap, String quoteId,String quoteVersion,boolean createNewVersion)
    {
        try {        
            createNewVersion = false;                     
            
            
            System.debug('createNewVersion'+createNewVersion);
            if('Approved'.equals(PackageController.checkQuoteStatus(quoteId))) 
            {
                createNewVersion = true;    //added by jagriti for PMD
            }   
            
            //added to dispaly price in header cart
            Map<String, String> priceMap = null;
            priceMap = PackageController.getPriceCalculationRevampForBOB(cartItemsMap); 
            System.debug('priceMap in formmap .. '+priceMap);
            if(priceMap!=null && priceMap.size() > 0){
                
                system.debug('priceMap'+priceMap+'quoteId'+'decimal.valueOf(quoteVersion)'+decimal.valueOf(quoteVersion)+'createNewVersion'+createNewVersion);
                getSalesFrameBasedOnQuote(quoteId,decimal.valueOf(quoteVersion));
                persistPriceDetailForQuote(priceMap, quoteId,decimal.valueOf(quoteVersion),createNewVersion);
                System.debug('before persistPriceVersion');
                persistPriceVersion(priceMap, quoteId,decimal.valueOf(quoteVersion));   
            }
            return 'success';
        }
        catch(Exception e) {
            system.debug('Exception occured while updating price'+e.getMessage()+e.getStackTraceString());
            return 'error';
            
        }
        //added
        
        
    }
    
   
    public static void getSalesFrameBasedOnQuote(String quoteId,decimal quoteVersion){
       
        /// DataSourceConfig__c config =DataSourceConfig__c.getvalues('ApiConfig');
        DataSourceConfig__c config = getDataSourceConfig();
        String approvalController=config.Approval_API_Name__c;
        System.debug('approvalController--'+approvalController);
        Type t = Type.forName(approvalController);
        QuotePriceApprovalInterface approvalObj = (QuotePriceApprovalInterface)t.newInstance();
        approvalObj.persistSalesFrame(quoteId,quoteVersion);
        
    }
    
    @AuraEnabled
    public static String persistQuoteLinesBOB(String servicename,List<Object> cartItemsMap, String quoteId,String attributes,boolean createNewVersion,decimal quoteVersion) {
        System.debug('Inside method persistQuoteLinesBOB in FormMap '+cartItemsMap);
        Map<String, String> priceMap = null;
        try {
            string objcartitem = string.valueof(cartItemsMap);
            System.debug('priceMap12 '+priceMap);
        } catch(Exception e) {
            System.debug('Error in revamp price for BOB');
        }     
        try {
            List<Object> productLineItemWrapperMapList = cartItemsMap;
            System.debug('cartItemsMap size '+productLineItemWrapperMapList.size());
            //deleteExistingQliFromDb(quoteId,quoteVersion);
            List<Quote_Line_Item__c> pkgListQLIs = new List<Quote_Line_Item__c>();  
            for(Integer j=0;j<productLineItemWrapperMapList.size();j++) {
                boolean recursiveFlag=false;
                Map<String, Object> item = (Map<String, Object>)productLineItemWrapperMapList[j];
                System.debug('j '+j+' item '+item);
                
                insertBOBProducts(servicename,(String)item.get('key'), (List<Object>)item.get('value'), null,quoteId,recursiveFlag,attributes,quoteVersion,pkgListQLIs);
            }
            //Need to be added. Gayathri - SQL Limit Exception
            // if(pkgListQLIs.size()>0) {    //added by jagriti for PMD
            ////insert pkgListQLIs;
            // mapQuoteLineToOpportunityProduct(pkgListQLIs, quoteId, quoteVersion);
            // }
        } catch(Exception e) {
            System.debug('Error in persistQuoteLinesBOB'+e.getMessage());
            return 'Error';
        }
        return 'Success';
    }
    

    public static void deleteExistingQliFromDb(String quoteId,decimal quoteVersion){
		Map<String, Schema.SObjectField> objfieldMap = Quote_Line_Item__c.sObjectType.getDescribe().fields.getMap();
        String strfieldName = getAllObjectFields(objfieldMap);
        System.debug('strfieldName for quoteLineItem--------'+strfieldName);
        // Build a Dynamic Query String.
        List<Quote_Line_Item__c> quoteLineItemList = Database.query('select ' + strfieldName + ' from Quote_Line_Item__c where Quote__c=:quoteId and QuoteVersion__c=:quoteVersion');        
    	if (!Quote_Line_Item__c.sObjectType.getDescribe().isDeletable()){
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            		
        			}
        delete quoteLineItemList;
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
    public static void persistPriceVersion(Map<String, String> priceMap, String quoteId,decimal quoteVersion) {
        System.debug('Inside persistPriceVersion');
        try {
            if(quoteId != null) {
                Decimal nRC = 0, rC = 0;
                System.debug(priceMap + ' persistPriceVersion ::'+quoteId+'quoteVersion'+quoteVersion);
                // PMD Check if the user has read access on the Opportunity.ExpectedRevenue field
                if (!Schema.sObjectType.Version__c.fields.VRecurring_Charge__c.isAccessible()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                    //return null; 
                }
                else
                {
                    //
                    List<Version__c> versionList = [SELECT Id,VRecurring_Charge__c,VPrice__c FROM Version__c WHERE VQuote__c=:quoteId and VQuoteVersion__c=:quoteVersion];
                    System.debug('versionList'+versionList);
                    if(versionList.size()>0) {
                        System.debug('in if');
                        // jagriti added for PMD
                        //  if (Schema.sObjectType.Version__c.fields.VPrice__c.isUpdateable()){
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                        //ends
                        
                        Version__c version = versionList.get(0);
                        if(priceMap != null) {
                            if(priceMap.get('NRC') != null)
                            {
                                version.VPrice__c = Decimal.valueof(priceMap.get('NRC'));   //added by jagriti for PMD
                                
                            }
                            
                            if(priceMap.get('RC') != null)
                            {
                                version.VRecurring_Charge__c = Decimal.valueof(priceMap.get('RC'));  //added by jagriti for PMD
                            }
                            
                            
                        }
                        //added for PMD fix- apex crud violation by RIMI
                        if (!Schema.sObjectType.Version__c.fields.VPrice__c.isCreateable() && !Schema.sObjectType.Version__c.fields.VPrice__c.isUpdateable()){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                            //return null;
                        }
                        else{
                            //
                            upsert version; //need to add
                            system.debug('Version updated'+version);
                        }
                        // }
                    }   
                    else {
                        System.debug('in else');
                        Version__c newVersion = new Version__c();
                        newVersion.VQuoteVersion__c = quoteVersion;
                        newVersion.VQuote__c = quoteId;
                        if(priceMap != null) {
                            if(priceMap.get('NRC') != null)
                            {
                                newVersion.VPrice__c = Decimal.valueof(priceMap.get('NRC'));  //added by jagriti for PMD
                            }
                            
                            if(priceMap.get('RC') != null)
                            {
                                newVersion.VRecurring_Charge__c = Decimal.valueof(priceMap.get('RC'));  //added by jagriti for PMD
                            }
                            
                        }
                        insert newVersion;
                        system.debug('Version inserted'+newVersion);
                        
                    }
                }
                
            }
        } catch(Exception e) {
            throw new FormMapException(e);
        }
    }
    
    @AuraEnabled
    public static void persistPriceDetailForQuote(Map<String, String> priceMap, String quoteId,decimal quoteVersion,boolean createNewVersion) {
        try {
            Decimal grandTotal;
            if(quoteId != null) {
                System.debug(priceMap + ' quoteId34 ::'+quoteId);
                // PMD Check if the user has read access on the Opportunity.ExpectedRevenue field
                if (!Schema.sObjectType.Quote.fields.Recurring_Charges__c.isAccessible()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                    //return null; 
                }
                else
                {
                    Quote quote = [SELECT Id,Recurring_Charges__c,Non_Recurring_Charges__c FROM Quote WHERE Id=:quoteId];
                    Decimal nRC = 0, rC = 0;
                    if (!Schema.sObjectType.Quote.fields.Recurring_Charges__c.isCreateable() &&
                        !Schema.sObjectType.Quote.fields.Recurring_Charges__c.isUpdateable()){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                            
                        }
                    quote.CurrentVersion__c = quoteVersion;
                    if(createNewVersion) 
                    {
                        quote.Status = 'Draft';  //added by jagriti for PMD  
                    }                
                    if(priceMap != null) {
                        if(priceMap.get('NRC') != null)
                        { 
                            //quote.Non_Recurring_Charges__c = Decimal.valueof(priceMap.get('NRC'));
                            quote.Non_Recurring_Charges__c = Decimal.valueof(priceMap.get('NRC')).setScale(2);
                            //changed decimal value from two decimals to four decimals
                           // quote.Non_Recurring_Charges__c = Decimal.valueof(priceMap.get('NRC')).setScale(4);
                            System.debug('DecimalpriceMapNOnrecurringcharges..'+Decimal.valueof(priceMap.get('NRC')));
                            System.debug('DecimalpriceMapNOnrecurringcharges..'+quote.Non_Recurring_Charges__c);
                        }
                        if(priceMap.get('RC') != null){
                            //quote.Recurring_Charges__c = Decimal.valueof(priceMap.get('RC'));
                            quote.Recurring_Charges__c = Decimal.valueof(priceMap.get('RC')).setScale(2);
                            //changed decimal value from two decimals to four decimals
                            //quote.Recurring_Charges__c = Decimal.valueof(priceMap.get('RC')).setScale(4);
                            System.debug('DecimalpriceMaprecurringcharges..'+quote.Recurring_Charges__c);
                        }
                        //quote.Quote_Grand_Total__c=Decimal.valueof(priceMap.get('NRC'))+Decimal.valueof(priceMap.get('RC'));
                        quote.Quote_Grand_Total__c=Decimal.valueof(priceMap.get('NRC')).setScale(2)+Decimal.valueof(priceMap.get('RC')).setScale(2);
                        //changed decimal value from two decimals to four decimals
                        //quote.Quote_Grand_Total__c=Decimal.valueof(priceMap.get('NRC')).setScale(4)+Decimal.valueof(priceMap.get('RC')).setScale(4);
                        //grandTotal=quote.Quote_Grand_Total__c;
                        grandTotal=quote.Quote_Grand_Total__c.setScale(2);
                        //grandTotal=quote.Quote_Grand_Total__c.setScale(4);
                        
                    }
                    //quote.Phone='9840514538';
                    upsert quote; // need to add
                    Quote quote1 = [SELECT Id,Recurring_Charges__c,Non_Recurring_Charges__c FROM Quote WHERE Id=:quoteId]; //need to add
                    system.debug('quote1'+quote1);
                    System.debug('quoterecurringcharges..'+quote1.Recurring_Charges__c);
                    
                }
            }
        }catch(Exception e) {
            throw new FormMapException(e);
        }
    }
    
    
    
    
    private Static void createQuoteLineItemForHeaderBundle(ProductOffering bundleProdOfferfromPc,
                                                           String defStateForBundleHeader,boolean isPkg,
                                                           List<Object> childBundleProductsList,String quoteId,String firstLevelparentProdOfferId,
                                                           Decimal pkgQunatity)
    {
        System.debug('inside createQuoteLineItemForHeaderBundle ..');
        PackageController.QuoteLineItemPkgWrapper childQuoteItemWrapper = new PackageController.QuoteLineItemPkgWrapper();
        childQuoteItemWrapper.Name = bundleProdOfferfromPc.name; 
        childQuoteItemWrapper.Is_Package = isPkg;
        childQuoteItemWrapper.productOfferingId = bundleProdOfferfromPc.productOfferingId;
        childQuoteItemWrapper.quote = quoteId;
        childQuoteItemWrapper.parentproductOfferingId =firstLevelparentProdOfferId;
        childQuoteItemWrapper.mandatory=defStateForBundleHeader;
        childQuoteItemWrapper.quantity=pkgQunatity;
        childQuoteItemWrapper.mandatory ='OptIn'; 
        childBundleProductsList.add(childQuoteItemWrapper);
    }
    
    private Static void createQuoteLineItemForLeaf(ProductOffering.cls_productSpec prodSpec,
                                                   boolean isPkg,String parentProdOfferid,
                                                   List<Object> childBundleProductsList,String quoteId,
                                                   List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts,
                                                   Decimal pkgQunatity)
    {
        System.debug('inside createQuoteLineItemForLeaf ..');
        PackageController.QuoteLineItemPkgWrapper childQuoteItemWrapper = new PackageController.QuoteLineItemPkgWrapper();
        childQuoteItemWrapper.Name = prodSpec.name; 
        if(!isPkg){
            PackageController.getProductPriceOfAOffer(prodSpec.productSpecID, bundlePriceForSelectedProducts, 
                                                      childQuoteItemWrapper,pkgQunatity);
        }
        childQuoteItemWrapper.Is_Package = isPkg;
        childQuoteItemWrapper.productOfferingId = prodSpec.productSpecID;
        childQuoteItemWrapper.quote = quoteId;
        childQuoteItemWrapper.parentproductOfferingId =parentProdOfferid;
        childQuoteItemWrapper.mandatory=prodSpec.defaultState;
        childQuoteItemWrapper.ProductType='';
        if(prodSpec.defaultState!='Mandatory'){
            childQuoteItemWrapper.mandatory ='OptIn'; 
        }
        System.debug('childQuoteItemWrapper--'+JSON.serialize(childQuoteItemWrapper));
        
        if(childBundleProductsList!=null){
            System.debug('inside childBundleProductsList not null'+JSON.serialize(childBundleProductsList));
            childBundleProductsList.add(childQuoteItemWrapper);
            System.debug('childBundleProductsList---'+JSON.serialize(childBundleProductsList));
        }
        
    }
    
    private Static void getPriceForAllChildLeafProducts(String serviceType,List<ProductOffering> productOfferingListforChildLeafProds,
                                                        List<Object> listOfChildProducts,String quoteId,
                                                        String firstLevelparentProdOfferId,Decimal pkgQunatity,
                                                        Map<String,List<Object>> chlidbundleProdNames,String firstLevelParentName,
                                                        boolean skipWithDBTogetExistingList)
        
        
    {
        System.debug('getPriceForAllChildLeafProducts....firstLevelparentProdOfferId.. '+firstLevelparentProdOfferId+
                     'firstLevelParentName .. '+firstLevelParentName);
        
        List<String> listTogetPrice = new List<String>();
        //Map<String,List<Object>> bundleChildProductsMap = null;
        List<Object> alreadyPersistedLeafProds = new List<Object>();
        List<Object> leafProdList = chlidbundleProdNames.get(firstLevelparentProdOfferId);
        for(ProductOffering eachLeafProdFromPc : productOfferingListforChildLeafProds)
        {
            
            System.debug('leafProdList .. '+leafProdList + 'eachLeafProdFromPc.productOfferingId' +eachLeafProdFromPc.productOfferingId
                         +'eachLeafProdFromPc.productType.. '+eachLeafProdFromPc.productType);
            if(eachLeafProdFromPc.productType !='BUNDLE'){
                if(leafProdList!=null && !leafProdList.contains(eachLeafProdFromPc.productOfferingId)){
                    listTogetPrice.add(eachLeafProdFromPc.productOfferingId);
                }  
            }else if(eachLeafProdFromPc.productType =='BUNDLE'){
                
                List<Object> alreadyPersistedLeafProdsNew = null;
                System.debug('firstLevelParentName is at .. '+firstLevelParentName);
                Map<String,List<Object>> bundleChildProductsMap = new Map<String,List<Object>>();
                alreadyPersistedLeafProdsNew=getExistBundleListFromDB(listOfChildProducts,eachLeafProdFromPc.name,bundleChildProductsMap,
                                                                      alreadyPersistedLeafProdsNew);
                System.debug('eachLeafProdFromPc.name is at .. '+eachLeafProdFromPc.name);
                System.debug('alreadyPersistedLeafProdsNew >>>   is at .. '+alreadyPersistedLeafProdsNew);
                if(alreadyPersistedLeafProdsNew!=null){
                    constructRemChildProductsFromPc(serviceType,chlidbundleProdNames,alreadyPersistedLeafProdsNew,eachLeafProdFromPc,
                                                    quoteId,pkgQunatity,skipWithDBTogetExistingList);
                }else{
                    List<String> prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle = new List<String>();
                    //String parentproductName=eachLeafProdFromPc.name;
                    constructBundleAndTheirProducts(serviceType,listOfChildProducts,eachLeafProdFromPc,quoteId,pkgQunatity,
                                                    prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle,skipWithDBTogetExistingList,
                                                    firstLevelparentProdOfferId,eachLeafProdFromPc.productType);
                }
                
            }
            
            
        }
        List<String> prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle = new List<String>();
        addPriceAndPRoducts(serviceType,productOfferingListforChildLeafProds,firstLevelparentProdOfferId,listTogetPrice,
                            listOfChildProducts,quoteId,pkgQunatity,leafProdList,prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle,
                            firstLevelParentName,skipWithDBTogetExistingList);  
        
    }
    
    private Static  List<Object> iteratationToGetBundle(Object childProduct,
                                                        Map<String,List<Object>> bundleChildProductsMap,String firstLevelParentName,
                                                        List<Object> alreadyPersistedLeafProds)
    {
 //commented for PMD fix
        System.debug('childProduct---'+JSON.serialize(childProduct));
        if(!(childProduct instanceof PackageController.QuoteLineItemPkgWrapper))
        {
            System.debug('insid else..');
            
            bundleChildProductsMap = ( Map<String,List<Object>>)childProduct;
            System.debug('insid else.bundleChildProductsMap.'+bundleChildProductsMap);
            if(bundleChildProductsMap!=null){
                Set<String> keys = bundleChildProductsMap.keySet(); 
                for(String key : keys){
                    System.debug('key in .getExistBundleListFromDB.' +key + 'firstLevelParentName.. '+firstLevelParentName);
                    if(key == firstLevelParentName)
                    {
                        System.debug('inside if.....'+key + '-' +firstLevelParentName);
                        alreadyPersistedLeafProds = bundleChildProductsMap.get(firstLevelParentName);
                        System.debug('key in .before break.'+alreadyPersistedLeafProds);
                        break; 
                        
                    }else{
                        List<Object> listOfBundles = bundleChildProductsMap.get(key);
                        alreadyPersistedLeafProds=getExistBundleListFromDB(listOfBundles,firstLevelParentName,bundleChildProductsMap,
                                                                           alreadyPersistedLeafProds);
                    }
                }
            }
            
            
        }
        System.debug('alreadyPersistedLeafProds .>bef return> >. '+alreadyPersistedLeafProds);
        return alreadyPersistedLeafProds;
    } 
    
    private Static List<Object> getExistBundleListFromDB(List<Object> listOfChildProducts,
                                                         String firstLevelParentName,Map<String,List<Object>> bundleChildProductsMap,List<Object> alreadyPersistedLeafProds)
    {
        boolean breakflag = false;
        for(Integer i=0;i<listOfChildProducts.size();i++){
            System.debug('inside for.  '+ i);
            
            alreadyPersistedLeafProds=iteratationToGetBundle(listOfChildProducts[i],bundleChildProductsMap,firstLevelParentName,
                                                             alreadyPersistedLeafProds) ;
            System.debug('alreadyPersistedLeafProds .>a> >. '+alreadyPersistedLeafProds);
            if(alreadyPersistedLeafProds!= null){
                //break;
                System.debug('inside for if.. .> >. '+alreadyPersistedLeafProds);
                breakflag = true;
                return alreadyPersistedLeafProds;
            }
            if(breakflag){
                break;
            }
        }
        
        return alreadyPersistedLeafProds;
        
        
    }
    private Static void addPriceAndPRoducts(String serviceType,List<ProductOffering> productOfferingListforChildLeafProds,
                                            String firstLevelparentProdOfferId,List<String> listTogetPrice,
                                            List<Object> listOfChildProducts,String quoteId,Decimal pkgQunatity,
                                            List<Object> leafProdList,List<String> prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle,
                                            String firstLevelParentName,boolean skipWithDBTogetExistingList)
    {
        System.debug('addPriceAndPRoducts at addPriceAndPRoducts..'+firstLevelparentProdOfferId + 'firstLevelParentName.. '+firstLevelParentName);
        
        
        
        
        List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts = new List<BundlePrice.cls_bundlePriceDetails>();
        Map<String, String> attributeMapValues = new Map<String, String>(); 
        PCServiceCall pccall = new PCServiceCall();
        //ProductPrice priceForSelectedProducts = pccall.getProductPrice(listTogetPrice, attributeMapValues);
        BundlePrice priceForSelectedProducts =pccall.getBundlePricePkgPricing(listTogetPrice, attributeMapValues,quoteId,serviceType);
        bundlePriceForSelectedProducts = priceForSelectedProducts.getBundlePriceDetails();
        List<Object> alreadyPersistedLeafProds = null;
        if(productOfferingListforChildLeafProds!=null) {
            for(ProductOffering eachBundleLeafprodOffefromPc : productOfferingListforChildLeafProds){
                System.debug('eachBundleLeafprodOffefromPc.productOfferingId>>.' +eachBundleLeafprodOffefromPc.productOfferingId+
                             'skipWithDBTogetExistingList. '+skipWithDBTogetExistingList);
                
                Map<String,List<Object>> bundleChildProductsMap = null;
                if(eachBundleLeafprodOffefromPc.productType!='BUNDLE'){
                    if(!skipWithDBTogetExistingList){
                        alreadyPersistedLeafProds=getExistBundleListFromDB(listOfChildProducts,firstLevelParentName,
                                                                           bundleChildProductsMap,alreadyPersistedLeafProds);
                    }
                    
                    System.debug('leafProdList is .. '+leafProdList  + 'alreadyPersistedLeafProds.after ' +alreadyPersistedLeafProds);
                    
                    if(leafProdList!=null && !leafProdList.contains(eachBundleLeafprodOffefromPc.productOfferingId)){
                        List<ProductOffering.cls_productSpec> productsSpec =eachBundleLeafprodOffefromPc.getproductSpec();
                        System.debug('productsSpec.get(0).productSpecID.' +productsSpec.get(0).productSpecID);
                        if(alreadyPersistedLeafProds == null){
                            createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                                       listOfChildProducts,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                            
                        }  else{
                            createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                                       alreadyPersistedLeafProds,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                            
                        }
                        
                        
                        
                    }else if(leafProdList == null){
                        List<ProductOffering.cls_productSpec> productsSpec =eachBundleLeafprodOffefromPc.getproductSpec();
                        
                        System.debug('productsSpec.get(0).productSpecID.' +productsSpec.get(0).productSpecID);
                        if(alreadyPersistedLeafProds == null){
                            createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                                       listOfChildProducts,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                        }  else{
                            createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                                       alreadyPersistedLeafProds,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                        }
                        
                        
                    }
                    System.debug('alreadyPersistedLeafProds after createLine is.. '+alreadyPersistedLeafProds);    
                }
            }
        }
    }
    
    
    private Static void getPriceForAllChildLeafProductsForProdSpec(String serviceType,List<ProductOffering.cls_productSpec> clsproductSpecList,
                                                                   List<Object> listOfChildProducts,String quoteId,
                                                                   String firstLevelparentProdOfferId,Decimal pkgQunatity,
                                                                   Map<String,List<Object>> chlidbundleProdNames,String firstLevelParentName)
        
        
    {
        System.debug('getPriceForAllChildLeafProductsForProdSpec....firstLevelparentProdOfferId.. '+firstLevelparentProdOfferId+
                     'firstLevelParentName .. '+firstLevelParentName);
        
        List<String> listTogetPrice = new List<String>();
        Map<String,List<Object>> bundleChildProductsMap = null;
        List<Object> alreadyPersistedLeafProds = null;
        List<Object> leafProdList = chlidbundleProdNames.get(firstLevelparentProdOfferId);
        
        for(ProductOffering.cls_productSpec eachLeafProdSpec : clsproductSpecList)
        {
            if(firstLevelparentProdOfferId != eachLeafProdSpec.productSpecID){
                System.debug('leafProdList .. '+leafProdList + 'eachLeafProdFromPc.productOfferingId' +eachLeafProdSpec.productSpecID
                             +'eachLeafProdFromPc.productType.. '+eachLeafProdSpec.productType);
                if(eachLeafProdSpec.productType !='BUNDLE' || eachLeafProdSpec.productType !='VAS'){
                    if(leafProdList!=null && !leafProdList.contains(eachLeafProdSpec.productSpecID)){
                        listTogetPrice.add(eachLeafProdSpec.productSpecID);
                    }else{
                        for(Integer i=0;i<listOfChildProducts.size();i++){
                           / // commented for PMD fix
                            if(!(listOfChildProducts[i] instanceof PackageController.QuoteLineItemPkgWrapper))
                            {
                                System.debug('insid else..');
                                bundleChildProductsMap = ( Map<String,List<Object>>)listOfChildProducts[i];
                                System.debug('insid else.bundleChildProductsMap.'+bundleChildProductsMap);
                                if(bundleChildProductsMap!=null && bundleChildProductsMap.get(firstLevelParentName)!=null){
                                    alreadyPersistedLeafProds = bundleChildProductsMap.get(firstLevelParentName);
                                }
                                System.debug('alreadyPersistedLeafProds .. '+alreadyPersistedLeafProds);
                            }
                        }
                    }  
                }
            }
            
        }
        List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts = new List<BundlePrice.cls_bundlePriceDetails>();
        Map<String, String> attributeMapValues = new Map<String, String>(); 
        PCServiceCall pccall = new PCServiceCall();
        BundlePrice priceForSelectedProducts = pccall.getBundlePricePkgPricing(listTogetPrice, attributeMapValues,quoteId,serviceType);
        bundlePriceForSelectedProducts = priceForSelectedProducts.getBundlePriceDetails();
        for(ProductOffering.cls_productSpec eachLeafProdSpec : clsproductSpecList){
            if(firstLevelparentProdOfferId!=eachLeafProdSpec.productSpecID){
                createQuoteLineItemForLeaf(eachLeafProdSpec,false,firstLevelparentProdOfferId,
                                           listOfChildProducts,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
            }
            
        }
        
        
    }
    
    
    
    private Static void setPriceAndAddProducts(String serviceType,Map<String,List<Object>> chlidbundleProdNames,List<Object> listOfChildProducts,
                                               ProductOffering eachprodOffefromPcBundle,String quoteId,Decimal pkgQunatity,
                                               boolean skipWithDBTogetExistingList)
    {
        
        
        
        System.debug('inside setPriceAndAddProducts');
        List<ProductOffering> productOfferingListforChildLeafProds=eachprodOffefromPcBundle.getproductOffering();
        System.debug('productOfferingListforChildLeafProds---'+JSON.serialize(productOfferingListforChildLeafProds));
        if(productOfferingListforChildLeafProds!=null){
            getPriceForAllChildLeafProducts(serviceType,productOfferingListforChildLeafProds,listOfChildProducts,quoteId,
                                            eachprodOffefromPcBundle.productOfferingId,pkgQunatity,chlidbundleProdNames,
                                            eachprodOffefromPcBundle.name,skipWithDBTogetExistingList
                                            
                                           );
        }
        
    }
    
    private Static void setPriceAndAddProductsForVas(String serviceType,Map<String,List<Object>> chlidbundleProdNames,List<Object> listOfChildProducts,
                                                     ProductOffering eachprodOffefromPcBundle,String quoteId,Decimal pkgQunatity,
                                                     boolean skipWithDBTogetExistingList)
    {
        
        System.debug('inside setPriceAndAddProducts');
        ProductOffering productOfferingVasProds=eachprodOffefromPcBundle;
        List<String> listTogetPrice = new List<String>();
        String firstLevelparentProdOfferId=null;
        List<Object> leafProdList=new List<Object>();
        System.debug('productOfferingVasProds---'+JSON.serialize(productOfferingVasProds));
        if(productOfferingVasProds!=null){
            System.debug('productOfferingVasProds.productOfferingId--'+productOfferingVasProds.productOfferingId);
            firstLevelparentProdOfferId=productOfferingVasProds.productOfferingId;
            leafProdList = chlidbundleProdNames.get(firstLevelparentProdOfferId);
            if(productOfferingVasProds.productType !='BUNDLE'){
                listTogetPrice.add(productOfferingVasProds.productOfferingId);
            }
        }
        List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts = new List<BundlePrice.cls_bundlePriceDetails>();
        Map<String, String> attributeMapValues = new Map<String, String>(); 
        PCServiceCall pccall = new PCServiceCall();
        BundlePrice priceForSelectedProducts = pccall.getBundlePricePkgPricing(listTogetPrice, attributeMapValues,quoteId,serviceType);
        bundlePriceForSelectedProducts = priceForSelectedProducts.getBundlePriceDetails();
        List<Object> alreadyPersistedLeafProds = null;
        Map<String,List<Object>> bundleChildProductsMap = null;
        if(productOfferingVasProds.productType !='BUNDLE'){
            System.debug('for VAS---'+JSON.serialize(listOfChildProducts));
          
            if(leafProdList!=null && !leafProdList.contains(productOfferingVasProds.productOfferingId)){
                List<ProductOffering.cls_productSpec> productsSpec =productOfferingVasProds.getproductSpec();
                System.debug('productsSpec.get(0).productSpecID. for leafProdList not null' +productsSpec.get(0).productSpecID);
                if(alreadyPersistedLeafProds == null){
                    System.debug('inside alreadyPersistedLeafProds null');
                    createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                               listOfChildProducts,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                    
                }  else{
                    System.debug('inside alreadyPersistedLeafProds not null');
                    createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                               alreadyPersistedLeafProds,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                    
                }
                
            }
            else if(leafProdList == null){
                List<ProductOffering.cls_productSpec> productsSpec =productOfferingVasProds.getproductSpec();
                
                System.debug('productsSpec.get(0).productSpecID. for leafProdList null' +productsSpec.get(0).productSpecID);
                if(alreadyPersistedLeafProds == null){
                    System.debug('inside alreadyPersistedLeafProds null');
                    createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                               listOfChildProducts,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                }  else{
                    System.debug('inside alreadyPersistedLeafProds not null');
                    createQuoteLineItemForLeaf(productsSpec.get(0),false,firstLevelparentProdOfferId,
                                               alreadyPersistedLeafProds,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                }
                
            }
        }
        System.debug('alreadyPersistedLeafProds after createLine is.. '+alreadyPersistedLeafProds);  
    }
    
    
    private Static void setPriceAndAddProductsForProdSpec(String serviceType,Map<String,List<Object>> chlidbundleProdNames,List<Object> listOfChildProducts,
                                                          ProductOffering eachprodOffefromPcBundle,String quoteId,Decimal pkgQunatity)
    {
        
        
        
        List<ProductOffering.cls_productSpec> clsproductSpecList=eachprodOffefromPcBundle.getProductSpec();
        if(clsproductSpecList!=null)
        {
            getPriceForAllChildLeafProductsForProdSpec(serviceType,clsproductSpecList,listOfChildProducts,quoteId,
                                                       eachprodOffefromPcBundle.productOfferingId,pkgQunatity,chlidbundleProdNames,
                                                       eachprodOffefromPcBundle.name);
        }
        
        
    }
    
    private Static void constructRemChildProductsFromPc(String serviceType,Map<String,List<Object>> chlidbundleProdNames,List<Object> listOfChildProducts,
                                                        ProductOffering eachprodOffefromPcBundle,String quoteId,Decimal pkgQunatity,
                                                        boolean skipWithDBTogetExistingList){
                                                            
                                                            setPriceAndAddProducts(serviceType,chlidbundleProdNames,listOfChildProducts,
                                                                                   eachprodOffefromPcBundle,quoteId,pkgQunatity,
                                                                                   skipWithDBTogetExistingList);
                                                        }
    
    private Static void constructIfProdSpecHaveChilds(String serviceType,ProductOffering eachprodOffefromPcBundle,
                                                      List<Object> childBundleProductsList,String quoteId,
                                                      Decimal pkgQunatity,String parentproductOfferingId,String prodType)
    {
        System.debug('inside constructIfProdSpecHaveChilds'+parentproductOfferingId);
        List<ProductOffering.cls_productSpec> productsSpec =eachprodOffefromPcBundle.getproductSpec();
        for(ProductOffering.cls_productSpec eachProdSpec : productsSpec){
            if(eachprodOffefromPcBundle.productOfferingId == eachProdSpec.productSpecID && prodType != 'VAS'){
                system.debug('in first if');
                createQuoteLineItemForHeaderBundle(eachprodOffefromPcBundle,eachProdSpec.defaultState,true,
                                                   childBundleProductsList,quoteId,parentproductOfferingId,
                                                   pkgQunatity);
            } else if(eachprodOffefromPcBundle.productOfferingId == eachProdSpec.productSpecID && prodType == 'VAS'){
                system.debug('in second if');
                List<BundlePrice.cls_bundlePriceDetails> bundlePriceForSelectedProducts = new List<BundlePrice.cls_bundlePriceDetails>();
                List<String> listTogetPrice = new List<String>();
                listTogetPrice.add(eachprodOffefromPcBundle.productOfferingId);
                Map<String, String> attributeMapValues = new Map<String, String>(); 
                PCServiceCall pccall = new PCServiceCall();
                BundlePrice priceForSelectedProducts = pccall.getBundlePricePkgPricing(listTogetPrice, attributeMapValues,quoteId,serviceType);
                bundlePriceForSelectedProducts = priceForSelectedProducts.getBundlePriceDetails();
                createQuoteLineItemForLeaf(eachProdSpec,false,parentproductOfferingId, childBundleProductsList,quoteId,bundlePriceForSelectedProducts,pkgQunatity);
                //  Map<String,List<Object>> chlidbundleProdNames = new Map<String,List<Object>>();
                //     setPriceAndAddProductsForProdSpec(chlidbundleProdNames,childBundleProductsList,
                //                                     eachprodOffefromPcBundle,quoteId,pkgQunatity);
            }
            
            else{
                Map<String,List<Object>> chlidbundleProdNames = new Map<String,List<Object>>();
                setPriceAndAddProductsForProdSpec(serviceType,chlidbundleProdNames,childBundleProductsList,
                                                  eachprodOffefromPcBundle,quoteId,pkgQunatity);
            }
        }
    }
    //PMD fix method name capital letter fix
    private Static void constructBundleAndTheirProducts(String serviceType,List<Object> listOfChildProducts,
                                                        ProductOffering eachprodOffefromPcBundle,String quoteId,Decimal pkgQunatity,
                                                        List<String> prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle,
                                                        boolean skipWithDBTogetExistingList,String parentproductOfferingId,String prodType
                                                       )
    {
        System.debug('constructBundleAndTheirProducts ... '+parentproductOfferingId);
        boolean sameMethodInvoked = false;
        Map<String,List<Object>> bundleChildProductsMap = new Map<String,List<Object>>();
        List<Object> childBundleProductsList = new List<Object>();
        
        
        bundleChildProductsMap.put(eachprodOffefromPcBundle.name,childBundleProductsList);
        System.debug('bundleChildProductsMap---> '+JSON.serialize(bundleChildProductsMap));
        constructIfProdSpecHaveChilds(serviceType,eachprodOffefromPcBundle,childBundleProductsList,quoteId,pkgQunatity,parentproductOfferingId,prodType);
        System.debug('childBundleProductsList after 111---> '+JSON.serialize(childBundleProductsList));
        List<ProductOffering> productOfferingListforChildLeafProds=eachprodOffefromPcBundle.getproductOffering();
        String firstLevelparentProdOfferId=eachprodOffefromPcBundle.productOfferingId;
        String firstLevelparentName=eachprodOffefromPcBundle.name;
        List<String> listTogetPrice = new List<String>();
        if(productOfferingListforChildLeafProds != null) {
            for(ProductOffering eachLeafProdFromPc : productOfferingListforChildLeafProds){
                System.debug('eachLeafProdFromPc.productType is.. '+eachLeafProdFromPc.productType);
                System.debug('prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle is.. '+
                             prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle);
                if(eachLeafProdFromPc.productType !='BUNDLE'){
                    listTogetPrice.add(eachLeafProdFromPc.productOfferingId);
                }else if(eachLeafProdFromPc.productType =='BUNDLE'){
                    prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle.add(eachLeafProdFromPc.productOfferingId);
                    //Map<String,List<Object>> bundleChildProductsMapNew = new Map<String,List<Object>>();
                    constructBundleAndTheirProducts(serviceType,childBundleProductsList,eachLeafProdFromPc,
                                                    quoteId,pkgQunatity,prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle,
                                                    skipWithDBTogetExistingList,parentproductOfferingId,eachLeafProdFromPc.productType);
                }
                
            }
        }
        System.debug('listTogetPrice in constructBundleAndTheirProducts'+listTogetPrice);
        addPriceAndPRoducts(serviceType,productOfferingListforChildLeafProds,firstLevelparentProdOfferId,listTogetPrice,
                            childBundleProductsList,quoteId,pkgQunatity,null,prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle
                            ,firstLevelparentName,skipWithDBTogetExistingList);
        
        listOfChildProducts.add(bundleChildProductsMap);
        
    }
    
    
    private Static void getPcCallresponsetoCompare(String serviceType,Map<String,Map<String,List<Object>>> packagePRodChilds,String quoteId,
                                                   List<Object> listOfChildProducts,Decimal pkgQunatity,List<String>existingProdOfferIdFromDb)
    {
        System.debug('in getPcCallresponsetoCompare'+JSON.serialize(packagePRodChilds));
        PCServiceCall pccall = new PCServiceCall();
        List<String> prodofferList = new List<String>();
        for (String existOfferId: packagePRodChilds.keySet()){
            System.debug('existOfferId is in getPcCallresponsetoCompare .. '+existOfferId);
            prodofferList.add(existOfferId);
        } 
        System.debug('listOfChildProducts 111--'+JSON.serialize(listOfChildProducts));
        try{
            PackageOffer offer = pccall.getChildProdsForListOfPackages(serviceType,prodofferList); 
            System.debug('offer at .. '+JSON.serialize(offer));
            List<ProductOffering> productItemList = offer.getPackages();
            System.debug('productItemList at .. '+JSON.serialize(productItemList));
            if(productItemList!=null){
                for(ProductOffering productOffering : productItemList){
                    String parentproductOfferingId=productOffering.productOfferingId;
                    String parentproductName=productOffering.name;
                    System.debug('parentproductOfferingId is .. '+parentproductOfferingId);
                    System.debug('packagePRodChilds--'+packagePRodChilds);
                    List<String> allChildBundleProdsOfPkgFromPc = new List<String>();
                    Map<String,List<Object>> childBundlesOFOfferFromDB=packagePRodChilds.get(parentproductOfferingId);
                    //set<String> setListexistngChildBundlesOfDB = new Set<String>(childBundlesOFOfferFromDB);
                    //List<String>  listOfBundlesWhichWeAlreadyConsidered = new List<String>();
                    List<String> prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle = new List<String>();
                    List<ProductOffering> productOfferingList=productOffering.getproductOffering();
                    System.debug('productOfferingList .. '+productOfferingList);
                    if(productOfferingList!=null){
                        for(ProductOffering eachprodOffefromPc : productOfferingList){
                            System.debug('eachprodOfferFromPc.productofferid.'+eachprodOffefromPc.productOfferingId);
                            System.debug('eachprodOffefromPc.productType . '+eachprodOffefromPc.productType);
                            System.debug('childBundlesOFOfferFromDB . '+childBundlesOFOfferFromDB);
                            boolean skipWithDBTogetExistingList = false;
                            // Map<String,List<Object>> bundleChildProductsMap = new Map<String,List<Object>>();
                            if((eachprodOffefromPc.productType == 'BUNDLE' || eachprodOffefromPc.productType == 'PACKAGE' || eachprodOffefromPc.productType == 'VAS')&& childBundlesOFOfferFromDB!=null){
                                if(childBundlesOFOfferFromDB.get(eachprodOffefromPc.productOfferingId)!=null){
                                    system.debug('productType11'+eachprodOffefromPc.productType+'eachprodOffefromPc.productOfferingId'+childBundlesOFOfferFromDB.get(eachprodOffefromPc.productOfferingId));
                                    List<Object> alreadyPersistedLeafProds = null;
                                    Map<String,List<Object>> bundleChildProductsMap = new Map<String,List<Object>>();
                                    alreadyPersistedLeafProds=getExistBundleListFromDB(listOfChildProducts,eachprodOffefromPc.name,bundleChildProductsMap,
                                                                                       alreadyPersistedLeafProds);
                                    //added
                                    
                                    System.debug('added .alreadyPersistedLeafProds. '+alreadyPersistedLeafProds);
                                    //
                                    constructRemChildProductsFromPc(serviceType,childBundlesOFOfferFromDB,
                                                                    alreadyPersistedLeafProds,eachprodOffefromPc,quoteId,pkgQunatity,
                                                                    skipWithDBTogetExistingList);
                                }
                            
                            }else if(eachprodOffefromPc.productType == 'BUNDLE'|| eachprodOffefromPc.productType == 'PACKAGE'){
                                system.debug('productType22'+eachprodOffefromPc.productType+'eachprodOffefromPc.productOfferingId'+eachprodOffefromPc.productOfferingId);
                                
                                skipWithDBTogetExistingList=true;
                                constructBundleAndTheirProducts(serviceType,listOfChildProducts,eachprodOffefromPc,quoteId,pkgQunatity,
                                                                prodOfferOfEachProdOfferWhichWeAlreadyConstructedHeaderBundle,skipWithDBTogetExistingList,
                                                                parentproductOfferingId,eachprodOffefromPc.productType
                                                               );
                            } else if((eachprodOffefromPc.productType!='BUNDLE' || eachprodOffefromPc.productType!='PACKAGE') && !existingProdOfferIdFromDb.contains(eachprodOffefromPc.productOfferingId))
                            {
                                system.debug('inside VAS');
                                system.debug('productType33'+eachprodOffefromPc.productType);
                                List<Object> alreadyPersistedLeafProds = null;
                                Map<String,List<Object>> bundleChildProductsMap = new Map<String,List<Object>>();
                                alreadyPersistedLeafProds=getExistBundleListFromDB(listOfChildProducts,eachprodOffefromPc.name,bundleChildProductsMap,
                                                                                   alreadyPersistedLeafProds);
                                //added
                                
                                System.debug('added .alreadyPersistedLeafProds 33 '+alreadyPersistedLeafProds);
                                System.debug('listOfChildProducts 33--'+JSON.serialize(listOfChildProducts));
                                
                                setPriceAndAddProductsForVas(serviceType,childBundlesOFOfferFromDB,
                                                             listOfChildProducts,eachprodOffefromPc,quoteId,pkgQunatity,
                                                             skipWithDBTogetExistingList);
                                
                            }
                            
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('exception msg in getPcCallresponsetoCompare'+e.getMessage());
            System.debug('exception in getPcCallresponsetoCompare'+e.getStackTraceString());
        }
        
        
    }
    
    @AuraEnabled
    public static void getExistingMap(List<Object> existingServiceOfferMap,Map<String,Object> existingMap)
    {
        
        for(Integer j=0;j<existingServiceOfferMap.size();j++){
            Map<String,Object> item = (Map<String,Object>)existingServiceOfferMap[j];
            String serviceTypeOfExisting = (String)item.get('key');
            existingMap.put(serviceTypeOfExisting,(List<Object>)item.get('value'));
        }
        system.debug('existingMap in getExistingMap' + existingMap);
        
    }
    
    @AuraEnabled 
    public Static map<String,map<String,List<Object>>> getExistingOffersForExistingServiceTypes(map<String,map<String,List<Object>>> 
                                                                                                resultMap,
                                                                                                String quoteId,
                                                                                                Map<String, Object> offerMap,
                                                                                                String serviceType,
                                                                                                Decimal currentVersion,
                                                                                                List<Object> existingServiceOfferMap)
    {
        Map<String,Object> existingMap = new Map<String,Object>();
        getExistingMap(existingServiceOfferMap,existingMap);
        System.debug('existingMap in formmap .. '+existingMap);
        List<Quote_Line_Item__c> existServTypesList = [SELECT Name, ServiceType__c, Parent_Item__c,parentproductofferingid__c FROM Quote_Line_Item__c WHERE Quote__c=:quoteId and QuoteVersion__c=:currentVersion and Parent_Item__c=null];
        //// List<Quote_Line_Item__c> existServTypesList = [SELECT Name, ServiceType__c, Parent_Item__c,parentproductofferingid__c FROM Quote_Line_Item__c WHERE Quote__c=:quoteId and QuoteVersion__c=:currentVersion and parentproductofferingid__c=null];        
        List<String> existServTypes = new List<String>();
        if(!existServTypesList.isEmpty()){
            for(Quote_Line_Item__c qitem : existServTypesList)
            { 
                if(!existServTypes.contains(qitem.ServiceType__c))
                { 
                    existServTypes.add(qitem.ServiceType__c); //all existing serviceTypes
                    Map<String,List<Object>> quoteLineMap =null;
                    System.debug('qitem.ServiceType__c ... '+qitem.ServiceType__c);
                    if(resultMap.containsKey(qitem.ServiceType__c)){
                        quoteLineMap=resultMap.get(qitem.ServiceType__c);
                    }else{
                        quoteLineMap = new  Map<String,List<Object>>();
                    }
                     
                    if(existingMap.containsKey(qitem.ServiceType__c)){
                        system.debug('existingMap contains .. '+qitem.ServiceType__c);
                        List<Object> existPkgProds=(List<Object>)existingMap.get(qitem.ServiceType__c);
                        //Map<String, Object> existingPackAndChildProds = new Map<String, Object>();
                        for(Integer i=0;i<existPkgProds.size();i++){
                            map<String, Object> item = (map<String, Object>)existPkgProds[i];
                            offerMap.put((String)item.get('key'),item.get('value'));
                        }
                        // offerMap= (Map<String,Object>)existingMap.get(qitem.ServiceType__c);
                    }
                    System.debug('offerMap in formmap .. '+offerMap);
                    Map<String,String> offerListvalue =new Map<String,String>();
                    offerListvalue.put('quoteId',quoteId);
                    offerListvalue.put('qitem.ServiceType__c',qitem.ServiceType__c);
                    offerListvalue.put('currentVersion', String.valueOf(currentVersion));
                    resultMap.put(qitem.ServiceType__c, getExistingOffers(quoteLineMap,offerMap,offerListvalue));    
                }
            }
            System.debug('completeMapWithServiceType '+ JSON.serialize(resultMap));
        }
        return resultMap;
        
    }
    
    @AuraEnabled 
    public Static Map <String,List<Object>> getExistingOffers( Map<String,List<Object>> completeMap, Map<String, Object> offerMap,Map<String,String> offerListvalue) //, Map<String,List<Object>> updatedMapFromUI)
    { 
        Map<String,List<Object>> newMap=new Map<String,List<Object>>();//added for order change in selected package
        try {
            System.debug('In getExistingOffers '+offerListvalue.get('quoteId')+' currentVersion--'+offerListvalue.get('currentVersion'));
            System.debug('service typeeee--'+offerListValue.get('qitem.ServiceType__c'));
            Decimal currentves=Decimal.valueOf(offerListvalue.get('currentVersion'));
            List<Quote_Line_Item__c> quoteLinesList = [SELECT Name, ServiceType__c,Quantity__c, Currency__c, Price__c, Recurring_Charge__c,isAddon__c, Attribute__c, Is_Package__c, productOfferingId__c, parentproductofferingid__c, Mandatory__c, ProductType__c, Quote__c, rcnetprice__c, nrcnetprice__c, rcdiscountvalue__c, nrcdiscountvalue__c, 
                                                       rcvariableprice__c, nrcvariableprice__c, Parent_Item__c,com_tcs_telecom__rcProductOfferingPriceID__c,com_tcs_telecom__rcPricingClassifier__c,
                                                       com_tcs_telecom__rcBillingComponentType__c,com_tcs_telecom__packagedPriced__c,com_tcs_telecom__rcdiscountType__c,com_tcs_telecom__nrcdiscountType__c,
                                                       com_tcs_telecom__nrcProductOfferingPriceID__c,com_tcs_telecom__nrcPricingClassifier__c,com_tcs_telecom__nrcBillingComponentType__c
                                                       FROM Quote_Line_Item__c WHERE Quote__c=:offerListvalue.get('quoteId') and ServiceType__c=:offerListvalue.get('qitem.ServiceType__c') and QuoteVersion__c=:currentves];
            System.debug('quoteLinesList in getExistingOffers--'+JSON.serialize(quoteLinesList));
            system.debug('completeMap-->'+JSON.serialize(completeMap));
            Map <String, String> pkgList = new Map<String,String>();
            Map <String, String> pkgProdOfferId = new Map<String,String>();
            
            Map<String,String> pkgNameWithOfferigIdMap = new Map<String,String>(); 
            Map<String,Decimal> pkgWithQuantity = new Map<String,Decimal>();
            Map <String, String> mapAgainstToServiceType = new Map<String,String>();
            List<String> existingProdOfferIdFromDb = new List<String>();
            if(!quoteLinesList.isEmpty() && completeMap != null){
                System.debug('inside if quotelinelist not empty');
                for(Quote_Line_Item__c quoteLineEachPackageProduct : quoteLinesList)
                {
                    if(quoteLineEachPackageProduct.Parent_Item__c == null) //commented for SQL Limit Exception
                        //// if(quoteLineEachPackageProduct.parentproductofferingid__c == null)
                    {
                        System.debug('Parent_Item__c is null');
                        mapAgainstToServiceType.put(quoteLineEachPackageProduct.Id,quoteLineEachPackageProduct.ServiceType__c);//
                        pkgList.put(quoteLineEachPackageProduct.Id, quoteLineEachPackageProduct.Name);
                        pkgProdOfferId.put(quoteLineEachPackageProduct.Id, quoteLineEachPackageProduct.parentproductofferingid__c);
                        pkgWithQuantity.put(quoteLineEachPackageProduct.parentproductOfferingId__c,quoteLineEachPackageProduct.Quantity__c);
                    }
                    existingProdOfferIdFromDb.add(quoteLineEachPackageProduct.productOfferingId__c);
                }
                System.debug('pkgList '+ JSON.serialize(pkgList));
                System.debug('offerMapis.. '+offerMap);
                for(String pkgId : pkgList.keySet()) {
                    System.debug('pkgId'+pkgId);
                    if(offerMap != null && offerMap.containsKey(pkgList.get(pkgId))) {
                        System.debug('inside offer map if...');
                        //completeMap.put(pkgList.get(pkgId), (List<Object>)offerMap.get(pkgList.get(pkgId)));
                        newMap.put(pkgList.get(pkgId), (List<Object>)offerMap.get(pkgList.get(pkgId)));
                    }
                    else {
                        //added
                        String parentProdOfferIdOfParentProd=pkgProdOfferId.get(pkgId);
                        System.debug('parentProdOfferIdOfParentProd .. '+parentProdOfferIdOfParentProd);
                        Map<String,Map<String,List<Object>>> packagePRodChilds = new Map<String,Map<String,List<Object>>>();
                        Map<String,List<Object>> childbundleProdOfferIDs = new Map<String,List<String>>(); 
                        Decimal pkgQunatity = pkgWithQuantity.get(parentProdOfferIdOfParentProd);
                        System.debug('quoteLinesList before getExistingChildQuoteLineItems--'+JSON.serialize(quoteLinesList));
                        List<Object> listOfChildProducts = getExistingChildQuoteLineItems(pkgId, quoteLinesList,childbundleProdOfferIDs);
                        System.debug('childbundleProdOfferIDs in existOferrr data .. '+childbundleProdOfferIDs);
                        //added
                        packagePRodChilds.put(parentProdOfferIdOfParentProd, childbundleProdOfferIDs);
                        System.debug('listOfChildProducts before compare'+listOfChildProducts);
                        getPcCallresponsetoCompare(offerListvalue.get('qitem.ServiceType__c'),packagePRodChilds,offerListvalue.get('quoteId'),listOfChildProducts,pkgQunatity,existingProdOfferIdFromDb);
                        
                        System.debug('listOfChildProducts after compare'+listOfChildProducts);
                        //completeMap.put(pkgList.get(pkgId), listOfChildProducts);
                        newMap.put(pkgList.get(pkgId), listOfChildProducts);
                        System.debug('New Map with existing offers '+ JSON.serialize( newMap));
                    }
                }
            } else {
                System.debug('quoteLinesList empty');
            }
            System.debug('completeMap '+ JSON.serialize(completeMap));
            //
            for(String pkgId : completeMap.keySet()) {
            newMap.put(pkgId,completeMap.get(pkgId));
            }
            System.debug('New Map with all offers '+ JSON.serialize( newMap));
            return newMap;
            //return completeMap;
         }
        catch(Exception ex){
            system.debug('ex in '+ex+ex.getStackTraceString()+ex.getMessage()+ex.getCause()+ex.getLineNumber());
            return null;
        }
    }
    
    
    
    
    @AuraEnabled
    public static List<Object> getExistingChildQuoteLineItems(String parentId, List<Quote_Line_Item__c> quoteLinesList,Map<String,List<Object>> childbundleProdOfferIDs) {
        System.debug('inside getExistingChildQuoteLineItems');
        List<Object> listOfChildProducts = new List<Object>();
        System.debug('parentId '+parentId);
        System.debug('childbundleProdOfferIDs--'+JSON.serialize(childbundleProdOfferIDs));
        for(Quote_Line_Item__c quoteLine : quoteLinesList) {
            System.debug('inside loop 1--');
            if(parentId.equals(quoteLine.Id)) {
                System.debug('Inside package products');
                System.debug('quoteLine '+JSON.serialize(quoteLine));
                listOfChildProducts.add(convertQuoteToWrapper(quoteLine));
                System.debug('package products quoteLine--'+JSON.serialize(listOfChildProducts));
            } else if(parentId.equals(quoteLine.Parent_Item__c)) {
                if(quoteLine.Is_Package__c) {
                    System.debug('Inside bundle products');
                    System.debug('quoteLine '+JSON.serialize(quoteLine));
                    List<Object> listOfAllChildsForThisBundle = new List<String>();
                    childbundleProdOfferIDs.put(quoteLine.productOfferingId__c,listOfAllChildsForThisBundle);
                    System.debug('childbundleProdOfferIDs in getExistingChildQuoteLineItems---'+childbundleProdOfferIDs);
                    Map<String, List<Object>> bundleItems = new Map<String, List<Object>>();
                    bundleItems.put(quoteLine.name, getExistingChildQuoteLineItems(quoteLine.Id, quoteLinesList,childbundleProdOfferIDs));
                    System.debug('bundleItems '+JSON.serialize(bundleItems));
                    listOfChildProducts.add(bundleItems);
                } else {
                    System.debug('Inside child products');
                    System.debug('quoteLine '+JSON.serialize(quoteLine));
                    if(childbundleProdOfferIDs.get(quoteLine.parentproductofferingid__c)!=null){
                        List<Object> childProdNamesOfBundleList = childbundleProdOfferIDs.get(quoteLine.parentproductofferingid__c);
                        childProdNamesOfBundleList.add(quoteLine.productOfferingId__c);
                    }
                    listOfChildProducts.add(convertQuoteToWrapper(quoteLine));
                }
            }
        }
        return listOfChildProducts;
    }
    
    // PMD Fix Method names should not contain underscores
    @AuraEnabled
    public Static Map<String,Map<String,List<Object>>> formMapToViewNew(String quoteId, Decimal versionId)    
    { 
        System.debug('quoteId...in formMapToView '+quoteId);
        System.debug('Version...in formMapToView '+versionId);
        
        
        List<Quote_Line_Item__c> quoteLinesList = [SELECT servicetype__c,Name, Quantity__c, Currency__c, Price__c, 
                                                   Recurring_Charge__c,isAddon__c, Attribute__c, Is_Package__c, 
                                                   productOfferingId__c, parentproductofferingid__c, Mandatory__c, 
                                                   ProductType__c, Quote__c, rcnetprice__c, nrcnetprice__c, 
                                                   rcdiscountvalue__c, nrcdiscountvalue__c, rcvariableprice__c, 
                                                   nrcvariableprice__c, Parent_Item__c,QuoteVersion__c,
                                                   com_tcs_telecom__rcProductOfferingPriceID__c,com_tcs_telecom__rcPricingClassifier__c,
                                                   com_tcs_telecom__rcBillingComponentType__c,com_tcs_telecom__packagedPriced__c,com_tcs_telecom__nrcdiscountType__c,com_tcs_telecom__rcdiscountType__c,
                                                   com_tcs_telecom__nrcProductOfferingPriceID__c,com_tcs_telecom__nrcPricingClassifier__c,com_tcs_telecom__nrcBillingComponentType__c FROM Quote_Line_Item__c WHERE Quote__c=:quoteId and QuoteVersion__c=:versionId];
        //need to add
        Map<String,List<Object>> completeMap = new Map<String,List<Object>>();
        Map<String,List<Object>> completeMaptemp = new Map<String,List<Object>>();
        Map<String,Map<String,List<Object>>> completeServiceMap = new Map<String,Map<String,List<Object>>>();
        Map <String, String> pkgList = new Map<String,String>();
        Map <String, String> serviceList = new  Map <String, String>();
        Map<String,List<Object>> pkgcheck = new Map<String,List<Object>>();
        System.debug('quoteLinesList is.. '+quoteLinesList);
        if(!quoteLinesList.isEmpty()){
            for(Quote_Line_Item__c quoteLineEachPackageProduct : quoteLinesList)
            {
                
                if(quoteLineEachPackageProduct.Parent_Item__c == null) //commented for SQL limit exception
                    ////if(quoteLineEachPackageProduct.parentproductofferingid__c == null)
                {
                    pkgList.put(quoteLineEachPackageProduct.Id, quoteLineEachPackageProduct.Name);
                    serviceList.put(quoteLineEachPackageProduct.Id, quoteLineEachPackageProduct.ServiceType__c);
                }
            }            
            
            Set<String> pkgIdList = pkgList.keySet();
            string servicename;
            for(String pkgId : pkgList.keySet()) {                
                System.debug('pkgId and pkgname in formmapView is.. '+pkgId +' '+pkgList.get(pkgId));                                
                Map<String,List<String>> childbundleProdOfferIDs = new   Map<String,List<String>>();
                servicename = serviceList.get(pkgId);
                if (completeServiceMap.containskey(servicename) == false && completeServiceMap != null)
                {
                    completeMap = new Map<String,List<Object>>();
                    
                }                  
                List<Object> listOfChildProducts = getExistingChildQuoteLineItems(pkgId, quoteLinesList,childbundleProdOfferIDs);
                completeMap.put(pkgList.get(pkgId), listOfChildProducts);                                  
                completeServiceMap.put(servicename,completeMap);                               
                
            }
            
        }
        //System.debug('completeMap ---New.. '+JSON.serialize(completeMap));
        // System.debug('completeServiceMap --New.. '+JSON.serialize(completeServiceMap));
        return completeServiceMap;
    }
    
    
    
    
    @AuraEnabled
    public Static void deleteOfferFromDBAgainstToServiceType(String parentProdOfferId,String quoteID,decimal quoteVersion,
                                                             String serviceType)
    {
        System.debug('inside deleteOfferFromDB->'+parentProdOfferId + 'quoteID-' +quoteID);
        // PMD Check if the user has read access on the field
        if (!Schema.sObjectType.Quote_Line_Item__c.fields.Is_Package__c.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            
        }
        else
        {
            List<Quote_Line_Item__c> quoteLineForDeleteList = [SELECT Name,Is_Package__c,productOfferingId__c,Parent_Item__c,parentproductOfferingId__c
                                                               FROM Quote_Line_Item__c WHERE  
                                                               parentproductOfferingId__c=:parentProdOfferId and ServiceType__c=:serviceType and Quote__c=:quoteID and QuoteVersion__c=:quoteVersion];
            if(quoteLineForDeleteList!=null && !quoteLineForDeleteList.isEmpty()){
                getDataForDeleteAgainstToService(quoteLineForDeleteList,quoteID,quoteVersion,serviceType);
            }
        }
        
        
    }
    
    @AuraEnabled
    public Static boolean deleteOfferFromDBAgainstToServiceTypeFromUI(String parentProdOfferId,String quoteID,decimal quoteVersion,
                                                                      String serviceType)
    {
        System.debug('inside deleteOfferFromDB->'+parentProdOfferId + 'quoteID-' +quoteID);
        // PMD Check if the user has read access on the field
        if (!Schema.sObjectType.Quote_Line_Item__c.fields.Is_Package__c.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return false; 
        }
        
        List<Quote_Line_Item__c> quoteLineForDeleteList = [SELECT Name,Is_Package__c,productOfferingId__c,Parent_Item__c,parentproductOfferingId__c
                                                           FROM Quote_Line_Item__c WHERE  
                                                           parentproductOfferingId__c=:parentProdOfferId and ServiceType__c=:serviceType and Quote__c=:quoteID and QuoteVersion__c=:quoteVersion];
        if(quoteLineForDeleteList!=null && !quoteLineForDeleteList.isEmpty()){
            getDataForDeleteAgainstToService(quoteLineForDeleteList,quoteID,quoteVersion,serviceType);
            return true;
        }
        
        return false; 
        
    }
    
    
    private Static void getDataForDeleteAgainstToService(List<Quote_Line_Item__c> quoteLineForDeleteList,String quoteID,
                                                         decimal quoteVersion,String serviceType)
    {
        System.debug('quoteLineForDeleteList size before.. '+quoteLineForDeleteList.size());
        System.debug('quoteLineForDeleteList--'+JSON.serialize(quoteLineForDeleteList));
        try{
                if (!Quote_Line_Item__c.sObjectType.getDescribe().isDeletable()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            if(quoteLineForDeleteList!=null && !quoteLineForDeleteList.isEmpty()){
                for(Quote_Line_Item__c itemTobeDelete : quoteLineForDeleteList){
                    if(!itemTobeDelete.Is_Package__c || itemTobeDelete.Parent_Item__c == null)
                        // if(!itemTobeDelete.Is_Package__c || itemTobeDelete.parentproductofferingid__c == null)
                    {
                        System.debug('inside if of delete');
                        delete itemTobeDelete;
                    }
                    else if( itemTobeDelete.Parent_Item__c != null && itemTobeDelete.Is_Package__c)
                        //else if( itemTobeDelete.parentproductofferingid__c != null && itemTobeDelete.Is_Package__c)
                        
                    {
                          System.debug('inside else if of delete');
                        deleteOfferFromDBAgainstToServiceType(itemTobeDelete.productOfferingId__c,quoteID,quoteVersion,
                                                              serviceType);
                        delete itemTobeDelete; //need to add
                    }
                    
                }
                
            }
        }
        catch(Exception e){
            System.debug('exception in getDataForDeleteAgainstToService'+e.getStackTraceString());
        }
    
    }  
    
    
    
    @AuraEnabled
    public static Map<String,String> getPriceCalculationRevampForBOB(string productLineItemMapStr) {
        System.debug('inside prceCal Reveamp Bob..');
        return PackageController.getPriceCalculationRevampForBOB(productLineItemMapStr);
        
    }
    
    public static boolean quoteLineItemWrapperMethod(){
        QuoteLineItemWrapper quoteline=new QuoteLineItemWrapper();
        quoteline.name=null;
        quoteline.quantity=null;
        quoteline.currencyObj=null;
        quoteline.price=null;
        quoteline.recurringCharge=null;
        quoteline.attribute=null;
        quoteline.isPackage=null;
        quoteline.productOfferingId=null;
        quoteline.mandatory=null;
        quoteline.quote=null;
        return true;
    }
    
    public class QuoteLineItemWrapper {
        
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public Decimal quantity {get; set;}
        @AuraEnabled public String currencyObj {get; set;}
        @AuraEnabled public Decimal price {get; set;}
        @AuraEnabled public Decimal recurringCharge {get; set;}
        @AuraEnabled public String attribute {get; set;}
        @AuraEnabled public boolean isPackage {get; set;}  
        @AuraEnabled public String productOfferingId {get; set;}
        @AuraEnabled public String mandatory {get; set;}
        @AuraEnabled public String quote {get; set;}
        
    }   
    
    public class AttributeWrapper {
        
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public String attributeValue {get; set;}
        
    } 
    
    
    //Added For View Attributes
    @AuraEnabled
    public static boolean checkQuoteIdForStatus(String quoteId)
    {
        system.debug('quoteid--'+quoteId);
        try{
            // PMD Check if the user has read access on the field
            if (!Schema.sObjectType.Quote_Line_Item__c.fields.description__c.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                return false; 
            }
            
            Quote quote = [SELECT Id,OpportunityId,CurrentVersion__c FROM Quote WHERE Id=:quoteId];
            decimal quoteVersion=quote.CurrentVersion__c;
            List<Quote_Line_Item__c> newPkgList= [select description__c,productOfferingId__c,Discount__c,Is_Package__c,IsAddon__c,
                                                  nrcnetprice__c,Price__c,Parent_Item__c,parentproductofferingid__c,Price_Override__c,rcnetprice__c,
                                                  ProductType__c,Quantity__c,ServiceType__c from Quote_Line_Item__c where Quote__c=:quoteId and QuoteVersion__c=:quoteVersion];
            system.debug('newPkgList--'+newPkgList);
            system.debug('quote--'+quote);
            if(newPkgList.size()>0)
            {
                mapQuoteLineToOpportunityProduct(newPkgList,quoteId,quoteVersion,quote);
                return true;
                
            }
            
        }
        catch(Exception e){
            System.debug('mapQuoteLineToOpportunityProduct--------->'+e.getLineNumber()+'--'+e.getMessage());
            
        }
        return false;
    }
    
    @AuraEnabled
    public static List<AttributeWrapper> fetchAttributesToView ( String pkgName, String quoteId )
    {
        List<AttributeWrapper> attrWrapperList = new  List<AttributeWrapper> ();
        System.debug('pkgName'+ pkgName);
        System.debug('quoteId'+ quoteId);
        // PMD Check if the user has read access on the field
        if (!Schema.sObjectType.Attribute__c.fields.ProductSpec__c.isAccessible())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null; 
        }
        
        List<Attribute__c>  attrList = [select Name,QuoteId__c,ProductSpec__c,Attribute_value__c from Attribute__c where ProductSpec__c=:pkgName and QuoteId__c=:quoteId ];
        
        for(Attribute__c att : attrList) {
            AttributeWrapper attWrapper = new AttributeWrapper();
            attWrapper.name = att.Name;
            attWrapper.attributeValue = att.Attribute_value__c;
            attrWrapperList.add(attWrapper);
        }
        system.debug('attrWrapperList'+attrWrapperList);
        return attrWrapperList;
    }
    public static void mapQuoteLineToOpportunityProduct(List<Quote_Line_Item__c> pkgListQLIs,String quoteId,decimal quoteVersion,Quote quote){
        system.debug('mapQuoteLineToOpportunityProduct---------->'+pkgListQLIs.size()+'---'+quoteId+'---'+quoteVersion);
        //Quote quote = [SELECT Id,OpportunityId,CurrentVersion__c FROM Quote WHERE Id=:quoteId];
        try{
            List<Quote_Line_Item__c> newPkgList= new List<Quote_Line_Item__c>();
            // PMD Check if the user has read access on the field
            if (!Schema.sObjectType.OpportunityLineItem.fields.IsAddon__c.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            else
            {
                List<OpportunityLineItem> opportunityLine=[SELECT ServiceDate, Discount, IsAddon__c, IsPackage__c, LastModifiedById, Description, ListPrice, OpportunityId, parentproductofferingid__c, Product2Id, ProductCode, Quantity, UnitPrice, Subtotal, TotalPrice  FROM OpportunityLineItem WHERE  OpportunityId=:quote.OpportunityId] ;
                if(opportunityLine!=null && opportunityLine.size() >0){
                    if (!Schema.sObjectType.Product2.fields.ProductCode.isAccessible()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                        //return null; 
                    }
                    for(Quote_Line_Item__c qline:pkgListQLIs){ 
                        boolean flag = false;
                        for(OpportunityLineItem line:opportunityLine){
                            Product2 prod= [SELECT ProductCode,Name,Id FROM Product2 WHERE Id=:line.Product2Id];
                            if(prod!=null && prod.ProductCode == qline.productofferingid__c){
                                system.debug('Product exist---------->'+prod.ProductCode);
                                flag = true;
                            }
                        }
                        if(!flag){
                            system.debug('Product not exist---------->'+qline.productofferingid__c);
                            newPkgList.add(qline);
                        }
                    }
                    createNewOpportunityProduct(quote, newPkgList, quoteId);
                }  else{
                    createNewOpportunityProduct(quote, pkgListQLIs, quoteId);
                }      
            }
        }catch(Exception e){
            System.debug('mapQuoteLineToOpportunityProduct--------->'+e.getLineNumber()+'--'+e.getMessage());
            
        }
        
    }    
    
    public static void createNewOpportunityProduct(Quote quote, List<Quote_Line_Item__c> pkgListQLIs,String quoteId){
        System.debug('createNewOpportunityProduct--------->'+pkgListQLIs.size());
        try{
            // PMD Check if the user has read access on the field
            if (!Schema.sObjectType.Opportunity.fields.Pricebook2Id.isAccessible())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            else
            {
                //added for PMD fix- apex crud violation by RIMI
                if (!Schema.sObjectType.Opportunity.fields.Pricebook2Id.isCreateable() &&
                    !Schema.sObjectType.Opportunity.fields.Pricebook2Id.isUpdateable()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                        
                    }
                Opportunity opp= [SELECT Id,Pricebook2Id,Name,CurrencyIsoCode FROM Opportunity where Id=:quote.OpportunityId];
                system.debug('Pricebook2Id Opportunity---------->'+opp.Pricebook2Id);
                if(opp.Pricebook2Id==null){
                    //added for PMD fix- apex crud violation by RIMI
                    if (!Schema.sObjectType.Pricebook2.fields.Name.isCreateable()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                        
                    }
                    Pricebook2 customPB = new Pricebook2(Name='Opp_'+ opp.Name, isActive=true);
                    insert customPB;
                    opp.Pricebook2Id= customPB.id;
                    system.debug('Pricebook2Id Opportunity------new---->'+opp.Pricebook2Id);
                    upsert opp;
                } if(opp.Pricebook2Id !=null){
                    //added for PMD fix- apex crud violation by RIMI
                    if (!Schema.sObjectType.Pricebook2.fields.Name.isAccessible() 
                        && !Schema.sObjectType.Pricebook2.fields.Name.isCreateable()){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                            
                        }
                    Pricebook2 customPBC = [SELECT Name FROM PriceBook2 WHERE id=:opp.Pricebook2Id];
                    if(customPBC==null){
                        Pricebook2 customPB1 = new Pricebook2(Name='Opp_'+ opp.Name, isActive=true);
                        insert customPB1;
                        opp.Pricebook2Id= customPB1.id;
                        system.debug('Pricebook2Id Opportunity------new---here->'+opp.Pricebook2Id);
                        upsert opp;
                    }
                }
                List<OpportunityLineItem> newLineList= new List<OpportunityLineItem>();
                //added for PMD fix- apex crud violation by RIMI
                if (!Schema.sObjectType.OpportunityLineItem.fields.Name.isCreateable() &&
                    !Schema.sObjectType.OpportunityLineItem.fields.Description.isCreateable()){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                        
                    }
                for(Quote_Line_Item__c line:pkgListQLIs){
                    system.debug('create OpportunityLineItem---------->'+line.Id);
                    OpportunityLineItem oprProduct= new OpportunityLineItem();
                    Product2 prod;
                    try{
                        List<Product2> prodL= [SELECT ProductCode,Name,Id FROM Product2 WHERE ProductCode=:line.productofferingid__c];
                        if(prodL== null || prodL.size() == 0){
                            prod= createProduc(line);
                        }else
                        { prod= prodL[0];
                        }
                    }catch(Exception e){
                        System.debug('no product in MAster table---1------>'+e.getMessage());
                        prod= createProduc(line);
                    }
                    if(line.rcnetprice__c !=null ){
                        PriceBookEntry entry= getPriceBookEntry(prod, line.rcnetprice__c, opp);
                        oprProduct.TotalPrice=decimal.valueOf(line.rcnetprice__c);
                        oprProduct.PricebookEntryId=entry.Id;
                    }
                    else{ 
                        PriceBookEntry entry= getPriceBookEntry(prod,'0.00', opp);
                        oprProduct.TotalPrice=decimal.valueOf('0.00');
                        oprProduct.PricebookEntryId=entry.Id;
                    }
                    oprProduct.Description=quoteId;
                    oprProduct.Product2Id= prod.Id;
                    oprProduct.OpportunityId=quote.OpportunityId;
                    oprProduct.Quantity=1;
                    if(line.IsAddon__c){
                        oprProduct.IsAddon__c= true;
                    }
                    else{
                        oprProduct.IsAddon__c= false;
                    }
                    if(line.Is_Package__c){
                        oprProduct.IsPackage__c= true;
                    }
                    else{
                        oprProduct.IsPackage__c=false;
                    }
                    oprProduct.parentproductofferingid__c=line.parentproductofferingid__c;
                    newLineList.add(oprProduct);
                } 
                insert newLineList;
            }
        }catch(Exception e){
            System.debug('mapQuoteLineToOpportunityProduct---1------>'+e.getLineNumber()+'--'+e.getMessage());
            
        }
    }
    
    public static Product2 createProduc(Quote_Line_Item__c line){
        //added for PMD fix- apex crud violation by RIMI
         Product2  prod= new Product2();
        if (!Schema.sObjectType.Product2.fields.ProductCode.isCreateable() &&
            !Schema.sObjectType.Product2.fields.Name.isCreateable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                return null;
            }
        else{
        System.debug('createProduc------>'+line.productofferingid__c);
        prod.ProductCode=line.productofferingid__c;
        prod.Name=line.Name;
        insert prod;
        }
       
        return prod;
    }
    public static PriceBookEntry createPriceBookEntry(Product2 prod,String amt,Opportunity opp){
        System.debug('createPriceBookEntry--------->'+amt);
        
        Pricebook2 stPricebook =  [SELECT Id, IsStandard FROM Pricebook2 WHERE IsStandard=true];
        if (!Schema.sObjectType.PriceBookEntry.fields.Product2Id.isAccessible() &&
            !Schema.sObjectType.PriceBookEntry.fields.PriceBook2Id.isAccessible()&&
            !Schema.sObjectType.PriceBookEntry.fields.Product2Id.isCreateable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                return null;
                
            }
        else{
         	List<PriceBookEntry> sEntry= [SELECT Id FROM PricebookEntry WHERE PriceBook2Id=:stPricebook.Id AND Product2Id=:prod.id];
        	System.debug('stPricebook--------->'+sEntry+'--'+opp.CurrencyIsoCode);
        	if(sEntry==null|| sEntry.size()==0){
            	PriceBookEntry stentry=new PricebookEntry( Product2Id=prod.id, UnitPrice= decimal.valueOf(amt),
                                                      PriceBook2Id=stPricebook.Id, 
                                                      UseStandardPrice=false,isActive=true);
            	insert stentry;
        	}
        PriceBookEntry entry=  new PricebookEntry( Product2Id=prod.id, UnitPrice=decimal.valueOf(amt), 
                                                  PriceBook2Id=opp.Pricebook2Id, CurrencyIsoCode=opp.CurrencyIsoCode,
                                                  UseStandardPrice=true,isActive=true);
        insert entry;
        System.debug('entry--------->'+opp.CurrencyIsoCode);
        return entry;
        }
       
        
        
    }
    
    public static PriceBookEntry getPriceBookEntry(Product2 prod,String amt,Opportunity opp){
        List<PriceBookEntry> entry= [SELECT id FROM PriceBookEntry WHERE Product2Id=:prod.id AND PriceBook2Id=:opp.Pricebook2Id];
        if(entry==null || entry.size()==0){
            return createPriceBookEntry(prod, amt, opp);
        }else
        { return entry[0];
        }
    }
    
    @AuraEnabled
    public static Boolean persistOrderLines(String mapToPersistJson,String orderId,String attributes)
    {
        System.debug('inside persistOrderLines Formmap');
        return OrderFormMap.persistOrderLines(mapToPersistJson,orderId,attributes);
    }
    
     @AuraEnabled
     public static OrgDefaults__c getCustomSettings()
    {
       OrgDefaults__c restVarblesObj= OrgDefaults__c.getOrgDefaults();
     	return restVarblesObj;
    }
   /* @AuraEnabled 
    public static Object setPackagePricingFlag1(Object conMap){
        System.debug('inside setPackagePricingFlag Formmap--------->'+Json.serialize(conMap));
        Map<String,Object>  packMap = (Map<String,Object>)Json.deserializeUntyped(Json.serialize(conMap));
        
        // Map<String,Object> value= packMap[i];
        System.debug('inside setPackagePricingFlag Formmap----value----->'+packMap);
        String key= (String)packMap.get('key');
        List<PackageController.QuoteLineItemPkgWrapper> qlPrd= (List<PackageController.QuoteLineItemPkgWrapper>)Json.deserialize(Json.serialize(packMap.get('value')),List<PackageController.QuoteLineItemPkgWrapper>.class);
        boolean flag = false;
        for(PackageController.QuoteLineItemPkgWrapper prd : qlPrd){
             System.debug('prd-prd.Is_package--->'+prd.Is_package+'---'+prd.name);
                System.debug('prd---pricing->'+prd.rcvariableprice+'--'+prd.nrcvariableprice+'--'+prd.rcnetprice+'--'+prd.nrcnetprice);
            if(prd!=null && prd.Is_Package != null){
               
                if(prd!= null && prd.Is_Package && (prd.rcvariableprice != null || prd.nrcvariableprice !=null || prd.rcnetprice !=null || prd.nrcnetprice !=null)){
                    flag= true;
                }
            }
        }
        System.debug('flag----->'+flag);
        for(PackageController.QuoteLineItemPkgWrapper prd : qlPrd){
            System.debug('prd----->'+prd.name +'----'+prd.packagedPriced);
            if(prd!=null && prd.packagedPriced == null)
            {
                prd.packagedPriced= flag;
            }
        }
        Map<String,Object> finalMap= new Map<String,Object>();
        finalMap.put('key',key);
        finalMap.put('value',qlPrd);
        System.debug('inside setPackagePricingFlag Formmap----value--after--->'+Json.serializePretty(finalMap));
        return finalMap;
    } */

    
   /* @AuraEnabled 
    public static void setPackagePricingFlag(Object conMap){
        System.debug('inside setPackagePricingFlag Formmap--------->'+Json.serialize(conMap));
        Map<String,Object>  packMap = (Map<String,Object>)Json.deserializeUntyped(Json.serialize(conMap));
        
        // Map<String,Object> value= packMap[i];
        System.debug('inside setPackagePricingFlag Formmap----value----->'+packMap);
        String key= (String)packMap.get('key');
        List<Object> qlPrd= (List<Object>)packMap.get('value');
         List<Object> qlPrdNew= new List<Object>();
        Map<String ,boolean> evMap= new Map<String,boolean>();
        boolean flagPkg = false;
        for(Integer i=0;i<=qlPrd.size();i++){
            if(qlPrd[i] instanceof PackageController.QuoteLineItemPkgWrapper){
                PackageController.QuoteLineItemPkgWrapper pkgProd=(PackageController.QuoteLineItemPkgWrapper)Json.deserialize(Json.serialize(qlPrd[i]),PackageController.QuoteLineItemPkgWrapper.class);
                if(pkgProd!= null && (pkgProd.rcvariableprice != null || pkgProd.nrcvariableprice !=null || pkgProd.rcnetprice !=null || pkgProd.nrcnetprice !=null)){
                    evMap.put(pkgProd.productOfferingId,true);
                }
            }else{
              evMap= processBigMap(qlPrd[i] ,evMap);
            }
        }
      
        System.debug('inside evMap--->'+Json.serializePretty(evMap));
      
    } 
    
    public static  Map<String ,boolean>  processBigMap(Object valueMap, Map<String ,boolean> evMap){
        Map<String,Object>  qlPrdMap = (Map<String,Object>)Json.deserializeUntyped(Json.serialize(valueMap)); 
        List<Object> objMap= (List<Object>)qlPrdMap.get('value');
        for(Integer j=0;j<= objMap.size();j++){
            if(objMap[j] instanceof PackageController.QuoteLineItemPkgWrapper){
                PackageController.QuoteLineItemPkgWrapper pkgProd=(PackageController.QuoteLineItemPkgWrapper)Json.deserialize(Json.serialize(objMap[j]),PackageController.QuoteLineItemPkgWrapper.class);
                if(pkgProd!= null && (pkgProd.rcvariableprice != null || pkgProd.nrcvariableprice !=null || pkgProd.rcnetprice !=null || pkgProd.nrcnetprice !=null)){
                    evMap.put(pkgProd.productOfferingId,true);
                }
            }else{
                evMap= processBigMap(objMap[j] ,evMap);
            }
        }
        return evMap;
    }
}*/

}