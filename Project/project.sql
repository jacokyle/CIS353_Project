SPOOL project.out
SET ECHO ON

-- This command file creates and populates the PROJECT database for our final project. 
-- This command file was written by Kyle Jacobson, Farid Karadsheh, Daniel Shamburger, Chesten VanPelt.

-- Drop the tables (in case they already exist in the system).

DROP TABLE Warehouse CASCADE CONSTRAINTS;
DROP TABLE Purchasing_Coordinator CASCADE CONSTRAINTS;
DROP TABLE Store CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Supplier CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE Sells CASCADE CONSTRAINTS;
DROP TABLE Represents CASCADE CONSTRAINTS;
DROP TABLE Notes CASCADE CONSTRAINTS;
DROP TABLE Sales_History CASCADE CONSTRAINTS;
DROP TABLE Portion CASCADE CONSTRAINTS;
DROP TABLE Manager CASCADE CONSTRAINTS;

-- Create the tables for the project.

    -- Create the warehouse table.
CREATE TABLE  Warehouse (
	wareNum   			INTEGER,
	wareName 				VARCHAR(25) NOT NULL,
	address 				VARCHAR(50) NOT NULL,
	CONSTRAINT wIC1 PRIMARY KEY (wareNum)
	);

    -- Create the purchasing coordinator table.
    CREATE TABLE Purchasing_Coordinator (
	    customerID 		INTEGER PRIMARY KEY,
			purName		 		VARCHAR(25) NOT NULL,
	    purPhoneNum		VARCHAR(25) NOT NULL
	    );

    -- Create the store table.
    CREATE TABLE Store (
	    storeID 					INTEGER PRIMARY KEY,
	    storeName 				VARCHAR(25) NOT NULL, 
	    storeLocation 		VARCHAR(60) NOT NULL	
	    );

    -- Create the order table.
CREATE TABLE Orders (
	orderID 						INTEGER PRIMARY KEY,
	wareNum							INTEGER NOT NULL,
	customerID					INTEGER NOT NULL, 
	storeID							INTEGER NOT NULL,
	o_date 							DATE NOT NULL, 
	CONSTRAINT ordIC1 FOREIGN KEY (wareNum) REFERENCES Warehouse (wareNum),
	CONSTRAINT ordIC2 FOREIGN KEY (customerID) REFERENCES Purchasing_Coordinator (customerID),
	CONSTRAINT ordIC3 FOREIGN KEY (storeID) REFERENCES Store (storeID)
	);

    -- Create the product table.
CREATE TABLE Product (
	productID 					INTEGER PRIMARY KEY,
	proName 						VARCHAR(50) NOT NULL, 
	description 				VARCHAR(200) NOT NULL, 
	weight 							DECIMAL NOT NULL,
	CONSTRAINT proIC1 CHECK (weight > 0)
	);

    -- Create the supplier table.
    CREATE TABLE Supplier (
	    supplierID 			INTEGER PRIMARY KEY,
	    supName 				VARCHAR(25) NOT NULL,
	    supLocation 		VARCHAR(50) NOT NULL
	    );

    -- Create the sells table.
    CREATE TABLE Sells (
	    supplierID			INTEGER NOT NULL,
	    productID				INTEGER NOT NULL, 
	    primary key		(supplierID, productID),
	    CONSTRAINT seIC1 FOREIGN KEY (supplierID) REFERENCES Supplier (supplierID) ON DELETE CASCADE,
	    CONSTRAINT seIC2 FOREIGN KEY (productID) REFERENCES Product (productID) ON DELETE CASCADE
	    );
    -- Create the represents table.
    CREATE TABLE Represents (
	    customerID			INTEGER NOT NULL, 
	    storeID					INTEGER NOT NULL, 
	    primary key 		(storeID, customerID),
	    CONSTRAINT repIC1 FOREIGN KEY (customerID) REFERENCES Purchasing_Coordinator (customerID) ON DELETE CASCADE,
	    CONSTRAINT repIC2 FOREIGN KEY (storeID) REFERENCES Store (storeID) ON DELETE CASCADE
	    );

    -- Create the notes table.
    CREATE TABLE Notes (
	    orderID			INTEGER,
	    notes 			VARCHAR(100),
	    primary key		(orderID, notes),
	    CONSTRAINT notIC1 FOREIGN KEY (orderID) REFERENCES Orders (orderID) ON DELETE CASCADE 
	    );

    -- Create the sales history table.
