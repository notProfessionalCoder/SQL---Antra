--1. a result set is the table result of queries

--2. there are 3 different between union and union all
		-- a. union can remove the duplicates data, And union All will display the duplicates
		-- b. union will sort the result set automatically, and union all will not.
		-- c. union cannot be used in recuresive cte, union all can

--3. Union, Union All, Intersect, and Minus(Except)

--4. Join combines data from many tables base on the match condition, were Union combine the result set of the select statements
--	in join combine more tables, the column may not be the same, but in Union the column most be the same
--	in join can combine different datatype, were UNION must be same datatype
-- in join combine data will be in new columns, and in UNION the data will be in new rows.

--5. INNER JOIN only JOIN the match statements ,and  FULL JOIN joins all data in the tables.

--6. LEFT JOIN joins the left tables with the match of right tables, and OUTER JOIN joins both tables.

--7. CROSS JOIN create the cartesian product of two tables, with no join conditions

--8. Having clause is similar as the where clause but its use in the aggregate functions, and where cannot use to filter the aggregate functions

--9. YES we can have multiple group by columns

--------------queries-------------------	
USE AdventureWorks2019
GO
--1. 
SELECT COUNT(ProductID) AS numberOfProducts
FROM Production.Product

--2.
SELECT COUNT(ProductID)AS NumOfProductWithSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--3.
SELECT ProductSubcategoryID, COUNT(ProductID)AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

--4.
SELECT COUNT(ProductID) AS ProductWithoutSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--5.
SELECT SUM(Quantity) AS SumOfProducts
FROM Production.ProductInventory

--6.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100


--7.
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

--8.
SELECT AVG(Quantity) AS AvgOfQuantity
FROM Production.ProductInventory
WHERE LocationID = 10

--9.
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--10.
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

--11.
SELECT Color, Class, COUNT(ListPrice) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--12.
SELECT PC.Name AS Country, PS.Name AS Province
FROM Person.StateProvince AS PS JOIN Person.CountryRegion AS PC ON PS.CountryRegionCode = PC.CountryRegionCode 

--13.
SELECT PC.Name AS Country, PS.Name AS Province
FROM Person.StateProvince AS PS JOIN Person.CountryRegion AS PC ON PS.CountryRegionCode = PC.CountryRegionCode 
WHERE PC.Name IN ('Germany','Canada')



USE Northwind
GO

--14.
SELECT p.ProductName
FROM Orders AS o JOIN [Order Details] AS od ON o.OrderID = od.OrderID JOIN Products AS p ON p.ProductID = od.ProductID
WHERE YEAR(GETDATE()) - YEAR(o.OrderDate) < 25 
ORDER BY p.ProductName

--15.
SELECT TOP 5 o.ShipPostalCode, MAX(od.quantity) AS quantity
FROM (
SELECT OrderID, SUM(Quantity) AS quantity 
FROM [Order Details] 
GROUP BY OrderID) AS od JOIN Orders AS o ON od.OrderID = o.OrderID
GROUP BY o.ShipPostalCode
ORDER BY quantity DESC

--16.
SELECT TOP 5 o.ShipPostalCode, MAX(od.quantity) AS quantity
FROM (
SELECT OrderID, SUM(Quantity) AS quantity 
FROM [Order Details] 
GROUP BY OrderID) AS od JOIN Orders AS o ON od.OrderID = o.OrderID
WHERE YEAR(GETDATE()) - YEAR(o.OrderDate) < 25 
GROUP BY o.ShipPostalCode
ORDER BY quantity DESC

--17.
SELECT City, COUNT(CustomerID) AS Customers
FROM Customers
GROUP BY City

--18.
SELECT City, COUNT(CustomerID) AS Customers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2

--19.
SELECT c.CompanyName, o.OrderDate
FROM Orders AS o JOIN Customers AS c on c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '1998-01-01'

--20.
SELECT c.CompanyName, o.OrderDate
FROM Orders AS o JOIN Customers AS c on c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC

--21.
SELECT c.CompanyName, SUM(od.Quantity) AS quantity
FROM [Order Details] AS od JOIN Orders AS o ON od.OrderID = o.OrderID JOIN Customers AS c ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY c.CompanyName

--22.
SELECT c.CompanyName, SUM(od.Quantity) AS quantity
FROM [Order Details] AS od JOIN Orders AS o ON od.OrderID = o.OrderID JOIN Customers AS c ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
HAVING SUM(od.Quantity) > 100
ORDER BY c.CompanyName

--23.
SELECT su.CompanyName, sh.CompanyName
FROM Suppliers AS su FULL JOIN Shippers AS sh ON 1 = 1
ORDER BY su.CompanyName

--24.
SELECT o.OrderDate,p.ProductName
FROM Orders AS o JOIN [Order Details] AS od ON o.OrderID = od.OrderID JOIN Products AS p ON p.ProductID = od.ProductID
ORDER BY o.OrderDate

--25.
SELECT e1.FirstName + ' '+ e1.LastName AS name1, e2.FirstName + ' '+ e2.LastName AS name2, e1.Title
FROM Employees AS e1 JOIN Employees AS e2 ON e1.Title = e2.Title
WHERE e1.FirstName NOT IN (e2.FirstName)

--26
SELECT m.FirstName + ' ' +m.LastName AS NAME, COUNT(e.ReportsTo) AS reportNumber
FROM Employees AS e JOIN Employees AS m ON e.ReportsTo = m.EmployeeID
GROUP BY m.FirstName + ' ' +m.LastName
HAVING COUNT(e.ReportsTo) > 2

--27.
SELECT City, CompanyName, ContactName, 'Customer' AS Type
FROM Customers
UNION
SELECT City, CompanyName, ContactName, 'Suppliers' AS Type
FROM Suppliers




