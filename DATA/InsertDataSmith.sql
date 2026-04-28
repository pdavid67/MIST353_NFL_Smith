USE MIST353_NFL_Smith;
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

SELECT * FROM ConfrenceDivision ORDER BY ConfrenceDivisionID;
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






insert into AppUser (Firstname, Lastname, Email, Phone, PasswordHash, UserRole)
VALUES
('Tom', 'Brady', 'tom.brady@example.com', '555-1234', 0x01, N'NFLFan'),
('Aaron', 'Rodgers', 'aaron.rodgers@example.com', '555-9012', 0x01, N'NFLFan'),
('Drew', 'Brees', 'drew.brees@example.com', '555-2222', 0x01, N'NFLFan'),
('Patrick', 'Mahomes', 'patrick.mahomes@example.com', '555-7890', 0x01, N'NFLFan'),

('Bill', 'Belichick', 'bill.belichick@example.com', '555-5678', 0x01, N'NFLAdmin'),
('Sean', 'McVay', 'sean.mcay@example.com', '555-3456', 0x01, N'NFLAdmin'),
('Mike', 'Tomlin', 'mike.tomlin@example.com', '555-1111', 0x01, N'NFLAdmin'),
('Andy', 'Reid', 'andy.reid@example.com', '555-3333', 0x01, N'NFLAdmin');

GO

insert into NFLFan (NFLFanID)
VALUES
(1),
(2),
(3),
(4);

GO

insert into NFLAdmin (NFLAdminID)
VALUES
(5),
(6),
(7),
(8);

GO

--select * from Team;
INSERT INTO FanTeam (NFLFanID, TeamID, PrimaryTeam)
VALUES
(1, 8, 1),  -- Pittsburgh Steelers primary
(1, 5, 0),  -- Baltimore Ravens
(2, 3, 1),  -- San Francisco 49ers primary
(2, 4, 0),  -- Seattle Seahawks
(3, 1, 1),  -- Arizona Cardinals primary
(3, 2, 0),  -- Los Angeles Rams
(4, 6, 1),  -- Cincinnati Bengals primary
(4, 7, 0);  -- Cleveland Browns


DELETE FROM FanTeam;
DBCC CHECKIDENT ('FanTeam', RESEED, 0);
GO




INSERT INTO FanTeam (NFLFanID, TeamID, PrimaryTeam)
VALUES
(1, 8, 1),  -- Fan 1, primary team = Pittsburgh Steelers
(1, 5, 0),  -- Fan 1 also likes Baltimore Ravens

(2, 3, 1),  -- Fan 2, primary team = San Francisco 49ers
(2, 4, 0),  -- Fan 2 also likes Seattle Seahawks

(3, 1, 1),  -- Fan 3, primary team = Arizona Cardinals
(3, 2, 0),  -- Fan 3 also likes Los Angeles Rams

(4, 6, 1),  -- Fan 4, primary team = Cincinnati Bengals
(4, 7, 0);  -- Fan 4 also likes Cleveland Browns
GO


USE MIST353_NFL_Smith;
GO

/* =========================================
   1) DELETE EXISTING DATA IN SAFE ORDER
   ========================================= */

DELETE FROM FanTeam;
DBCC CHECKIDENT ('FanTeam', RESEED, 0);
GO

DELETE FROM Game;
DBCC CHECKIDENT ('Game', RESEED, 0);
GO

DELETE FROM NFLAdmin;
GO

DELETE FROM NFLFan;
GO

DELETE FROM AppUser;
DBCC CHECKIDENT ('AppUser', RESEED, 0);
GO

DELETE FROM Team;
DBCC CHECKIDENT ('Team', RESEED, 0);
GO

DELETE FROM Stadium;
DBCC CHECKIDENT ('Stadium', RESEED, 0);
GO

DELETE FROM ConfrenceDivision;
DBCC CHECKIDENT ('ConfrenceDivision', RESEED, 0);
GO


/* =========================================
   2) REINSERT CONFERENCE / DIVISION
   ========================================= */

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


/* =========================================
   3) REINSERT ALL 32 NFL TEAMS
   ========================================= */

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


/* =========================================
   4) REINSERT STADIUMS
   ========================================= */

INSERT INTO Stadium (StadiumName, StadiumCityState)
VALUES
('Highmark Stadium', 'Orchard Park, NY'),
('Hard Rock Stadium', 'Miami Gardens, FL'),
('Gillette Stadium', 'Foxborough, MA'),
('MetLife Stadium', 'East Rutherford, NJ');
GO


/* =========================================
   5) REINSERT APP USERS
   Do NOT include AppUserID
   ========================================= */

INSERT INTO AppUser (FirstName, LastName, Email, Phone, PasswordHash, UserRole)
VALUES
('Tom', 'Brady', 'tom.brady@example.com', '555-1234', 0x01, 'NFLFan'),
('Aaron', 'Rodgers', 'aaron.rodgers@example.com', '555-2345', 0x02, 'NFLFan'),
('Drew', 'Brees', 'drew.brees@example.com', '555-3456', 0x03, 'NFLFan'),
('Patrick', 'Mahomes', 'patrick.mahomes@example.com', '555-4567', 0x04, 'NFLFan');
GO


/* =========================================
   6) REINSERT NFLFAN
   NFLFan has only NFLFanID
   so use the matching AppUser IDs
   ========================================= */

INSERT INTO NFLFan (NFLFanID)
VALUES
(1),
(2),
(3),
(4);
GO


/* =========================================
   7) REINSERT NFLADMIN
   AppUser IDs 5-8 are admins
   ========================================= */

INSERT INTO AppUser (FirstName, LastName, Email, Phone, PasswordHash, UserRole)
VALUES
('Roger', 'Goodell', 'roger.goodell@example.com', '555-5678', 0x05, 'NFLAdmin'),
('Admin', 'One', 'admin1@example.com', '555-6789', 0x06, 'NFLAdmin'),
('Admin', 'Two', 'admin2@example.com', '555-7890', 0x07, 'NFLAdmin'),
('Admin', 'Three', 'admin3@example.com', '555-8901', 0x08, 'NFLAdmin');
GO

INSERT INTO NFLAdmin (NFLAdminID)
VALUES
(5),
(6),
(7),
(8);
GO


/* =========================================
   8) REINSERT FANTEAM
   NFLFanID must exist in NFLFan
   ========================================= */

INSERT INTO FanTeam (NFLFanID, TeamID, PrimaryTeam)
VALUES
(1, 3, 1),   -- Tom Brady primary: Patriots
(1, 16, 0),  -- also likes Chargers

(2, 24, 1),  -- Aaron Rodgers primary: Packers
(2, 4, 0),   -- also likes Jets

(3, 27, 1),  -- Drew Brees primary: Saints
(3, 16, 0),  -- also likes Chargers

(4, 14, 1),  -- Patrick Mahomes primary: Chiefs
(4, 30, 0);  -- also likes Rams
GO


/* =========================================
   9) CHECK RESULTS
   ========================================= */

SELECT * FROM ConfrenceDivision ORDER BY ConfrenceDivisionID;
GO

SELECT
    t.TeamID,
    t.TeamName,
    cd.Confrence,
    cd.Division
FROM Team t
INNER JOIN ConfrenceDivision cd
    ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
ORDER BY cd.Confrence, cd.Division, t.TeamName;
GO

SELECT * FROM AppUser ORDER BY AppUserID;
GO

SELECT * FROM NFLFan ORDER BY NFLFanID;
GO

SELECT * FROM FanTeam ORDER BY FanTeamID;
GO
