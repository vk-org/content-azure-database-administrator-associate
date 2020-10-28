-- Turn off autostats for the table
EXEC sp_autostats 'dbo.errorlog', 'OFF'

-- Verify autostats is off
EXEC sp_autostats 'dbo.errorlog'

-- Delete rows from the table
DELETE FROM dbo.errorlog WHERE ErrorLogID > 700

-- Clear the cache
DBCC FREEPROCCACHE

-- Compare estimated and actual query plan
SELECT * FROM dbo.errorlog WHERE ErrorLogID > 200

-- Manually update the statistics
UPDATE STATISTICS dbo.errorlog

-- Verify last update date
EXEC sp_autostats 'dbo.errorlog'

-- Clear the cache
DBCC FREEPROCCACHE

-- Compare the plans again
SELECT * FROM dbo.errorlog WHERE ErrorLogID > 200