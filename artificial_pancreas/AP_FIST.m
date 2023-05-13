%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                 AP_FIST                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FIST, CCR, MDI, BGR_R, BGA_R] = AP_FIST(weight_)

    % MAX INSULIN PER DAY
    MIPD = weight_ * 0.55;

    % CHO COVERAGE RATIO
    CCR = 500 / MIPD;

    % INSULIN DOSE RANGE
    MDI = [0 1.5];

    % BLOOD GLUCOSE RATE RANGE
    BGR_R = [-2 2]; % mg/dL/min

    % BLOOD GLUCOSE ACCELERATION RANGE
    BGA_R = [-0.7 0.7]; % mg/dL/min^2


    % MEMBERSHIP FUNCTIONS
    mf5_nzp = ["Neg", "SNeg", "Zero", "SPos", "Pos"];
    mf5_lmh = ["V_Low", "Low", "Mid", "High", "V_High"];


    % FISs INIT
    % - precalculated dose
    fPrecalcDose = mamfis( 'Name', 'fPrecalcDose', 'NumInputMFs', 5, ...
        'NumOutputMFs', 5, 'NumInputs', 2, 'NumOutputs', 1);

    % - insulin dose
    fInsulinDose = mamfis( 'Name', 'fInsulinDose', 'NumInputMFs', 5, ...
        'NumOutputMFs', 5, 'NumInputs', 2, 'NumOutputs', 1);


    % EDIT BG_LV NAME AND RANGE
    fPrecalcDose.Inputs(1).Name = "BG_LVL";
    fPrecalcDose.Inputs(1).Range = [0 400];


    % EDIT BG_LV MF'S
    fPrecalcDose.Inputs(1).MembershipFunctions(1).Name = mf5_lmh(1);
    fPrecalcDose.Inputs(1).MembershipFunctions(1).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(1).Parameters = [50 0];
    %
    fPrecalcDose.Inputs(1).MembershipFunctions(2).Name = mf5_lmh(2);
    fPrecalcDose.Inputs(1).MembershipFunctions(2).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(2).Parameters = [15 70];
    %
    fPrecalcDose.Inputs(1).MembershipFunctions(3).Name = mf5_lmh(3);
    fPrecalcDose.Inputs(1).MembershipFunctions(3).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(3).Parameters = [20 120]; 
    %
    fPrecalcDose.Inputs(1).MembershipFunctions(4).Name = mf5_lmh(4);
    fPrecalcDose.Inputs(1).MembershipFunctions(4).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(4).Parameters = [80 240];
    %
    fPrecalcDose.Inputs(1).MembershipFunctions(5).Name = mf5_lmh(5);
    fPrecalcDose.Inputs(1).MembershipFunctions(5).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(5).Parameters = [70 400];


    % UPDATE BG_RATE & PRECALC_DOSE
    fPrecalcDose = update_io(fPrecalcDose, "Input", 2, "BG_RATE", BGR_R, mf5_nzp);
    fPrecalcDose = update_io(fPrecalcDose, "Output", 1, "PRECLAC_DOSE", MDI, mf5_lmh);


    % EDIT PRECALC_DOSE RULEBASE
        fPrecalcDose.Rules(1).Description = "BG_LVL==V_Low & BG_RATE==Neg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(6).Description = "BG_LVL==V_Low & BG_RATE==SNeg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(16).Description = "BG_LVL==V_Low & BG_RATE==SPos => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(11).Description = "BG_LVL==V_Low & BG_RATE==Zero => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(21).Description = "BG_LVL==V_Low & BG_RATE==Pos => PRECLAC_DOSE=V_Low (1)";
    %
    fPrecalcDose.Rules(2).Description = "BG_LVL==Low & BG_RATE==Neg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(7).Description = "BG_LVL==Low & BG_RATE==SNeg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(12).Description = "BG_LVL==Low & BG_RATE==Zero => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(17).Description = "BG_LVL==Low & BG_RATE==SPos => PRECLAC_DOSE=Low (1)";
    fPrecalcDose.Rules(22).Description = "BG_LVL==Low & BG_RATE==Pos => PRECLAC_DOSE=Low (1)";
    %
    fPrecalcDose.Rules(3).Description = "BG_LVL==Mid & BG_RATE==Neg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(8).Description = "BG_LVL==Mid & BG_RATE==SNeg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(13).Description = "BG_LVL==Mid & BG_RATE==Zero => PRECLAC_DOSE=Low (1)";
    fPrecalcDose.Rules(18).Description = "BG_LVL==Mid & BG_RATE==SPos => PRECLAC_DOSE=Mid (0.7)";
    fPrecalcDose.Rules(23).Description = "BG_LVL==Mid & BG_RATE==Pos => PRECLAC_DOSE=Mid (0.7)";
    %
    fPrecalcDose.Rules(4).Description = "BG_LVL==High & BG_RATE==Neg => PRECLAC_DOSE=Low (1)";
    fPrecalcDose.Rules(9).Description = "BG_LVL==High & BG_RATE==SNeg => PRECLAC_DOSE=Low (1)";
    fPrecalcDose.Rules(14).Description = "BG_LVL==High & BG_RATE==Zero => PRECLAC_DOSE=Mid (0.7)";
    fPrecalcDose.Rules(19).Description = "BG_LVL==High & BG_RATE==SPos => PRECLAC_DOSE=High (0.6)"; 
    fPrecalcDose.Rules(24).Description = "BG_LVL==High & BG_RATE==Pos => PRECLAC_DOSE=High (0.6)";
    %
    fPrecalcDose.Rules(5).Description = "BG_LVL==V_High & BG_RATE==Neg => PRECLAC_DOSE=V_Low (1)";
    fPrecalcDose.Rules(10).Description = "BG_LVL==V_High & BG_RATE==SNeg => PRECLAC_DOSE=Low (1)";
    fPrecalcDose.Rules(15).Description = "BG_LVL==V_High & BG_RATE==Zero => PRECLAC_DOSE=Mid (1)";
    fPrecalcDose.Rules(20).Description = "BG_LVL==V_High & BG_RATE==SPos => PRECLAC_DOSE=High (1)";
    fPrecalcDose.Rules(25).Description = "BG_LVL==V_High & BG_RATE==Pos => PRECLAC_DOSE=V_High (1)";


    % EDIT VALUES FOR INSULIN DOSE
    fInsulinDose = update_io(fInsulinDose, "Input", 1, "PRECALC_DOSE", MDI, mf5_lmh);
    fInsulinDose = update_io(fInsulinDose, "Input", 2, "BG_ACCEL", BGA_R, mf5_nzp);
    fInsulinDose = update_io(fInsulinDose, "Output", 1, "INSULIN_DOSE", MDI, mf5_lmh);


    % EDIT INSULIN_DOSE RULEBASE
    fInsulinDose.Rules(1).Description = "PRECALC_DOSE==V_Low & BG_ACCEL==Neg => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(6).Description = "PRECALC_DOSE==V_Low & BG_ACCEL==SNeg => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(11).Description = "PRECALC_DOSE==V_Low & BG_ACCEL==Zero => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(16).Description = "PRECALC_DOSE==V_Low & BG_ACCEL==SPos => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(21).Description = "PRECALC_DOSE==V_Low & BG_ACCEL==Pos => INSULIN_DOSE=V_Low (1)";
    %
    fInsulinDose.Rules(2).Description = "PRECALC_DOSE==Low & BG_ACCEL==Neg => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(7).Description = "PRECALC_DOSE==Low & BG_ACCEL==SNeg => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(12).Description = "PRECALC_DOSE==Low & BG_ACCEL==Zero => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(17).Description = "PRECALC_DOSE==Low & BG_ACCEL==SPos => INSULIN_DOSE=Low (0.7)";
    fInsulinDose.Rules(22).Description = "PRECALC_DOSE==Low & BG_ACCEL==Pos => INSULIN_DOSE=Low (0.7)";
    %
    fInsulinDose.Rules(3).Description = "PRECALC_DOSE==Mid & BG_ACCEL==Neg => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(8).Description = "PRECALC_DOSE==Mid & BG_ACCEL==SNeg => INSULIN_DOSE=V_Low (1)";
    fInsulinDose.Rules(13).Description = "PRECALC_DOSE==Mid & BG_ACCEL==Zero => INSULIN_DOSE=Low (0.7)";
    fInsulinDose.Rules(18).Description = "PRECALC_DOSE==Mid & BG_ACCEL==SPos => INSULIN_DOSE=Low (0.7)";
    fInsulinDose.Rules(23).Description = "PRECALC_DOSE==Mid & BG_ACCEL==Pos => INSULIN_DOSE=Mid (0.6)";
    %
    fInsulinDose.Rules(4).Description = "PRECALC_DOSE==High & BG_ACCEL==Neg => INSULIN_DOSE=Low (0.7)";
    fInsulinDose.Rules(9).Description = "PRECALC_DOSE==High & BG_ACCEL==SNeg => INSULIN_DOSE=Low (0.7)";
    fInsulinDose.Rules(14).Description = "PRECALC_DOSE==High & BG_ACCEL==Zero => INSULIN_DOSE=Mid (0.8)";
    fInsulinDose.Rules(19).Description = "PRECALC_DOSE==High & BG_ACCEL==SPos => INSULIN_DOSE=Mid (0.8)";
    fInsulinDose.Rules(24).Description = "PRECALC_DOSE==High & BG_ACCEL==Pos => INSULIN_DOSE=High (1)";
    %
    fInsulinDose.Rules(5).Description = "PRECALC_DOSE==V_High & BG_ACCEL==Neg => INSULIN_DOSE=Mid (0.8)";
    fInsulinDose.Rules(10).Description = "PRECALC_DOSE==V_High & BG_ACCEL==SNeg => INSULIN_DOSE=Mid (0.8)";
    fInsulinDose.Rules(15).Description = "PRECALC_DOSE==V_High & BG_ACCEL==Zero => INSULIN_DOSE=High (1)";
    fInsulinDose.Rules(20).Description = "PRECALC_DOSE==V_High & BG_ACCEL==SPos => INSULIN_DOSE=High (1)";
    fInsulinDose.Rules(25).Description = "PRECALC_DOSE==V_High & BG_ACCEL==Pos => INSULIN_DOSE=V_High (1)";
   

    % FIST INIT
    treeConnection = [ ...
                fPrecalcDose.Name + "/" + fPrecalcDose.Outputs(1).Name ...
                    fInsulinDose.Name + "/" + fInsulinDose.Inputs(1).Name ...
                ];
    FIST = fistree([fPrecalcDose fInsulinDose], treeConnection);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
