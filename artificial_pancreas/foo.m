patient.ID = '1a2c';
patient.FirstName = 'John';
patient.LastName = 'Doe';
patient.TimeStamp = datetime('now', 'Format', 'dd/MM/yyyy');
patient.BGL = 124; % blood glucose level
patient.BGR = 1.3; % blood glucose rate
patient.AVG = 132; % average blood glucose level
patient.SD = 14.33; % standard deviation 
patient.GMI = 7.14; % glucose management indicator
patient.TIR.high = 22; % time in range above norm
patient.TIR.inRange = 65; % time in range witihin norm
patient.TIR.low = 13; % time in range below norm

patient_chn = 'http://localhost:8080/patient';

webwrite(patient_chn, patient);

% GMI = 3.31 + 0.02392 x [mean glucose in mg/dL].
% Sampe Standard Deviation = iykyk