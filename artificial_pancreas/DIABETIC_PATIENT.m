%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  NOTES                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           DIABETIC PATIENT                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DIABETIC_PATIENT(weight_, diet_, version_, randomize_)

    % INIT FIS TREE
    [AP, CCR, ~, ~, ~] = AP_FIST(weight_);

    % SET PATH
    version_path = strcat('db/results/', 'v', version_);
    test_id = strcat(diet_, '_', char(randi([48 57], 1, 3)), char(randi([65 90], 1, 2)));
    path = strcat(version_path, '/', test_id);
    mkdir(path);

    % OPEN DB
    database = strcat('db/diets/', diet_, '.xlsx');

    if isstring(database)
        database = readtable(database, "VariableNamingRule", "preserve");
    end

    % EVALUATE FIS
    options = evalfisOptions('NumSamplePoints', 1000);

    % CALCULATE TIMESTAMP
    TS = database.Time(2) - database.Time(1);

    % RANDOMIZE test_data(1:3) VALUES
    if randomize_
        database.BGL(1) = rand(1) * (70 - 250) + 250;
        database.BGL(2) = database.BGL(1) + rand(1) * (-8) + 4;
        database.BGL(3) = database.BGL(2) + rand(1) * (-8) + 4;
        database.BGR(2) = (database.BGL(2) - database.BGL(1)) / TS;
        database.BGR(3) = (database.BGL(3) - database.BGL(2)) / TS;
        database.BGA(3) = (database.BGR(3) - database.BGR(2)) / TS;
    end

    % TEST FISTREE
    for i = 3:size(database, 1)

        % evaluate fis tree
        eval = evalfis(AP, [database.BGL(i) database.BGR(i) database.BGA(i)], options);

        % Logging current insulin dose into databse
        database.Insulin(i) = eval;

        % Insulin Absorption Time (between 56 and 126)
        absorption_time = floor((rand(1) * (-70) + 126) / 5);

        % Total Insulin Absorbed (mg/dL)
        total_insulin = database.Insulin(i) * 50;

        absorption_rate = total_insulin / absorption_time;

        for j = i:i + absorption_time - 1

            if j < size(database, 1)

                if isnan(database.BGL(j + 1))
                    database.BGL(j + 1) = 0;
                end

                database.BGL(j + 1) = database.BGL(j + 1) - absorption_rate;
            end

        end

        % logging next BGL, BGR, BGA
        if i < size(database, 1)
            % add noise
            database.BGL(i + 1) = database.BGL(i + 1) + database.BGL(i) + (rand(1) * (-2) + 1);
            database.BGR(i + 1) = (database.BGL(i + 1) - database.BGL(i)) / TS;
            database.BGA(i + 1) = (database.BGR(i + 1) - database.BGR(i)) / TS;
        end

        % logging Carbs into BGL
        if database.Carbs(i) > 0
            % Total Glucose Absorbed (mg/dL)
            TGA = (database.Carbs(i) / CCR) * 50;
            % TGA normally distributed (mg/dL/min)
            [ds, CAT] = cho_distribution(TGA);

            for j = i:(i + CAT - 1)

                if j < size(database, 1)

                    if isnan(database.BGL(j + 1))
                        database.BGL(j + 1) = 0;
                    end

                    database.BGL(j + 1) = database.BGL(j + 1) + ds(j - i + 1);
                end

            end

        end

        % pause(1)
    end

    % SUMMARISING RESULTS
    database.("Patient's weight")(1) = weight_;
    database.CHO_TOTAL(1) = sum(database.Carbs);
    database.INSULIN_TOTAL(1) = sum(database.Insulin);
    database.BGL_GROW_APPROX(1) = database.CHO_TOTAL(1) / CCR * 50;
    database.PREDICTED_INSULIN_TOTAL(1) = database.CHO_TOTAL(1) / 50;

    database.BGL_NORM_100_120(1) = ...
        (sum(database.BGL < 120) ...
        - sum(database.BGL < 100)) ...
        / size(database, 1) * 100;

    database.BGL_NORM_72_180(1) = ...
        (sum(database.BGL < 180) ...
        - sum(database.BGL < 72)) ...
        / size(database, 1) * 100;

    % WRITE TO RESULTS TABLE
    writetable(database, append(path, '/results.xlsx'));

    % FIGURES
    t = 0:minutes(TS):hours((size(database, 1) - 1) / 12);

    % - fig
    fig = figure;
    yyaxis right;
    plot(t, database.Insulin, 'DurationTickFormat', 'hh:mm', Color = "#FFA400"),
    ylim([0 2]),
    ylabel('Insulin Dose Level (mg/dL)')
    yyaxis left;
    plot(t, database.BGL, 'DurationTickFormat', 'hh:mm', Color = "#220DFF"),
    ylim([0 400]),
    yticks(linspace(0, 400, 21));
    xlabel('Time'), ylabel('Blood Glucose Level (mg/dL)')
    title('Blood Glucose Levels and Insulin Dosage Over 24 hours')

    % - fig1
    fig1 = figure;
    plot(t, database.BGL, 'DurationTickFormat', 'hh:mm', Color = "#220DFF"),
    ylim([0 400]),
    yticks(linspace(0, 400, 11));
    xlabel('Time'), ylabel('Blood Glucose Level (mg/dL)')
    title('Blood Glucose Levels Over 24hrs')

    % SAVE FIGURES
    saveas(fig, append(path, '/BGL_INSULIN_24hr'), 'png');
    saveas(fig1, append(path, '/BGL_24hr'), 'png');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
