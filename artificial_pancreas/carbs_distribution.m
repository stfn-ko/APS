%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         CARBS_DISTRIBUTION                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ds_tr, carbs_absorbtion_time] = carbs_distribution(total_glucose_absorbed)
    
    if total_glucose_absorbed / 180 > 2.9
        carbs_absorbtion_time = floor(total_glucose_absorbed / 2.9 / 5);
    else
        while 1
            carbs_absorbtion_time = floor(rand(1) * (-28) + 51);
    
            if (total_glucose_absorbed / (carbs_absorbtion_time * 5)) < 2.9
                break;
            end
        end
    end

    carbs_absorbtion_ratio = total_glucose_absorbed / carbs_absorbtion_time;
    hp = carbs_absorbtion_time * 5;

    ds = zeros(1, carbs_absorbtion_time);

    if mod(carbs_absorbtion_time, 2) == 0
        darr = (carbs_absorbtion_time - 2);
        hpm = (carbs_absorbtion_time * 100 - 2 * hp) / darr;
        ds(carbs_absorbtion_time / 2:carbs_absorbtion_time / 2 + 1) = hp;
    else
        darr = (carbs_absorbtion_time - 1);
        hpm = (carbs_absorbtion_time * 100 - hp) / darr;
        ds(floor(carbs_absorbtion_time / 2 + 1)) = hp;
    end

    darr = floor(darr / 4);

    ds(1:darr + 1) = hpm - darr * (darr + 1 - (1:darr + 1));
    ds(darr + 2:darr * 2 + 1) = hpm + (darr * (1:darr));

    if mod(carbs_absorbtion_time, 2) == 0
        ds(carbs_absorbtion_time / 2 + 1:carbs_absorbtion_time) = fliplr(ds(1:carbs_absorbtion_time / 2));
    else
        ds(floor(carbs_absorbtion_time / 2) + 2:carbs_absorbtion_time) = fliplr(ds(1:floor(carbs_absorbtion_time / 2)));
    end

    ds_tr(1:carbs_absorbtion_time) = carbs_absorbtion_ratio / 100 * ds(1:carbs_absorbtion_time);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             END OF FUNCTION                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%