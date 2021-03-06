function [CurrX,FLG]=FarFieldCalculation(freq,FLG,envir,CurrX,geom,exci)

global PWR NM F G N  W Sa Wp Ua
global CR CI G0
global fidPsi

BSd = '********************';

% Xa Ya Za
Xa = geom.XYZa(:,1)';
Ya = geom.XYZa(:,2)';
Za = geom.XYZa(:,3)';

CA = geom.CABG(:,1);
CB = geom.CABG(:,2);
CG = geom.CABG(:,3);

Cp = geom.Cp;


% "VERTICAL", "HORIZONTAL", "TOTAL"
Rub3 = 'ZENITH        AZIMUTH       VERTICAL      HORIZONTAL    TOTAL\n';
Rub4 = ' ANGLE         ANGLE        PATTERN (DB)  PATTERN (DB)  PATTERN (DB)\n';

dForm =' %3d           %3d          % 8.3f      % 8.3f      % 8.3f\n';

%Ua(1) = 0;
% 620 REM ********** FAR FIELD CALCULATION **********
% 621 IF FLG < 2 THEN GOSUB 196
if (FLG < 2)
   [CurrX,FLG] = ImpedanceMatrixCalculation(CurrX,freq,FLG,envir,geom,exci);
end
% 622 O2 = PWR
O2 = PWR;
% 623 REM ----- TABULATE IMPEDANCE
% 624 IF NM = 0 THEN 634
if ~(NM == 0)
    % 625 FOR I = 1 TO NM
    for I = 1:NM
        %     626 Z6 = T(I)
        Z6 = T(I);
        %     627 Z7 = -V(I) / (2 * P * F * 8.85E-06)
        Z7 = -V(I)/(2*pi*F*8.85E-6);
        %     628 REM ----- FORM IMPEDANCE=1/SQR(DIELECTRIC CONSTANT)
        %     629 GOSUB 184
        [W6,W7] = ComplexSquareRoot(Z6, Z7);
        %     630 D = W6 * W6 + W7 * W7
        D = W6*W6 + W7*W7;
        %     631 Z1(I) = W6 / D
        Z1(I) = W6/D;
        %     632 Z2(I) = -W7 / D
        Z2(I) = -W7/D;
        % 633 NEXT I
    end
end
% 634 PRINT #3, " "
% 635 PRINT #3, B$; "     FAR FIELD      "; B$
% 636 PRINT #3, " "
fprintf(fidPsi, '\n%s     FAR FIELD      %s\n', BSd, BSd);
% 637 REM ----- INPUT VARIABLES FOR FAR FIELD CALCULATION
% 638 INPUT "CALCULATE PATTERN IN DBI OR VOLTS/METER (D/V)"; P$
Ps = 'D';
% 639 IF P$ = "D" THEN 655
if ~(Ps == 'D')
    % 640 IF P$ <> "V" THEN 638
    % 641 F1 = 1
    % 642 PRINT
    % 643 PRINT "PRESENT POWER LEVEL =  "; PWR; " WATTS"
    % 644 INPUT "CHANGE POWER LEVEL (Y/N) "; A$
    % 645 IF A$ = "N" THEN 650
    % 646 IF A$ <> "Y" THEN 644
    % 647 INPUT "NEW POWER LEVEL (WATTS)  "; O2
    % 648 IF O$ > "C" THEN PRINT #3, "NEW POWER LEVEL = "; O2
    % 649 GOTO 644
    % 650 IF (O2 < 0 OR O2 = 0) THEN O2 = PWR
    % 651 F1 = SQR(O2 / PWR)
    % 652 PRINT
    % 653 INPUT "RADIAL DISTANCE (METERS) "; RD
    % 654 IF RD < 0 THEN RD = 0
end

