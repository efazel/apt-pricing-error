% perror: measures the pricing error of the Arbitrage Pricing Theory by using a 
% a rolling window analysis for a single factor
%
% Author:        Ehsan Fazel (Concordia University)
% This version:  2019/02/12

% SYNTAX: 
%[Mean, SD, CI] = perror(returns, factor, w)
%
% INPUT
% returns       A matrix of asset return time series (T by N)
% factor        A vector of the time series of the factor (T by 1)
% w             Window length
%
% OUTPUT
% Mean          Mean of the pricing errors
% SD            Standard deviation of the pricing errors
% CI            95% confidence interval of the errors



function [Mean, SD, CI] = perror(returns, factor, w)

N = size(returns,2); %number of assets
t = size(returns,1); %dimesnion of the time series
M = t - w +1; %number of intervals
x = factor; %declaring the independent variable
alpha = ones(size(x,1),1); %creating the columns of one for the intercept
y = returns; %dependent variable

% creating the first row of windows for each firm
subsam = cell(M,N);
for j=1:N
    y2 = y(:,j);
    subsam{1,j} = [y2(1:w) alpha(1:w) x(1:w)]; 
end

% creating the rest of the rows
for r=1:N
    y3 = y(:,r);
         for p=1:M-1
             
             subsam{p+1,r}= [y3(1+p:w+p) alpha(1:w) x(1+p:w+p,:)];
             
         end
end

% creating cells for betas
betas = zeros(M,N);
alphas = zeros(M,N);
rsd = cell(204,12);
for h=1:N
for e=1:M
    Y = subsam{e,h}(:,1);
    X = subsam{e,h}(:,2:end);
    [b,bint,r] = regress(Y,X);
    rsd{e,h} = r;
    betas(e,h) = b(2,1);
    alphas(e,h) = b(1,1);
end
end

% getting the idiosyncratic risks
sigm = zeros(204,12);
for i=1:N
    for j=1:M
       rsd_vec = rsd{j,i}; 
       sigm(j,i) = sqrt(var(rsd_vec));
    end
end

idio = mean(sigm);

% calculating a time series for the pricing error
p = zeros(M,1);
for i=1:M
    beta = betas(i,:);
    beta = beta';
    alpha = alphas(i,:);
    alpha = alpha';
    beta_star = [ones(size(returns,2),1), beta];
    p_2 = (1/N)*alpha'*(eye(N)-beta_star*inv(beta_star'*beta_star)*beta_star')*alpha;
    p(i,1) = sqrt(p_2);
end

% mean and s.d.
results =[mean(p) std(p)]; %mean and sd of the pricing errors
Mean = results(1,1);
SD = results(1,2);

% 95 confidence interval
SEM = std(p)/sqrt(length(p)); 
ts = tinv([0.025  0.975],length(x)-1); % T-Score
CI = mean(p) + ts*SEM; %CI of PE for NC

end
