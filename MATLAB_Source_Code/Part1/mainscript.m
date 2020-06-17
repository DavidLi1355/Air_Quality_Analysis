aqi2018 = readtable('aqi2018.csv');
newaqi2018=scrub(aqi2018);%this step is to scrub the data;
fprintf('The percentage of good days and all days with AQI is %.4f',calave(newaqi2018)) %this step is to
%calcualte the acerage percentage of good days and all days;
polluted_counties=find_bad(newaqi2018)%this step is to find the 
                                       %counties with serious air pollution
polluted_countiesinfo=extractdata(newaqi2018);%this step is to 
%                        reorganize the data to focus on polluted counties
mostp=find_most_pollution(polluted_countiesinfo);%this step is to find the 
                           %most serious pollutant in the polluted counties

                           
clear ans aqi2018 i newaqi2018 polluted_counties polluted_countiesinfo;