function [minStr, maxStr, meanStr, stdStr] = generateStats(Sol)
d = 3; % d ondalýklý reel sayý
tol = 240;

% Min
[~,minInd] = min([Sol(:).fmin]);
minStr = num2str(Sol(minInd).fmin);
minStr = parseExponentialNumber(minStr,d,0,tol);

% Max
[~,maxInd] = max([Sol(:).fmin]);
maxStr = num2str(Sol(maxInd).fmin);
maxStr = parseExponentialNumber(maxStr,d,0,tol);

% Check underflowMeanFlag error
underflowMeanFlag=0; underflowStdFlag=0;
overflowMeanFlag=0; overflowStdFlag=0;
if mean([Sol(:).fmin]) < 10^(-tol)
    underflowMeanFlag = 1;
end
if std([Sol(:).fmin]) < 10^(-tol)
    underflowStdFlag = 1;
end

if mean([Sol(:).fmin]) > 10^tol
    overflowMeanFlag = 1;
end
if std([Sol(:).fmin]) > 10^tol
    overflowStdFlag = 1;
end

% Mean
if (underflowMeanFlag==0) && (overflowMeanFlag==0)
    meanStr = num2str(mean([Sol(:).fmin]));
    meanStr = parseExponentialNumber(meanStr,d,0,tol);
else
    if (underflowMeanFlag==1)
        meanStr = num2str(mean(10^tol*[Sol(:).fmin]));
        meanStr = parseExponentialNumber(meanStr,d,-1,tol);
    else % Overflow error
        meanStr = num2str(mean(10^(-tol)*[Sol(:).fmin]));
        meanStr = parseExponentialNumber(meanStr,d,1,tol);
    end
end

% Standard Deviation
if (underflowStdFlag==0) && (overflowStdFlag==0)
    stdStr = num2str(std([Sol(:).fmin]));
    stdStr = parseExponentialNumber(stdStr,d,0,tol);
else
    if (underflowStdFlag==1)
        stdStr = num2str(std(10^tol*[Sol(:).fmin]));
        stdStr = parseExponentialNumber(stdStr,d,-1,tol);
    else % Overflow error
        stdStr = num2str(std(10^(-tol)*[Sol(:).fmin]));
        stdStr = parseExponentialNumber(stdStr,d,1,tol);
    end
end
end