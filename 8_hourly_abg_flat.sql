-- This file pulls out all of the arterial blood gas monitoring data
SELECT 
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC(charttime, HOUR) as charttime,
valuenum as value,
valueuom as units,
label
FROM `physionet-data.mimic_icu.chartevents`
JOIN `physionet-data.mimic_icu.d_items`
USING(itemid)
WHERE label in
('Arterial O2 pressure',
'Arterial O2 Saturation',
'Arterial CO2 Pressure',
'PH (Arterial)',
'Arterial Base Excess'
)
