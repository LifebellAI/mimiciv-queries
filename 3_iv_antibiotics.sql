-- This query collects all of the rows recording iv antibiotics, from the larger table of all ICU inputevents
-- We include both rate and amount because data from one EMR comes with a calculated rate (ml/hr), 
-- whereas data from the other EMR comes with only an amount and a total amount (rate presumably can be calculated from this)
CREATE OR REPLACE TABLE `physionet.iv_antibiotics` as

SELECT
subject_id,
hadm_id,
stay_id,
starttime,
amount,
amountuom,
rate,
rateuom,
totalamount,
ordercategoryname,
FROM `physionet-data.mimic_icu.inputevents` 
WHERE ordercategoryname = "08-Antibiotics (IV)"
order by starttime
