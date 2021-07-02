-- This file pulls out all of the arterial blood gas monitoring data

DROP TABLE IF EXISTS public.hourly_abg_flat;

CREATE TABLE public.hourly_abg_flat AS

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
  'Arterial O2 pressure',
  'Arterial O2 Saturation',
  'Arterial CO2 Pressure',
  'PH (Arterial)',
  'Arterial Base Excess'
)
