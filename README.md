# Introduction
Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on business analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

The SQL queries leveraged for the analysis can be found at [project_sql](https://github.com/RynThomas/SQL-Project-Data-Job-Analysis/tree/main/project_sql)

# Background
The motivation behind this project stemmed from my desire to understand the business analyst job market better. I aimed to discover which skills are paid the most and in demand, making a job search in this space more targeted and effective. 

The data for this analysis is from Luke Barousse’s [SQL Course](https://lukebarousse.com/sql). This data includes details on job titles, salaries, locations, and required skills. Note that this data stems from 2023, but is still more than relevant for positions posted in 2024.

## The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?

2. What skills are required for these top-paying jobs?

3. What skills are most in demand for data analysts?

4. Which skills are associated with higher salaries?

5. What are the most optimal skills to learn?

Each question focused on the positions or skills required for those within my local job market, so each query aimed to answer these will filter to positions available in Virginia or remotely.

# Tools Used
- SQL: The code leveraged to query the database and gather critical insights.
- PostgreSQL: The particular database management system selected, which is used widely across a variety of comapnies to store valuable data. This allowed me to store, query, and manipulate the job posting data.
- Visual Studio Code: This open-source administration and development platform helped me manage the database and execute SQL queries.
- Git & GitHub: Allows for improved collaboration and sharing of my queries and analysis, within a version controlled environment.

# Analysis
Each query (5 total) of the project aims to investigate a particular aspect about the business analyst job market, primarily related to salary and skills for these positions.

## 1. Top Paying Business Analyst Roles
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
``` sql
-- Identify the top 10 paying Business Analyst roles available remotely or locally.
SELECT
    job_postings.job_id,
    job_postings.job_title,
    companies.name as company_name,
    job_postings.job_location,
	job_postings.job_schedule_type,
	job_postings.salary_year_avg,
	job_postings.job_posted_date
FROM
    job_postings_fact AS job_postings
    LEFT JOIN company_dim AS companies ON job_postings.company_id = companies.company_id
WHERE
	job_postings.job_title = 'Business Analyst'
	AND job_postings.salary_year_avg IS NOT NULL
	AND (job_location = 'Anywhere' OR job_location LIKE '%VA%')
ORDER BY 
    job_postings.salary_year_avg DESC
LIMIT 10;
```

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
-- Identify the top 10 paying skills required for Business Analyst roles available remotely or locally.
-- Captures the top 10 paying Business Analyst roles.
WITH top_paying_jobs AS (
    SELECT
    job_postings.job_id,
    job_postings.job_title,
    companies.name as company_name,
	job_postings.salary_year_avg
FROM
    job_postings_fact AS job_postings
    LEFT JOIN company_dim AS companies ON job_postings.company_id = companies.company_id
WHERE
	job_postings.job_title = 'Business Analyst'
	AND job_postings.salary_year_avg IS NOT NULL
	AND (job_location = 'Anywhere' OR job_location LIKE '%VA%')
ORDER BY 
    job_postings.salary_year_avg DESC
LIMIT 10
)
-- Identifies the skills required for the top 10 paying Business Analyst roles
SELECT 
    top_paying_jobs.job_id,
    job_title,
    salary_year_avg,
    skills
FROM
    top_paying_jobs
    INNER JOIN
        skills_job_dim AS skills_job ON top_paying_jobs.job_id = skills_job.job_id
	INNER JOIN
        skills_dim AS skills ON skills_job.skill_id = skills.skill_id
ORDER BY
    salary_year_avg DESC;
```

## 3. In-Demand Skills for Business Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
-- Identifies the top 5 most demanded skills for remote or local Business Analyst job postings.
SELECT
    skills.skills,
    COUNT(skills_job.job_id) AS skill_count
FROM
    job_postings_fact AS job_postings
    INNER JOIN  
        skills_job_dim AS skills_job ON job_postings.job_id = skills_job.job_id
    INNER JOIN
        skills_dim AS skills ON skills_job.skill_id = skills.skill_id
WHERE
    job_postings.job_title_short = 'Business Analyst'
    AND (job_postings.job_work_from_home = True OR job_postings.job_location LIKE '%VA%')
GROUP BY
    skills.skills
ORDER BY
    skill_count DESC
LIMIT 5;
```

## 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql

-- Calculates the average salary for remote or local Business Analyst job postings by individual skill.
SELECT
    skills.skills AS skill,
    ROUND(AVG(job_postings.salary_year_avg),2) AS avg_salary
FROM
    job_postings_fact AS job_postings
    INNER JOIN  
        skills_job_dim AS skills_job ON job_postings.job_id = skills_job.job_id
    INNER JOIN
        skills_dim AS skills ON skills_job.skill_id = skills.skill_id
WHERE
    job_postings.job_title_short = 'Business Analyst'
    AND job_postings.salary_year_avg IS NOT NULL
    AND (job_postings.job_work_from_home = True OR job_postings.job_location LIKE '%VA%')
GROUP BY
    skills.skills
ORDER BY
    avg_salary DESC;
```

## 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
-- Return 10 skills with the highest demand and salaries for Business analyst roles
SELECT
    skills_dim.skills, 
    COUNT(skills_job_dim.job_id) as skill_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Business Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND (job_postings_fact.job_work_from_home = True OR job_postings_fact.job_location LIKE '%VA%')
GROUP BY
    skills_dim.skills
HAVING
	COUNT(skills_job_dim.job_id) > 5 -- Ensure skill count is higher than 5 to remove outliers
ORDER BY
    avg_salary DESC,
    skill_count DESC
LIMIT 10;
```

Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

# What I Learned
Throughout this project, I honed several key SQL techniques and skills:
- **Complex Query Construction:** Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation:** Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking:** Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.
# Conclusions 
## Insights
From the analysis, several general insights emerged:
1. **Top-Paying Business Analyst Jobs**: The highest-paying jobs for business analysts in VA or that allow remote work offer a wide range of salaries, the highest at $X!
2. **Skills for Top-Paying Jobs**: 
3. **Most In-Demand Skills**: 
4. **Skills with Higher Salaries**: 
5. **Optimal Skills for Job Market Value**:
## Final Thoughts
This project enhanced my SQL skills and provided valuable insights into the business analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring business analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
