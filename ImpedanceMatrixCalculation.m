function [CurrX,FLG] = ImpedanceMatrixCalculation(CurrX,freq,FLG,envir,geom)

global F4 F5 F6 F7 F8
global CSd

global fidZRZI

persistent Zmn

N = geom.N;
CABG = geom.CABG;
Sa = geom.Sa;
Cp = geom.Cp;
Wp = geom.Wp;
XYZa = geom.XYZa;
A = geom.A;
J2a = geom.J2a;


% 195 REM ********** IMPEDANCE MATRIX CALCULATION **********
if FLG == 1      % NEW EXCITATION, RECALCULATE CURRENT % 196 IF FLG=1 THEN 428
    [CurrX] = MatSolve(Zmn,freq.m,FLG);
    SourceData(CurrX);
    return
end
if FLG == 2      % NO NEED to RECALCULATE              % 197 IF FLG=2 THEN 477
    SourceData(CurrX);
    return
end

Zmn = complex(zeros(N,N),0);

% 210 REM ----- COMPUTE ROW I OF MATRIX (OBSERVATION LOOP)
for I =1:N  % 211 FOR I=1 TO N  (to 336)
    I1 = abs(Cp(I,1));                  % 212 I1=ABS(C%(I,1))
    I2 = abs(Cp(I,2));                  % 213 I2=ABS(C%(I,2))
    % Sa = segment length
    F4 = sign(Cp(I,1))*Sa(I1);          % 214 F4=SGN(C%(I,1))*S(I1)
    F5 = sign(Cp(I,2))*Sa(I2);          % 215 F5=SGN(C%(I,2))*S(I2)

    % 216 REM ----- R(M + 1/2) - R(M - 1/2) HAS COMPONENTS (T5,T6,T7)
    % CABG = Direction Cosines
    if Cp(I,1) == -Cp(I,2)              % 220
        dRm = [F4 F4 Sa(I1)]'.*CABG(I1,:)' + [F5 F5 Sa(I1)]'.*CABG(I2,:)';
    else
        dRm = [F4 F4 F4]'.*CABG(I1,:)' + [F5 F5 F5]'.*CABG(I2,:)';
    end

    % 221 REM ----- COMPUTE COLUMN J OF ROW I (SOURCE LOOP)
    for J = 1:N  % 222 FOR J=1 TO N (to 333)
        J1 = abs(Cp(J,1));              % 223 J1=ABS(C%(J,1))
        J2 = abs(Cp(J,2));              % 224 J2=ABS(C%(J,2))
        F4 = sign(Cp(J,1));             % 225 F4=SGN(C%(J,1))
        F5 = sign(Cp(J,2));             % 226 F5=SGN(C%(J,2))
        F6 = 1;                         % 227 F6=1
        F7 = 1;                         % 228 F7=1

        % 229 REM ----- IMAGE LOOP
        for K = 1:-2:envir.G                  % 230
            if ~(Cp(J,1) ~= -Cp(J,2))   % 231
                if K < 0
                    continue
                end % 232 IF K<0 THEN 332
                F6 = F4;                % 233 F6=F4
                F7 = F5;                % 234 F7=F5
            end
            F8 = 0;                     % 235 F8=0
            if K < 0                    % 236 IF K<0 THEN 248
                Zmn = Beta_247_315Cmplx(I,J,K,J1,J2,dRm,CSd,Zmn,freq,geom); % *******************
            else
                % 237 REM ----- SET FLAG TO AVOID REDUNANT CALCULATIONS
                L238 = I1 ~= I2;
                L239 = (CABG(I1,1) + CABG(I1,2)) == 0;
                L240 = Cp(I,1) ~= Cp(I,2);
                L241 = J1 ~= J2;
                L242 = (CABG(J1,1) + CABG(J1,2)) == 0;
                L243 = Cp(J,1) ~= Cp(J,2);
                % Tested with http://electronics-course.com/boolean-algebra
                if ((L239 || ~L240) && (L242 || ~L243) && ~L238 && ~L241 )
                    if I1 == J1
                        F8 = 1;
                    end  %244 IF I1=J1 THEN F8=1
                    if I == J
                        F8 = 2;
                    end %245 IF I=J THEN F8=2
                end

                if real(Zmn(I,J)) == 0
                    Zmn = Beta_247_315Cmplx(I,J,K,J1,J2,dRm,CSd,Zmn,freq,geom);  % *******************
                end
            end

            % 316 REM ----- AVOID REDUNANT CALCULATIONS
            if J < I
                continue
            end     % 317 IF J<I THEN 332
            if F8 == 0
                continue
            end   % 318 IF F8=0 THEN 332
            Zmn(J,I) = Zmn(I,J);

            % 321 REM ----- SEGMENTS ON SAME WIRE SAME DISTANCE APART HAVE SAME Z
            P1 = J + 1;                 % 322 P1=J+1
            if P1 > N
                continue
            end    % 323 IF P1>N THEN 332
            if Cp(P1,1) ~= Cp(P1,2)
                continue
            end % 324
            if ~(Cp(P1,2) == Cp(J,2))  % 325 IF C%(P1,2)=C%(J,2) THEN 328
                if Cp(P1,2) ~= -Cp(J,2)
                    continue
                end % 326
                if (CABG(J2,1) + CABG(J2,2)) ~= 0
                    continue
                end % 327
            end
            P2 = I + 1;                 % 328 P2=I+1
            if P2 > N
                continue
            end    % 329 IF P2>N THEN 332
            Zmn(P2,P1) = Zmn(I,J);
        end                             % 332 NEXT K
        fprintf(fidZRZI,'332 %d %d %e %e\n', I, J, real(Zmn(I,J)), imag(Zmn(I,J)));
    end  % 333 NEXT J
end  % 336 NEXT I

[CurrX,FLG] = MatSolve(Zmn,freq.M,FLG);

SourceData(CurrX);

save ZRZI

return  % 495 RETURN