function [out,index]=find_bad(in)
%in this function, We find the counties that had the percentage of good
%days and bad days lower than 0.7*average and sort it by the seriousness of
%air pollution, this will return a output with all the names of counties
%with bad air quality and their index in the original table
[r,~]=size(in);
count=1;
ave=0.7*calave(in);
for i=1:r
    per=in{i,'GoodDays'}/in{i,'DaysWithAQI'};
    if per<ave
        out(1,count)=in{i,'County'};
        index(1,count)=i;
        count=count+1;
    end
end
