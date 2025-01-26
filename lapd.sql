USE sys;
 
DROP DATABASE IF EXISTS lapd;
CREATE DATABASE IF NOT EXISTS lapd
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';
 
USE lapd;


-- -------------------------------------------------------------------
DROP TABLE IF EXISTS area;
CREATE TABLE IF NOT EXISTS area (
    area_code     SMALLINT    UNSIGNED AUTO_INCREMENT NOT NULL
  , area_name     VARCHAR(50)                         NOT NULL
  , active        BIT                                 NOT NULL  DEFAULT 1
  , CONSTRAINT area_PK PRIMARY KEY(area_code)
  , CONSTRAINT area_UK
        UNIQUE (area_name)
);
TRUNCATE TABLE area;


LOAD DATA LOCAL INFILE 'crime_area_table.csv'
INTO TABLE area
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(area_name);




-- -------------------------------------------------------------------
DROP TABLE IF EXISTS gender;
CREATE TABLE IF NOT EXISTS gender (
    s_id          SMALLINT    UNSIGNED AUTO_INCREMENT NOT NULL
  , sex           VARCHAR(15)                          NOT NULL
  , active        BIT                                 NOT NULL  DEFAULT 1
  , CONSTRAINT gender_PK PRIMARY KEY(s_id)
  , CONSTRAINT gender_UK
        UNIQUE (sex)
);
TRUNCATE TABLE gender;


LOAD DATA LOCAL INFILE 'crime_sex_table.csv'
INTO TABLE gender
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sex);




-- -------------------------------------------------------------------
DROP TABLE IF EXISTS crime_code_desc;
CREATE TABLE IF NOT EXISTS crime_code_desc (
    crime_code       MEDIUMINT   NOT NULL
  , crime_code_desc  VARCHAR(50) NOT NULl
  , active           BIT         NOT NULL  DEFAULT 1
  , CONSTRAINT crime_code_desc_PK PRIMARY KEY(crime_code)
  , CONSTRAINT crime_code_desc_UK 
        UNIQUE (crime_code_desc)
);
TRUNCATE TABLE crime_code_desc;

LOAD DATA LOCAL INFILE 'crime_code_desc_table.csv'
INTO TABLE crime_code_desc
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(crime_code, crime_code_desc)
;


-- -------------------------------------------------------------------
DROP TABLE IF EXISTS premisis;
CREATE TABLE IF NOT EXISTS premisis (
    premise_code  MEDIUMINT    NOT NULL
  , premise_desc  VARCHAR(100) NULL
  , active        BIT         NOT NULL  DEFAULT 1
  , CONSTRAINT premisis_PK PRIMARY KEY(premise_code)
);
TRUNCATE TABLE premisis;

LOAD DATA LOCAL INFILE 'crime_premise_table.csv'
INTO TABLE premisis
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(premise_code, premise_desc)
;


-- -------------------------------------------------------------------
DROP TABLE IF EXISTS weapon;
CREATE TABLE IF NOT EXISTS weapon (
    weapon_code   MEDIUMINT   NOT NULL
  , weapon_desc   VARCHAR(75) NOT NULL
  , active        BIT         NOT NULL  DEFAULT 1
  , CONSTRAINT weapon_PK PRIMARY KEY(weapon_code)
  , CONSTRAINT weapon_UK 
        UNIQUE (weapon_desc)
);
TRUNCATE TABLE weapon;

LOAD DATA LOCAL INFILE 'crime_weapon_table.csv'
INTO TABLE weapon
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(weapon_code, weapon_desc)
;


-- -------------------------------------------------------------------
DROP TABLE IF EXISTS case_status;
CREATE TABLE IF NOT EXISTS case_status (
    cs_id          SMALLINT UNSIGNED AUTO_INCREMENT  NOT NULL
  , status         VARCHAR(2)                        NOT NULL
  , status_desc    VARCHAR(30)                       NOT NULL
  , active         BIT                               NOT NULL  DEFAULT 1
  , CONSTRAINT case_status_PK PRIMARY KEY(cs_id)
  , CONSTRAINT area_UK 
        UNIQUE (status, status_desc)
);
TRUNCATE TABLE case_status;

LOAD DATA LOCAL INFILE 'crime_casestatus_table.csv'
INTO TABLE case_status
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(status, status_desc)
;

-- -------------------------------------------------------------------
DROP TABLE IF EXISTS descent;
CREATE TABLE IF NOT EXISTS descent (
    dc_id          SMALLINT     UNSIGNED AUTO_INCREMENT
  , descent        VARCHAR(2)   NOT NULL
  , active         BIT          NOT NULL  DEFAULT 1
  , CONSTRAINT descent_PK PRIMARY KEY(dc_id)
  , CONSTRAINT descent_UK 
        UNIQUE (descent)
);
TRUNCATE TABLE descent;

LOAD DATA LOCAL INFILE 'crime_descent_table.csv'
INTO TABLE descent
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(descent)
;



