use payroll

CREATE TABLE `department` (
  `Dept_id` int NOT NULL,
  `Dept_name` varchar(50) DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`Dept_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `department_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`Emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `employees` (
  `Emp_id` int NOT NULL,
  `Emp_name` varchar(50) DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `Ethinity` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `jobs` (
  `job_id` int NOT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `job_class_pgrade` varchar(6) DEFAULT NULL,
  `employement_type` varchar(20) DEFAULT NULL,
  `job_status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `pay_year` varchar(20) DEFAULT NULL,
  `Regular_pay` decimal(14,2) DEFAULT NULL,
  `overtime_pay` decimal(14,2) DEFAULT NULL,
  `allother_pay` decimal(14,2) DEFAULT NULL,
  `retirement_contributions` decimal(14,2) DEFAULT NULL,
  `benefit_pay` decimal(14,2) DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `job_id` (`job_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dept_jobs` (
  `dept_jobs_id` int NOT NULL,
  `dept_no` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`dept_jobs_id`),
  KEY `dept_no` (`dept_no`),
  KEY `job_id` (`job_id`),
  CONSTRAINT `dept_jobs_ibfk_1` FOREIGN KEY (`dept_no`) REFERENCES `department` (`Dept_id`),
  CONSTRAINT `dept_jobs_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
 /* calculate the avg,min,max salaries */
 
 select  e.emp_id,
 min(p.regular_pay+overtime_pay+allother_pay) as minsal,
 max(p.regular_pay+overtime_pay+allother_pay) as maxsal,
 avg(p.regular_pay+overtime_pay+allother_pay) as avgsal
 from employees e
 join department d on e.emp_id=d.employee_id
 join dept_jobs dj on dj.dept_no=d.dept_id
 join jobs j on j.job_id=dj.job_id
 join payments p on p.job_id=j.job_id
 group by  e.emp_id
 
 
 /*fetch the salary along as the employee and job title who are geting highest */
 
 select  e.emp_id, j.job_title,
 min(p.regular_pay+overtime_pay+allother_pay) as minsal,
 max(p.regular_pay+overtime_pay+allother_pay) as maxsal,
 avg(p.regular_pay+overtime_pay+allother_pay) as avgsal
 from employees e
 join department d on e.emp_id=d.employee_id
 join dept_jobs dj on dj.dept_no=d.dept_id
 join jobs j on j.job_id=dj.job_id
 join payments p on p.job_id=j.job_id
 group by  e.emp_id,j.job_title
 
 /* Determine the salary distribution across different departments or job titles */
  select  e.emp_id, j.job_title,d.dept_name,
 min(p.regular_pay+overtime_pay+allother_pay) as minsal,
 max(p.regular_pay+overtime_pay+allother_pay) as maxsal,
 avg(p.regular_pay+overtime_pay+allother_pay) as avgsal
 from employees e
 join department d on e.emp_id=d.employee_id
 join dept_jobs dj on dj.dept_no=d.dept_id
 join jobs j on j.job_id=dj.job_id
 join payments p on p.job_id=j.job_id
 group by  e.emp_id,j.job_title,d.dept_name

/*Analyse salary trends over time (you can use the GROUP BY on a YEA */

select  p.pay_year,
 min(p.regular_pay+overtime_pay+allother_pay) as minsal,
 max(p.regular_pay+overtime_pay+allother_pay) as maxsal,
 avg(p.regular_pay+overtime_pay+allother_pay) as avgsal
 from employees e
 join department d on e.emp_id=d.employee_id
 join dept_jobs dj on dj.dept_no=d.dept_id
 join jobs j on j.job_id=dj.job_id
 join payments p on p.job_id=j.job_id
 group by  p.pay_year

/*Identify the departments or job titles with the highest diversit*/

select  d.dept_name,j.job_title,
count(e.ethinity) as high_diversity
  from employees e
 join department d on e.emp_id=d.employee_id
 join dept_jobs dj on dj.dept_no=d.dept_id
 join jobs j on j.job_id=dj.job_id
 join payments p on p.job_id=j.job_id
 group by  d.dept_name,j.job_title
 
 /* Identify employees with the highest amount of overtime */
 
 select  e.emp_id,
  max(overtime_pay) as maxoverttime
  from employees e
 join department d on e.emp_id=d.employee_id
 join dept_jobs dj on dj.dept_no=d.dept_id
 join jobs j on j.job_id=dj.job_id
 join payments p on p.job_id=j.job_id
 group by  e.emp_id

