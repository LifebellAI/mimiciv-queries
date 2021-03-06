CREATE OR REPLACE TABLE `physionet.hourly_vitals_pivoted` AS

SELECT
subject_id,
hadm_id,
stay_id,
chart_hour,
AVG(if (label IN ('RR per min', 'Respiratory Rate','Respiratory Rate (Total)'), value, null)) AS resp_rate,
AVG(if (label IN ('HR per min','Heart Rate'), value, null)) AS heart_rate,
        -- To do: need to check if Skin Temperature is provided in Farenheit!
        -- And also, if "Temperature Celsius" should be used to fill this field when Farenheit not available?
AVG(if (label IN ('Temperature Fahrenheit', 'Skin Temperature'), value, null)) AS temperature,
AVG(if (label IN ('Arterial Blood Pressure systolic','Non Invasive Blood Pressure systolic'), value, null)) AS systolic_bp,
AVG(if (label IN ('Arterial Blood Pressure diasystolic','Non Invasive Blood Pressure diasystolic'), value, null)) AS diasystolic_bp,
AVG(if (label IN ('Arterial Blood Pressure mean', 'Non Invasive Blood Pressure mean'), value, null)) AS mean_arterial_bp,
AVG(if (label IN ('EtCO2'), value, null)) AS etco2,
AVG(if (label IN ('O2 saturation pulseoxymetry'), value, null)) AS spo2,
FROM `elevated-pod-307118.physionet.hourly_vitals_flat`
GROUP BY subject_id, hadm_id, stay_id, chart_hour
