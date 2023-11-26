close all
clear all

R = REACHcal;
R.plotSourceModels;

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
R1 = R.tempOpt;
toc
R1.plotSourceModels
% 
% % subplot 221, R1.Sr36.network.getS.plot11dB('b--')
% % subplot 223, R1.Sr36.network.getS.plot11real('b--')
% % subplot 224, R1.Sr36.network.getS.plot11imag('b--')
% 
% subplot 221, R1.Sr27.network.getS.plot11dB('b--')
% subplot 223, R1.Sr27.network.getS.plot11real('b--')
% subplot 224, R1.Sr27.network.getS.plot11imag('b--')
