DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.pressors) THEN
        DROP TABLE public.pressors;
    END IF;
END
$do$;

CREATE TABLE public.pressors AS

SELECT
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC('hour', mimic_hosp.prescriptions.starttime) AS chart_hour,
mimic_hosp.prescriptions.starttime,
mimic_hosp.prescriptions.stoptime,
drug,
medication,
prod_strength,
CASE WHEN dose_unit_rx='mg' THEN cast(dose_val_rx AS numeric)*1000 ELSE cast(dose_val_rx AS numeric) END AS dose_val_rx, --labeler expects pressors in mcg/kg/min
'mcg' AS dose_unit_rx,
duration,
duration_interval
-- note: whenever joining between prescriptions and pharmacy, make sure your medication/drug field filters are applied to the drug field, which is a lower grain
-- since pharmacy orders can comprise of multiple prescriptions, you may end up with multiple records in the final table
-- with each record representing one of potentially multiple drugs being used to fulfill a pharmacy order (which will invalidate dosage aggregations)
FROM mimic_hosp.prescriptions
JOIN mimic_hosp.pharmacy
USING (subject_id, hadm_id, pharmacy_id)
JOIN mimic_icu.icustays
USING (subject_id, hadm_id)
WHERE
(
    lower(mimic_hosp.prescriptions.drug) LIKE '%epinephrine%'
     OR lower(mimic_hosp.prescriptions.drug) LIKE '%dopamine%'
     OR lower(mimic_hosp.prescriptions.drug) LIKE '%dobutamine%'
)
AND
-- the below filters remove a very small % of records that are problematic
lower(mimic_hosp.prescriptions.route) IN ('iv', 'iv drip')
AND
dose_val_rx NOT LIKE "%-%" --todo: determine how to transform these (take highest number from range?)
AND
dose_unit_rx IN ('mg', 'mcg');
