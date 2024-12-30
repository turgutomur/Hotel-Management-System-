-- Tables

CREATE TABLE Restaurant (
    RestaurantID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255),
    OperatingHours VARCHAR(255)
);

CREATE TABLE Employee (
    EmployeeID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Role VARCHAR(50),
    PhoneNumber VARCHAR(50),
    Salary DECIMAL(10, 2),
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

CREATE TABLE Manager (
    EmployeeID SERIAL PRIMARY KEY,
    ManagerLevel VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Waiter (
    EmployeeID SERIAL PRIMARY KEY,
    TipsEarned DECIMAL(10, 2),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Cook (
    EmployeeID SERIAL PRIMARY KEY,
    KitchenSection VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE RestaurantTable (
    TableID SERIAL PRIMARY KEY,
    TableNumber INT,
    Capacity INT,
    Available BOOLEAN,
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    PhoneNumber VARCHAR(50),
    Email VARCHAR(255)
);


CREATE TABLE Session (
    SessionID SERIAL PRIMARY KEY,
    CustomerID INT,
    TableID INT,
    Date DATE,
    Active BOOLEAN,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE SET NULL,
    FOREIGN KEY (TableID) REFERENCES RestaurantTable(TableID)
);

CREATE TABLE Payment (
    PaymentID SERIAL PRIMARY KEY,
    SessionID INT,
    PaymentType VARCHAR(50),
    PaymentStatus VARCHAR(50),
    FOREIGN KEY (SessionID) REFERENCES Session(SessionID)
);

CREATE TABLE Cash (
    PaymentID SERIAL PRIMARY KEY,
    Currency VARCHAR(50),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

CREATE TABLE Card (
    PaymentID SERIAL PRIMARY KEY,
    OwnerName VARCHAR(255),
    CardNumber VARCHAR(50),
    CCV VARCHAR(10),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

CREATE TABLE Receipt (
    ReceiptID SERIAL PRIMARY KEY,
    PaymentID INT,
    ReceiptDate DATE,
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

CREATE TABLE Menu (
    MenuID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    Category VARCHAR(50),
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

CREATE TABLE Product (
    ProductID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Price DECIMAL(10, 2),
    MenuID INT,
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

CREATE TABLE RestaurantOrder (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT,
    TableID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE SET NULL,
    FOREIGN KEY (TableID) REFERENCES RestaurantTable(TableID)
);

CREATE TABLE OrderItem (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    LastPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES RestaurantOrder(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);



----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

-- Sample Data for Restaurant


INSERT INTO Restaurant (Name, Location, OperatingHours)
VALUES 
('Sham Palace', 'Damascus, Syria', '10:00 AM - 11:00 PM'),
('Istanbul Kebab House', 'Istanbul, Turkey', '9:00 AM - 12:00 AM'),
('Persian Delights', 'Tehran, Iran', '11:00 AM - 10:00 PM');

-- Sample Data for Employee
INSERT INTO Employee (EmployeeID, Name, Role, PhoneNumber, Salary, RestaurantID)
VALUES 
(1, 'Ahmad Khalid', 'Manager', '00963-123456789', 5000.00, 1),
(2, 'Zeynep Yildiz', 'Waiter', '0090-5554443332', 1200.00, 2),
(3, 'Ali Reza', 'Cook', '0098-9123456789', 1800.00, 3),
(4, 'Fatima Hussein', 'Waiter', '00963-987654321', 1200.00, 1),
(5, 'Mehmet Kara', 'Cook', '0090-5551234567', 1800.00, 2);

-- Sample Data for Manager
INSERT INTO Manager (EmployeeID, ManagerLevel)
VALUES 
(1, 'Senior Manager');

-- Sample Data for Waiter
INSERT INTO Waiter (EmployeeID, TipsEarned)
VALUES 
(2, 300.00),
(4, 250.00);

-- Sample Data for Cook
INSERT INTO Cook (EmployeeID, KitchenSection)
VALUES 
(3, 'Grill'),
(5, 'Appetizers');

-- Sample Data for RestaurantTable
INSERT INTO RestaurantTable (TableNumber, Capacity, Available, RestaurantID)
VALUES 
(101, 4, TRUE, 1),
(102, 6, FALSE, 1),
(201, 2, TRUE, 2),
(301, 8, TRUE, 3),
(444, 12, TRUE, 3);

-- Sample Data for Customer
INSERT INTO Customer (Name, PhoneNumber, Email)
VALUES 
('Layla Abed', '00963-998877665', 'layla.abed@example.com'),
('Omar Farouk', '0090-5556789876', 'omar.farouk@example.com'),
('Sahar Yazdi', '0098-9125671234', 'sahar.yazdi@example.com');

-- Sample Data for Session
INSERT INTO Session (CustomerID, TableID, Date, Active)
VALUES 
(1, 1, '2024-12-19', FALSE),
(2, 2, '2024-12-18', TRUE),
(3, 3, '2024-12-20', TRUE);

-- Sample Data for Payment
INSERT INTO Payment ( SessionID, PaymentType, PaymentStatus)
VALUES 
(1, 'Card', 'Completed'),
(2, 'Cash', 'Completed'),
(3, 'Card', 'Pending');

-- Sample Data for Cash
INSERT INTO Cash (PaymentID, Currency)
VALUES 
(2, 'TRY');

-- Sample Data for Card
INSERT INTO Card (PaymentID, OwnerName, CardNumber, CCV)
VALUES 
(1, 'Layla Abed', '1234567812345678', '123'),
(3, 'Sahar Yazdi', '9876543298765432', '987');

-- Sample Data for Receipt
INSERT INTO Receipt (PaymentID, ReceiptDate)
VALUES 
(1, '2024-12-19'),
(2, '2024-12-18'),
(3, '2024-12-20');

-- Sample Data for Menu
INSERT INTO Menu ( Name, Description, Category, RestaurantID)
VALUES 
('Appetizers Menu', 'Fresh starters to begin your meal.', 'Appetizer', 1),
('Main Course', 'Grilled and traditional dishes.', 'Main', 2),
('Desserts', 'Sweet treats to end your meal.', 'Dessert', 3);

-- Sample Data for Product
INSERT INTO Product ( Name, Price, MenuID)
VALUES 
('Hummus', 4.50, 1),
('Kebab', 15.00, 2),
('Baklava', 7.00, 3);

-- Sample Data for RestaurantOrder
INSERT INTO RestaurantOrder (CustomerID, TableID, OrderDate, TotalAmount)
VALUES 
(1, 1, '2024-12-19', 25.00),
(2, 2, '2024-12-18', 15.00),
(3, 3, '2024-12-20', 30.00);

-- Sample Data for OrderItem
INSERT INTO OrderItem (OrderID, ProductID, Quantity, LastPrice)
VALUES 
(1, 1, 2, 4.50),
(1, 2, 1, 15.00),
(3, 3, 3, 7.00);



----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

-- Functions

CREATE OR REPLACE FUNCTION search_customers(search_term VARCHAR)
RETURNS TABLE (
    CustomerID INT,
    Name VARCHAR,
    PhoneNumber VARCHAR,
    Email VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.CustomerID, c.Name, c.PhoneNumber, c.Email
    FROM Customer c
    WHERE c.Name ILIKE '%' || search_term || '%'
       OR c.Email ILIKE '%' || search_term || '%';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_customer(
    p_name VARCHAR,
    p_phone_number VARCHAR,
    p_email VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Customer (Name, PhoneNumber, Email)
    VALUES (p_name, p_phone_number, p_email);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_customer(
    p_customer_id INT,
    p_name VARCHAR,
    p_phone_number VARCHAR,
    p_email VARCHAR
) RETURNS VOID AS $$
BEGIN
    UPDATE Customer
    SET Name = p_name,
        PhoneNumber = p_phone_number,
        Email = p_email
    WHERE CustomerID = p_customer_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_customer(p_customer_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Customer
    WHERE CustomerID = p_customer_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION end_session(p_session_id INT)
RETURNS VOID AS $$
BEGIN
    -- Update the session to set it as inactive (Active = FALSE)
    UPDATE Session
    SET Active = FALSE
    WHERE SessionID = p_session_id;

    -- Optionally, you could add more logic for logging, notifications, etc.
    -- For example, setting the table to be available again after the session ends:
    UPDATE RestaurantTable
    SET Available = TRUE
    WHERE TableID = (SELECT TableID FROM Session WHERE SessionID = p_session_id);
    
    -- If there are any other processes related to ending a session, you can add them here.
    
    -- The trigger 'trg_create_payment_and_receipt_on_session_end' will automatically run
    -- because it is triggered after the session's Active status is set to FALSE.
    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION create_new_session_for_existing_user(customer_id INT)
RETURNS VOID AS $$
DECLARE
    random_table_id INT;
BEGIN
    -- Select a random available table
    SELECT TableID INTO random_table_id
    FROM RestaurantTable
    WHERE Available = TRUE
    ORDER BY RANDOM()
    LIMIT 1;

    -- If no available table is found, raise an error
    IF random_table_id IS NULL THEN
        RAISE EXCEPTION 'No available table found for the new session';
    END IF;

    -- Create a new session for the user with the selected table
    INSERT INTO Session (CustomerID, TableID, Date, Active)
    VALUES (customer_id, random_table_id, CURRENT_DATE, TRUE);

    -- Optionally, update the table to mark it as unavailable
    UPDATE RestaurantTable
    SET Available = FALSE
    WHERE TableID = random_table_id;

    RAISE NOTICE 'New session created for CustomerID % with TableID %', customer_id, random_table_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION end_all_sessions()
RETURNS VOID AS $$
BEGIN
    -- Update all active sessions to be inactive
    UPDATE Session
    SET Active = FALSE
    WHERE Active = TRUE;

    -- Optionally, mark tables as available again
    UPDATE RestaurantTable
    SET Available = TRUE
    WHERE TableID IN (SELECT TableID FROM Session WHERE Active = FALSE);

    RAISE NOTICE 'All active sessions have been ended';
END;
$$ LANGUAGE plpgsql;



----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
--- TRIGGERS


CREATE OR REPLACE FUNCTION create_session_for_new_customer()
RETURNS TRIGGER AS $$
DECLARE
    random_table_id INT;
BEGIN
    -- Select a random available table from the restaurant
    SELECT TableID INTO random_table_id
    FROM RestaurantTable
    WHERE Available = TRUE
    ORDER BY RANDOM()
    LIMIT 1;

    -- If no available table found, raise an error
    IF random_table_id IS NULL THEN
        RAISE EXCEPTION 'No available table found for the session';
    END IF;

    -- Create a new session for the customer with the selected table
    INSERT INTO Session (CustomerID, TableID, Date, Active)
    VALUES (NEW.CustomerID, random_table_id, CURRENT_DATE, TRUE);

    -- Mark the table as unavailable after assigning it to the session
    UPDATE RestaurantTable
    SET Available = FALSE
    WHERE TableID = random_table_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to execute the function after a new customer is created
CREATE OR REPLACE TRIGGER trg_create_session_for_new_customer
AFTER INSERT ON Customer
FOR EACH ROW
EXECUTE FUNCTION create_session_for_new_customer();


----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------



CREATE OR REPLACE FUNCTION update_session_and_create_random_order()
RETURNS TRIGGER AS $$
DECLARE
    random_order_id INT;
    random_product_id INT;
    item_price DECIMAL(10, 2);
    total_amount DECIMAL(10, 2) := 0;
BEGIN
    -- Check if the session already has a table assigned
    IF NEW.TableID IS NOT NULL THEN
        -- Create a new order for the session
        INSERT INTO RestaurantOrder (CustomerID, TableID, OrderDate, TotalAmount)
        VALUES (NEW.CustomerID, NEW.TableID, CURRENT_DATE, 0)
        RETURNING OrderID INTO random_order_id;

        -- Populate the order with random items and calculate total amount
        FOR i IN 1..3 LOOP -- Create 3 random items for the order
            SELECT ProductID, Price INTO random_product_id, item_price
            FROM Product
            ORDER BY RANDOM()
            LIMIT 1;

            -- Add the random item to the order
            INSERT INTO OrderItem (OrderID, ProductID, Quantity, LastPrice)
            VALUES (random_order_id, random_product_id, 1, item_price);

            -- Accumulate the price into the total amount
            total_amount := total_amount + item_price;
        END LOOP;

        -- Update the total amount in the order
        UPDATE RestaurantOrder
        SET TotalAmount = total_amount
        WHERE OrderID = random_order_id;

    ELSE
        RAISE NOTICE 'Session does not have an assigned table';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_update_session_and_create_random_order
AFTER INSERT ON Session
FOR EACH ROW
EXECUTE FUNCTION update_session_and_create_random_order();





CREATE OR REPLACE FUNCTION create_payment_and_receipt_when_session_ends()
RETURNS TRIGGER AS $$
DECLARE
    random_payment_type VARCHAR(50);
    random_payment_status VARCHAR(50);
    random_payment_id INT;
    random_receipt_id INT;
BEGIN
    -- Only trigger when the session is being set to inactive (FALSE)
    IF NEW.Active = FALSE AND OLD.Active = TRUE THEN
        -- Generate random payment type and status
        random_payment_type := CASE WHEN RANDOM() > 0.5 THEN 'Cash' ELSE 'Card' END;
        random_payment_status := CASE WHEN RANDOM() > 0.5 THEN 'Completed' ELSE 'Pending' END;

        -- Create the payment record for the session
        INSERT INTO Payment (SessionID, PaymentType, PaymentStatus)
        VALUES (NEW.SessionID, random_payment_type, random_payment_status)
        RETURNING PaymentID INTO random_payment_id;

        -- Create a receipt associated with the payment
        INSERT INTO Receipt (PaymentID, ReceiptDate)
        VALUES (random_payment_id, CURRENT_DATE)
        RETURNING ReceiptID INTO random_receipt_id;

        -- Optionally, if 'Cash' payment is selected, create a Cash record
        IF random_payment_type = 'Cash' THEN
            INSERT INTO Cash (PaymentID, Currency)
            VALUES (random_payment_id, 'USD');  -- Assuming currency is USD
        ELSE
            -- If 'Card' payment is selected, create a Card record with some sample details
            INSERT INTO Card (PaymentID, OwnerName, CardNumber, CCV)
            VALUES (random_payment_id, 'John Doe', '1234-5678-9876-5432', '123'); -- Sample card info
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_create_payment_and_receipt_on_session_end
AFTER UPDATE ON Session
FOR EACH ROW
WHEN (NEW.Active = FALSE AND OLD.Active = TRUE)
EXECUTE FUNCTION create_payment_and_receipt_when_session_ends();




CREATE OR REPLACE FUNCTION add_tables_when_all_unavailable()
RETURNS TRIGGER AS $$
DECLARE
    unavailable_tables_count INT;
BEGIN
    -- Check if all tables are unavailable
    SELECT COUNT(*) INTO unavailable_tables_count
    FROM RestaurantTable
    WHERE Available = FALSE;

    -- If all tables are unavailable, add 3 new available tables
    IF unavailable_tables_count = (SELECT COUNT(*) FROM RestaurantTable) THEN
        FOR i IN 1..3 LOOP
            INSERT INTO RestaurantTable (TableNumber, Capacity, Available, RestaurantID)
            VALUES (
                (SELECT COALESCE(MAX(TableNumber), 0) + 1 FROM RestaurantTable),  -- Increment TableNumber
                4,  -- Default Capacity, you can change this value as needed
                TRUE,  -- Make the table available
                (SELECT RestaurantID FROM Restaurant LIMIT 1)  -- Assign to the first restaurant
            );
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_tables_when_all_unavailable
AFTER UPDATE ON RestaurantTable
FOR EACH ROW
WHEN (OLD.Available = TRUE AND NEW.Available = FALSE)  -- Trigger only when a table becomes unavailable
EXECUTE FUNCTION add_tables_when_all_unavailable();



----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

--- Some text functions

SELECT insert_customer('HAMZA', '+666', 'hamza@example.com');
SELECT insert_customer('OMUR', '+777', 'omur@example.com');


SELECT search_customers('omu')
SELECT search_customers('za@')


SELECT update_customer(1, 'new name', '333', 'newemail@example.com')

SELECT delete_customer(3)


SELECT end_session(4);
SELECT end_session(5);


SELECT create_new_session_for_existing_user(4)

SELECT end_all_sessions();


