CREATE OR REPLACE TABLE `physionet.hourly_abg_pivoted` as

SELECT 
subject_id,
hadm_id,
stay_id,
charttime,
AVG(if (label ='Arterial O2 pressure', value, null)) as PaO2,
AVG(if (label ='Arterial O2 Saturation', value, null)) as SaO2,
AVG(if (label ='Arterial CO2 Pressure', value, null)) as PaCO2,
AVG(if (label ='PH (Arterial)', value, null)) as pH,
AVG(if (label ='Arterial Base Excess', value, null)) as base_excess,
FROM `elevated-pod-307118.physionet.hourly_abg_flat`
GROUP BY subject_id, hadm_id, stay_id, charttime
