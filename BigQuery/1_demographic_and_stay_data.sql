CREATE OR REPLACE TABLE `physionet.demographic_and_stay_data` AS

SELECT
  subject_id,
  hadm_id,
  stay_id,
  admittime,
  deathtime,
  DATETIME(hour) AS chart_hour,
  admission_type,
  discharge_location,
  first_careunit,
  last_careunit,
  intime,
  outtime,
  los AS total_los,
  ethnicity,
  gender,
  anchor_age,
  weight,
  weight_units
FROM
  `physionet-data.mimic_core.admissions`
JOIN
  `physionet-data.mimic_core.patients`
USING
  (subject_id)
JOIN
  `physionet-data.mimic_icu.icustays`
USING
  (subject_id,
    hadm_id)
LEFT JOIN
(
    SELECT
    subject_id, ROUND(AVG(valuenum), 2) AS weight,
    'kg' AS weight_units --note: the weight uom is always kg
    FROM  `physionet-data.mimic_icu.chartevents`
    WHERE valuenum IS NOT NULL
    -- admission weight itemid: 226512
    -- note: may want to also consider itemid 224639 (daily weight) in the future
    AND itemid = 226512
    AND valuenum > 0
    GROUP BY subject_id
)
USING (subject_id)
JOIN
  UNNEST(GENERATE_TIMESTAMP_ARRAY(TIMESTAMP(DATETIME_TRUNC(admittime,
          HOUR)),
      TIMESTAMP(DATETIME_TRUNC(dischtime,
          HOUR)),
      INTERVAL 1 HOUR)) HOUR
