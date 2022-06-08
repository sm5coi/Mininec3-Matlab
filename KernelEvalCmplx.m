function [T34] = KernelEvalCmplx(K, XYZ2, V123, T, W, SRM, I6u, T34, Ap4)

A2 = Ap4*Ap4;  % Ap4 = A(P4), A = wire radii, P4 

% 27 REM ********** KERNEL EVALUATION OF INTEGRALS I2 & I3 **********
if K >= 0                           % 28 IF K<0 THEN 33
    XYZ3 = XYZ2 + T*(V123 - XYZ2);
else % 32 GOTO 36
    XYZ3 = V123 + T*(XYZ2 - V123);
end

D3 = norm(XYZ3)^2;              % 36 D3=X3*X3+Y3*Y3+Z3*Z3

% 37 REM ----- MOD FOR SMALL RADIUS TO WAVELENGTH RATIO

if Ap4 <= SRM                 % 38 IF A(P4)<=SRM THEN D=SQR(D3):GOTO 49
    D = sqrt(D3);
else
    D = sqrt(D3 + A2); % 39 D=D3+A2  % 40 IF D>0 THEN D=SQR(D)
    % 41 REM ----- CRITERIA FOR USING REDUCED KERNEL
    if I6u ~= 0 % 42 IF I6!=0 THEN 49
        % 43 REM ----- EXACT KERNEL CALCULATION WITH ELLIPTIC INTEGRAL
        % m = 1 - beta^2 = (sm -s')^2/((sm - s')^2 + 4a^2) in Eq 17 page 8
        B=D3/(D3 + 4*A2); % 44 B=D3/(D3+4*A2) 
        V0 = EllipticIntegral(B); % LINE 45, 46 and 47
        V0 = V0*sqrt(1 - B);
        % 48 T3=T3+(V0+LOG(D3/(64*A2))/2)/P/A(P4)-1/D
        T34 = T34 + (V0 + log(D3/(64*A2))/2)/pi/Ap4 - 1/D;
    end
end
B1=D*W;                             % 49 B1=D*W

% 50 REM ----- EXP(-J*K*R)/R
T34 = T34 + complex(cos(B1), -sin(B1))/D; % 51 T3=T3+COS(B1)/D  % 52 T4=T4-SIN(B1)/D
return                              % 53 RETURN
