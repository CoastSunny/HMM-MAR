function [XX,Y] = formautoregr(X,T,orders,maxorder,zeromean,single_format)
%
% form regressor and response for the autoregression;
% residuals are assumed to have size T(in)-order in each trial 
% 
% Author: Diego Vidaurre, OHBA, University of Oxford
 
N = length(T); ndim = size(X,2);
if nargin<5, zeromean = 1; end
if nargin<6, single_format = 0; end


if single_format
    XX = zeros(sum(T)-length(T)*maxorder,length(orders)*ndim+(~zeromean),'single');
else
    XX = zeros(sum(T)-length(T)*maxorder,length(orders)*ndim+(~zeromean));
end
if nargout==2
    Y = zeros(sum(T)-length(T)*maxorder,ndim);
end

t_cumulative = cumsum([0;T]);
for in=1:N
    t0 = t_cumulative(in); 
    s0 = t0 - maxorder*(in-1);

    if nargout==2
        Y(s0+1:s0+T(in)-maxorder,:) = X(t0+maxorder+1:t0+T(in),:);
    end
    for i=1:length(orders)
        o = orders(i);
        if single_format
            XX(s0+1:s0+T(in)-maxorder,(1:ndim)+(i-1)*ndim+(~zeromean)) = ...
                single(X(t0+maxorder-o+1:t0+T(in)-o,:));
        else
            XX(s0+1:s0+T(in)-maxorder,(1:ndim)+(i-1)*ndim+(~zeromean)) = ...
                X(t0+maxorder-o+1:t0+T(in)-o,:);
        end
    end
end
if ~zeromean, XX(:,1) = 1; end
end