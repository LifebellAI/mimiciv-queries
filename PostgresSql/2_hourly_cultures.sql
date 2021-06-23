-- This query right now is restricted to the main cultures we anticipate
-- Including blood, urine, stool, BAL, pleural, and CSF
-- We are notably excluding less common things like joint aspirations and swabs that we aren't currently using as
-- indications of clinical supsicion of infection


DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.cultures_hourly) THEN
        DROP TABLE public.cultures_hourly;
    END IF;
END
$do$;

CREATE TABLE public.cultures_hourly as

SELECT
  subject_id,
  hadm_id,
  stay_id,
  DATE_TRUNC('hour',charttime) AS chart_hour,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'blood' THEN 1 else 0 end) as blood_cx,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'urine' THEN 1 else 0 end) as urine_cx,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'sputum' THEN 1 else 0 end )as sputum_cx,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'stool' THEN 1 else 0 end) as stool_cx,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'BRONCHOALVEOLAR LAVAGE' THEN 1 else 0 end) as broncho_lavage_cx,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'PLEURAL FLUID' THEN 1 else 0 end )as pleural_cx,
  max(CASE WHEN LOWER(spec_type_desc) LIKE 'CSF;SPINAL FLUID' THEN 1 else 0 end )as csf_cx
FROM
  mimic_hosp.microbiologyevents
JOIN
  mimic_icu.icustays
USING
  (subject_id,
    hadm_id)
WHERE spec_type_desc in 
('SPUTUM', 
'BLOOD CULTURE', 
'URINE',
'FLUID RECEIVED IN BLOOD CULTURE BOTTLES',
'URINE,KIDNEY',
'URINE,SUPRAPUBIC ASPIRATE',
'Blood (EBV)',
'Blood (CMV AB)',
'Blood (LYME)',
'Blood (Toxo)',
'Blood (Malaria)',
'VIRAL CULTURE',
'BLOOD',
'SWAB',
'STOOL',
'BRONCHOALVEOLAR LAVAGE',
'CSF;SPINAL FLUID',
'PLEURAL FLUID')
-- Since the microbiology table does not record the stay_id, we have to use the following condition
 -- to map the culture to the correct incident of the patients stay
AND
DATE_TRUNC('hour',charttime) < outtime
AND
DATE_TRUNC('hour',charttime) > intime
GROUP BY subject_id, hadm_id, stay_id, DATE_TRUNC('hour',charttime)
