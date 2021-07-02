
-- This schema is *SIMILAR* but not exactly the same as the PNC 2019 Challenge Schema
-- Changing this to the correct schema should be very simple
-- Please feel free to modify this yourself (add/rename/remove fields) to get it into the schema needed

CREATE OR REPLACE TABLE `physionet.final_schema` AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
admittime,
deathtime,
admission_type,
first_careunit,
last_careunit,
total_los,
ethnicity,
gender,
weight,
weight_units,
anchor_age AS age,
-- Cultures fields
blood_cx,
urine_cx,
sputum_cx,
-- Antibiotics fields (input events)
amount AS antibiotics_amount,
rate AS antibiotics_rate,
--Antibiotics fields (pharmacy)
abx_orders,
-- pressors fields
pressors_orders,
dobutamine_mcg AS dobutamine,
dopamine_mcg AS dopamine,
norepinephrine_mcg AS norepinephrine,
epinephrine_mcg AS epinephrine,
-- vitals
resp_rate,
heart_rate,
temperature,
systolic_bp,
diasystolic_bp AS diastolic_bp,
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
troponin_i,
hematocrit,
hemoglobin,
ptt,
wbc,
fibrinogen,
platelets,
-- ABG
pao2,
sao2,
paco2,
ph,
base_excess,
-- supplemental flow
fio2,
o2_flow_rate,
-- vent status
ventilated
FROM `elevated-pod-307118.physionet.demographic_and_stay_data`
FULL JOIN
`elevated-pod-307118.physionet.cultures_hourly`
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
`elevated-pod-307118.physionet.iv_antibiotics_inputevents`
USING(subject_id, hadm_id, stay_id, chart_hour)
-- iv_abx_pharmacy is rolled up to the stay x chart_hour x medication grain
-- we need to roll it up further to the stay x chart_hour grain in order to join with the rest of the tables
FULL JOIN
(
    SELECT subject_id, hadm_id, stay_id, chart_hour, count(1) AS abx_orders
    FROM `elevated-pod-307118.physionet.iv_abx_pharmacy`
    GROUP BY subject_id, hadm_id, stay_id, chart_hour
)
USING(subject_id, hadm_id, stay_id, chart_hour)
LEFT JOIN
`elevated-pod-307118.physionet.hourly_vitals_pivoted`
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
`elevated-pod-307118.physionet.hourly_labs_pivoted`
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
`elevated-pod-307118.physionet.hourly_abg_pivoted`
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
`elevated-pod-307118.physionet.hourly_supplemental_o2_pivoted`
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
`elevated-pod-307118.physionet.hourly_patient_vent_status_pivoted`
USING(subject_id, hadm_id, stay_id, chart_hour)
--join aggregated and transformed pressors data
FULL JOIN
(
    SELECT subject_id, hadm_id, stay_id, chart_hour
    , COUNT(1) AS pressors_orders
    , SUM(IF(LOWER(drug) LIKE '%dobutamine%',CAST(dose_val_rx AS numeric), NULL)) AS dobutamine_mcg
    , SUM(IF(LOWER(drug) LIKE '%dopamine%',CAST(dose_val_rx AS numeric), NULL)) AS dopamine_mcg
    , SUM(IF(LOWER(drug) LIKE '%norepinephrine%',CAST(dose_val_rx AS  numeric), NULL)) AS norepinephrine_mcg
    , SUM(IF((LOWER(drug) LIKE '%epinephrine%') AND (LOWER(medication) NOT LIKE '%nor%'), CAST(dose_val_rx AS numeric), NULL)) AS epinephrine_mcg
    FROM `elevated-pod-307118.physionet.pressors`
    GROUP BY subject_id, hadm_id, stay_id, chart_hour
)
USING(subject_id, hadm_id, stay_id, chart_hour)
