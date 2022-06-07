function [ELM,I1,I2,J1a,J2a] = Connections(I,NW,G,XYZ1,XYZ2,A,S1,ELM,J1a,J2a)

% 1298 REM ********** CONNECTIONS **********

ELM(I,:) = XYZ1;                % 1299 E(I)=X1 1300 L(I)=Y1 1301 M(I)=Z1
E(I) = XYZ1(1);
L(I) = XYZ1(2);
M(I) = XYZ1(3);
ELM(I+NW,:) = XYZ2;             % 1302 E(I+NW)=X2 1303 L(I+NW)=Y2 1304 M(I+NW)=Z2
E(I+NW) = XYZ2(1);
L(I+NW) = XYZ2(2);
M(I+NW) = XYZ2(3);
Gp = 0;                         % 1305 G%=0  % Lokal variabel i Connections
I1 = 0;                         % 1306 I1=0
I2 = 0;                         % 1307 I2=0
J1a(I) = 0;                     % 1308 J1(I)=0
J2a(I,1) = -I;                  % 1309 J2(I,1)=-I
J2a(I,2) = -I;                  % 1310 J2(I,2)=-I

if G == 1                       % 1311 IF G=1 THEN 1323  % For Free Space
    if I == 1                   % 1323 IF I=1 THEN 1358
        WriteConnection(XYZ1,XYZ2,I1,I2,A(I),S1);
        return                  % 1362 RETURN
    end
    for J = 1:I-1               % 1324 FOR J=1 TO I-1

        % 1325 REM ----- CHECK FOR END1 TO END1
        % 1326 IF (X1=E(J) AND Y1=L(J) AND Z1=M(J)) THEN 1328
        if (XYZ1(1) == E(J)) && (XYZ1(2) == L(J)) && (XYZ1(3) == M(J))
            I1 = -J;            % 1328 I1=-J
            J2a(I,1) = J;       % 1329 J2(I,1)=J
            % 1330 IF J2(J,1)=-J THEN J2(J,1)=J
            if J2a(J,1) == -J, J2a(J,1) = J; end
            break;              % 1331 GOTO 1340
        end

        % 1332 REM ----- CHECK FOR END1 TO END2
        % 1333 IF (X1=E(J+NW) AND Y1=L(J+NW) AND Z1=M(J+NW)) THEN 1335
        if  (XYZ1(1) == E(J+NW)) && (XYZ1(2) == L(J+NW)) && (XYZ1(3) == M(J+NW))
            I1 = J;             % 1335 I1=J
            J2a(I,1) = J;       % 1336 J2(I,1)=J
            % 1337 IF J2(J,2)=-J THEN J2(J,2)=J
            if J2a(J,2) == -J, J2a(J,2) = J; end
            break;              % 1338 GOTO 1340
        end
    end
elseif G == -1 % For Ground Plan

    % 1312 REM ----- CHECK FOR GROUND CONNECTION
    % 1313 IF Z1=0 THEN 1315
    % 1314 GOTO 1318
    if XYZ1(3) == 0
        % 1315 I1=-I
        I1 = -I;
        % 1316 J1(I)=-1
        J1a(I) = -1;
        % 1317 GOTO 1340
    else
        % 1318 IF Z2=0 THEN 1320
        % 1319 GOTO 1323

        if XYZ2(3) == 0
            I2 = -I;      % 1320 I2=-I
            J1a(I) = 1;  % 1321 J1(I)=1
            Gp = 1;      % 1322 G%=1
        end

        % 1323 IF I=1 THEN 1358
        if I == 1
            % 1358 PRINT 
            WriteConnection(XYZ1,XYZ2,I1,I2,A(I),S1);
            % 1362 RETURN
            return
        end
        % 1324 FOR J=1 TO I-1
        for J = 1:I-1

            % 1325 REM ----- CHECK FOR END1 TO END1
            % 1326 IF (X1=E(J) AND Y1=L(J) AND Z1=M(J)) THEN 1328
            % 1327 GOTO 1333
            if (XYZ1(1) == E(J)) && (XYZ1(2) == L(J)) && (XYZ1(3) == M(J))
                % 1328 I1=-J
                I1 = -J;
                % 1329 J2(I,1)=J
                J2a(I,1) = J;
                % 1330 IF J2(J,1)=-J THEN J2(J,1)=J
                if J2a(J,1) == -J
                    J2a(J,1) = J;
                end
                % 1331 GOTO 1340
                break
            end

            % 1332 REM ----- CHECK FOR END1 TO END2
            % 1333 IF (X1=E(J+NW) AND Y1=L(J+NW) AND Z1=M(J+NW)) THEN 1335
            % 1334 GOTO 1339
            if  (XYZ1(1) == E(J+NW)) && (XYZ1(2) == L(J+NW)) && ...
                    (XYZ1(3) == M(J+NW))
                % 1335 I1=J
                I1 = J;
                % 1336 J2(I,1)=J
                J2a(I,1) = J;
                % 1337 IF J2(J,2)=-J THEN J2(J,2)=J
                if J2a(J,2) == -J
                    J2a(J,2) = J;
                end
                % 1338 GOTO 1340
                break;
            end
        end
        % 1339 NEXT J
    end
