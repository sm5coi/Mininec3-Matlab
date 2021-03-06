function [freq, FLG] = FrequencyInput

% global FLG S0 M SRM W W2

% 1131 REM ********** FREQUENCY INPUT **********
% 1134 INPUT "FREQUENCY (MHZ)";F
F = 299.8;
% 1136 IF O$>"C" THEN PRINT #3, " ":PRINT #3, "FREQUENCY (MHZ):";F
% 1137 W=299.8/F
W = 299.8/F;
% 1138 REM -----VIRTUAL DIPOLE LENGTH FOR NEAR FIELD CALCULATION
S0 =  0.001*W;
% 1140 REM ----- 1 / (4 * PI * OMEGA * EPSILON)
M = 4.77783352*W;
% 1142 REM ----- SET SMALL RADIUS MODIFICATION CONDITION
SRM = 0.0001*W;
fprintf('    WAVE LENGTH = %10.3f METERS\n', W)
% 1145 REM ----- 2 PI / WAVELENGTH
W = 2*pi/W;
W2 = W*W/2;
FLG = 0;

freq.F = F;
freq.S0 = S0;
freq.M = M;
freq.SRM = SRM;
freq.W = W;
freq.W2 = W2;


return
