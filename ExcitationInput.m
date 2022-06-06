function ExcitationInput(N,FLG)

global MP P0 Ea La Ma NS

%  FLG

% 1429 REM ********** EXCITATION INPUT **********
while 1
    NS = 1; 
    if NS < 1
        NS = 1
    end
    if NS <= MP
        break
    end
    fprintf('NO. OF SOURCES EXCEEDS DIMENSION ...\n')
end
%
for I = 1:NS
    while 1
        res = [1,1,0]; % PULSE NO., VOLTAGE MAGNITUDE, PHASE (DEGREES) [E V P]
        EM = res(1);
        VM = res(2);
        VP = res(3);
        if EM <= N
            break
        end
        fprintf('PULSE NUMBER EXCEEDS NUMBER OF PULSES...\n')
    end
    %
    Ea(I) = EM;
    La(I) = VM*cos(VP*P0);
    Ma(I) = VM*sin(VP*P0);
end
if FLG == 2, FLG = 1; end
return
% test av sista raden.