public with sharing class CreateDummyJsonUserQueueable implements Queueable, Database.AllowsCallouts{
    public String contactId {get; private set;}
    
    public CreateDummyJsonUserQueueable(String contactId){
        this.contactId = contactId;
    }
    public void execute(QueueableContext context){
        DummyJSonCallout.postCreateDummyJSONUser(this.contactId);
    }

}
