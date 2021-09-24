--1. if both join and subqueries can be used , its better to use the joins, which had better performence

--2. CTE stands for common table expression, its used to rap the code into more readable code, and it can recursive them-self

--3. table variable is a variable that declear as a table type, its use in same batch execution the create in system database called tempdb

--4. DELETE IS USE TO delete the rows from a tables, and TRUNCATE is used to delete all the rows from the table and free the space containing the table.
		-- IF WE WANT TO DELETE A SINGLE DATA WE USE DETELE, IF WE WANT TO DELETE ALL THE DATA IN TABLES  WE USE TRUNCATE, THE PERFORMANCE DEPEND ON THE USED

--5. indentity column is the column that genery the value by the database, when you create and set the column with auto increment.
	-- by using delete it will delete the rows in the datatable but did not reset the seed value of the identity, and TRUNCATE delete all the data include the seed value.


--6. delete from table_name means delete one rows in that tables. truncate table table_name means delete all the data in that tables

---------------queries------------

--1.
SELECT distinct e.City
FROM Employees as e JOIN Customers AS c ON e.City = c.City

--2. a
SELECT DISTINCT C.City
FROM Customers AS C
WHERE City NOT IN
(
SELECT City
FROM Employees
)
--2. B
SELECT DISTINCT c.City
FROM Customers AS c LEFT JOIN Employees AS e ON c.City = e.City
WHERE e.City IS NULL

--3.
SELECT p.ProductName, COUNT(od.Quantity) AS Totalquantity
FROM Products AS p JOIN [Order Details] AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

--4.
SELECT c.City, COUNT(od.Quantity) AS TotalOrder
FROM Customers AS c JOIN Orders AS o ON o.CustomerID = c.CustomerID JOIN [Order Details] AS od ON od.OrderID = o.OrderID
GROUP BY c.City

--5. a  I THINK THERE IS PROBLEM WITH THIS QUESTION 
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
UNION 
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2


--5. b
SELECT distinct c1.City
FROM Customers AS c1 JOIN 
(
SELECT CITY,CompanyName
FROM Customers
) AS c2 ON c1.City = c2.City AND c1.CompanyName != c2.CompanyName

--6.
SELECT c.City, od.OrderID ,COUNT(od.ProductID) AS NumbsOfProduct
FROM Customers AS c JOIN Orders AS o ON o.CustomerID = c.CustomerID JOIN [Order Details] AS od ON od.OrderID = o.OrderID
GROUP BY c.City,od.OrderID
HAVING COUNT(od.ProductID) >= 2

--7.
SELECT DISTINCT c.CompanyName, c.ContactName
FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE o.ShipCity != c.City

--8.
SELECT p.ProductName, dt.TotalSale, dt.City
FROM Products AS p JOIN
(
SELECT psale.ProductID, psale.ProductName, PSALE.TotalSale, c.City,MAX(od.Quantity) AS MAXQUANTITY,RANK() OVER(PARTITION BY psale.ProductName ORDER BY MAX(od.Quantity) DESC) AS RNK
FROM 
(SELECT TOP 5 p.ProductID, p.ProductName, AVG(od.UnitPrice*od.Quantity) TotalSale
FROM Products AS p JOIN [Order Details] AS od on od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSale DESC
) AS psale JOIN [Order Details] AS od ON od.ProductID = psale.ProductID JOIN Orders AS o ON o.OrderID = od.OrderID JOIN Customers AS c ON c.CustomerID = O.CustomerID
GROUP BY psale.ProductID,psale.ProductName, PSALE.TotalSale,c.City
) AS dt ON p.ProductID = dt.ProductID
WHERE RNK = 1

--9. a
SELECT e.City
FROM Employees AS e JOIN
(
SELECT CompanyName,City
FROM Customers 
WHERE CustomerID NOT IN
(SELECT CustomerID
FROM Orders
)) AS dt ON e.City = dt.City

--9. b
SELECT c.City
FROM Customers AS c LEFT JOIN Orders AS o ON O.CustomerID = C.CustomerID JOIN Employees AS e ON e.City = c.City
WHERE O.CustomerID IS NULL

--10. HARD TO READ THE QUESTION

SELECT o.ShipCity, COUNT(od.Quantity) AS productsold
FROM Products AS p JOIN [Order Details] AS od ON od.ProductID = p.ProductID JOIN Orders AS o ON o.OrderID = od.OrderID,(
SELECT TOP 1 e.City, e.EmployeeID, COUNT(o.OrderID) AS mostORDER 
FROM Orders AS o JOIN Employees AS e ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.City
ORDER BY mostORDER DESC
) as dt
WHERE o.ShipCity = dt.City
GROUP BY o.ShipCity


-- 11. USE DISTINCT 
--13. 
SELECT d.deptname, dt.empnumb
FROM Dept AS d JOIN 
(
SELECT d.deptname,COUNT(e.empid) AS empnumb, RANK()OVER(PARTITION BY d.deptname ORDER BY COUNT(e.empid) DESC) AS RNK
FROM Dept AS d JOIN Employee as e ON e.deptid = d.deptid
GROUP BY deptname
)AS dt ON dt.deptid = d.deptid
WHERE RNK = 1

--14.
SELECT d.deptname, dt.empid, dt.salary
FROM Dept AS d JOIN 
(
SELECT d.deptname, e.empid, e.salary, RANK()OVER(PARTITION BY d.deptname ORDER BY MAX(e.salary) DESC) AS RNK
FROM Dept AS d JOIN Employee as e ON e.deptid = d.deptid
GROUP BY deptname
)AS dt
WHERE RNK IN (1,2,3) 
ORDER BY d.deptname
