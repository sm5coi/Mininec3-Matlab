function [T1, T2] = Gosub87(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,Ap4,Sa4,CSd,J2a,Wp)

% global CSd J2a Wp 

% 84 REM ----- ENTRIES REQUIRED FOR IMPEDANCE MATRIX CALCULATION
% 85 REM ----- S(M) GOES IN (X1,Y1,Z1) FOR SCALAR POTENTIAL
% 86 REM ----- MOD FOR SMALL RADIUS TO WAVE LENGTH RATIO
%    case 87  % From 283, 292, 300, 309 Impedance Matrix Calcualtion
FVS = 1;                    % 87 FVS=1
if K >= 1                   % 88 IF K<1 THEN 94
    if Ap4 <= SRM         % 89 IF A(P4)>SRM THEN 94
                            % 90 IF (P3=P2+1 AND P1=(P2+P3)/2) THEN 91 ELSE 94
        if  ((P3 == P2+1) && (P1 == (P2+P3)/2))
            T1 = 2*log(Sa4/Ap4); % 91 T1=2*LOG(S(P4)/A(P4))
            T2 = -W*Sa4; % 92 T2=-W*S(P4)
            return          % 93 RETURN
        end
    end
end
I4=fix(P1);                 % 94 I4=INT(P1)
I5=I4+1;                    % 95 I5=I4+1
X1 = (Xa(I4) + Xa(I5))/2;   % 96 X1=(X(I4)+X(I5))/2
Y1 = (Ya(I4) + Ya(I5))/2;   % 97 Y1=(Y(I4)+Y(I5))/2
Z1 = (Za(I4) + Za(I5))/2;   % 98 Z1=(Z(I4)+Z(I5))/2
% 99 GOTO 113
[X2,Y2,Z2,V1,V2,V3] = Gosub113(K,P2,P3,Xa,Ya,Za, X1,Y1,Z1);

[T1,T2] = Gosub135(I,J,K,X2,Y2,Z2,V1,V2,V3,P2,P3,CSd,J2a, Wp,SRM,FVS,W, Ap4, Sa4);

% [XYZ2,V123] = Gosub113Cmplx(K,P1,P2,P3,XYZa);
% 
% T12 = Gosub135Cmplx(I,J,K,XYZ2,V123,P2,P3,CSd,J2a, Wp,SRM,FVS,W, Ap4, Sa4);


return