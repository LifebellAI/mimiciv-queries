CREATE OR REPLACE TABLE `physionet.demographic_and_stay_data` as

SELECT
  subject_id,
  hadm_id,
  stay_id,
  admittime,
  deathtime,
  DATETIME(hour) as chart_hour,
  admission_type,
  discharge_location,
  first_careunit,
  last_careunit,
  intime,
  outtime,
  los as total_los,
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
    select subject_id, round(avg(valuenum), 2) as weight, max(valueuom) as weight_units 
    from  `physionet-data.mimic_icu.chartevents`
    where valuenum is not null
    -- admission weight itemid: 226512
    -- note: may want to also consider itemid 224639 (daily weight) in the future
    and itemid = 226512 
    and valuenum > 0
    group by subject_id
)
USING (subject_id)
JOIN
  UNNEST(GENERATE_TIMESTAMP_ARRAY(TIMESTAMP(DATETIME_TRUNC(admittime,
          HOUR)),
      TIMESTAMP(DATETIME_TRUNC(dischtime,
          HOUR)),
      INTERVAL 1 HOUR)) HOUR