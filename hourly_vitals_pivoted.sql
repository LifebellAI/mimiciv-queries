SELECT 
subject_id,
hadm_id,
stay_id,
charttime,
AVG(if (label in ('RR per min', 'Respiratory Rate','Respiratory Rate (Total)'), value, null)) as resp_rate,
AVG(if (label in ('HR per min','Heart Rate'), value, null)) as heart_rate,
AVG(if (label in ('Temperature Fahrenheit','Temperature Celsius','Skin Temperature'), value, null)) as temperature,
AVG(if (label in ('Arterial Blood Pressure systolic','Non Invasive Blood Pressure systolic'), value, null)) as systolic_bp,
AVG(if (label in ('Arterial Blood Pressure diasystolic','Non Invasive Blood Pressure diasystolic'), value, null)) as diasystolic_bp,
AVG(if (label in ('Arterial Blood Pressure mean'), value, null)) as mean_arterial_bp,
AVG(if (label in ('EtCO2'), value, null)) as etco2,
FROM `elevated-pod-307118.physionet.hourly_vitals_flat`
GROUP BY subject_id, hadm_id, stay_id, charttime
