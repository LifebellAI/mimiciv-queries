-- This file pulls out all of the arterial blood gas monitoring data
DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.hourly_abg_flat) THEN
        DROP TABLE public.hourly_abg_flat;
    END IF;
END
$do$;

CREATE TABLE public.hourly_abg_flat as

SELECT 
subject_id,
hadm_id,
stay_id,
DATE_TRUNC('hour', charttime) as chart_hour,
valuenum as value,
valueuom as units,
label
FROM mimic_icu.chartevents
JOIN mimic_icu.d_items
USING(itemid)
WHERE label in
('Arterial O2 pressure',
'Arterial O2 Saturation',
'Arterial CO2 Pressure',
'PH (Arterial)',
'Arterial Base Excess'
)
