DROP TABLE IF EXISTS public.hourly_supplemental_o2_pivoted;

CREATE TABLE public.hourly_supplemental_o2_pivoted AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(CASE WHEN label in ('Inspired O2 Fraction') THEN value END) AS FiO2,
AVG(CASE WHEN label in ('O2 Flow') THEN value END) AS O2_flow_rate
FROM hourly_supplemental_o2_flat
GROUP BY subject_id, hadm_id, stay_id, chart_hour
