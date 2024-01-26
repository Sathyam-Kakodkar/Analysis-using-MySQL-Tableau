-- Task 1
-- Create a visualization that provides a breakdown between the male and female employees working in the company each year, starting from 1990.

-- Solution
SELECT 
    distinct emp_no , from_date, to_date
FROM
    t_dept_emp;
    
SELECT 
    YEAR(d.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON e.emp_no = d.emp_no
GROUP BY calendar_year , gender
HAVING calendar_year >= 1990;

---------------------------------------------------------

-- Task 2
-- Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.

-- Solution
SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            YEAR(to_date) >= e.calendar_year
                AND YEAR(from_date) <= e.calendar_year
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calendar_year;

---------------------------------------------------------

-- Task 3
-- Compare the average salary of female versus male employees in the entire company until year 2002,
-- and add a filter allowing you to see that per each department.

-- Solution
select d.dept_name, e.gender, year(s.from_date) as calendar_year, avg(s.salary) as salary
from
t_employees e 
join 
t_dept_emp de on e.emp_no = de.emp_no
join
t_departments d on de.dept_no = d.dept_no
join
t_salaries s on e.emp_no = s.emp_no
group by calendar_year, e.gender, d.dept_no
having calendar_year <= 2002;

---------------------------------------------------------

-- Task 4
-- Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range.
-- Let this range be defined by two values the user can insert when calling the procedure.

-- Solution
select max(salary) from t_salaries;

select min(salary) from t_salaries;

drop procedure if exists filter_salary;

delimiter $$
create procedure filter_salary ( IN p_min_salary float, IN p_max_salary float)
begin
select 
e.gender , d.dept_name, avg(s.salary) as salary
from 
t_salaries s 
join
t_employees e on s.emp_no = e.emp_no
join
t_dept_emp de on e.emp_no = de.emp_no
join
t_departments d on de.dept_no = d.dept_no
 where salary between p_min_salary and p_max_salary
group by e.gender, d.dept_no;
end$$

delimiter ;

call filter_salary(50000, 90000);

