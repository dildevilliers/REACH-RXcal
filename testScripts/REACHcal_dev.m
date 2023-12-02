close all
clear all

R = REACHcal;
R.plotSourceModels;

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
tic
R1 = R.fitParams;
toc
R1.plotSourceModels


% tic
% R1 = R.tempOpt;
% toc
% R1.plotSourceModels
% 
% % % subplot 221, R1.Sr36.network.getS.plot11dB('b--')
% % subplot 223, R1.Sr36.network.getS.plot11real('b--')
% % subplot 224, R1.Sr36.network.getS.plot11imag('b--')
% 
% subplot 221, R1.Sr27.network.getS.plot11dB('b--')
% subplot 223, R1.Sr27.network.getS.plot11real('b--')
% subplot 224, R1.Sr27.network.getS.plot11imag('b--')
