
-- This schema is *SIMILAR* but not exactly the same as the PNC 2019 Challenge Schema
-- Changing this to the correct schema should be very simple
-- Please feel free to modify this yourself (add/rename/remove fields) to get it into the schema needed

DROP TABLE IF EXISTS public.final_schema;

CREATE  TABLE public.final_schema AS

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
anchor_age AS age,
-- Cultures fields
blood_cx,
urine_cx,
sputum_cx,
-- Antibiotics fields (input events)
amount AS antibiotics_amount,
rate AS antibiotics_rate,
-- antibiotics fields (pharmacy)
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
public.iv_antibiotics_inputevents
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
(
  SELECT subject_id, hadm_id, stay_id, chart_hour, count(1) AS abx_orders
  FROM public.iv_antibiotics_pharmacy
  GROUP BY subject_id, hadm_id, stay_id, chart_hour
) AS abx_pharmacy
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
USING(subject_id, hadm_id, stay_id, chart_hour)
FULL JOIN
(
  SELECT subject_id, hadm_id, stay_id, chart_hour,
  count(1) AS pressors_orders,
  SUM(CASE WHEN LOWER(drug) LIKE '%dobutamine%' THEN CAST(dose_val_rx AS numeric) ELSE NULL END) AS dobutamine_mcg,
  SUM(CASE WHEN LOWER(drug) LIKE '%dopamine%' THEN CAST(dose_val_rx AS numeric) ELSE NULL END) AS dopamine_mcg,
  SUM(CASE WHEN LOWER(drug) LIKE '%norepinephrine%' THEN CAST(dose_val_rx AS  numeric) ELSE NULL END) AS norepinephrine_mcg,
  SUM(CASE WHEN (LOWER(drug) LIKE '%epinephrine%') AND (LOWER(medication) NOT LIKE '%nor%') THEN  CAST(dose_val_rx AS numeric) ELSE NULL END) AS epinephrine_mcg
  FROM public.pressors
  GROUP BY subject_id, hadm_id, stay_id, chart_hour
) AS pressors
USING(subject_id, hadm_id, stay_id, chart_hour)
;

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
