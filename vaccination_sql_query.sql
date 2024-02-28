WITH median_table AS 
(
SELECT 
	DISTINCT COUNTRY,
	PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY daily_vaccinations) OVER (PARTITION BY COUNTRY) AS median_vacc
FROM
	[TESTDATABASE].[dbo].[vaccines_table]
)

SELECT 
	maint.country,
	maint.date,
	CASE WHEN (median_vacc is null) then 0 
	WHEN (maint.daily_vaccinations is null) then med.median_vacc
	ELSE maint.daily_vaccinations END AS daily_vacc,
	vaccines
FROM 
	[TESTDATABASE].[dbo].[vaccines_table] maint LEFT JOIN median_table med ON (maint.country = med.country)
