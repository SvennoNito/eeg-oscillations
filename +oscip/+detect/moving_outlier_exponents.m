function Artefacts = moving_outlier_exponents(Exponents, Artefacts, opts)
arguments
    Exponents
    Artefacts = false(size(Exponents));    
    opts.Threshold = 3;
    opts.MovingWindow_Minutes = 5;
    opts.EpochLength = 30;
    opts.AllowedDeviation = .7;
end

nWindows = opts.MovingWindow_Minutes * 60 / opts.EpochLength;


Exponents(Artefacts) = nan;

MovingMedian      = movmedian(Exponents, nWindows, 2, 'omitnan');
% AllowedDeviation  = opts.Threshold * movmad(Exponents, nWindows, 2, 'omitnan');
AllowedDeviation  = opts.AllowedDeviation;

Artefacts = Exponents > MovingMedian + AllowedDeviation | ...
    Exponents < MovingMedian - AllowedDeviation;


% %%
% figure('Color','w');
% hold on;
% for ch = 1:size(Exponents, 1)
%     plot(Exponents(ch, :) - ch*2  , '.')  
%     plot(find(Artefacts(ch, :)), Exponents(ch, Artefacts(ch, :)) - ch*2, 'ro')
%     plot(MovingMedian(ch, :) - AllowedDeviation- ch*2, 'r') 
%     plot(MovingMedian(ch, :) + AllowedDeviation- ch*2, 'r') 
% end
% a=2