-- This file pulls out data about both FiO2 and O2Flow - it's unclear yet which one is a more reliable field

DROP TABLE IF EXISTS public.hourly_supplemental_o2_flat;

CREATE TABLE public.hourly_supplemental_o2_flat AS

SELECT
subject_id,
hadm_id,
stay_id,
DATE_TRUNC('hour', charttime) AS chart_hour,
valuenum AS value,
valueuom AS units,
label
FROM mimic_icu.chartevents
JOIN mimic_icu.d_items
USING(itemid)
WHERE label IN
(
  'Inspired O2 Fraction',
  'O2 Flow'
)
