function AdditionOfLoads

% 342 REM ********** ADDITION OF LOADS **********
% 343 IF NL=0 THEN 377
% 344 F5=2*pi*F
% 345 FOR I=1 TO NL
% 346 	IF L$="N" THEN 366
% 347 	REM ----- S-PARAMETER LOADS
% 348 	U1=0
% 349 	U2=0
% 350 	D1=0
% 351 	D2=0
% 352 	S=1
% 353 	FOR J=0 TO LS(I) STEP 2
% 354 		U1=U1+LA(1,I,J)*S*F5^J
% 355 		D1=D1+LA(2,I,J)*S*F5^J
% 356 		L=J+1
% 357 		U2=U2+LA(1,I,L)*S*F5^L
% 358 		D2=D2+LA(2,I,L)*S*F5^L
% 359 		S=-S
% 360 	NEXT J
% 361 	J=LP(I)
% 362 	D=D1*D1+D2*D2
% 363 	LI=(U2*D1-D2*U1)/D
% 364 	LR=(U1*D1+U2*D2)/D
% 365 	GOTO 369
%
% 366 	LR=LA(1,I,1)
% 367 	LI=LA(2,I,1)
% 368 	J=LP(I)
% 369 	F2=1/M
% 370 	IF C%(J,1)<>-C%(J,2) THEN 372
% 371 	IF K<0 THEN F2=2/M
% 372 	ZR(J,J)=ZR(J,J)+F2*LI
% 373 	ZI(J,J)=ZI(J,J)-F2*LR
% 374 NEXT I
return
