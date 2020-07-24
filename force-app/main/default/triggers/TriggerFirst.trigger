trigger TriggerFirst on Properties__c (before insert,before Update) {
    system.debug('test');
    List<Properties__c> PropertyList = trigger.new;
    
    for (Properties__c pp:PropertyList){
        if (Trigger.isInsert)
        {
            pp.PropertyName__c = pp.PropertyName__c + 'Insert';
            system.debug(pp.PropertyName__c);            
                }
            if (trigger.isUpdate)
            {
            pp.PropertyName__c = pp.PropertyName__c + 'update';
                
                }
            
            
    }

}