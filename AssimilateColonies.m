function emp = AssimilateColonies(emp,CostFunction,funId,params,beta)

nVar = params.dim;              % Number of Decision Variables
VarSize=[1 nVar];               % Decision Variables Matrix Size
VarMin = params.low;            % Lower Bound of Variables
VarMax = params.up ;            % Upper Bound of Variables

nEmp=numel(emp);
for k=1:nEmp
    for i=1:emp(k).nCol
        emp(k).Col(i).Position = emp(k).Col(i).Position ...
            + beta*rand(VarSize).*(emp(k).Imp.Position-emp(k).Col(i).Position);
        
        emp(k).Col(i).Position = max(emp(k).Col(i).Position,VarMin);
        emp(k).Col(i).Position = min(emp(k).Col(i).Position,VarMax);
        [~, emp(k).Col(i).Cost, ~, ~] = feval(CostFunction, emp(k).Col(i).Position, funId, params.shift);
    end
end

end