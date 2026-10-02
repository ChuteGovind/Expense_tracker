USE expense_tracker;
INSERT INTO transactions(type,category,title,amount,transaction_date,note,created_at,updated_at) VALUES
('INCOME','Salary','Monthly salary',45000.00,CURRENT_DATE,'Demo income',NOW(),NOW()),
('EXPENSE','Food','Groceries',4200.00,CURRENT_DATE,'Monthly groceries',NOW(),NOW()),
('EXPENSE','Rent','Apartment rent',12000.00,CURRENT_DATE,'Monthly rent',NOW(),NOW()),
('EXPENSE','Transport','Fuel',1800.00,CURRENT_DATE,'Bike fuel',NOW(),NOW()),
('EXPENSE','Entertainment','Movie night',750.00,CURRENT_DATE,'Weekend',NOW(),NOW());
