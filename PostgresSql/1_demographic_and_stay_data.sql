
DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.demographic_and_stay_data) THEN
        DROP TABLE public.demographic_and_stay_data;
    END IF;
END
$do$;

CREATE TABLE public.demographic_and_stay_data as

SELECT
  subject_id,
  hadm_id,
  stay_id,
  admittime,
  deathtime,
  chart_hour,
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
  mimic_core.admissions
JOIN
  mimic_core.patients
USING
  (subject_id)
JOIN
  mimic_icu.icustays
USING
  (subject_id,
    hadm_id)
CROSS JOIN LATERAL (SELECT generate_series(DATE_TRUNC('hour', admittime::timestamp )::timestamp, date_trunc('hour', dischtime::timestamp)::timestamp, '1 hour') chart_hour) as hours
