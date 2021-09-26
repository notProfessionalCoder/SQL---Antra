-- 1. simplicity£¬ view can convert complicity query into virtual view tables which we don't have to deal with complix query everytime
		--data more secure because its a virtual tables the changes in view will not affect data in database

--2. no the changes in view will not affect the data in database

--3. store procedures is a prepared sql code that you can save, and reused again in the future

--4. a view is store as a table data and base on the select query, and a stored procedure is a group of statement that can be executed

--5. Store Procedure is used in DML,and function is more used in calculations
		--Store Procedure is call by executing the name, and function can call in the SELECT statement
		--function must have input parameter and return values, Store Procedure can choose to
		--store procedure can call functions but functions cannot call sp

--6. yes

--7. Store Procedure cannot be used in the select statement, you can rewrite the code in functions and call in select

--8. Trigger is kind like event listener, it automatically execute when the specify instruction is called, there are four types of trigger DML trigger,CLR trigger,DDL trigger AND LOGON trigger

--9. the scenarios of trigger is when somethings happend and you want to do something with the event, for example u insert/ delete some data and you also want to see what happend to the data
	--you can create a select trigger for insert and delete, everytime you insert/delect the data, a select statement will execute

--10. trigger is automatically called, and store procedure is store code there u have to execute everytime

------------------QUERY--------------

----pass 1,2,3, 7,8


--4. 
CREATE VIEW view_product_order_CHEN AS
SELECT p.ProductName , SUM(od.Quantity) AS TotalQuantity
FROM Products AS p JOIN [Order Details] AS od ON od.ProductID = p.ProductID
GROUP BY p.ProductName

--5.

CREATE PROCEDURE sp_product_order_quantity_CHEN @Id int, @Quantity int out
AS
BEGIN
SELECT 
@Quantity = SUM(od.Quantity)
FROM Products AS p JOIN [Order Details] AS od ON od.ProductID = p.ProductID
WHERE p.ProductID = @Id
GROUP BY p.ProductID
END

--6.
CREATE PROCEDURE sp_product_order_city_CHEN @Name varchar(20), @City varchar(20) out,@Quantity int out
AS
BEGIN
SELECT @City = o.ShipCity, @Quantity = SUM(od.Quantity)
FROM Products AS p JOIN [Order Details] AS od ON od.ProductID = p.ProductID JOIN Orders AS o ON o.OrderID = od.OrderID
WHERE p.ProductName = @Name
GROUP BY o.ShipCity
END

--9.
CREATE TABLE city_CHEN
(	
	Id int NOT NULL PRIMARY KEY,
	City VARCHAR(20) UNIQUE NOT NULL
)
CREATE TABLE people_CHEN
(
	Id int NOT NULL PRIMARY KEY,
	Name VARCHAR(20) NOT NULL,
	City int FOREIGN KEY REFERENCES city_Chen(Id) ON DELETE SET NULL
)
INSERT INTO city_CHEN VALUES (1,'Seattle'),(2,'Green Bay')
INSERT INTO people_CHEN VALUES(1,'Aaron Rodgers',2),(2,'Russell Wilson',1),(3,'Jody Nelson',2)

DROP TABLE people_CHEN

DELETE FROM city_CHEN
WHERE City = 'Seattle'

INSERT INTO city_CHEN VALUES(3,'Madison')

UPDATE people_CHEN SET City = 3 WHERE City IS NULL


CREATE VIEW Packers_CHEN AS
SELECT p.Name
FROM city_CHEN AS c JOIN people_CHEN AS p ON P.City = c.Id
WHERE c.City = 'Green Bay'

--10.
CREATE PROC sp_birthday_employees_CHEN
AS
BEGIN
CREATE TABLE birthday_employees_CHEN
(
	Id INT NOT NULL PRIMARY KEY,
	Name VARCHAR(20),
	birthday DATETIME
)

INSERT INTO birthday_employees_CHEN
SELECT EmployeeID,FirstName + ' ' + LastName, BirthDate
FROM Employees
WHERE MONTH(BirthDate) = 2

SELECT *FROM birthday_employees_CHEN

DROP TABLE birthday_employees_CHEN
END

--11.
CREATE PROC sp_chen_1
AS
BEGIN
SELECT c.City
FROM Customers AS c LEFT JOIN Orders AS o ON o.CustomerID = c.CustomerID LEFT JOIN [Order Details] AS od ON od.OrderID = o.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) < 2 AND COUNT(c.CustomerID) > 1
END


SELECT City, COUNT(CustomerID)
FROM Customers
GROUP BY City

CREATE PROC sp_chen_2
AS
BEGIN
SELECT City 
FROM Customers
WHERE CustomerID NOT IN
(
	SELECT o.CustomerID
	FROM Orders AS o JOIN [Order Details] AS od ON od.OrderID = o.OrderID
	GROUP BY o.CustomerID
	HAVING COUNT(od.ProductID) > 1
)
GROUP BY City
HAVING COUNT(CustomerID) >= 2
END

--12.I DON'T GET THE QUESTIONS


--14.
SELECT [FIRST NAME] + ' ' + [LAST NAME] + ' ' + ISNULL([MIDDLE NAME]+'.','') AS [FULL NAME]
FROM XXXTABLE

--15.
SELECT MAX(Marks)
FROM XXXTABLE
WHERE Sex = 'F'

--16.
SELECT STUDENT,MARKS,SEX
FROM XXXTABLE
ORDER BY SEX,MARKS DESC




