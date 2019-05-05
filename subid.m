%% Subidentification
function [At,Bt,Ct,Dt,x0t,S] = mysubid(y,u,s,n)
U = zeros(s,length(u)-s+1);
Y = zeros(s,length(y)-s+1);
for N = 1:(length(y)-s+1)
    Y(1:s,N) = y(N:N+s-1);
    U(1:s,N) = u(N:N+s-1);
end

PI_Proj = eye(length(y)-s+1)- U'*inv(U*U')*U;
[U,S] = svd(Y*PI_Proj);
Ct = U(1,1:n);
At = pinv(U(1:(s-1),1:n))*U(2:s,1:n);

for k=0:length(y)-1
    LL= zeros(1,n);
    for tau=0:k-1
        LL =  LL + u(tau+1)'.*Ct*At^(k-tau-1);
    end
    PSI(k+1,:) = [Ct*At^k, LL, u(k+1)']';
end

H = PSI'*PSI*2;
f = -2*y'*PSI;

theta = quadprog(H,f);

x0t=theta(1:n);
Bt = theta(n+1:n+n);
Dt = theta(n+n+1:end);
end