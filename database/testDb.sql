INSERTAR DATOS REALES

INSERT INTO Customers (Name, EcuadorID, PhoneNumber, Email, BirthDate) 
VALUES ('María López', '1723456789', '0991234567', 'maria.lopez@email.com', '1995-06-15');

INSERT INTO ServiceCategories (CategoryName) VALUES ('Hairdressing');

INSERT INTO Services (ServiceName, CategoryID, Price, DurationMinutes) 
VALUES ('Haircut', 1, 20.00, 30);

INSERT INTO Roles (RoleName) VALUES ('Stylist');
INSERT INTO Departments (DepartmentName) VALUES ('Hairdressing');

INSERT INTO Employers (Name, PhoneNumber, Email, RoleID, DepartmentID) 
VALUES ('Ana Ramírez', '0995551234', 'ana.ramirez@salon.com', 1, 1);

INSERT INTO Bookings (CustomerID, EmployerID, BookingDate, Status)
VALUES (1, 1, CONVERT(DATETIME, '2025-03-20 10:00:00', 120), 'Scheduled');

INSERT INTO BookingDetails (BookingID, ServiceID, Price, DurationMinutes)
VALUES (1, 1, 20.00, 30);

INSERT INTO PaymentMethods (MethodName) VALUES ('Cash'), ('Credit Card');

INSERT INTO Taxes (TaxName, TaxRate) VALUES ('IVA', 12.00);

INSERT INTO Discounts (DiscountName, DiscountRate) VALUES ('Loyalty Discount', 10.00);

INSERT INTO Invoices (BookingID, SubTotal, TotalAmount, Status)
VALUES (1, 20.00, 22.40, 'Pending');

INSERT INTO Payments (InvoiceID, PaymentMethodID, AmountPaid)
VALUES (1, 2, 22.40);