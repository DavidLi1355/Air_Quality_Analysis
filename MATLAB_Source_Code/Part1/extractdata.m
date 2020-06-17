function newdata=extractdata(entire)
%this function is to form a new table only includes information about the counties of bad ai
%quality
[~,part]=find_bad(entire);
newdata=entire(part,:);
end