CREATE TABLE Sales_History (
	numSold 			INTEGER NOT NULL,
	revenue				INTEGER NOT NULL,
	productID 		INTEGER NOT NULL,
	saleYear		SMALLINT NOT NULL,
	primary key		(productID, saleYear),
	CONSTRAINT s_hIC1 FOREIGN KEY(productID) REFERENCES Product (productID),
	CONSTRAINT s_hIC2 CHECK ((numSold > 0) AND (revenue > 0))
	);

    -- Creates a relational table linking products to warehouse.
    CREATE TABLE Inventory (
	    wareNum				INTEGER NOT NULL,
	    productID 		INTEGER NOT NULL,
	    quantity			INTEGER NOT NULL,
	    primary key		(productID, wareNum),
	    CONSTRAINT invIC1 FOREIGN KEY(productID) REFERENCES Product (productID) ON DELETE CASCADE,
	    CONSTRAINT invIC2 FOREIGN KEY(wareNum) REFERENCES Warehouse(wareNum) ON DELETE CASCADE
	    );

    -- Creates a relational table linking products to order.
    CREATE TABLE Portion (
	    orderID				INTEGER NOT NULL,
	    productID 		INTEGER NOT NULL,
	    pQuantity			INTEGER NOT NULL,
	    primary key		(productID, orderID),
	    CONSTRAINT porIC1 FOREIGN KEY(productID) REFERENCES Product (productID),
	    CONSTRAINT porIC2 FOREIGN KEY(OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE
	    );

    -- Create the manager table.
    CREATE TABLE Manager (
	    managerID 		INTEGER PRIMARY KEY,
	    wareNum				INTEGER NOT NULL,
	    manPhoneNum		VARCHAR(25) NOT NULL,
	    manName				VARCHAR(30),
	    CONSTRAINT manIC1 FOREIGN KEY(wareNum) REFERENCES Warehouse(wareNum) ON DELETE CASCADE
	    );

    SET FEEDBACK OFF

    alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD';

    -- Inserts data into the warehouse table: (wareNum, wareName, address)
    INSERT INTO Warehouse VALUES (0, 'West Grand Rapids', '123 Bridge St. NW, Grand Rapids, MI 49504');
    INSERT INTO Warehouse VALUES (1, 'East Grand Rapids', '4125 28th St. NE, Grand Rapids, MI 49506');
    INSERT INTO Warehouse VALUES (2, 'Central Detroit', '4567 Main St. S, Detroit, MI 48206');

    -- Inserts data into the purchasing coordinator table: (customerID, purName, purPhoneNum)
    INSERT INTO Purchasing_Coordinator VALUES (0, 'John Smith', '616-617-0083');
    INSERT INTO Purchasing_Coordinator VALUES (1, 'Jackie Chan', '231-367-5309');
    INSERT INTO Purchasing_Coordinator VALUES (2, 'Sandra Bullock', '616-375-4081');
    INSERT INTO Purchasing_Coordinator VALUES (3, 'Prahdeep Singh', '231-997-4602');
    INSERT INTO Purchasing_Coordinator VALUES (4, 'Emma Stone', '421-697-3371');

    -- Inserts data into the store table: (storeID, storeName, storeLocation)
    INSERT INTO Store VALUES (0, 'McDonalds', '417 Michigan St. NE, Grand Rapids, MI 49503');
    INSERT INTO Store VALUES (1, 'Burger King', '2155 Gratiot Ave., Detroit, MI 48207');
    INSERT INTO Store VALUES (2, 'Wahlburgers', '569 Monroe St., Detroit, MI 48226');
    INSERT INTO Store VALUES (3, 'Qdoba', '25 Michigan St. NE Suite 1100, Grand Rapids, MI 49503');
    INSERT INTO Store VALUES (4, 'Spectrum Health', '100 Michigan St. NE, Grand Rapids, Michigan, 49503');
    INSERT INTO Store VALUES (5, 'Shell Gas Station', '4661 Woodward Ave., Detroit, MI 48201');
    INSERT INTO Store VALUES (6, 'McDonalds', '4235 Woodward Ave., Detroit, MI 48201');

    -- Inserts data into the order table: (orderID, wareNum, customerID, storeID, o_date)
    INSERT INTO Orders VALUES (0, 0, 0, 0, '2019-07-12');
    INSERT INTO Orders VALUES (1, 1, 1, 1, '2019-07-13');
    INSERT INTO Orders VALUES (2, 1, 0, 1, '2019-07-14');
    INSERT INTO Orders VALUES (3, 0, 1, 3, '2019-07-15');
    INSERT INTO Orders VALUES (4, 2, 4, 4, '2019-07-16');
    INSERT INTO Orders VALUES (5, 2, 4, 4, '2019-09-16');
    INSERT INTO Orders VALUES (6, 1, 4, 3, '2019-07-16');
    INSERT INTO Orders VALUES (7, 1, 4, 3, '2019-09-16');

    -- Inserts data into the Product table: (productID, proName, description, weight)
    INSERT INTO Product VALUES (0, 'Ultimate Dish Soap', 'Commercial dish soap cleaner.', 1);
    INSERT INTO Product VALUES (1, 'Concentrated HE Bleach', 'Commercial sanitizing solution and whitener.', 5);
    INSERT INTO Product VALUES (2, 'Roma Tomatoes', 'Farm fresh red-Roma tomatoes.', 25);
    INSERT INTO Product VALUES (3, '5-quart Colander', 'Stainless steel micro-perforated 5-quart colander.', 4);
    INSERT INTO Product VALUES (4, '6 in. Strainer', 'A fine mesh stainless-steel strainer.', 1);
    INSERT INTO Product VALUES (5, 'Double Coffee Brewer and Warmer', 'An electronic coffee brewer with hot water intake, two glass decanters, a warmer and a brewer.', 45);
    INSERT INTO Product VALUES (6, 'Disinfecting Wipes', 'Clorox Disinfecting Wipes is an all-purpose wipe that cleans and disinfects with antibacterial power killing 99.9% of viruses and bacteria in a Crisp Lemon scent.', 3);

    -- Inserts data into the supplier table: (supplierID, supName, supLocation)
    INSERT INTO Supplier VALUES (0, 'Dawn', '123 1st St., New York, NY 22222');
    INSERT INTO Supplier VALUES (1, 'Walmart', '1221 Broadway,  Oakland, CA 94607');
    INSERT INTO Supplier VALUES (2, 'Shelton Farms', '1832 S 11th St., Niles, MI 49120');
    INSERT INTO Supplier VALUES (3, 'Bellemain', '736 28th St. SE, Grand Rapids, MI 49502');
    INSERT INTO Supplier VALUES (4, 'Cuisinart', '4536 West Blvd., Atlanta, GA 12355');
    INSERT INTO Supplier VALUES (5, 'BUNN', '1400 Adlai Stevenson Dr., Springfield, IL 62703');
    INSERT INTO Supplier VALUES (6, 'Walmart', '5064 S Merrimac Ave., Chicago, IL 60638');

    -- Inserts data into the notes table: (orderID, note)
    INSERT INTO Notes VALUES (0, 'Deliver after 3pm.');
    INSERT INTO Notes VALUES (4, 'Payment is to be collected on arrival.');
    INSERT INTO Notes VALUES (1, 'Pick up a return after dropping off order.');
    INSERT INTO Notes VALUES (0, 'Please include an additional copy of the invoice.');

    -- Inserts data into the sells table: (supplierID, productID)
    INSERT INTO Sells VALUES(0, 0);
    INSERT INTO Sells VALUES(0, 1);
    INSERT INTO Sells VALUES(1, 2); 
    INSERT INTO Sells VALUES(1, 3);
    INSERT INTO Sells VALUES(1, 5);
    INSERT INTO Sells VALUES(1, 6);
    INSERT INTO Sells VALUES(2, 2);
    INSERT INTO Sells VALUES(2, 3);
    INSERT INTO Sells VALUES(2, 4);
    INSERT INTO Sells VALUES(2, 6);
    INSERT INTO Sells VALUES(3, 5);
    INSERT INTO Sells VALUES(3, 6);
    INSERT INTO Sells VALUES(4, 3);
    INSERT INTO Sells VALUES(4, 4);
    INSERT INTO Sells VALUES(4, 6);
    INSERT INTO Sells VALUES(5, 1);
    INSERT INTO Sells VALUES(5, 6);
    INSERT INTO Sells VALUES(6, 3);
    INSERT INTO Sells VALUES(6, 4);
    INSERT INTO Sells VALUES(6, 6);
    INSERT INTO Sells VALUES(6, 1);

--Inserts data into portion (orderID, productID , pQuantity)
    INSERT INTO Portion VALUES(6, 6, 2);
    INSERT INTO Portion VALUES(3, 4, 3);
    INSERT INTO Portion VALUES(7, 6, 5);

    -- Inserts data into the inventory table: (wareNum, productID, quantity)
    INSERT INTO Inventory VALUES(0, 0, 12);
    INSERT INTO Inventory VALUES(0, 1, 2);
    INSERT INTO Inventory VALUES(0, 3, 7);
    INSERT INTO Inventory VALUES(0, 4, 2);
    INSERT INTO Inventory VALUES(1, 5, 7);
    INSERT INTO Inventory VALUES(1, 3, 36);
    INSERT INTO Inventory VALUES(1, 4, 8);
    INSERT INTO Inventory VALUES(1, 6, 14);
    INSERT INTO Inventory VALUES(2, 1, 7);
    INSERT INTO Inventory VALUES(2, 3, 3);
    INSERT INTO Inventory VALUES(2, 4, 4);
    INSERT INTO Inventory VALUES(2, 5, 7);
    INSERT INTO Inventory VALUES(1, 2, 3);

    -- Inserts data into the Sales_History table: (numSold, revenue, productID, saleYear)
    INSERT INTO Sales_History VALUES(5, 100, 0, 2019);
    INSERT INTO Sales_History VALUES(22, 200, 1, 2019);
    INSERT INTO Sales_History VALUES(16, 160, 2, 2019);
    INSERT INTO Sales_History VALUES(34, 220, 3, 2019);
    INSERT INTO Sales_History VALUES(76, 332, 4, 2019);
    INSERT INTO Sales_History VALUES(14, 245, 5, 2019);

    -- Inserts data into the Manager table: (managerID, wareNum, manPhoneNum, manName)
    INSERT INTO Manager VALUES(0, 0, '616-234-8930', 'Matt Champion');
    INSERT INTO Manager VALUES(1, 1, '616-345-1390', 'Kevin Abstract');
    INSERT INTO Manager VALUES(2, 2, '586-321-5690', 'JOBA');

    -- Inserts data into the Represents table: (customerID, storeID)
    INSERT INTO Represents VALUES(1, 2);
    INSERT INTO Represents VALUES(2, 3);

    SET FEEDBACK ON
    COMMIT;

    -- Performs various queries for sorting the PROJECT database information.

    -- Query: Complete analyzation of the Warehouse table.
    -- Description: Finds all of the given information that has been inserted into Warehouse table.
    SELECT * 
    FROM Warehouse;

    -- Query: Complete analyzation of the Purchasing_Coordinator table.
    -- Description: Finds all of the given information that has been inserted into Purchasing_Coordinator table.
    SELECT * 
    FROM Purchasing_Coordinator;

    -- Query: Complete analyzation of the Store table.
    -- Description: Finds all of the given information that has been inserted into Store table.
    SELECT * 
    FROM Store;

    -- Query: Complete analyzation of the Orders table.
    -- Description: Finds all of the given information that has been inserted into Orders table.
    SELECT * 
    FROM Orders;


    -- Query: Complete analyzation of the Product table.
    -- Description: Finds all of the given information that has been inserted into Product table.
    SELECT * 
    FROM Product;

    -- Query: Complete analyzation of the Supplier table.
    -- Description: Finds all of the given information that has been inserted into Supplier table.
    SELECT * 
    FROM Supplier;

    -- Query: Complete analyzation of the Inventory table.
    -- Description: Finds all of the given information that has been inserted into Inventory table.
    SELECT * 
    FROM Inventory;

    -- Query: Complete analyzation of the Sells table.
    -- Description: Finds all of the given information that has been inserted into Sells table.
    SELECT * 
    FROM Sells;

    -- Query: Complete analyzation of the Represents table.
    -- Description: Finds all of the given information that has been inserted into Represents table.
    SELECT * 
    FROM Represents;

    -- Query: Complete analyzation of the Notes table.
    -- Description: Finds all of the given information that has been inserted into Notes table.
    SELECT * 
    FROM Notes;

    -- Query: Complete analyzation of the Sales_History table.
    -- Description: Finds all of the given information that has been inserted into Sales_History table.
    SELECT * 
    FROM Sales_History;

    -- Query: Complete analyzation of the Portion table.
    -- Description: Finds all of the given information that has been inserted into Portion table.
    SELECT * 
    FROM Portion;

    -- Query: Complete analyzation of the Managers table.
    -- Description: Finds all of the given information that has been inserted into Managers table.
    SELECT * 
    FROM Manager;

    -- Query: A join involving at least four relations.
    -- Description: Finds Warehouses, Stores, and Suppliers that are all on the same order, and are located in “Grand Rapids”.
    SELECT 		O.orderID, W.address, S.storeLocation, Sup.supLocation
    FROM 			Warehouse W, Store S, Supplier Sup, Order O, Product P, Portion Por, Sells Sel
    WHERE 		O.storeID = S.StoreID AND 
    S.storeLocation LIKE ‘%Grand Rapids%’  AND 
    O.wareNum = W.wareNum AND
    W.address LIKE ‘%Grand Rapids%’ AND 
    O.orderID = Por.orderID AND
    Por.productID = P.productID AND
    P.productID = Sel.productID AND
    Sel.supplierID = Sup.supplierID AND
    Sup.supLocation LIKE ‘%Grand Rapids%’
    ORDER BY O.orderID

    -- Query: A self-join. 
    -- Description: Finds pairs of unique orders that came from the same warehouse and went to the same store.
    SELECT 		O1.orderID, O1.wareNum, O1.storeID, O2.orderID, O2.wareNum, O2.storeID
    FROM  		Orders O1, Orders O2
    WHERE 		O1.wareNum = O2.wareNum AND
    O1.storeID = O2.storeID AND
    O1.orderID > O2.orderID
    ORDER BY 		O1.orderID;

    -- Query: UNION, INTERSECT, and/or MINUS.
    -- Description: Finds products that there are more than 4 in any warehouse, and whose weight is greater than 10 
    SELECT 		P.productID, P.weight, I.quantity
    FROM 			Product P, Inventory I
    WHERE			I.quantity > 4 AND 
    I.productID = P.productID
    INTERSECT
    SELECT 		P.productID, P.weight, I.quantity
    FROM 			Product P, Inventory I
    WHERE			I.productID = P.productID AND 
    P.weight  > 10;

    -- Query: SUM, AVG, MAX and/or MIN.
    -- Description: Finds average weight of products for each warehouse.
SELECT 		W.wareNum, AVG(P.weight)
    FROM 					Warehouse W, Product P, Inventory I
    WHERE 				I.wareNum = W.wareNum AND 
    I.productID = P.productID 
    GROUP BY			W.wareNum
    HAVING				AVG(P.weight) > 0
    ORDER BY 			W.wareNum;

    -- Query: GROUP BY, HAVING, and ORDER BY, all appearing in the same query.
    -- Description: Finds suppliers that supply more than 2 products.
SELECT 		DISTINCT S.supplierID, S.supName, COUNT(DISTINCT P.productID)
    FROM 			Supplier S, Product P, Sells Sel
    WHERE 		P.productID = Sel.productID AND
    					Sel.supplierID = S.supplierID
    GROUP BY 	S.supplierID, S.supName
    HAVING 		COUNT(*) > 2
    ORDER BY 	S.supplierID;

    -- Query: A correlated subquery.
    -- Description: Finds the heaviest item and shows what warehouse it’s in.
    SELECT		I1.wareNum, I1.productID, P1.weight
    FROM 			Product P1, Inventory I1
    WHERE			I1.productID = P1.productID AND
    P1.weight = 
(SELECT 	MAX(P2.weight)
 FROM 		Product P2, Inventory I2	
 WHERE	I1.wareNum = I2.wareNum)
    ORDER BY I1.wareNum;

    -- Query: A non-correlated subquery.
    -- Description: Finds the name of every product that has less than 15 number of sold units.
    SELECT 		P.productID, P.proName 
    FROM 			Product P
    WHERE			P.productID NOT IN 
    		(SELECT SH.productID
    		 FROM Sales_History SH
     		 WHERE SH.numSold > 15 )
    ORDER BY P.productID;

    -- Query: A relational DIVISION query.
    -- Description: Finds the name and product ID of every product that is supplied by Walmart.
    SELECT 		P.proName, P.productID
    FROM 			Product P
    WHERE			NOT EXISTS((SELECT S.supName
		FROM 			Supplier S
		WHERE 		S.supName = 'Walmart')
	    MINUS
	    (SELECT 	S.supName
	     FROM		Supplier S, Sells Sel
	     WHERE	P.productID = Sel.productID AND
	     Sel.supplierID = S.supplierID AND
	     S.supName = 'Walmart'))	
    ORDER BY		P.proName;	

    -- Query: An outer join query.
    -- Description: Finds the managerID, manName, manPhoneNum for every manager. Also shows the address of the warehouse they manage.
    SELECT 		M.managerID, M.manName, M.manPhoneNum, W.wareNum
    FROM 			Manager M LEFT OUTER JOIN Warehouse W ON M.wareNum = W.wareNum;

    -- Insert DELETE/UPDATE statements that violate integrity constraints for testing our queries.

    INSERT INTO Inventory VALUES('a', 20, 7);
    INSERT INTO Inventory VALUES(1, 20, 7);
    INSERT INTO Product VALUES (5, 'BUNN', 'Double Coffee Brewer and Warmer', 'An electronic coffee brewer with hot water intake, two glass decanters, a warmer and a brewer.', -2);
    INSERT INTO Sales_History VALUES(-1, -24, 5, 2018);

    COMMIT;
    SPOOL OFF

