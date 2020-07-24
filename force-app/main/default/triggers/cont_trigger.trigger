trigger cont_trigger on Contact (before delete) {
for (contact c:trigger.old)
{
if (c.Account == null)
c.adderror('Cant delete');
}

}