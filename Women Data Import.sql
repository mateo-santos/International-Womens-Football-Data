CREATE TABLE results (
date text,
home_team text, 
away_team text, 
home_score text, 
away_score text,
tournament text, 
city text, 
country text, 
neutral text)
;

CREATE TABLE goalscorers (
date text, 
home_team text, 
away_team text,
team text,
scorer text, 
minute text,
own_goal text,
penalty text)
;

CREATE TABLE shootouts (
date text,
home_team text,
away_team text,
winner text)
;

LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/women results.csv' 
INTO TABLE results
FIELDS TERMINATED BY ','
IGNORE 1 LINES
;


LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/women goalscorers.csv' 
INTO TABLE goalscorers
FIELDS TERMINATED BY ','
IGNORE 1 LINES
;

LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/women shootouts.csv' 
INTO TABLE shootouts
FIELDS TERMINATED BY ','
IGNORE 1 LINES
;

ALTER TABLE results
MODIFY COLUMN date date,
MODIFY COLUMN home_score int, 
MODIFY COLUMN away_score int
;

ALTER TABLE goalscorers
MODIFY COLUMN date date,
MODIFY COLUMN minute int
;

SELECT *
FROM results;
SELECT *
FROM goalscorers;
