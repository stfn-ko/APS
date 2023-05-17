%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         CARBS_DISTRIBUTION                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [distributed_glucose, glucose_absorbtion_time] = carbs_distribution(total_glucose_absorbed)
    mean = 0;
    std_dev = 1;
    step = rand(1) * (0.6) + 2.2;
    % @Note: since avg carbs absorption rate for a person with 70 kg body weight is 0.73 g/min (https://www.sciencedirect.com/science/article/pii/S1474667017355337?ref=pdf_download&fr=RR-2&rr=7c89ebd149907702)
    % I adjusted glucose absorption time so that it can't go higher than 1g/min and can't go over 7hrs of digestion. 
    glucose_absorbtion_time = floor((rand(1) * (84 - total_glucose_absorbed/5)) + total_glucose_absorbed/5);
        
    % Generate equally spaced x-values
    x_values = linspace(-step * std_dev, step * std_dev, glucose_absorbtion_time);
        
    % Calculate y-values using the PDF equation
    y_values = (1 / (std_dev * sqrt(2 * pi))) * exp(-(x_values - mean).^2 / (2 * std_dev^2));
        
    % Normalize the y-values to sum up to total_glucose_absorbed
    distributed_glucose = (y_values / sum(y_values)) * total_glucose_absorbed;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%