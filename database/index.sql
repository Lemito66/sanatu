CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    EcuadorID VARCHAR(20) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    BirthDate DATE,
    IsActive BIT DEFAULT 1, -- Eliminación lógica
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
    IsActive BIT DEFAULT 1, -- Eliminación lógica
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
    IsActive BIT DEFAULT 1, -- Eliminación lógica
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

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