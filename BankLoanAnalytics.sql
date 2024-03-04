                                      --- BANK LOAN ANALYTICS ---

SELECT * FROM bank_loan_info

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS

--- ANALYTICS PROCESS
-- 1. Summary
-- 2. Overview 
-- 3. Details

-- (1) SUMMARY
          -- SUMMARY(KPIs)

-- Total Loan Applications
SELECT COUNT(id) FROM bank_loan_info
SELECT DISTINCT COUNT(id) FROM bank_loan_info
-- Total MTD Loan Applications
SELECT COUNT(id) FROM bank_loan_info
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
-- Total Loan Applications MOM (%)
SELECT CONCAT(ROUND(((total_mtd_applications - total_pmtd_applications) * 100.0 /
       total_pmtd_applications),2),'%') AS mom_rate
FROM
    ( SELECT COUNT(id) AS total_mtd_applications FROM bank_loan_info
      WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
    ) current_month,
    ( SELECT COUNT(id) AS total_pmtd_applications FROM bank_loan_info
      WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
    ) previous_month;

-- Total Amount Disbursed
SELECT SUM(loan_amount) FROM bank_loan_info
-- Total MTD Amount Disbursed
SELECT SUM(loan_amount) FROM bank_loan_info
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
-- Total Loan Amount Disbursed MOM (%)
SELECT CONCAT(ROUND(((total_mtd_disbursed - total_pmtd_disbursed) * 100.0 /
       total_pmtd_disbursed),2),'%') AS mom_rate
FROM
    ( SELECT SUM(loan_amount) AS total_mtd_disbursed FROM bank_loan_info
      WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
    ) current_month,
    ( SELECT SUM(loan_amount) AS total_pmtd_disbursed FROM bank_loan_info
      WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
    ) previous_month;

-- Total Amount Received
SELECT SUM(total_payment) FROM bank_loan_info
-- Total MTD Amount Received
SELECT SUM(total_payment) FROM bank_loan_info
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
-- Total Loan Amount Received MOM (%)
SELECT CONCAT(ROUND(((total_mtd_received - total_pmtd_received) * 100.0 /
       total_pmtd_received),2),'%') AS mom_rate
FROM
    ( SELECT SUM(total_payment) AS total_mtd_received FROM bank_loan_info
      WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
    ) current_month,
    ( SELECT SUM(total_payment) AS total_pmtd_received FROM bank_loan_info
      WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
    ) previous_month;

-- Average Interest Rate
SELECT CONCAT(ROUND(AVG(int_rate),4) * 100, '%') FROM bank_loan_info
-- MTD Average Interest Rate
SELECT CONCAT(ROUND(AVG(int_rate),4) * 100, '%') FROM bank_loan_info
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
-- Average Interest Rate MOM (%) 
SELECT CONCAT(ROUND(((avg_mtd_int_rate - avg_pmtd_int_rate) * 100.0 /
       avg_pmtd_int_rate),2),'%') AS mom_rate
FROM
    ( SELECT ROUND(AVG(int_rate),4) * 100 AS avg_mtd_int_rate FROM bank_loan_info
      WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
    ) current_month,
    ( SELECT ROUND(AVG(int_rate),4) * 100 AS avg_pmtd_int_rate FROM bank_loan_info
      WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
    ) previous_month;

-- Average DTI
SELECT CONCAT(ROUND(AVG(dti),4) * 100, '%') FROM bank_loan_info
-- MTD Average DTI
SELECT CONCAT(ROUND(AVG(dti),4) * 100, '%') FROM bank_loan_info
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
-- Average DTI MOM (%)
SELECT CONCAT(ROUND(((avg_mtd_dti - avg_pmtd_dti) * 100.0 /
       avg_pmtd_dti),2),'%') AS mom_rate
FROM
    ( SELECT ROUND(AVG(dti),4) * 100 AS avg_mtd_dti FROM bank_loan_info
      WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
    ) current_month,
    ( SELECT ROUND(AVG(dti),4) * 100 AS avg_pmtd_dti FROM bank_loan_info
      WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
    ) previous_month;
        
		  -- SUMMARY (Good Loan VS Bad Loan)
SELECT DISTINCT loan_status FROM bank_loan_info

-- Good Loan (%)
SELECT CONCAT(ROUND(SUM(CASE WHEN loan_status IN ('Fully Paid','Current') THEN 1 ELSE 0 END * 100.0) /
       COUNT(id), 1),'%')
FROM bank_loan_info
-- Total Good Loan Applications
SELECT SUM(CASE WHEN loan_status IN ('Fully Paid','Current') THEN 1 ELSE 0 END) 
FROM bank_loan_info
-- Total Good Loan Disbursed
SELECT SUM(loan_amount) FROM bank_loan_info
WHERE loan_status IN ('Fully Paid','Current')
-- Total Good Loan Received
SELECT SUM(total_payment) FROM bank_loan_info
WHERE loan_status IN ('Fully Paid','Current')

-- Bad Loan (%)
SELECT CONCAT(ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END * 100.0) /
       COUNT(id), 1),'%')
FROM bank_loan_info
-- Total Bad Loan Applications
SELECT SUM(CASE WHEN loan_status = 'Charged Off'  THEN 1 ELSE 0 END) 
FROM bank_loan_info
-- Total Bad Loan Disbursed
SELECT SUM(loan_amount) FROM bank_loan_info
WHERE loan_status = 'Charged Off'
-- Total Bad Loan Received
SELECT SUM(total_payment) FROM bank_loan_info
WHERE loan_status = 'Charged Off'

          -- SUMMARY (Loan Status)
SELECT loan_status AS Loan_Status,
       COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received,
	   CONCAT(ROUND(AVG(int_rate),4) * 100, '%') AS Avg_IntRate,
	   CONCAT(ROUND(AVG(dti),4) * 100, '%') AS Avg_DTI
FROM bank_loan_info
GROUP BY loan_status


-- (2) OVERVIEW
SELECT * FROM bank_loan_info

          -- OVERVIEW (Monthly Trends)
SELECT MONTH(issue_date) AS Month_No,
       DATENAME(MONTH,issue_date) AS Month_Name,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_info
GROUP BY MONTH(issue_date), DATENAME(MONTH,issue_date)
ORDER BY Month_No
           -- OVERVIEW (Regional Analysis)
SELECT address_state AS State,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_info
GROUP BY address_state
ORDER BY Total_Loan_Applications DESC
           -- OVERVIEW (Loan Term Analysis)
SELECT term AS Loan_Term,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_info
GROUP BY term
           -- OVERVIEW (Employee Length Analysis)
SELECT emp_length AS Employee_Length,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_info
GROUP BY emp_length
ORDER BY emp_length
           -- OVERVIEW (Loan Purpose Analysis)
SELECT purpose AS Loan_Purpose,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_info
GROUP BY purpose
ORDER BY Total_Loan_Applications DESC
           -- OVERVIEW (Home Ownership Analysis)
SELECT home_ownership AS Home_Ownership,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Amount_Disbursed,
	   SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_info
GROUP BY home_ownership
ORDER BY Total_Loan_Applications DESC


-- (3) DETAILS
SELECT id,
       purpose,
	   home_ownership,
	   grade,
	   sub_grade,
	   issue_date,
	   loan_amount,
	   total_payment,
	   term,
	   CONCAT(ROUND(int_rate *100,2),'%') interest_rate
FROM bank_loan_info



