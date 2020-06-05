function emp = DoRevolution(emp,CostFunction,funId,params,pRevolution,mu)

nVar = params.dim;              % Number of Decision Variables
VarSize=[1 nVar];               % Decision Variables Matrix Size
VarMin = params.low;            % Lower Bound of Variables
VarMax = params.up ;            % Upper Bound of Variables

nmu=ceil(mu*nVar);

sigma=0.1*(VarMax-VarMin);

nEmp=numel(emp);
for k=1:nEmp
    
    NewPos = emp(k).Imp.Position + sigma*randn(VarSize);
    
    jj=randsample(nVar,nmu)';
    NewImp=emp(k).Imp;
    NewImp.Position(jj)=NewPos(jj);
    [~, NewImp.Cost, ~, ~] = feval(CostFunction, NewImp.Position, funId, params.shift);
    if NewImp.Cost<emp(k).Imp.Cost
        emp(k).Imp = NewImp;
    end
    
    for i=1:emp(k).nCol
        if rand<=pRevolution
            
            NewPos = emp(k).Col(i).Position + sigma*randn(VarSize);
            
            jj=randsample(nVar,nmu)';
            emp(k).Col(i).Position(jj) = NewPos(jj);
            
            emp(k).Col(i).Position = max(emp(k).Col(i).Position,VarMin);
            emp(k).Col(i).Position = min(emp(k).Col(i).Position,VarMax);
            
            [~, emp(k).Col(i).Cost, ~, ~] = feval(CostFunction, emp(k).Col(i).Position, funId, params.shift);

            
        end
    end
end

end