-- This query uses the table "procedureevents" which records when a patient was ventilated and then when they were unventilated
-- In order to expand this into the hourly format we need, I've used the "Generate Timestamp Array" function provided by bigquery:
-- See: https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#generate_date_array
DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.hourly_patient_vent_status_pivoted) THEN
        DROP TABLE public.hourly_patient_vent_status_pivoted;
    END IF;
END
$do$;

CREATE TABLE public.hourly_patient_vent_status_pivoted as
SELECT
  subject_id,
  hadm_id,
  stay_id,
  DATE_TRUNC('hour', starttime) AS chart_hour,
  starttime,
  endtime,
  day,
  TRUE AS ventilated
FROM
  mimic_icu.procedureevents
CROSS JOIN LATERAL (SELECT generate_series(DATE_TRUNC('hour', starttime::timestamp )::timestamp, date_trunc('hour', endtime::timestamp)::timestamp, '1 hour') as day) as hours
WHERE ordercategoryname = 'Ventilation'
