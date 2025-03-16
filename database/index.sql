-- Eliminar tablas en orden correcto para evitar FK errors
IF OBJECT_ID('InvoiceDiscounts', 'U') IS NOT NULL DROP TABLE InvoiceDiscounts;
IF OBJECT_ID('InvoiceTaxes', 'U') IS NOT NULL DROP TABLE InvoiceTaxes;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
IF OBJECT_ID('Invoices', 'U') IS NOT NULL DROP TABLE Invoices;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Discounts', 'U') IS NOT NULL DROP TABLE Discounts;
IF OBJECT_ID('Taxes', 'U') IS NOT NULL DROP TABLE Taxes;
IF OBJECT_ID('BookingDetails', 'U') IS NOT NULL DROP TABLE BookingDetails;
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
IF OBJECT_ID('Employers', 'U') IS NOT NULL DROP TABLE Employers;
IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
IF OBJECT_ID('Services', 'U') IS NOT NULL DROP TABLE Services;
IF OBJECT_ID('ServiceCategories', 'U') IS NOT NULL DROP TABLE ServiceCategories;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;

-- Crear tabla Customers primero
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    EcuadorID VARCHAR(20) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    BirthDate DATE,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE ServiceCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    DurationMinutes INT NOT NULL CHECK (DurationMinutes > 0),
    Description TEXT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES ServiceCategories(CategoryID)
);

CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Employers (
    EmployerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    RoleID INT NOT NULL,
    DepartmentID INT NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 🔹 Crear tabla `Bookings` antes de `Invoices`
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    EmployerID INT NOT NULL,
    BookingDate DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployerID) REFERENCES Employers(EmployerID)
);

CREATE TABLE BookingDetails (
    BookingDetailID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    DurationMinutes INT NOT NULL CHECK (DurationMinutes > 0),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- 🔹 Crear `Invoices` después de `Bookings`
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    InvoiceDate DATETIME NOT NULL DEFAULT GETDATE(),
    SubTotal DECIMAL(10,2) NOT NULL CHECK (SubTotal >= 0),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Paid', 'Cancelled')),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE TABLE Taxes (
    TaxID INT IDENTITY(1,1) PRIMARY KEY,
    TaxName VARCHAR(100) NOT NULL UNIQUE,
    TaxRate DECIMAL(5,2) NOT NULL CHECK (TaxRate >= 0)
);

CREATE TABLE Discounts (
    DiscountID INT IDENTITY(1,1) PRIMARY KEY,
    DiscountName VARCHAR(100) NOT NULL UNIQUE,
    DiscountRate DECIMAL(5,2) NOT NULL CHECK (DiscountRate >= 0)
);

CREATE TABLE InvoiceTaxes (
    InvoiceTaxID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL,
    TaxID INT NOT NULL,
    TaxAmount DECIMAL(10,2) NOT NULL CHECK (TaxAmount >= 0),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (TaxID) REFERENCES Taxes(TaxID)
);

CREATE TABLE InvoiceDiscounts (
    InvoiceDiscountID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL,
    DiscountID INT NOT NULL,
    DiscountAmount DECIMAL(10,2) NOT NULL CHECK (DiscountAmount >= 0),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (DiscountID) REFERENCES Discounts(DiscountID)
);

CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL CHECK (AmountPaid > 0),
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
