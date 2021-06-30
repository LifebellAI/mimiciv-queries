-- This query takes the labs from the hourly_labs_flat table we create (from the hourly_labs_flat.sql file)
-- and pivots out the columns so that we get a wide (pivoted) version of that table
-- in doing so, we also have to account for the case where multiple labs of the same type are available in the same hour
-- when this is the case, this query will take the AVERAGE of those

DO
$do$
BEGIN
   IF  EXISTS (SELECT FROM public.hourly_labs_pivoted) THEN
        DROP TABLE public.hourly_labs_pivoted;
    END IF;
END
$do$;

CREATE TABLE public.hourly_labs_pivoted AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(CASE WHEN label IN ('Bicarbonate') THEN value END) AS bicarbonate,
AVG(CASE WHEN label IN ('Chloride') THEN value END) AS chloride,
AVG(CASE WHEN label IN ('Bilirubin, Indirect') THEN value END) AS bilirubin_indirect,
AVG(CASE WHEN label IN ('Bilirubin, Direct') THEN value END) AS bilirubin_direct,
AVG(CASE WHEN label IN ('Bilirubin, Total') THEN value END) AS bilirubin_total,
AVG(CASE WHEN label IN ('Calcium') THEN value END) AS calcium,
AVG(CASE WHEN label IN ('Creatinine') THEN value END) AS creatinine,
AVG(CASE WHEN label IN ('Glucose') THEN value END) AS glucose,
AVG(CASE WHEN label IN ('Lactate') THEN value END) AS lactate,
AVG(CASE WHEN label IN ('Magnesium') THEN value END) AS magnesium,
AVG(CASE WHEN label IN ('Phosphate') THEN value END) AS phosphate,
AVG(CASE WHEN label IN ('Potassium') THEN value END) AS potassium,
AVG(CASE WHEN label IN ('Troponin I') THEN value END) AS troponin_i,
AVG(CASE WHEN label IN ('Hematocrit') THEN value END) AS hematocrit,
AVG(CASE WHEN label IN ('Hemoglobin') THEN value END) AS hemoglobin,
AVG(CASE WHEN label IN ('PTT') THEN value END) AS ptt,
AVG(CASE WHEN label IN ('WBC Count') THEN value END) AS wbc,
AVG(CASE WHEN label IN ('Fibrinogen') THEN value END) AS fibrinogen,
AVG(CASE WHEN label IN ('Platelet Count') THEN value END) AS platelets

FROM hourly_labs_flat
GROUP BY
subject_id,
hadm_id,
stay_id,
chart_hour
