function fail = regress_bmibnb_gamsrobot(ops)

x1 = sdpvar(1,1);
x2 = sdpvar(1,1);
x3 = sdpvar(1,1);
x4 = sdpvar(1,1);
x5 = sdpvar(1,1);
t = sdpvar(1,1);
p = 42*x1-50*x1^2+44*x2-50*x2^2+45*x3-50*x3^2+47*x4-50*x4^2+47.5*x5-50*x5^2;
F = set([20 12 11 7 4]*[x1;x2;x3;x4;x5] < 40) + set(0<[x1;x2;x3;x4;x5]<1);
obj = p;

sol = solvesdp(F,obj,ops);

fail=getfail(sol.problem,double(obj),-17,checkset(F));