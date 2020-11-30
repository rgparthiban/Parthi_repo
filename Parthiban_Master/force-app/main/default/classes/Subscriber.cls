public class Subscriber {
/*
 subid  	SIid	productid	Parentid 	Rootid		name				 RootFlag    ChildFlag
12		SI123		P123		--		 ---	HOBsOBs mobile plan	   Y
123		SI124		P126		SI123	 SI123	 Data bundle                        Y
124		SI125		D128		SI124	 SI123	    Data 1GB	 	                Y
32		SI126		V1234		SI123	 SI123   Voice bundle						Y
1231	SI127		V23			SI126	 SI123      voice 5GB						Y


In Asset table:: Serviceid,parentid, rootid,subscriberid,assetparentupdated,assetrootupdated
In subscriber_dump table:: Serviceid,parentid, rootid,subscriberid,assetparentupdated,assetrootupdated
In subscriber_new table: subscriberid, name (auto-generated),creted date, accountid, contactid

if not exists(select subscriberid from subscriber where HOBsSubscriberid = i/p-subscriberid)
insert subscriber - subscriberid, name (auto-generated),creted date, accountid, contactid

insert asset with all asset details and assetparentupdate ='n',assetrootupdated ='n';

//updating parent and rootasset id;
list<asset> assetinfo = [select assetid,parentid,rootid,name from asset where subscriberid = subscriberid and assetupdated ='N' ]

Map<id,asset> input = new Map<id,asset>
for (asset ass : assetinfo)
{
if (select SFDCassetid from asset where SIid  = ass.parentid and subscriberid = subscriberid)
{
ass.sfdcparentid = SFDCassetid;
ass.assetparentupdated = 'Y'
}
if (select SFDCrootassetid from asset where paerntid is null and rootid is null and subscriberid = subscriberid)
{
	ass.sfdcrootid = SFDCrootassetid;
	ass.assetrootupdated = 'Y'
}
update ass;
}
//updating rootasset id;
if (select SFDCrootassetid from asset where paerntid is null and rootid is null and subscriberid = subscriberid)
{
	for(select id,assetrootid,assetrootupdated from asset where sfdcparentid is not null and assetrootupdated = 'n' and subscriberid = subscriberid)
	{
	  ass.assetrootid = sfdcrootassetid,
	  ass.assetrootupdated = 'Y'
	}
	update ass;
}

 */
}