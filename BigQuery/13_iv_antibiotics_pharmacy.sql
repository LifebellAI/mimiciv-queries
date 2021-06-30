CREATE OR REPLACE TABLE `physionet.iv_abx_pharmacy` AS

SELECT
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC(starttime, HOUR) AS chart_hour,
medication,
-- todo: instead of taking the arbitrary minimum, take the values from the latest entertime for a given stay_id/chart_hour/medication combination
min(entertime) AS entertime_min,
min(starttime) AS starttime_min,
min(route) AS route_min,
max(stoptime) AS stoptime_max,
min(frequency) AS frequency_min,
min(disp_sched) AS disp_sched_min,
min(doses_per_24_hrs) AS doses_per_24_hrs_min,
min(duration) AS duration_min,
min(duration_interval) AS duration_interval_min,
count(1) AS records
from `physionet-data.mimic_hosp.pharmacy`
JOIN `physionet-data.mimic_icu.icustays`
USING (subject_id, hadm_id)
where
(
    --medical abx names
    lower(medication) LIKE "%vancomycin%"
    OR lower(medication) LIKE "%ceftriaxone%"
    OR lower(medication) LIKE "%meropenem%"
    OR lower(medication) LIKE "%ceftazidime%"
    OR lower(medication) LIKE "%cefotaxime%"
    OR lower(medication) LIKE "%cefepime%"
    OR lower(medication) LIKE "%piperacillin%"
    OR lower(medication) LIKE "%tazobactam%"
    OR lower(medication) LIKE "%amipcillin%"
    OR lower(medication) LIKE "%sulbactam%"
    OR lower(medication) LIKE "%imipenem%"
    OR lower(medication) LIKE "%cilastatin%"
    OR lower(medication) LIKE "%levofloxacin%"
    OR lower(medication) LIKE "%clindamycin%"
    OR lower(medication) LIKE "%metronidazol%"
    OR lower(medication) LIKE "%linezolid%"
    OR lower(medication) LIKE "%ciprofloxacin%"
    OR lower(medication) LIKE "%nafcillin%"
    OR lower(medication) LIKE "%daptomycin%"
    OR lower(medication) LIKE "%amikacin%"
    OR lower(medication) LIKE "%tobramycin%"
    OR lower(medication) LIKE "%gentamicin"
    --brand names
    OR lower(medication) LIKE "%vancocin%"
    OR lower(medication) LIKE "%rocephin%"
    OR lower(medication) LIKE "%merrem%"
    OR lower(medication) LIKE "%fortaz%"
    OR lower(medication) LIKE "%claforan%"
    OR lower(medication) LIKE "%maxipime%"
    OR lower(medication) LIKE "%zosyn%"
    OR lower(medication) LIKE "%unasyn%"
    OR lower(medication) LIKE "%primaxin%"
    OR lower(medication) LIKE "%levaquin%"
    OR lower(medication) LIKE "%cleocin%"
    OR lower(medication) LIKE "%flagyl%"
    OR lower(medication) LIKE "%zyvox%"
    OR lower(medication) LIKE "%cetraxal%"
    OR lower(medication) LIKE "%cipro%"
    OR lower(medication) LIKE "%otiprio%"
    OR lower(medication) LIKE "%ciloxan%"
    OR lower(medication) LIKE "%cubicin%"
    OR lower(medication) LIKE "%tobi podhaler%"
    OR lower(medication) LIKE "%bethkis%"
    OR lower(medication) LIKE "%tobrex%"
    OR lower(medication) LIKE "%gentak%"
)
AND route IN (
    'IV' --this captures by far the largest portion of abx orders, followed with a few from IVIC and IVT. The others are here for posterity
    ,'IVCI'
    ,'IVIC'
    ,'IVS'
    ,'IVT')
AND
lower(medication) NOT LIKE "%desensitization%" --ignore desensitization protocols in preparation for abx
AND
DATETIME_TRUNC(starttime, HOUR) < outtime
AND
DATETIME_TRUNC(starttime, HOUR) > intime
GROUP BY subject_id, hadm_id, stay_id, chart_hour, medication
