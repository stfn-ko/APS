%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             FUZZY_SYSTEM                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FIST, CCR, MDI, BGR_R, BGA_R] = fuzzy_system(patient)

    % MAX INSULIN PER DAY
    MIPD = patient.weight * patient.IRC;

    % CARBS COVERAGE RATIO
    CCR = patient.ACC / MIPD;

    % INSULIN DOSE RANGE
    MDI = [0 1.5];

    % BLOOD GLUCOSE RATE RANGE
    BGR_R = [-2 2]; % mg/dL/min

    % BLOOD GLUCOSE ACCELERATION RANGE
    BGA_R = [-0.7 0.7]; % mg/dL/min^2

    % MEMBERSHIP FUNCTIONS
    mf5_nzp = ["neg", "s_neg", "zero", "s_pos", "pos"];
    mf5_lmh = ["v_low", "low", "mid", "high", "v_high"];

    % INIT FIS
    % - precalculated dose
    fPrecalcDose = mamfis('Name', 'fPrecalcDose', 'NumInputMFs', 5, ...
        'NumOutputMFs', 5, 'NumInputs', 2, 'NumOutputs', 1);

    % - insulin dose
    fInsulinDose = mamfis('Name', 'fInsulinDose', 'NumInputMFs', 5, ...
        'NumOutputMFs', 5, 'NumInputs', 2, 'NumOutputs', 1);

    % EDIT BGL NAME AND RANGE
    fPrecalcDose.Inputs(1).Name = "BGL";
    fPrecalcDose.Inputs(1).Range = [0 400];

    % EDIT BLOOD GLUCOSE LEVEL MEMBERSHIP FUNCTIONS
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
    fPrecalcDose.Inputs(1).MembershipFunctions(3).Parameters = [25 125];
    %
    fPrecalcDose.Inputs(1).MembershipFunctions(4).Name = mf5_lmh(4);
    fPrecalcDose.Inputs(1).MembershipFunctions(4).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(4).Parameters = [80 240];
    %
    fPrecalcDose.Inputs(1).MembershipFunctions(5).Name = mf5_lmh(5);
    fPrecalcDose.Inputs(1).MembershipFunctions(5).Type = "gaussmf";
    fPrecalcDose.Inputs(1).MembershipFunctions(5).Parameters = [70 400];

    % UPDATE BGR & PRECALCULATED DOSE
    fPrecalcDose = update_io(fPrecalcDose, "Input", 2, "BGR", BGR_R, mf5_nzp);
    fPrecalcDose = update_io(fPrecalcDose, "Output", 1, "PRECLAC_DOSE", MDI, mf5_lmh);

    % EDIT PRECALCULATED DOSE RULEBASE
    fPrecalcDose.Rules(1).Description = "BGL==v_low & BGR==neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(6).Description = "BGL==v_low & BGR==s_neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(16).Description = "BGL==v_low & BGR==s_pos => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(11).Description = "BGL==v_low & BGR==zero => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(21).Description = "BGL==v_low & BGR==pos => PRECLAC_DOSE=v_low (1)";
    %
    fPrecalcDose.Rules(2).Description = "BGL==low & BGR==neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(7).Description = "BGL==low & BGR==s_neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(12).Description = "BGL==low & BGR==zero => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(17).Description = "BGL==low & BGR==s_pos => PRECLAC_DOSE=low (1)";
    fPrecalcDose.Rules(22).Description = "BGL==low & BGR==pos => PRECLAC_DOSE=low (1)";
    %
    fPrecalcDose.Rules(3).Description = "BGL==mid & BGR==neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(8).Description = "BGL==mid & BGR==s_neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(13).Description = "BGL==mid & BGR==zero => PRECLAC_DOSE=low (1)";
    fPrecalcDose.Rules(18).Description = "BGL==mid & BGR==s_pos => PRECLAC_DOSE=mid (0.7)";
    fPrecalcDose.Rules(23).Description = "BGL==mid & BGR==pos => PRECLAC_DOSE=mid (0.7)";
    %
    fPrecalcDose.Rules(4).Description = "BGL==high & BGR==neg => PRECLAC_DOSE=low (1)";
    fPrecalcDose.Rules(9).Description = "BGL==high & BGR==s_neg => PRECLAC_DOSE=low (1)";
    fPrecalcDose.Rules(14).Description = "BGL==high & BGR==zero => PRECLAC_DOSE=mid (0.7)";
    fPrecalcDose.Rules(19).Description = "BGL==high & BGR==s_pos => PRECLAC_DOSE=high (0.6)";
    fPrecalcDose.Rules(24).Description = "BGL==high & BGR==pos => PRECLAC_DOSE=high (0.6)";
    %
    fPrecalcDose.Rules(5).Description = "BGL==v_high & BGR==neg => PRECLAC_DOSE=v_low (1)";
    fPrecalcDose.Rules(10).Description = "BGL==v_high & BGR==s_neg => PRECLAC_DOSE=low (1)";
    fPrecalcDose.Rules(15).Description = "BGL==v_high & BGR==zero => PRECLAC_DOSE=mid (1)";
    fPrecalcDose.Rules(20).Description = "BGL==v_high & BGR==s_pos => PRECLAC_DOSE=high (1)";
    fPrecalcDose.Rules(25).Description = "BGL==v_high & BGR==pos => PRECLAC_DOSE=v_high (1)";

    % EDIT VALUES FOR INSULIN DOSE
    fInsulinDose = update_io(fInsulinDose, "Input", 1, "PRECALC_DOSE", MDI, mf5_lmh);
    fInsulinDose = update_io(fInsulinDose, "Input", 2, "BGA", BGA_R, mf5_nzp);
    fInsulinDose = update_io(fInsulinDose, "Output", 1, "INSULIN_DOSE", MDI, mf5_lmh);

    % EDIT INSULIN DOSE RULEBASE
    fInsulinDose.Rules(1).Description = "PRECALC_DOSE==v_low & BGA==neg => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(6).Description = "PRECALC_DOSE==v_low & BGA==s_neg => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(11).Description = "PRECALC_DOSE==v_low & BGA==zero => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(16).Description = "PRECALC_DOSE==v_low & BGA==s_pos => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(21).Description = "PRECALC_DOSE==v_low & BGA==pos => INSULIN_DOSE=v_low (1)";
    %
    fInsulinDose.Rules(2).Description = "PRECALC_DOSE==low & BGA==neg => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(7).Description = "PRECALC_DOSE==low & BGA==s_neg => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(12).Description = "PRECALC_DOSE==low & BGA==zero => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(17).Description = "PRECALC_DOSE==low & BGA==s_pos => INSULIN_DOSE=low (0.7)";
    fInsulinDose.Rules(22).Description = "PRECALC_DOSE==low & BGA==pos => INSULIN_DOSE=low (0.7)";
    %
    fInsulinDose.Rules(3).Description = "PRECALC_DOSE==mid & BGA==neg => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(8).Description = "PRECALC_DOSE==mid & BGA==s_neg => INSULIN_DOSE=v_low (1)";
    fInsulinDose.Rules(13).Description = "PRECALC_DOSE==mid & BGA==zero => INSULIN_DOSE=low (0.7)";
    fInsulinDose.Rules(18).Description = "PRECALC_DOSE==mid & BGA==s_pos => INSULIN_DOSE=low (0.7)";
    fInsulinDose.Rules(23).Description = "PRECALC_DOSE==mid & BGA==pos => INSULIN_DOSE=mid (0.6)";
    %
    fInsulinDose.Rules(4).Description = "PRECALC_DOSE==high & BGA==neg => INSULIN_DOSE=low (0.7)";
    fInsulinDose.Rules(9).Description = "PRECALC_DOSE==high & BGA==s_neg => INSULIN_DOSE=low (0.7)";
    fInsulinDose.Rules(14).Description = "PRECALC_DOSE==high & BGA==zero => INSULIN_DOSE=mid (0.8)";
    fInsulinDose.Rules(19).Description = "PRECALC_DOSE==high & BGA==s_pos => INSULIN_DOSE=mid (0.8)";
    fInsulinDose.Rules(24).Description = "PRECALC_DOSE==high & BGA==pos => INSULIN_DOSE=high (1)";
    %
    fInsulinDose.Rules(5).Description = "PRECALC_DOSE==v_high & BGA==neg => INSULIN_DOSE=mid (0.8)";
    fInsulinDose.Rules(10).Description = "PRECALC_DOSE==v_high & BGA==s_neg => INSULIN_DOSE=mid (0.8)";
    fInsulinDose.Rules(15).Description = "PRECALC_DOSE==v_high & BGA==zero => INSULIN_DOSE=high (1)";
    fInsulinDose.Rules(20).Description = "PRECALC_DOSE==v_high & BGA==s_pos => INSULIN_DOSE=high (1)";
    fInsulinDose.Rules(25).Description = "PRECALC_DOSE==v_high & BGA==pos => INSULIN_DOSE=v_high (1)";

    % FIST INIT
    treeConnection = [fPrecalcDose.Name + "/" + fPrecalcDose.Outputs(1).Name ...
                          fInsulinDose.Name + "/" + fInsulinDose.Inputs(1).Name];

    FIST = fistree([fPrecalcDose fInsulinDose], treeConnection);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
