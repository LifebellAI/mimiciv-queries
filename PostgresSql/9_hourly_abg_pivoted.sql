
DROP TABLE IF EXISTS public.hourly_abg_pivoted;

CREATE TABLE public.hourly_abg_pivoted AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(CASE WHEN label IN ('Arterial O2 pressure') THEN value END) AS PaO2,
AVG(CASE WHEN label IN ('Arterial O2 Saturation') THEN value END) AS SaO2,
AVG(CASE WHEN label IN ('Arterial CO2 Pressure') THEN value END) AS PaCO2,
AVG(CASE WHEN label IN ('PH (Arterial)') THEN value END) AS pH,
AVG(CASE WHEN label IN ('Arterial Base Excess') THEN value END) AS base_excess
FROM hourly_abg_flat
GROUP BY subject_id, hadm_id, stay_id, chart_hour
