stateCoord = readtable('StateCoord.xlsx');
coord = sortrows(stateCoord,{'StateName'},{'ascend'});
cellCoord = {coord, coord, coord};
inTable = [aqiTable, cellCoord, windTable, tempTable, pressTable, rhTable];
stateIndex = getIndex(inTable);
inTableScrub = scrubCell(inTable, stateIndex);

mlTable = []; 
for i = 1:3
    mlTable = [mlTable; inTableScrub{4}(:,1)];
end


counter = 1;
for i = 1:6
    subTable = [];
    for j = 1:3
        subTable = [subTable; inTableScrub{counter}(:,2:end)];
        counter = counter + 1;
    end
    mlTable = [mlTable subTable];
end
    
clear inTable inTableScrub i j counter subTable stateCoord coord cellCoord stateIndex
    
    


function out = getIndex(tablesInCell)
    columns{1, length(tablesInCell)} = [];
    for i = 1:length(tablesInCell)
        columns{1, i} = table2cell(tablesInCell{1, i}(:,1));
    end
    out = columns{1, 1};
    for i = 2:length(columns)
        out = compareCell(out, columns{1, i});
    end
end

function out = compareCell(cell1, cell2)
    i = 1;
    while i <= length(cell1)
        [state] = cell1{i, :};
        if isInCell(state, cell2) == 0
            cell1(i, :) = [];
        else
            i = i+1;
        end
    end
    out = cell1;
end

function out = isInCell(state, inCell)
%output 0 or 1, 0 means the state, county combination not in inCell
    out = 0;
    range = 1:length(inCell);
    for i = range
        if strcmp(inCell{i, 1}, state)
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
        state = string(inTable{i, 1});
        if isInCell(state, index) == 0
            inTable(i, :) = [];
        else
            i = i + 1;
        end
    end
    out = inTable;     
end
