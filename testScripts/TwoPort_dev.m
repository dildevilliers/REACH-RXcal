close all
clear all

%% 
p = mfilename("fullpath");
[pth] = [fileparts(p),'\'];
dataPth = [pth,'..\data\S1P\'];
filePathName = [dataPth,'69_Ohms.s1p'];
[S69,freqData] = touchread(filePathName,1);


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

% %% Old code
% T_C1 = CparABCD(C1.*1e-12,freq);
% T_L1 = LserABCD(L1.*1e-9,freq);
% T_C2 = CparABCD(C2.*1e-12,freq);
% T_L2 = LserABCD(L2.*1e-9,freq);
% 
% 
% 
% 
% [T_load,T_adapt] = deal(zeros(2,2,Nf));
% for ff = 1:Nf
%     T_load(:,:,ff) = T_C1(:,:,ff)*T_L1(:,:,ff)*T_C2(:,:,ff)*T_L2(:,:,ff);
%     T_adapt(:,:,ff) = TlineABCD(A_Z0,1i.*2.*pi.*freq(ff).*sqrt(mu0.*eps0.*A_epsr),2.*A_len.*1e-3)*T_load(:,:,ff);
% end
% 
% % S = ABCD2S(T_load,Z0,R);
% S_old = ABCD2S(T_adapt,Z0,R);
% 
% 
% % Plot
% figure(1)
% subplot 211
% plot(freq./1e6,dB20(squeeze(S_old(1,1,:))),'k'), grid on, hold on
% xlabel('Frequency (MHz)')
% ylabel('|S_{11}| (dB)')
% % legend('Data','Model')
% title('69 \Omega load')
% subplot 212
% plot(real(squeeze(S_old(1,1,:))),imag(squeeze(S_old(1,1,:))),'k'), grid on, hold on
% axis equal

%% New code
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

%% Measured data
S11_69 = interp1(freqData,squeeze(S69(1,1,:)),freq,'linear');
subplot 211
plot(freq./1e6,dB20(S11_69),'b'), grid on, hold on
