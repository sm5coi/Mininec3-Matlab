function Zmn = Beta_247_315Cmplx(I,J,K,J1,J2,F4,F5,F6,F7,F8,dRm,Zmn,freq,geom)

global fidPsiZ

% fprintf('%d %d %d %d %d %d %d %d \n',I,J,K,F4,F5,F6,F7,F8)

% 247 REM ----- COMPUTE PSI(M,N,N+1/2)
P1 = 2*geom.Wp(I) + I - 1;               % 248 P1=2*W%(I)+I-1
P2 = 2*geom.Wp(J) + J - 1;               % 249 P2=2*W%(J)+J-1
P3 = P2 + 0.5;                      % 250 P3=P2+.5
P4 = J2;                            % 251 P4=J2
T12 = Gosub102Cmplx(I,J,K,P1,P2,P3,P4,freq,geom); % 252 GOSUB 102
U12 = F5*T12;

% 255 REM ----- COMPUTE PSI(M,N-1/2,N)
P3 = P2;                            % 256 P3=P2
P2 = P2 - 0.5;                      % 257 P2=P2-.5
P4 = J1;                            % 258 P4=J1
% 259 IF F8<2 THEN GOSUB 102
% if F8 < 2
    T12 = Gosub102Cmplx(I,J,K,P1,P2,P3,P4,freq,geom);
% end 
V12 = F4*T12;

fprintf(fidPsiZ,'\n %2d %2d %3d \t%.12f%+.10fi  %.12f%+.10fi',I,J,K,real(U12), imag(U12),real(V12),imag(V12));

% 262 REM ----- S(N+1/2)*PSI(M,N,N+1/2) + S(N-1/2)*PSI(M,N-1/2,N)

% 266 REM ----- REAL PART OF VECTOR POTENTIAL CONTRIBUTION

% 271 REM ----- IMAGINARY PART OF VECTOR POTENTIAL CONTRIBUTION

% compare with eq 27, the first line, k^2(r ....)*(s ....)
V = freq.W2*dRm'*([1 1 K]'.*(U12*[1 1 F7]'.*geom.CABG(J2,:)' + V12*[1 1 F6]'.*geom.CABG(J1,:)'));

U12 = Sub_273_312Cmplx(I,J,K,J1,J2,F5,F8,T12,U12,P1,P3,freq,geom); %,);  J2a

% 313 REM ----- SUM INTO IMPEDANCE MATRIX
Zmn(I,J) = Zmn(I,J) + K*(V + U12);

return

