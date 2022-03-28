CREATE TABLE Group
(
  groupId INT NOT NULL,
  PRIMARY KEY (groupId)
);

CREATE TABLE Company
(
  companyId INT NOT NULL,
  groupId INT NOT NULL,
  structure_companyId INT,
  PRIMARY KEY (companyId),
  FOREIGN KEY (groupId) REFERENCES Group(groupId),
  FOREIGN KEY (structure_companyId) REFERENCES Company(companyId)
);

CREATE TABLE Plant
(
  plantId INT NOT NULL,
  companyId INT NOT NULL,
  PRIMARY KEY (plantId),
  FOREIGN KEY (companyId) REFERENCES Company(companyId)
);

CREATE TABLE Item
(
  itemId INT NOT NULL,
  plantId INT NOT NULL,
  PRIMARY KEY (itemId),
  FOREIGN KEY (plantId) REFERENCES Plant(plantId)
);

