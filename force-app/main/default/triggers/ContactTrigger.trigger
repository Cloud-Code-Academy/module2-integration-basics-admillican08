trigger ContactTrigger on Contact (before insert, after insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert){
		ContactTriggerHandler.handleBeforeInsert(Trigger.new);
	}
	else if(Trigger.isAfter && Trigger.isInsert){
		ContactTriggerHandler.handleAfterInsert(Trigger.newMap);
        } 
	else if (Trigger.isAfter && Trigger.isUpdate) {
            ContactTriggerHandler.handleAfterUpdate(Trigger.newMap);
        }
}