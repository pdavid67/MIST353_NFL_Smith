-- Seed data for NFL app.
-- Run after CreateTablesSmith.sql.

USE MIST353_NFL_Smith;
GO

DELETE FROM Game;
DBCC CHECKIDENT ('Game', RESEED, 0);
GO

DELETE FROM FanTeam;
DBCC CHECKIDENT ('FanTeam', RESEED, 0);
GO

DELETE FROM NFLAdmin;
GO

DELETE FROM NFLFan;
GO

DELETE FROM AppUser;
DBCC CHECKIDENT ('AppUser', RESEED, 0);
GO

DELETE FROM Stadium;
DBCC CHECKIDENT ('Stadium', RESEED, 0);
GO

DELETE FROM Team;
DBCC CHECKIDENT ('Team', RESEED, 0);
GO

DELETE FROM ConfrenceDivision;
DBCC CHECKIDENT ('ConfrenceDivision', RESEED, 0);
GO

INSERT INTO ConfrenceDivision (Confrence, Division)
VALUES
('AFC', 'East'),
('AFC', 'North'),
('AFC', 'South'),
('AFC', 'West'),
('NFC', 'East'),
('NFC', 'North'),
('NFC', 'South'),
('NFC', 'West');
GO

INSERT INTO Team (TeamName, TeamCityState, TeamColors, ConfrenceDivisionID)
VALUES
('Buffalo Bills', 'Buffalo, NY', 'Royal Blue, Red, White', 1),
('Miami Dolphins', 'Miami, FL', 'Aqua, Orange, White', 1),
('New England Patriots', 'Foxborough, MA', 'Navy, Red, Silver', 1),
('New York Jets', 'East Rutherford, NJ', 'Green, White', 1),
('Baltimore Ravens', 'Baltimore, MD', 'Purple, Black, Gold', 2),
('Cincinnati Bengals', 'Cincinnati, OH', 'Black, Orange, White', 2),
('Cleveland Browns', 'Cleveland, OH', 'Brown, Orange, White', 2),
('Pittsburgh Steelers', 'Pittsburgh, PA', 'Black, Gold, White', 2),
('Houston Texans', 'Houston, TX', 'Deep Steel Blue, Battle Red, White', 3),
('Indianapolis Colts', 'Indianapolis, IN', 'Royal Blue, White', 3),
('Jacksonville Jaguars', 'Jacksonville, FL', 'Teal, Black, Gold', 3),
('Tennessee Titans', 'Nashville, TN', 'Navy, Titan Blue, Red, Silver', 3),
('Denver Broncos', 'Denver, CO', 'Orange, Navy, White', 4),
('Kansas City Chiefs', 'Kansas City, MO', 'Red, Gold, White', 4),
('Las Vegas Raiders', 'Las Vegas, NV', 'Silver, Black', 4),
('Los Angeles Chargers', 'Los Angeles, CA', 'Powder Blue, Gold, White', 4),
('Dallas Cowboys', 'Arlington, TX', 'Navy, Silver, White', 5),
('New York Giants', 'East Rutherford, NJ', 'Blue, Red, White', 5),
('Philadelphia Eagles', 'Philadelphia, PA', 'Midnight Green, Silver, Black', 5),
('Washington Commanders', 'Landover, MD', 'Burgundy, Gold, White', 5),
('Chicago Bears', 'Chicago, IL', 'Navy, Orange, White', 6),
('Detroit Lions', 'Detroit, MI', 'Honolulu Blue, Silver, White', 6),
('Green Bay Packers', 'Green Bay, WI', 'Green, Gold, White', 6),
('Minnesota Vikings', 'Minneapolis, MN', 'Purple, Gold, White', 6),
('Atlanta Falcons', 'Atlanta, GA', 'Black, Red, Silver', 7),
('Carolina Panthers', 'Charlotte, NC', 'Black, Process Blue, Silver', 7),
('New Orleans Saints', 'New Orleans, LA', 'Black, Old Gold, White', 7),
('Tampa Bay Buccaneers', 'Tampa, FL', 'Red, Pewter, Black', 7),
('Arizona Cardinals', 'Glendale, AZ', 'Red, Black, White', 8),
('Los Angeles Rams', 'Los Angeles, CA', 'Royal Blue, Sol, White', 8),
('San Francisco 49ers', 'Santa Clara, CA', 'Scarlet, Gold, White', 8),
('Seattle Seahawks', 'Seattle, WA', 'College Navy, Action Green, Wolf Gray', 8);
GO

INSERT INTO Stadium (StadiumName, StadiumCityState)
VALUES
('Highmark Stadium', 'Orchard Park, NY'),
('Hard Rock Stadium', 'Miami Gardens, FL'),
('Gillette Stadium', 'Foxborough, MA'),
('MetLife Stadium', 'East Rutherford, NJ'),
('M&T Bank Stadium', 'Baltimore, MD'),
('Paycor Stadium', 'Cincinnati, OH'),
('Cleveland Browns Stadium', 'Cleveland, OH'),
('Acrisure Stadium', 'Pittsburgh, PA');
GO

INSERT INTO AppUser (FirstName, LastName, Email, Phone, PasswordHash, UserRole)
VALUES
('Tom', 'Brady', 'tom.brady@example.com', '555-1234', 0x01, 'NFLFan'),
('Aaron', 'Rodgers', 'aaron.rodgers@example.com', '555-2345', 0x02, 'NFLFan'),
('Drew', 'Brees', 'drew.brees@example.com', '555-3456', 0x03, 'NFLFan'),
('Patrick', 'Mahomes', 'patrick.mahomes@example.com', '555-4567', 0x04, 'NFLFan'),
('Roger', 'Goodell', 'roger.goodell@example.com', '555-5678', 0x05, 'NFLAdmin'),
('Admin', 'One', 'admin1@example.com', '555-6789', 0x06, 'NFLAdmin'),
('Admin', 'Two', 'admin2@example.com', '555-7890', 0x07, 'NFLAdmin'),
('Admin', 'Three', 'admin3@example.com', '555-8901', 0x08, 'NFLAdmin');
GO

INSERT INTO NFLFan (NFLFanID)
VALUES
(1),
(2),
(3),
(4);
GO

INSERT INTO NFLAdmin (NFLAdminID)
VALUES
(5),
(6),
(7),
(8);
GO

INSERT INTO FanTeam (NFLFanID, TeamID, PrimaryTeam)
VALUES
(1, 3, 1),
(1, 16, 0),
(2, 24, 1),
(2, 4, 0),
(3, 27, 1),
(3, 16, 0),
(4, 14, 1),
(4, 30, 0);
GO

SELECT * FROM ConfrenceDivision ORDER BY ConfrenceDivisionID;
SELECT * FROM Team ORDER BY TeamID;
SELECT * FROM Stadium ORDER BY StadiumID;
SELECT * FROM AppUser ORDER BY AppUserID;
SELECT * FROM NFLFan ORDER BY NFLFanID;
SELECT * FROM NFLAdmin ORDER BY NFLAdminID;
SELECT * FROM FanTeam ORDER BY FanTeamID;
GO
