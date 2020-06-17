function out=find_most_pollution(in)
%in this function, we will calculate what is the most serious pollutants in
%these seriously air-polluted counties. this function will return a ell
%array with the first row representing the county names and the second row
%representing the most serious pollutant
[r,~]=size(in);
for i=1:r
    %we use the days when certain pollutant is the main pollutant divided
    %by the all days having the pollution
    sump=sum(in{i,end-5:end});
    co=in{i,'DaysCO'}/sump;
    no2=in{i,'DaysNO2'}/sump;
    ozone=in{i,'DaysOzone'}/sump;
    so2=in{i,'DaysSO2'}/sump;
    pm25=in{i,'DaysPM2_5'}/sump;
    pm10=in{i,'DaysPM10'}/sump;
    pollutant=["CO","NO2","OZONE","SO2","PM25","PM10"];
    polnum=[co,no2,ozone,so2,pm25,pm10];
    maxp=max(polnum);
    
    outa{1,1}=string(in{i,'State'});
    outa{2,1}=string(in{i,'County'});
    polnumindex=find(polnum==maxp);
    if length(polnumindex)~=1
        polnumindex=polnumindex(1,1);
    end
        outa{3,1}=pollutant(polnumindex); 
    out{1,i}=outa;
end
    
    
    
    