trigger UpdateAsset on Account (After insert) {

   /* string count;
    string subscriberId;
    string RootId ;
    Integer CurrentCount;   
    for (Asset assobj:Trigger.new)
    {
        count = [Select com_tcs_telecom__ProductCount__c from com_tcs_telecom__Subscriber_temp__c 
             where com_tcs_telecom__Subscriber_ID__c  =: assobj.com_tcs_telecom__subscriberid__c limit 1].com_tcs_telecom__ProductCount__c;
        subscriberId = assobj.com_tcs_telecom__subscriberid__c;
       if(!Schema.sObjectType.Asset.fields.Id.isAccessible())
       {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
       }
        //String JSONString = JSON.serialize(Database.Query('Select count(id) from Asset where com_tcs_telecom__subscriberid__c  =: assobj.com_tcs_telecom__subscriberid__c  Group by com_tcs_telecom__subscriberid__c'));
        AggregateResult obj =[Select count(Id)totalcount from Asset 
                        where com_tcs_telecom__subscriberid__c  =: assobj.com_tcs_telecom__subscriberid__c 
                        Group by com_tcs_telecom__subscriberid__c];
        CurrentCount = (integer)obj.get('totalcount');
        
        System.debug ('currentcount:'+CurrentCount);
        System.debug ('Actualcount:'+count);
        
    }
    
    
    if (count == string.valueOf(CurrentCount))
    {
        System.debug('Entry ok');
        RootId = [Select RootAssetId from Asset where com_tcs_telecom__subscriberid__c =: subscriberId 
                  and com_tcs_telecom__ProductTypeId__c =:'PACKAGE' limit 1].RootAssetId;
        
        List<Asset> assList = new List<Asset>();
        map<id,Asset> assmap = new map<id,Asset>();
       
        string parentid;        
        for(Asset assobj: [Select Id,com_tcs_telecom__OfferInstanceId__c,com_tcs_telecom__SubscriberInstanceId__c,
           com_tcs_telecom__ProductTypeId__c,RootAssetId from Asset where com_tcs_telecom__subscriberid__c =: subscriberid
                          And com_tcs_telecom__ProductTypeId__c !=:'PACKAGE'])
        {           
            system.debug('Asset Id'+assobj.Id);
             Asset assUpdate = new Asset();
            assUpdate.Id = assobj.Id;
           if(!Schema.sObjectType.Asset.fields.Id.isAccessible())
           {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
           }
            Asset[] assParentId = [Select id from Asset where
                                   com_tcs_telecom__subscriberid__c =: subscriberid And
                                   com_tcs_telecom__SubscriberInstanceId__c =:assobj.com_tcs_telecom__OfferInstanceId__c];
            if (assParentId.size()>0){
                parentid = assParentId[0].Id;
                
            }
                

            
          
                if (string.isNotBlank(parentid))
                {
                    //updating parentid for child                     
                	assupdate.ParentId = parentid;
                    parentid = '';
                }
                else
                {
                    //no direct parent so updating root id as parent id even for multiple package come under one subscriber.
                	assupdate.ParentId = [Select RootAssetId from Asset where com_tcs_telecom__subscriberid__c =: subscriberId 
                                          and com_tcs_telecom__ProductTypeId__c =:'PACKAGE'  
                                          and com_tcs_telecom__OfferInstanceId__c =: assobj.com_tcs_telecom__OfferInstanceId__c].RootAssetId;
                    
                    //assupdate.ParentId = RootId;
                }
                
           
            assList.add(assupdate);
            System.debug('assupdate::'+Json.serialize(assupdate));
            
        }
        
        assmap.putall(assList);
        if(assmap.size()>0){
            update assmap.values();
            }
        //update assList; 
       // productCountStatic.ProductCount = 1;
        
    }*/
}