CREATE OR REPLACE TABLE `physionet.demographic_and_stay_data` as

SELECT
  subject_id,
  hadm_id,
  stay_id,
  admittime,
  deathtime,
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
