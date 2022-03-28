CREATE TABLE Salesperson
(
  salespersonId INT NOT NULL,
  PRIMARY KEY (salespersonId)
);

CREATE TABLE Customer
(
  customerId INT NOT NULL,
  PRIMARY KEY (customerId)
);

CREATE TABLE Service
(
  serviceId INT NOT NULL,
  PRIMARY KEY (serviceId)
);

CREATE TABLE DealerShip
(
  dealerShipId INT NOT NULL,
  PRIMARY KEY (dealerShipId)
);

CREATE TABLE Mechanic
(
  mechanicId INT NOT NULL,
  PRIMARY KEY (mechanicId)
);

CREATE TABLE has
(
  dealerShipId INT NOT NULL,
  serviceId INT NOT NULL,
  PRIMARY KEY (dealerShipId, serviceId),
  FOREIGN KEY (dealerShipId) REFERENCES DealerShip(dealerShipId),
  FOREIGN KEY (serviceId) REFERENCES Service(serviceId)
);

CREATE TABLE has
(
  serviceId INT NOT NULL,
  mechanicId INT NOT NULL,
  PRIMARY KEY (serviceId, mechanicId),
  FOREIGN KEY (serviceId) REFERENCES Service(serviceId),
  FOREIGN KEY (mechanicId) REFERENCES Mechanic(mechanicId)
);

CREATE TABLE Car
(
  serialNumber INT NOT NULL,
  salespersonId INT NOT NULL,
  customerId INT NOT NULL,
  PRIMARY KEY (serialNumber),
  FOREIGN KEY (salespersonId) REFERENCES Salesperson(salespersonId),
  FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);

CREATE TABLE repairCar
(
  serviceTicket VARCHAR NOT NULL,
  parts INT NOT NULL,
  serialNumber INT NOT NULL,
  serviceId INT NOT NULL,
  PRIMARY KEY (serialNumber, serviceId),
  FOREIGN KEY (serialNumber) REFERENCES Car(serialNumber),
  FOREIGN KEY (serviceId) REFERENCES Service(serviceId)
);
