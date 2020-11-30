trigger TriggerAsset on Account (After insert) {
 /*Asset assetDetails = new Asset();  
    string RootId ;
    List<com_tcs_telecom__Subscriber__c> sub = new List<com_tcs_telecom__Subscriber__c>();
    //added for PMD fix- apex crud violation by RIMI
    if(!Schema.sObjectType.com_tcs_telecom__Subscriber_temp__c.fields.com_tcs_telecom__Product_Type_ID__c.isAccessible())
       {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
       }
     com_tcs_telecom__Subscriber_temp__c subtemp = [SELECT 	com_tcs_telecom__Subscriber_ID__c,com_tcs_telecom__Service_Instance_ID__c,
                                                    com_tcs_telecom__Product_Type_ID__c,com_tcs_telecom__subscriberInstanceId__c,
                                                    com_tcs_telecom__Product_Desc__c,com_tcs_telecom__Offer_Instance_Id__c,
                                                    com_tcs_telecom__Product_ID__c, com_tcs_telecom__Account_Id__c,
                                                    com_tcs_telecom__Service_Type__c,com_tcs_telecom__ProductCount__c,
                                                    com_tcs_telecom__Customer_Id__c,com_tcs_telecom__Asset_Start_Date__c,
                                                    com_tcs_telecom__Asset_End_Date__c,com_tcs_telecom__Status__c
                                                    FROM com_tcs_telecom__Subscriber_temp__c WHERE Id IN :Trigger.New];
   
    //added for PMD fix- apex crud violation by RIMI
    if(!Schema.sObjectType.com_tcs_telecom__Subscriber__c.fields.com_tcs_telecom__SubscriberId__c.isAccessible()&&
    	!Schema.sObjectType.com_tcs_telecom__Subscriber__c.fields.com_tcs_telecom__SubscriberId__c.isCreateable())
       {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
       }
    sub = [SELECT com_tcs_telecom__SubscriberId__c from com_tcs_telecom__Subscriber__c 
           where com_tcs_telecom__SubscriberId__c =: subtemp.com_tcs_telecom__Subscriber_ID__c];
    
    if (sub.size() ==0)
    {
        com_tcs_telecom__Subscriber__c subnew = new com_tcs_telecom__Subscriber__c(com_tcs_telecom__SubscriberId__c = subtemp.com_tcs_telecom__Subscriber_ID__c,
                                                                                  com_tcs_telecom__Account__c = [Select Id from Account where id =: subtemp.com_tcs_telecom__Customer_Id__c Limit 1].Id,
                                                                                  com_tcs_telecom__Billing_Account__c = [Select Id from com_tcs_telecom__Billing_Account__c where id =: subtemp.com_tcs_telecom__Account_Id__c Limit 1].Id);
        insert(subnew);
    }
    //added for PMD fix- apex crud violation by RIMI
    if(!Schema.sObjectType.Asset.fields.com_tcs_telecom__ProductTypeId__c.isCreateable())
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
      }
    assetDetails.com_tcs_telecom__assetrootupdated__c = 'N';
    assetDetails.com_tcs_telecom__OfferInstanceId__c = subtemp.com_tcs_telecom__Offer_Instance_Id__c;
    assetDetails.com_tcs_telecom__SubscriberInstanceId__c = subtemp.com_tcs_telecom__subscriberInstanceId__c;
    assetDetails.com_tcs_telecom__ProductTypeId__c = subtemp.com_tcs_telecom__Product_Type_ID__c;
    assetDetails.Name = subtemp.com_tcs_telecom__Product_Desc__c;
        assetDetails.com_tcs_telecom__subscriberid__c = subtemp.com_tcs_telecom__Subscriber_ID__c;
    assetDetails.Product2Id = [Select Id from product2 where ExternalId =: subtemp.com_tcs_telecom__Product_ID__c Limit 1].Id;
    System.debug('subtemp.com_tcs_telecom__Customer_Id__c...'+subtemp.com_tcs_telecom__Customer_Id__c);
   
        assetDetails.AccountId =  subtemp.com_tcs_telecom__Customer_Id__c;
    assetDetails.InstallDate = subtemp.com_tcs_telecom__Asset_Start_Date__c;
    assetDetails.UsageEndDate = subtemp.com_tcs_telecom__Asset_End_Date__c;
    assetDetails.Status = subtemp.com_tcs_telecom__Status__c;
    	system.debug('subtemp.com_tcs_telecom__Account_Id__c.. '+subtemp.com_tcs_telecom__Customer_Id__c);
    	
    if (subtemp.com_tcs_telecom__Product_Type_ID__c == 'PACKAGE')
        {
            assetDetails.ParentId = null;              
        }
   
  		insert(assetDetails);    
    */
   
}