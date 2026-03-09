function [Outliers, xfit, yfit, ytop, ylow, stats] = linear_outlier_detector(X, Y, Threshold)
arguments
    X
    Y
    Threshold = 10
end

Dims = size(X);

% identify linear fit between two data series
X = X(:);
Y = Y(:);

if nnz(~isnan(X)) <5 || nnz(~isnan(Y)) <5 
    Outliers = false(Dims);
    xfit = [];
    yfit = [];
    ytop = [];
    ylow = [];
    return
end

[b, stats] = robustfit(X, Y); % fits y ≈ b(1) + b(2)*x, downweights outliers
yfit = b(1) + b(2)*X;
xfit = X; % for output

% calculate normalized residuals
Residuals = Y(:) - yfit;
medR = median(Residuals, 'omitnan');
madR = mad(Residuals, 1);
Z = (Residuals-medR)./madR;

% Calculate upper and lower boundary (for plotting)
ytop = yfit + medR + Threshold*madR;
ylow = yfit + medR - Threshold*madR;

% ytop = linspace(min(ytop), max(ytop), 10000);
% ylow = linspace(min(ylow), max(ylow), 10000);
% xfit = linspace(min(xfit), max(xfit), 10000);
% yfit = linspace(min(yfit), max(yfit), 10000);

% identify outliers
Outliers = abs(Z)>Threshold;

Outliers = reshape(Outliers, Dims);


% figure('Position', [50, 50, 200, 200]);
% plot(X, Y, 'k.')
% hold on;
% plot(X(Outliers), Y(Outliers), 'ro')
% plot(xfit, yfit, 'k-')
% plot(xfit, ytop, 'k-')
% plot(xfit, ylow, 'k-')
% 
% figure('Position', [50, 50, 200, 200]);
% plot(Y, X, 'k.')
% hold on;
% plot(Y(Outliers), X(Outliers), 'ro')
% plot(yfit, xfit, 'k-')
% plot(ytop, xfit, 'k-')
% plot(ylow, xfit, 'k-')