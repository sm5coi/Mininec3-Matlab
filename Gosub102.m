function [T1, T2] = Gosub102(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,Ap4,Sa4)

global CSd J2a Wp 

% 100 REM ----- S(M) GOES IN (X1,Y1,Z1) FOR VECTOR POTENTIAL
% 101 REM ----- MOD FOR SMALL RADIUS TO WAVE LENGTH RATIO
% From 252, 259 in Impedance Matrix Calcualtion
FVS = 0;                    % 102 FVS=0
if K >= 1                   % 103 IF K<1 THEN 109
    if Ap4 < SRM          % 104 IF A(P4)>=SRM THEN 109
                            % 105 IF (I=J AND P3=P2+.5) THEN 106 ELSE 109
        if ((I == J) && (P3 == (P2+0.5)))
            T1 = log(Sa4/Ap4);     % 106 T1=LOG(S(P4)/A(P4))
            T2 = -W*Sa4/2;           % 107 T2=-W*S(P4)/2
            return                      % 108 RETURN
        end
    end
end
X1 = Xa(P1);                % 109 X1=X(P1)
Y1 = Ya(P1);                % 110 Y1=Y(P1)
Z1 = Za(P1);                % 111 Z1=Z(P1)

[X2,Y2,Z2,V1,V2,V3] = Gosub113(K,P2,P3,Xa,Ya,Za, X1,Y1,Z1);

[T1,T2] = Gosub135(I,J,K,X2,Y2,Z2,V1,V2,V3,P2,P3,CSd,J2a, Wp,SRM,FVS,W, Ap4, Sa4);

return
