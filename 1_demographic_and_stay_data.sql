CREATE OR REPLACE TABLE `physionet.demographic_and_stay_data` as

SELECT
  subject_id,
  hadm_id,
  stay_id,
  admittime,
  deathtime,
  DATETIME(hour) as charttime,
  admission_type,
  discharge_location,
  first_careunit,
  last_careunit,
  intime,
  outtime,
  los as total_los,
  ethnicity,
  gender,
  anchor_age
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
JOIN
  UNNEST(GENERATE_TIMESTAMP_ARRAY(TIMESTAMP(DATETIME_TRUNC(admittime,
          HOUR)),
      TIMESTAMP(DATETIME_TRUNC(dischtime,
          HOUR)),
      INTERVAL 1 HOUR)) HOUR
