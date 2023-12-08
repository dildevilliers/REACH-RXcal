close all
clear all

R = REACHcal;
figure(1)
R.plotSourceAllS11(3,{'r','k'})
figure(2)
R.plotAllParameters('k*')

figure
subplot(2,2,1)
R.S_meas_MS3_J1.plot11dB('k'), grid on, hold on
R.S_meas_MS3_J2.plot11dB('b'), grid on, hold on
R.S_meas_MS3_J3.plot11dB('r'), grid on, hold on
R.S_meas_MS3_J4.plot11dB('g'), grid on, hold on
R.ms3.network.getS.plot11dB('c')
title('MS-3')
subplot(2,2,2)
R.S_meas_MS3_J1.plot11RI('k'), grid on, hold on
R.S_meas_MS3_J2.plot11RI('b'), grid on, hold on
R.S_meas_MS3_J3.plot11RI('r'), grid on, hold on
R.S_meas_MS3_J4.plot11RI('g'), grid on, hold on
R.ms3.network.getS.plot11RI('c')
subplot(2,2,3)
R.S_meas_MS3_J1.plot21dB('k'), grid on, hold on
R.S_meas_MS3_J2.plot21dB('b'), grid on, hold on
R.S_meas_MS3_J3.plot21dB('r'), grid on, hold on
R.S_meas_MS3_J4.plot21dB('g'), grid on, hold on
R.ms3.network.getS.plot21dB('c')
subplot(2,2,4)
R.S_meas_MS3_J1.plot21RI('k'), grid on, hold on
R.S_meas_MS3_J2.plot21RI('b'), grid on, hold on
R.S_meas_MS3_J3.plot21RI('r'), grid on, hold on
R.S_meas_MS3_J4.plot21RI('g'), grid on, hold on
R.ms3.network.getS.plot21RI('c')



% S11_36 = R.readSourceS11('c12r36');
% S11_27 = R.readSourceS11('c12r27');
% 
% figure(1)
% subplot 221
% % R.Sr36.network.getS.plot11dB
% R.Sr27.network.getS.plot11dB
% hold on
% % plot(R.freq,dB20(S11_36),'r--')
% plot(R.freq,dB20(S11_27),'r--')
% 
% subplot 223
% % R.Sr36.network.getS.plot11real
% R.Sr27.network.getS.plot11real
% hold on
% % plot(R.freq,real(S11_36),'r--')
% plot(R.freq,real(S11_27),'r--')
% 
% subplot 224
% % R.Sr36.network.getS.plot11imag
% R.Sr27.network.getS.plot11imag
% hold on
% % plot(R.freq,imag(S11_36),'r--')
% plot(R.freq,imag(S11_27),'r--')


%% Run optimization test

% Rms3 = R.optimConfig('ms3set');
% Rms3 = Rms3.fitParams('fmincon');
% figure(1)
% Rms3.plotSourceAllS11(1,{'b'})
% figure(2)
% Rms3.plotAllParameters('b*')

% % 
% Rms4 = R.optimConfig('ms4set_lim_10_250');
% Rms4 = Rms4.fitParams('ga');
% figure(1)
% Rms4.plotSourceAllS11(1,{'m'})
% figure(2)
% Rms4.plotAllParameters('m*')

% Ropen = R.optimConfig('rOpen');
% Ropen = Ropen.fitParams('fmincon');
% figure(1)
% Ropen.plotSourceAllS11(1,{'m'})
% figure(2)
% Ropen.plotAllParameters('m*')
% 
% R100 = R.optimConfig('custom',{'r100'},{'r100'});
% R100 = R100.fitParams('fmincon');
% figure(1)
% R100.plotSourceAllS11(1,{'m'})
% figure(2)
% R100.plotAllParameters('m*')


% tic
% R = R.optimConfig('custom',{'r36','ms3','c2'},{'r36'});
% % R = R.optimConfig('ms3set');
% R1 = R.fitParams('fmincon');
% % R1 = R.fitParams('ga');
% toc
% figure(1)
% R1.plotSourceAllS11(1,{'b'})
% 
% R36 = R.optimConfig('custom',{'r36'},{'r36'});
% % R36 = R.optimConfig('r36');
% R36 = R36.fitParams('fmincon');
% figure(1)
% R36.plotSourceAllS11(1,{'b'})
% figure(2)
% R36.plotAllParameters('b*')



% 
% 
% R69 = R.optimConfig('r69');
% R69 = R69.fitParams('fmincon');
% figure(1)
% R69.plotSourceAllS11(1,{'m'})
% figure(2)
% R69.plotAllParameters('m*')


% R27 = R.optimConfig('r27');
% R27 = R27.fitParams('fmincon');
% figure(1)
% R27.plotSourceAllS11(1,{'m'})
% figure(2)
% R27.plotAllParameters('m*')

% R91 = R.optimConfig('r91');
% R91 = R91.fitParams('fmincon');
% figure(1)
% R91.plotSourceAllS11(1,{'m'})
% figure(2)
% R91.plotAllParameters('m*')

% 
% R3769 = R.optimConfig('custom',{'r36','r69','ms3','c2','ms1','sr_mtsj2','mts','sr_mtsj1'},{'r36','r69'});
% R3769 = R3769.fitParams('fmincon');
% figure(1)
% R3769.plotSourceAllS11(1,{'g'})
% figure(2)
% R3769.plotAllParameters('g*')

