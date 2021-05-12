-- This query uses the table "procedureevents" which records when a patient was ventilated and then when they were unventilated
-- In order to expand this into the hourly format we need, I've used the "Generate Timestamp Array" function provided by bigquery: 
-- See: https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#generate_date_array

CREATE OR REPLACE TABLE `physionet.hourly_patient_vent_status_pivoted` as


SELECT
  subject_id,
  hadm_id,
  stay_id,
  DATETIME_TRUNC(starttime,
    HOUR) AS chart_hour,
  starttime,
  endtime,
  day,
  TRUE AS ventilated
FROM
  `physionet-data.mimic_icu.procedureevents`
JOIN
  UNNEST(GENERATE_TIMESTAMP_ARRAY(TIMESTAMP(DATETIME_TRUNC(starttime,
          HOUR)),
      TIMESTAMP(DATETIME_TRUNC(endtime,
          HOUR)),
      INTERVAL 1 HOUR)) DAY
WHERE
  ordercategoryname = "Ventilation"
