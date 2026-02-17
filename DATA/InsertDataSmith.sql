--Insert Data
--Insert all the ConferenceDivision data (8 rows)
--Insert team data for AFC North (4 rows)

INSERT INTO ConferenceDivision (Conference, DivisionID)
VALUES 
('AFC', 'North'),
('AFC', 'South'),
('AFC', 'East'),
('AFC', 'West'),
('NFC', 'North'),
('NFC', 'South'),
('NFC', 'East'),
('NFC', 'West');

GO
SELECT * FROM ConferenceDivision order by ConferenceDivisionID;

INSERT INTO Team (ConfrenceDivisionID, TeamName, TeamCityState, TeamColors)
VALUES
(1, 'Baltimore Ravens', 'Baltimore, MD', 'Purple, Black, Gold'),
(2, 'Cincinnati Bengals', 'Cincinnati, OH', 'Black, Orange, White'),
(3, 'Cleveland Browns', 'Cleveland, OH', 'Brown, Orange, White'),
(4, 'Pittsburgh Steelers', 'Pittsburgh, PA', 'Black, Gold'),

(5, 'Houston Texans', 'Houston, TX', 'Blue, Red, White'),
(6, 'Indianapolis Colts', 'Indianapolis, IN', 'Blue, White'),
(7, 'Jacksonville Jaguars', 'Jacksonville, FL', 'Teal, Black, Gold'),
(8, 'Tennessee Titans', 'Nashville, TN', 'Blue, Red, Silver'),

(9, 'Buffalo Bills', 'Buffalo, NY', 'Blue, Red, White'),
(10, 'Miami Dolphins', 'Miami, FL', 'Aqua, Orange, White'),
(11, 'New England Patriots', 'Foxborough, MA', 'Blue, Red, Silver'),
(12, 'New York Jets', 'East Rutherford, NJ', 'Green, White'),

(13, 'Chicago Bears', 'Chicago, IL', 'Blue, Orange'),
(14, 'Detroit Lions', 'Detroit, MI', 'Blue, Silver'),
(15, 'Green Bay Packers', 'Green Bay, WI', 'Green, Gold'),
(16, 'Minnesota Vikings', 'Minneapolis, MN', 'Purple, Gold'),

(17, 'Atlanta Falcons', 'Atlanta, GA', 'Red, Black, White'),
(18, 'Carolina Panthers', 'Charlotte, NC', 'Black, Blue, Silver'),
(19, 'New Orleans Saints', 'New Orleans, LA', 'Gold, Black'),
(20, 'Tampa Bay Buccaneers', 'Tampa, FL', 'Red, Silver, Black'),

(21, 'Arizona Cardinals', 'Phoenix, AZ', 'Red, White, Black'),
(22, 'Los Angeles Rams', 'Los Angeles, CA', 'Blue, Yellow'),
(23, 'San Francisco 49ers', 'San Francisco, CA', 'Red, Gold'),
(24, 'Seattle Seahawks', 'Seattle, WA', 'Blue, Green, Grey');

GO
SELECT * FROM Team order by TeamID;
