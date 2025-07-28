/*
 * DummyJSONCallout Class Description:
 * 
 * This class, DummyJSONCallout, facilitates HTTP callouts to an external system (presumably 'DummyJsonUser' in this context) 
 * to either fetch or send user information based on a given identifier. The class supports both GET (to fetch data) 
 * and POST (to send data) operations.
 * 
 * Overview of HTTP Callouts:
 * 
 * HTTP callouts are a way for Salesforce to communicate with external systems using HTTP protocols. Through HTTP callouts, 
 * you can invoke external web services, collect data from them, or send data for further processing. Apex provides 
 * classes that enable you to both send and receive HTTP data. The primary classes for this are `HttpRequest`, which 
 * represents the request you're sending, and `HttpResponse`, which represents the response you receive.
 * 
 * Best Practices:
 * 1. Handle Exceptions: Always handle exceptions that might be thrown, to ensure your code doesn't break unexpectedly.
 * 2. Named Credentials: Use Named Credentials to store endpoint URLs and authentication details securely.
 * 3. Test Callouts: Use mock classes and interfaces to test HTTP callouts without making actual callouts.
 * 
 * For more detailed information on HTTP callouts in Apex, refer to the official Salesforce documentation: 
 * https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_classes_restful_http_httprequest.htm
 */

