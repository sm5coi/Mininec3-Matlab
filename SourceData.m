function SourceData(CurrX)

global NS Ea Ma La BSd PWR fidPsi

% 476 REM ********** SOURCE DATA **********
fprintf('\n%s SOURCE DATA %s\n', BSd, BSd);
fprintf( fidPsi, '\n%s SOURCE DATA  %s\n', BSd, BSd);
PWR = 0;
for I = 1:NS
    cR = real(CurrX(Ea(I)));
    cI = imag(CurrX(Ea(I)));
    T = cR*cR + cI*cI;
    T1 = (La(I)*cR + Ma(I)*cI)/T;
    T2 = (Ma(I)*cR - La(I)*cI)/T;
    O2 = (La(I)*cR+Ma(I)*cI)/2;
    PWR = PWR + O2;
    fprintf('PULSE %d VOLTAGE = %5.1f%+5.1fj\n', Ea(I), La(I),Ma(I));
    fprintf( fidPsi, 'PULSE %d VOLTAGE = %5.1f%+5.1fj\n', Ea(I), La(I),Ma(I));
    fprintf('CURRENT = (%e %+ej)\n', cR, cI);
    fprintf( fidPsi, 'CURRENT = (%e %+ej)\n', cR, cI);
    fprintf('IMPEDANCE = (%e %+ej)\n',T1, T2);
    fprintf( fidPsi, 'IMPEDANCE = (%e %+ej)\n',T1, T2);
    fprintf('POWER = %e WATTS\n\n', O2);
    fprintf( fidPsi, 'POWER = %e WATTS\n\n', O2);
end
if NS > 1
   fprintf('\n TOTAL POWER = %e WATTS\n', PWR);
   fprintf( fidPsi, '\n TOTAL POWER = %e WATTS\n', PWR);
end
return