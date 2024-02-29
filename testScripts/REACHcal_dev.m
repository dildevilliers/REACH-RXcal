close all
clear all


%% Input script setup
dataPth = 'c:\Users\ddv\OneDrive - Stellenbosch University\Navorsing\REACH\Calibration\2023_12_11_10min-int_full-meas\14_32\';
R = REACHcal(dataPth);

return

%% Do the MTS fits with lab sources
% R1 = R.fitMTS;

R.plotAllS11(2,{'','k'})

% %% Do the MTS fits with lab sources
% % R1 = R.fitMTS;
% 
% R1 = R.optimConfig('open',[],[],3);
% R1 = R1.fitParams;
% 
% figure
% R1.Lc12r36.network.getS.plot11dB
% plot(R1.freq,dB20(R1.S11_meas_c12r36))
% 
% figure
% R1.Lc25open.network.getS.plot11dB
% plot(R1.freq,dB20(R1.S11_meas_c25open))
% 
% 
% return
% 




%% Some good fits
% % This set if for a good short cable fit
r36.vals = [3.8492 21.0167 4.5243 36.8479];
r27.vals = [4.4148 24.1903 9.0568 27.3331];
r69.vals = [7.2883 36.4569 4.6570 69.9235];
r91.vals = [8.3539 49.6584 3.7671 93.1463];
rOpen.vals = [3.3378 52.2454 3.7027 391.5123];
rShort.vals = [7.9373 18.6394 9.9928 0.3677];
r10.vals = [5.3058 20.9861 10.7688 10.3533];
r250.vals = [4.5536 21.6320 3.5899 254.1647];
rCold.vals = [0.3876 2.0638 0.0537 50.2550];
rHot.vals = [3.7886 9.7978 0.9865 50.8162];
r25.vals = [16.1297 9.6251 5.2162 25.1860];
r100.vals = [7.3128e-05 44.9274 2.6004 101.7963];
c2.vals = [49.4791 1.9407 0.0214 1.3723 0.0088 0.0093 0.0323 0.6720];
c10.vals = [49.7610 9.9198 -0.0118 1.4059 -0.0014 0.0068 0.0074 0.4267];
ms1.vals = [51.7101 13.3335 1.7260 0.0052 4.4804];
ms3.vals = [50.0232 13.3749 1.6933 0.0051 4.4749];
ms4.vals = [50.0232 13.3749 1.6933 0.0051 4.4749];
mts.vals = [50.9304 113.2259 1.6351 0.0059 3.9662];
sr_mtsj2.vals = [48.4377 125.1712 2.0504 2.5188e-04 0.9629];
sr_mtsj1.vals = [49.2178 124.9098 2.0459 2.5273e-04 1.0101];
sr_ms1j2.vals = [54.4476 114.7614 2.0523 2.9177e-04 1.0598];

