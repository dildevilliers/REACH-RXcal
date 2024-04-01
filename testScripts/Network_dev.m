close all
clear all



load("EMconstants.mat")
Z0 = 50;
Nf = 501;
freq = linspace(50,200,Nf).*1e6;

% Load
R = 68.67;
% Adaptor
L1 = 10.92; % nH
L2 = 7.96; % nH
C1 = 0.7; % pF
C2 = 3.3; % pF
A_len = 18;  % mm
A_epsr = 2.1;
A_Z0 = 50;


T_C1new = TwoPort.Cpar(C1.*1e-12,freq);
T_L1new = TwoPort.Lser(L1.*1e-9,freq);
T_C2new = TwoPort.Cpar(C2.*1e-12,freq);
T_L2new = TwoPort.Lser(L2.*1e-9,freq);
T_TX = TwoPort.Tline(A_Z0,2.*A_len.*1e-3,freq,A_epsr);

T = cascade([T_TX,T_C1new,T_L1new,T_C2new,T_L2new]);

T = T.freqChangeUnit('MHz');
T = T.getS(50,R);

figure(1)
subplot 211
T.plot11dB('r--')
subplot 212
T.plot11RI('r--')


%% 
R1 = OnePort.R(45,freq);
R2 = R1;
R3 = R2;
R4 = series([R1,R2,R3]);

figure
R4.plot11mag

%%

T1 = T_TX;
R1 = OnePort.R(50,freq);
R2 = parallel([R1,R1]);
T2 = cascade([T1,R2.series2port]);

figure
T2.getS.plot11dB
