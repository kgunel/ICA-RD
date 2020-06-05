function createTexFile(nVar,nBenchmarkFunc,method,maxTrials)

fileName = ['Results_' num2str(nVar)];
fid = fopen(['tex\' fileName '.tex'],'w+');

%fprintf(fid,'\\begin{table}[htbp]\n');
fprintf(fid,'\\centering{\n');
caption = [' \caption{The experimental results of ' method ' method with/without mutation operation over ' num2str(maxTrials) ' independent runs on $f_1 - f_{' num2str(nBenchmarkFunc)...
    '}$ benchmark functions of ' ...
    num2str(nVar) ' variables.}'];
label = ['\label{tbl:results_' num2str(nVar) '}'];
fprintf(fid,' \\begin{small}\n');
fprintf(fid,'  \\begin{longtable}{cccc}\n');
fprintf(fid,'%s\n',[caption ' ' label ' \\']);
fprintf(fid,['     \\textbf{$f$-Id}  &  \\textbf{Results}  &  \\textbf{' method '}  &  \\textbf{' method ' with mutation}    \\\\ \n']);
fprintf(fid,'     \\hline\n');

for funId = 1:nBenchmarkFunc
  [funName, ~, ~, ~] = Cost(zeros(1,nVar),funId);
  dataFile = ['Results\' funName '_' num2str(nVar) '_Results.mat'];
  load(dataFile);
  
  [Sol_0_min_str, Sol_0_max_str, Sol_0_mean_str, Sol_0_std_str] = generateStats(Sol_0);
  [Sol_1_min_str, Sol_1_max_str, Sol_1_mean_str, Sol_1_std_str] = generateStats(Sol_1);
  
  fprintf(fid,'     \\multirow{4}{*}{$f_{%d}$} & $f_{\\text{Min}}$   & %s & %s  \\\\ \n',funId, Sol_0_min_str, Sol_1_min_str );
  fprintf(fid,'                              & $f_{\\text{Worst}}$ & %s & %s  \\\\ \n', Sol_0_max_str,  Sol_1_max_str);
  fprintf(fid,'                              & $f_{\\text{Mean}}$  & %s & %s  \\\\ \n', Sol_0_mean_str, Sol_1_mean_str );
  fprintf(fid,'                              & $f_{\\text{StDev}}$ & %s & %s  \\\\ \n', Sol_0_std_str, Sol_1_std_str );
  fprintf(fid,'     \\hline\n');
end
fprintf(fid,'   \\end{longtable}\n');
fprintf(fid,'  \\end{small}\n');
%fprintf(fid,'\\end{table}\n');
fprintf(fid,'}\n');
fclose(fid);
end