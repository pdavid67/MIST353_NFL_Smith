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

INSERT INTO Team (TeamName, TeamCityState, TeamColor, ConferenceDivisionID)
VALUES 
('Bengals', 'Cincinnati, OH', 'Orange', 'AFC-North'),
('Browns', 'Cleveland, OH', 'Brown', 'AFC-North'),
('Steelers', 'Pittsburgh, PA', 'Yellow', 'AFC-North'),
('Jaguars', 'Jacksonville, FL', 'Blue', 'AFC-South'),
('Texans', 'Houston, TX', 'Red', 'AFC-South'),
('Colts', 'Indianapolis, IN', 'Blue and White', 'AFC-South'),
('Titans', 'Nashville, TN', 'Orange and White', 'AFC-South');