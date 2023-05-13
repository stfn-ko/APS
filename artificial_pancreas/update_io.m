%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                UPDATE_IO                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fis_ = update_io(fis_, io_, id_, name_, range_, mf_)
    
    % UPDATE OUTPUT
    if io_ == "Output"
        fis_.Outputs(id_).Name = name_;
        rangeDiff = diff(range_);

        for it = 1:length(mf_)
            fis_.Outputs(id_).MembershipFunctions(it).Name = mf_(it);
            params = range_(1) + rangeDiff * ...
                fis_.Outputs(id_).MembershipFunctions(it).Parameters;
            fis_.Outputs(id_).MembershipFunctions(it).Parameters = params;
        end

        l_ = fis_.Outputs(id_).MembershipFunctions(1).Parameters(1);
        r_ = fis_.Outputs(id_).MembershipFunctions(end).Parameters(end);

        fis_.Outputs(id_).Range = [l_ r_];

    end

    % UPDATE INPUT
    if io_ == "Input"
        fis_.Inputs(id_).Name = name_;
        fis_.Inputs(id_).Range = range_;

        for it = 1:length(mf_)
            fis_.Inputs(id_).MembershipFunctions(it).Name = mf_(it);
            params = range_(1) + ...
                diff(range_) * fis_.Inputs(id_).MembershipFunctions(it).Parameters;

            fis_.Inputs(id_).MembershipFunctions(it).Parameters = params;
        end

    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
