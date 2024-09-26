--RAILWAY MANAGMENT SYSTEM

-- You can access the whole data using this statment
SELECT * FROM Train_details;

SELECT * from Train_details
WHERE [Destination Station Name] IS NULL;

SELECT COUNT(*) from Train_details;

-- Total records of trains availabe in this dataset is 11112 trains
SELECT DISTINCT [Train Number] FROM Train_details;


-- Top 10 long distance travels
-- average travel time
--
SELECT * FROM Train_details 
WHERE [Train Number] = 107;

SELECT [Train Number],[Station Name],[Source Station Name],Distance FROM Train_details
ORDER BY Distance DESC;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Train_details';


ALTER TABLE Train_details
ALTER COLUMN [Train Number] INT;

SELECT DISTINCT [Train Number], [Station Code], [Station Name]
FROM Train_details;

-- the data for storing data for each train
CREATE TABLE Trains (
    TrainNumber INT PRIMARY KEY,
    SourceStationCode VARCHAR(10),
    DestinationStationCode VARCHAR(10),
    Distance INT
);

--The table stores unique records
CREATE TABLE Stations (
    StationCode VARCHAR(10) PRIMARY KEY,
    StationName VARCHAR(100)
);
--train shedule timings 
CREATE TABLE TrainSchedules (
    TrainNumber INT,
    StationCode VARCHAR(10),
    ArrivalTime TIME,
    DepartureTime TIME,
    PRIMARY KEY (TrainNumber, StationCode),
    FOREIGN KEY (TrainNumber) REFERENCES Trains(TrainNumber),
    FOREIGN KEY (StationCode) REFERENCES Stations(StationCode)
);

INSERT INTO Stations (StationCode, StationName)
SELECT DISTINCT [Station Code], [Station Name]
FROM Train_details;

INSERT INTO Trains (TrainNumber, SourceStationCode, DestinationStationCode)
SELECT DISTINCT [Train Number], [Source Station], [Destination Station]
FROM Train_details;

INSERT INTO TrainSchedules (TrainNumber, StationCode, ArrivalTime, DepartureTime)
SELECT [Train Number], [Station Code], [Arrival Time], [Departure Time]
FROM Train_details;

SELECT [Train Number], [Station Code], COUNT(*)
FROM Train_details
GROUP BY [Train Number], [Station Code]
HAVING COUNT(*) > 1;

-- Using CTE to identify and remove duplicates
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [Train Number], [Station Code] ORDER BY (SELECT NULL)) AS rn
    FROM Train_details
)
DELETE FROM CTE
WHERE rn > 1;

INSERT INTO TrainSchedules (TrainNumber, StationCode, ArrivalTime, DepartureTime)
SELECT [Train Number], [Station Code], [Arrival Time], [Departure Time]
FROM Train_details;

-- Check for any remaining primary key violations
SELECT TrainNumber, StationCode, COUNT(*)
FROM TrainSchedules
GROUP BY TrainNumber, StationCode
HAVING COUNT(*) > 1;

-- Check for trains that do not exist in the Trains table
SELECT DISTINCT TrainNumber
FROM TrainSchedules
WHERE TrainNumber NOT IN (SELECT TrainNumber FROM Trains);

-- Check for stations that do not exist in the Stations table
SELECT DISTINCT StationCode
FROM TrainSchedules
WHERE StationCode NOT IN (SELECT StationCode FROM Stations);

SELECT * FROM Trains;
SELECT * FROM TrainSchedules;
SELECT * FROM Stations;

ALTER TABLE TrainSchedules
ADD Distance INT;

INSERT INTO TrainSchedules (TrainNumber, StationCode, ArrivalTime, DepartureTime, Distance)
SELECT DISTINCT 
    [Train Number], 
    [Station Code], 
    [Arrival Time], 
    [Departure Time], 
    [Distance]
FROM Train_details;

ALTER TABLE TrainSchedules
DROP CONSTRAINT [PK__TrainSch__9DFA484F302C013C];  -- Adjust the constraint name as necessary

ALTER TABLE TrainSchedules
ADD CONSTRAINT UQ_TrainStation UNIQUE (TrainNumber, StationCode);

-- Assuming TrainSchedules already contains TrainNumber and StationCode
UPDATE TrainSchedules
SET Distance = td.[Distance]
FROM Train_details td
WHERE TrainSchedules.TrainNumber = td.[Train Number]
  AND TrainSchedules.StationCode = td.[Station Code];

