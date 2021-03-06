function T12 = Gosub135Cmplx(I,J,K,XYZ2,V123,P2,P3,CSd,J2a,Wp,SRM,FVS,W,Ap4,Sa4)

Q = [0.288675135, 0.5, 0.430568156, 0.173927423, 0.169990522, ...
    0.326072577, 0.480144928, 0.050614268, 0.398333239, 0.111190517, ...
    0.262766205, 0.156853323, 0.091717321, 0.181341892];

% 134 REM ----- MAGNITUDE OF S(U) - S(M)
D0 = norm(XYZ2);

% 136 REM ----- MAGNITUDE OF S(V) - S(M)
D3 = norm(V123);

% 142 REM ----- MAGNITUDE OF S(V) - S(U)
S4 = (P3 - P2)*Sa4;          % 143 S4=(P3-P2)*S(P4)

% 144 REM ----- ORDER OF INTEGRATION
% 145 REM ----- LTH ORDER GAUSSIAN QUADRATURE
T12 = 0 + 0i;
I6u = 0;                        % 148 I6!=0
F2 = 1;                         % 149 F2=1
L = 7;                          % 150 L=7
T = (D0 + D3)/Sa4;           % 151 T=(D0+D3)/S(P4)

% 152 REM ----- CRITERIA FOR EXACT KERNEL Csd == 'N', N = NEAR FIELD
if (T > 1.1) || (CSd == 'N')  % 153 IF T>1.1 THEN 165 % 154 IF C$="N" THEN 165
    if T > 6, L = 3; end        % 165 IF T>6 THEN L=3
    if T > 10, L = 1; end       % 166 IF T>10 THEN L=1
else
    if  (J2a(Wp(I),1) == J2a(Wp(J),1)) || ...       % 155
            (J2a(Wp(I),1) == J2a(Wp(J),2)) || ...   % 156
            (J2a(Wp(I),2) == J2a(Wp(J),1)) || ...   % 157
            (J2a(Wp(I),2) == J2a(Wp(J),2))          % 158
        if Ap4 <= SRM                     % 160 IF A(P4)>SRM THEN 162
            if FVS == 1  % 161 IF FVS=1 THEN 91 ELSE 106
                T12 = complex(2*log(Sa4/Ap4), -W*Sa4);
                return                  % 93 RETURN
            else
                T12 = complex(log(Sa4/Ap4), -W*Sa4/2);
                return                  % 108 RETURN
            end
        end
        F2=2*(P3-P2);                   % 162 F2=2*(P3-P2)
        I6u=(1-log(S4/F2/8/Ap4))/pi/Ap4;  % 163 I6!=(1-LOG(S4/F2/8/A(P4)))/P/A(P4)
    else                                % 159 GOTO 165
        if T > 6, L = 3; end            % 165 IF T>6 THEN L=3
        if T > 10, L = 1; end           % 166 IF T>10 THEN L=1
    end                                 % 164 GOTO 167
end
I5 = L + L;                             % 167 I5=L+L
while 1
    T34 = 0 + 0i;
    T=(Q(L)+0.5)/F2;                     % 170 T=(Q(L)+.5)/F2
    T34 = KernelEvalCmplx(K, XYZ2, V123, T, W, SRM, I6u, T34, Ap4);
    T=(0.5-Q(L))/F2;                     % 172 T=(.5-Q(L))/F2
    T34 = KernelEvalCmplx(K, XYZ2, V123, T, W, SRM, I6u, T34, Ap4);
    L=L+1;                              % 174 L=L+1
    T12 = T12 + Q(L)*T34;
    L=L+1;                              % 177 L=L+1
    if L >= I5, break; end              % 178 IF L<I5 THEN 168
end
T12 = S4*(T12 + (I6u + 0i));
return % 181 RETURN
 
