function [T3, T4] = KernelEval(K, X2,Y2,Z2, V1,V2,V3, T, W, SRM, I6u, T3, T4, Ap4)

A2 = Ap4*Ap4;

% 27 REM ********** KERNEL EVALUATION OF INTEGRALS I2 & I3 **********
if K >= 0                           % 28 IF K<0 THEN 33
    X3=X2+T*(V1-X2);                % 29 X3=X2+T*(V1-X2)
    Y3=Y2+T*(V2-Y2);                % 30 Y3=Y2+T*(V2-Y2)
    Z3=Z2+T*(V3-Z2);                % 31 Z3=Z2+T*(V3-Z2)
else % 32 GOTO 36
    X3=V1+T*(X2-V1);                % 33 X3=V1+T*(X2-V1)
    Y3=V2+T*(Y2-V2);                % 34 Y3=V2+T*(Y2-V2)
    Z3=V3+T*(Z2-V3);                % 35 Z3=V3+T*(Z2-V3)
end
D3 = X3*X3 + Y3*Y3 + Z3*Z3;         % 36 D3=X3*X3+Y3*Y3+Z3*Z3

% 37 REM ----- MOD FOR SMALL RADIUS TO WAVELENGTH RATIO

if Ap4 <= SRM                 % 38 IF A(P4)<=SRM THEN D=SQR(D3):GOTO 49
    D = sqrt(D3);
else
    D = D3 + A2; % 39 D=D3+A2
    if D > 0, D = sqrt(D); end % 40 IF D>0 THEN D=SQR(D)
    % 41 REM ----- CRITERIA FOR USING REDUCED KERNEL
    if I6u ~= 0 % 42 IF I6!=0 THEN 49
        % 43 REM ----- EXACT KERNEL CALCULATION WITH ELLIPTIC INTEGRAL
        B=D3/(D3+4*A2); % 44 B=D3/(D3+4*A2)
        % 45 W0=C0+B*(C1+B*(C2+B*(C3+B*C4)))
        % 46 W1=C5+B*(C6+B*(C7+B*(C8+B*C9)))
        % 47 V0=(W0-W1*LOG(B))*SQR(1-B)
        V0 = EllipticIntegral(B);
        V0 = V0*sqrt(1-B);
        % 48 T3=T3+(V0+LOG(D3/(64*A2))/2)/P/A(P4)-1/D
        T3 = T3 + (V0 + log(D3/(64*A2))/2)/pi/Ap4 - 1/D;
    end
end
B1=D*W;                             % 49 B1=D*W

% 50 REM ----- EXP(-J*K*R)/R
T3 = T3 + cos(B1)/D;                % 51 T3=T3+COS(B1)/D
T4 = T4 - sin(B1)/D;                % 52 T4=T4-SIN(B1)/D
return                              % 53 RETURN