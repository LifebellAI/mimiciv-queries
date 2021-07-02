-- This query takes the labs from the hourly_labs_flat table we create (from the hourly_labs_flat.sql file)
-- and pivots out the columns so that we get a wide (pivoted) version of that table
-- in doing so, we also have to account for the case where multiple labs of the same type are available in the same hour
-- when this is the case, this query will take the AVERAGE of those


DROP TABLE IF EXISTS public.hourly_labs_pivoted;

CREATE TABLE public.hourly_labs_pivoted as

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(CASE WHEN label in ('Bicarbonate')THEN value END) as bicarbonate,
AVG(CASE WHEN label in ('Chloride')THEN value END) as chloride,
AVG(CASE WHEN label in ('Bilirubin, Indirect')THEN value END) as bilirubin_indirect,
AVG(CASE WHEN label in ('Bilirubin, Direct')THEN value END) as bilirubin_direct,
AVG(CASE WHEN label in ('Bilirubin, Total')THEN value END) as bilirubin_total,
AVG(CASE WHEN label in ('Calcium')THEN value END) as calcium,
AVG(CASE WHEN label in ('Creatinine')THEN value END) as creatinine,
AVG(CASE WHEN label in ('Glucose')THEN value END) as glucose,
AVG(CASE WHEN label in ('Lactate')THEN value END) as lactate,
AVG(CASE WHEN label in ('Magnesium')THEN value END) as magnesium,
AVG(CASE WHEN label in ('Phosphate')THEN value END) as phosphate,
AVG(CASE WHEN label in ('Potassium')THEN value END) as potassium,
AVG(CASE WHEN label in ('Troponin I')THEN value END) as troponin_i,
AVG(CASE WHEN label in ('Hematocrit')THEN value END) as hematocrit,
AVG(CASE WHEN label in ('Hemoglobin')THEN value END) as hemoglobin,
AVG(CASE WHEN label in ('PTT')THEN value END) as ptt,
AVG(CASE WHEN label in ('WBC Count')THEN value END) as wbc,
AVG(CASE WHEN label in ('Fibrinogen')THEN value END) as fibrinogen,
AVG(CASE WHEN label in ('Platelet Count')THEN value END) as platelets

FROM hourly_labs_flat
GROUP BY 
subject_id,
hadm_id,
stay_id,
chart_hour
