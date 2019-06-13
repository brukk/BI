/*
--The initial date must correspond to the minimum date value in your transaction tables 
--@StartDate uDate = '20040101'-- Initialize your Start Date (uDate is a user Defined Data type of Date)
--@NoOfYrs INT = 2;---Used to limit the number of Year to be generated 
*/
CREATE PROCEDURE usp_DimDatePopulator AS
BEGIN

DECLARE 
  @StartDate Date = '20040101' 
, @NoOfYrs INT = 4;   --determines for how many years should the code generate the date values


SET DATEFIRST 7;      -- on which day the week starts (7 is sunday)
SET DATEFORMAT mdy;   -- Date format (mdy = month-day-year  *weird)
SET LANGUAGE US_ENGLISH;

DECLARE @CutoffDate DATE = DATEADD(YEAR, @NoOfYrs, @StartDate);-- This will give us the last date value 
-- select @CutoffDate

DROP TABLE IF EXISTS dimDate

CREATE TABLE DimDate (
  dimDateKey   AS CONVERT(CHAR(8),   [date], 112) ,
  [Date]       DATE  ,
  [Day]        AS DATEPART(DAY,      [date]),
  [Month]      AS DATEPART(MONTH,    [date]),
  FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),
  [MonthName]  AS DATENAME(MONTH,    [date]),
  [Week]       AS DATEPART(WEEK,     [date]),
  [ISOweek]    AS DATEPART(ISO_WEEK, [date]),--Leap week
  [DayName]    AS FORMAT([date], 'dddd'),
  [DayOfWeek]  AS DATEPART(WEEKDAY,  [date]),
  [Quarter]    AS DATEPART(QUARTER,  [date]),
  [Year]       AS DATEPART(YEAR,     [date]),
  FirstOfYear  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [date]), 0))
);
/*
An ISO week-numbering year (also called ISO year informally) has 52 or 53 full weeks. 
That is 364 or 371 days instead of the usual 365 or 366 days. 
*/

;WITH CTE_Date_Row
AS(
    SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate))  rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    ORDER BY s1.[object_id]
 ) ,CTE_Date
 AS
 (
 SELECT d = DATEADD(DAY, rn - 1, @StartDate)
 FROM  CTE_Date_Row
 )

 INSERT dimDate([date]) 
 SELECT * FROM CTE_Date

END





