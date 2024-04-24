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