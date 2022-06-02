function V0 = EllipticIntegral(B)

% Following constants from Handbook of Mathematical Functions, 
% by Abramowitz and Stegun, Issued June 1964, page 591

C0 = 1.38629436112; C1 = 0.09666344259; C2 = 0.03590092383; C3 = 0.03742563713;
C4 = 0.01451196212; C5 = 0.5; C6 = 0.12498593397; C7 = 0.06880248576;
C8 = 0.0332835346; C9 = 0.00441787012;

% 45 W0=C0+B*(C1+B*(C2+B*(C3+B*C4)))
W0=C0+B*(C1+B*(C2+B*(C3+B*C4)));
% 46 W1=C5+B*(C6+B*(C7+B*(C8+B*C9)))
W1=C5+B*(C6+B*(C7+B*(C8+B*C9)));
% 47 V0=(W0-W1*LOG(B))*SQR(1-B)
V0=(W0-W1*log(B));

return