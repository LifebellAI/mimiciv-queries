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
if(dose_unit_rx='mg', cast(dose_val_rx as numeric)*1000, cast(dose_val_rx as numeric)) as dose_val_rx, --labeler expects pressors in mcg/kg/min
'mcg' as dose_unit_rx, 
duration, 
duration_interval
-- note: whenever joining between prescriptions and pharmacy, make sure your medication field / drug field filters are applied to the drug field
-- since pharmacy orders can comprise of multiple prescriptions, you may end up with multiple records in the final table 
-- with each record representing one of potentially multiple drugs being used to fulfill a pharmacy order (which will invalidate dosage aggregations)
from `physionet-data.mimic_hosp.prescriptions`
join `physionet-data.mimic_hosp.pharmacy`
using(subject_id, hadm_id, pharmacy_id)
join `physionet-data.mimic_icu.icustays`
using (subject_id, hadm_id)
where 
(
    lower(`physionet-data.mimic_hosp.prescriptions`.drug) like '%epinephrine%'
     or lower(`physionet-data.mimic_hosp.prescriptions`.drug) like '%dopamine%'
     or lower(`physionet-data.mimic_hosp.prescriptions`.drug) like '%dobutamine%'
)
and
-- the below filters remove a very small % of records that are problematic
lower(`physionet-data.mimic_hosp.prescriptions`.route) in ('iv', 'iv drip')
and
dose_val_rx not like "%-%" --todo: determine how to transform these (take highest number from range?)
and
dose_unit_rx in ('mg', 'mcg');
