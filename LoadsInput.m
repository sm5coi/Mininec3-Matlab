function LoadsInput(N)

% global   N 

% MS MW MM MP P P0 G Ea La Ma S0 M SRM W W2 FLG ML MA

% 10 REM ----- MAXIMUM NUMBER OF LOADS = 11
ML = 11;
% 12 REM ----- MAXIMUM ORDER OF S-PARAMETER LOADS = 8
MA = 8;


% 1454 REM ********** LOADS INPUT **********
% 1455 PRINT
while 1
    % 1456 INPUT "NUMBER OF LOADS       ";NL
    NL = 0; %input('NUMBER OF LOADS       ');
    % 1457 IF NL<=ML THEN 1460
    if NL <= ML
        break
    end
    % 1458 PRINT "NUMBER OF LOADS EXCEEDS DIMENSION..."
    % 1459 GOTO 1456
end
%
% 1460 IF O$>"C" THEN PRINT #3,"NUMBER OF LOADS";NL
% 1461 IF NL<1 THEN 1492
if NL < 1
%     FLG = 0;
    return
end
% 1462 INPUT "S-PARAMETER (S=jw) IMPEDANCE LOAD (Y/N)";L$
while 1
    LST = input('S-PARAMETER (S=jw) IMPEDANCE LOAD (Y/N)','s');
    LST = upper(LST);
    % 1463 IF L$<>"Y" AND L$<>"N" THEN 1462
    if ~((LST ~= 'Y') && (LST ~= 'N'))
        break
    end
end
% 1464 A$="PULSE NO.,RESISTANCE,REACTANCE"
% 1465 IF L$="Y" THEN A$= "PULSE NO., ORDER OF S-PARAMETER FUNCTION"
if LST == 'Y'
    AS = 'PULSE NO., ORDER OF S-PARAMETER FUNCTION';
else
    AS = 'PULSE NO.,RESISTANCE,REACTANCE';
end
% 1466 FOR I=1 TO NL
for I = 1:NL
    % 1467 PRINT
    % 1468 PRINT "LOAD NO. ";I;":"
    fprintf('LOAD NO. %2d: \n', I);
    % 1469 IF L$="Y" THEN 1476
    if LST ~= 'Y'
        while 1
            % 1470 PRINT A$;
            fprintf('%s\n', AS)
            % 1471 INPUT LP(I),LA(1,I,1),LA(2,I,1)
            res = input('[LP LA1 LA2]: ');
            if length(res) ~= 3
                fprintf('NEED THREE INPUTS [LP LA1 LA2] ...\n')
                continue
            end
            LP(I) = res(1);
            LA(1,I,1) = res(2);
            LA(2,I,1) = res(3);
            % 1472 IF LP(I)>N THEN PRINT "PULSE NUMBER EXCEEDS NUMBER OF PULSES...": GOTO 1470
            if ~(LP(I) > N)
                break
            end
            fprintf('PULSE NUMBER EXCEEDS NUMBER OF PULSES...\n')
        end
        %
        % 1473 IF O$>"C" THEN PRINT #3,A$;": ";LP(I);",";LA(1,I,1);",";LA(2,I,1)
        % 1474 GOTO 1491
        %
    else
        % 1475 REM ----- S-PARAMETER LOADS
        while 1
            % 1476 PRINT A$;
            fprintf('%s\n', AS)
            % 1477 INPUT LP(I),LS(I)
            res = input('[LP LS]: ');
            if length(res) ~= 2
                fprintf('NEED TWO INPUTS [LP LS] ...\n')
                continue
            end
            LP(I) = res(1);
            LS(I) = res(2);
            % 1478 IF LP(I)>N THEN PRINT "PULSE NUMBER EXCEEDS NUMBER OF PULSES...": GOTO 1476
            %
            % 1479 IF LS(I)>MA THEN PRINT "MAXIMUM DIMENSION IS 10":GOTO 1477
            %
            if (LP(I) > N)
                fprintf('PULSE NUMBER EXCEEDS NUMBER OF PULSES...\n')
                continue
            end
            if ~(LS(I) > MA)
                break
            end
            fprintf('MAXIMUM DIMENSION IS 10\n')
        end
        % 1480 IF O$>"C" THEN PRINT #3,A$;": ";LP(I);",";LS(I)
        % 1481 FOR J=0 TO LS(I)
        for J = 0:LS(I)
            % 1482 A$="NUMERATOR, DENOMINATOR COEFFICIENTS OF S^"
            % 1483 PRINT A$;J;
            fprintf('NUMERATOR, DENOMINATOR COEFFICIENTS OF S^%d\n', J);
            % 1484 INPUT LA(1,I,J),LA(2,I,J)
            res = input('[LA1 LA2]: ');
            if length(res) ~= 2
                fprintf('NEED TWO INPUTS [LA1 LA2] ...\n')
                continue
            end
            LA(1,I,zeroindx(J)) = res(1);
            LA(2,I,zeroindx(J)) = res(2);
            % 1485 IF O$>"C" THEN PRINT #3,A$;J;":";LA(1,I,J);",";LA(2,I,J)
            % 1486 NEXT J
        end
        % 1487 IF LS(I)>0 THEN 1491
        if LS(I) > 0
            continue
        end
        % 1488 LS(I)=1
        LS(I) = 1;
        % 1489 LA(1,I,1)=0
        LA(1,I,zeroindx(1)) = 0;
        % 1490 LA(2,I,1)=0
        LA(2,I,zeroindx(1)) = 0;
    end
    % 1491 NEXT I
end
% 1492 FLG=0
% FLG = 0;
% 1493 RETURN
return

function indx = zeroindx(x)
indx = x + 1;
return