public with sharing class DummyJSONCallout {
	private static final Integer TIMEOUT = 12000;
	/* 
	 * Question 1
     * Fetches user information from an external system https://dummyjson.com/user/{id} ('DummyJsonUser') based on the provided dummy user ID. 
     * If the callout is successful and returns an HTTP status of 200, the method will update a contact based on the DummyJSON_Id__c with the data returned from the external system.
	 * Use the createContactFromJson method to parse the JSON response and create a Salesforce Contact object.
     * Documentation: https://dummyjson.com/docs/users
	 * This callout method should work in triggers
	 * 
     * @param dummyUserId The ID of the user in the external system to fetch data for.
     */
	@future(callout=true)
	public static void getDummyJSONUserFromId(String dummyUserId) {
		// Create HTTP request to send.
		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.
		// Set the HTTP method to GET.
		// Send the HTTP request and get the response.
		// If the HTTP response code is successful, parse the JSON response and update the contact.
		 Http h = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:DummyJsonNamedCredential' + '/' + dummyUserId);
    request.setMethod('GET');
    request.setTimeout(TIMEOUT);
    HttpResponse resp = h.send(request);
    ApiResponse apiResponse = new ApiResponse(resp);
	if(apiResponse.isSuccess){
		Contact cont = createContactFromJson(apiResponse.body);
		cont.DummyJSON_Id__c = dummyUserId;
	upsert cont DummyJSON_Id__c; //insert/update from the JSON response using the external id (dummyUserId)
	} else {
		throw new ApiResponseException(apiResponse.body);
	}
	}
	/* 
	 * Question 2
     * Transforms a JSON response from the external system https://dummyjson.com/users into a Salesforce Contact object.
     * The method parses the JSON string to extract user details and map them to a Salesforce Contact object.
     * The contact fields populated from the JSON include Email, Phone, Birthdate, and various address-related fields.
     * The method is primarily designed to work in conjunction with callouts that fetch user details from the external system. 
	 * 
	 * Fields from JSON used to populate Salesforce Contact
	 * Fields: Email, Phone, Birthdate, MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry
	 * 
     * Documentation: https://dummyjson.com/docs/users
     * 
     * @param String jsonResponse The JSON string from the external system that contains user details.
     * @return Contact The Salesforce Contact object populated with details from the JSON string.
     */
	@TestVisible // Allows test class to see this method. Since it is private, it would not be visible otherwise.
private static Contact createContactFromJson(String jsonResponse) {
    ContactDTO.ContactObj newContactObj = (ContactDTO.ContactObj) JSON.deserialize(jsonResponse, ContactDTO.ContactObj.class);	
    Contact cont = new Contact();
    cont.FirstName = newContactObj.firstName;
    cont.LastName = newContactObj.lastName;
    cont.Email = newContactObj.email;
    cont.Birthdate = Date.valueOf(newContactObj.birthDate);  // Changed from 'birthdate' to 'birthDate'
    cont.Phone = newContactObj.phone;
    ContactDTO.AddressObj newAddrObj = newContactObj.address;
    cont.MailingStreet = newAddrObj.address;
    cont.MailingCity = newAddrObj.city;
    cont.MailingPostalCode = newAddrObj.postalCode;
    cont.MailingState = newAddrObj.state;
    cont.MailingCountry = newAddrObj.country;
    return cont;
}

	/* 
	 * Question 3
     * Sends Contact information to an external system https://dummyjson.com/users/add ('DummyJsonUser') to create or update a user based on the provided Salesforce Contact ID.
     * The method prepares a JSON payload with the contact's information and sends it to the 'DummyJsonUser' add endpoint.
     * If the callout is successful (HTTP status code between 200 and 299), the method updates the contact's 'DummyJSON_Last_Updated__c' field in Salesforce to the current time.
	 * Salesforce Contact should be used to generate the JSON payload
	 * Fields: Id, FirstName, LastName, Email, Phone
	 * This callout method should work in triggers
	 * 
     * Documentation: https://dummyjson.com/docs/users
     * 
     * @param contactId The Salesforce Contact ID used to generate the JSON payload for the external system.
     */
	@future(callout=true)
	public static void postCreateDummyJSONUser(String contactId) {
		// Create HTTP request to send.
		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.
		// Set the HTTP method to POST.
		// Set the body using generateDummyJsonUserPayload method.
		// Send the HTTP request and get the response.
		// If the HTTP response code is successful, update the contact.
	Http h = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:DummyJsonNamedCredential' + '/add');
    request.setMethod('POST');
	request.setBody(generateDummyJsonUserPayload(contactId));
	request.setTimeout(TIMEOUT);
	HttpResponse response = h.send(request);
	ApiResponse apiResponse = new ApiResponse(response);
	if (apiResponse.isSuccess) {
		Contact contactToUpdate = [SELECT Id, DummyJSON_Last_Updated__c FROM Contact WHERE Id = :contactId WITH USER_MODE LIMIT 1];
		contactToUpdate.DummyJSON_Last_Updated__c = System.now();
		update contactToUpdate;
	} else {
		throw new ApiResponseException(apiResponse.body);
	}
}
	/*
	 * Question 4
     * Generates a JSON payload based on a Salesforce Contact's fields to be sent to an external system https://dummyjson.com/users/add for user creation or update.
     * The method queries a contact from Salesforce based on the provided contactId and maps its fields into a JSON payload.
     * The fields from Salesforce Contact that are transformed into the JSON payload include Id, FirstName, LastName, Email, and Phone.
     * The generated JSON payload can be sent to the external system for various operations like creating or updating a user.
	 * 
	 * Fields from Salesforce Contact used to generate JSON payload:
	 * Fields: Id => salesforceId, FirstName => firstName, LastName => lastName, Email => email, Phone => phone
	 * 
     * Documentation: https://dummyjson.com/docs/users
     * 
     * @param String contactId The Salesforce Contact ID used to fetch the contact's fields and generate the JSON payload.
     * @return String The JSON string payload that represents the Contact's details.
     */
	@TestVisible // Allows test class to see this method. Since it is private, it would not be visible otherwise.
	private static String generateDummyJsonUserPayload(String contactId) {
		// Query the contact to get the field values to generate the JSON payload.
		// Create a map of the field values.
		// Serialize the map into a JSON string.
		// Make sure to check that required contacts fields have a value. Default the value to unknown if it does not exists.
		// Integration data can change over time. It is a best practice to add safeguards/validation to ensure the integration does not break.
Map<Id, Contact> conLst = new Map<Id, Contact>([
        SELECT Id, FirstName, LastName, Email, Phone, MailingStreet, MailingCity, 
               MailingPostalCode, MailingState, MailingCountry, DummyJSON_Id__c
        FROM Contact 
        WHERE Id = :contactId 
        WITH USER_MODE 
    ]);
    
    if (conLst.values().size() == 0) {
        throw new ApiResponseException('Contact not found');
    } else {
        Contact newCon = conLst.values()[0];
        ContactDto.ContactObj conObj = new ContactDto.ContactObj();
        conObj.id = newCon.DummyJSON_Id__c;
		conObj.salesforceId = newCon.Id;
        conObj.firstName = newCon.FirstName ?? 'Unknown';
        conObj.lastName = newCon.LastName ?? 'Unknown';
        conObj.email = newCon.Email ?? 'unknown@email.com';
        conObj.phone = newCon.Phone ?? '0000000000';

        ContactDto.AddressObj addressObj = new ContactDto.AddressObj();
        conObj.address = addressObj;
        addressObj.address = newCon.MailingStreet ?? 'Unknown Street';
        addressObj.city = newCon.MailingCity ?? 'Unknown City';
        addressObj.postalCode = newCon.MailingPostalCode ?? '00000';
        addressObj.state = newCon.MailingState ?? 'Unknown State';
        addressObj.country = newCon.MailingCountry ?? 'Unknown Country'; 
        
        return JSON.serialize(conObj, true);
    }
}
	
}