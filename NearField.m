function [CurrX,FLG] = NearField(XYZa,freq,FLG,envir,CurrX,geom)

global  PWR NM F BSd N Cp W Sa Wp Ua S0
global CABG Xa Ya Za CR CI G0
global fidPsi

% FLG G

% 873 REM ********** NEAR FIELD CALCULATION **********
% 874 REM ----- ENSURE CURRENTS HAVE BEEN CALCULATED
% 875 IF FLG < 2 THEN GOSUB 196
if (FLG < 2)
    [CurrX,FLG] = ImpedanceMatrixCalculation(CurrX,freq,FLG,envir,geom);
end
% 876 O2 = PWR
O2 = PWR;
% 877 PRINT #3, " "
% 878 PRINT #3, B$; "    NEAR FIELDS     "; B$
fprintf( '\n%s    NEAR FIELDS      %s\n\n', BSd, BSd);
% 879 PRINT #3, " "
% 880 INPUT "ELECTRIC OR MAGNETIC NEAR FIELDS (E/H) "; N$
% 881 IF (N$ = "H" OR N$ = "E") GOTO 883
% 882 GOTO 880
% 883 PRINT
% 884 REM ----- INPUT VARIABLES FOR NEAR FIELD CALCULATION
% 885 PRINT "FIELD LOCATION(S):"
% 886 A$ = "-COORDINATE (M): INITIAL,INCREMENT,NUMBER "
% 887 PRINT "   X"; A$;
% 888 INPUT XI, XC, NX
XI = 1;
XC = 2;
NX = 3;
% 889 IF NX = 0 THEN NX = 1
% 890 IF O$ > "C" THEN PRINT #3, "X"; A$; ": "; XI; ","; XC; ","; NX
% 891 PRINT "   Y"; A$;
% 892 INPUT YI, YC, NY
YI = 4;
YC = 5;
NY = 6;
% 893 IF NY = 0 THEN NY = 1
% 894 IF O$ > "C" THEN PRINT #3, "Y"; A$; ": "; YI; ","; YC; ","; NY
% 895 PRINT "   Z"; A$;
% 896 INPUT ZI, ZC, NZ
ZI = 7;
ZC = 8;
NZ = 9;
% 897 IF NZ = 0 THEN NZ = 1
% 898 IF O$ > "C" THEN PRINT #3, "Z"; A$; ": "; ZI; ","; ZC; ","; NZ
% 899 F1 = 1
F1 = 1;
% 900 PRINT
% 901 PRINT "PRESENT POWER LEVEL IS "; PWR; " WATTS"
% 902 INPUT "CHANGE POWER LEVEL (Y/N) "; A$
% 903 IF A$ = "N" THEN 908
% 904 IF A$ <> "Y" THEN 902
% 905 INPUT "NEW POWER LEVEL (WATTS)  "; O2
% 906 IF O$ > "C" THEN PRINT #3, " ": PRINT #3, "NEW POWER LEVEL (WATTS) = "; O2
% 907 GOTO 902
% 908 IF (O2 < 0 OR O2 = 0) THEN O2 = PWR
if ((O2 < 0) || (O2 == 0)), O2 = PWR; end

