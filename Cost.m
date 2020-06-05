function [funName, y, lower, upper] = Cost(x, fun, shift)

% Function List
%     fun = 1  : Sphere          > f(x) = 0 for x = [0,0,...,0]
%     fun = 2  : Rastrigin       > f(x) = 0 for x = [0,0,...,0]
%     fun = 3  : Rosenbrock      > f(x) = 0 for x = [1,1,...,1]
%     fun = 4  : Griewank        > f(x) = 0 for x = [0,0,...,0]
%     fun = 5  : Ackley          > f(x) = 0 for x = [0,0,...,0]
%     fun = 6  : Dixon-Price     > f(x) = 0 for x(k) = 2^((2-2^k)/2^k)
%     fun = 7  : SumSquare       > f(x) = 0 for x = [0,0,...,0]
%     fun = 8  : DoubleSum       > f(x) = 0 for x(k) = k
%     fun = 9  : Schwefel's 1.2  > f(x) = 0 for x = [0,0,...,0]
%     fun = 10 : Schwefel's 2.21 > f(x) = 0 for x = [0,0,...,0]
%     fun = 11 : Schwefel's 2.22 > f(x) = 0 for x = [0,0,...,0]
%     fun = 12 : Zakharov        > f(x) = 0 for x = [0,0,...,0]
%     fun = 13 : Step No.1       > f(x) = 0 for x(k)>-1 and x(k)<1
%     fun = 14 : Step No.2       > f(x) = 0 for x(k)>=-0.5 and x(k)<0.5
%     fun = 15 : Step No.3       > f(x) = 0 for x(k)>-1 and x(k)<1
%     fun = 16 : Schwefel Function
%     fun = 17 : CrossLegTable   > f(x) =-1 for x = [0,0]
%     fun = 18 : Damavandi       > f(x) = 0 for x = [2,2]

if nargin < 1
    x = zeros(1,10);  % To get lower and upper bounds with no given input
end

if nargin < 2
    fun = 1;    % Function number from list
end

if nargin < 3
    shift = 0;  % Shifting amount for x
end

x = x - shift;  % Shift input
n = length(x);  % Dimension of function domain
y = 0;

switch(fun)

    case 1 % Sphere Function
        funName = 'Sphere';
        lower = -100; upper = 100;
        y = sum(x.^2);

    case 2 % Rastrigin Function
        funName = 'Rastrigin';
        lower = -5.12; upper = 5.12; 
        y = 10*n + sum(x.^2 - 10*cos(2*pi*x));

    case 3 % Rosenbrock Function
        funName = 'Rosenbrock';
        lower = -5; upper = 5;
        y = sum(100*(x(2:n)-x(1:n-1).^2).^2 + (1-x(1:n-1)).^2);

    case 4 % Griewank Function
        funName = 'Griewank';
        lower = -600; upper = 600;
        y = 1 + sum((x.^2)/4000) - prod(cos(x ./ sqrt(1:n)));

    case 5 % Ackley Function
        funName = 'Ackley';
        lower = -32.768; upper = 32.768;
        y = 20*(1 - exp(-0.2*sqrt((1/n)*sum(x.^2)))) ...
            - exp((1/n)*sum(cos(2*pi*x))) + exp(1);

    case 6 % Dixon-Price Function
        funName = 'Dixon-Price';
        lower = -10; upper = 10;
        y = sum((2:n).*(2*x(2:n).^2-x(1:n-1)).^2) + (x(1)-1)^2;

    case 7 % SumSquare Function
        funName = 'SumSquare';
        lower = -10; upper = 10;
        y = sum((1:n) .* x.^2);

    case 8 % DoubleSum Function
        funName = 'DoubleSum';
        lower = -100; upper = 100;
        for i=1:n, y = y + sum((x(1:i)-(1:i)).^2); end
        
    case 9 % Schwefel's 1.2 Function
        funName = 'Schwefel''s 1.2';      
        lower = -10; upper = 10;
        for i=1:n, y = y + (sum(x(1:i))).^2; end

    case 10 % Schwefel's 2.21 Function
        funName = 'Schwefel''s 2.21';       
        lower = -100; upper = 100;
        y = max(abs(x));

    case 11 % Schwefel's 2.22 Function
        funName = 'Schwefel''s 2.22';
        lower = -100; upper = 100;
        y = sum(abs(x)) + prod(abs(x));
%        y = sum(abs(x)) + vpa(prod(abs(sym(x))));
      
    case 12 % Zakharov Function
        funName = 'Zakharov';
        lower = -5; upper = 10;
        y = sum(x.^2) + (sum(.5*(1:n).*x))^2 + (sum(.5*(1:n).*x))^4;
        
    case 13 % Step Function No.1
        funName = 'Step Function No.1';
        lower = -100; upper = 100;
        y = sum(round(abs(x)));        
        
    case 14 % Step Function No.2
        funName = 'Step Function No.2';
        lower = -100; upper = 100;
        y = sum(round(x+0.5).^2);
               
    case 15 % Step Function No.3
        funName = 'Step Function No.3';
        lower = -100; upper = 100;
        y = sum(round(x.^2));
        
    case 16 % Schwefel Function
        funName = 'Schwefel';        
        lower = -500; upper = 500;
        y = 418.9829*n - sum(x .* sin(sqrt(abs(x))));
     
    case 17 % CrossLegTable Function
        funName = 'CrossLegTable';
        lower = -10; upper = 10;
        y = -(abs(sin(x(1)).*sin(x(2)).*exp(abs(100 ...
            - sqrt(x(1).^2+x(2).^2)/pi))) + 1).^(-0.1);

    case 18 % Damavandi Function
        funName = 'Damavandi';
        lower = -10; upper = 10;
        y = (1-(abs((sin(pi*(x(1)-2))*sin(pi*(x(2)-2))) ...
            /(pi*pi*(x(1)-2)*(x(2)-2)))).^5)*(2+(x(1)-7).^2+2*(x(2)-7).^2);
        
    otherwise % Sphere Function (as default)
        funName = 'Sphere'; 
        lower = -10; upper = 10;
        y = sum(x.^2);

end
y = y + shift;
end