R = REACHcal(dataPth,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
                'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
                'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
                'c2',c2,'c10',c10,...
                'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
                'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
% figure(1)
% R.plotAllS11(3,{'r','k'})
% figure(2)
% R.plotAllParameters('r*')
% 
% % % This set is good for a long cable fit
% % r36.vals = [3.8492      21.0167       4.5243      36.8479];
% % r27.vals = [4.4148      24.1903       9.0568      27.3331];
% % r69.vals = [7.2883      36.4569        4.657      69.9235];
% % r91.vals = [8.3539      49.6584       3.7671      93.1463];
% % rOpen.vals = [3.971437      52.36596      2.551372      391.5299];
% % rShort.vals = [4.57796      17.9006      9.99549     0.362966];
% % r10.vals = [4.47401      19.3911      10.8874      10.5237];
% % r250.vals = [4.436662      20.78295      2.818686      254.0834];
% % rCold.vals = [0.3876       2.0638       0.0537       50.255];
% % rHot.vals = [3.7886       9.7978       0.9865      50.8162];
% % r25.vals = [16.1297       9.6251       5.2162       25.186];
% % r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
% % ms1.vals = [51.7616      13.1041      1.68047   0.00532843      5.03607];
% % ms3.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
% % ms4.vals = [50.3913      13.8893      1.66496   0.00501457      4.99927];
% % mts.vals = [50.70389      113.1093      1.591984   0.006779474      5.488629];
% % sr_mtsj1.vals = [49.29323      124.2556      2.041442  0.0002499523     0.9009118];
% % sr_mtsj2.vals = [49.07511      124.3155      2.045816  0.0002440867     0.5608773];
% % sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
% % c2.vals = [49.4791       1.9407       0.0214       1.3723       0.0088       0.0093       0.0323        0.672];
% % c10.vals = [50.0058      9.93221  -0.00932534      1.41056  -0.00162869   0.00706399    0.0353731     0.392754];
% 
% This set is good for r10 and r250
% r36.vals = [3.8492      21.0167       4.5243      36.8479];
% r27.vals = [4.4148      24.1903       9.0568      27.3331];
% r69.vals = [7.2883      36.4569        4.657      69.9235];
% r91.vals = [8.3539      49.6584       3.7671      93.1463];
% rOpen.vals = [3.971437      52.36596      2.551372      391.5299];
% rShort.vals = [4.57796      17.9006      9.99549     0.362966];
% r10.vals = [14.0099      18.4338      19.1494      9.84993];
% r250.vals = [7.846784e-05      34.30101      6.257312      273.6188];
% rCold.vals = [0.3876       2.0638       0.0537       50.255];
% rHot.vals = [3.7886       9.7978       0.9865      50.8162];
% r25.vals = [16.1297       9.6251       5.2162       25.186];
% r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
% ms1.vals = [50.9362      13.0905      1.69934   0.00501107      4.96332];
% ms3.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
% ms4.vals = [49.946      14.3167      1.69818   0.00500727       4.9442];
% mts.vals = [50.4499      115.7623      1.678471   0.005072099      4.691394];
% sr_mtsj1.vals = [49.4545      124.3085      2.048575  0.0002501276     0.9876416];
% sr_mtsj2.vals = [49.25469      124.6742      2.048982  0.0002500739     0.9828439];
% sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
% c2.vals = [49.4791       1.9407       0.0214       1.3723       0.0088       0.0093       0.0323        0.672];
% c10.vals = [49.9823      9.93856   -0.0187272      1.41239  -0.00724262   0.00791879    0.0126217     0.409788];
% 
% R = REACHcal(dataPth,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
%                 'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
%                 'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
%                 'c2',c2,'c10',c10,...
%                 'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
%                 'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
% figure(1)
% R.plotAllS11(1,{'b'})
% figure(2)
% R.plotAllParameters('b*')
% 
% This set looks good for rOpen and rShort
r36.vals = [3.8492      21.0167       4.5243      36.8479];
r27.vals = [4.4148      24.1903       9.0568      27.3331];
r69.vals = [7.2883      36.4569        4.657      69.9235];
r91.vals = [8.3539      49.6584       3.7671      93.1463];
rOpen.vals = [2.322535      63.38746       4.23932      392.1202];
rShort.vals = [11.3904      18.7049      9.99554     0.310544];
r10.vals = [4.47401      19.3911      10.8874      10.5237];
r250.vals = [4.436662      20.78295      2.818686      254.0834];
rCold.vals = [0.3876       2.0638       0.0537       50.255];
rHot.vals = [3.7886       9.7978       0.9865      50.8162];
r25.vals = [16.1297       9.6251       5.2162       25.186];
r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
ms1.vals = [52.0168      14.1605      1.70057   0.00507891      4.96472];
ms3.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
ms4.vals = [50.112      13.9746      1.70107   0.00500376      4.92931];
mts.vals = [51.57888      107.0369        1.6228   0.005624205      7.635847];
sr_mtsj1.vals = [48.97274      124.2352      2.047108  0.0002478738     0.7075997];
sr_mtsj2.vals = [49.36386      124.0274      2.047696  0.0002460209     0.6147804];
sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
c2.vals = [49.4791       1.9407       0.0214       1.3723       0.0088       0.0093       0.0323        0.672];
c10.vals = [51.1024      9.93372   -0.0164242      1.41163  -0.00159683   0.00706765    0.0114086     0.396464];


R = REACHcal(dataPth,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
                'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
                'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
                'c2',c2,'c10',c10,...
                'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
                'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
figure(1)
R.plotAllS11(1,{'m'})
% R.plotAllS11(3,{'r','k'})
figure(2)
R.plotAllParameters('m*')

% This is my current best guess:
r36.vals = [3.8492      21.0167       4.5243      36.8479];
r27.vals = [4.4148      24.1903       9.0568      27.3331];
r69.vals = [7.2883      36.4569        4.657      69.9235];
r91.vals = [8.3539      49.6584       3.7671      93.1463];
rOpen.vals = [3.563987      53.27102      3.265524      391.5473];
rShort.vals = [5.42071        18.79      9.99092     0.407853];
r10.vals = [5.3424      20.6094      14.9282      10.3693];
r250.vals = [0.0009242954      13.26286      7.206573      262.5717];
rCold.vals = [0.3876       2.0638       0.0537       50.255];
rHot.vals = [3.7886       9.7978       0.9865      50.8162];
r25.vals = [16.1297       9.6251       5.2162       25.186];
r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
ms1.vals = [52.9984      13.0296      1.65023   0.00892856      5.88201];
ms3.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
ms4.vals = [48.0256      14.7282      1.78927   0.00319568      5.47695];
mts.vals = [50.9304      113.2259        1.6351        0.0059        3.9662];
sr_mtsj1.vals = [49.2178      124.9098        2.0459    0.00025273        1.0101];
sr_mtsj2.vals = [48.4377      125.1712        2.0504    0.00025188        0.9629];
sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
c2.vals = [49.4791       1.9407       0.0214       1.3723       0.0088       0.0093       0.0323        0.672];
c10.vals = [49.3773      9.93225   -0.0116175      1.40889  -0.00205473   0.00791344  -0.00816588     0.317861];


R = REACHcal(dataPth,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
                'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
                'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
                'c2',c2,'c10',c10,...
                'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
                'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
figure(1)
R.plotAllS11(1,{'b'})
% R.plotAllS11(3,{'r','k'})
figure(2)
R.plotAllParameters('b*')

% % This lot is good for ms3 lab
% r36.vals = [2.20876      19.4297      6.76495      36.6781];
% r27.vals = [0.311989      19.9545      11.5782      27.2906];
% r69.vals = [7.01316      31.5077      2.38305      69.4706];
% r91.vals = [8.18277       49.585      1.57307      91.4477];
% rOpen.vals = [3.3378       52.2454        3.7027      391.5123];
% rShort.vals = [7.9373      18.6394       9.9928       0.3677];
% r10.vals = [5.3058      20.9861      10.7688      10.3533];
% r250.vals = [4.5536        21.632        3.5899      254.1647];
% rCold.vals = [0.3876       2.0638       0.0537       50.255];
% rHot.vals = [3.7886       9.7978       0.9865      50.8162];
% r25.vals = [16.1297       9.6251       5.2162       25.186];
% r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
% ms1.vals = [48.1733      16.0726      1.71484   0.00511717      4.89182];
% ms3.vals = [50.6226      13.6571      1.69786   0.00503748      4.84406];
% ms4.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
% mts.vals = [50.9304      113.2259        1.6351        0.0059        3.9662];
% sr_mtsj1.vals = [49.2178      124.9098        2.0459    0.00025273        1.0101];
% sr_mtsj2.vals = [49.24141      125.6524      2.050857  0.0002505901      0.968197];
% sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
% c2.vals = [49.15      1.96048  -0.00348159      1.52339    0.0301139   0.00811307   0.00995774      1.08108];
% c10.vals = [49.761       9.9198      -0.0118       1.4059      -0.0014       0.0068       0.0074       0.4267];
% 
% % And this is optimized from the set above for the field S11 of ms3
% r36.vals = [1.68447      16.9893      6.26647      36.6907];
% r27.vals = [0.0227021      17.0528      10.6802      27.0777];
% r69.vals = [5.60127      25.5545      1.63803        70.01];
% r91.vals = [6.75522      44.2941      1.33815      92.9132];
% rOpen.vals = [3.3378       52.2454        3.7027      391.5123];
% rShort.vals = [7.9373      18.6394       9.9928       0.3677];
% r10.vals = [5.3058      20.9861      10.7688      10.3533];
% r250.vals = [4.5536        21.632        3.5899      254.1647];
% rCold.vals = [0.3876       2.0638       0.0537       50.255];
% rHot.vals = [3.7886       9.7978       0.9865      50.8162];
% r25.vals = [16.1297       9.6251       5.2162       25.186];
% r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
% ms1.vals = [52.1562      15.5191      1.74183   0.00579419      3.86014];
% ms3.vals = [51.6713      13.7342       1.8247   0.00595167      4.98557];
% ms4.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
% mts.vals = [51.14979      114.8133      1.723242   0.008508035      4.103113];
% sr_mtsj1.vals = [48.95633      125.8003      2.067713  0.0002641243     0.8839314];
% sr_mtsj2.vals = [48.0679      126.8923      2.036309    0.00026242       1.08962];
% sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
% c2.vals = [49.2484        1.942   -0.0115799      1.43708    0.0239805    0.0099076    0.0177584      1.22652];
% c10.vals = [49.761       9.9198      -0.0118       1.4059      -0.0014       0.0068       0.0074       0.4267];
% 
% R = REACHcal(dataPth,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
%                 'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
%                 'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
%                 'c2',c2,'c10',c10,...
%                 'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
%                 'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
% figure(1)
% R.plotAllS11(1,{'m'})
% figure(2)
% R.plotAllParameters('m*')

% % THis lot is good for ms4 lab
% r36.vals = [3.8492      21.0167       4.5243      36.8479];
% r27.vals = [4.4148      24.1903       9.0568      27.3331];
% r69.vals = [7.2883      36.4569        4.657      69.9235];
% r91.vals = [8.3539      49.6584       3.7671      93.1463];
% rOpen.vals = [3.522919      52.24799      3.250831      391.5135];
% rShort.vals = [5.65986      18.3851      9.99468     0.702259];
% r10.vals = [5.196      19.9265      10.9511      10.2307];
% r250.vals = [3.897265      21.53178       3.89646      254.3789];
% rCold.vals = [0.3876       2.0638       0.0537       50.255];
% rHot.vals = [3.7886       9.7978       0.9865      50.8162];
% r25.vals = [16.1297       9.6251       5.2162       25.186];
% r100.vals = [7.3128e-05       44.9274        2.6004      101.7963];
% ms1.vals = [50.6506      13.2002      1.68758   0.00503152      4.52485];
% ms3.vals = [50.0232      13.3749       1.6933       0.0051       4.4749];
% ms4.vals = [50.1903      13.5851      1.70354   0.00501494      4.52011];
% mts.vals = [50.9304      113.2259        1.6351        0.0059        3.9662];
% sr_mtsj1.vals = [49.2178      124.9098        2.0459    0.00025273        1.0101];
% sr_mtsj2.vals = [49.09445      125.1286       2.04904  0.0002504578     0.9836633];
% sr_ms1j2.vals = [54.4476      114.7614        2.0523    0.00029177        1.0598];
% c2.vals = [49.4791       1.9407       0.0214       1.3723       0.0088       0.0093       0.0323        0.672];
% c10.vals = [49.2353      9.96839   -0.0104859      1.42327  -0.00185764   0.00697546    0.0181239     0.386999];
% 
% R = REACHcal(dataPth,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
%                 'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
%                 'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
%                 'c2',c2,'c10',c10,...
%                 'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
%                 'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
% figure(1)
% R.plotAllS11(1,{'m'})
% figure(2)
% R.plotAllParameters('m*')

return

%% Run optimizations



% Ropt = R.optimConfig('custom',{'mts','sr_mtsj1'}, {'c12r36','c12r27','c12r69','c12r91'});

% Ropt = R.optimConfig('custom',{'rOpen','rShort','r10','r250','ms4','c10','ms1','sr_mtsj2','mts','sr_mtsj1'}, {'c25open','c25short','c25r10','c25r250'});
% Ropt = R.optimConfig('custom',{'r10','r250','ms4','c10','ms1','sr_mtsj2','mts','sr_mtsj1'}, {'c25r10','c25r250'});
% Ropt = R.optimConfig('rOpen');
% Ropt = R.optimConfig('r10');
% Ropt = R.optimConfig('r25_r36_r10');
% Ropt = R.optimConfig('custom',{'r25','r69','r10','ms3','ms4','c2','c10','ms1','sr_mtsj2','mts','sr_mtsj1'},{'r25','c12r69','c25r10'});
% Ropt = R.optimConfig('custom',{'r250'}, {'c25r250'});
% Ropt = R.optimConfig('ms4set_lim');
Ropt = R.optimConfig('ms4set_lim_10_250');
% Ropt = R.optimConfig('ms3set');
Ropt = Ropt.fitParams('fmincon');
figure(1)
Ropt.plotAllS11(1,{'b'})
figure(2)
Ropt.plotAllParameters('b*')

%% Old stuff below here

% figure
% subplot(2,2,1)
% R.S_meas_MS3_J1.plot11dB('k'), grid on, hold on
% R.S_meas_MS3_J2.plot11dB('b'), grid on, hold on
% R.S_meas_MS3_J3.plot11dB('r'), grid on, hold on
% R.S_meas_MS3_J4.plot11dB('g'), grid on, hold on
% R.ms3.network.getS.plot11dB('c')
% title('MS-3')
% subplot(2,2,2)
% R.S_meas_MS3_J1.plot11RI('k'), grid on, hold on
% R.S_meas_MS3_J2.plot11RI('b'), grid on, hold on
% R.S_meas_MS3_J3.plot11RI('r'), grid on, hold on
% R.S_meas_MS3_J4.plot11RI('g'), grid on, hold on
% R.ms3.network.getS.plot11RI('c')
% subplot(2,2,3)
% R.S_meas_MS3_J1.plot21dB('k'), grid on, hold on
% R.S_meas_MS3_J2.plot21dB('b'), grid on, hold on
% R.S_meas_MS3_J3.plot21dB('r'), grid on, hold on
% R.S_meas_MS3_J4.plot21dB('g'), grid on, hold on
% R.ms3.network.getS.plot21dB('c')
% subplot(2,2,4)
% R.S_meas_MS3_J1.plot21RI('k'), grid on, hold on
% R.S_meas_MS3_J2.plot21RI('b'), grid on, hold on
% R.S_meas_MS3_J3.plot21RI('r'), grid on, hold on
% R.S_meas_MS3_J4.plot21RI('g'), grid on, hold on
% R.ms3.network.getS.plot21RI('c')



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


% r36.vals = [1 1 1 1];
% r36.optFlag = [0 1 0 1];
% 
% r91.vals = [1 1 1 1];
% r91.optFlag = [0 1 0 1];
% 
% R_ = REACHcal([],'r36',r36,'r91',r91)

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

% Rhot = R.optimConfig('custom',{'rHot','sr_ms1j2'},{'rHot'});
% Rhot = Rhot.fitParams('fmincon');
% figure(1)
% Rhot.plotSourceAllS11(1,{'m'})
% figure(2)
% Rhot.plotAllParameters('m*')


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
