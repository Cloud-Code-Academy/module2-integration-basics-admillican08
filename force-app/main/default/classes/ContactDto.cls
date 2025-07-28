public with sharing class ContactDto {
    
    public class ContactObj{
        public String id {get; set;}
        public String salesforceId {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String email {get; set;}
        public String phone {get; set;}
        public String birthDate {get; set;}  // Changed from 'birthdate' to 'birthDate'
        public AddressObj address {get; set;}
    } 

    public class AddressObj{
        public String address {get; set;}
        public String city {get; set;}
        public String postalCode {get; set;}
        public String state {get; set;}
        public String country {get; set;}
    }
}