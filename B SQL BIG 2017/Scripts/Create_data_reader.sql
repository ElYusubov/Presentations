
CREATE USER ApplicationUser WITH PASSWORD = 'YourStrongPassword1';
GO

ALTER ROLE db_datareader ADD MEMBER ApplicationUser;
GO
ALTER ROLE db_datawriter ADD MEMBER ApplicationUser;
GO