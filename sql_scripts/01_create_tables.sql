-- ====================================================================
-- PHASE 1: DATABASE SCHEMA AND INGESTION LAYER
-- ====================================================================

-- 1. Create the Knicks Performance & Demand Table
CREATE TABLE knicks_games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_date DATE NOT NULL,
    opponent VARCHAR(50),
    venue VARCHAR(10) DEFAULT 'Home', 
    game_result CHAR(1), 
    knicks_score INT,
    opponent_score INT,
    game_start_time VARCHAR(20), 
    attendance INT
);

-- 2. Create the MTA Transit Metrics Table (Protected against truncation crashes)
CREATE TABLE mta_transit_metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    month_period VARCHAR(10),            -- Holds year-month format strings (e.g., '2026-03')
    subway_line VARCHAR(20),             -- Expanded to handle multi-line arrays like '1,2,3' or 'A,C,E'
    service_period VARCHAR(30),          -- Holds peak, off-peak, or weekend strings
    estimated_ridership INT,
    avg_additional_platform_time FLOAT, -- The "APT" proxy for commuter platform friction
    avg_additional_train_time FLOAT
);

-- 3. Data Mapping Ingestion Blueprint for Knicks Data
LOAD DATA INFILE 'C:/Desktop/data_raw/knicks_schedule.csv'
INTO TABLE knicks_games
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(game_date, opponent, venue, game_result, knicks_score, opponent_score, game_start_time, attendance);

-- 4. Data Mapping Ingestion Blueprint for MTA Data
LOAD DATA INFILE 'C:/Desktop/data_raw/mta_travel_metrics.csv'
INTO TABLE mta_transit_metrics
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(month_period, subway_line, service_period, estimated_ridership, avg_additional_platform_time, avg_additional_train_time);
