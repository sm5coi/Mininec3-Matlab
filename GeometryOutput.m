function Cp = GeometryOutput(N,Wp,NW,Na,X,Y,Z,A,Cp)

% 1256 REM ********** GEOMETRY OUTPUT **********
K = 1;  % 1264 K = 1
J = 0;  % 1265 J = 0

for I = 1:N   % 1266 FOR I = 1 TO N
    I1 = 2 * Wp(I) - 1 + I;   %     1267 I1 = 2 * W%(I) - 1 + I
    %     1268 IF K > NW THEN 1279
    %     1269 IF K = J THEN 1279
    if (K > NW) || (K == J)
        %     1279 PRINT #3, X(I1); TAB(15); Y(I1); TAB(29); Z(I1); 
        %       TAB(43); A(W%(I)); TAB(57);
        fprintf('%8.4f\t%8.4f\t%8.4f\t%8.4f',X(I1),Y(I1),Z(I1),A(Wp(I)));
        %     1280 PRINT #3, USING "###  ###   ##"; C%(I, 1), C%(I, 2), I
        fprintf('\t%4d\t%4d\t%4d\n', Cp(I,1), Cp(I,2), I)
        %     1281 IF (I = N(K, 2) OR N(K, 1) = N(K, 2) OR C%(I, 2) = 0) 
        %       THEN K = K + 1
        if (I == Na(K, 2)) || (Na(K, 1) == Na(K, 2)) ||(Cp(I, 2) == 0)
            K = K + 1;
        end
        %     1282 IF C%(I, 1) = 0 THEN C%(I, 1) = W%(I)
        if Cp(I, 1) == 0
            Cp(I, 1) = Wp(I);
        end
        %     1283 IF C%(I, 2) = 0 THEN C%(I, 2) = W%(I)
        if Cp(I, 2) == 0
            Cp(I, 2) = Wp(I);
        end
        %     1284 IF (K = NW AND N(K, 1) = 0 AND N(K, 2) = 0) THEN 1270
        if ~((K == NW) && (Na(K, 1) == 0) && (Na(K, 2) == 0))
            %     1285 IF (I = N AND K < NW) THEN 1270
            if ~((I == N) && (K < NW))
                continue
            end
        end
    end

    while 1
        %     1270 J = K
        J = K;
        fprintf('WIRE NO.%3d\t COORDINATES\t\t\t\t\t\t  CONNECTION\tPULSE\n',K)
        fprintf('  X           Y           Z           RADIUS\tEND 1\tEND 2\t NO.\n')
        %     1274 IF (N(K, 1) <> 0 OR N(K, 2) <> 0) THEN 1279
        if (Na(K, 1) ~= 0) || (Na(K, 2) ~= 0)
            fprintf('%8.4f\t%8.4f\t%8.4f\t%8.4f',X(I1),Y(I1),Z(I1),A(Wp(I)));
            fprintf('\t%4d\t%4d\t%4d\n', Cp(I,1), Cp(I,2), I)
            %     1281 IF (I = N(K, 2) OR N(K, 1) = N(K, 2) OR C%(I, 2) = 0) THEN K = K + 1
            if (I == Na(K, 2)) || (Na(K, 1) == Na(K, 2)) || (Cp(I, 2) == 0)
                K = K + 1;
            end
            %     1282 IF C%(I, 1) = 0 THEN C%(I, 1) = W%(I)
            if Cp(I, 1) == 0
                Cp(I, 1) = Wp(I);
            end
            %     1283 IF C%(I, 2) = 0 THEN C%(I, 2) = W%(I)
            if Cp(I, 2) == 0
                Cp(I, 2) = Wp(I);
            end
            %     1284 IF (K = NW AND N(K, 1) = 0 AND N(K, 2) = 0) THEN 1270
            if ~((K == NW) && (Na(K, 1) == 0) && (Na(K, 2) == 0))
                %     1285 IF (I = N AND K < NW) THEN 1270
                if ~((I == N) && (K < NW))
                    break
                end
            end
        else
            %     1275 PRINT #3, "-", "-", "-", "    -", " -    -    0"
            %     1276 K = K + 1
            K = K + 1;
            %     1277 IF K > NW THEN 1286
            if K > NW
                break
            end
            %     1278 GOTO 1270
        end
    end
    % 1286 NEXT I
end
% 1287 PRINT
% 1288 CLOSE 1: IF INFILE THEN INFILE = 0: IF O$ > "C" THEN 1293
% 1289 INPUT "    CHANGE GEOMETRY (Y/N) "; A$
% 1290 IF A$ = "Y" THEN 1153
% 1291 IF A$ <> "N" THEN 1289