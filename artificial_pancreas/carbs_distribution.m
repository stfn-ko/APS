function [ds_tr, CAT_] = carbs_distribution(TGA_)
    
    if TGA_ / 180 > 2.9
        CAT_ = floor(TGA_ / 2.9 / 5);
    else
        while 1
            % - carbs absorption time (mins / TS)
            CAT_ = floor(rand(1) * (22 - 50) + 51); %18 36 37
    
            if (TGA_ / (CAT_ * 5)) < 2.9
                break;
            end
        end
    end

    mean = TGA_ / CAT_;
    hp = CAT_ * 5;

    ds = zeros(1, CAT_);

    if mod(CAT_, 2) == 0
        darr = (CAT_ - 2);
        hpm = (CAT_ * 100 - 2 * hp) / darr;
        ds(CAT_ / 2:CAT_ / 2 + 1) = hp;
    else
        darr = (CAT_ - 1);
        hpm = (CAT_ * 100 - hp) / darr;
        ds(floor(CAT_ / 2 + 1)) = hp;
    end

    darr = floor(darr / 4);

    ds(1:darr + 1) = hpm - darr * (darr + 1 - (1:darr + 1));
    ds(darr + 2:darr * 2 + 1) = hpm + (darr * (1:darr));

    if mod(CAT_, 2) == 0
        ds(CAT_ / 2 + 1:CAT_) = fliplr(ds(1:CAT_ / 2));
    else
        ds(floor(CAT_ / 2) + 2:CAT_) = fliplr(ds(1:floor(CAT_ / 2)));
    end

    ds_tr(1:CAT_) = mean / 100 * ds(1:CAT_);
end
