#Условие: Вторая по величине зарплата 

WITH dense_rnk AS(
SELECT salary,
DENSE_RANK() OVER (ORDER BY salary DESC) as dr
FROM employees
)
SELECT salary
FROM dense_rnk
WHERE dense_rnk.dr = 2;
