CREATE TABLE Order
(
  orderId INT NOT NULL,
  date DATE NOT NULL,
  house VARCHAR(100) NOT NULL,
  street VARCHAR(100) NOT NULL,
  district VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  PRIMARY KEY (orderId)
);

CREATE TABLE Item
(
  itemId INT NOT NULL,
  description VARCHAR(1000) NOT NULL,
  PRIMARY KEY (itemId)
);

CREATE TABLE Manufacturer
(
  manufacturerId INT NOT NULL,
  phonenumber VARCHAR(11) NOT NULL,
  PRIMARY KEY (manufacturerId)
);

CREATE TABLE includes
(
  quantity INT NOT NULL,
  orderId INT NOT NULL,
  itemId INT NOT NULL,
  PRIMARY KEY (orderId, itemId),
  FOREIGN KEY (orderId) REFERENCES Order(orderId),
  FOREIGN KEY (itemId) REFERENCES Item(itemId)
);

CREATE TABLE produce
(
  quantity INT NOT NULL,
  itemId INT NOT NULL,
  manufacturerId INT NOT NULL,
  PRIMARY KEY (itemId, manufacturerId),
  FOREIGN KEY (itemId) REFERENCES Item(itemId),
  FOREIGN KEY (manufacturerId) REFERENCES Manufacturer(manufacturerId)
);

CREATE TABLE Customer
(
  house VARCHAR(100) NOT NULL,
  street VARCHAR(100) NOT NULL,
  district VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  clientId INT NOT NULL,
  balance INT NOT NULL,
  discount INT NOT NULL,
  creditLimit INT NOT NULL,
  orderId INT NOT NULL,
  PRIMARY KEY (clientId),
  FOREIGN KEY (orderId) REFERENCES Order(orderId)
);
