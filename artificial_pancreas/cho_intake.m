%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              CHO_INTAKE                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cho_upd = cho_intake(table_name, cho_arr_, time_arr_, overwrite_)

    % TABLE INIT
    table_ = readtable(table_name, "VariableNamingRule", "preserve");

    % ERROR HANDLING
    if size(cho_arr_) ~= size(time_arr_)
        error("'Carbs intake' and 'Time of intake' arrays must be the same size");
    end
    if size(cho_arr_, 1) > 1
        error("Carbs intake' array must have height of 1");
    end
    if size(time_arr_, 1) > 1
        error("'Time of intake' array must have height of 1");
    end
    if ~istable(table_)
        error("Input variable 'table_' must be of type table");
    end
    if ~isstring(overwrite_)
        error("Input variable 'overwrite_' must be of type string");
    end
    if any(time_arr_ < 10)
        error("'Time of intake' array elements must be higher than 10 " + ...
        "for correct work of the controller");
    end
    if any(mod(time_arr_, 5) ~= 0)
        error("'Time of intake' array elements must be divisible by 5");
    end
    if any(time_arr_ < 0) || any(cho_arr_ < 0)
        error("'Carbs intake' and 'Time of intake' arrays' elements " + ...
        "must be bigger than 0");
    end
    if length(time_arr_) ~= length(unique(time_arr_))
        error("'Time of intake' array must only have unique values");
    end

    try
        table_.Carbs;
    catch ME
        if (strcmp(ME.identifier, 'MATLAB:table:UnrecognizedVarName'))
            error("Table " + table_ + " doesn't have" + ...
                " necessary column called 'Carbs'.", 1)
        end
    end

    try
        table_.Time;
    catch ME
        if (strcmp(ME.identifier, 'MATLAB:table:UnrecognizedVarName'))
            error("Table " + table_ + " doesn't have" + ...
                " necessary column called 'Time'.", 1)
        end
    end

    % DATA MANIPULATION
    if overwrite_ == "overwrite"
        for i = 1:size(table_.Carbs, 1)
            table_.Carbs(i) = 0;
        end
    end

    for i = 1:size(cho_arr_, 2)
        table_.Carbs(time_arr_(i) / 5) = cho_arr_(i);
    end

    % RETURN TABLE
    cho_upd = table_;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
