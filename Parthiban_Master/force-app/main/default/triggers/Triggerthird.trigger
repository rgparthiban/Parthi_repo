trigger Triggerthird on Account (before insert,before update) {
    
    if (trigger.isinsert)
    {
    for(Account ac:trigger.new)
    {
        ac.Rating = 'Hot';
        ac.phone = '044-38343';
    }
    }
    if (trigger.isupdate)
    {
        List<account>acountnew = trigger.new;
        for(Account acc:acountnew)
    	{
        	acc.Rating = 'Warm';
        	acc.phone = '044-58545';
    	}
    } 
}