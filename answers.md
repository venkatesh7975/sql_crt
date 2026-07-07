# GLENWOOD SYSTEMS – TECHNICAL INTERVIEW PANEL CHEAT SHEET
## Java & SQL Technical Interview Question Bank Answers

### SECTION 1: JAVA FUNDAMENTALS

1. **What is the difference between JDK, JRE and JVM?**
   - **JVM (Java Virtual Machine):** An abstract machine that executes Java bytecode. It is platform-dependent.
   - **JRE (Java Runtime Environment):** Provides the libraries, JVM, and other components to run applications written in Java. (JRE = JVM + Libraries)
   - **JDK (Java Development Kit):** A software development environment used to develop Java applications. It contains JRE + development tools (compiler, debugger, etc.).

2. **Why is Java called Platform Independent?**
   - Java code is compiled into bytecode (.class file), which is platform-independent. This bytecode can be run on any platform that has a JVM, following the "Write Once, Run Anywhere" (WORA) principle.

3. **Explain Primitive and Non-Primitive Data Types with examples.**
   - **Primitive Data Types:** Predefined by the language (e.g., `int`, `char`, `float`, `boolean`). They store simple values.
   - **Non-Primitive Data Types:** Created by the programmer and not defined by Java (except String). Used to store complex objects (e.g., `String`, `Array`, `Class`).

4. **What is the difference between == operator and equals() method?**
   - `==` is an operator that compares object references (memory addresses) to check if they point to the same object.
   - `equals()` is a method that can be overridden to compare the actual values/content of the objects.

5. **What are implicit and explicit type casting?**
   - **Implicit (Widening) Casting:** Converting a smaller data type to a larger data type automatically (e.g., `int` to `long`).
   - **Explicit (Narrowing) Casting:** Manually converting a larger data type to a smaller data type (e.g., `double` to `int` using `(int) value`).

6. **Explain break, continue and return statements.**
   - `break`: Terminates the loop/switch and transfers execution to the statement immediately following it.
   - `continue`: Skips the current iteration of the loop and proceeds to the next iteration.
   - `return`: Exits from the current method and optionally returns a value to the caller.

7. **What is the difference between while loop and do-while loop?**
   - **while loop:** Checks condition before executing the loop body. (Entry-controlled)
   - **do-while loop:** Executes the loop body at least once before checking the condition. (Exit-controlled)

8. **What are command-line arguments in Java?**
   - Arguments passed to the main program at execution from the command line, stored as strings in the `String[] args` parameter of the `main()` method.

9. **Explain the switch statement. Can it work with String?**
   - A `switch` statement executes one statement from multiple conditions based on an expression's value. Yes, since Java 7, it works with `String`.

10. **What is the main() method? Why is it declared as public static void?**
    - The entry point for execution.
    - `public`: Accessible by the JVM to start execution.
    - `static`: Can be invoked without creating an instance.
    - `void`: Does not return any value.

### SECTION 2: OBJECT ORIENTED PROGRAMMING (OOPs)

1. **What are the four pillars of OOP?**
   - Encapsulation, Inheritance, Polymorphism, and Abstraction.

2. **What is the difference between Class and Object?**
   - **Class:** A blueprint or template defining properties and behaviors.
   - **Object:** An instance of a class, representing a physical entity with state and behavior.

3. **Explain Inheritance with a real-life example.**
   - A mechanism where one class acquires properties of a parent class.
   - *Example:* A `Vehicle` parent class and a `Car` child class. The `Car` inherits generic properties like wheels but has specific ones like AC.

4. **What is Method Overloading?**
   - Having multiple methods in the same class with the same name but different parameters (compile-time polymorphism).

5. **What is Method Overriding?**
   - When a subclass provides a specific implementation for a method already defined in its superclass, having the same name and parameters (run-time polymorphism).

6. **Difference between Overloading and Overriding.**
   - **Overloading:** Same class, different parameters, compile-time.
   - **Overriding:** Subclass/superclass relationship, exact same parameters, run-time.

7. **Explain Encapsulation.**
   - Wrapping data (variables) and code acting on data (methods) into a single unit. Typically achieved by making variables `private` and providing `public` getters/setters.

8. **What is Abstraction?**
   - Hiding implementation details and showing only essential functionality to the user, achieved via abstract classes and interfaces.

9. **Difference between Abstract Class and Interface.**
   - **Abstract Class:** Can have both abstract and non-abstract methods, instance variables, and constructors.
   - **Interface:** Historically only abstract methods (now default/static too), variables are `public static final`, no constructors. Multiple inheritance is allowed.

