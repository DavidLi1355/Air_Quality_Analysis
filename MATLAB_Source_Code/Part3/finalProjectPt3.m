
windData = initWind();
tempData = initTemp();
pressData = initPress();
rhData = initRH();
aqiData = initAQI();

searchCol = "ParameterName";
searchTermIndex = {"Wind Speed - Resultant", "Outdoor Temperature", "Barometric pressure", "Relative Humidity "};
colVarIndex = {'WindSpeed', 'Temperature', 'Pressure', 'Humidity'};
colName = {'StateName', 'ArithmeticMean'};
aqiColName = {'State', 'MaxAQI', 'x90thPercentileAQI', 'MedianAQI'};

windTable = processData(windData, colName, searchCol, searchTermIndex{1}, colVarIndex{1});
clear windData; 
tempTable = processData(tempData, colName, searchCol, searchTermIndex{2}, colVarIndex{2});
clear tempData; 
pressTable = processData(pressData, colName, searchCol, searchTermIndex{3}, colVarIndex{3});
clear pressData; 
rhTable = processData(rhData, colName, searchCol, searchTermIndex{4}, colVarIndex{4});
clear rhData; 
aqiTable = processData(aqiData, aqiColName);
clear aqiData; 

clear searchCol searchTermIndex colVarIndex colName aqiColName


%{
tenYearData = tablesInCellScrubbed;
tenYearCol = {'State', 'MedianAQI'};
tenYearTable = processData(tenYearData, tenYearCol);
%}

function out = processData(dataIn, colName, varargin)
%varargin = searchCol, searchTerm
    out{length(dataIn)} = 0;
    for i = 1:length(dataIn)
        oneYearTable = dataIn{i};
        if nargin > 2
            tempTable = createVarTable(oneYearTable, colName, varargin{1}, varargin{2});
            stateAverage = avergeByState(tempTable, colName, cellstr(varargin{3}));
        else
            tempTable = createColTable(oneYearTable, colName);
            stateAverage = avergeByState(tempTable, colName, colName(2:end));
        end
        out{i} = stateAverage;
    end
end

function out = avergeByState(tableIn, colName, colVar)
    statesTable = tableIn(1:end, 1); 
    states = catForColumn(statesTable);
    averages(length(states), length(colName) - 1) = 0;
    
    for i = 1:length(states)
        searchCol = string(colName{1});
        searchTerm = states{i};
        oneStateTable = createVarTable(tableIn, colName, searchCol, searchTerm);
        averages(i, :) = mean(oneStateTable{:,2:end}, 1);
    end
    
    averages = array2table(averages, 'VariableNames', colVar);
    states = states';
    out = table(states);
    out = [out averages];
end

function out = createVarTable(tableIn, colName, searchCol, searchTerm)
    col(length(colName)) = 0;
    
    for i = 1:length(colName)
        col(i) = find(string(tableIn.Properties.VariableNames) == string(colName{i}));
    end
    
    searchCol = find(string(tableIn.Properties.VariableNames) == searchCol);
    
    out = tableIn(strcmp(tableIn.(searchCol), char(searchTerm)), col);
end

function out = createColTable(tableIn, colName)
    col(length(colName)) = 0;
    
    for i = 1:length(colName)
        col(i) = find(string(tableIn.Properties.VariableNames) == string(colName{i}));
    end
    
    out = tableIn(1:end, col);
end

function out = catForColumn(tableIn)
    diction = {};
    for i = 1:height(tableIn)
        temp = string(table2array(tableIn(i, 1)));
        inDic = 0;
        
        if isempty([diction{:}]) == 0
            if isempty(find([diction{:}] == temp{1})) == 0
                inDic = 1;
            end
        end
            
        if inDic == 0
            diction{length(diction)+1} = temp;
        end
    end
    out = diction;
end



function out = initWind()
    out = {readtable('wind2016.csv'), readtable('wind2017.csv'), readtable('wind2018.csv')};
end

function out = initTemp()
    out = {readtable('temp2016.csv'), readtable('temp2017.csv'), readtable('temp2018.csv')};
end

function out = initPress()
    out = {readtable('press2016.csv'), readtable('press2017.csv'), readtable('press2018.csv')};
end

function out = initRH()
    out = {readtable('rhdp2016.csv'), readtable('rhdp2017.csv'), readtable('rhdp2018.csv')};
end

function out = initAQI()
    out = {readtable('aqi2016.csv'), readtable('aqi2017.csv'), readtable('aqi2018.csv')};
end


