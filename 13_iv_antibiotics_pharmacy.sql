CREATE OR REPLACE TABLE `physionet.iv_abx_pharmacy` as

select 
subject_id,
hadm_id,
stay_id,
DATETIME_TRUNC(starttime, HOUR) as chart_hour,
intime,
outtime,
medication,
-- todo: instead of taking the arbitrary minimum, take the values from the latest entertime for a given stay_id/chart_hour/medication combination 
min(entertime) as entertime,
min(starttime) as starttime,
min(route) as route,
max(stoptime) as stoptime,
min(frequency) as frequency,
min(disp_sched) as disp_sched,
min(doses_per_24_hrs) as doses_per_24_hrs,
min(duration) as duration,
min(duration_interval) as duration_interval,
count(1) as records
from `physionet-data.mimic_hosp.pharmacy`
JOIN `physionet-data.mimic_icu.icustays`
USING (subject_id, hadm_id)
where
(
    --medical abx names
    lower(medication) like "%vancomycin%"
    or lower(medication) like "%ceftriaxone%"
    or lower(medication) like "%meropenem%"
    or lower(medication) like "%ceftazidime%"
    or lower(medication) like "%cefotaxime%"
    or lower(medication) like "%cefepime%"
    or lower(medication) like "%piperacillin%"
    or lower(medication) like "%tazobactam%"
    or lower(medication) like "%amipcillin%"
    or lower(medication) like "%sulbactam%"
    or lower(medication) like "%imipenem%"
    or lower(medication) like "%cilastatin%"
    or lower(medication) like "%levofloxacin%"
    or lower(medication) like "%clindamycin%"
    or lower(medication) like "%metronidazol%"
    or lower(medication) like "%linezolid%"
    or lower(medication) like "%ciprofloxacin%"
    or lower(medication) like "%nafcillin%"
    or lower(medication) like "%daptomycin%"
    or lower(medication) like "%amikacin%"
    or lower(medication) like "%tobramycin%"
    or lower(medication) like "%gentamicin"
    --brand names
    or lower(medication) like "%vancocin%"
    or lower(medication) like "%rocephin%"
    or lower(medication) like "%merrem%"
    or lower(medication) like "%fortaz%"
    or lower(medication) like "%claforan%"
    or lower(medication) like "%maxipime%"
    or lower(medication) like "%zosyn%"
    or lower(medication) like "%unasyn%"
    or lower(medication) like "%primaxin%"
    or lower(medication) like "%levaquin%"
    or lower(medication) like "%cleocin%"
    or lower(medication) like "%flagyl%"
    or lower(medication) like "%zyvox%"
    or lower(medication) like "%cetraxal%"
    or lower(medication) like "%cipro%"
    or lower(medication) like "%otiprio%"
    or lower(medication) like "%ciloxan%"
    or lower(medication) like "%cubicin%"
    or lower(medication) like "%tobi podhaler%"
    or lower(medication) like "%bethkis%"
    or lower(medication) like "%tobrex%"
    or lower(medication) like "%gentak%"
)
and route in (
    'IV' --this captures by far the largest portion of abx orders, followed with a few from IVIC and IVT. The others are here for posterity
    ,'IVCI'
    ,'IVIC'
    ,'IVS'
    ,'IVT')
AND
lower(medication) not like "%desensitization%" --ignore desensitization protocols in preparation for abx
AND
DATETIME_TRUNC(starttime, HOUR) < outtime 
AND
DATETIME_TRUNC(starttime, HOUR) > intime
GROUP BY subject_id, hadm_id, stay_id, intime, outtime, chart_hour, medication