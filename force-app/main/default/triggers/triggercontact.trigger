trigger triggercontact on Account (after insert) {
List<contact>con = new List<contact>();
    map<id,decimal>mapacc = new map<id,decimal>();
    
    for(account ac:trigger.new)
    {
        mapacc.put(ac.id,ac.NumberofLocations__c);
    }
    if (mapacc!=null && mapacc.size()>0)
    {
        for(id accid:mapacc.keySet())
        {
            for (integer i=0;i<mapacc.get(accid);i++)
            {
                contact c = new contact();
                c.accountid= accid;
                c.FirstName = 'Person'+i;
                c.LastName ='person last'+i;
                con.add(c);
            }
        }
        
    }
    if (con!=null && con.size()>0)
        insert(con);
}