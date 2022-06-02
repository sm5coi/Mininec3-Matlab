function [X2,Y2,Z2,V1,V2,V3] = Gosub113(K,P2,P3,Xa,Ya,Za, X1,Y1,Z1)

% 112 REM ----- S(U)-S(M) GOES IN (X2,Y2,Z2)
I4 = fix(P2);                           % 113 I4=INT(P2)
if I4 ~= P2                             % 114 IF I4=P2 THEN 120
    I5 = I4 + 1;                        % 115 I5=I4+1
    X2 = (Xa(I4) + Xa(I5))/2 - X1;      % 116 X2=(X(I4)+X(I5))/2-X1
    Y2 = (Ya(I4) + Ya(I5))/2 - Y1;      % 117 Y2=(Y(I4)+Y(I5))/2-Y1
    Z2 = K*(Za(I4) + Za(I5))/2 - Z1;    % 118 Z2=K*(Z(I4)+Z(I5))/2-Z1
else    % 119 GOTO 124
    X2 = Xa(P2) - X1;                   % 120 X2=X(P2)-X1
    Y2 = Ya(P2) - Y1;                   % 121 Y2=Y(P2)-Y1
    Z2 = K*Za(P2) - Z1;                 % 122 Z2=K*Z(P2)-Z1
end

% 123 REM ----- S(V)-S(M) GOES IN (V1,V2,V3)
I4 = fix(P3);                           % 124 I4=INT(P3)
if I4 ~= P3                             % 125 IF I4=P3 THEN 131
    I5 = I4 + 1;                        % 126 I5=I4+1
    V1 = (Xa(I4) + Xa(I5))/2 - X1;      % 127 V1=(X(I4)+X(I5))/2-X1
    V2 = (Ya(I4) + Ya(I5))/2 - Y1;      % 128 V2=(Y(I4)+Y(I5))/2-Y1
    V3 = K*(Za(I4) + Za(I5))/2 - Z1;    % 129 V3=K*(Z(I4)+Z(I5))/2-Z1
else                                    % 130 GOTO 135
    V1 = Xa(P3) - X1;                   % 131 V1=X(P3)-X1
    V2 = Ya(P3) - Y1;                   % 132 V2=Y(P3)-Y1
    V3 = K*Za(P3) - Z1;                 % 133 V3=K*Z(P3)-Z1
end

return
