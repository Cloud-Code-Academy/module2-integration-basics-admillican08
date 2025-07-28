public with sharing class ContactTriggerHandler {
    

    private static Boolean insertHasExecuted = false;
    private static Boolean updateHasExecuted = false;
    
      public static void handleBeforeInsert(List<Contact> newContacts) {
        if (insertHasExecuted) {
            return;
        } 
        else {
            for (Contact contact : newContacts) {
			    if (String.isBlank(contact.DummyJSON_Id__c)) {
				    Integer randomNumber = Integer.valueOf(Math.random() * 101);
                    String newId = String.valueOf(randomNumber);
				    contact.DummyJSON_Id__c = newId;
			    }	
            }
        }
    }
    
    public static void handleAfterInsert(Map<Id, Contact> newContactMap) {
        if (insertHasExecuted) {
            return;
        }
        else {
            for (Contact contact : newContactMap.values()) {
                if (!String.isBlank(contact.DummyJSON_Id__c) &&  Integer.valueOf(contact.DummyJSON_Id__c) <=100 && !System.isFuture() && !System.isQueueable()) {
                    // Queue job to fetch user data from DummyJSON API
                    System.enqueueJob(new GetDummyJsonUserQueueable(contact.DummyJSON_Id__c)); 
                }
            }
             insertHasExecuted = true;
        }
    
    }
     public static void handleAfterUpdate(Map<Id, Contact> newContactMap){
        if (updateHasExecuted) {
            return;
        }
        else {
          for (Contact contact : newContactMap.values()) {
                if (!String.isBlank(contact.DummyJSON_Id__c) &&  Integer.valueOf(contact.DummyJSON_Id__c) <=100 && !System.isFuture() && !System.isQueueable()) {
                     System.enqueueJob(new CreateDummyJsonUserQueueable(contact.Id));
                }
            }
        updateHasExecuted = true;
        }
    }
}