else
    error('Erroneus Environment Variable!')
end
% 1340 IF G%=1 THEN 1358
if Gp ~= 1
    % 1341 IF I=1 THEN 1358
    if I ~= 1
        % 1342 FOR J=1 TO I-1
        for J = 1:I-1

            % 1343 REM ----- CHECK END2 TO END2
            % 1344 IF (X2=E(J+NW) AND Y2=L(J+NW) AND Z2=M(J+NW)) THEN 1346
            % 1345 GOTO 1351
            if  (XYZ2(1) == E(J+NW)) && (XYZ2(2) == L(J+NW)) && ...
                    (XYZ2(3) == M(J+NW))
                % 1346 I2=-J
                I2 = -J;
                % 1347 J2(I,2)=J
                J2a(I,2) = J;
                % 1348 IF J2(J,2)=-J THEN J2(J,2)=J
                if J2a(J,2) == -J
                    J2a(J,2) = J;
                end
                % 1349 GOTO 1358
                break;
            end

            % 1350 REM ----- CHECK FOR END2 TO END1
            % 1351 IF (X2=E(J) AND Y2=L(J) AND Z2=M(J)) THEN 1353
            % 1352 GOTO 1357
            if  (XYZ2(1) == E(J)) && (XYZ2(2) == L(J)) && (XYZ2(3) == M(J))
                I2 = J;
                J2a(I,2) = J;
                
                if J2a(J,1) == -J % 1355 IF J2(J,1)=-J THEN J2(J,1)=J
                    J2a(J,1) = J;
                end
                break; % 1356 GOTO 1358
            end
        end  % 1357 NEXT J
    end
end

WriteConnection(XYZ1,XYZ2,I1,I2,A(I),S1);

return % 1362 RETURN

function WriteConnection(XYZ1,XYZ2,I1,I2,A,S1)
% 1358 PRINT #3,"            COORDINATES","  ","  ","END         NO. OF"
fprintf('            COORDINATES                                        END        NO. OF\n')
% 1359 PRINT #3,"   X","   Y","   Z","RADIUS     CONNECTION     SEGMENTS"
fprintf('   X               Y               Z               RADIUS      CONNECTION SEGMENTS\n')
% 1360 PRINT #3,X1;TAB(15);Y1;TAB(29);Z1;TAB(57);I1
fprintf('%8.3f\t%8.3f\t%8.3f\t        \t%4d\n', XYZ1(1),XYZ1(2),XYZ1(3),I1)
% 1361 PRINT #3,X2;TAB(15);Y2;TAB(29);Z2;TAB(43);A(I);TAB(57);I2;TAB(71);S1
fprintf('%8.3f\t%8.3f\t%8.3f\t%8.3f\t%4d\t %4d\n\n', XYZ2(1),XYZ2(2),XYZ2(3),A,I2,S1)

return