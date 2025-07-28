public with sharing class GetDummyJsonUserQueueable implements Queueable, Database.AllowsCallouts{
    public String extId {get; private set;}
    
    public GetDummyJsonUserQueueable(String extId){
        this.extId = extId;
    }
    public void execute(QueueableContext context){
        DummyJSonCallout.getDummyJSONUserFromId(this.extId);
    }

}
