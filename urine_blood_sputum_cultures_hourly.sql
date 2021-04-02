SELECT
  subject_id,
  hadm_id,
  DATETIME_TRUNC(charttime,
    HOUR) AS charttime,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'blood'), org_name, null)) as blood_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'urine'), org_name, null)) as urine_cx,
  ANY_VALUE(if (REGEXP_CONTAINS(LOWER(spec_type_desc), 'sputum'), org_name, null)) as urine_cx,
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
'BLOOD')
GROUP BY subject_id, hadm_id, DATETIME_TRUNC(charttime,
    HOUR)
