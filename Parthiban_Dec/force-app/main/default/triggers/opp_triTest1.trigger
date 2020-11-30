trigger opp_triTest1 on Opportunity (before insert,before update) {
for (opportunity  o: trigger.new)
{
 if(o.amount <10000 && trigger.isinsert)
 {
     o.addError('Please enter greater than 10000');
 } else if(o.amount <20000 && trigger.isupdate)
 {
     o.addError('Please enter lessthan 20000');
 }
}
}