% Copyright (c) 2018, Korhan Gunel
% All rights reserved.
% Developer: Korhan Gunel (Adnan Menderes University, Department of Mathematics)
%
% Contact Info: kgunel@adu.edu.tr
%

tic;
clear; close; clc

T0 = getBaseTime;

%% Parameters
params.nEmp = 8;              % # of imperialist
params.nCol = 80;             % # of colony
params.low = -100;            % Lower bound
params.up  = 100;             % Upper bound
params.dim = 10;              % Size of the problem
params.Max_Iteration  = 100; % Maximum number of "iterations"
params.maxfeval = 10^6;
params.tol = realmin;
params.shift = 0;

method = 'ICA';
eps = realmin;       % Minimum value of Cost function (Stopping criteria)
nBenchmarkFunc = 2; % # of Benchmark Test Functions
maxTrials = 25;

empty_Sol.Problem.method = method;
empty_Sol.Problem.funName = '';
empty_Sol.Problem.nVar = 10;
empty_Sol.Problem.VarMin = -10;
empty_Sol.Problem.VarMax = 10;
empty_Sol.xmin = [];
empty_Sol.fmin = Inf;
empty_Sol.nFeval = 0;
empty_Sol.nIter = 0;
empty_Sol.noSuccessfulDomination = 0;
empty_Sol.BestCost = [];

objfunc = str2func('Cost');

%% Performance Analysis measures
dimensions = [2, 10, 30, 50, 100];
n = length(dimensions);
ef_0 = zeros(n,nBenchmarkFunc,maxTrials);
ef_1 = zeros(n,nBenchmarkFunc,maxTrials);
SE_0 = zeros(1,maxTrials);
SE_1 = zeros(1,maxTrials);
rank_0 = zeros(n,nBenchmarkFunc,maxTrials);
rank_1 = zeros(n,nBenchmarkFunc,maxTrials);
SR_0 = zeros(1,maxTrials);
SR_1 = zeros(1,maxTrials);
Score1_0 = zeros(1,maxTrials);
Score1_1 = zeros(1,maxTrials);
Score2_0 = zeros(1,maxTrials);
Score2_1 = zeros(1,maxTrials);
Score_0 = zeros(1,maxTrials);
Score_1 = zeros(1,maxTrials);


