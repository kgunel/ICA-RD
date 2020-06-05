function emp = CreateInitialEmpires(CostFunction,funId,params,alpha,zeta)

nVar = params.dim;              % Number of Decision Variables
VarSize=[1 nVar];               % Decision Variables Matrix Size
VarMin = params.low;            % Lower Bound of Variables
VarMax = params.up ;            % Upper Bound of Variables

nPop = params.nEmp + params.nCol;   % Population Size
nEmp = params.nEmp;                 % Number of Empires/Imperialists
nCol=nPop-nEmp;

empty_country.Position=[];
empty_country.Cost=[];
country=repmat(empty_country,nPop,1);

for i=1:nPop
    country(i).Position=unifrnd(VarMin,VarMax,VarSize);
    [~, country(i).Cost, ~, ~] = feval(CostFunction, country(i).Position, funId, params.shift);
end

costs=[country.Cost];
[~, SortOrder]=sort(costs);
country=country(SortOrder);

imp=country(1:nEmp);
col=country(nEmp+1:end);

empty_empire.Imp=[];
empty_empire.Col=repmat(empty_country,0,1);
empty_empire.nCol=0;
empty_empire.TotalCost=[];

emp=repmat(empty_empire,nEmp,1);

% Assign Imperialists
for k=1:nEmp
    emp(k).Imp=imp(k);
end

% Assign Colonies
P=exp(-alpha*[imp.Cost]/max([imp.Cost]));
P=P/sum(P);
for j=1:nCol
    
    k=RouletteWheelSelection(P);
    
    emp(k).Col=[emp(k).Col
        col(j)];
    
    emp(k).nCol=emp(k).nCol+1;
end

emp=UpdateTotalCost(emp,zeta);

end