10. **What is Polymorphism? Explain compile-time and run-time polymorphism.**
    - Ability of an object to take on many forms.
    - **Compile-time:** Achieved via method overloading. Method resolved by compiler.
    - **Run-time:** Achieved via method overriding. Method resolved by JVM at runtime based on actual object type.

### SECTION 3: EXCEPTION HANDLING & PACKAGES

1. **What is an Exception?**
   - An unexpected event at runtime that disrupts the normal flow of the program.

2. **Difference between Checked and Unchecked Exceptions.**
   - **Checked:** Checked by compiler (e.g., `IOException`). Must be handled.
   - **Unchecked:** Occur at runtime (e.g., `NullPointerException`). Extend `RuntimeException`.

3. **Explain try, catch and finally blocks.**
   - `try`: Code that might throw an exception.
   - `catch`: Handles the exception.
   - `finally`: Executes crucial code (like closing resources) whether an exception occurs or not.

4. **Difference between throw and throws.**
   - `throw`: Used to explicitly throw a single exception inside a method.
   - `throws`: Used in a method signature to declare that it might throw exceptions.

5. **Can finally block be skipped?**
   - Yes, if `System.exit()` is called, or the JVM crashes.

6. **What is Exception Propagation?**
   - When an unhandled exception is passed up the call stack to the calling method until it's caught or terminates the program.

7. **How do you create a Custom Exception?**
   - By creating a class that extends `Exception` (checked) or `RuntimeException` (unchecked).

8. **What is the purpose of packages?**
   - Group related classes/interfaces, avoid name conflicts, and provide access protection.

9. **Difference between import package.* and import specific class.**
   - `.*` imports all classes in a package. Specifying a class imports only that one, improving code clarity and avoiding collisions.

10. **What happens if an exception is not handled?**
    - The JVM's default handler catches it, prints the stack trace, and abnormally terminates the program.

### SECTION 4: COLLECTIONS & STRINGS

1. **What is the Java Collections Framework?**
   - A unified architecture for representing and manipulating collections of objects (interfaces, implementations, algorithms).

2. **Difference between Array and ArrayList.**
   - **Array:** Fixed size, holds primitives and objects.
   - **ArrayList:** Dynamic size, holds only objects (primitives autoboxed).

3. **Difference between List, Set and Map.**
   - **List:** Ordered, allows duplicates.
   - **Set:** Unordered, no duplicates.
   - **Map:** Key-value pairs, unique keys.

4. **Explain HashMap.**
   - Implements `Map`, stores data in key-value pairs using hashing. Allows one null key and multiple null values, no insertion order.

5. **Difference between HashMap and Hashtable.**
   - **HashMap:** Not thread-safe, allows null key/values.
   - **Hashtable:** Thread-safe (synchronized), no null keys/values.

6. **Difference between String, StringBuffer and StringBuilder.**
   - **String:** Immutable, thread-safe.
   - **StringBuffer:** Mutable, thread-safe (synchronized), slower.
   - **StringBuilder:** Mutable, not thread-safe, faster.

7. **Why are Strings Immutable?**
   - For security, string pool memory caching, inherent thread-safety, and caching hashcodes.

8. **Explain HashSet.**
   - Implements `Set` backed by a `HashMap`. Stores unique elements, no order.

9. **Difference between Comparable and Comparator.**
   - **Comparable:** Natural sorting, modifies original class (`compareTo()`).
   - **Comparator:** Custom sorting, separate class (`compare()`), allows multiple sorting sequences.

10. **How does HashMap internally work?**
    - Uses an array of buckets. The key's hashcode determines the bucket index. Collisions are handled using a Linked List (or Balanced Tree in Java 8+) inside the bucket.

### SECTION 5: METHODS, ARRAYS & PROGRAMMING LOGIC

1. **Difference between Parameters and Arguments.**
   - **Parameters:** Variables declared in the method definition.
   - **Arguments:** Actual values passed when calling the method.

2. **Explain Pass by Value in Java.**
   - Java strictly uses pass by value. For primitives, a copy is passed. For objects, a copy of the reference (memory address) is passed.

3. **How do you reverse an array?**
   - Loop to the middle, swapping `array[i]` with `array[length - 1 - i]`.

4. **Write logic to find the largest element in an array.**
   - Initialize `max = array[0]`, loop through array, if `array[i] > max` update `max = array[i]`.

5. **Difference between 1D and 2D arrays.**
   - **1D:** Linear list.
   - **2D:** Array of arrays (matrix with rows and columns).

