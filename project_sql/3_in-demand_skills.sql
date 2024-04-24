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