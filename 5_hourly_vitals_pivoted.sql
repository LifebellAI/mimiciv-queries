CREATE OR REPLACE TABLE `physionet.hourly_vitals_pivoted` as

SELECT 
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(if (label in ('RR per min', 'Respiratory Rate','Respiratory Rate (Total)'), value, null)) as resp_rate,
AVG(if (label in ('HR per min','Heart Rate'), value, null)) as heart_rate,
        -- To do: need to check if Skin Temperature is provided in Farenheit!
        -- And also, if "Temperature Celsius" should be used to fill this field when Farenheit not available?
AVG(if (label in ('Temperature Fahrenheit', 'Skin Temperature'), value, null)) as temperature,
AVG(if (label in ('Arterial Blood Pressure systolic','Non Invasive Blood Pressure systolic'), value, null)) as systolic_bp,
AVG(if (label in ('Arterial Blood Pressure diasystolic','Non Invasive Blood Pressure diasystolic'), value, null)) as diasystolic_bp,
AVG(if (label in ('Arterial Blood Pressure mean', 'Non Invasive Blood Pressure mean'), value, null)) as mean_arterial_bp,
AVG(if (label in ('EtCO2'), value, null)) as etco2,
AVG(if (label in ('O2 saturation pulseoxymetry'), value, null)) as spo2,
FROM `elevated-pod-307118.physionet.hourly_vitals_flat`
GROUP BY subject_id, hadm_id, stay_id, chart_hour
