####################################################################
# Source: A Cloud Guru Azure Database Administrator Associate Course
# Author: Landon Fowler
# Purpose: Script to generate load against Azure SQL Database
# Date Updated: 10/05/2020
####################################################################

# Parameters
param (
    $instance
)

# Variables
$database = "acweb"
$query1 = "INSERT INTO SalesLT.Customer (FirstName, LastName, CompanyName, EmailAddress, PasswordHash, PasswordSalt)
VALUES ('Delmar', 'Database', 'A Cloud Guru', 'delmar@acloud.guru', 'L/Rlwxzp4w7RWmEgXX+/A7cXaePEPcp+KwQhl2fJL7w=', '1KjXYs4=')"
$query2 = "SELECT p.ProductID, p.Name, pm.Name AS ProductModel, pmx.Culture, pd.Description
FROM [SalesLT].[Product] p
INNER JOIN [SalesLT].[ProductModel] pm
ON p.ProductModelID = pm.ProductModelID
INNER JOIN [SalesLT].[ProductModelProductDescription] pmx
ON pm.ProductModelID = pmx.ProductModelID
INNER JOIN [SalesLT].[ProductDescription] pd
ON pmx.ProductDescriptionID = pd.ProductDescriptionID
ORDER BY p.ProductID"
$query3 = "SELECT Name FROM SalesLT.Product ORDER BY ProductID"

# Iterator
$i = 1

# Function to insert rows and select large amounts of data
function run_sql {
    Invoke-SQLCMD -ServerInstance $instance -Database $database -Query $query1 -Username delmar -Password "AwesomePassword!"
    Invoke-SQLCMD -ServerInstance $instance -Database $database -Query $query2 -Username delmar -Password "AwesomePassword!"
    Invoke-SQLCMD -ServerInstance $instance -Database $database -Query $query3 -Username delmar -Password "AwesomePassword!"
}

# Infinitely loop and call the run_sql function
while ($i -lt 2) {
    run_sql
}