--------------------------------------------------------------------------------
-- Source: A Cloud Guru 'Azure Database Administrator Associate (DP-300)' Course
-- Author: Landon Fowler
-- Purpose: SQL script for creating the 'acsales' database structures.
--------------------------------------------------------------------------------

-- Create the schemas
CREATE SCHEMA sales;
GO
CREATE SCHEMA hr;
GO


-- State Table
CREATE TABLE sales.state (
    state_id int IDENTITY PRIMARY KEY,
    name VARCHAR (50) NOT NULL
);
GO

-- City Table
CREATE TABLE sales.city (
    city_id int IDENTITY PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    state_id INTEGER NOT NULL
);
GO

ALTER TABLE sales.city
ADD CONSTRAINT stfk FOREIGN KEY (state_id) REFERENCES sales.state (state_id);
GO


-- Address Table
CREATE TABLE sales.address (
    addr_id int IDENTITY PRIMARY KEY,
    address VARCHAR (100),
    address2 VARCHAR (100),
    city_id INTEGER NOT NULL,
    postal_code VARCHAR (30)
);
GO

-- Customer Table
CREATE TABLE sales.customer (
   customer_id int IDENTITY PRIMARY KEY,
   first_name VARCHAR (50),
   last_name VARCHAR (50),
   addr_id INTEGER,
   email VARCHAR (100) UNIQUE,
   phone VARCHAR (20)
);
GO

ALTER TABLE sales.customer
ADD CONSTRAINT addrfk FOREIGN KEY (addr_id) REFERENCES sales.address (addr_id);
GO


-- Category Table
CREATE TABLE sales.category (
    cat_id int IDENTITY PRIMARY KEY,
    name VARCHAR (50) UNIQUE,
    description TEXT
);
GO

-- Products Table
CREATE TABLE sales.products (
    id int IDENTITY PRIMARY KEY,
    name VARCHAR (50),
    cat_id INTEGER NOT NULL,
    color VARCHAR (50),
    description TEXT,
    price NUMERIC(6,2)
);
GO

ALTER TABLE sales.products
ADD CONSTRAINT catfk FOREIGN KEY (cat_id) REFERENCES sales.category (cat_id);
GO

-- Payment Table
CREATE TABLE sales.payment (
    payment_id int IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    amount numeric(6,2) NOT NULL,
    payment_date timestamp NOT NULL
);
GO

ALTER TABLE sales.payment
ADD CONSTRAINT custfk FOREIGN KEY (customer_id) REFERENCES sales.customer (customer_id);
GO

-- Staff Table
CREATE TABLE hr.staff (
    staff_id int IDENTITY PRIMARY KEY,
    first_name VARCHAR (50),
    last_name VARCHAR (50),
    addr_id INTEGER,
    email VARCHAR (100) UNIQUE,
    phone VARCHAR (20),
    active BIT DEFAULT 1 NOT NULL,
    username VARCHAR (50) NOT NULL
);
GO

ALTER TABLE hr.staff
ADD CONSTRAINT addrfk FOREIGN KEY (addr_id) REFERENCES sales.address (addr_id);
GO