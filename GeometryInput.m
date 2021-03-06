function [N,NW,CABG,Sa,Na,Cp,Wp,XYZa,A,ELM,J1a,J2a,geom,FLG] = GeometryInput(G,FLG)

% global FLG

INFILE = 1;

if INFILE
    fid = fopen('MININEC.INP','r');
end

% 1150 REM ********** GEOMETRY INPUT **********
% 1151 REM ----- WHEN GEOMETRY IS CHANGED, ENVIRONMENT MUST BE CHECKED
% 1155 INPUT "NO. OF WIRES";NW
NW = 2;
ELM = zeros(NW*2,3);
J1a = zeros(NW,2);
J2a = zeros(NW,2);

% 1161 REM ----- INITIALIZE NUMBER OF PULSES TO ZERO
N = 0;
for I = 1:NW
    if INFILE
        [S1,XYZ1,XYZ2,Radie] = ReadInfile(fid);
        A(I) = Radie;
    else
        fprintf('\nWIRE NO. %d\n', I)
        S1 = input('   NO. OF SEGMENTS ')
        while 1
            XYZ1 = input('   END ONE COORDINATES [X,Y,Z] ')
            if (G >= 0)|| (XYZ1(3) >= 0), break, end
            fprintf('Z CANNOT BE NEGATIVE\n');
        end
        while 1
            XYZ2 = input('   END TWO COORDINATES [X,Y,Z] ')
            if (G >= 0)|| (XYZ2(3) >= 0), break, end
            fprintf('Z CANNOT BE NEGATIVE\n');
        end
        while 1
            A(I) = input('                        RADIUS ')
            if A(I) > 0, break, end
        end
    end
    % 1182 REM ----- DETERMINE CONNECTIONS
    [ELM,I1,I2,J1a,J2a] = Connections(I,NW,G,XYZ1,XYZ2,A,S1,ELM,J1a,J2a);
    % 1189 REM ----- COMPUTE DIRECTION COSINES
    XYZ3 = XYZ2 - XYZ1;
    D = sqrt(XYZ3*XYZ3');
    CABG(I,:) = XYZ3/D;
    Sa(I) = D/S1;
    % 1198 REM ----- COMPUTE CONNECTIVITY DATA (PULSES N1 TO N)
    N1 = N + 1;
    Na(I,1) = N1;
    if (S1 == 1) && (I1 == 0)
        Na(I,1) = 0;
    end
    N = N1 + S1;
    if I1 == 0
        N = N - 1;
    end
    if I2 == 0
        N = N - 1;
    end
    Na(I,2) = N;
    if (S1 == 1) && (I2 == 0)
        Na(I,2) = 0;
    end
    if N >= N1
        for J = N1:N
            Cp(J,1) = I;
            Cp(J,2) = I;
            Wp(J)   = I;
        end
        Cp(N1,1) = I1;
        Cp(N,2)  = I2;
        % 1216 REM ----- COMPUTE COORDINATES OF BREAK POINTS
        I1 = N1 + 2*(I-1);
        I3 = I1;
        Xa(I1) = XYZ1(1);
        Ya(I1) = XYZ1(2);
        Za(I1) = XYZ1(3);
        if Cp(N1,1) ~= 0
            I2=abs(Cp(N1,1));
            F3=sign(Cp(N1,1))*Sa(I2);
            Xa(I1) = Xa(I1) - F3*CABG(I2,1);
            Ya(I1) = Ya(I1) - F3*CABG(I2,2);
            if Cp(N1,1)== -I
                F3 = -F3;
            end
            Za(I1) = Za(I1) - F3*CABG(I2,3);
            I3 = I3 + 1;
        end
        I6 = N + 2*I;
        for I4 = I1+1:I6
            J = I4 - I3;
            Xa(I4) = XYZ1(1) + J*XYZ3(1)/S1;
            Ya(I4) = XYZ1(2) + J*XYZ3(2)/S1;
            Za(I4) = XYZ1(3) + J*XYZ3(3)/S1;
        end
        if Cp(N,2) ~= 0
            I2 = abs(Cp(N,2));
            F3 = sign(Cp(N,2))*Sa(I2);
            I3 = I6-1;
            Xa(I6) = Xa(I3) + F3*CABG(I2,1);
            Ya(I6) = Ya(I3) + F3*CABG(I2,2);
            if I == -Cp(N,2)
                F3 = -F3;
            end
            Za(I6) = Za(I3) + F3*CABG(I2,3);
        end
        continue;
    else % N < N1
        % 1246 REM ---- SINGLE SEGMEN 0 PULSE CASE
        I1 = N1 + 2*(I-1);
        Xa(I1)=XYZ1(1);
        Ya(I1)=XYZ1(2);
        Za(I1)=XYZ1(3);

        I1=I1+1;
        Xa(I1)=XYZ2(1);
        Ya(I1)=XYZ2(2);
        Za(I1)=XYZ2(3);
    end
end
% 1256 1291 ********** GEOMETRY OUTPUT **********
XYZa = [Xa; Ya; Za]';
Cp = GeometryOutput(N,Wp,NW,Na,Xa,Ya,Za,A,Cp);
% % 1292 REM ----- EXCITATION INPUT
ExcitationInput(N,FLG);
% % 1294 REM ----- LOADS/NETWORKS INPUT
FLG = LoadsInput(FLG);

geom.N = N;
geom.NW = NW;
geom.CABG = CABG;
geom.Sa = Sa;
geom.Na = Na;
geom.Cp = Cp;
geom.Wp = Wp;
geom.XYZa = XYZa;
geom.A = A;
geom.ELM = ELM;
geom.J1a = J1a;
geom.J2a = J2a;

FLG = 0;
return

%************************************************

function [S1,XYZ1,XYZ2,A] = ReadInfile(fid)

L = fscanf(fid,'%f',8);
S1 = L(1);
XYZ1 = L(2:4)';
XYZ2 = L(5:7)';
A = L(8);

return