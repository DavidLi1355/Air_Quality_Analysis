function out=scrub(in)
%This function is to scrub the data and delete some redundant features
%We delete Very enhelathy days, hazardous days because they are almos all 0
%and we delete the MaxAQI because it is not used in our calculation
out=removevars(in,{'VeryUnhealthyDays','HazardousDays','MaxAQI'});
end