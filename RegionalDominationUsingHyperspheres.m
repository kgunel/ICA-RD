function [emp,ct, isDominated] = RegionalDominationUsingHyperspheres(emp,CostFunction,funId,params,rdamp)

ct = 0;   % Counts the Cost function evalution
isDominated = 0;

nPop = params.nCol + params.nEmp;
nVar = params.dim;
totalNMutants = 1 + floor(rdamp*0.4*nPop);

nEmp = numel(emp);

empCosts = [emp.TotalCost];
[~,SortOrder] = sort(empCosts);

% Select an empire which is not equal the best emp
selectedIndex = SortOrder(1 + randi(nEmp-1));
M = abs(emp(SortOrder(1)).Imp.Position - emp(selectedIndex).Imp.Position)/2;
r = rdamp*sqrt(sum((emp(SortOrder(1)).Imp.Position - emp(selectedIndex).Imp.Position).^2))/2;
% Generate a new population inside of hypersphere neighbourhood of M with
% radius r
empty_country.Position=[];
empty_country.Cost=[];
newPop=repmat(empty_country,totalNMutants,1);
for j=1:totalNMutants
    newPop(j).Position = randHypersphere(1,nVar,r,M);
    [~, newPop(j).Cost, ~, ~] = feval(CostFunction, newPop(j).Position, funId, params.shift);
end
ct = ct + totalNMutants;
% Sort Population
[~, minIndex] = min([newPop.Cost]);

if newPop(minIndex).Cost < emp(SortOrder(1)).Imp.Cost  % The best imp
    emp(SortOrder(1)).nCol = emp(SortOrder(1)).nCol + 1;
    emp(SortOrder(1)).Col(emp(SortOrder(1)).nCol) = emp(SortOrder(1)).Imp;
    emp(SortOrder(1)).Imp = newPop(minIndex);
	isDominated = 1;
elseif newPop(minIndex).Cost < emp(selectedIndex).Imp.Cost  % The selected imp
    emp(selectedIndex).nCol = emp(selectedIndex).nCol + 1;
    emp(selectedIndex).Col(emp(selectedIndex).nCol) = emp(selectedIndex).Imp;
    emp(selectedIndex).Imp = newPop(minIndex);    
	isDominated = 1;
else
    % The colonies of the best imp
    cols = [emp(SortOrder(1)).Col];
    if ~isempty(cols)
        [~,maxIndex] = max([cols.Cost]);
        if newPop(minIndex).Cost < emp(SortOrder(1)).Col(maxIndex).Cost
            emp(SortOrder(1)).Col(maxIndex) = newPop(minIndex);
			isDominated = 1;
        else
            % The colonies of the randomly selected imp
            cols = [emp(selectedIndex).Col];
            if ~isempty(cols)
                [~,maxIndex] = max([cols.Cost]);
                if newPop(minIndex).Cost < emp(selectedIndex).Col(maxIndex).Cost
                    emp(selectedIndex).Col(maxIndex) = newPop(minIndex);
					isDominated = 1;
                end
            end
            
        end
    end
end