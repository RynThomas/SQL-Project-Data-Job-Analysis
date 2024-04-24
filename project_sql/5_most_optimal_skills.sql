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