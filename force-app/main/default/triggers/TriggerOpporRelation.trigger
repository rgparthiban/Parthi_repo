trigger TriggerOpporRelation on customerobject__c (after insert) {
List<opportunity> opp = new List<opportunity>();
    for(customerobject__c cust: trigger.new)
    {
        if (cust.Active__c == true)
        {
        opportunity op = new opportunity(id = cust.id__c);
          op.Active_Customer_project__c = true;
            opp.add(op);
            }
    }
    update opp;
}