function Zmn = Beta_247_315Cmplx(I,J,K,J1,J2,dRm,CSd,Zmn,freq,geom)

global F4 F5 F6 F7 F8

CABG = geom.CABG;
Sa = geom.Sa;
Wp = geom.Wp;
XYZa = geom.XYZa;
A = geom.A;
J2a = geom.J2a;


W = freq.W;
W2 = freq.W2;
SRM = freq.SRM;

% 247 REM ----- COMPUTE PSI(M,N,N+1/2)
P1 = 2*Wp(I) + I - 1;               % 248 P1=2*W%(I)+I-1
P2 = 2*Wp(J) + J - 1;               % 249 P2=2*W%(J)+J-1
P3 = P2 + 0.5;                      % 250 P3=P2+.5
P4 = J2;                            % 251 P4=J2
T12 = Gosub102Cmplx(I,J,K,P1,P2,P3,P4,CSd,freq,geom); % 252 GOSUB 102
U12 = F5*T12;

% 255 REM ----- COMPUTE PSI(M,N-1/2,N)
P3 = P2;                            % 256 P3=P2
P2 = P2 - 0.5;                      % 257 P2=P2-.5
P4 = J1;                            % 258 P4=J1
% 259 IF F8<2 THEN GOSUB 102
if F8 < 2
    T12 = Gosub102Cmplx(I,J,K,P1,P2,P3,P4,CSd,freq,geom);
end 
V12 = F4*T12;

% 262 REM ----- S(N+1/2)*PSI(M,N,N+1/2) + S(N-1/2)*PSI(M,N-1/2,N)

% 266 REM ----- REAL PART OF VECTOR POTENTIAL CONTRIBUTION

% 271 REM ----- IMAGINARY PART OF VECTOR POTENTIAL CONTRIBUTION

V = W2*dRm'*([1 1 K]'.*(U12*[1 1 F7]'.*CABG(J2,:)' + V12*[1 1 F6]'.*CABG(J1,:)'));

U12 = Sub_273_312Cmplx(I,J,K,J1,J2,T12,U12,P1,P3,CSd,freq,geom); %,);  J2a

% 313 REM ----- SUM INTO IMPEDANCE MATRIX
Zmn(I,J) = Zmn(I,J) + K*(V + U12);

return

