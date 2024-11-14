-- Calculate total loyalty points for each player for October 2022
WITH MonthlyDeposits AS (
    SELECT d.User_ID, SUM(CAST(d.Amount AS DECIMAL(10, 2))) AS Total_Deposit, COUNT(*) AS Num_Deposits
    FROM Deposit d
    WHERE CONVERT(DATE, d.Datetime) BETWEEN '2022-10-01' AND '2022-10-31'
    GROUP BY d.User_ID
),
MonthlyWithdrawals AS (
    SELECT w.User_ID, SUM(CAST(w.Amount AS DECIMAL(10, 2))) AS Total_Withdrawal, COUNT(*) AS Num_Withdrawals
    FROM Withdrawal w
    WHERE CONVERT(DATE, w.Datetime) BETWEEN '2022-10-01' AND '2022-10-31'
    GROUP BY w.User_ID
),
MonthlyGamesPlayed AS (
    SELECT g.User_ID, SUM(CAST(g.Games_Played AS INT)) AS Total_Games_Played
    FROM User_Gameplay g
    WHERE CONVERT(DATE, g.Datetime) BETWEEN '2022-10-01' AND '2022-10-31'
    GROUP BY g.User_ID
),
TotalLoyaltyPoints AS (
    SELECT
        COALESCE(d.User_ID, w.User_ID, g.User_ID) AS User_ID,
        COALESCE(Total_Deposit, 0) AS Total_Deposit,
        COALESCE(Total_Withdrawal, 0) AS Total_Withdrawal,
        COALESCE(Total_Games_Played, 0) AS Total_Games_Played,
        (0.01 * COALESCE(Total_Deposit, 0)) + 
        (0.005 * COALESCE(Total_Withdrawal, 0)) + 
        (0.001 * GREATEST(COALESCE(d.Num_Deposits, 0) - COALESCE(w.Num_Withdrawals, 0), 0)) + 
        (0.2 * COALESCE(Total_Games_Played, 0)) AS Total_Loyalty_Points
    FROM MonthlyDeposits d
    LEFT JOIN MonthlyWithdrawals w ON d.User_ID = w.User_ID
    LEFT JOIN MonthlyGamesPlayed g ON COALESCE(d.User_ID, w.User_ID) = g.User_ID
),
RankedPlayers AS (
    SELECT
        User_ID,
        Total_Loyalty_Points,
        RANK() OVER (ORDER BY Total_Loyalty_Points DESC, Total_Games_Played DESC) AS Player_Rank
    FROM TotalLoyaltyPoints
),
Top50Players AS (
    SELECT 
        User_ID, 
        Total_Loyalty_Points,
        Player_Rank
    FROM RankedPlayers 
    WHERE Player_Rank <= 50
),
TotalPoints AS (
    SELECT SUM(Total_Loyalty_Points) AS Total_Loyalty_Points_Sum 
    FROM Top50Players
)
-- Allocate bonus to top 50 players based on their loyalty points
SELECT 
    p.User_ID,
    p.Total_Loyalty_Points,
    (p.Total_Loyalty_Points / t.Total_Loyalty_Points_Sum) * 50000 AS Bonus_Amount
FROM 
    Top50Players p, 
    TotalPoints t
ORDER BY 
    p.Player_Rank;
