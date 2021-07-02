
DROP TABLE IF EXISTS public.hourly_vitals_pivoted;

CREATE TABLE public.hourly_vitals_pivoted as

SELECT 
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(CASE WHEN label in ('RR per min', 'Respiratory Rate','Respiratory Rate (Total)')THEN value END) as resp_rate,
AVG(CASE WHEN label in ('HR per min','Heart Rate')THEN value END) as heart_rate,
        -- To do: need to check if Skin Temperature is provided in Farenheit!
        -- And also, if "Temperature Celsius" should be used to fill this field when Farenheit not available?
AVG(CASE WHEN label in ('Temperature Fahrenheit', 'Skin Temperature')THEN value END) as temperature,
AVG(CASE WHEN label in ('Arterial Blood Pressure systolic','Non Invasive Blood Pressure systolic')THEN value END) as systolic_bp,
AVG(CASE WHEN label in ('Arterial Blood Pressure diasystolic','Non Invasive Blood Pressure diasystolic')THEN value END) as diasystolic_bp,
AVG(CASE WHEN label in ('Arterial Blood Pressure mean', 'Non Invasive Blood Pressure mean')THEN value END) as mean_arterial_bp,
AVG(CASE WHEN label in ('EtCO2')THEN value END) as etco2,
AVG(CASE WHEN label in ('O2 saturation pulseoxymetry')THEN value END) as spo2
FROM public.hourly_vitals_flat
GROUP BY subject_id, hadm_id, stay_id, chart_hour
