function print_perc(in)
%this program is to print the bar of each cbsa's percentage of good days
%and all days
[r,~]=size(in);
per=zeros(1,r);
for i=1:r
    per(1,i)=in{i,'GoodDays'}/in{i,'DayswithAQI'};
end
x =categorical(in{:,'CBSA'});

bar(x,per);
end