SELECT TrainNumber, StationCode, Distance
FROM TrainSchedules
WHERE TrainNumber = 107;

-- Create a temporary table to hold the max distance values
SELECT TrainNumber, MAX(Distance) AS MaxDistance
INTO #MaxDistances
FROM TrainSchedules
GROUP BY TrainNumber;

-- Update the Trains table with the maximum distance values
UPDATE Trains
SET Distance = md.MaxDistance
FROM Trains t
JOIN #MaxDistances md ON t.TrainNumber = md.TrainNumber;

-- Drop the temporary table
DROP TABLE #MaxDistances;

-- Rename the column Distance to max_distance_travelled
EXEC sp_rename 'Trains.Distance', 'max_distance_travelled', 'COLUMN';

-- Retrieve the top 10 trains with the highest distance traveled
SELECT TOP 10 TrainNumber, max_distance_travelled
FROM Trains
ORDER BY max_distance_travelled DESC;


-- Select the top 5 trains with the highest distance traveled along with their station names
SELECT t.TrainNumber, 
       t.max_distance_travelled,
	   s.StationName AS fromStationName,
	   t.SourceStationName
FROM Trains t
JOIN TrainSchedules ts ON t.TrainNumber = ts.TrainNumber
JOIN Stations s ON ts.StationCode = s.StationCode
ORDER BY t.max_distance_travelled DESC;

SELECT DISTINCT t.TrainNumber, 
       t.max_distance_travelled,
       s.StationName AS fromStationName,
       t.DestinationStationCode
FROM Trains t
JOIN TrainSchedules ts ON t.TrainNumber = ts.TrainNumber
JOIN Stations s ON ts.StationCode = s.StationCode
ORDER BY t.max_distance_travelled DESC;

--Details of each train number which is moving from and to station and max-distance travelled.
SELECT t.TrainNumber, 
       MAX(t.max_distance_travelled) AS max_distance_travelled,
       MIN(s.StationName) AS fromStationName,  -- Example: Get the first station name alphabetically or another aggregate function
       t.SourceStationName AS [to station name]
FROM Trains t
JOIN TrainSchedules ts ON t.TrainNumber = ts.TrainNumber
JOIN Stations s ON ts.StationCode = s.StationCode
GROUP BY t.TrainNumber, t.SourceStationName
ORDER BY max_distance_travelled DESC;

--here are the top 10 trains which travel the highest distance.
SELECT TOP 10 
       t.TrainNumber, 
       MAX(t.max_distance_travelled) AS max_distance_travelled,
       MIN(s.StationName) AS fromStationName,
       t.SourceStationName AS [to station name]
FROM Trains t
JOIN TrainSchedules ts ON t.TrainNumber = ts.TrainNumber
JOIN Stations s ON ts.StationCode = s.StationCode
GROUP BY t.TrainNumber, t.SourceStationName
ORDER BY max_distance_travelled DESC;

--in which time trains arrive at the station more
SELECT DATEPART(HOUR, ArrivalTime) AS ArrivalHour, 
       COUNT(*) AS NumberOfTrains
FROM TrainSchedules
GROUP BY DATEPART(HOUR, ArrivalTime)
ORDER BY ArrivalHour;

--most used stations and most unused stations
SELECT StationCode, 
       COUNT(*) AS TrainCount
FROM TrainSchedules
GROUP BY StationCode
ORDER BY TrainCount DESC;

--average stop time in munites
SELECT TrainNumber, 
       StationCode, 
       AVG(CASE 
             WHEN DATEDIFF(MINUTE, ArrivalTime, DepartureTime) >= 0 
             THEN DATEDIFF(MINUTE, ArrivalTime, DepartureTime) 
             ELSE NULL 
           END) AS AvgStopTime
FROM TrainSchedules
GROUP BY TrainNumber, StationCode
ORDER BY AvgStopTime DESC;

--status of train delay or on-time
SELECT TrainNumber, 
       CASE 
         WHEN DATEDIFF(MINUTE, [ArrivalTime], [DepartureTime]) <= 5 THEN 'On Time'
         ELSE 'Delayed'
       END AS Performance
FROM TrainSchedules;

ALTER TABLE Trains
ADD SourceStationName VARCHAR(50);

UPDATE Trains
SET SourceStationName = td.[Source Station Name]
FROM Train_details td
WHERE Trains.TrainNumber = td.[Train Number];

