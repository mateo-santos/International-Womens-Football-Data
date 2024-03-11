-- 1. Which are the top 10 teams with more games played?

SELECT
    team,
    SUM(home_games) AS home_games,
    SUM(away_games) AS away_games,
    SUM(home_games + away_games) AS total_games_played
FROM (
    SELECT
        home_team AS team,
        COUNT(*) AS home_games,
        0 AS away_games
    FROM results
    GROUP BY home_team
    UNION ALL
    SELECT
        away_team AS team,
        0 AS home_games,
        COUNT(*) AS away_games
    FROM results
    GROUP BY away_team
) AS subquery
GROUP BY team
ORDER BY total_games_played desc
;

-- Which are the top 10 teams with more wins? Clasify by home and away games.

SELECT team,
	SUM(home_wins) AS home_wins,
    SUM(away_wins) AS away_wins,
	SUM(home_wins + away_wins) AS total_wins
FROM (
	SELECT 
		home_team AS team,
        SUM(CASE
        WHEN home_score > away_score THEN 1 ELSE 0 END) AS home_wins,
        0 AS away_wins
	FROM results
    GROUP BY home_team
    UNION
    SELECT 
		away_team AS team,
        0 AS home_wins,
        SUM(CASE
        WHEN home_score < away_score THEN 1 ELSE 0 END) AS away_wins
	FROM results
    GROUP BY away_team
) AS subquery
GROUP BY team
ORDER BY total_wins desc
;

-- Which is the top 10 with less losses? Clasify by home and away games.

SELECT team,
	SUM(home_losses) AS home_losses,
    SUM(away_losses) AS away_losses,
	SUM(home_losses + away_losses) AS total_losses
FROM (
	SELECT 
		home_team AS team,
        0 AS away_losses,
        SUM(CASE
        WHEN home_score < away_score THEN 1 ELSE 0 END) AS home_losses
	FROM results
    GROUP BY home_team
    UNION ALL
    SELECT 
		away_team AS team,
        SUM(CASE
        WHEN home_score > away_score THEN 1 ELSE 0 END) AS away_losses,
        0 AS home_losses
	FROM results
    GROUP BY away_team
) AS subquery
GROUP BY team
ORDER BY total_losses desc
;

-- Which team dominated different eras of football?

SELECT decade,
    team,
    total_wins,
    ranking
FROM (
    SELECT decade,
        team,
        total_wins,
        ROW_NUMBER() OVER (PARTITION BY decade ORDER BY total_wins DESC) AS ranking
    FROM (
        SELECT team,
			CONCAT(YEAR(date) DIV 10 * 10, 's') AS decade,
            COUNT(*) AS total_wins
        FROM (
            SELECT 
				home_team AS team,
                date
            FROM results
            WHERE home_score > away_score
            UNION ALL
            SELECT 
				away_team AS team,
                date
            FROM results
            WHERE away_score > home_score
            ) AS subquery
        GROUP BY decade,
            team
        ) AS wins_per_decade
    ) AS ranked_results
WHERE
    ranking <= 5
ORDER BY
    decade,
    total_wins DESC
;


-- Does hosting a major tournament have an influence on winning the tournament?

SELECT date,
	home_team,
	away_team,
	home_score,
    away_score,
	tournament
FROM results
WHERE home_team = country AND tournament IN ('FIFA World Cup', 'AFC Asian Cup', 'African Cup of Nations', 'Copa America', 'UEFA Euro')
ORDER BY tournament, date
;
