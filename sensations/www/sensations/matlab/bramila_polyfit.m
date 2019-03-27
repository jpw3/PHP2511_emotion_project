function [yfit p R2 R2adj]=bramila_polyfit(x,y,N)
% usage
% [R2 R2adj]=bramila_polyfit(x,y,N)

p = polyfit(x,y,N);
yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
R2 = 1 - SSresid/SStotal;
R2adj = 1 - SSresid/SStotal * (length(y)-1)/(length(y)-length(p));