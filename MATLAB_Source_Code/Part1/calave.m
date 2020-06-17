%this program is to calucltae the average of the percents of the division
%of good days and all days in 2018
function out=calave(in)
gooddays=in{:,'GoodDays'};
alldays=in{:,'DaysWithAQI'};
sumgooddays=sum(gooddays);
sumalldays=sum(alldays);
out=sumgooddays'/sumalldays';
end
