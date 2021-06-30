-- This query takes the labs from the hourly_labs_flat table we create (from the hourly_labs_flat.sql file)
-- and pivots out the columns so that we get a wide (pivoted) version of that table
-- in doing so, we also have to account for the case where multiple labs of the same type are available in the same hour
-- when this is the case, this query will take the AVERAGE of those
CREATE OR REPLACE TABLE `physionet.hourly_labs_pivoted` AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(if (label= 'Bicarbonate', value, null)) AS bicarbonate,
AVG(if (label= 'Chloride', value, null)) AS chloride,
AVG(if (label= 'Bilirubin, Indirect', value, null)) AS bilirubin_indirect,
AVG(if (label= 'Bilirubin, Direct', value, null)) AS bilirubin_direct,
AVG(if (label= 'Bilirubin, Total', value, null)) AS bilirubin_total,
AVG(if (label= 'Calcium', value, null)) AS calcium,
AVG(if (label= 'Creatinine', value, null)) AS creatinine,
AVG(if (label= 'Glucose', value, null)) AS glucose,
AVG(if (label= 'Lactate', value, null)) AS lactate,
AVG(if (label= 'Magnesium', value, null)) AS magnesium,
AVG(if (label= 'Phosphate', value, null)) AS phosphate,
AVG(if (label= 'Potassium', value, null)) AS potassium,
AVG(if (label= 'Troponin I', value, null)) AS troponin_i,
AVG(if (label= 'Hematocrit', value, null)) AS hematocrit,
AVG(if (label= 'Hemoglobin', value, null)) AS hemoglobin,
AVG(if (label= 'PTT', value, null)) AS ptt,
AVG(if (label= 'WBC Count', value, null)) AS wbc,
AVG(if (label= 'Fibrinogen', value, null)) AS fibrinogen,
AVG(if (label= 'Platelet Count', value, null)) AS platelets
FROM `elevated-pod-307118.physionet.hourly_labs_flat`
GROUP BY
subject_id,
hadm_id,
stay_id,
chart_hour