% 655 A$ = "ZENITH ANGLE : INITIAL,INCREMENT,NUMBER"
As1 = 'ZENITH ANGLE : INITIAL, INCREMENT, NUMBER';
% 656 PRINT A$;
% 657 INPUT ZA, ZC, NZ
ZA = 0;
ZC = 10;
NZ = 10;
% 658 IF NZ = 0 THEN NZ = 1
% 659 IF O$ > "C" THEN PRINT #3, A$; ": "; ZA; ","; ZC; ","; NZ
fprintf(fidPsi, '%s %5.1f %5.1f %5.1f\n', As1, ZA, ZC, NZ);

% 660 A$ = "AZIMUTH ANGLE: INITIAL,INCREMENT,NUMBER"
As2 = 'AZIMUTH ANGLE: INITIAL, INCREMENT, NUMBER';
% 661 PRINT A$;
% 662 INPUT AA, AC, NA
AA = 0;
AC = 0;
NA = 0;
% 663 IF NA = 0 THEN NA = 1
if (NA == 0)
    NA = 1;
end
% 664 IF O$ > "C" THEN PRINT #3, A$; ": "; AA; ","; AC; ","; NA
% fprintf( dForm, I, CR(I), CI(I), S1, S2);
fprintf(fidPsi, '%s %5.1f %5.1f %5.1f\n\n', As2, AA, AC, NA);
% 665 PRINT #3, " "
% 666 REM ********** FILE FAR FIELD DATA **********
% 667 INPUT "FILE PATTERN (Y/N)"; S$
% 668 IF S$ = "N" THEN 676
% 669 IF S$ <> "Y" THEN 667
% 670 PRINT #3, " "
% 671 INPUT "FILENAME (NAME.OUT)"; F$
% 672 IF LEFT$(RIGHT$(F$, 4), 1) = "." THEN 673 ELSE F$ = F$ + ".OUT"
% 673 IF O$ > "C" THEN PRINT #3, "FILENAME (NAME.OUT): "; F$
% 674 OPEN F$ FOR OUTPUT AS #1
% 675 PRINT #1, NA * NZ; ","; O2; ","; P$
% 676 PRINT #3, " "
% 677 K9! = .016678 / PWR
K9u = .016678 / PWR;
% 678 REM ----- PATTERN HEADER
% 679 PRINT #3, B$; "    PATTERN DATA    "; B$
fprintf(fidPsi, '\n%s    PATTERN DATA    %s\n', BSd, BSd);

