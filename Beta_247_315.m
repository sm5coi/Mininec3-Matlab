function Beta_247_315(I,J,K,J1,J2,T5,T6,T7,A,Sa)

global Wp F4 F5 F6 F7 F8 CABG W2 ZR ZI
global  SRM W Xa Ya Za 

% 247 REM ----- COMPUTE PSI(M,N,N+1/2)
P1 = 2*Wp(I) + I - 1;               % 248 P1=2*W%(I)+I-1
P2 = 2*Wp(J) + J - 1;               % 249 P2=2*W%(J)+J-1
P3 = P2 + 0.5;                      % 250 P3=P2+.5
P4 = J2;                            % 251 P4=J2
[T1, T2] = Gosub102(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,A(P4),Sa(P4)); % 252 GOSUB 102
U1 = F5*T1;                         % 253 U1=F5*T1
U2 = F5*T2;                         % 254 U2=F5*T2

% 255 REM ----- COMPUTE PSI(M,N-1/2,N)
P3 = P2;                            % 256 P3=P2
P2 = P2 - 0.5;                      % 257 P2=P2-.5
P4 = J1;                            % 258 P4=J1
% 259 IF F8<2 THEN GOSUB 102
if F8 < 2, [T1, T2] = Gosub102(I,J,K,SRM,P1,P2,P3,Xa,Ya,Za,W,A(P4),Sa(P4)); end 
V1 = F4*T1;                         % 260 V1=F4*T1
V2 = F4*T2;                         % 261 V2=F4*T2

% 262 REM ----- S(N+1/2)*PSI(M,N,N+1/2) + S(N-1/2)*PSI(M,N-1/2,N)

% 266 REM ----- REAL PART OF VECTOR POTENTIAL CONTRIBUTION
X3 = U1*CABG(J2,1) + V1*CABG(J1,1); % 263 X3=U1*CA(J2)+V1*CA(J1)
Y3 = U1*CABG(J2,2) + V1*CABG(J1,2); % 264 Y3=U1*CB(J2)+V1*CB(J1)
% 265 Z3=(F7*U1*CG(J2)+F6*V1*CG(J1))*K
Z3 = (F7*U1*CABG(J2,3) + F6*V1*CABG(J1,3))*K;
D1=W2*(X3*T5+Y3*T6+Z3*T7);          % 267 D1=W2*(X3*T5+Y3*T6+Z3*T7)

% 271 REM ----- IMAGINARY PART OF VECTOR POTENTIAL CONTRIBUTION
X3=U2*CABG(J2,1)+V2*CABG(J1,1);     % 268 X3=U2*CA(J2)+V2*CA(J1)
Y3=U2*CABG(J2,2)+V2*CABG(J1,2);     % 269 Y3=U2*CB(J2)+V2*CB(J1)
% 270 Z3=(F7*U2*CG(J2)+F6*V2*CG(J1))*K
Z3=(F7*U2*CABG(J2,3)+F6*V2*CABG(J1,3))*K;
D2=W2*(X3*T5+Y3*T6+Z3*T7);          % 272 D2=W2*(X3*T5+Y3*T6+Z3*T7)

[U1,U2] = Sub_273_312(I,J,K, J1, J2, T1, T2, U1, U2, P1, P3);

% 313 REM ----- SUM INTO IMPEDANCE MATRIX
ZR(I,J)=ZR(I,J)+K*(D1+U1);          % 314 ZR(I,J)=ZR(I,J)+K*(D1+U1)
ZI(I,J)=ZI(I,J)+K*(D2+U2);          % 315 ZI(I,J)=ZI(I,J)+K*(D2+U2)

return

