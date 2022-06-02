function [U1, U2] = Sub_273_312(I,J,K, J1, J2, T1, T2, U1, U2, P1, P3)

global Sa F5 F8 SRM Xa Ya Za W A

% 273 REM ----- COMPUTE PSI(M+1/2,N,N+1)
P1=P1+.5;                           % 274 P1=P1+.5
if F8 == 2, P1 = P1 - 1; end        % 275 IF F8=2 THEN P1=P1-1
P2=P3;                              % 276 P2=P3
P3=P3+1;                            % 277 P3=P3+1
P4=J2;                              % 278 P4=J2
if F8 ~= 1                          % 279 IF F8<>1 THEN 283
    [T1,T2] = Gosub87(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,A(P4),Sa(P4)); % 283 GOSUB 87
    if F8 < 2                       % 284 IF F8<2 THEN 288
        U5=T1;                      % 288 U5=T1
        U6=T2;                      % 289 U6=T2
    else
        U1=(2*T1-4*U1*F5)/Sa(J1);   % 285 U1=(2*T1-4*U1*F5)/S(J1)
        U2=(2*T2-4*U2*F5)/Sa(J1);   % 286 U2=(2*T2-4*U2*F5)/S(J1)
        return
    end
else
    U5=F5*U1+T1;                    % 280 U5=F5*U1+T1
    U6=F5*U2+T2;                    % 281 U6=F5*U2+T2
end                                 % 282 GOTO 291
        % 290 REM ----- COMPUTE PSI(M-1/2,N,N+1)
P1=P1-1;                                            % 291 P1=P1-1
[T1,T2] = Gosub87(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,A(P4),Sa(P4));   % 292 GOSUB 87
U1=(T1-U5)/Sa(J2);                                  % 293 U1=(T1-U5)/S(J2)
U2=(T2-U6)/Sa(J2);                                  % 294 U2=(T2-U6)/S(J2)
        % 295 REM ----- COMPUTE PSI(M+1/2,N-1,N)
P1=P1+1;                                            % 296 P1=P1+1
P3=P2;                                              % 297 P3=P2
P2=P2-1;                                            % 298 P2=P2-1
P4=J1;                                              % 299 P4=J1
[T1,T2] = Gosub87(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,A(P4),Sa(P4));   % 300 GOSUB 87
U3=T1;                                              % 301 U3=T1
U4=T2;                                              % 302 U4=T2
        % 303 REM ----- COMPUTE PSI(M-1/2,N-1,N)
if F8 < 1                                           % 304 IF F8<1 THEN 308
    P1=P1-1;                                        % 308 P1=P1-1
    [T1,T2] = Gosub87(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,A(P4),Sa(P4)); % 309 GOSUB 87
else
    T1=U5;                                          % 305 T1=U5
    T2=U6;                                          % 306 T2=U6
end                                                 % 307 GOTO 311
        % 310 REM ----- GRADIENT OF SCALAR POTENTIAL CONTRIBUTION
U1=U1+(U3-T1)/Sa(J1);   % 311 U1=U1+(U3-T1)/S(J1)
U2=U2+(U4-T2)/Sa(J1);   % 312 U2=U2+(U4-T2)/S(J1)

return