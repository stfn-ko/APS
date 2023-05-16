function json_handler(data)
    patient.TimeStamp.initial = data.TimeStamp.initial;
    patient.TimeStamp.current = data.TimeStamp.current;
    
    patient.BGL = data.BGL; % blood glucose level
    patient.BGR = data.BGR; % blood glucose rate
    patient.AVG = data.AVG; % average blood glucose level
    patient.SD = data.SD; % standard deviation 
    patient.GMI = data.GMI; % glucose management indicator
    patient.TIR.high = data.TIR.high; % time in range above norm
    patient.TIR.inRange = data.TIR.inRange; % time in range witihin norm
    patient.TIR.low = data.TIR.low; % time in range below norm

    patient_chn = 'http://localhost:8080/patient';

    webwrite(patient_chn, patient);
end