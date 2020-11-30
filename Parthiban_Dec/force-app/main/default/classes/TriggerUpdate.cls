public class TriggerUpdate {
    public void updatevalue(List<account> acc){
        for(Account ac:acc)
        {
            if (ac.Type != 'Prospect')
                ac.type = 'prospect';
        }
    }
}