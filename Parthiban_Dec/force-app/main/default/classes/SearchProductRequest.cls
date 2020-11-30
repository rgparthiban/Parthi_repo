public class SearchProductRequest {
 /*  static OrgDefaults__c configGlobal =OrgDefaults__c.getvalues('RestVariables');
    
    
    public static void setOrgDefaults(OrgDefaults__c orgDefaults){
        System.debug('inside setter of prodprice json');
        configGlobal = orgDefaults;
    }
    
    public static OrgDefaults__c getOrgDefaults()
    {
        return configGlobal;
    }
    
    
    public String interactionID;
    public DateTime interactionDate;
    public String sourceApplicationID;
    public String serviceName;
    public String triggeredBy;
    public String uuid;
    public String password;
    public String channel;
    public String opID;
    public String buID;
    public String pcFilter;
    public String offerPolicy;
    public String offerability;
    public String offerabilityCriteria;
    //public String searchProductActionId;
       public SearchProductRequest() {
         //Reading DNA config details from custom setting object(OrgDefaults__c).
        //OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
        OrgDefaults__c config =getOrgDefaults();
        System.debug(config);
        
        this.interactionID='TestPCFilter-911';
        this.interactionDate=System.now(); 
        this.sourceApplicationID ='devtest';
        this.serviceName='searchProducts';
        this.triggeredBy=config.triggeredBy__c;//'dev';
        this.uuid=config.uid__c;
        this.password=config.pwd__c;
        this.channel=config.channelID__c;//'CSA';// COCO
        //this.searchProductActionId=config.searchProductActionId__c; 
        
     
        this.opID='HOB';
        this.buID='DEFAULT';
        this.pcFilter='offerPolicy';
        this.offerPolicy='****';
        this.offerability='====';
        this.offerabilityCriteria='+++++';
        
       }
        
     
    
    public String generateJson(List<Param_Configure__c>paramList,String srvcCatg){
        
         
       
         //OrgDefaults__c config =OrgDefaults__c.getvalues('RestVariables');
        OrgDefaults__c config =getOrgDefaults();
        System.debug(config);
        System.debug('srvcCatg---'+srvcCatg);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeStringField('interactionID',this.interactionID);
            gen.writeDateTimeField('interactionDate',this.interactionDate);
            gen.writeStringField('sourceApplicationID', this.sourceApplicationID);
            gen.writeStringField('serviceName',this.serviceName);
            gen.writeStringField('triggeredBy',this.triggeredBy);
            gen.writeStringField('uuid', this.uuid);
            gen.writeStringField('password', this.password); 
            gen.writeStringField('channel', this.channel);
            gen.writeStringField('opID',this.opID);
            gen.writeStringField('buID',this.buID);
        
        
        gen.writeFieldName('serviceKeyList');
        		gen.writeStartObject();
        		gen.writeFieldName('attribute');
                                gen.writeStartArray();
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'ID');
                                       
                                    gen.writeEndObject();
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'DESC');
                                    gen.writeEndObject();
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'TYPE');
                                    gen.writeEndObject();
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'CATEGORY');
                                    gen.writeEndObject();
                                gen.writeEndArray();
         					gen.writeEndObject();
        
//DEF_CATALOG MOBILE
        		//gen.writeStringField('catalogID', 'DEF_CATALOG');
        		gen.writeFieldName('pcFilter');
        	gen.writeStartObject();
        		gen.writeFieldName('offerPolicy');
        		gen.writeStartObject();
        			gen.writeFieldName('offerability');
        			gen.writeStartArray();
        			gen.writeStartObject();
        				gen.writeFieldName('offerabilityCriteria');
        					gen.writeStartObject();
        						gen.writeFieldName('attribute');
                                gen.writeStartArray();
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'channelID');              
                                    	gen.writeStringField('attributeValue', config.channelID__c);
                                    gen.writeEndObject();
                                  
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'operatorID');
                                        gen.writeStringField('attributeValue', 'HOB');
                                    gen.writeEndObject();
                                    gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'buID');
                                        gen.writeStringField('attributeValue', 'DEFAULT');
                                    gen.writeEndObject();
        							gen.writeStartObject();
                                        gen.writeStringField('attributeName', 'serviceCatg');
                                        gen.writeStringField('attributeValue', srvcCatg);
                                    gen.writeEndObject();
       
                                    for(com_tcs_telecom__Param_Configure__c configParam:paramList){
                                        if(configParam.com_tcs_telecom__FieldName__c!=null){
                                             gen.writeStartObject();
                                             gen.writeStringField('attributeName', configParam.com_tcs_telecom__FieldName__c);
                                             gen.writeStringField('attributeValue', String.isBlank(configParam.com_tcs_telecom__FieldValue__c)?'':configParam.com_tcs_telecom__FieldValue__c);
                                             gen.writeEndObject();
                                        }
                                        
                                    }
                                gen.writeEndArray();
        					gen.writeEndObject();
        			gen.writeEndObject();
       	 		gen.writeEndArray();
        	gen.writeEndObject();
        gen.writeEndObject();
        List<String> lst = new List<String>();
lst.add('ID');
lst.add('DESC');
lst.add('CATEGORY');
        lst.add('TYPE');
        gen.writeObjectField('searchString', lst);

        gen.writeEndObject();

        
        String jsonString = gen.getAsString();
        System.debug('jsonString request neww:'+jsonString);
        return jsonString;
        
    }*/
}