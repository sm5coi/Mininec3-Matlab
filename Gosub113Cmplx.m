function [XYZ2, V123] = Gosub113Cmplx(K,P1,P2,P3,XYZa)

XYZ1 = XYZa(P1,:)';

% 112 REM ----- S(U)-S(M) GOES IN (X2,Y2,Z2)
I4 = fix(P2);                           % 113 I4=INT(P2)
if I4 ~= P2                             % 114 IF I4=P2 THEN 120
    XYZ2 = [1 1 K]'.*(XYZa(I4,:)' + XYZa(I4+1,:)')/2 - XYZ1; 
else    % 119 GOTO 124
    XYZ2 = [1 1 K]'.*XYZa(P2,:)' - XYZ1;
end

% 123 REM ----- S(V)-S(M) GOES IN (V1,V2,V3)
I4 = fix(P3);                           % 124 I4=INT(P3)
if I4 ~= P3                             % 125 IF I4=P3 THEN 131
    V123 = [1 1 K]'.*(XYZa(I4,:)' + XYZa(I4+1,:)')/2 - XYZ1; 
else                                    % 130 GOTO 135
    V123 = [1 1 K]'.*XYZa(P3,:)' - XYZ1;
end

return