6. **How do you remove duplicate elements?**
   - Convert array to a `HashSet` (which removes duplicates) and back to array.

7. **Explain Recursion.**
   - A method calling itself until a base termination condition is met.

8. **Write logic to check whether a number is Prime.**
   - If `n <= 1` false. Loop `i` from 2 to `Math.sqrt(n)`. If `n % i == 0`, it's not prime.

9. **Write logic to check Palindrome.**
   - String: reverse it and check if it equals the original string.

10. **Write logic to generate Fibonacci Series.**
    - Start with `a=0`, `b=1`. Loop: print `a`, then `c = a+b; a=b; b=c;`.

### SECTION 6: SQL FUNDAMENTALS

1. **What is DBMS?**
   - Database Management System: Software to create, manage, and manipulate databases.

2. **Difference between DBMS and RDBMS.**
   - **RDBMS** (Relational) stores data in tabular form with relationships (keys). **DBMS** stores data as files without relationships.

3. **What is SQL?**
   - Structured Query Language: Standard language to communicate with relational databases.

4. **Difference between DDL, DML, DCL and TCL.**
   - **DDL:** Definition (CREATE, ALTER).
   - **DML:** Manipulation (INSERT, UPDATE, DELETE).
   - **DCL:** Control (GRANT, REVOKE).
   - **TCL:** Transaction (COMMIT, ROLLBACK).

5. **What is a Primary Key?**
   - Uniquely identifies each row; cannot be null and must be unique.

6. **What is a Foreign Key?**
   - A column pointing to a primary key in another table, enforcing referential integrity.

7. **Explain NOT NULL, UNIQUE and CHECK constraints.**
   - **NOT NULL:** Prevents null values.
   - **UNIQUE:** Ensures distinct values.
   - **CHECK:** Validates a specific condition (e.g., `age > 18`).

8. **Difference between DELETE, TRUNCATE and DROP.**
   - **DELETE:** Removes specific rows, can be rolled back.
   - **TRUNCATE:** Empties table, resets identity, usually can't be rolled back, faster.
   - **DROP:** Deletes the table structure entirely.

9. **What is Normalization?**
   - Organizing data to reduce redundancy and improve data integrity by dividing large tables.

10. **Explain different Normal Forms.**
    - **1NF:** Atomic values.
    - **2NF:** 1NF + no partial dependency.
    - **3NF:** 2NF + no transitive dependency.

### SECTION 7: SQL QUERY WRITING

1. **Write a query to display all records.**
   - `SELECT * FROM table_name;`

2. **Difference between WHERE and HAVING.**
   - **WHERE:** Filters rows before grouping. No aggregate functions.
   - **HAVING:** Filters groups after grouping (`GROUP BY`). Used with aggregates.

3. **Explain ORDER BY.**
   - Sorts the result set in ascending (`ASC`) or descending (`DESC`) order.

4. **What is DISTINCT?**
   - Returns only unique values, eliminating duplicates.

5. **Explain GROUP BY.**
   - Groups rows with same values into summary rows, typically used with aggregate functions.

6. **Difference between COUNT(*) and COUNT(column).**
   - **COUNT(*):** Counts all rows including NULLs.
   - **COUNT(column):** Counts rows where the specific column is NOT NULL.

7. **How do you retrieve the top N records?**
   - MySQL: `LIMIT N`. SQL Server: `TOP N`. Oracle: `ROWNUM <= N`.

8. **Explain LIKE operator.**
   - Searches for a specified pattern using wildcards `%` (multiple chars) and `_` (single char).

9. **Difference between IN and EXISTS.**
   - **IN:** Compares against a list or subquery result.
   - **EXISTS:** Checks if a subquery returns any rows (often faster for correlated queries).

10. **Write a query to display duplicate records.**
    - `SELECT col, COUNT(col) FROM table GROUP BY col HAVING COUNT(col) > 1;`

### SECTION 8: JOINS & RELATIONSHIPS

1. **What is a Join?**
   - Combines rows from two or more tables based on a related column.

2. **Difference between INNER JOIN and LEFT JOIN.**
   - **INNER:** Returns only matching records in both tables.
   - **LEFT:** Returns all records from left table, and matches from right (NULL if no match).

3. **Explain RIGHT JOIN.**
   - Returns all records from right table, and matches from left (NULL if no match).

4. **Explain FULL OUTER JOIN.**
   - Returns all records from both tables, filling with NULLs where there is no match.

5. **Difference between SELF JOIN and CROSS JOIN.**
   - **SELF:** Joining a table with itself (using aliases).
   - **CROSS:** Cartesian product (every row combined with every row).

