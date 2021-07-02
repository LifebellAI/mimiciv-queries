-- This file pulls out data about both FiO2 and O2Flow - it's unclear yet which one is a more reliable field

DROP TABLE IF EXISTS public.hourly_supplemental_o2_flat;

CREATE TABLE public.hourly_supplemental_o2_flat as

SELECT 
subject_id,
hadm_id,
stay_id,
DATE_TRUNC('hour',charttime) as chart_hour,
valuenum as value,
valueuom as units,
label
FROM mimic_icu.chartevents
JOIN mimic_icu.d_items
USING(itemid)
WHERE label in
('Inspired O2 Fraction',
'O2 Flow'
)
