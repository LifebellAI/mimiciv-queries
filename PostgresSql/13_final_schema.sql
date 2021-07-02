
-- This schema is *SIMILAR* but not exactly the same as the PNC 2019 Challenge Schema
-- Changing this to the correct schema should be very simple
-- Please feel free to modify this yourself (add/rename/remove fields) to get it into the schema needed

DROP TABLE IF EXISTS public.final_schema;

CREATE  TABLE public.final_schema as

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
FROM public.demographic_and_stay_data
FULL JOIN
public.cultures_hourly
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
public.iv_antibiotics
USING(subject_id, hadm_id, stay_id, chart_hour)
LEFT JOIN
public.hourly_vitals_pivoted
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
public.hourly_labs_pivoted
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
public.hourly_abg_pivoted
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
public.hourly_supplemental_o2_pivoted
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
public.hourly_patient_vent_status_pivoted
USING(subject_id, hadm_id, stay_id, chart_hour);

DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.final_schema) THEN
        DROP TABLE public.cultures_hourly;
        DROP TABLE public.demographic_and_stay_data;
        DROP TABLE public.hourly_abg_flat;
        DROP TABLE public.hourly_abg_pivoted;
        DROP TABLE public.hourly_labs_flat;
        DROP TABLE public.hourly_labs_pivoted;
        DROP TABLE public.hourly_patient_vent_status_pivoted;
        DROP TABLE public.hourly_supplemental_o2_flat;
        DROP TABLE public.hourly_supplemental_o2_pivoted;
        DROP TABLE public.hourly_vitals_flat;
        DROP TABLE public.hourly_vitals_pivoted;
        DROP TABLE public.iv_antibiotics;
    END IF;
END
$do$;
