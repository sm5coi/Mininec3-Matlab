function T12 = Gosub102Cmplx(I,J,K,P1,P2,P3,P4,CSd,freq,geom)

Sa = geom.Sa;
Wp = geom.Wp;
XYZa = geom.XYZa;
A = geom.A;
J2a = geom.J2a;

SRM = freq.SRM;
W = freq.W;

% 100 REM ----- S(M) GOES IN (X1,Y1,Z1) FOR VECTOR POTENTIAL
% 101 REM ----- MOD FOR SMALL RADIUS TO WAVE LENGTH RATIO
% From 252, 259 in Impedance Matrix Calcualtion
FVS = 0;                    % 102 FVS=0
if K >= 1                   % 103 IF K<1 THEN 109
    if A(P4) < SRM          % 104 IF A(P4)>=SRM THEN 109
                            % 105 IF (I=J AND P3=P2+.5) THEN 106 ELSE 109
        if ((I == J) && (P3 == (P2+0.5)))
            T12 = complex(log(Sa(P4)/A(P4)), -W*Sa(P4)/2); % LINE 106, 107
            return                      % 108 RETURN
        end
    end
end

XYZ1 = XYZa(P1,:)';

[XYZ2,V123] = Gosub113Cmplx(K,P2,P3,XYZa,XYZ1);

T12 = Gosub135Cmplx(I,J,K,XYZ2,V123,P2,P3,CSd,J2a, Wp,SRM,FVS,W, A(P4), Sa(P4));

return
