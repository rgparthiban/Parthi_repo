trigger Triggerduplicate on Account (before insert, before update,before delete) {
   
    if (trigger.isinsert)
    {
        for (account acc : trigger.new)
        {
            List<Account> acclist = [Select id from Account where Name=:acc.Name and Rating=:acc.Rating];
            if (acclist.size() >0)
            {
                acc.Name.adderror ('duplicate name captured');        	
            }
            
        }
	}
    if (trigger.isDelete)
    {
        for (account acc: trigger.old)
        {            
            if (acc.SLAExpirationDate__c > Date.today())
            {
                acc.SLAExpirationDate__c.adderror ( 'cant delete since SLA is not expired');
            }
        }
    }
    
}