close all
clear all

R = REACHcal;

R.source_r36.getS.plot11dB
hold on

S11_36 = R.readSourceS11('c12r36');
plot(R.freq,dB20(S11_36),'r')

