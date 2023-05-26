%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  NOTES                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

Insulin Goals:
1) Very Low BG : <54 mg/dL
2) Low BG :  54-72 mg/dL
3) Mid BG :  72-180 mg/dL
4) High BG :  180-250 mg/dL
5) Very High BG : >250 mg/dL

@src: https://dtc.ucsf.edu/types-of-diabetes/type2/treatment-of-type-2-diabetes/medications-and-therapies/type-2-insulin-rx/calculating-insulin-dose/
Carbohydrate Coverage Ratio (CCR):
1) CCR = 500 ÷ Total Daily Insulin Dose
2) Total Daily Insulin Dose = Insulin Resistance Coeficent(IRC) * Weight
3) IRC(norm) = 0.55 | IRC(lower) < 0.55 | IRC(higher) > 0.55
4) CCR = Average Daily Carbs Consumption / (IRC*Weight)
ex) CCR = 500/(0.55*80)

TOTAL BGL INCREASE FROM MEAL = (CHO / CCR) * 50;

GMI = 3.31 + 0.02392 x [mean glucose in mg/dL].

Sampe Standard Deviation = iykyk

To set custom carbs intake (optional):
@EX: test_data = cho_intake(
            dbname,
            [50 50 50 50 50],
            [40 240 440 640 840],
            "overwrite"
        );

To run for all databases
    for i = 1:size(fname,2)
        simulation(weight, fname(i), version, path(i), randomize)
    end

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               MAIN START                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup fig display off
set(0, 'DefaultFigureVisible', 'off')

% setup user
patient.ACC = 500; % Average Carbs Consumption (daily)
patient.IRC = 0.55; % Insulin Resistance Coefficent
patient.weight = 71;

% run sim
% version = 'showcase';
%simulation(patient, "norm", version, false);
%simulation(patient, "highBGL", version, false);
simulation(patient, "highCHO", version, false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                 MAIN END                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