% 909 REM ----- RATIO OF POWER LEVELS
% 910 F1 = SQR(O2 / PWR)
F1 = sqrt(O2/PWR);
% 911 IF N$ = "H" THEN F1 = F1 / S0 / 4 / P
% 912 PRINT
% 913 REM ----- DESIGNATION OF OUTPUT FILE FOR NEAR FIELD DATA
% 914 INPUT "SAVE TO A FILE (Y/N) "; S$
% 915 IF S$ = "N" THEN 923
% 916 IF S$ <> "Y" THEN 914
% 917 INPUT "FILENAME (NAME.OUT)  "; F$
% 918 IF LEFT$(RIGHT$(F$, 4), 1) = "." THEN 919 ELSE F$ = F$ + ".OUT"
% 919 IF O$ > "C" THEN PRINT #3, " ": PRINT #3, "FILENAME (NAME.OUT) "; F$
% 920 OPEN F$ FOR OUTPUT AS #2
% 921 PRINT #2, NX * NY * NZ; ","; O2; ","; N$
% 922 REM ----- LOOP OVER Z DIMENSION
% 923 FOR IZ = 1 TO NZ
for IZ = 1:NZ
    %     924 ZZ = ZI + (IZ - 1) * ZC
    ZZ = ZI + (IZ - 1) * ZC;
    %     925 REM ----- LOOP OVER Y DIMENSION
    %     926 FOR IY = 1 TO NY
    for IY = 1:NY
        %         927 YY = YI + (IY - 1) * YC
        YY = YI + (IY - 1) * YC;
        %         928 REM ----- LOOP OVER X DIMENSION
        %         929 FOR IX = 1 TO NX
        for IX = 1:NX
            %             930 XX = XI + (IX - 1) * XC
            XX = XI + (IX - 1) * XC;
            %             931 REM ----- NEAR FIELD HEADER
            %             932 PRINT #3, " "
            %             933 IF N$ = "E" THEN PRINT #3, B$; "NEAR ELECTRIC FIELDS"; B$
            %             934 IF N$ = "H" THEN PRINT #3, B$; "NEAR MAGNETIC FIELDS"; B$
            %             935 PRINT #3, TAB(10); "FIELD POINT: "; "X = "; XX; " Y = "; YY; " Z = "; ZZ
            %             936 PRINT #3, "  VECTOR", "REAL", "IMAGINARY", "MAGNITUDE", "PHASE"
            %             937 IF N$ = "E" THEN A$ = " V/M "
            %             938 IF N$ = "H" THEN A$ = " AMPS/M "
            %             939 PRINT #3, " COMPONENT  ", A$, A$, A$, " DEG"
            %             940 A1 = 0
            A1 = 0;
            %             941 A3 = 0
            A3 = 0;
            %             942 A4 = 0
            A4 = 0;
            %             943 REM ----- LOOP OVER THREE VECTOR COMPONENTS
            %             944 FOR I = 1 TO 3 % 1097
            for I = 1:3
                %                 945 X0 = XX
                X0 = XX;
                %                 946 Y0 = YY
                Y0 = YY;
                %                 947 Z0 = ZZ
                Z0 = ZZ;
                %                 948 IF N$ = "H" THEN 958
                %                 949 T5 = 0
                T5 = 0;
                %                 950 T6 = 0
                T6 = 0;
                %                 951 T7 = 0
                T7 = 0;
                %                 952 IF I = 1 THEN T5 = 2 * S0
                if (I == 1), T5 = 2 * S0; end
                %                 953 IF I = 2 THEN T6 = 2 * S0
                if (I == 2), T6 = 2 * S0; end
                %                 954 IF I = 3 THEN T7 = 2 * S0
                if (I == 3), T7 = 2 * S0; end
                %                 955 U7 = 0
                U7 = 0;
                %                 956 U8 = 0
                U8 = 0;
                %                 957 GOTO 968

                %                 958 FOR J8 = 1 TO 6
                %                     959 K!(J8, 1) = 0
                %                     960 K!(J8, 2) = 0
                %                 961 NEXT J8
                %                 962 J9 = 1
                %                 963 J8 = -1
                %                 964 IF I = 1 THEN X0 = XX + J8 * S0 / 2
                %                 965 IF I = 2 THEN Y0 = YY + J8 * S0 / 2
                %                 966 IF I = 3 THEN Z0 = ZZ + J8 * S0 / 2

                %                 967 REM ----- LOOP OVER SOURCE SEGMENTS
                %                 968 FOR J = 1 TO N
                for J = 1:N
                    %                     969 J1 = ABS(C%(J, 1))
                    J1 = abs(Cp(J,1));
                    %                     970 J2 = ABS(C%(J, 2))
                    J2 = abs(Cp(J,2));
                    %                     971 J3 = J2
                    J3 = J2;
                    %                     972 IF J1 > J2 THEN J3 = J1
                    if (J1 > J2), J3 = J1; end
                    %                     973 F4 = SGN(C%(J, 1))
                    F4 = sign(Cp(J,1));
                    %                     974 F5 = SGN(C%(J, 2))
                    F5 = sign(Cp(J,2));
                    %                     975 F6 = 1
                    F6 = 1;
                    %                     976 F7 = 1
                    F7 = 1;
                    %                     977 U5 = 0
                    U5 = 0;
                    %                     978 U6 = 0
                    U6 = 0;
                    %                     979 REM ----- IMAGE LOOP
                    %                     980 FOR K = 1 TO G STEP -2
                    for K = 1:-2:envir.G
                        %                         981 IF C%(J, 1) <> -C%(J, 2) THEN 987
                        %                         982 IF K < 0 THEN 1048
                        if (K < 0), continue, end
                        %                         983 REM ----- COMPUTE VECTOR POTENTIAL A
                        %                         984 F6 = F4
                        %                         985 F7 = F5
                        %                         986 REM ----- COMPUTE PSI(0,J,J+.5)
                        %                         987 P1 = 0
                        %                         988 P2 = 2 * J3 + J - 1
                        %                         989 P3 = P2 + .5
                        %                         990 P4 = J2
                        %                         991 GOSUB 75 Se i psi.m
                        %                         992 U1 = T1 * F5
                        %                         993 U2 = T2 * F5
                        %                         994 REM ----- COMPUTE PSI(0,J-.5,J)
                        %                         995 P3 = P2
                        %                         996 P2 = P2 - .5
                        %                         997 P4 = J1
                        %                         998 GOSUB 66 Se i psi.m
                        %                         999 V1 = F4 * T1
                        %                         1000 V2 = F4 * T2
                        %                         1001 REM ----- REAL PART OF VECTOR POTENTIAL CONTRIBUTION
                        %                         1002 X3 = U1 * CA(J2) + V1 * CA(J1)
                        %                         1003 Y3 = U1 * CB(J2) + V1 * CB(J1)
                        %                         1004 Z3 = (F7 * U1 * CG(J2) + F6 * V1 * CG(J1)) * K
                        %                         1005 REM ----- IMAGINARY PART OF VECTOR POTENTIAL CONTRIBUTION
                        %                         1006 X5 = U2 * CA(J2) + V2 * CA(J1)
                        %                         1007 Y5 = U2 * CB(J2) + V2 * CB(J1)
                        %                         1008 Z5 = (F7 * U2 * CG(J2) + F6 * V2 * CG(J1)) * K
                        %                         1009 REM ----- MAGNETIC FIELD CALCULATION COMPLETED
                        %                         1010 IF N$ = "H" THEN 1042
                        %                         1011 D1 = (X3 * T5 + Y3 * T6 + Z3 * T7) * W2
                        %                         1012 D2 = (X5 * T5 + Y5 * T6 + Z5 * T7) * W2
                        %                         1013 REM ----- COMPUTE PSI(.5,J,J+1)
                        %                         1014 P1 = .5
                        %                         1015 P2 = P3
                        %                         1016 P3 = P3 + 1
                        %                         1017 P4 = J2
                        %                         1018 GOSUB 56 Se i psi.m
                        %                         1019 U1 = T1
                        %                         1020 U2 = T2
                        %                         1021 REM ----- COMPUTE PSI(-.5,J,J+1)
                        %                         1022 P1 = -P1
                        %                         1023 GOSUB 56 Se i psi.m
                        %                         1024 U1 = (T1 - U1) / S(J2)
                        %                         1025 U2 = (T2 - U2) / S(J2)
                        %                         1026 REM ----- COMPUTE PSI(.5,J-1,J)
                        %                         1027 P1 = -P1
                        %                         1028 P3 = P2
                        %                         1029 P2 = P2 - 1
                        %                         1030 P4 = J1
                        %                         1031 GOSUB 56 Se i psi.m
                        %                         1032 U3 = T1
                        %                         1033 U4 = T2
                        %                         1034 REM ----- COMPUTE PSI(-.5,J-1,J)
                        %                         1035 P1 = -P1
                        %                         1036 GOSUB 56 Se i psi.m
                        %                         1037 REM ----- GRADIENT OF SCALAR POTENTIAL
                        %                         1038 U5 = (U1 + (U3 - T1) / S(J1) + D1) * K + U5
                        %                         1039 U6 = (U2 + (U4 - T2) / S(J1) + D2) * K + U6
                        %                         1040 GOTO 1048
                        %                         1041 REM ----- COMPONENTS OF VECTOR POTENTIAL A
                        %                         1042 K!(1, J9) = K!(1, J9) + (X3 * CR(J) - X5 * CI(J)) * K
                        %                         1043 K!(2, J9) = K!(2, J9) + (X5 * CR(J) + X3 * CI(J)) * K
                        %                         1044 K!(3, J9) = K!(3, J9) + (Y3 * CR(J) - Y5 * CI(J)) * K
                        %                         1045 K!(4, J9) = K!(4, J9) + (Y5 * CR(J) + Y3 * CI(J)) * K
                        %                         1046 K!(5, J9) = K!(5, J9) + (Z3 * CR(J) - Z5 * CI(J)) * K
                        %                         1047 K!(6, J9) = K!(6, J9) + (Z5 * CR(J) + Z3 * CI(J)) * K
                        %                     1048 NEXT K
                    end
                    %                     1049 IF N$ = "H" THEN 1052
                    %                     1050 U7 = U5 * CR(J) - U6 * CI(J) + U7
                    U7 = U5 * CR(J) - U6 * CI(J) + U7;
                    %                     1051 U8 = U6 * CR(J) + U5 * CI(J) + U8
                    U8 = U6 * CR(J) + U5 * CI(J) + U8;
                    %                 1052 NEXT J
                end
                %                 1053 IF N$ = "E" THEN 1075
                %                 1054 REM ----- DIFFERENCES OF VECTOR POTENTIAL A
                %                 1055 J8 = 1
                %                 1056 J9 = J9 + 1
                %                 1057 IF J9 = 2 THEN 964
                %                 1058 ON I GOTO 1059, 1064, 1069
                %                 1059 H(3) = K!(5, 1) - K!(5, 2)
                %                 1060 H(4) = K!(6, 1) - K!(6, 2)
                %                 1061 H(5) = K!(3, 2) - K!(3, 1)
                %                 1062 H(6) = K!(4, 2) - K!(4, 1)
                %                 1063 GOTO 1097
                %                 1064 H(1) = K!(5, 2) - K!(5, 1)
                %                 1065 H(2) = K!(6, 2) - K!(6, 1)
                %                 1066 H(5) = H(5) - K!(1, 2) + K!(1, 1)
                %                 1067 H(6) = H(6) - K!(2, 2) + K!(2, 1)
                %                 1068 GOTO 1097
                %                 1069 H(1) = H(1) - K!(3, 2) + K!(3, 1)
                %                 1070 H(2) = H(2) - K!(4, 2) + K!(4, 1)
                %                 1071 H(3) = H(3) + K!(1, 2) - K!(1, 1)
                %                 1072 H(4) = H(4) + K!(2, 2) - K!(2, 1)
                %                 1073 GOTO 1097
                %                 1074 REM ----- IMAGINARY PART OF ELECTRIC FIELD
                %                 1075 U7 = -M * U7 / S0
                %                 1076 REM ----- REAL PART OF ELECTRIC FIELD
                %                 1077 U8 = M * U8 / S0
                %                 1078 REM ----- MAGNITUDE AND PHASE CALCULATION
                %                 1079 S1 = 0
                %                 1080 IF (U7 = 0 AND U8 = 0) THEN 1082
                %                 1081 S1 = SQR(U7 * U7 + U8 * U8)
                %                 1082 S2 = 0
                %                 1083 IF U8 <> 0 THEN S2 = ATN(U7 / U8) / P0
                %                 1084 IF U8 > 0 THEN 1086
                %                 1085 S2 = S2 + SGN(U7) * 180
                %                 1086 IF I = 1 THEN PRINT #3, "   X  ",
                %                 1087 IF I = 2 THEN PRINT #3, "   Y  ",
                %                 1088 IF I = 3 THEN PRINT #3, "   Z  ",
                %                 1089 PRINT #3, TAB(15); F1 * U8; TAB(29); F1 * U7; TAB(43); F1 * S1; TAB(57); S2
                %                 1090 IF S$ = "Y" THEN PRINT #2, F1 * U8; ","; F1 * U7; ","; F1 * S1; ","; S2
                %                 1091 REM ----- CALCULATION FOR PEAK ELECTRIC FIELD
                %                 1092 S1 = S1 * S1
                %                 1093 S2 = S2 * P0
                %                 1094 A1 = A1 + S1 * COS(2 * S2)
                %                 1095 A3 = A3 + S1 * SIN(2 * S2)
                %                 1096 A4 = A4 + S1
                %             1097 NEXT I
            end
            %             1098 IF N$ = "E" THEN 1121
            %             1099 REM ----- MAGNETIC FIELD MAGNITUDE AND PHASE CALCULATION
            %             1100 FOR I = 1 TO 5 STEP 2
            for I = 1:2:5
                %                 1101 S1 = 0
                %                 1102 IF (H(I) = 0 AND H(I + 1) = 0) THEN 1104
                %                 1103 S1 = SQR(H(I) * H(I) + H(I + 1) * H(I + 1))
                %                 1104 S2 = 0
                %                 1105 IF H(I) <> 0 THEN S2 = ATN(H(I + 1) / H(I)) / P0
                %                 1106 IF H(I) > 0 THEN 1108
                %                 1107 S2 = S2 + SGN(H(I + 1)) * 180
                %                 1108 IF I = 1 THEN PRINT #3, "   X  ",
                %                 1109 IF I = 3 THEN PRINT #3, "   Y  ",
                %                 1110 IF I = 5 THEN PRINT #3, "   Z  ",
                %                 1111 PRINT #3, TAB(15); F1 * H(I); TAB(29); F1 * H(I + 1); TAB(43); F1 * S1; TAB(57); S2
                %                 1112 IF S$ = "Y" THEN PRINT #2, F1 * H(I); ","; F1 * H(I + 1); ","; F1 * S1; ","; S2
                %                 1113 REM ----- CALCULATION FOR PEAK MAGNETIC FIELD
                %                 1114 S1 = S1 * S1
                %                 1115 S2 = S2 * P0
                %                 1116 A1 = A1 + S1 * COS(2 * S2)
                %                 1117 A3 = A3 + S1 * SIN(2 * S2)
                %                 1118 A4 = A4 + S1
                %             1119 NEXT I
            end
            %             1120 REM ----- PEAK FIELD CALCULATION
            %             1121 PK = SQR(A4 / 2 + SQR(A1 * A1 + A3 * A3) / 2)
            %             1122 PRINT #3, "   MAXIMUM OR PEAK FIELD = "; F1 * PK; A$
            %             1123 IF (S$ = "Y" AND N$ = "E") THEN PRINT #2, F1 * PK; ","; O2
            %             1124 IF (S$ = "Y" AND N$ = "H") THEN PRINT #2, F1 * PK; ","; O2
            %             1125 IF S$ = "Y" THEN PRINT #2, XX; ","; YY; ","; ZZ
            %         1126 NEXT IX
        end
        %     1127 NEXT IY
    end
    % 1128 NEXT IZ
end
% 1129 CLOSE #2
% 1130 RETURN

return
