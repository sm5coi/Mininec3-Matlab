function U12 = Sub_273_312Cmplx(I,J,K,J1,J2,T12,U12,P1,P3,CSd,freq,geom)

global F5 F8
%  A

SRM = freq.SRM;
W = freq.W;

Sa = geom.Sa;
Wp = geom.Wp;
XYZa = geom.XYZa;
A = geom.A;
J2a = geom.J2a;


% 273 REM ----- COMPUTE PSI(M+1/2,N,N+1)
P1=P1+.5;                           % 274 P1=P1+.5
if F8 == 2, P1 = P1 - 1; end        % 275 IF F8=2 THEN P1=P1-1
P2=P3;                              % 276 P2=P3
P3=P3+1;                            % 277 P3=P3+1
P4=J2;                              % 278 P4=J2
if F8 ~= 1                          % 279 IF F8<>1 THEN 283
    T12 = Gosub87Cmplx(I,J,K,SRM,P1,P2,P3,P4,XYZa,W,A(P4),Sa(P4),CSd,J2a,Wp,freq,geom); % 283 GOSUB 87
    if F8 < 2                       % 284 IF F8<2 THEN 288
        U56 = T12;
    else
        U12 = (2*T12 - 4*F5*U12)/Sa(J1);
        return
    end
else
    U56 = F5*U12 +T12;
end                                 % 282 GOTO 291
% 290 REM ----- COMPUTE PSI(M-1/2,N,N+1)
P1=P1-1;                                            % 291 P1=P1-1
T12 = Gosub87Cmplx(I,J,K,SRM,P1,P2,P3,P4,XYZa,W,A(P4),Sa(P4),CSd,J2a,Wp,freq,geom);   % 292 GOSUB 87
U12 = (T12-U56)/Sa(J2);
% 295 REM ----- COMPUTE PSI(M+1/2,N-1,N)
P1=P1+1;                                            % 296 P1=P1+1
P3=P2;                                              % 297 P3=P2
P2=P2-1;                                            % 298 P2=P2-1
P4=J1;                                              % 299 P4=J1
T12 = Gosub87Cmplx(I,J,K,SRM,P1,P2,P3,P4,XYZa,W,A(P4),Sa(P4),CSd,J2a,Wp,freq,geom);   % 300 GOSUB 87
U34 = T12;
% 303 REM ----- COMPUTE PSI(M-1/2,N-1,N)
if F8 < 1                                           % 304 IF F8<1 THEN 308
    P1=P1-1;                                        % 308 P1=P1-1
    T12 = Gosub87Cmplx(I,J,K,SRM,P1,P2,P3,P4,XYZa,W,A(P4),Sa(P4),CSd,J2a,Wp,freq,geom); % 309 GOSUB 87
else
    T12 = U56;
end                                                 % 307 GOTO 311
% 310 REM ----- GRADIENT OF SCALAR POTENTIAL CONTRIBUTION
U12 = U12 + (U34 - T12)/Sa(J1);

return