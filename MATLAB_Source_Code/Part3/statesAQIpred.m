cellTable10 = tenYearTable;
entireTable10 = [];
yearIndex = 2008;

for i = 1:length(cellTable10)
    oneTable = cellTable10{i};
    Year = repelem(i+yearIndex,height(oneTable));
    Year = Year';
    oneTable = addvars(oneTable,Year,'Before','MedianAQI');
    entireTable10 = [entireTable10; oneTable];
end

clear i Year oneTable yearIndex


entireTable10.states = cellstr(entireTable10.states);
entireTable10.states = categorical(entireTable10.states);

%center data
entireTable10.YRcentered = entireTable10.Year - mean(unique(entireTable10.Year));

%get model
lme = fitlme(entireTable10, 'MedianAQI ~ 1 + YRcentered + (1+YRcentered|states)');
data = lme.Variables;
response = lme.ResponseName;
xdata = 'Year';
group = 'states';
gscatter(data.(xdata), data.(response), data.(group));


forecastData = table;
forecastYears = (2019:2021)';
forecastStates = categorical(entireTable10.states);

for ii = 1:numel(forecastStates)
    tbl = table;
    tbl.Year = forecastYears;
    tbl.states(:,1) = forecastStates(ii);
    forecastData = [forecastData;tbl];
end
forecastData.YRcentered = forecastData.Year - mean(unique(entireTable10.Year));


newData = predict(lme, forecastData);
data = lme.Variables;
response = lme.ResponseName;
group_names = categories(data.(group));
group = 'STATE';
gscatter(newdata.(xdata),newdata.(response),newdata.(group));


newdata = forecastData;
data = lme.Variables;
response = lme.ResponseName;
group_names = categories(data.(group));
group = 'STATE';
c = hsv(numel(unique(group_names)));
[~,loc] = ismember(categories(newdata.(group)),group_names);
[lme_pred,lmeCI] = predict(lme,newdata,'Prediction','observation');
newdata(:,response) = array2table(lme_pred);
gscatter(newdata.(xdata),newdata.(response),newdata.(group));


