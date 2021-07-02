-- In this first CTE, the table mimic_hosp.labevents is first joined with icustays (so that we only get labs for patients in the icu) 
-- and then with the table mimic_hosp.d_labitems, because labitems contains the plaintext labels that correspond to the itemids
-- from the labevents table
-- In later CTE's, the individual labs have to be separated out by a WHERE clause (i.e. WHERE label = "Bicarbonate")
-- These plaintext labels were found by searching through the labitems table for the relevant plaintext
-- They should be correct on first approximation, but if we find unexpectedly sparse columns, we may want to double check these
-- This query TRUNCATES THE HOUR to the earliest, closest hour to when the lab was *recorded* 
-- (Charttime according to MIMIC-IV documentation refers to when the lab was recorded)

DROP TABLE IF EXISTS public.hourly_labs_flat;

CREATE TABLE public.hourly_labs_flat as

WITH
  labs AS (
  SELECT
    *
  FROM (
    SELECT
      *
    FROM
      mimic_hosp.labevents
    JOIN
      mimic_icu.icustays
    USING
      (subject_id,
        hadm_id)
    WHERE
    DATE_TRUNC('hour',charttime) < outtime
    AND
    DATE_TRUNC('hour',charttime) > intime ) as labevents
  JOIN
    mimic_hosp.d_labitems
  USING
    (itemid)),
    
  bicarb AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour',charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Bicarbonate'),
  chloride AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour',charttime) AS charttime,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Chloride'),
    
  bilirubin_indirect AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour',charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Bilirubin, Indirect'),
    
  bilirubin_direct AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour',charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Bilirubin, Direct'),
    
  bilirubin_total AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour',charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Bilirubin, Total'),
    
  calcium AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Calcium'),
    
  creatinine AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Creatinine'),
    
  glucose AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Glucose'),
    
  lactate AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Lactate'),
    
  magnesium AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Magnesium'),
    
  phosphate AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Phosphate'),
    
  potassium AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Potassium'),
    
  troponin AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Troponin I'),
    
  Hct AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Hematocrit'),
    
  Hgb AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Hemoglobin'),
    
  PTT AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'PTT'),
    
  WBC AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'WBC Count'),
    
  Fibrinogen AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Fibrinogen'),
    
  Platelets AS (
  SELECT
    subject_id,
    hadm_id,
    stay_id,
    label,
    DATE_TRUNC('hour', charttime) AS chart_hour,
    valuenum AS value,
    valueuom AS units,
    fluid AS fluid
  FROM
    labs
  WHERE
    label = 'Platelet Count')
    
SELECT
  *
FROM
  bicarb
UNION ALL
SELECT * FROM
  chloride
UNION ALL
SELECT * FROM
  bilirubin_indirect
UNION ALL
SELECT * FROM
  bilirubin_direct
UNION ALL
SELECT * FROM
  bilirubin_total
UNION ALL
SELECT * FROM
  calcium
UNION ALL
SELECT * FROM
  creatinine
UNION ALL
SELECT * FROM
  glucose
UNION ALL
SELECT * FROM
  lactate
UNION ALL
SELECT * FROM
  magnesium
UNION ALL
SELECT * FROM
  phosphate
UNION ALL
SELECT * FROM
  potassium
UNION ALL
SELECT * FROM
  troponin
UNION ALL
SELECT * FROM
  Hct
UNION ALL
SELECT * FROM
  Hgb
UNION ALL
SELECT * FROM
  PTT
UNION ALL
SELECT * FROM
  WBC
UNION ALL
SELECT * FROM
  Fibrinogen
UNION ALL
SELECT * FROM
  Platelets
