
DROP TABLE IF EXISTS public.hourly_abg_pivoted;

CREATE TABLE public.hourly_abg_pivoted as

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(CASE WHEN label in ('Arterial O2 pressure') THEN value END) as PaO2,
AVG(CASE WHEN label in ('Arterial O2 Saturation') THEN value END) as SaO2,
AVG(CASE WHEN label in ('Arterial CO2 Pressure') THEN value END) as PaCO2,
AVG(CASE WHEN label in ('PH (Arterial)') THEN value END) as pH,
AVG(CASE WHEN label in ('Arterial Base Excess') THEN value END) as base_excess
FROM hourly_abg_flat
GROUP BY subject_id, hadm_id, stay_id, chart_hour
