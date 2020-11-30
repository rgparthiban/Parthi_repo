trigger TriggerDeleteValidate on Account (before insert) {
    List<account> acc = trigger.new;
    TriggerUpdate tri = new TriggerUpdate();
    tri.updatevalue(acc);
}