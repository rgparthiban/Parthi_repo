trigger fillopporpick on Opportunity (before insert) {
    Set<Id> ownerIds = new Set<Id>();
    for(Opportunity o : trigger.new){
        ownerIds.add(o.OwnerId);
    }
     Map<Id,User> ownerMap = new Map<Id,User>([Select Id, Country From User ]);
    for(Opportunity o : trigger.new){
        o.multiservices__c =  ownerMap.get(o.OwnerId).Country;
        System.debug(ownerMap.get(o.OwnerId).Country);
    }
}