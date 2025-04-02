# Creating a new database called CookieByte
CREATE DATABASE CookieByte;
# Set CookieByte as the current database
USE CookieByte;

-- Table: MenuItem
DROP TABLE IF EXISTS MenuItem;
CREATE TABLE MenuItem
(
    ItemID    INT UNIQUE PRIMARY KEY NOT NULL,
    Status    VARCHAR(20)            NOT NULL,
    Category  VARCHAR(50)            NOT NULL,
    Name      VARCHAR(100)           NOT NULL,
    ShelfLife INT                    NOT NULL,
    Price     DECIMAL(10, 2)         NOT NULL,
    Stock     INT                    NOT NULL
);


-- Table: Manager
DROP TABLE IF EXISTS Manager;
CREATE TABLE Manager
(
    ID        INT UNIQUE PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName  VARCHAR(100),
    Phone     VARCHAR(20) UNIQUE,
    Email     VARCHAR(100) UNIQUE,
    Revenue   DECIMAL
);

-- Table: Supplier
DROP TABLE IF EXISTS Supplier;
CREATE TABLE Supplier
(
    ID    INT UNIQUE PRIMARY KEY,
    Name  VARCHAR(100),
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE
);

-- Table: SupplyOrder
DROP TABLE IF EXISTS SupplyOrder;
CREATE TABLE SupplyOrder
(
    ID            INT UNIQUE PRIMARY KEY,
    SupplierID    INT UNIQUE, -- Foreign Key to Supplier
    ManagerID     INT UNIQUE, -- Foreign Key to Manager (who created the order)
    OrderTotal    DECIMAL(10, 2),
    OrderQuantity INT,
    DateOrdered   DATETIME,
    DeliveryDate  DATETIME,
    CONSTRAINT fk_1 FOREIGN KEY (`SupplierID`) REFERENCES Supplier (`ID`)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_2 FOREIGN KEY (`ManagerID`) REFERENCES Manager (`ID`)
        ON UPDATE RESTRICT ON DELETE CASCADE
);

-- Table: Ingredients
DROP TABLE IF EXISTS Ingredients;
CREATE TABLE Ingredients
(
    IngredientID   INT UNIQUE PRIMARY KEY NOT NULL,
    IngredientName VARCHAR(100)           NOT NULL,
    Inventory      INT                    NOT NULL,
    Expiry         INT                    NOT NULL,
    BurnRate       DECIMAL(10, 2)         NOT NULL,
    Price          DECIMAL(10, 2)         NOT NULL
);

-- Table: Materials
DROP TABLE IF EXISTS Materials;
CREATE TABLE Materials
(
    ID        INT UNIQUE PRIMARY KEY,
    Name      VARCHAR(100),
    Price     DECIMAL(10, 2),
    BurnRate  DECIMAL(10, 2),
    Inventory INT
);

-- Table: Equipment
DROP TABLE IF EXISTS Equipment;
CREATE TABLE Equipment
(
    ID       INT UNIQUE PRIMARY KEY,
    Name     VARCHAR(100),
    Price    DECIMAL(10, 2),
    Lifespan INT
);

-- Table: OrderQuantity
-- This table represents the breakdown of a supply order into quantities for ingredients,
-- materials, and equipment.
DROP TABLE IF EXISTS OrderQuantity;
CREATE TABLE OrderQuantity
(
    OrderQuantityID    INT UNIQUE PRIMARY KEY AUTO_INCREMENT,
    OrderID            INT UNIQUE,
    IngredientID       INT UNIQUE DEFAULT NULL,
    MaterialsID        INT UNIQUE DEFAULT NULL,
    EquipmentID        INT UNIQUE DEFAULT NULL,
    IngredientQuantity INT        DEFAULT NULL,
    MaterialQuantity   INT        DEFAULT NULL,
    EquipmentQuantity  INT        DEFAULT NULL,
    CONSTRAINT fk_3 FOREIGN KEY (`OrderID`) REFERENCES SupplyOrder (`ID`)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_4 FOREIGN KEY (`IngredientID`) REFERENCES Ingredients (`IngredientID`)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_5 FOREIGN KEY (`MaterialsID`) REFERENCES Materials (`ID`)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_6 FOREIGN KEY (`EquipmentID`) REFERENCES Equipment (`ID`)
        ON UPDATE RESTRICT ON DELETE CASCADE
);

-- Table: Employee
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee
(
    ID          INT UNIQUE PRIMARY KEY,
    FirstName   VARCHAR(100),
    LastName    VARCHAR(100),
    Position    VARCHAR(50),
    Wage        DECIMAL(10, 2),
    HoursWorked DECIMAL(5, 2),
    ManagerID   INT UNIQUE, -- Foreign Key to Manager
    CONSTRAINT fk_7 FOREIGN KEY (`ManagerID`) REFERENCES Manager (`ID`)
        ON UPDATE RESTRICT ON DELETE SET NULL
);

-- Table: Costs
DROP TABLE IF EXISTS Costs;
CREATE TABLE Costs
(
    CostID        INT UNIQUE PRIMARY KEY AUTO_INCREMENT, -- Surrogate Primary Key ??
    Type          VARCHAR(50),
    PaymentDate   DATETIME,
    PaymentAmount DECIMAL(10, 2),
    ManagerID     INT UNIQUE,                            -- Foreign Key to Manager (who reviews/receives costs)
    CONSTRAINT fk_8 FOREIGN KEY (`ManagerID`) REFERENCES Manager (`ID`)
        ON UPDATE RESTRICT ON DELETE SET NULL
);

-- Table: Sales
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales
(
    SalesID    INT UNIQUE PRIMARY KEY NOT NULL,
    Date       DATETIME               NOT NULL,
    TotalSales DECIMAL(10, 2)         NOT NULL
);

-- Table: TransactionDetails
-- This is a weak entity that details the items in a sale.
DROP TABLE IF EXISTS TransactionDetails;
CREATE TABLE TransactionDetails
(
    SalesID          INT UNIQUE NOT NULL, -- Foreign Key to Sales
    MenuItemID       INT UNIQUE NOT NULL, -- Foreign Key to MenuItem
    MenuItemQuantity INT        NOT NULL,
    Date             DATETIME   NOT NULL,
    EmployeeID       INT UNIQUE,
    PRIMARY KEY (SalesID, MenuItemID),
    CONSTRAINT fk_9 FOREIGN KEY (`SalesID`) REFERENCES Sales (`SalesID`)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_10 FOREIGN KEY (`MenuItemID`) REFERENCES MenuItem (`ItemID`)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_11 FOREIGN KEY (`EmployeeID`) REFERENCES Employee (`ID`)
        ON UPDATE RESTRICT ON DELETE SET NULL
);
