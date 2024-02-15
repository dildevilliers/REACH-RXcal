close all
clear all


%% Input script setup
dataPth = 'c:\Users\ddv\OneDrive - Stellenbosch University\Navorsing\REACH\Calibration\2023_12_11_10min-int_full-meas\14_32\';

% Fit with everything
disp('Fitting for all cable parameters...')

c2.vals = [48.8416 1.9825 0 1.4919 -0.0018 0.0076 0 0.4753];
c2.max = [52,2.1,0.1,1.6,0.1,0.05,0.1,2];
c2.min = [48,1.9,-0.1,1.4,-0.1,0,-0.1,0];
c2.optFlag = [1,1,1,1,1,1,1,1];

c10.vals = [48.9523 9.9566 0 1.4272 -0.0013 0.0064 0 0.4759];
c10.max = [52,10.1,0.1,1.6,0.1,0.05,0.1,2];
c10.min = [48,9.9,-0.1,1.4,-0.1,0,-0.1,0];
c10.optFlag = [1,1,1,1,1,1,1,1];

R1 = REACHcal(dataPth,'c2',c2,'c10',c10);
R1 = R1.fitCables('c2');
R1 = R1.fitCables('c10');  

% Remove eps slope
disp('Removing eps slope...')

c2.vals = R1.c2_vals;
c2.vals(3) = 0;
c2.optFlag(3) = 0;

c10.vals = R1.c10_vals;
c10.vals(3) = 0;
c10.optFlag(3) = 0;

R2 = REACHcal(dataPth,'c2',c2,'c10',c10);
R2 = R2.fitCables('c2');
R2 = R2.fitCables('c10');  

% Remove R_prime slope
disp('Removing R_prime slope...')

c2.vals = R2.c2_vals;
c2.vals(7) = 0;
c2.optFlag(7) = 0;

c10.vals = R2.c10_vals;
c10.vals(7) = 0;
c10.optFlag(7) = 0;

R3 = REACHcal(dataPth,'c2',c2,'c10',c10);
R3 = R3.fitCables('c2');
R3 = R3.fitCables('c10'); 

% Remove R_prime
disp('Removing R_prime...')

c2.vals = R3.c2_vals;
c2.vals(8) = 0;
c2.optFlag(8) = 0;

c10.vals = R3.c10_vals;
c10.vals(8) = 0;
c10.optFlag(8) = 0;

R4 = REACHcal(dataPth,'c2',c2,'c10',c10);
R4 = R4.fitCables('c2');
R4 = R4.fitCables('c10'); 



disp('c2_vals (all): ')
disp(R1.c2_vals)
disp('c2_vals (no eps slope): ')
disp(R2.c2_vals)
disp('c2_vals (no eps slope, no R_prime slope): ')
disp(R3.c2_vals)
disp('c2_vals (no eps slope, no R_prime): ')
disp(R4.c2_vals)
disp('c10_vals (all): ')
disp(R1.c10_vals)
disp('c10_vals (no eps slope): ')
disp(R2.c10_vals)
disp('c10_vals (no eps slope, no R_prime slope): ')
disp(R3.c10_vals)
disp('c10_vals (no eps slope, no R_prime): ')
disp(R4.c10_vals)

subplot 221
R1.S_meas_c2.getS.plot11dB('k')
R1.c2.network.getS.plot11dB('r--')
R2.c2.network.getS.plot11dB('b--')
R3.c2.network.getS.plot11dB('m--')
R4.c2.network.getS.plot11dB('c--')
subplot 222
R1.S_meas_c2.getS.plot21dB('k')
R1.c2.network.getS.plot21dB('r--')
R2.c2.network.getS.plot21dB('b--')
R3.c2.network.getS.plot21dB('m--')
R4.c2.network.getS.plot21dB('c--')
subplot 223
R1.S_meas_c10.getS.plot11dB('k')
R1.c10.network.getS.plot11dB('r--')
R2.c10.network.getS.plot11dB('b--')
R3.c10.network.getS.plot11dB('m--')
R4.c10.network.getS.plot11dB('c--')
subplot 224
R1.S_meas_c10.getS.plot21dB('k')
R1.c10.network.getS.plot21dB('r--')
R2.c10.network.getS.plot21dB('b--')
R3.c10.network.getS.plot21dB('m--')
R4.c10.network.getS.plot21dB('c--')
legend('Measure','All','No eps slope','No Rprime slope','No Rprime')


