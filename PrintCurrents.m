function [CurrX,FLG] = PrintCurrents(CurrX,freq,FLG,envir,geom)

global NW Na Cp G BSd  cForm dForm fidPsi

J1a = geom.J1a;

Rub1 = 'PULSE         REAL          IMAGINARY     MAGNITUDE     PHASE\n';
Rub2 = ...
    ' NO.          (AMPS)        (AMPS)        (AMPS)        (DEGREES)\n';

cForm = '  %c           % 12.6E % 12.6E % 12.6E % 9.5f\n';
dForm = '%3d           % 12.6E % 12.6E % 12.6E % 9.5f\n';

% 496 REM ********** PRINT CURRENTS **********
[CurrX,FLG] = ImpedanceMatrixCalculation(CurrX,freq,FLG,envir,geom);
Ss = 'N';
%CurrX = complex(CR,CI);
fprintf(fidPsi, '\n%s CURRENT DATA %s\n', BSd, BSd);
for K = 1:NW  % 501 FOR K=1 TO NW (to 555)
    %*** A ***
    if ~(Ss == 'Y')
        fprintf(fidPsi, '\nWIRE NO.  %d\n', K);
        fprintf(fidPsi, Rub1);
        fprintf(fidPsi, Rub2);
    end
    N1 = Na(K,1);
    N2 = Na(K,2);
    I = N1;
    C = Cp(I,1);
    if (N1 == 0) && (N2 == 0), C = K; end
    %*** A ***
    if ~(G == 1)  % 512 IF G=1 THEN 515  %*** ~B ***
        if (J1a(K) == -1) && (N1 > N2), N2 = N1; end %*** C ***
    end
    if ~(J1a(K) == -1) || (envir.G == 1) %*** ~D or B ***
        %*** E..I ***
        %*** E ***
        Ep = 1;
        [IJu, Is] = SortJunctionCurrents(Ep, I, C, K, CurrX);
        PrintOutS(fidPsi, cForm, Is, IJu);
        if ~(N1 == 0) %*** ~F ***
            if ~(C == K) %*** ~G ***
                if (Is == 'J'), N1 = N1 + 1; end %*** H ***
            end
            for I = N1:N2-1 %*** I ***
                PrintOutD(fidPsi, dForm, I, CurrX(I));
            end
        end
    else %*** E..I ***
        for I = N1:N2-1 %*** I ***
            PrintOutD(fidPsi, dForm, I, CurrX(I));
        end
    end
    
    I = N2;
    C = Cp(I,2);
    if ((N1 == 0) && (N2 == 0)), C = K; end
    
    if (envir.G == 1) || ~(J1a(K) == 1) %*** K or ~L ***
        Ep = 2;
        [IJu, Is] = SortJunctionCurrents(Ep, I, C, K, CurrX);
        if ((N1 == 0) && (N2 == 0)) || (N1 > N2) %*** N or O ****
            PrintOutS(fidPsi,cForm,Is,IJu); %*** T ***
        else
            if (C == K) %*** P ***
                fAlfa_2(K,N2,CurrX(N2),IJu,Is,J1a)
            else
                if (Is == 'J') %*** Q ***
                    PrintOutS(fidPsi,cForm,Is,IJu);
                else
                    fAlfa_2(K,N2,CurrX(N2),IJu,Is,J1a)
                end
            end
        end
    elseif (J1a(K) == 1) %*** L ***
        fAlfa_2(K,N2,CurrX(N2),IJu,Is,J1a)   %*** beta, R,S,T ***
    end
end % 555 NEXT K
Fs = 'NAME.OUT';
% if (Os > 'C'), fprintf('FILENAME (NAME.OUT): %s\n', Fs); end
return


function PrintOutD(fid, format, i, Cx)

fprintf(fid, format, i, real(Cx), imag(Cx), abs(Cx), angle(Cx)*180/pi);
return

function PrintOutS(fid, format, s, Cx)

fprintf(fid, format, s, real(Cx), imag(Cx), abs(Cx), angle(Cx)*180/pi);
return


function fAlfa_2(K,N2,Cx,IJu,Is,J1a)

% J1a
global dForm cForm fidPsi

PrintOutD(fidPsi, dForm, N2, Cx)
if ~(J1a(K) == 1)
    PrintOutS(fidPsi, cForm, Is, IJu);
end
return


function [IJu,Is] = SortJunctionCurrents(Ep, I, C, K, Cx)

global NW Na Cp

Is = 'E';
IJu = complex(0,0);
if ~((C == K) || (C == 0))
    Is = 'J';
    IJu = Cx(I);
end
for J = 1:NW
    if (J == K), continue, end
    L1 = Na(J,1);
    L2 = Na(J,2);
    if (Ep == 2)
        CO = Cp(L2,2);
        CT = Cp(L1,1);
        L3 = L2;
        L4 = L1;
    else
        CO = Cp(L1,1);
        CT = Cp(L2,2);
        L3 = L1;
        L4 = L2;
    end
    if (CO == -K)
        IJu = IJu - Cx(L3);
        Is = 'J';
    end
    if ~(CT == K)
        continue
    else
        IJu = IJu + Cx(L4);
        Is = 'J';
    end
end
return