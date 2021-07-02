CREATE OR REPLACE TABLE `physionet.hourly_supplemental_o2_pivoted` AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(if (label ='Inspired O2 Fraction', value, null)) AS FiO2,
AVG(if (label ='O2 Flow', value, null)) AS O2_flow_rate,
FROM `elevated-pod-307118.physionet.hourly_supplemental_o2_flat`
GROUP BY subject_id, hadm_id, stay_id, chart_hour