% 680 IF P$ = "V" GOTO 685
% 681 PRINT #3, "ZENITH", "AZIMUTH", "VERTICAL", "HORIZONTAL", "TOTAL"
fprintf(fidPsi, Rub3);
% 682 A$ = "PATTERN (DB)"
% 683 PRINT #3, " ANGLE", " ANGLE", A$, A$, A$
fprintf(fidPsi, Rub4);
% 684 GOTO 692
% 685 IF RD > 0 THEN PRINT #3, TAB(15); "RADIAL DISTANCE = "; RD; " METERS"
% 686 PRINT #3, TAB(15); "POWER LEVEL = "; PWR * F1 * F1; " WATTS"
% 687 PRINT #3, "ZENITH   AZIMUTH", "     E(THETA)     ", "     E(PHI)"
% 688 A$ = " MAG(V/M)    PHASE(DEG)"
% 689 PRINT #3, " ANGLE    ANGLE", A$, A$
% 690 IF S$ = "Y" THEN PRINT #1, RD
% 691 REM ----- LOOP OVER AZIMUTH ANGLE
% 692 Q1 = AA
Q1 = AA;
% 693 FOR I1 = 1 TO NA
for I1 = 1:NA
    %     694 U3 = Q1 * P0
    U3 = Q1*pi/180;
    %     695 V1 = -SIN(U3)
    V1 = -sin(U3);
    %     696 V2 = COS(U3)
    V2 = cos(U3);
    %     697 REM ----- LOOP OVER ZENITH ANGLE
    %     698 Q2 = ZA
    Q2 = ZA;
    %     699 FOR I2 = 1 TO NZ % 867
    for I2 = 1:NZ
        %         700 U4 = Q2 * P0
        U4 = Q2*pi/180;
        %         701 R3 = COS(U4)
        R3 = cos(U4);
        %         702 T3 = -SIN(U4)
        T3 = -sin(U4);
        %         703 T1 = R3 * V2
        T1 = R3*V2;
        %         704 T2 = -R3 * V1
        T2 = -R3*V1;
        %         705 R1 = -T3 * V2
        R1 = -T3*V2;
        %         706 R2 = T3 * V1
        R2 = T3*V1;
        %         707 X1 = 0
        X1 = 0;
        %         708 Y1 = 0
        Y1 = 0;
        %         709 Z1 = 0
        Z1 = 0;
        %         710 X2 = 0
        X2 = 0;
        %         711 Y2 = 0
        Y2 = 0;
        %         712 Z2 = 0
        Z2 = 0;
        %         713 REM ----- IMAGE LOOP
        %         714 FOR K = 1 TO G STEP -2 % 814
        for K = 1:-2:G
            %             715 FOR I = 1 TO N  % 813
            for I = 1:N
                %                 716 IF K > 0 THEN 718
                if ~(K > 0)
                    %                 717 IF C%(I, 1) = -C%(I, 2) THEN 813
                    if (Cp(I,1) == -Cp(I,2))
                        continue,
                    end
                end
                %                 718 J = 2 * W%(I) - 1 + I
                J = 2*Wp(I) - 1 + I;
                %                 719 REM ----- FOR EACH END OF PULSE COMPUTE A CONTRIBUTION TO E-FIELD
                %                 720 FOR F5 = 1 TO 2
                for F5 = 1:2
                    %                     721 L = ABS(C%(I, F5))
                    L = abs(Cp(I,F5));
                    %                     722 F3 = SGN(C%(I, F5)) * W * S(L) / 2
                    F3 = sign(Cp(I,F5))*W*Sa(L)/2;
                    %                     723 IF C%(I, 1) <> -C%(I, 2) THEN 725
                    if ~(Cp(I,1) ~= -Cp(I,2))
                        %                     724 IF F3 < 0 THEN 812
                        if (F3 < 0)
                            continue
                        end
                    end
                    %                     725 IF K = 1 THEN 728
                    if (K == 1)
                        %                     727 REM ----- STANDARD CASE
                        %                     728 S2 = W * (X(J) * R1 + Y(J) * R2 + Z(J) * K * R3)
                        S2 = W*(Xa(J)*R1 + Ya(J)*R2 + Za(J)*K * R3);
                        %                     729 S1 = COS(S2)
                        S1 = cos(S2);
                        %                     730 S2 = SIN(S2)
                        S2 = sin(S2);
                        %                     731 B1 = F3 * (S1 * CR(I) - S2 * CI(I))
                        B1 = F3*(S1*CR(I) - S2*CI(I));
                        %                     732 B2 = F3 * (S1 * CI(I) + S2 * CR(I))
                        B2 = F3*(S1*CI(I) + S2*CR(I));
                        %                     733 IF C%(I, 1) = -C%(I, 2) THEN 742
                        if ~(Cp(I,1) == -Cp(I,2))
                            %                     734 X1 = X1 + K * B1 * CA(L)
                            X1 = X1 + K*B1*CA(L);
                            %                     735 X2 = X2 + K * B2 * CA(L)
                            X2 = X2 + K*B2*CA(L);
                            %                     736 Y1 = Y1 + K * B1 * CB(L)
                            Y1 = Y1 + K*B1*CB(L);
                            %                     737 Y2 = Y2 + K * B2 * CB(L)
                            Y2 = Y2 + K*B2*CB(L);
                            %                     738 Z1 = Z1 + B1 * CG(L)
                            Z1 = Z1 + B1*CG(L);
                            %                     739 Z2 = Z2 + B2 * CG(L)
                            Z2 = Z2 + B2*CG(L);
                            %                     740 GOTO 812
                            continue
                        end
                        %                     741 REM ----- GROUNDED ENDS
                        %                     742 Z1 = Z1 + 2 * B1 * CG(L)
                        Z1 = Z1 + 2*B1*CG(L);
                        %                     743 Z2 = Z2 + 2 * B2 * CG(L)
                        Z2 = Z2 + 2*B2*CG(L);
                        %                     744 GOTO 812
                        continue
                    else
                        %                     726 IF NM <> 0 THEN 747
                        if (NM == 0)
                            %                     727 REM ----- STANDARD CASE
                            %                     728 S2 = W * (X(J) * R1 + Y(J) * R2 + Z(J) * K * R3)
                            S2 = W*(Xa(J)*R1 + Ya(J)*R2 + Za(J)*K * R3);
                            %                     729 S1 = COS(S2)
                            S1 = cos(S2);
                            %                     730 S2 = SIN(S2)
                            S2 = sin(S2);
                            %                     731 B1 = F3 * (S1 * CR(I) - S2 * CI(I))
                            B1 = F3*(S1*CR(I) - S2*CI(I));
                            %                     732 B2 = F3 * (S1 * CI(I) + S2 * CR(I))
                            B2 = F3*(S1*CI(I) + S2*CR(I));
                            %                     733 IF C%(I, 1) = -C%(I, 2) THEN 742
                            if ~(Cp(I,1) == -Cp(I,2))
                                %                     734 X1 = X1 + K * B1 * CA(L)
                                X1 = X1 + K*B1*CA(L);
                                %                     735 X2 = X2 + K * B2 * CA(L)
                                X2 = X2 + K*B2*CA(L);
                                %                     736 Y1 = Y1 + K * B1 * CB(L)
                                Y1 = Y1 + K*B1*CB(L);
                                %                     737 Y2 = Y2 + K * B2 * CB(L)
                                Y2 = Y2 + K*B2*CB(L);
                                %                     738 Z1 = Z1 + B1 * CG(L)
                                Z1 = Z1 + B1*CG(L);
                                %                     739 Z2 = Z2 + B2 * CG(L)
                                Z2 = Z2 + B2*CG(L);
                                %                     740 GOTO 812
                                continue
                            end
                            %                     741 REM ----- GROUNDED ENDS
                            %                     742 Z1 = Z1 + 2 * B1 * CG(L)
                            Z1 = Z1 + 2*B1*CG(L);
                            %                     743 Z2 = Z2 + 2 * B2 * CG(L)
                            Z2 = Z2 + 2*B2*CG(L);
                            %                     744 GOTO 812
                            continue
                        end
                    end
                    %                     745 REM ----- REAL GROUND CASE
                    %                     746 REM ----- BEGIN BY FINDING SPECULAR DISTANCE
                    %                     747 T4 = 100000!
                    T4 = 100000;
                    
                    %                     748 IF R3 = 0 THEN 750
                    if ~(R3 == 0)
                        %                     749 T4 = -Z(J) * T3 / R3
                        T4 = -Za(J) * T3 / R3;
                    end
                    %                     750 B9 = T4 * V2 + X(J)
                    B9 = T4 * V2 + Xa(J);
                    %                     751 IF TB = 1 THEN 755
                    if ~(TB == 1)
                        %                     752 B9 = B9 * B9 + (Y(J) - T4 * V1) ^ 2
                        B9 = B9 * B9 + (Ya(J) - T4 * V1) ^ 2;
                        %                     753 IF B9 > 0 THEN B9 = SQR(B9) ELSE GOTO 755
                        if (B9 > 0)
                            B9 = sqrt(B9);
                        end
                        %                     754 REM ----- SEARCH FOR THE CORRESPONDING MEDIUM
                    end
                    %                     755 J2 = NM
                    J2 = NM;
                    %                     756 FOR J1 = NM TO 1 STEP -1
                    for J1 = NM:-1:1
                        %                         757 IF B9 > U(J1) THEN 759
                        if (B9 > Ua(J1))
                            continue
                        end
                        %                         758 J2 = J1
                        J2 = J1;
                    end
                    %                     759 NEXT J1
                    
                    %                     760 REM ----- OBTAIN IMPEDANCE AT SPECULAR POINT
                    %                     761 Z4 = Z1(J2)
                    Z4 = Z1(J2);
                    %                     762 Z5 = Z2(J2)
                    Z5 = Z2(J2);
                    
                    %                     763 REM ----- IF PRESENT INCLUDE GROUND SCREEN IMPEDANCE IN PARALLEL
                    %                     764 IF NR = 0 THEN 776
                    if ~(NR == 0)
                        %                     765 IF B9 > U(1) THEN 776
                        if ~(B9 > Ua(1))
                            %                     766 R = B9 + NR * RR
                            %                     767 Z8 = W * R * LOG(R / (NR * RR)) / NR
                            %                     768 S8 = -Z5 * Z8
                            %                     769 S9 = Z4 * Z8
                            %                     770 T8 = Z4
                            %                     771 T9 = Z5 + Z8
                            %                     772 D = T8 * T8 + T9 * T9
                            %                     773 Z4 = (S8 * T8 + S9 * T9) / D
                            %                     774 Z5 = (S9 * T8 - S8 * T9) / D
                        end
                    end
                    %                     775 REM ----- FORM SQR(1-Z^2*SIN^2)
                    %                     776 Z6 = 1 - (Z4 * Z4 - Z5 * Z5) * T3 * T3
                    Z6 = 1 - (Z4 * Z4 - Z5 * Z5) * T3 * T3;
                    %                     777 Z7 = -(2 * Z4 * Z5) * T3 * T3
                    Z7 = -(2 * Z4 * Z5) * T3 * T3;
                    %                     778 GOSUB 184
                    [W6,W7] = ComplexSquareRoot(Z6, Z7);
                    
                    %                     779 REM ----- VERTICAL REFLECTION COEFFICIENT
                    %                     780 S8 = R3 - (W6 * Z4 - W7 * Z5)
                    S8 = R3 - (W6 * Z4 - W7 * Z5);
                    %                     781 S9 = -(W6 * Z5 + W7 * Z4)
                    S9 = -(W6 * Z5 + W7 * Z4);
                    %                     782 T8 = R3 + (W6 * Z4 - W7 * Z5)
                    T8 = R3 + (W6 * Z4 - W7 * Z5);
                    %                     783 T9 = W6 * Z5 + W7 * Z4
                    T9 = W6 * Z5 + W7 * Z4;
                    %                     784 D = T8 * T8 + T9 * T9
                    D = T8 * T8 + T9 * T9;
                    %                     785 V8 = (S8 * T8 + S9 * T9) / D
                    V8 = (S8 * T8 + S9 * T9) / D;
                    %                     786 V9 = (S9 * T8 - S8 * T9) / D
                    V9 = (S9 * T8 - S8 * T9) / D;
                    
                    %                     787 REM ----- HORIZONTAL REFLECTION COEFFICIENT
                    %                     788 S8 = W6 - R3 * Z4
                    S8 = W6 - R3 * Z4;
                    %                     789 S9 = W7 - R3 * Z5
                    S9 = W7 - R3 * Z5;
                    %                     790 T8 = W6 + R3 * Z4
                    T8 = W6 + R3 * Z4;
                    %                     791 T9 = W7 + R3 * Z5
                    T9 = W7 + R3 * Z5;
                    %                     792 D = T8 * T8 + T9 * T9
                    D = T8 * T8 + T9 * T9;
                    %                     793 H8 = (S8 * T8 + S9 * T9) / D - V8
                    H8 = (S8 * T8 + S9 * T9) / D - V8;
                    %                     794 H9 = (S9 * T8 - S8 * T9) / D - V9
                    H9 = (S9 * T8 - S8 * T9) / D - V9;
                    
                    %                     795 REM ----- COMPUTE CONTRIBUTION TO SUM
                    %                     796 S2 = W * (X(J) * R1 + Y(J) * R2 - (Z(J) - 2 * H(J2)) * R3)
                    S2 = W * (X(J) * R1 + Y(J) * R2 - (Z(J) - 2 * H(J2)) * R3);
                    %                     797 S1 = COS(S2)
                    S1 = cos(S2);
                    %                     798 S2 = SIN(S2)
                    S2 = sin(S2);
                    %                     799 B1 = F3 * (S1 * CR(I) - S2 * CI(I))
                    B1 = F3 * (S1 * CR(I) - S2 * CI(I));
                    %                     800 B2 = F3 * (S1 * CI(I) + S2 * CR(I))
                    B2 = F3 * (S1 * CI(I) + S2 * CR(I));
                    %                     801 W6 = B1 * V8 - B2 * V9
                    W6 = B1 * V8 - B2 * V9;
                    %                     802 W7 = B1 * V9 + B2 * V8
                    W7 = B1 * V9 + B2 * V8;
                    %                     803 D = CA(L) * V1 + CB(L) * V2
                    D = CA(L) * V1 + CB(L) * V2;
                    %                     804 Z6 = D * (B1 * H8 - B2 * H9)
                    Z6 = D * (B1 * H8 - B2 * H9);
                    %                     805 Z7 = D * (B1 * H9 + B2 * H8)
                    Z7 = D * (B1 * H9 + B2 * H8);
                    %                     806 X1 = X1 - (CA(L) * W6 + V1 * Z6)
                    X1 = X1 - (CA(L) * W6 + V1 * Z6);
                    %                     807 X2 = X2 - (CA(L) * W7 + V1 * Z7)
                    X2 = X2 - (CA(L) * W7 + V1 * Z7);
                    %                     808 Y1 = Y1 - (CB(L) * W6 + V2 * Z6)
                    Y1 = Y1 - (CB(L) * W6 + V2 * Z6);
                    %                     809 Y2 = Y2 - (CB(L) * W7 + V2 * Z7)
                    Y2 = Y2 - (CB(L) * W7 + V2 * Z7);
                    %                     810 Z1 = Z1 + CG(L) * W6
                    Z1 = Z1 + CG(L) * W6;
                    %                     811 Z2 = Z2 + CG(L) * W7
                    Z2 = Z2 + CG(L) * W7;
                end
                %                 812 NEXT F5
                % fprintf(fidPsi,'%d %e %e %e %e %e %e\n', I, X1, X2, Y1, Y2, Z1, Z2);
            end
            %             813 NEXT I
        end
        %         814 NEXT K
        
        %         815 H2 = -(X1 * T1 + Y1 * T2 + Z1 * T3) * G0
        H2 = -(X1 * T1 + Y1 * T2 + Z1 * T3) * G0;
        %         816 H1 = (X2 * T1 + Y2 * T2 + Z2 * T3) * G0
        H1 = (X2 * T1 + Y2 * T2 + Z2 * T3) * G0;
        %         817 X4 = -(X1 * V1 + Y1 * V2) * G0
        X4 = -(X1 * V1 + Y1 * V2) * G0;
        %         818 X3 = (X2 * V1 + Y2 * V2) * G0
        X3 = (X2 * V1 + Y2 * V2) * G0;
        % fprintf(fidPsi,'818 %d %e %e %e %e %e %e\n', I2, V1, V2, H1, H2, X3, X4);
        %         819 IF P$ = "D" THEN 827
        %         820 IF RD = 0 THEN 842
        %         821 H1 = H1 / RD
        %         822 H2 = H2 / RD
        %         823 X3 = X3 / RD
        %         824 X4 = X4 / RD
        %         825 GOTO 842
        
        %         826 REM ----- PATTERN IN DB
        %         827 P1 = -999
        P1 = -999;
        %         828 P2 = P1
        P2 = P1;
        %         829 P3 = P1
        P3 = P1;
        %         830 T1 = K9! * (H1 * H1 + H2 * H2)
        T1 = K9u * (H1 * H1 + H2 * H2);
        %         831 T2 = K9! * (X3 * X3 + X4 * X4)
        T2 = K9u * (X3 * X3 + X4 * X4);
        %         832 T3 = T1 + T2
        T3 = T1 + T2;
        % fprintf(fidPsi, '832 %d %e %e %e\n', I2, T1, T2, T3);
        %         833 REM ----- CALCULATE VALUES IN DB
        %         834 IF T1 > 1E-30 THEN P1 = 4.343 * LOG(T1)
        if (T1 > 1e-30), P1 = 4.343*log(T1); end
        %         835 IF T2 > 1E-30 THEN P2 = 4.343 * LOG(T2)
        if (T2 > 1e-30), P2 = 4.343*log(T2); end
        %         836 IF T3 > 1E-30 THEN P3 = 4.343 * LOG(T3)
        if (T3 > 1e-30), P3 = 4.343*log(T3); end
        %         837 PRINT #3, Q2; TAB(15); Q1; TAB(29); P1; TAB(43); P2; TAB(57); P3
        fprintf(fidPsi, dForm, Q2, Q1, P1, P2, P3);
        %         838 IF S$ = "Y" THEN PRINT #1, Q2; ","; Q1; ","; P1; ","; P2; ","; P3
        %         839 GOTO 866
        %         840 REM ----- PATTERN IN VOLTS/METER
        %         841 REM ----- MAGNITUDE AND PHASE OF E(THETA)
        %         842 S1 = 0
        %         843 IF (H1 = 0 AND H2 = 0) THEN 845
        %         844 S1 = SQR(H1 * H1 + H2 * H2)
        %         845 IF H1 <> 0 THEN 848
        %         846 S2 = 0
        %         847 GOTO 851
        %         848 S2 = ATN(H2 / H1) / P0
        %         849 IF H1 < 0 THEN S2 = S2 + SGN(H2) * 180
        
        %         850 REM ----- MAGNITUDE AND PHASE OF E(PHI)
        %         851 S3 = 0
        %         852 IF (X3 = 0 AND X4 = 0) THEN 854
        %         853 S3 = SQR(X3 * X3 + X4 * X4)
        %         854 IF X3 <> 0 THEN 857
        %         855 S4 = 0
        %         856 GOTO 859
        %         857 S4 = ATN(X4 / X3) / P0
        %         858 IF X3 < 0 THEN S4 = S4 + SGN(X4) * 180
        %         859 PRINT #3, USING "###.##    "; Q2, Q1;
        %         860 PRINT #3, USING "       ##.###^^^^"; S1 * F1;
        %         861 PRINT #3, USING "   ###.##   "; S2;
        %         862 PRINT #3, USING "       ##.###^^^^"; S3 * F1;
        %         863 PRINT #3, USING "   ###.##"; S4
        %         864 REM IF S$="Y" THEN PRINT #1,Q2;",";Q1;",";S1*F1;",";S2;",";S3*F1;","S4
        
        %         865 REM ----- INCREMENT ZENITH ANGLE
        %         866 Q2 = Q2 + ZC
        % fprintf(fidPsi,'I2: %d %e %e %e %e %e %e %e\n', I2, R1, R2, R3, T1, T2, T3, U4);
        Q2 = Q2 + ZC;
    end
    %     867 NEXT I2
    
    %     868 REM ----- INCREMENT AZIMUTH ANGLE
    %     869 Q1 = Q1 + AC
    Q1 = Q1 + AC;
end
% 870 NEXT I1
fprintf('Far Field Calculation Done.\n\n')
% 871 CLOSE #1
% 872 RETURN
return
