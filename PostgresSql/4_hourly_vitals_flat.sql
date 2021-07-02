
DROP TABLE IF EXISTS public.cultures_hourly;

CREATE TABLE public.hourly_vitals_flat as

SELECT 
subject_id,
hadm_id,
stay_id,
DATE_TRUNC('hour',charttime) as chart_hour,
valuenum as value,
valueuom as units,
label
FROM mimic_icu.chartevents
JOIN mimic_icu.d_items
USING(itemid)
WHERE label in
('RR per min', -- Respiratory rate per min
'Respiratory Rate', -- Also a respiratory rate
'Respiratory Rate (Total)', -- for ventilated patients
'HR per min', -- Heart Rate per min measurement, not available for all patients
'Heart Rate', -- This seems to be a Heart Rate measurement as well, but maybe taken from a different source than the HR per min above
'Temperature Fahrenheit',
'Temperature Celsius',
'Skin Temperature', -- unclear why this is different from the above
'Arterial Blood Pressure systolic',  -- invasive - being measured from the arterial line
'Arterial Blood Pressure diastolic', -- invasive- being measured from the arterial line
'Arterial Blood Pressure mean', -- invasive- being measured from the arterial line
'Non Invasive Blood Pressure systolic', -- non-invasive meaning from a cuff
'Non Invasive Blood Pressure diastolic', 
'Non Invasive Blood Pressure mean',
'EtCO2',
'O2 saturation pulseoxymetry' -- AKA SpO2, measured from peripheral (e.g. forehead or fingertip) oxymetry
)
