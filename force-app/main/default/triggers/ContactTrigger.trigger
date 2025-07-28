/**
 * ContactTrigger Trigger Description:
 * 
 * The ContactTrigger is designed to handle various logic upon the insertion and update of Contact records in Salesforce. 
 * 
 * Key Behaviors:
 * 1. When a new Contact is inserted and doesn't have a value for the DummyJSON_Id__c field, the trigger generates a random number between 0 and 100 for it.
 * 2. Upon insertion, if the generated or provided DummyJSON_Id__c value is less than or equal to 100, the trigger initiates the getDummyJSONUserFromId API call.
 * 3. If a Contact record is updated and the DummyJSON_Id__c value is greater than 100, the trigger initiates the postCreateDummyJSONUser API call.
 * 
 * Best Practices for Callouts in Triggers:
 * 
 * 1. Avoid Direct Callouts: Triggers do not support direct HTTP callouts. Instead, use asynchronous methods like @future or Queueable to make the callout.
 * 2. Bulkify Logic: Ensure that the trigger logic is bulkified so that it can handle multiple records efficiently without hitting governor limits.
 * 3. Avoid Recursive Triggers: Ensure that the callout logic doesn't result in changes that re-invoke the same trigger, causing a recursive loop.
 * 
 * Optional Challenge: Use a trigger handler class to implement the trigger logic.
 */
trigger ContactTrigger on Contact(before insert, after insert, after update) {
	public static Boolean insertHasRun =  false;
	public static Boolean updateHasRun = false;
	Integer randomNumber = Integer.valueOf(Math.random() * 101);
		// if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
	if (
		Trigger.isInsert &&
		Trigger.isBefore &&
		!insertHasRun){
			for (Contact contact : Trigger.new) {
			if (String.isBlank(contact.DummyJSON_Id__c)) {
				String newId = String.valueOf(randomNumber);
				contact.DummyJSON_Id__c = newId;
			}			
		}
	}
//When a contact is inserted
	// if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API

		if(Trigger.isInsert &&
		Trigger.isAfter &&
		!insertHasRun){
			for (Contact contact : Trigger.new) {
			if (!String.isBlank(contact.DummyJSON_Id__c) &&  Integer.valueOf(contact.DummyJSON_Id__c) <= 100 &&  !System.isFuture() && !System.isBatch()) {
				DummyJSonCallout.getDummyJSONUserFromId(contact.DummyJSON_Id__c);
			}			
		}
			insertHasRun = true;
	}
	//When a contact is updated
	// if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
		if(Trigger.isUpdate &&
		Trigger.isAfter &&
		!updateHasRun){
			for (Contact contact : Trigger.new) {
			if (!String.isBlank(contact.DummyJSON_Id__c) &&  Integer.valueOf(contact.DummyJSON_Id__c) >100 &&  !System.isFuture() && !System.isBatch()) {
				DummyJSonCallout.postCreateDummyJSONUser(contact.Id);
			}			
		}
			updateHasRun = true;
	}
}


	
	
