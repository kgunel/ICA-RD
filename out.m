function [X,Y] = out(h,a,A,b,B,p)
x = a:h:b;
X =  x;
Y = trialSolution(x,a,A,b,B,p);