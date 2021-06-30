CREATE OR REPLACE TABLE `physionet.hourly_abg_pivoted` AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(if (label ='Arterial O2 pressure', value, null)) AS PaO2,
AVG(if (label ='Arterial O2 Saturation', value, null)) AS SaO2,
AVG(if (label ='Arterial CO2 Pressure', value, null)) AS PaCO2,
AVG(if (label ='PH (Arterial)', value, null)) AS pH,
AVG(if (label ='Arterial Base Excess', value, null)) AS base_excess,
FROM `elevated-pod-307118.physionet.hourly_abg_flat`
GROUP BY subject_id, hadm_id, stay_id, chart_hour
