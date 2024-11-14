# sql-loyalty-points-evaluation
SQL-Based Loyalty Points Evaluation for Gaming Platforms
# SQL-Based Loyalty Points Evaluation for Gaming Platforms

## Project Description
This project involves calculating loyalty points for players of an online gaming platform based on their activities, such as deposits, withdrawals, and games played. The loyalty points system is used to retain players and reward the top performers with cash bonuses.

## Objectives
- Calculate player-wise loyalty points for specific time slots.
- Aggregate and rank players based on their loyalty points for a given month.
- Determine average deposit amounts and games played per user.
- Propose a fair method for bonus allocation to top players.
- Assess the fairness of the current loyalty point formula and suggest improvements.

## Technologies Used
- SQL
- Database Management Systems (e.g., MySQL, PostgreSQL)
- Jupyter Notebook

## Data Description
The dataset consists of three tables:
1. **User_Gameplay:** Records the games played by users.
2. **Deposit:** Records the deposits made by users.
3. **Withdrawal:** Records the withdrawals made by users.

## Project Files
- **SQL Files:** Located in the `sql/` directory.
  - `file1.sql`: Description of what this file does.
  - `file2.sql`: Description of what this file does.
  - `file3.sql`: Description of what this file does.
  - `file4.sql`: Description of what this file does.
- **Report:** Located in the `report/` directory.
  - `Loyalty_Points_Report.ipynb`: Detailed analysis and visualization of the project.

## Key SQL Queries
```sql
-- Example key query
SELECT
    ug.User_ID,
    (0.01 * COALESCE(SUM(d.Amount), 0)) + 
    (0.005 * COALESCE(SUM(w.Amount), 0)) + 
    (0.001 * GREATEST((COALESCE(COUNT(d.User_ID), 0) - COALESCE(COUNT(w.User_ID), 0)), 0)) + 
    (0.2 * COALESCE(SUM(ug.Games_Played), 0)) AS Loyalty_Points
FROM
    User_Gameplay ug
LEFT JOIN
    Deposit d ON ug.User_ID = d.User_ID AND d.Datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 11:59:59'
LEFT JOIN
    Withdrawal w ON ug.User_ID = w.User_ID AND w.Datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 11:59:59'
WHERE
    ug.Datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 11:59:59'
GROUP BY
    ug.User_ID; 
```

## Results
- Loyalty Points Calculation: Successfully calculated and ranked players based on loyalty points for different time slots and overall for the month.

- Average Deposit Amount: Determined the average deposit amount per user and overall.

- Average Games Played: Calculated the average number of games played per user.

## Recommendations
- Proposed a fair method for bonus allocation among top players.

- Suggested improvements to the loyalty points formula to ensure fairness.

## Conclusion
This project demonstrates my ability to work with SQL, handle large datasets, and derive meaningful insights to enhance business strategies. It showcases my analytical skills and attention to detail in ensuring fairness and efficiency in loyalty reward systems.
