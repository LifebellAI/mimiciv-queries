-- This query takes the labs from the hourly_labs_flat table we create (from the hourly_labs_flat.sql file)
-- and pivots out the columns so that we get a wide (pivoted) version of that table
-- in doing so, we also have to account for the case where multiple labs of the same type are available in the same hour
-- when this is the case, this query will take the AVERAGE of those
CREATE OR REPLACE TABLE `physionet.hourly_labs_pivoted` as

SELECT
subject_id,
hadm_id,
stay_id,
charttime,
AVG(if (label= 'Bicarbonate', value, null)) as bicarbonate,
AVG(if (label= 'Chloride', value, null)) as chloride,
AVG(if (label= 'Bilirubin, Indirect', value, null)) as bilirubin_indirect,
AVG(if (label= 'Bilirubin, Direct', value, null)) as bilirubin_direct,
AVG(if (label= 'Bilirubin, Total', value, null)) as bilirubin_total,
AVG(if (label= 'Calcium', value, null)) as calcium,
AVG(if (label= 'Creatinine', value, null)) as creatinine,
AVG(if (label= 'Glucose', value, null)) as glucose,
AVG(if (label= 'Lactate', value, null)) as lactate,
AVG(if (label= 'Magnesium', value, null)) as magnesium,
AVG(if (label= 'Phosphate', value, null)) as phosphate,
AVG(if (label= 'Potassium', value, null)) as potassium,
AVG(if (label= 'Troponin I', value, null)) as troponin_i,
AVG(if (label= 'Hematocrit', value, null)) as hematocrit,
AVG(if (label= 'Hemoglobin', value, null)) as hemoglobin,
AVG(if (label= 'PTT', value, null)) as ptt,
AVG(if (label= 'WBC Count', value, null)) as wbc,
AVG(if (label= 'Fibrinogen', value, null)) as fibrinogen,
AVG(if (label= 'Platelet Count', value, null)) as platelets

FROM `elevated-pod-307118.physionet.hourly_labs_flat`
GROUP BY 
subject_id,
hadm_id,
stay_id,
charttime
