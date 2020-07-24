trigger fillopporpicklist on Opportunity (before insert,before update) {
    
   Set<Id> ownerIds = new Set<Id>();
    for(Opportunity o : trigger.new){
        ownerIds.add(o.OwnerId);
    }
    Map<Id,User> ownerMap = new Map<Id,User>([Select Id, Country From User] 
                                              );
    for (opportunity o:trigger.New)
    {
        o.multiservices__c = ownerMap.get(o.OwnerId).Country;
    }

}