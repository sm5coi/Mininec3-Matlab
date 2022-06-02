function MainProgram

global MS ML MA MM MP P P0 CSd BSd Os G0 G
global fidPsi fidGau fidZRZI
global N NW CABG Sa Na Cp Wp Xa Ya Za A ELM 

% 1 REM ****** MININEC(3) **********  NOSC CODE 822 (JCL CHANGE 9) 11-26-86
% 4 REM ----- MAXIMUM NUMBER OF SEGMENTS (PULSES + 2 * WIRES) = 150
MS = 150;
% 10 REM ----- MAXIMUM NUMBER OF LOADS = 11
ML = 11;
% 12 REM ----- MAXIMUM ORDER OF S-PARAMETER LOADS = 8
MA = 8;
% 15 REM ----- MAXIMUM NUMBER OF MEDIA = 6
MM = 6;
% 19 REM ----- MAXIMUM NUMBER OF PULSES = 50 
MP = 50;
% 1494 REM ********** MAIN PROGRAM **********
% 1496 REM ----- PI
P = pi;
% 1498 REM ----- CHANGES DEGREES TO RADIANS
P0 = pi/180;
BSd = '********************';
% 1501 REM ----- INTRINSIc IMPEDANCE OF FREE SPACE DIVIDED BY 2 PI
G0 = 29.979221;
% 1513 REM ----- IDENTIFY OUTPUT DEVICE
Os = 'D';
fprintf('%s%s\n', BSd, BSd)
FrequencyInput;
G = EnvironmentInput;
% 1526 REM ----- GEOMETRY INPUT
[N,NW,CABG,Sa,Na,Cp,Wp,Xa,Ya,Za,A,ELM] = GeometryInput(G);
% 1528 REM ----- MENu
fidPsi = fopen('PSI_DATA.dat','w');
fidGau = fopen('GAUSS_DATA.dat','w');
fidZRZI = fopen('Impedans.dat','w');
while 1
fprintf('   G - CHANGE GEOMETRY     C - COMPUTE/DISPLAY CURRENTS\n')
fprintf('   E - CHANGE ENVIRONMENT  P - COMPUTE FAR-FIELD PATTERNS\n')
fprintf('   X - CHANGE EXCITATION   N - COMPUTE NEAR-FIELDS\n')
fprintf('   L - CHANGE LOADS\n')
fprintf('   F - CHANGE FREQUENCY    Q - QUIT\n\n')
CSd = input('   COMMAND ','s');
CSd = upper(CSd);
if CSd == 'P', FarFieldCalculation; end
if CSd == 'C', PrintCurrents; end
if CSd == 'N', NearField; end
if CSd == 'Q', break, end
end

fclose(fidPsi);
fclose(fidGau);
fclose(fidZRZI);

return