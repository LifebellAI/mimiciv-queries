SELECT
subject_id AS id,
ROW_NUMBER() OVER (PARTITION BY subject_id, hadm_id, stay_id ORDER BY chart_hour ASC) AS ICULOS,
admittime AS HospAdmTime,
0 AS Unit1,
1 AS Unit2,
age AS Age,
gender AS Gender,
platelets AS Platelets,
WBC,
ptt AS PTT,
hemoglobin AS Hgb,
hematocrit AS Hct,
troponin_I AS TroponinI,
bilirubin_total AS Bilirubin_total,
potassium AS Potassium,
phosphate AS Phosphate,
magnesium AS Magnesium,
lactate AS Lactate,
glucose AS Glucose,
bilirubin_direct AS Bilirubin_direct,
creatinine AS Creatinine,
chloride AS Chloride,
calcium AS Calcium,
0 AS Alkalinephos,
0 AS BUN,
0 AS AST,
PaCO2,
SaO2,
PaO2,
pH,
FiO2,
bicarbonate AS HCO3,
base_excess AS BaseExcess,
EtCO2 AS EtCO2,
resp_rate AS Resp,
diastolic_bp AS DBP,
mean_arterial_bp AS MAP,
systolic_bp AS SBP,
temperature AS Temp,
spo2 AS O2Sat,
heart_rate AS HR,
ventilated AS vent_status,
blood_cx AS blood_cx_order,
urine_cx AS urine_cx_order,
sputum_cx AS sputum_cx_order,
antibiotics_amount AS iv_abx_dose,
abx_orders AS iv_abx_ordered,
dopamine,
dobutamine,
epinephrine,
norepinephrine
FROM `elevated-pod-307118.physionet.final_schema`
WHERE total_los>8