function X = randHypersphere(m,n,r,c)
 
% This function returns an m by n array, X, in which 
% each of the m rows has the n Cartesian coordinates 
% of a random point uniformly-distributed over the 
% interior of an n-dimensional hypersphere with 
% radius r and center c.  
% The function 'randn' is initially used to generate m sets of n 
% random variables with independent multivariate 
% normal distribution, with mean 0 and variance 1.
% Then the incomplete gamma function, 'gammainc', 
% is used to map these points radially to fit in the 
% hypersphere of finite radius r with a uniform 
% spatial distribution.
% Korhan Günel 02.03.2017 
% Updated from randsphere by Roger Stafford - 12/23/05
 
%% Generate data with Sobol sequence
leapInd = randi(12);
skipInd = randi(12);
Q = qrandstream('sobol',n,'Leap',leapInd,'Skip',skipInd);
Y = qrand(Q,m);
% Transform Y into new data with 0 mean and 1 standard deviation for
% each column of Y
%{
for i=1:n
    mi = mean(Y(:,i));
    si = std(Y(:,i));
    Y(:,i) = (Y(:,i) - mi)*si; 
end
%}
X = Y;
%%
%X = randn(m,n);
s2 = sum(X.^2,2);
X = X.*repmat(r*(gammainc(s2/2,n/2).^(1/n))./sqrt(s2),1,n);

% Move each points according to the center c
for k=1:m
    X(k,:) = X(k,:) + c;
end