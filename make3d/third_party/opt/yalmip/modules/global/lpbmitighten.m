% *************************************************************************
% Bound strengthening, here is where we actually solve LPs
% *************************************************************************
function [p,feasible,lower] = lpbmitighten(p,lower,upper,lpsolver)

% Construct problem with only linear terms
% and add cuts from lower/ upper bounds

p_test = p;
p_test.F_struc = p.lpcuts;
p_test.K.l = size(p.lpcuts,2);
p_test.K.f = 0;
p_test.K.s = 0;
p_test.K.q = 0;
if ~isnan(lower)
    p_test.F_struc = [-(p.lower-abs(p.lower)*0.01)+p.f p_test.c';p_test.F_struc];
end
if upper < inf
    p_test.F_struc = [upper+abs(upper)*0.01-p.f -p_test.c';p_test.F_struc];
end
if ~isempty(p.bilinears)
    p_test = addmcgormick(p_test);
end

%aa = p_test.F_struc(7,:);;
%p_test.F_struc = [];%p_test.F_struc(7,:);

p_test.K.l = size(p_test.F_struc,1);
p_test.F_struc = [p.F_struc(1:1:p.K.f,:);p_test.F_struc];
p_test.K.f = p.K.f;

feasible = 1;

% Perform reduction on most violating approximations at current solution
if p.options.bmibnb.lpreduce ~= 1
    n = ceil(max(p.options.bmibnb.lpreduce*length(p_test.linears),1));
    res = zeros(length(p.lb),1);
    for i = 1:size(p.bilinears,1)
        res(p.bilinears(i,2)) = res(p.bilinears(i,2)) + abs( p.x0(p.bilinears(i,1))-p.x0(p.bilinears(i,2)).*p.x0(p.bilinears(i,3)));
        res(p.bilinears(i,3)) = res(p.bilinears(i,3)) + abs( p.x0(p.bilinears(i,1))-p.x0(p.bilinears(i,2)).*p.x0(p.bilinears(i,3)));
    end
    res = res(p.linears);
    [ii,jj] = sort(abs(res));
    jj = jj(end-n+1:end);
else
    jj=1:length(p_test.linears);
end

j = 1;
while feasible & j<=length(jj)
    i = p_test.linears(jj(j));
    if abs(p.ub(i)-p.lb(i)>0.1)
        p_test.c = eyev(length(p_test.c),i);

        output = feval(lpsolver,p_test);
        if output.problem == 0
            if p_test.lb(i) < output.Primal(i)-1e-5
                p_test.lb(i) = output.Primal(i);
                p_test = updateonenonlinearbound(p_test,i);
            end
            p_test.c = -p_test.c;
            output = feval(lpsolver,p_test);
            if output.problem == 0
                if p_test.ub(i) > output.Primal(i)+1e-5
                    p_test.ub(i) = output.Primal(i);
                    p_test = updateonenonlinearbound(p_test,i);
                end
            end
            if output.problem == 1
                feasible = 0;
            end
        end
        if output.problem == 1
            feasible = 0;
        end
    end
    j = j + 1;
end
p_test = clean_bounds(p_test);
p.lb = p_test.lb;
p.ub = p_test.ub;