6. **When would you use SELF JOIN?**
   - To compare rows within the same table (e.g., employee and manager in same table).

7. **Difference between Primary Key and Foreign Key.**
   - **Primary:** Uniquely identifies a record, no nulls.
   - **Foreign:** Links to another table's primary key, allows nulls/duplicates.

8. **Explain Referential Integrity.**
   - Ensures relationships remain consistent (a foreign key must point to a valid existing primary key).

9. **Can two tables be joined without a foreign key?**
   - Yes, on any columns with matching data types, though explicit foreign keys are best practice.

10. **Explain Many-to-Many Relationships.**
    - Requires a third "junction" table containing foreign keys to both original tables.

### SECTION 9: AGGREGATE FUNCTIONS & SUBQUERIES

1. **Explain COUNT(), SUM(), AVG(), MAX() and MIN().**
   - Count rows, sum values, calculate average, find maximum, find minimum.

2. **What is a Subquery?**
   - A query nested inside another outer query.

3. **Difference between Correlated and Non-Correlated Subqueries.**
   - **Non-Correlated:** Runs independently, executes once.
   - **Correlated:** References outer query columns, executes once for every outer row.

4. **What is EXISTS?**
   - Operator testing if a subquery returns any rows (returns true/false).

5. **Difference between EXISTS and IN.**
   - EXISTS checks for row presence (faster for correlated), IN compares specific values against a set.

6. **Write a query using GROUP BY and HAVING.**
   - `SELECT Dept, SUM(Salary) FROM Emp GROUP BY Dept HAVING SUM(Salary) > 50000;`

7. **What is a Scalar Subquery?**
   - A subquery that returns exactly one row and one column (a single value).

8. **Explain Nested Queries.**
   - Queries placed inside other queries, can be nested multiple levels deep.

9. **How do Aggregate Functions handle NULL values?**
   - They ignore NULLs (except `COUNT(*)` which counts all rows).

10. **Difference between UNION and UNION ALL.**
    - **UNION:** Combines result sets and removes duplicates.
    - **UNION ALL:** Combines result sets and keeps all duplicates (faster).

### SECTION 10: PRACTICAL PROBLEM SOLVING (JAVA & SQL)

1. **Write a Java program to reverse a String.**
   ```java
   String reversed = new StringBuilder("Hello").reverse().toString();
   ```

2. **Write a Java program to check whether a number is Prime.**
   ```java
   boolean isPrime(int n) {
       if(n <= 1) return false;
       for(int i=2; i<=Math.sqrt(n); i++) if(n%i==0) return false;
       return true;
   }
   ```

3. **Write a Java program to find the second largest number in an array.**
   ```java
   int largest = Integer.MIN_VALUE, second = Integer.MIN_VALUE;
   for(int n : arr) {
       if(n > largest) { second = largest; largest = n; }
       else if(n > second && n != largest) { second = n; }
   }
   ```

4. **Write a Java program to count vowels in a String.**
   ```java
   int count = 0;
   for(char c : str.toLowerCase().toCharArray()) {
       if("aeiou".indexOf(c) != -1) count++;
   }
   ```

5. **Write a Java program to remove duplicate elements from an array.**
   ```java
   Set<Integer> set = new LinkedHashSet<>();
   for(int n : arr) set.add(n);
   ```

6. **Write an SQL query to find the second highest salary.**
   ```sql
   SELECT MAX(Salary) FROM Employee WHERE Salary < (SELECT MAX(Salary) FROM Employee);
   ```

7. **Write an SQL query to retrieve duplicate employee records.**
   ```sql
   SELECT emp_name, COUNT(*) FROM Employee GROUP BY emp_name HAVING COUNT(*) > 1;
   ```

8. **Write an SQL query to display employees working in more than one project.**
   ```sql
   SELECT emp_id, COUNT(project_id) FROM Employee_Projects 
   GROUP BY emp_id HAVING COUNT(project_id) > 1;
   ```

9. **Write an SQL query using INNER JOIN on Employee and Department tables.**
   ```sql
   SELECT e.name, d.dept_name FROM Employee e 
   INNER JOIN Department d ON e.dept_id = d.dept_id;
   ```

10. **Given a small business scenario, write an appropriate SQL query and explain your approach.**
    - *Scenario:* Find customers with no orders.
    - *Query:* `SELECT c.name FROM Customers c LEFT JOIN Orders o ON c.id = o.cust_id WHERE o.id IS NULL;`
    - *Explanation:* LEFT JOIN keeps all customers. `WHERE o.id IS NULL` filters only those who didn't match with any order.
