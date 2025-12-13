function [CurrX] = MatSolve(Z)

global FLG M N NS Cp Ea Ma La 
global CR CI
% 426 REM ********** SOLVE **********
CR = zeros(N,1);
CI = zeros(N,1);

for J = 1:NS                            % 432 FOR J=1 TO NS
    F2 = 1/M;                           % 433 	F2=1/M
    % 434 	IF C%(E(J),1)=-C%(E(J),2) THEN F2=2/M
    if Cp(Ea(J),1) == -Cp(Ea(J),2), F2 = 2/M; end
    CR(Ea(J)) = F2*Ma(J);               % 435 	CR(E(J))=F2*M(J)
    CI(Ea(J)) = -F2*La(J);              % 436 	CI(E(J))=-F2*L(J)
end                                     % 437 NEXT J

b = complex(CR,CI);

FLG = 2;

CurrX = Z\b;

save Slv

return
