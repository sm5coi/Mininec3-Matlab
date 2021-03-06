function T12 = Gosub87Cmplx(I,J,K,SRM,P1,P2,P3,P4,XYZa,W,Ap4,Sa4,CSd,J2a,Wp,freq,geom)

% global CSd J2a Wp 

Sa = geom.Sa;
Wp = geom.Wp;
XYZa = geom.XYZa;
A = geom.A;
J2a = geom.J2a;

SRM = freq.SRM;
W = freq.W;


% 84 REM ----- ENTRIES REQUIRED FOR IMPEDANCE MATRIX CALCULATION
% 85 REM ----- S(M) GOES IN (X1,Y1,Z1) FOR SCALAR POTENTIAL
% 86 REM ----- MOD FOR SMALL RADIUS TO WAVE LENGTH RATIO
%    case 87  % From 283, 292, 300, 309 Impedance Matrix Calcualtion
FVS = 1;                    % 87 FVS=1
if K >= 1                   % 88 IF K<1 THEN 94
    if A(P4) <= SRM         % 89 IF A(P4)>SRM THEN 94
                            % 90 IF (P3=P2+1 AND P1=(P2+P3)/2) THEN 91 ELSE 94
        if  ((P3 == P2+1) && (P1 == (P2+P3)/2))
            T1 = 2*log(Sa(P4)/A(P4)); % 91 T1=2*LOG(S(P4)/A(P4))
            T2 = -W*Sa(P4); % 92 T2=-W*S(P4)
            T12 = complex(T1,T2);
            return          % 93 RETURN
        end
    end
end

I4=fix(P1);                 % 94 I4=INT(P1)
I5=I4+1;                    % 95 I5=I4+1
XYZ1 = (XYZa(I4,:)' + XYZa(I5,:)')/2;

[XYZ2,V123] = Gosub113Cmplx(K,P2,P3,XYZa,XYZ1);

T12 = Gosub135Cmplx(I,J,K,XYZ2,V123,P2,P3,CSd,J2a, Wp,SRM,FVS,W, A(P4), Sa(P4));

return