-- This query collects all of the rows recording iv antibiotics, from the larger table of all ICU inputevents
-- We include both rate and amount because data from one EMR comes with a calculated rate (ml/hr), 
-- whereas data from the other EMR comes with only an amount and a total amount (rate presumably can be calculated from this)
CREATE OR REPLACE TABLE `physionet.iv_antibiotics_inputevents` as

SELECT
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC(starttime, HOUR) as chart_hour,
min(starttime) as starttime,
min(endtime) as endtime,
sum(amount) as amount,
min(amountuom) as amountuom,
sum(rate) as rate,
min(rateuom) as rateuom,
sum(totalamount) as totalamount,
FROM `physionet-data.mimic_icu.inputevents` 
WHERE ordercategoryname = "08-Antibiotics (IV)"
GROUP BY DATETIME_TRUNC(starttime, HOUR), subject_id, hadm_id, stay_id
