-- This schema is *SIMILAR* but not exactly the same as the PNC 2019 Challenge Schema
-- Changing this to the correct schema should be <1% of the work involved in getting it to this last mile
-- Please feel free to modify this yourself (add/rename/remove fields) to get it into the schema needed
SELECT 
subject_id,
hadm_id,
charttime,
-- Cultures fields
blood_cx,
urine_cx,
sputum_cx,
-- Antibiotics fields
amount as antibiotics_amount,
rate as antibiotics_rate,
-- vitals
resp_rate,
heart_rate,
temperature,
systolic_bp,
diasystolic_bp as diastolic_bp,
mean_arterial_bp,
etco2,
spo2,
-- labs
bicarbonate,
chloride,
bilirubin_indirect,
bilirubin_direct,
bilirubin_total,
calcium,
creatinine,
glucose,
lactate,
magnesium,
phosphate,
potassium,
troponin_I,
hematocrit,
hemoglobin,
ptt,
wbc,
fibrinogen,
platelets,
-- ABG
PaO2,
SaO2,
PaCO2,
pH,
base_excess,
-- supplemental flow
FiO2,
O2_flow_rate,
-- vent status
ventilated
FROM `elevated-pod-307118.physionet.demographic_and_stay_data`
FULL JOIN
`elevated-pod-307118.physionet.cultures_hourly`
USING(subject_id, hadm_id)
FULL JOIN
`elevated-pod-307118.physionet.iv_antibiotics`
USING(subject_id, hadm_id, charttime)
LEFT JOIN
`elevated-pod-307118.physionet.hourly_vitals_pivoted`
USING(subject_id, hadm_id, charttime)
FULL JOIN
`elevated-pod-307118.physionet.hourly_labs_pivoted`
USING(subject_id, hadm_id, charttime)
FULL JOIN
`elevated-pod-307118.physionet.hourly_abg_pivoted`
USING(subject_id, hadm_id, charttime)
FULL JOIN
`elevated-pod-307118.physionet.hourly_supplemental_o2_pivoted`
USING(subject_id, hadm_id, charttime)
FULL JOIN
`elevated-pod-307118.physionet.hourly_vent_status`
USING(subject_id, hadm_id, charttime)
