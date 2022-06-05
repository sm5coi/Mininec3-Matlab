function Beta_247_315Cmplx(I,J,K,J1,J2,T5,T6,T7,A,Sa,CSd,J2a,Wp,XYZa)

global F4 F5 F6 F7 F8 CABG W2 ZR ZI
global  SRM W 

% 247 REM ----- COMPUTE PSI(M,N,N+1/2)
P1 = 2*Wp(I) + I - 1;               % 248 P1=2*W%(I)+I-1
P2 = 2*Wp(J) + J - 1;               % 249 P2=2*W%(J)+J-1
P3 = P2 + 0.5;                      % 250 P3=P2+.5
P4 = J2;                            % 251 P4=J2
T12 = Gosub102Cmplx(I,J,K,SRM,P1,P2,P3,XYZa,W,A(P4),Sa(P4),CSd,J2a,Wp); % 252 GOSUB 102
T1 = real(T12);
T2 = imag(T12);

U1 = F5*T1;                         % 253 U1=F5*T1
U2 = F5*T2;                         % 254 U2=F5*T2
U12 = F5*T12;

% 255 REM ----- COMPUTE PSI(M,N-1/2,N)
P3 = P2;                            % 256 P3=P2
P2 = P2 - 0.5;                      % 257 P2=P2-.5
P4 = J1;                            % 258 P4=J1
% 259 IF F8<2 THEN GOSUB 102
if F8 < 2
    T12 = Gosub102Cmplx(I,J,K,SRM,P1,P2,P3,XYZa,W,A(P4),Sa(P4),CSd,J2a,Wp);
    T1 = real(T12);
    T2 = imag(T12);
end 
V1 = F4*T1;                         % 260 V1=F4*T1
V2 = F4*T2;                         % 261 V2=F4*T2
V12 = F4*T12;

% 262 REM ----- S(N+1/2)*PSI(M,N,N+1/2) + S(N-1/2)*PSI(M,N-1/2,N)

% 266 REM ----- REAL PART OF VECTOR POTENTIAL CONTRIBUTION
XYZ3 = [1 1 K]'.*(U1*[1 1 F7]'.*CABG(J2,:)' + V1*[1 1 F6]'.*CABG(J1,:)');
d1 = W2*XYZ3'*[T5 T6 T7]';

% 271 REM ----- IMAGINARY PART OF VECTOR POTENTIAL CONTRIBUTION
XYZ3 = [1 1 K]'.*(U2*[1 1 F7]'.*CABG(J2,:)' + V2*[1 1 F6]'.*CABG(J1,:)');
d2 = W2*XYZ3'*[T5 T6 T7]';

[U1,U2] = Sub_273_312(I,J,K, J1, J2, T1, T2, U1, U2, P1, P3,CSd,J2a,Wp); %,);  J2a

% 313 REM ----- SUM INTO IMPEDANCE MATRIX
ZR(I,J)=ZR(I,J)+K*(d1+U1);          % 314 ZR(I,J)=ZR(I,J)+K*(D1+U1)
ZI(I,J)=ZI(I,J)+K*(d2+U2);          % 315 ZI(I,J)=ZI(I,J)+K*(D2+U2)

return

