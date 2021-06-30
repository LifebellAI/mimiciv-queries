-- This query collects all of the rows recording iv antibiotics, from the larger table of all ICU inputevents
-- We include both rate and amount because data from one EMR comes with a calculated rate (ml/hr),
-- whereas data from the other EMR comes with only an amount and a total amount (rate presumably can be calculated from this)
CREATE OR REPLACE TABLE `physionet.iv_antibiotics_inputevents` AS

SELECT
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC(starttime, HOUR) AS chart_hour,
min(starttime) AS starttime,
min(endtime) AS endtime,
sum(amount) AS amount,
min(amountuom) AS amountuom,
sum(rate) AS rate,
min(rateuom) AS rateuom,
sum(totalamount) AS totalamount,
FROM `physionet-data.mimic_icu.inputevents`
WHERE ordercategoryname = "08-Antibiotics (IV)"
GROUP BY subject_id, hadm_id, stay_id, DATETIME_TRUNC(starttime, HOUR)
