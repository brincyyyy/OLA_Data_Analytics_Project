CREATE DATABASE Ola;
USE Ola;

CREATE TABLE bookings (
    Date VARCHAR(255),
    Time VARCHAR(255),
    Booking_ID VARCHAR(255),
    Booking_Status VARCHAR(255),
    Customer_ID VARCHAR(255),
    Vehicle_Type VARCHAR(50),
    Pickup_Location VARCHAR(255),
    Drop_Location VARCHAR(255),
    V_TAT VARCHAR(255),                      -- Vehicle Turnaround Time (assumed integer)
    C_TAT VARCHAR(255),                      -- Customer Turnaround Time (assumed integer)
    Canceled_Rides_by_Customer VARCHAR(255),
    Canceled_Rides_by_Driver VARCHAR(255),
    Incomplete_Rides VARCHAR(255),
    Incomplete_Rides_Reason VARCHAR(255),
    Booking_Value VARCHAR(255),
    Payment_Method VARCHAR(255),
    Ride_Distance VARCHAR(255),
    Driver_Ratings VARCHAR(255),
    Customer_Rating VARCHAR(255),
    Vehicle_Images VARCHAR(255)     -- Assuming you store image URLs or file paths
);


SET GLOBAL local_infile=1; 
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/Bookings.csv'
INTO TABLE bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW TABLES;

SELECT *
FROM Bookings
LIMIT 20;

# Retrieve all successful bookings
select  count(*)
from Bookings
where Booking_Status = 'success'; # 44271 Successful Bookings


# Find the average ride distance for each vehicle type
SELECT Vehicle_type, ROUND(AVG(CAST(Ride_Distance AS FLOAT)),2) AS 'Average Ride Distance'
FROM Bookings
WHERE Ride_Distance IS NOT NULL AND Ride_Distance != ""
GROUP BY Vehicle_type;

# Get the total number of canceled rides by customers
SELECT count(*)
FROM Bookings
WHERE Booking_Status = 'Canceled by Customer';

# List the Top 5 customers who booked the highest number of rides
SELECT 
	Customer_ID, 
	count(*) as Highest_Bookings
FROM 
	Bookings
GROUP BY 
	Customer_ID
ORDER BY 
	count(Customer_ID) DESC
LIMIT 5;


# Get the number of rides cancelled by drivers due to personal or car - related issues
SELECT count(*) as Rides_cancelled
FROM Bookings
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';

# Find the maximum and minimum driver ratings for Prime Sudan bookings
SET SQL_SAFE_UPDATES = 0; # Turn off safe mode to update column

UPDATE Bookings
SET Driver_Ratings = NULL
WHERE lower(Driver_Ratings) = 'null'; # Change all the string 'null' into NULL value

ALTER TABLE Bookings
MODIFY COLUMN Driver_Ratings FLOAT; # Alter the datatype of the table from VARCHAR to FLOAT

SELECT 
	'Prime Sedan' as Car_Type, MAX(Driver_Ratings) as Maximum_Rating , MIN(Driver_Ratings) as Minimum_Rating
FROM 
	Bookings
WHERE 
	Vehicle_Type = 'Prime Sedan';
 

 # Retrieve all rides where the payment was made using UPI
 SELECT count(*)
 FROM Bookings
 WHERE Payment_Method = 'UPI';
 
 # Find the average customer rating per vehicle type
 UPDATE Bookings
 SET Customer_Rating = NULL
 WHERE lower(Customer_Rating) = 'null';
 
 ALTER TABLE Bookings
 MODIFY COLUMN Customer_Rating FLOAT;
 
 SELECT Vehicle_type, ROUND(AVG(Customer_Rating), 2)
 FROM Bookings
 GROUP BY Vehicle_type;
 
 # Calculate the total booking value of rides completed successfully
ALTER TABLE Bookings
MODIFY COLUMN  Booking_Value INT;
 
 SELECT SUM(Booking_Value) as Successful_Rides
 FROM Bookings
 WHERE Booking_Status = 'Success';

 
 # List all incomplete rides along with the reason
 SELECT Booking_ID, Incomplete_Rides_Reason
 FROM Bookings
 WHERE Incomplete_Rides = 'Yes';

 
 
 
