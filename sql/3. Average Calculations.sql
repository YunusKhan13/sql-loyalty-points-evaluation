-- Calculate the average deposit amount
SELECT AVG(CAST(Amount AS DECIMAL(10, 2))) AS Average_Deposit_Amount
FROM Deposit
WHERE CONVERT(DATE, Datetime) BETWEEN '2022-10-01' AND '2022-10-31';

-- Calculate the average deposit amount per user
SELECT AVG(User_Deposit_Avg) AS Average_Deposit_Per_User
FROM (
    SELECT 
        User_Id, 
        AVG(CAST(Amount AS DECIMAL(10, 2))) AS User_Deposit_Avg
    FROM 
        Deposit
    WHERE CONVERT(DATE, Datetime) BETWEEN '2022-10-01' AND '2022-10-31'
    GROUP BY 
        User_Id
) AS Avg_Deposits;

-- Calculate the average number of games played per user
SELECT AVG(User_Games_Avg) AS Average_Games_Per_User
FROM (
    SELECT 
        User_ID, 
        AVG(CAST(Games_Played AS INT)) AS User_Games_Avg
    FROM 
        User_Gameplay
    WHERE CONVERT(DATE, Datetime) BETWEEN '2022-10-01' AND '2022-10-31'
    GROUP BY 
        User_ID
) AS Avg_Games;