-- -------------------------------------------------------------------
DROP TABLE IF EXISTS crime_commited;
CREATE TABLE IF NOT EXISTS crime_commited (
    cc_id          BIGINT            UNSIGNED AUTO_INCREMENT NOT NULL
  , dr_no          VARCHAR(12)       NOT NULL
  , crime_code     MEDIUMINT         NOT NULL
  , CONSTRAINT crime_commited PRIMARY KEY(cc_id)
)
;
TRUNCATE TABLE crime_commited;


LOAD DATA LOCAL INFILE 'crime_commited.csv'
INTO TABLE crime_commited
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(dr_no, crime_code)
;





-- -------------------------------------------------------------------

DROP TABLE IF EXISTS crime;
CREATE TABLE IF NOT EXISTS crime (
      dr_no              VARCHAR(12) NOT NULL
    , date_report        DATE        NOT NULL
    , date_occurence     DATE        NULL
    , time_occurence     TIME        NULL
    , area_code          SMALLINT    NOT NULL
    , report_dist_no     MEDIUMINT   NOT NULL
    , part_area          SMALLINT    NULL
    , age_victim         MEDIUMINT   NULL
    , sex_id             SMALLINT    NULL
    , dc_id              SMALLINT    NULL
    , premise_code       MEDIUMINT   NOT NULL
    , weapon_code        MEDIUMINT   NULL
    , case_status_id     SMALLINT    NOT NULL
    , location           VARCHAR(50) NOT NULL
    , CONSTRAINT crime PRIMARY KEY(dr_no)
);
TRUNCATE TABLE crime;

LOAD DATA LOCAL INFILE 'crime_table.csv'
INTO TABLE crime
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(dr_no, date_report, date_occurence, time_occurence, area_code
, report_dist_no, part_area, age_victim, sex_id
, dc_id, premise_code, weapon_code, case_status_id
, location)
;


-- -------------------------------------------------------------------

SELECT c.date_report, c.date_occurence, c.time_occurence
     , c.report_dist_no, c.part_area, c.age_victim, c.location
     , c.dr_no, c.area_code, c.sex_id, c.dc_id
     , c.premise_code, c.weapon_code, c.case_status_id
     , ca.area_code, ca.area_name
     , cp.premise_code, cp.premise_desc
     , cw.weapon_code, cw.weapon_desc
     , cs.cs_id, cs.status, cs.status_desc
     , cd.dc_id, cd.descent
     , cc.dr_no, cc.cc_id, cc.crime_code
     , ccd.crime_code, ccd.crime_code_desc
FROM crime c
    JOIN area ca              ON c.area_code=ca.area_code
    JOIN premisis cp          ON c.premise_code=cp.premise_code
    JOIN weapon cw            ON c.weapon_code=cw.weapon_code
    JOIN case_status cs       ON c.case_status_id=cs.cs_id
    JOIN descent cd           ON c.dc_id=cd.dc_id
    JOIN crime_commited cc    ON c.dr_no=cc.dr_no
    JOIN crime_code_desc ccd  ON cc.crime_code=ccd.crime_code
;

-- query to get top 5 areas of crime
SELECT 
    ca.area_name,
    COUNT(c.dr_no) as crime_count
FROM crime c
JOIN area ca ON c.area_code=ca.area_code
GROUP BY ca.area_name
ORDER BY crime_count DESC
LIMIT 5
;

SELECT 
     YEAR(c.date_occurence) AS crime_year,
     COUNT(c.dr_no) AS Total_crime_cases
FROM crime c
GROUP BY crime_year
ORDER BY crime_year
;



-- query to get the most commited crime in each month of each year
WITH RankedCrimes AS (
    SELECT 
        MONTH(c.date_occurence) AS crime_month,
        YEAR(c.date_occurence) AS crime_year,
        ccd.crime_code_desc,
        COUNT(c.dr_no) AS total_crime,
        ROW_NUMBER() OVER (PARTITION BY YEAR(c.date_occurence), MONTH(c.date_occurence) 
                           ORDER BY COUNT(c.dr_no) DESC) AS rank
    FROM crime c
        JOIN crime_commited cc    ON c.dr_no = cc.dr_no
        JOIN crime_code_desc ccd  ON cc.crime_code = ccd.crime_code
    GROUP BY crime_year, crime_month, ccd.crime_code_desc
)
SELECT 
    crime_year,
    crime_month,
    crime_code_desc,
    total_crime
FROM RankedCrimes
WHERE rank = 1
ORDER BY crime_year, crime_month
;


-- query to get the time of day which is peak time of occurence of crime
SELECT 
    HOUR(c.time_occurence) AS crime_hour,
    COUNT(c.dr_no) AS total_crime
FROM crime c
GROUP BY crime_hour
ORDER BY total_crime DESC
LIMIT 1
;


-- Monthly Crime Trends

SELECT 
    MONTH(c.date_occurence) AS crime_month, 
    COUNT(c.dr_no) AS Total_Crimes
FROM crime c
GROUP BY crime_month
ORDER BY crime_month ASC
;


SELECT *
FROM crime
LIMIT 15;










































