public class RandomNameGenerator {
    
    // Lists of common first names
    private static final List<String> FIRST_NAMES = new List<String>{
        'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
        'William', 'Elizabeth', 'David', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica',
        'Thomas', 'Sarah', 'Charles', 'Karen', 'Christopher', 'Nancy', 'Daniel', 'Lisa',
        'Matthew', 'Betty', 'Anthony', 'Helen', 'Mark', 'Sandra', 'Donald', 'Donna',
        'Steven', 'Carol', 'Paul', 'Ruth', 'Andrew', 'Sharon', 'Joshua', 'Michelle',
        'Kenneth', 'Laura', 'Kevin', 'Sarah', 'Brian', 'Kimberly', 'George', 'Deborah',
        'Timothy', 'Dorothy', 'Ronald', 'Lisa', 'Jason', 'Nancy', 'Edward', 'Karen'
    };
    
    // Lists of common last names
    private static final List<String> LAST_NAMES = new List<String>{
        'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
        'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas',
        'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White',
        'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young',
        'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores',
        'Green', 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell',
        'Carter', 'Roberts', 'Gomez', 'Phillips', 'Evans', 'Turner', 'Diaz', 'Parker'
    };
    
    /**
     * Generates a random first name
     * @return String Random first name
     */
    public static String getRandomFirstName() {
        Integer randomIndex = (Integer)(Math.random() * FIRST_NAMES.size());
        return FIRST_NAMES[randomIndex];
    }
    
    /**
     * Generates a random last name
     * @return String Random last name
     */
    public static String getRandomLastName() {
        Integer randomIndex = (Integer)(Math.random() * LAST_NAMES.size());
        return LAST_NAMES[randomIndex];
    }
    
    /**
     * Generates a random full name
     * @return Map<String, String> with 'firstName' and 'lastName' keys
     */
    public static Map<String, String> getRandomFullName() {
        return new Map<String, String>{
            'firstName' => getRandomFirstName(),
            'lastName' => getRandomLastName()
        };
    }
    
    /**
     * Simple method to generate random names with prefixes (like your instructor's pattern)
     * @param prefix The prefix to add before the name (e.g., 'User', 'Test')
     * @param suffix The number to append (e.g., 1, 2, 3)
     * @return Map<String, String> with 'firstName' and 'lastName' keys
     */
    public static Map<String, String> getRandomNameWithPrefix(String prefix, Integer suffix) {
        return new Map<String, String>{
            'firstName' => getRandomFirstName() + prefix + suffix,
            'lastName' => getRandomLastName() + prefix + suffix
        };
    }
    
    /**
     * Alternative simple method - generates completely random names
     * @return Map<String, String> with 'firstName' and 'lastName' keys
     */
    public static Map<String, String> generateRandomName() {
        return new Map<String, String>{
            'firstName' => getRandomFirstName(),
            'lastName' => getRandomLastName()
        };
    }
}
