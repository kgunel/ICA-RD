function [xmin,fmin,nFeval,iter,BestCost,emp,noSuccessfulDomination] = ica(objfunc,funId,params,setMutation)
rand('seed', sum(100 * clock));
%% Problem Definition
CostFunction = fcnchk(objfunc); 
VarMin = params.low;
VarMax = params.up;
maxfeval = params.maxfeval;

%% ICA 
MaxIt = params.Max_Iteration;       % Maximum Number of Iterations

alpha = 1;                          % Selection Pressure
beta = 1.5;                         % Assimilation Coefficient
pRevolution = 0.05;                 % Revolution Probability
mu = 0.1;                           % Revolution Rate
zeta = 0.2;                         % Colonies Mean Cost Coefficient

%% Mutation Parameters
r = abs(VarMax-VarMin)*0.4;        % Initial Hypersphere Radius
rdamp = 1; % Hypersphere Radius Damping Ratio
noSuccessfulDomination = 0;

%% Initialization
% Initialize Empires
emp = CreateInitialEmpires(CostFunction,funId,params,alpha,zeta);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);
ct = 0; % # of cost function evaluation
%% ICA Main Loop
for it=1:MaxIt   
%     if ct>maxfeval
%          break;
%     end
    
    % Assimilation
    emp = AssimilateColonies(emp,CostFunction,funId,params,beta);
    ct = ct + numel(emp) + sum([emp.nCol]);
    
    % Revolution
    emp = DoRevolution(emp,CostFunction,funId,params,pRevolution,mu);
    ct = ct + numel(emp) + sum([emp.nCol]);
     
    % Mutation - Regional Domination Policy
    if (setMutation) && (numel(emp)>3)
		[emp, cntr, isDominated] = RegionalDominationUsingHyperspheres(emp,objfunc,funId,params,rdamp);
		noSuccessfulDomination = noSuccessfulDomination + isDominated;
        ct = ct + cntr;
    end
    
    % Intra-Empire Competition
    emp = IntraEmpireCompetition(emp);
    
    % Update Total Cost of Empires
    emp = UpdateTotalCost(emp,zeta);
   
    % Inter-Empire Competition
    emp = InterEmpireCompetition(emp,alpha);
  
    % Update Best Solution Ever Found
    imp = [emp.Imp];
    [~, BestImpIndex] = min([imp.Cost]);
    BestSol = imp(BestImpIndex);
    
    % Update Best Cost
    BestCost(it) = BestSol.Cost;
    
    if BestCost(it)< params.tol
        break;
    end
    
    % Show Iteration Information
    %disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    %r = r*rdamp;
    rdamp = (MaxIt - it+1)/MaxIt;
end
xmin = BestSol.Position;
fmin = BestSol.Cost;
nFeval = ct;
iter = it;