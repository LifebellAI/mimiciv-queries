-- This file pulls out data about both FiO2 and O2Flow - it's unclear yet which one is a more reliable field

CREATE OR REPLACE TABLE `physionet.hourly_supplemental_o2_flat` as

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
('Inspired O2 Fraction',
'O2 Flow'
)
