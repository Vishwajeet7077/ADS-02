-- Q1 a
CREATE TABLE test_table (
    RecordNumber INT(3),
    CurrentDate DATE
);

-- MySQL block to insert 50 records into test_table with current date
DELIMITER //

CREATE PROCEDURE InsertTestData()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 50 DO
        INSERT INTO test_table (RecordNumber, CurrentDate)
        VALUES (i, CURRENT_DATE());
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL InsertTestData();

select * from test_table;









-- Q1 b

-- Create products table
CREATE TABLE products (
    ProductID INT(4),
    Category CHAR(3),
    Detail VARCHAR(30),
    Price DECIMAL(10,2),
    Stock INT(5)
);

-- Sample data for products table
INSERT INTO products (ProductID, Category, Detail, Price, Stock)
VALUES (1, 'ABC', 'Product1', 10.50, 100);

INSERT INTO products (ProductID, Category, Detail, Price, Stock)
VALUES (2, 'XYZ', 'Product2', 20.75, 150);

-- Create a stored procedure
DELIMITER //

CREATE PROCEDURE UpdatePriceByCategory(IN p_percentage_increase DECIMAL(5,2), IN p_category CHAR(3))
BEGIN
    UPDATE products
    SET Price = Price * (1 + p_percentage_increase / 100)
    WHERE Category = p_category;
END //

DELIMITER ;

-- Example call to the stored procedure
CALL UpdatePriceByCategory(10, 'ABC');

select * from products;






-- Q2 a


-- Create a DETERMINISTIC function to count the number of words
DELIMITER //

CREATE FUNCTION CountWords(inputString VARCHAR(50)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE wordCount INT;
    SET wordCount = LENGTH(inputString) - LENGTH(REPLACE(inputString, ' ', '')) + 1;
    RETURN wordCount;
END //

DELIMITER ;


-- Create a table with a column of type VARCHAR(50)
CREATE TABLE NameObjectTable (
    id INT,
    name VARCHAR(50)
);

-- Insert data into the table
INSERT INTO NameObjectTable VALUES (1, 'John Doe');
INSERT INTO NameObjectTable VALUES (2, 'Jane Smith');
INSERT INTO NameObjectTable VALUES (3, 'Jane Smith another word');

-- Query the table and call the CountWords function
SELECT id, name, CountWords(name) AS wordCount
FROM NameObjectTable;









-- Q2 b


-- Create a stored procedure to extract addresses based on a given keyword
DELIMITER //

CREATE PROCEDURE ExtractAddresses(keyword VARCHAR(50))
BEGIN
    SELECT *
    FROM AddressTable
    WHERE address LIKE CONCAT('%', keyword, '%')
       OR city LIKE CONCAT('%', keyword, '%')
       OR state LIKE CONCAT('%', keyword, '%')
       OR pincode LIKE CONCAT('%', keyword, '%');
END //

DELIMITER ;

-- Create a stored procedure to return the number of words in a given field
DELIMITER //

CREATE PROCEDURE CountWordsInField(fieldName VARCHAR(50))
BEGIN
    SET @sql = CONCAT('SELECT ', fieldName, ', 
                             LENGTH(', fieldName, ') - LENGTH(REPLACE(', fieldName, ', '' '', '''')) + 1 AS wordCount 
                      FROM AddressTable;');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;
-- Create a new address table
CREATE TABLE AddressTable (
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10)
);

-- Insert sample data into the address table
INSERT INTO AddressTable (address, city, state, pincode)
VALUES 
    ('123 Main St', 'City1', 'State1', '12345'),
    ('456 Oak St', 'City2', 'State2', '67890'),
    ('789 Maple St', 'City3', 'State3', '54321');

-- Example usage of ExtractAddresses
CALL ExtractAddresses('City');

-- Example usage of CountWordsInField
CALL CountWordsInField('address');










-- Q2 c

-- Create a table to simulate the user-defined type
CREATE TABLE CourseTypeTable (
    course_id INT,
    description VARCHAR(255)
);

-- Create a stored procedure to insert into the simulated type
DELIMITER //

CREATE PROCEDURE InsertCourseType(IN p_course_id INT, IN p_description VARCHAR(255))
BEGIN
    INSERT INTO CourseTypeTable (course_id, description)
    VALUES (p_course_id, p_description);
END //

DELIMITER ;

-- Insert rows into the table using the stored procedure
CALL InsertCourseType(1, 'Mathematics');
CALL InsertCourseType(2, 'History');
CALL InsertCourseType(3, 'Computer Science');

-- Query the table
SELECT * FROM CourseTypeTable;