%% Main Program Block
for nVar = dimensions
    ind = find(dimensions==nVar);
    fid = fopen(['Results\Results_' num2str(nVar) '.txt'],'w+');
    params.dim = nVar;
    params.maxfeval = 10000*nVar;   % Maximum # of Cost function evalutaion (Stopping criteria)
    
    for funId=1:nBenchmarkFunc
        [funName, ~, VarMin, VarMax] = Cost(zeros(1,nVar),funId);
        fprintf('Cost Function : %s, Range : [%4.3f, %4.3f], Dimension : %d\n\n',funName,VarMin,VarMax,nVar);
        fprintf(fid,'Cost Function : %s, Range : [%4.3f, %4.3f], Dimension : %d\n\n',funName,VarMin,VarMax,nVar);
        
        %% ICA
        Sol_0=repmat(empty_Sol,maxTrials,1);
        setMutation = 0;
        fmin = zeros(1,maxTrials);
        nFeval = zeros(1,maxTrials);
        nIter = zeros(1,maxTrials);
        T = zeros(1,maxTrials);
        for k=1:maxTrials
            Sol_0(k).Problem.funName = funName;
            Sol_0(k).Problem.nVar = nVar;
            Sol_0(k).Problem.VarMin = VarMin;
            Sol_0(k).Problem.VarMax = VarMax;
            tic;
            [Sol_0(k).xmin,fmin(k),nFeval(k),nIter(k),Sol_0(k).BestCost,emp,~] = ica(objfunc,funId,params,setMutation);
            T(k) = toc;
            if nVar>2
                ef_0(ind,funId,k) = ef_0(ind,funId,k) + fmin(k);
            end
            Sol_0(k).fmin = fmin(k);
            Sol_0(k).nFeval = nFeval(k);
            Sol_0(k).nIter = nIter(k);
            Sol_0(k).elapsedTime = T(k);
        end
        T1 = mean(T);
        T2 = (T1 - min(T))/T0;
        
        % Display results
        [~,minInd_0] = min(fmin);
        [~,maxInd_0] = max(fmin);
        fprintf('\t%s after %d iterations : %d\n\n',method,Sol_0(minInd_0).nIter);
        fprintf(fid,'\t%s after %d iterations : %d\n\n',method,Sol_0(minInd_0).nIter);
        createReport(Sol_0,minInd_0,maxInd_0,fmin,T,fid);
        fprintf('\t Algorithm complexity measures: \n\t\t T1 : % f \n\t\t T2 = (mean(T) - min(T))/T0 : %f depending on base time T0 : %f seconds\n\n',T1,T2,T0);
        fprintf(fid,'\t Algorithm complexity measures: \n\t\t T1 : % f \n\t\t T2 = (mean(T) - min(T))/T0 : %f depending on base time T0 : %f seconds\n\n',T1,T2,T0);
        fprintf('\n');
        fprintf(fid,'\n');
        
        %% ICA with Regional Domination policy
        Sol_1=repmat(empty_Sol,maxTrials,1);
        setMutation=1;
        for k=1:maxTrials
            Sol_1(k).Problem.funName = funName;
            Sol_1(k).Problem.nVar = nVar;
            Sol_1(k).Problem.VarMin = VarMin;
            Sol_1(k).Problem.VarMax = VarMax;
            tic;
            [Sol_1(k).xmin,fmin(k),nFeval(k),nIter(k),Sol_1(k).BestCost,emp,Sol_1(k).noSuccessfulDomination] = ica(objfunc,funId,params,setMutation);
            T(k) = toc;
            if nVar>2
                ef_1(ind,funId,k) = ef_1(ind,funId,k) + fmin(k);
            end
            Sol_1(k).fmin = fmin(k);
            Sol_1(k).nFeval = nFeval(k);
            Sol_1(k).nIter = nIter(k);
            Sol_1(k).elapsedTime = T(k);
        end
        T1 = mean(T);
        T2 = (T1 - min(T))/T0;
        
        % Display results
        [~,minInd_1] = min(fmin);
        [~,maxInd_1] = max(fmin);
        fprintf('\t%s with mutation after %d iterations : %d\n',method,Sol_1(minInd_1).nIter);
        fprintf(fid,'\t%s with mutation after %d iterations : %d\n',method,Sol_1(minInd_1).nIter);
        createReport(Sol_1,minInd_1,maxInd_1,fmin,T,fid);
        fprintf('\t Algorithm complexity measures: \n\t\t T1 : % f \n\t\t T2 = (mean(T) - min(T))/T0 : %f depending on base time T0 : %f seconds\n\n',T1,T2,T0);
        fprintf(fid,'\t Algorithm complexity measures: \n\t\t T1 : % f \n\t\t T2 = (mean(T) - min(T))/T0 : %f depending on base time T0 : %f seconds\n\n',T1,T2,T0);
		fprintf(fid,'\tThe number of succesful Regional Domination operation : %d\n\n',Sol_1(minInd_1).noSuccessfulDomination);
        fprintf('\tThe number of succesful Regional Domination operation : %d\n\n',Sol_1(minInd_1).noSuccessfulDomination);
        fprintf('\n-----------------------------------------------------------------------\n\n');
        fprintf(fid,'\n-----------------------------------------------------------------------\n\n');
        
        % Saving Results
        save(['Results\' funName '_' num2str(nVar) '_Results.mat'],'Sol_0','Sol_1');
        
        % Plotting
        X = Sol_0(minInd_0).BestCost;
        X(X<0)=0;
        semilogy(X,'Color',myColorCodes(18),'LineWidth',1.5);
        hold on;
        X = Sol_1(minInd_1).BestCost;
        X(X<0)=0;
        semilogy(X,'Color',myColorCodes(22),'LineWidth',1.5);
        title('Cost Function','FontSize',12,'FontWeight','b');
        xlabel('Iteration','FontSize',12,'FontWeight','b');
        ylabel('Fitness(Best-so-far)','FontSize',12,'FontWeight','b');
        legend(method,[method ' using Regional Domination policy'],'FontSize',12,'FontWeight','b');
        hold off
        fig = gcf;
        fig.InvertHardcopy = 'on';
        savefig(fig, ['figs\Figure_Cost_' funName '_' num2str(nVar) '.fig']);
        print(fig,['figs\Figure_Cost_' funName '_' num2str(nVar) '.eps'],'-depsc','-r300');
        print(fig,['figs\Figure_Cost_' funName '_' num2str(nVar) '.jpg'],'-djpeg','-r300');
        close(fig);
    end
    
    % Calculate scores
    for k = 1:maxTrials
        SE_0(k) = SE_0(k) + nVar/sum(dimensions)*sum(ef_0(ind,:,k));
        SE_1(k) = SE_1(k) + nVar/sum(dimensions)*sum(ef_1(ind,:,k));
        if SE_0(k)< SE_1(k)
            Score1_0(k) = 50;
            Score1_1(k) = (1 - (SE_1(k) - SE_0(k))/SE_1(k))*50;
        else
            Score1_0(k) = (1 - (SE_0(k) - SE_1(k))/SE_0(k))*50;
            Score1_1(k) = 50;
        end
        
        if isnan(Score1_0(k))
            Score1_0(k)=0;
        end
        
        if isnan(Score1_1(k))
            Score1_1(k)=0;
        end
        
        for funId=1:nBenchmarkFunc
            if ef_0(ind,funId,k) < ef_1(ind,funId,k)
                rank_0(ind,funId,k)=1;
                rank_1(ind,funId,k)=2;
            else
                rank_0(ind,funId,k)=2;
                rank_1(ind,funId,k)=1;
            end
        end
        
        SR_0(k) = SR_0(k) +  nVar/sum(dimensions)*sum(rank_0(ind,:,k));
        SR_1(k) = SR_1(k) +  nVar/sum(dimensions)*sum(rank_1(ind,:,k));
        if SR_0(k)< SR_1(k)
            Score2_0(k) = 50;
            Score2_1(k) = (1 - (SR_1(k) - SR_0(k))/SR_1(k))*50;
        else
            Score2_0(k) = (1 - (SR_0(k) - SR_1(k))/SR_0(k))*50;
            Score2_1(k) = 50;
        end
        
        if isnan(Score2_0(k))
            Score2_0(k)=0;
        end
        
        if isnan(Score2_1(k))
            Score2_1(k)=0;
        end
        
        Score_0(k) = Score1_0(k) + Score2_0(k);
        Score_1(k) = Score1_1(k) + Score2_1(k);
    end
      
    fprintf('\n');
    fprintf(fid,'\n');
    fclose(fid);
    %% Create Tex Files
    createTexFile(nVar,nBenchmarkFunc,method,maxTrials);
    
end

%% Display Performance Scores
fid = fopen('Results\Scores.txt','w+');
fprintf(' Best of Score obtained from %s : %f\n Best Score obtained from %s with Regional Domination Policy : %f\n\n',method,max(Score_0),method,max(Score_1));
fprintf(' Worst of Score obtained from %s : %f\n Worst Score obtained from %s with Regional Domination Policy : %f\n\n',method,min(Score_0),method,min(Score_1));
fprintf(' Mean of Scores obtained from %s : %f %c %f\n Mean Scores obtained from %s with Regional Domination Policy : %f %c %f\n\n',method,mean(Score_0),char(177),std(Score_0),method,mean(Score_1),char(177),std(Score_1));
fprintf(fid,' Best of Score obtained from %s : %f\n Best Score obtained from %s with Regional Domination Policy : %f\n\n',method,max(Score_0),method,max(Score_1));
fprintf(fid,' Worst of Score obtained from %s : %f\n Worst Score obtained from %s with Regional Domination Policy : %f\n\n',method,min(Score_0),method,min(Score_1));
fprintf(fid,' Mean of Scores obtained from %s : %f %c %f\n Mean Scores obtained from %s with Regional Domination Policy : %f %c %f\n\n',method,mean(Score_0),char(177),std(Score_0),method,mean(Score_1),char(177),std(Score_1));
fclose(fid);