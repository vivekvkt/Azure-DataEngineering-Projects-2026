-- =========================================================
-- INSURANCE DATA ENGINEERING PROJECT
-- PostgreSQL Source Database Setup
-- Schema: operational
-- db : insurance_db
-- =========================================================

DROP SCHEMA IF EXISTS operational CASCADE;

CREATE SCHEMA operational;

-- =========================================================
-- CUSTOMERS
-- =========================================================

CREATE TABLE operational.customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender VARCHAR(20),
    date_of_birth DATE,
    email VARCHAR(255),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- AGENTS
-- =========================================================

CREATE TABLE operational.agents (
    agent_id SERIAL PRIMARY KEY,
    agent_name VARCHAR(200),
    license_number VARCHAR(100),
    region VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(255),
    hire_date DATE,
    commission_rate NUMERIC(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- POLICIES
-- =========================================================

CREATE TABLE operational.policies (
    policy_id SERIAL PRIMARY KEY,
    policy_number VARCHAR(50) UNIQUE,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    policy_type VARCHAR(100),
    premium_amount NUMERIC(12,2),
    coverage_amount NUMERIC(12,2),
    start_date DATE,
    end_date DATE,
    policy_status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customer
    FOREIGN KEY(customer_id)
    REFERENCES operational.customers(customer_id),

    CONSTRAINT fk_agent
    FOREIGN KEY(agent_id)
    REFERENCES operational.agents(agent_id)
);

-- =========================================================
-- CLAIMS
-- =========================================================

CREATE TABLE operational.claims (
    claim_id SERIAL PRIMARY KEY,
    policy_id INT NOT NULL,
    customer_id INT NOT NULL,
    claim_date DATE,
    incident_date DATE,
    processed_date DATE,
    claim_amount NUMERIC(12,2),
    approved_amount NUMERIC(12,2),
    claim_status VARCHAR(50),
    fraud_flag BOOLEAN DEFAULT FALSE,
    claim_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_policy
    FOREIGN KEY(policy_id)
    REFERENCES operational.policies(policy_id),

    CONSTRAINT fk_claim_customer
    FOREIGN KEY(customer_id)
    REFERENCES operational.customers(customer_id)
);

-- =========================================================
-- INSERT CUSTOMERS
-- =========================================================

INSERT INTO operational.customers
(first_name,last_name,gender,date_of_birth,email,phone,address,city,state,zip_code)
VALUES
('John','Smith','Male','1985-01-15','john.smith@email.com','9876543210','21 Main Street','New York','NY','10001'),
('Emma','Watson','Female','1990-05-21','emma.w@email.com','9876543211','54 Lake Road','Chicago','IL','60007'),
('David','Miller','Male','1988-11-02','david.m@email.com','9876543212','77 Hill Street','Dallas','TX','75001'),
('Sophia','Wilson','Female','1992-03-18','sophia@email.com','9876543213','5 Oak Avenue','Seattle','WA','98101'),
('Michael','Brown','Male','1980-07-09','michael@email.com','9876543214','62 Green Park','Boston','MA','02101'),
('Olivia','Taylor','Female','1994-08-12','olivia@email.com','9876543215','90 Sunset Blvd','Phoenix','AZ','85001'),
('James','Anderson','Male','1987-09-25','james@email.com','9876543216','41 River View','Denver','CO','80014'),
('Ava','Thomas','Female','1993-10-10','ava@email.com','9876543217','18 Central Park','Miami','FL','33101'),
('William','Jackson','Male','1981-12-05','william@email.com','9876543218','73 Maple Road','Atlanta','GA','30301'),
('Mia','White','Female','1995-02-14','mia@email.com','9876543219','28 Pine Street','Houston','TX','77001');


INSERT INTO operational.customers
(first_name,last_name,gender,date_of_birth,email,phone,address,city,state,zip_code)
VALUES
('Ethan','Harris','Male','1986-04-12','ethan.harris@email.com','9876543221','101 Elm Street','San Diego','CA','92101'),
('Charlotte','Martin','Female','1991-06-15','charlotte.m@email.com','9876543222','202 Cedar Road','Portland','OR','97201'),
('Benjamin','Clark','Male','1984-09-28','ben.clark@email.com','9876543223','303 Birch Avenue','Nashville','TN','37201'),
('Amelia','Lewis','Female','1993-01-19','amelia.lewis@email.com','9876543224','404 Willow Drive','Las Vegas','NV','89101'),
('Lucas','Walker','Male','1988-07-23','lucas.walker@email.com','9876543225','505 Aspen Lane','Austin','TX','73301'),
('Harper','Hall','Female','1995-03-05','harper.hall@email.com','9876543226','606 Cherry Street','Orlando','FL','32801'),
('Alexander','Allen','Male','1982-11-11','alex.allen@email.com','9876543227','707 Spruce Court','Detroit','MI','48201'),
('Evelyn','Young','Female','1994-08-17','evelyn.young@email.com','9876543228','808 Walnut Road','Columbus','OH','43004'),
('Daniel','King','Male','1987-02-26','daniel.king@email.com','9876543229','909 Magnolia Ave','Kansas City','MO','64101'),
('Abigail','Scott','Female','1992-12-30','abigail.scott@email.com','9876543230','111 Park View','Raleigh','NC','27601'),
('Matthew','Green','Male','1985-05-09','matthew.green@email.com','9876543231','112 River Road','Salt Lake City','UT','84101'),
('Ella','Baker','Female','1990-10-20','ella.baker@email.com','9876543232','113 Forest Lane','Minneapolis','MN','55401'),
('Joseph','Adams','Male','1989-03-14','joseph.adams@email.com','9876543233','114 Sunrise Blvd','Tampa','FL','33601'),
('Scarlett','Nelson','Female','1996-01-25','scarlett.nelson@email.com','9876543234','115 Sunset Avenue','Charlotte','NC','28201'),
('Samuel','Carter','Male','1983-08-08','samuel.carter@email.com','9876543235','116 Highland Road','Indianapolis','IN','46201'),
('Grace','Mitchell','Female','1991-09-13','grace.mitchell@email.com','9876543236','117 Brook Street','St. Louis','MO','63101'),
('Henry','Perez','Male','1986-06-22','henry.perez@email.com','9876543237','118 Valley Drive','Cincinnati','OH','45201'),
('Chloe','Roberts','Female','1993-04-07','chloe.roberts@email.com','9876543238','119 Ocean View','Jacksonville','FL','32099'),
('Sebastian','Turner','Male','1987-12-18','sebastian.turner@email.com','9876543239','120 Mountain Road','Albuquerque','NM','87101'),
('Lily','Phillips','Female','1994-11-02','lily.phillips@email.com','9876543240','121 Lake Shore','Milwaukee','WI','53201');
-- =========================================================
-- INSERT AGENTS
-- =========================================================

INSERT INTO operational.agents
(agent_name,license_number,region,phone,email,hire_date,commission_rate)
VALUES
('Robert Brown','LIC1001','East','9000011111','robert@insurance.com','2021-01-10',5.00),
('Sarah Johnson','LIC1002','West','9000011112','sarah@insurance.com','2020-03-15',6.50),
('Michael Davis','LIC1003','Central','9000011113','michael@insurance.com','2019-08-12',7.00),
('Emily Clark','LIC1004','North','9000011114','emily@insurance.com','2022-02-02',5.50),
('Daniel Moore','LIC1005','South','9000011115','daniel@insurance.com','2021-05-20',6.00);

-- =========================================================
-- INSERT POLICIES
-- =========================================================

INSERT INTO operational.policies
(policy_number,customer_id,agent_id,policy_type,premium_amount,
coverage_amount,start_date,end_date,policy_status)
VALUES
('POL10001',1,1,'Health',1200.00,100000.00,'2024-01-01','2024-12-31','ACTIVE'),
('POL10002',2,2,'Auto',1500.00,75000.00,'2024-02-01','2025-01-31','ACTIVE'),
('POL10003',3,3,'Life',2500.00,300000.00,'2024-03-01','2034-03-01','ACTIVE'),
('POL10004',4,4,'Home',1800.00,150000.00,'2024-04-01','2025-03-31','ACTIVE'),
('POL10005',5,5,'Health',1100.00,120000.00,'2024-05-01','2025-04-30','ACTIVE'),
('POL10006',6,1,'Auto',1700.00,90000.00,'2024-06-01','2025-05-31','ACTIVE'),
('POL10007',7,2,'Life',3000.00,500000.00,'2024-07-01','2034-06-30','ACTIVE'),
('POL10008',8,3,'Health',1400.00,100000.00,'2024-08-01','2025-07-31','ACTIVE'),
('POL10009',9,4,'Home',2200.00,220000.00,'2024-09-01','2025-08-31','ACTIVE'),
('POL10010',10,5,'Auto',1600.00,85000.00,'2024-10-01','2025-09-30','ACTIVE');

-- =========================================================
-- INSERT CLAIMS
-- =========================================================

INSERT INTO operational.claims
(
policy_id,
customer_id,
claim_date,
incident_date,
processed_date,
claim_amount,
approved_amount,
claim_status,
fraud_flag,
claim_description
)
VALUES
(1,1,'2024-03-10','2024-03-08','2024-03-15',5000,4700,'APPROVED',FALSE,'Medical treatment claim'),
(2,2,'2024-04-14','2024-04-12','2024-04-18',12000,11000,'APPROVED',FALSE,'Vehicle accident claim'),
(3,3,'2024-05-20','2024-05-18',NULL,50000,NULL,'UNDER_REVIEW',TRUE,'Large life insurance claim'),
(4,4,'2024-05-25','2024-05-22','2024-05-30',7000,6500,'APPROVED',FALSE,'House repair claim'),
(5,5,'2024-06-12','2024-06-10','2024-06-16',6000,5500,'APPROVED',FALSE,'Hospitalization claim'),
(6,6,'2024-06-20','2024-06-18','2024-06-25',9000,8500,'APPROVED',FALSE,'Car damage claim'),
(7,7,'2024-07-07','2024-07-05',NULL,100000,NULL,'UNDER_REVIEW',TRUE,'Suspicious high-value claim'),
(8,8,'2024-07-15','2024-07-12','2024-07-20',4000,4000,'APPROVED',FALSE,'Health reimbursement'),
(9,9,'2024-08-01','2024-07-30','2024-08-05',15000,14500,'APPROVED',FALSE,'Property damage claim'),
(10,10,'2024-08-15','2024-08-12','2024-08-20',8000,7500,'APPROVED',FALSE,'Vehicle repair claim');

-- =========================================================
-- VALIDATION
-- =========================================================

SELECT COUNT(*) AS customers_count
FROM operational.customers;

SELECT COUNT(*) AS agents_count
FROM operational.agents;

SELECT COUNT(*) AS policies_count
FROM operational.policies;

SELECT COUNT(*) AS claims_count
FROM operational.claims;




-- postgresql
SELECT COUNT(*) AS customers_count
FROM operational.customers;
--10

select * from  operational.customers;

SELECT COUNT(*) AS agents_count
FROM operational.agents;
--10

SELECT COUNT(*) AS policies_count
FROM operational.policies;

SELECT COUNT(*) AS claims_count
FROM operational.claims;

SELECT
    current_database(),
    current_schema(),
    inet_server_addr(),
    inet_server_port();


SELECT schemaname, tablename
FROM pg_tables
WHERE tablename IN ('customers', 'agents', 'policies', 'claims');
