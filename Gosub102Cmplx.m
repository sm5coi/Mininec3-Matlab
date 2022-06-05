function T12 = Gosub102Cmplx(I,J,K,SRM,P1,P2,P3,XYZa,W,Ap4,Sa4,CSd,J2a,Wp)

% 100 REM ----- S(M) GOES IN (X1,Y1,Z1) FOR VECTOR POTENTIAL
% 101 REM ----- MOD FOR SMALL RADIUS TO WAVE LENGTH RATIO
% From 252, 259 in Impedance Matrix Calcualtion
FVS = 0;                    % 102 FVS=0
if K >= 1                   % 103 IF K<1 THEN 109
    if Ap4 < SRM          % 104 IF A(P4)>=SRM THEN 109
                            % 105 IF (I=J AND P3=P2+.5) THEN 106 ELSE 109
        if ((I == J) && (P3 == (P2+0.5)))
            T12 = complex(log(Sa4/Ap4), -W*Sa4/2); % LINE 106, 107
            return                      % 108 RETURN
        end
    end
end

[XYZ2,V123] = Gosub113Cmplx(K,P1,P2,P3,XYZa);

T12 = Gosub135Cmplx(I,J,K,XYZ2,V123,P2,P3,CSd,J2a, Wp,SRM,FVS,W, Ap4, Sa4);

return
