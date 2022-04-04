--3NF
CREATE TABLE IF NOT EXISTS Items (
  itemId serial NOT NULL PRIMARY KEY,
  itemName varchar(100) NOT NULL,
  price float NOT NULL
);

CREATE TABLE IF NOT EXISTS Customers (
  customerId serial NOT NULL PRIMARY KEY,
  customerName varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cities (
  cityId serial NOT NULL PRIMARY KEY,
  cityName varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
  orderId serial NOT NULL PRIMARY KEY,
  cityId integer NOT NULL REFERENCES Cities(cityId)
  orderDate date NOT NULL,
);

CREATE TABLE IF NOT EXISTS CusomersOrders (
  id serial NOT NULL PRIMARY KEY,
  customerId integer NOT NULL REFERENCES Customers(customerId),
  orderId integer NOT NULL REFERENCES Orders(orderId)
);

CREATE TABLE IF NOT EXISTS OrdersItems (
  id serial NOT NULL PRIMARY KEY,
  orderId integer NOT NULL REFERENCES Orders(orderId),
  itemId integer NOT NULL REFERENCES Items(itemId),
  quantity integer NOT NULL
);

--Calculate the total number of items per order and the total amount to pay for the order:

SELECT o.orderId,
       SUM(oi.quantity) AS "Total Number of Items",
       SUM(i.price * oi.quantity) AS "Total Cost"
FROM Orders o
JOIN OrdersItems oi ON o.orderId = oi.orderId
JOIN Items i ON oi.itemId = i.itemId
GROUP BY o.orderId;

--Obtain the customer whose purchase in terms of money has been greater than the others:
SELECT c.customerId, c.customerName
FROM Customers as c
JOIN CustomersOrders AS co ON co.customerId = c.customerId
JOIN Orders AS o ON o.orderId = co.orderId
JOIN OrdersItems AS oi ON oi.orderId = o.orderId
JOIN Items AS i ON oi.itemId = i.itemId
GROUP BY c.customerId
HAVING SUM(i.price * oi.quantity) = MAX(SUM(i.price * oi.quantity))