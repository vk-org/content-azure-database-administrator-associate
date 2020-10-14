####################################################################
# Source: A Cloud Guru Azure Database Administrator Associate Course
# Author: Landon Fowler
# Purpose: Script to generate load against Azure SQL Database
# Date Updated: 10/14/2020
####################################################################

# Parameters
param (
    $instance
)

# Variables
$database = "acweb"
$query1 = "SELECT Name FROM SalesLT.Product ORDER BY ProductID"
$query2 = "SELECT * FROM SalesLT.ProductDescription"
$query3 = "SELECT ProductID,UnitPrice FROM SalesLT.SalesOrderDetail "

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