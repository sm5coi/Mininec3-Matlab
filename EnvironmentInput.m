function envir = EnvironmentInput

%global NR Ua NM

envir.Ua(1) = 0;
% 1363 REM ********** ENVIROMENT INPUT **********
% 1368 REM ----- INITIALIZE NUMBER OF RADIAL WIRES TO ZERO
envir.NR=0;
% 1370 REM ----- SET ENVIRONMENT
% A$= 'ENVIRONMENT (+1 FOR FREE SPACE, -1 FOR GROUND PLANE)';
envir.G = -1;
if envir.G == 1
    return
end
% 1378 REM ----- NUMBER OF MEDIA
% 1379 A$=" NUMBER OF MEDIA (0 FOR PERFECTLY CONDUCTING GROUND)"
envir.NM = 0;
% 1386 REM ----- INITIALIZE BOUNDARY TYPE
envir.TB=1;
if envir.NM == 0
    return
end
% 1390 REM ----- TYPE OF BOUNDARY
% 1391 A$=" TYPE OF BOUNDARY (1-LINEAR, 2-CIRCULAR)"
% 1395 REM ----- BOUNDARY CONDITIONS
for I = 1:envir.NM
    % 1397 PRINT "MEDIA";I
    % 1398 A$=" RELATIVE DIELECTRIC CONSTANT, CONDUCTIVITY"
    % 1399 PRINT "         ";A$;
    % 1400 INPUT T(I),V(I)
    % 1401 IF O$>"C" THEN PRINT #3,A$;": ";T(I)","V(I)
    % 1402 IF I>1 THEN 1414
    % 1403 IF TB=1 THEN 1414
    % 1404 A$=" NUMBER OF RADIAL WIRES IN GROUND SCREEN"
    % 1405 PRINT "            ";A$;
    % 1406 INPUT NR
    % 1407 IF O$>"C" THEN PRINT #3,A$;": ";NR
    % 1408 IF NR=0 THEN 1414
    % 1409 A$=" RADIUS OF RADIAL WIRES"
    % 1410 PRINT "                             ";A$;
    % 1411 INPUT RR
    % 1412 IF O$>"C" THEN PRINT #3,A$;": ";RR
    % 1413 REM ----- INITIALIZE COORDINATE OF MEDIA INTERFACE
    % 1414 U(I)=1000000!
    % 1415 REM ----- INITIALIZE HEIGHT OF MEDIA
    % 1416 H(I)=0
    % 1417 IF I=NM THEN 1422
    % 1418 A$=" X OR R COORDINATE OF NEXT MEDIA INTERFACE"
    % 1419 PRINT "          ";A$;
    % 1420 INPUT U(I)
    envir.Ua(I) = 0;
    % 1421 IF O$>"C" THEN PRINT #3,A$;": ";U(I)
    % 1422 IF I=1 THEN 1427
    % 1423 A$=" HEIGHT OF MEDIA"
    % 1424 PRINT "                                    ";A$;
    % 1425 INPUT H(I)
    % 1426 IF O$>"C" THEN PRINT #3,A$;": ";H(I)
end

return