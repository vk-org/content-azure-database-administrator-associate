----------------------------------------------------------------------
-- Source: A Cloud Guru Azure Database Administrator Associate Course
-- Author: Landon Fowler
-- Purpose: Demo for Elastic Jobs
-- Date Updated: 01/27/2021
----------------------------------------------------------------------

-------------------------------
-- Prerequisites
-------------------------------

-- 1: Create an Azure SQL Database to be the Job Database.
-- 2: Deploy an Elastic Job Agent using that database.

-------------------------------
-- Create Credentials
-------------------------------

---- Connect to the jobs database server. ----

-- Create a database master key on the job database.
CREATE MASTER KEY ENCRYPTION BY PASSWORD='AwesomePassword!';  
  
-- Create a database scoped credential for running jobs against the target.
CREATE DATABASE SCOPED CREDENTIAL acjobcred WITH IDENTITY = 'jobcred',
    SECRET = 'AwesomePassword!';
GO

-- Create a database scoped credential for refreshing the target database list.
CREATE DATABASE SCOPED CREDENTIAL acmastercred WITH IDENTITY = 'mastercred',
    SECRET = 'AwesomePassword!';
GO

-- Verify the credentials.
SELECT * FROM sys.database_scoped_credentials

---- Connect to the target server and create the logins and users. ----

-- Using the master databese, create the logins and master credential user.
CREATE LOGIN mastercred
WITH PASSWORD = 'AwesomePassword!'; 
 
CREATE LOGIN jobcred
WITH PASSWORD = 'AwesomePassword!'; 
 
CREATE USER mastercred
FROM LOGIN mastercred

-- Using the target database, create a database user and assign permissions.

create user jobcred
from login jobcred
 
ALTER ROLE db_owner 
ADD MEMBER jobcred ;  
GO

-------------------------------
-- Create target group
-------------------------------

---- Connect to the jobs database. ----

-- Add a target group containing server(s).
EXEC jobs.sp_add_target_group 'ACServerGroup'

-- Add a server target member.
EXEC jobs.sp_add_target_group_member
'ACServerGroup',
@target_type = 'SqlServer',
@refresh_credential_name = 'acmastercred', --credential required to refresh the databases in a server
@server_name = 'acsql-7777.database.windows.net'

-- View the recently created target group and target group members.
SELECT * FROM jobs.target_groups WHERE target_group_name='ACServerGroup';
SELECT * FROM jobs.target_group_members WHERE target_group_name='ACServerGroup';


-------------------------------
-- Create job
-------------------------------

---- Connect to the jobs database. ----

-- Add a job for updating statistics.
EXEC jobs.sp_add_job @job_name = 'UpdateStats', @description = 'Update statistics'

-- Add a job step for updating statistics.
EXEC jobs.sp_add_jobstep @job_name = 'UpdateStats',
@command = N'EXEC sp_updatestats;',
@credential_name = 'acjobcred',
@target_group_name = 'ACServerGroup'

-------------------------------
-- Schedule and run job
-------------------------------

-- Execute the latest version of a job.
EXEC jobs.sp_start_job 'UpdateStats'

--View top-level execution status for the job.
SELECT * FROM jobs.job_executions
WHERE is_active = 1

-- Cancel job execution with the specified job execution id.
EXEC jobs.sp_stop_job 'AB1925BB-DAE7-412C-93FF-81E413FBB75C'

-- Schedule the job.
EXEC jobs.sp_update_job
@job_name = 'UpdateStats',
@enabled=1,
@schedule_interval_type = 'Weeks',
@schedule_interval_count = 1