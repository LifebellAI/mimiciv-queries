-- This query right now is restricted to the main cultures we anticipate
-- Including blood, urine, stool, BAL, pleural, and CSF
-- We are notably excluding less common things like joint aspirations and swabs that we aren't currently using as
-- indications of clinical supsicion of infection
SELECT
  subject_id,
  hadm_id,
  DATETIME_TRUNC(charttime,
    HOUR) AS charttime,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'blood'), org_name, null)) as blood_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'urine'), org_name, null)) as urine_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'sputum'), org_name, null)) as urine_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'stool'), org_name, null)) as stool_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'BRONCHOALVEOLAR LAVAGE'), org_name, null)) as broncho_lavage_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'PLEURAL FLUID'), org_name, null)) as pleural_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'CSF;SPINAL FLUID'), org_name, null)) as csf_cx,
FROM
  `physionet-data.mimic_hosp.microbiologyevents`
JOIN
  `physionet-data.mimic_icu.icustays`
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
GROUP BY subject_id, hadm_id, DATETIME_TRUNC(charttime,
    HOUR)
