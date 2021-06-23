-- This file pulls out data about both FiO2 and O2Flow - it's unclear yet which one is a more reliable field

DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.hourly_supplemental_o2_flat) THEN
        DROP TABLE public.hourly_supplemental_o2_flat;
    END IF;
END
$do$;

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
