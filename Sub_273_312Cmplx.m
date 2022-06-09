function U12 = Sub_273_312Cmplx(I,J,K,J1,J2,F5,F8,T12,U12,P1,P3,freq,geom)

global   fidPsiZ

% 273 REM ----- COMPUTE PSI(M+1/2,N,N+1)
P1=P1+.5;                           % 274 P1=P1+.5
% if F8 == 2                          % 275 IF F8=2 THEN P1=P1-1
%     P1 = P1 - 1;
% end       
P2=P3;                              % 276 P2=P3
P3=P3+1;                            % 277 P3=P3+1
P4=J2;                              % 278 P4=J2
% if F8 ~= 1                          % 279 IF F8<>1 THEN 283
    T12 = Gosub87Cmplx(I,J,K,P1,P2,P3,P4,freq,geom); % 283 GOSUB 87
%     if F8 < 2                       % 284 IF F8<2 THEN 288
        U56 = T12;
%     else
%         U12 = (2*T12 - 4*F5*U12)/geom.Sa(J1);
%         return
%     end
% else
%     U56 = F5*U12 +T12;
% end                                 % 282 GOTO 291
% 290 REM ----- COMPUTE PSI(M-1/2,N,N+1)
P1=P1-1;                                            % 291 P1=P1-1
T12 = Gosub87Cmplx(I,J,K,P1,P2,P3,P4,freq,geom);   % 292 GOSUB 87
U12 = (T12-U56)/geom.Sa(J2);

fprintf(fidPsiZ,' \t%.12f%+.10fi  %.12f%+.10fi',real(U56), imag(U56),real(T12),imag(T12));


% 295 REM ----- COMPUTE PSI(M+1/2,N-1,N)
P1=P1+1;                                            % 296 P1=P1+1
P3=P2;                                              % 297 P3=P2
P2=P2-1;                                            % 298 P2=P2-1
P4=J1;                                              % 299 P4=J1
T12 = Gosub87Cmplx(I,J,K,P1,P2,P3,P4,freq,geom);   % 300 GOSUB 87
U34 = T12;

% 303 REM ----- COMPUTE PSI(M-1/2,N-1,N)
% if F8 < 1                                           % 304 IF F8<1 THEN 308
    P1=P1-1;                                        % 308 P1=P1-1
    T12 = Gosub87Cmplx(I,J,K,P1,P2,P3,P4,freq,geom); % 309 GOSUB 87
% else
%     T12 = U56;
% end                                                 % 307 GOTO 311

fprintf(fidPsiZ,' \t%.12f%+.10fi  %.12f%+.10fi',real(U34), imag(U34),real(T12),imag(T12));

% 310 REM ----- GRADIENT OF SCALAR POTENTIAL CONTRIBUTION
U12 = U12 + (U34 - T12)/geom.Sa(J1);

return