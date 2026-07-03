-- =================================================================================
-- CRICKET PLAYERS SQL PRACTICE SCRIPT
-- =================================================================================
-- A fun, sports-themed schema for students to practice SQL commands.
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DDL: Create Tables
-- ---------------------------------------------------------------------------------

CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL, -- e.g., 'Batsman', 'Bowler', 'All-Rounder', 'Wicketkeeper'
    team_id INT,
    matches_played INT DEFAULT 0,
    runs_scored INT DEFAULT 0,
    wickets_taken INT DEFAULT 0,
    batting_average DECIMAL(5, 2),
    bowling_economy DECIMAL(4, 2),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE SET NULL
);

-- ---------------------------------------------------------------------------------
-- 2. DML: Insert Sample Data
-- ---------------------------------------------------------------------------------

INSERT INTO Teams (team_name, country) VALUES 
('Mumbai Indians', 'India'),
('Chennai Super Kings', 'India'),
('Royal Challengers Bangalore', 'India'),
('Kolkata Knight Riders', 'India');

INSERT INTO Players (first_name, last_name, role, team_id, matches_played, runs_scored, wickets_taken, batting_average, bowling_economy) VALUES
('Rohit', 'Sharma', 'Batsman', 1, 243, 6211, 15, 29.58, 8.02),
('Suryakumar', 'Yadav', 'Batsman', 1, 139, 3249, 0, 31.85, NULL),
('Jasprit', 'Bumrah', 'Bowler', 1, 120, 57, 145, 11.40, 7.39),
('MS', 'Dhoni', 'Wicketkeeper', 2, 250, 5082, 0, 38.79, NULL),
('Ravindra', 'Jadeja', 'All-Rounder', 2, 226, 2677, 152, 26.24, 7.60),
('Ruturaj', 'Gaikwad', 'Batsman', 2, 52, 1797, 0, 39.06, NULL),
('Virat', 'Kohli', 'Batsman', 3, 237, 7263, 4, 37.24, 8.80),
('Glenn', 'Maxwell', 'All-Rounder', 3, 124, 2719, 31, 26.40, 8.31),
('Mohammed', 'Siraj', 'Bowler', 3, 73, 97, 78, 11.20, 8.54),
('Andre', 'Russell', 'All-Rounder', 4, 112, 2262, 96, 29.37, 9.25),
('Sunil', 'Narine', 'All-Rounder', 4, 162, 1046, 163, 13.76, 6.73),
('Shreyas', 'Iyer', 'Batsman', 4, 101, 2776, 0, 31.54, NULL),
('Sachin', 'Tendulkar', 'Batsman', 1, 78, 2334, 0, 34.83, 7.75);

-- ---------------------------------------------------------------------------------
-- 3. Practice Queries
-- ---------------------------------------------------------------------------------

-- Q1. Retrieve all players and their roles.
SELECT first_name, last_name, role FROM Players;

-- Q2. Find all 'All-Rounder's in the database.
SELECT first_name, last_name, team_id 
FROM Players 
WHERE role = 'All-Rounder';

-- Q3. List the top 3 highest run-scorers.
SELECT first_name, last_name, runs_scored 
FROM Players 
ORDER BY runs_scored DESC 
LIMIT 3;

-- Q4. Find players who have taken more than 100 wickets.
SELECT first_name, last_name, wickets_taken 
FROM Players 
WHERE wickets_taken > 100;

-- Q5. Find players whose batting average is above 35.00.
SELECT first_name, last_name, batting_average 
FROM Players 
WHERE batting_average > 35.00;

-- Q6. Get the total number of runs scored by players in each role.
SELECT role, SUM(runs_scored) AS total_runs 
FROM Players 
GROUP BY role;

-- Q7. Find the names of players along with their team names (Using INNER JOIN).
SELECT p.first_name, p.last_name, t.team_name 
FROM Players p
JOIN Teams t ON p.team_id = t.team_id;

-- Q8. Find all players who play for 'Royal Challengers Bangalore' (Using Subquery).
SELECT first_name, last_name 
FROM Players 
WHERE team_id = (SELECT team_id FROM Teams WHERE team_name = 'Royal Challengers Bangalore');

-- Q9. Find the best bowling economy in the database (lowest number, ignoring NULLs).
SELECT MIN(bowling_economy) AS best_economy FROM Players;

-- Q10. Use a CASE statement to categorize players based on matches played:
--      > 200 matches as 'Veteran', 100-200 as 'Experienced', < 100 as 'Rising Star'
SELECT first_name, last_name, matches_played,
    CASE
        WHEN matches_played > 200 THEN 'Veteran'
        WHEN matches_played BETWEEN 100 AND 200 THEN 'Experienced'
        ELSE 'Rising Star'
    END AS player_status
FROM Players;
