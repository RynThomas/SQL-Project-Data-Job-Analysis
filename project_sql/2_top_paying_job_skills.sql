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