
-- This schema is *SIMILAR* but not exactly the same as the PNC 2019 Challenge Schema
-- Changing this to the correct schema should be very simple
-- Please feel free to modify this yourself (add/rename/remove fields) to get it into the schema needed

CREATE OR REPLACE TABLE `physionet.final_schema` as

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
anchor_age as age,
-- Cultures fields
blood_cx,
urine_cx,
sputum_cx,
-- Antibiotics fields
amount as antibiotics_amount,
rate as antibiotics_rate,
--pressors fields
pressors_orders,
dobutamine_mcg/weight/60 as dobutamine, 
dopamine_mcg/weight/60 as dopamine,
norepinephrine_mcg/weight/60 as norepinephrine,
epinephrine_mcg/weight/60 as epinephrine,
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
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
`elevated-pod-307118.physionet.iv_antibiotics`
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
    select subject_id, hadm_id, stay_id, chart_hour
    , count(1) as pressors_orders
    , sum(if(lower(medication) like '%dobutamine%',cast(dose_val_rx as numeric), null)) as dobutamine_mcg
    , sum(if(lower(medication) like '%dopamine%',cast(dose_val_rx as numeric), null)) as dopamine_mcg
    , sum(if(lower(medication) like '%norepinephrine%',cast(dose_val_rx as numeric), null)) as norepinephrine_mcg
    , sum(if((lower(medication) like '%epinephrine%') AND (lower(medication) not like '%nor%'), cast(dose_val_rx as numeric), null)) as epinephrine_mcg
    from `elevated-pod-307118.physionet.pressors`
    GROUP BY subject_id, hadm_id, stay_id, chart_hour
)
USING(subject_id, hadm_id, stay_id, chart_hour)