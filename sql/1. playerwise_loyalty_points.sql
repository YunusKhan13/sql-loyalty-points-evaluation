WITH Slots AS (
    SELECT '2022-10-02 00:00:00' AS StartDateTime, '2022-10-02 12:00:00' AS EndDateTime, 'Slot1_02Oct' AS SlotLabel UNION ALL
    SELECT '2022-10-16 12:00:00', '2022-10-17 00:00:00', 'Slot2_16Oct' UNION ALL
    SELECT '2022-10-18 00:00:00', '2022-10-18 12:00:00', 'Slot1_18Oct' UNION ALL
    SELECT '2022-10-26 12:00:00', '2022-10-27 00:00:00', 'Slot2_26Oct'
),
Deposits AS (
    SELECT s.SlotLabel, d.User_ID, SUM(CAST(d.Amount AS DECIMAL(10, 2))) AS Total_Deposit, COUNT(*) AS Num_Deposits
    FROM Deposit d
    JOIN Slots s ON d.Datetime >= s.StartDateTime AND d.Datetime < s.EndDateTime
    GROUP BY s.SlotLabel, d.User_ID
),
Withdrawals AS (
    SELECT s.SlotLabel, w.User_ID, SUM(CAST(w.Amount AS DECIMAL(10, 2))) AS Total_Withdrawal, COUNT(*) AS Num_Withdrawals
    FROM Withdrawal w
    JOIN Slots s ON w.Datetime >= s.StartDateTime AND w.Datetime < s.EndDateTime
    GROUP BY s.SlotLabel, w.User_ID
),
GamesPlayed AS (
    SELECT s.SlotLabel, g.User_ID, SUM(CAST(g.Games_Played AS INT)) AS Total_Games_Played
    FROM User_Gameplay g
    JOIN Slots s ON g.Datetime >= s.StartDateTime AND g.Datetime < s.EndDateTime
    GROUP BY s.SlotLabel, g.User_ID
)
SELECT
    s.SlotLabel,
    COALESCE(d.User_ID, w.User_ID, g.User_ID) AS User_ID,
    COALESCE(Total_Deposit, 0) AS Total_Deposit,
    COALESCE(Total_Withdrawal, 0) AS Total_Withdrawal,
    COALESCE(Total_Games_Played, 0) AS Total_Games_Played,
    (0.01 * COALESCE(Total_Deposit, 0)) + 
    (0.005 * COALESCE(Total_Withdrawal, 0)) + 
    (0.001 * GREATEST(COALESCE(d.Num_Deposits, 0) - COALESCE(w.Num_Withdrawals, 0), 0)) + 
    (0.2 * COALESCE(Total_Games_Played, 0)) AS Loyalty_Points
FROM Slots s
LEFT JOIN Deposits d ON s.SlotLabel = d.SlotLabel
LEFT JOIN Withdrawals w ON s.SlotLabel = w.SlotLabel AND d.User_ID = w.User_ID
LEFT JOIN GamesPlayed g ON s.SlotLabel = g.SlotLabel AND COALESCE(d.User_ID, w.User_ID) = g.User_ID
ORDER BY s.SlotLabel, User_ID;
