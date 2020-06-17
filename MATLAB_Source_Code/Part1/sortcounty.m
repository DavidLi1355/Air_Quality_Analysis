function out=sortcounty(in,gas)
%this function is to sort the county by the seriousness of the pollution of
%the certain pollutant, the gas in the input should be the column in the
%table like "DaysCO"
countyname=[in{:,'County'}]';

[r,c]=size(in);
data=zeros(1,r);
for i=1:r
    sumd=sum(in{i,end-5:end});
    data(1,i)=[in{i,gas}/sumd];
    for j=1:i-1
        if data(1,j)>data(1,i)
            temp=data(1,j+1);
            data(1,j+1)=data(1,j);
            data(1,j)=temp;
            tempc=countyname(1,j+1);
            countyname(1,j+1)=countyname(1,j);
            countyname(1,j)=tempc;
        end
    end
end
out=countyname;
end