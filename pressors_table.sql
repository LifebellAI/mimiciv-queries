CREATE OR REPLACE TABLE `physionet.pressors` as

select
subject_id, 
hadm_id,
stay_id,
DATETIME_TRUNC(`physionet-data.mimic_hosp.prescriptions`.starttime, HOUR) as chart_hour,
`physionet-data.mimic_hosp.prescriptions`.starttime, 
`physionet-data.mimic_hosp.prescriptions`.stoptime, 
drug, 
medication, 
prod_strength, 
dose_val_rx, 
dose_unit_rx, 
duration, 
duration_interval
from `physionet-data.mimic_hosp.prescriptions`
join `physionet-data.mimic_hosp.pharmacy`
using(subject_id, hadm_id, pharmacy_id)
join `physionet-data.mimic_icu.icustays`
using (subject_id, hadm_id)
where 
(
    lower(drug) like '%epinephrine%'
     or lower(drug) like '%dopamine%'
     or lower(drug) like '%dobutamine%'
)
and
lower(`physionet-data.mimic_hosp.prescriptions`.route) in ('iv', 'iv drip');