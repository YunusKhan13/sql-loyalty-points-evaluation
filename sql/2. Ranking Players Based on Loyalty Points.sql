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
)
SELECT
    User_ID,
    Total_Deposit,
    Total_Withdrawal,
    Total_Games_Played,
    Total_Loyalty_Points,
    RANK() OVER (ORDER BY Total_Loyalty_Points DESC, Total_Games_Played DESC) AS Rank
FROM TotalLoyaltyPoints;
