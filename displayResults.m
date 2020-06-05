function displayResults(x,y,yt,caption,label,exampleNo,params,setMutation)
  n = length(x);
  MSE = sum((y-yt).^2)/n;
  N = params.nEmp + params.nCol; % # of individuals 
  m = params.noNeurons; % # of neurons 
  Low = params.low; % lower bound of search space  
  Up = params.up;  % upper bound of search space
  Dim = params.dim; % dimension of search space
  max_it = params.Max_Iteration;  % Maximum number of iteration
  
  fileID=fopen(['tex\table_' num2str(setMutation) '.tex'],'w+');
  fprintf(fileID,'\\begin{table}[ht]\n');
  fprintf(fileID,['  \\caption{Parameters for Example ' num2str(exampleNo) '}\n']);
  fprintf(fileID,'  \\centering\n');
  fprintf(fileID,'  \\begin{tabular}{rr}\n');
  fprintf(fileID,'    \\hline\\hline\n');
  fprintf(fileID,'    %s & %s \n','Parameter','Value\\');
  fprintf(fileID,'    %s & %d\\ \n','Number of Agents',N);
  fprintf(fileID,'    %s & %d\\ \n','Number of neurons',m);
  fprintf(fileID,'    %s & [%d, %d]\\ \n','Range of search space',Low,Up);
  fprintf(fileID,'    %s & %d\\ \n','Dimension of search space',Dim);
  fprintf(fileID,'    %s & %d\\ \n','Maximum Iteration',max_it);
  fprintf(fileID,'    \\hline\n');
  fprintf(fileID,'  \\end{tabular}\n');
  fprintf(fileID,'  \\label{%s}\n',label);
  fprintf(fileID,'\\end{table}\n');  
  
  fprintf(fileID,'\\begin{figure}\n');
  fprintf(fileID,'  \\centering\n');
  fprintf(fileID,['  \\includegraphics[width=7cm]{Figure_Ex0' num2str(exampleNo) '_a.eps}\n0'] );
  fprintf(fileID,['  \\caption{}\\label{Figure_Ex0' num2str(exampleNo) '_a}\n']);
  fprintf(fileID,'\\end{figure}\n');

  fprintf(fileID,'\\begin{figure}\n');
  fprintf(fileID,'  \\centering\n');
  fprintf(fileID,['  \\includegraphics[width=7cm]{Figure_Ex0' num2str(exampleNo) '_b.eps}\n']);
  fprintf(fileID,['  \\caption{}\\label{Figure_Ex0' num2str(exampleNo) '_b}\n']);
  fprintf(fileID,'\\end{figure}\n');
  
  fprintf(fileID,'\\begin{table}[ht]\n');
  fprintf(fileID,'  \\caption{%s}\n',caption);
  fprintf(fileID,'  \\centering\n');
  fprintf(fileID,'  \\begin{tabular}{rcccc}\n');
  fprintf(fileID,'    %s & %s & %s & %s & %s\n','$k$','$x_{k}$','$y_{k}$','$y_{T_{k}}$','$E=|y_{k} - y_{T_{k}}|$\\');
  fprintf(fileID,'    \\hline\\hline\n');
  fprintf('\n k   x(k)        y(k)           yt(k)       E = |y(k) - yt(k)|\n');
  fprintf('--------------------------------------------------------------\n');
  for k=1:n
      fprintf('%2d %6.3f %14.3e %14.3e %15.3e\n',k,x(k),y(k),yt(k),abs(y(k)-yt(k)));
      fprintf(fileID,'    %2d & %6.3f & %14.3e & %14.3e  & %15.3e\\\\ \n',k,x(k),y(k),yt(k),abs(y(k)-yt(k)));
  end
  fprintf('--------------------------------------------------------------\n\n');
  fprintf('Mean Squared Error : %1.3e\n',MSE);
  fprintf(fileID,'    \\hline\n');
  fprintf(fileID,'     \\multicolumn{5}{l}{\\textbf{Mean Squared Error :} %1.14e}\\\\ \n',MSE);
  fprintf(fileID,'  \\end{tabular}\n');
  fprintf(fileID,'  \\label{%s}\n',label);
  fprintf(fileID,'\\end{table}\n');  

  fclose(fileID); 
end