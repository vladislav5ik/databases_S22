CREATE TABLE Airport
(
  IATACode VARCHAR(4) NOT NULL,
  PRIMARY KEY (IATACode)
);

CREATE TABLE Flight
(
  flightNum INT NOT NULL,
  PRIMARY KEY (flightNum)
);

CREATE TABLE AircraftType
(
  typeId INT NOT NULL,
  PRIMARY KEY (typeId)
);

CREATE TABLE DailyFlightLegCombination
(
  DFLegId INT NOT NULL,
  PRIMARY KEY (DFLegId)
);

CREATE TABLE CanLand
(
  IATACode VARCHAR(4) NOT NULL,
  typeId INT NOT NULL,
  PRIMARY KEY (IATACode, typeId),
  FOREIGN KEY (IATACode) REFERENCES Airport(IATACode),
  FOREIGN KEY (typeId) REFERENCES AircraftType(typeId)
);

CREATE TABLE AssignedTo
(
  typeId INT NOT NULL,
  DFLegId INT NOT NULL,
  PRIMARY KEY (typeId, DFLegId),
  FOREIGN KEY (typeId) REFERENCES AircraftType(typeId),
  FOREIGN KEY (DFLegId) REFERENCES DailyFlightLegCombination(DFLegId)
);

CREATE TABLE FlightLeg
(
  flightLegId INT NOT NULL,
  IATACode VARCHAR(4) NOT NULL,
  EndsAtIATACode VARCHAR(4) NOT NULL,
  flightNum INT NOT NULL,
  PRIMARY KEY (flightLegId),
  FOREIGN KEY (IATACode) REFERENCES Airport(IATACode),
  FOREIGN KEY (EndsAtIATACode) REFERENCES Airport(IATACode),
  FOREIGN KEY (flightNum) REFERENCES Flight(flightNum)
);

CREATE TABLE PartOf
(
  DFLegId INT NOT NULL,
  flightLegId INT NOT NULL,
  PRIMARY KEY (DFLegId, flightLegId),
  FOREIGN KEY (DFLegId) REFERENCES DailyFlightLegCombination(DFLegId),
  FOREIGN KEY (flightLegId) REFERENCES FlightLeg(flightLegId)
);
