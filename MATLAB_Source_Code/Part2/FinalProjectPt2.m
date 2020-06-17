%from 2009 - 2018

tablesInCell = getTablesInCell10year();
index = getIndex(tablesInCell);
tablesInCellScrubbed = scrubCell(tablesInCell, index);
totalSearch = mostp;
clear tablesInCell mostp;
multiPlotOverYear(tablesInCellScrubbed, index, totalSearch, 4);

tablesInCell3 = getTablesInCell3year();
index3 = getIndex(tablesInCell3);
tablesInCellScrubbed3 = scrubCell(tablesInCell3, index3);





function out = getTablesInCell10year() 
    t2018 = readtable('aqi2018.csv');
    t2017 = readtable('aqi2017.csv');
    t2016 = readtable('aqi2016.csv');
    t2015 = readtable('aqi2015.csv');
    t2014 = readtable('aqi2014.csv');
    t2013 = readtable('aqi2013.csv');
    t2012 = readtable('aqi2012.csv');
    t2011 = readtable('aqi2011.csv');
    t2010 = readtable('aqi2010.csv');
    t2009 = readtable('aqi2009.csv');

    out = {t2009, t2010, t2011, t2012, t2013, t2014, t2015, t2016, t2017, t2018};
end

function out = getTablesInCell3year()
    t2018 = readtable('aqi2018.csv');
    t2017 = readtable('aqi2017.csv');
    t2016 = readtable('aqi2016.csv');

    out = {t2016, t2017, t2018};
end

function out = getIndex(tablesInCell)
    columns{1, length(tablesInCell)} = [];
    for i = 1:length(tablesInCell)
        columns{1, i} = table2cell(tablesInCell{1, i}(:,[1 2]));
    end
    out = columns{1, 1};
    for i = 2:length(columns)
        out = compareCell(out, columns{1, i});
    end
end

function out = compareCell(cell1, cell2)
    i = 1;
    while i <= length(cell1)
        [state, county] = cell1{i, :};
        if isInCell(state, county, cell2) == 0
            cell1(i, :) = [];
        else
            i = i+1;
        end
    end
    out = cell1;
end

function out = isInCell(state, county, inCell)
%output 0 or 1, 0 means the state, county combination not in inCell
    out = 0;
    range = 1:length(inCell);
    for i = range
        if and(strcmp(inCell{i, 1}, state), strcmp(inCell{i, 2}, county))
            out = 1; 
            break;
        end
    end
end

function out = scrubCell(tablesInCell, index)
    out{1, length(tablesInCell)} = [];
    for i = 1:length(tablesInCell)
        out{1, i} = scrubTable(tablesInCell{1, i}, index);
    end 
end

function out = scrubTable(inTable, index)
    i = 1;
    while i <= height(inTable)
        state = inTable{i, 1};
        county = inTable{i, 2};
        if isInCell(state, county, index) == 0
            inTable(i, :) = [];
        else
            i = i + 1;
        end
    end
    out = inTable;     
end

function multiPlotOverYear(tablesInCellScrubbed, index, totalSearch, varargin)
    figNum = 1;
    subFigNum = 1;
    fprintf("\n")
    for i = 1:length(totalSearch)
        oneSearch = totalSearch{1, i};
        state = oneSearch{1, 1};
        county = oneSearch{2, 1};
        if isInCell(state, county, index) == 0
            fprintf("%s, %s does not have 10 years of data to plot a graph!!!\n", county, state);
        else
            figure(figNum);
            if nargin == 4
                plotSubPlot(tablesInCellScrubbed, oneSearch, varargin{1}, subFigNum);
                subFigNum = subFigNum + 1;
                if subFigNum > (varargin{1} * varargin{1})
                    subFigNum = 1;
                    figNum = figNum + 1;
                end
            else 
                plotOnePlot(tablesInCellScrubbed, oneSearch);
                figNum = figNum + 1;
            end
        end
        
    end
end

function plotSubPlot(tablesInCellScrubbed, oneSearch, figSize, subFigNum) 
    subplot(figSize, figSize, subFigNum);
    plotOnePlot(tablesInCellScrubbed, oneSearch);
end

function plotOnePlot(tablesInCellScrubbed, oneSearch)
    historic(10) = 0;
    for i = 1:10
        oneYearTable = tablesInCellScrubbed{1, i};
        historic(i) = getOneYearValue(oneYearTable, oneSearch);
    end
    x = 2009:2018;
    y = historic * 100;
    plot(x, y);
    
    state = oneSearch{1, 1};
    county = oneSearch{2, 1};
    pollutant = oneSearch{3, 1};
    title([char(county), ' ', char(state), ', Pollutant: ', char(pollutant)], 'Interpreter', 'none');
    xlabel('Years');
    ylabel('Percentage Days');
end

function out = getOneYearValue(oneYearTable, oneSearch) 
    state = oneSearch{1, 1};
    county = oneSearch{2, 1};
    pollutant = oneSearch{3, 1};
    rawValue = getRawValueFromTable(oneYearTable, state, county, pollutant);
    out = rawValue(1) / sum(rawValue(2:end));
end

function out = getRawValueFromTable(oneYearTable, state, county, pollutant)
    tableIndex = getTableIndex(oneYearTable, state, county);
    
    pollutantReference = {"CO","NO2","OZONE","SO2","PM25","PM10"};  
    pollutantIndex = 13 + find([pollutantReference{:}] == pollutant);
    
    out(7) = 0;
    out = [oneYearTable{tableIndex, pollutantIndex}];
    for i = 1:length(pollutantReference)
        out(i+1) = oneYearTable{tableIndex, i+13};
    end
end

function out = getTableIndex(oneYearTable, state, county) 
    out = 0;
    for i = 1:height(oneYearTable)
        if and(strcmp(oneYearTable{i, 1}, state), strcmp(oneYearTable{i, 2}, county))
            out = i; 
            break;
        end
    end
end


