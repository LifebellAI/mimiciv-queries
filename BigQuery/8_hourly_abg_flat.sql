-- This file pulls out all of the arterial blood gas monitoring data
CREATE OR REPLACE TABLE `physionet.hourly_abg_flat` AS

SELECT
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC(charttime, HOUR) AS chart_hour,
valuenum AS value,
valueuom AS units,
label
FROM `physionet-data.mimic_icu.chartevents`
JOIN `physionet-data.mimic_icu.d_items`
USING(itemid)
WHERE label IN
(
  'Arterial O2 pressure',
  'Arterial O2 Saturation',
  'Arterial CO2 Pressure',
  'PH (Arterial)',
  'Arterial Base Excess'
)
