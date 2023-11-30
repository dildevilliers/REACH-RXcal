classdef REACHcal

    properties

    end

    properties (SetAccess = private)
        dataPath(1,:) char
        dataPathMS3(1,:) char   % Path to the MS-3 2-port measured data
        

        Nf(1,1) double = 101
        fmin(1,1) double = 50  % in MHz
        fmax(1,1) double = 200 % in MHz

        % Resistors
        r36_vals = [4.6759 24.9711 7.2820 37.5758];
        r36_unitScales = [1e-12,1e-9,1e-12,1];
        r36_max = [20,40,20,38];
        r36_min = [0,0,0,34];
        r36_optFlag = [1,1,1,1];

        r27_vals = [3.5919 23.8815 9.9348 28.5516];
        r27_unitScales = [1e-12,1e-9,1e-12,1];
        r27_max = [20,40,20,29];
        r27_min = [0,0,0,25];
        r27_optFlag = [1,1,1,1];

        r69_vals = [7.6665 39.1113 4.7693 68.5770];
        r69_unitScales = [1e-12,1e-9,1e-12,1];
        r69_max = [20,60,20,72];
        r69_min = [0,0,0,66];
        r69_optFlag = [1,1,1,1];

        r91_vals = [8.8027 55.4075 3.9754 89.6991];
        r91_unitScales = [1e-12,1e-9,1e-12,1];
        r91_max = [20,80,20,95];
        r91_min = [0,0,0,86];
        r91_optFlag = [1,1,1,1];

        % Cables
        c2_vals = [49.5165 1.9473 -0.0187 1.4388 0.0226 0.0018 0.0229 0.0423];
        c2_unitScales = [1,1,1,1,1,1,1,1];
        c2_max = [52,2.1,0.1,1.5,0.1,0.01,0.1,2];
        c2_min = [48,1.9,-0.1,1.4,-0.1,0,-0.1,0];
        c2_optFlag = [1,1,1,1,1,1,1,1].*0;

        % Mechanical switches
        ms1_vals = [48.0006 38.8854 1.7304 0 0];
        ms1_unitScales = [1,1e-3,1,1,1];
        ms1_max = [52,50,2.1,0.0005,2];
        ms1_min = [48,5,1,0,0];
        ms1_optFlag = [1,1,1,1,1].*0;

        ms3_vals = [49.7381 32.0274 1.7637 0.0092 8.1946];
        ms3_unitScales = [1,1e-3,1,1,1];
        ms3_max = [52,35,2.1,0.01,10];
        ms3_min = [48,30,1.5,0,0];
        ms3_optFlag = [1,1,1,1,1].*1;

        mts_vals = [51.6461 39.2243 1.5635 0 0];
        mts_unitScales = [1,1e-3,1,1,1];
        mts_max = [52,50,2.1,0.0005,2];
        mts_min = [48,5,1,0,0];
        mts_optFlag = [1,1,1,1,1].*0;

        % Semi-ridged links
        sr_mtsj2_vals = [49.6240 126.6710 2.0521 2.4878e-04 0.4268];
        sr_mtsj2_unitScales = [1,1e-3,1,1,1];
        sr_mtsj2_max = [52,140,2.1,0.0005,2];
        sr_mtsj2_min = [48,110,2.0,0,0];
        sr_mtsj2_optFlag = [1,1,1,1,1].*0;

        sr_mtsj1_vals = [49.4363 126.7525 2.0501 2.4880e-04 0.4887];
        sr_mtsj1_unitScales = [1,1e-3,1,1,1];
        sr_mtsj1_max = [52,140,2.1,0.0005,2];
        sr_mtsj1_min = [48,110,2.0,0,0];
        sr_mtsj1_optFlag = [1,1,1,1,1].*0;

        % Measured Data
        S11_meas_c12r36
        S11_meas_c12r27
        S11_meas_c12r69
        S11_meas_c12r91
        S11_meas_c12rOpen
        S11_meas_c12rShort
        S11_meas_c12r10
        S11_meas_c12r250

        S_meas_MS3_J1
        S_meas_MS3_J2
        S_meas_MS3_J3
        S_meas_MS3_J4

    end

    properties (Dependent = true)
        freq(1,:) double
        r36(1,1) struct
        r27(1,1) struct
        r69(1,1) struct
        r91(1,1) struct
        rOpen(1,1) struct
        rShort(1,1) struct
        r10(1,1) struct
        r250(1,1) struct
        c2(1,1) struct
        ms1(1,1) struct
        ms3(1,1) struct
        mts(1,1) struct
        sr_mtsj2(1,1) struct
        sr_mtsj1(1,1) struct

        %         source_r36(1,1) TwoPort

        Sr36(1,1) struct
        Sr27(1,1) struct
        Sr69(1,1) struct
        Sr91(1,1) struct
        SrOpen(1,1) struct
        SrShort(1,1) struct
        Sr10(1,1) struct
        Sr250(1,1) struct

    end

    properties (Dependent = true, Hidden = true)
        freqHz

        optFlag
        X0full
        LBfull
        UBfull
        err_source_r36
        err_source_r27
        err_source_r69
        err_source_r91
        err_source_rOpen
        err_source_rShort
        err_source_r10
        err_source_r250

        % Lower level error functions
        err_ms3


    end

    properties (Constant = true)
        sourceNames = {'cold','hot','r25','r100','c12r27','c12r36','c12r69','c12r91','c25open','c25short','c25r10','c25r250'}
        freqUnit = 'MHz'

        rVarNames = {'C1','L1','C2','L2','R'};
        cVarNames = {'Z0','L','eps_r_slope','eps_r_const','tan_d_slope','tan_d_const','r_prime_slope','r_prime_const'};
    end

    methods
        function obj = REACHcal(dataPath)
            % REACHcal constructor function

            p = mfilename("fullpath");
            if nargin < 1 || isempty(dataPath)
                obj.dataPath = [fileparts(p),'\..\data\calibration\'];
            else
                obj.dataPath = dataPath;
            end
            % MS3 dataPath
            obj.dataPathMS3 = [fileparts(p),'\..\data\MS-3\'];

            % Read the data
            obj.S11_meas_c12r36 = obj.readSourceS11('c12r36');
            obj.S11_meas_c12r27 = obj.readSourceS11('c12r27');
            obj.S11_meas_c12r69 = obj.readSourceS11('c12r69');
            obj.S11_meas_c12r91 = obj.readSourceS11('c12r91');

            % Read the MS3 data - only for the active through paths
            obj.S_meas_MS3_J1 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J1\J1_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J2 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J2\J2_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J3 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J3\J3_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J4 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J4\J4_ON.s2p'],2,obj.freqHz);
%             obj.S_meas_MS3_J1 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J1\J1_ON.s2p']);
%             obj.S_meas_MS3_J2 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J2\J2_ON.s2p']);
%             obj.S_meas_MS3_J3 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J3\J3_ON.s2p']);
%             obj.S_meas_MS3_J4 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J4\J4_ON.s2p']);
            obj.S_meas_MS3_J1 = obj.S_meas_MS3_J1.freqChangeUnit(obj.freqUnit);
            obj.S_meas_MS3_J2 = obj.S_meas_MS3_J2.freqChangeUnit(obj.freqUnit);
            obj.S_meas_MS3_J3 = obj.S_meas_MS3_J3.freqChangeUnit(obj.freqUnit);
            obj.S_meas_MS3_J4 = obj.S_meas_MS3_J4.freqChangeUnit(obj.freqUnit);


        end

        % Dependent getters
        function freq = get.freq(obj)
            freq = linspace(obj.fmin,obj.fmax,obj.Nf);
        end

        function freqHz = get.freqHz(obj)
            freqHz = obj.freq.*1e6;
        end

        function r36 = get.r36(obj)
            r36 = obj.buildRstruct(obj.r36_vals,obj.r36_unitScales,obj.r36_max,obj.r36_min,obj.r36_optFlag);
        end

        function r27 = get.r27(obj)
            r27 = obj.buildRstruct(obj.r27_vals,obj.r27_unitScales,obj.r27_max,obj.r27_min,obj.r27_optFlag);
        end

        function r69 = get.r69(obj)
            r69 = obj.buildRstruct(obj.r69_vals,obj.r69_unitScales,obj.r69_max,obj.r69_min,obj.r69_optFlag);
        end

        function r91 = get.r91(obj)
            r91 = obj.buildRstruct(obj.r91_vals,obj.r91_unitScales,obj.r91_max,obj.r91_min,obj.r91_optFlag);
        end

        function c2 = get.c2(obj)
            c2 = obj.buildCableStruct(obj.c2_vals,obj.c2_unitScales,obj.c2_max,obj.c2_min,obj.c2_optFlag);
        end

        function ms1 = get.ms1(obj)
            ms1 = obj.buildMSstruct(obj.ms1_vals,obj.ms1_unitScales,obj.ms1_max,obj.ms1_min,obj.ms1_optFlag);
        end

        function ms3 = get.ms3(obj)
            ms3 = obj.buildMSstruct(obj.ms3_vals,obj.ms3_unitScales,obj.ms3_max,obj.ms3_min,obj.ms3_optFlag);
        end

        function mts = get.mts(obj)
            mts = obj.buildMSstruct(obj.mts_vals,obj.mts_unitScales,obj.mts_max,obj.mts_min,obj.mts_optFlag);
        end

        function sr_mtsj1 = get.sr_mtsj1(obj)
            sr_mtsj1 = obj.buildSRstruct(obj.sr_mtsj1_vals,obj.sr_mtsj1_unitScales,obj.sr_mtsj1_max,obj.sr_mtsj1_min,obj.sr_mtsj1_optFlag);
        end

        function sr_mtsj2 = get.sr_mtsj2(obj)
            sr_mtsj2 = obj.buildSRstruct(obj.sr_mtsj2_vals,obj.sr_mtsj2_unitScales,obj.sr_mtsj2_max,obj.sr_mtsj2_min,obj.sr_mtsj2_optFlag);
        end

        function Sr36 = get.Sr36(obj)
            Sr36 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r36'});
        end

        function Sr27 = get.Sr27(obj)
            Sr27 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r27'});
        end

        function Sr69 = get.Sr69(obj)
            Sr69 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r69'});
        end

        function Sr91 = get.Sr91(obj)
            Sr91 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r91'});
        end

        function err_source_r36 = get.err_source_r36(obj)
            S11_model = obj.Sr36.network.getS.d11;
            err_source_r36 = sqrt(sum(abs(S11_model(:) - obj.S11_meas_c12r36(:)).^2))./obj.Nf;
            err_source_r36 = 2.*err_source_r36 + sqrt(sum(abs(dB20(S11_model(:)) - dB20(obj.S11_meas_c12r36(:))).^2))./obj.Nf;
        end

        function err_source_r27 = get.err_source_r27(obj)
            S11_model = obj.Sr27.network.getS.d11;
            err_source_r27 = sqrt(sum(abs(S11_model(:) - obj.S11_meas_c12r27(:)).^2))./obj.Nf;
            err_source_r27 = 2.*err_source_r27 + sqrt(sum(abs(dB20(S11_model(:)) - dB20(obj.S11_meas_c12r27(:))).^2))./obj.Nf;
        end

        function err_source_r69 = get.err_source_r69(obj)
            S11_model = obj.Sr69.network.getS.d11;
            err_source_r69 = sqrt(sum(abs(S11_model(:) - obj.S11_meas_c12r69(:)).^2))./obj.Nf;
            err_source_r69 = 2.*err_source_r69 + sqrt(sum(abs(dB20(S11_model(:)) - dB20(obj.S11_meas_c12r69(:))).^2))./obj.Nf;
        end

        function err_source_r91 = get.err_source_r91(obj)
            S11_model = obj.Sr91.network.getS.d11;
            err_source_r91 = sqrt(sum(abs(S11_model(:) - obj.S11_meas_c12r91(:)).^2))./obj.Nf;
            err_source_r91 = 2.*err_source_r91 + sqrt(sum(abs(dB20(S11_model(:)) - dB20(obj.S11_meas_c12r91(:))).^2))./obj.Nf;
        end

        function err_ms3 = get.err_ms3(obj)
%             obj.Nf = length(obj.S_meas_MS3_J1.freq);
%             obj.fmin = min(obj.S_meas_MS3_J1.freqHz)./1e6;
%             obj.fmax = max(obj.S_meas_MS3_J1.freqHz)./1e6;
            meas21 = obj.S_meas_MS3_J1.d21;
            mod21 = obj.ms3.network.getS.d21;
            err_ms3 = sqrt(sum(abs(meas21 - mod21).^2))./obj.Nf;
        end

        function optFlag = get.optFlag(obj)
%             optFlag = obj.Sr36.optFlag;
%             optFlag = obj.Sr27.optFlag;
            optFlag = obj.Sr69.optFlag;
%             optFlag = obj.Sr91.optFlag;
        end

        function X0full = get.X0full(obj)
%             X0full = obj.Sr36.vals;
%             X0full = obj.Sr27.vals;
            X0full = obj.Sr69.vals;
%             X0full = obj.Sr91.vals;
        end

        function LBfull = get.LBfull(obj)
%             LBfull = obj.Sr36.min;
%             LBfull = obj.Sr27.min;
            LBfull = obj.Sr69.min;
%             LBfull = obj.Sr91.min;
        end

        function UBfull = get.UBfull(obj)
%             UBfull = obj.Sr36.max;
%             UBfull = obj.Sr27.max;
            UBfull = obj.Sr69.max;
%             UBfull = obj.Sr91.max;
        end

        % Measurement data
        function [S11,freq] = readSourceS11(obj,sourceName,interpFlag)
            % READSOURCES11 returns the measured source S11 in a vector
            % Also interpolates onto the object frequencies

            if nargin < 3 || isempty(interpFlag), interpFlag = true; end

            assert(ismember(sourceName,obj.sourceNames),'Unknown source name - check REACHcal.sourceNames')
            [S11,freq] = touchread([obj.dataPath,sourceName,'\',sourceName,'.s1p']);
            S11 = squeeze(S11(1,1,:));
            if interpFlag
                S11 = interp1(freq,S11,obj.freqHz,'linear');
                freq = obj.freqHz;
            end
        end

        % Optimization
        function [obj] = tempOpt(obj)
            %             X0 = [obj.r36_vals,obj.c2_vals];
            %             LB = [obj.r36_min,obj.c2_min];
            %             UB = [obj.r36_max,obj.c2_max];
            X0 = obj.X0full(find(obj.optFlag == 1));
            LB = obj.LBfull(find(obj.optFlag == 1));
            UB = obj.UBfull(find(obj.optFlag == 1));
            options = optimoptions('fmincon','display','iter','MaxIterations',1000);
            optVals = fmincon(@(x) errFunc(obj,x),X0,[],[],[],[],LB,UB,[],options);
%             options = optimoptions('ga','display','iter');
%             optVals = ga(@(x) errFunc(obj,x),length(X0),[],[],[],[],LB,UB,[],options);

            %             obj.r36_vals = optVals(1:length(obj.r36_vals));
            %             obj.c2_vals = optVals((length(obj.r36_vals)+1):end);
            [~,obj] = obj.errFunc(optVals);

        end

        function [err,obj] = errFunc(obj,x)
            X = obj.X0full;
            X(obj.optFlag == 1) = x;

            
%             Ne = length(obj.Sr36.elements);
%             Ne = length(obj.Sr27.elements);
            Ne = length(obj.Sr69.elements);
%             Ne = length(obj.Sr91.elements);
            for ii = 1:Ne
%                 obj.([obj.Sr36.elements{ii},'_vals']) = X((sum(obj.Sr36.Nvars(1:(ii-1)))+1):sum(obj.Sr36.Nvars(1:ii)));
%                 obj.([obj.Sr27.elements{ii},'_vals']) = X((sum(obj.Sr27.Nvars(1:(ii-1)))+1):sum(obj.Sr27.Nvars(1:ii)));
                obj.([obj.Sr69.elements{ii},'_vals']) = X((sum(obj.Sr69.Nvars(1:(ii-1)))+1):sum(obj.Sr69.Nvars(1:ii)));
%                 obj.([obj.Sr91.elements{ii},'_vals']) = X((sum(obj.Sr91.Nvars(1:(ii-1)))+1):sum(obj.Sr91.Nvars(1:ii)));
            end
%             err = obj.err_source_r36;
%             err = obj.err_source_r27;
            err = obj.err_source_r69;
%             err = obj.err_source_r91;
        end

        function obj = fitMS3(obj)
            % FITMS3 is a componennt-level function to fit the MS3 model

            X0 = obj.ms3_vals;
            LB = obj.ms3_min;
            UB = obj.ms3_max;
            options = optimoptions('fmincon','display','iter','MaxIterations',1000);
            optVals = fmincon(@(x) errFuncMS3(obj,x),X0,[],[],[],[],LB,UB,[],options);
            [~,obj] = errFuncMS3(obj,optVals);

            function [err, obj] = errFuncMS3(obj,x)
                obj.ms3_vals = x;
                err = obj.err_ms3;
            end
        end


        % Plotting
        function plotCablePars(obj,cVals,cUnitScales)
            % PLOTCABLEPARS Plots the requested cable parameters over frequency

            [Z0,L,~,eps_r,tan_delta,r_prime] = getCablePars(obj,cVals,cUnitScales);

            figure
            subplot 411
            if length(Z0) == 1, Z0 = ones(1,obj.Nf).*Z0; end
            plot(obj.freq,Z0,'k'), grid on
            ylabel('Z_0 (\Omega)')
            title(['L = ',num2str(L),' m'])

            subplot 412
            if length(eps_r) == 1, eps_r = ones(1,obj.Nf).*eps_r; end
            plot(obj.freq,eps_r,'k'), grid on
            ylabel('\epsilon_r')

            subplot 413
            if length(tan_delta) == 1, tan_delta = ones(1,obj.Nf).*tan_delta; end
            plot(obj.freq,tan_delta,'k'), grid on
            ylabel('tan(\delta)')

            subplot 414
            if length(r_prime) == 1, r_prime = ones(1,obj.Nf).*r_prime; end
            plot(obj.freq,r_prime,'k'), grid on
            ylabel("R' (\Omega/m)")
        end

        function plotSourceModels(obj)
            % plotSOurceModels plots all the current source models with measured data

            Svect = [obj.Sr36,obj.Sr27,obj.Sr69,obj.Sr91];
            measVect = {obj.S11_meas_c12r36,obj.S11_meas_c12r27,obj.S11_meas_c12r69,obj.S11_meas_c12r91};
            nameVect = {'r36','r27','r69','r91'};

            for ii = 1:length(Svect)
                figure
                subplot(2,2,1:2)
                Svect(ii).network.getS.plot11dB
                plot(obj.freq,dB20(measVect{ii}),'r--')
                title(nameVect{ii})
                subplot(2,2,3)
                Svect(ii).network.getS.plot11real
                plot(obj.freq,real(measVect{ii}),'r--')
                subplot(2,2,4)
                Svect(ii).network.getS.plot11imag
                plot(obj.freq,imag(measVect{ii}),'r--')
            end
        end

    end

    methods (Access = private)
       
        function [Z0,L,freq,eps_r,tan_delta,r_prime] = getCablePars(obj,c_vals,c_unitScales)
            % GETCABLEPARS Calculates the frequency dependent Tline parameters


            cVals = c_vals.*c_unitScales;

            Z0 = cVals(1);
            L = cVals(2);
            freq = obj.freqHz;

            fn = (freq - min(freq))./(max(freq) - min(freq));
            eps_r = cVals(3).*fn + cVals(4);
            tan_delta = cVals(5).*fn + cVals(6);
            r_prime = cVals(7).*fn + cVals(8);
        end

        function cable = buildCableStruct(obj,c_vals,c_unitScales,c_max,c_min,c_optFlag)
            % BUILDCABLESTRUCT builds a general cable structure

            [Z0,L,f,eps_r,tan_delta,r_prime] = obj.getCablePars(c_vals,c_unitScales);
            cable.network = TwoPort.Tline(Z0,L,f,eps_r,tan_delta,r_prime);
            cable.network = cable.network.freqChangeUnit(obj.freqUnit);
            cable.vals = c_vals;
            cable.unitScales = c_unitScales;
            cable.max = c_max;
            cable.min = c_min;
            cable.optFlag = c_optFlag;
        end

        function r = buildRstruct(obj,r_vals,r_unitScales,r_max,r_min,r_optFlag)
            % BUILDRSTRUCT builds a general resistor structure

            r.vals = r_vals;
            r.unitScales = r_unitScales;
            r.max = r_max;
            r.min = r_min;
            r.optFlag = r_optFlag;
            parVals = r.vals.*r.unitScales;
            r.network = TwoPort.PI_CLC(parVals(1),parVals(2),parVals(3),obj.freqHz,[],parVals(4));
            r.network = r.network.freqChangeUnit(obj.freqUnit);
        end

        function sr = buildSRstruct(obj,sr_vals,sr_unitScales,sr_max,sr_min,sr_optFlag)
            % BUILDSRSTRUCT builds a general semi-rigid structure

            sr.vals = sr_vals;
            sr.unitScales = sr_unitScales;
            sr.max = sr_max;
            sr.min = sr_min;
            sr.optFlag = sr_optFlag;
            parVals = sr.vals.*sr.unitScales;
            sr.network = TwoPort.Tline(parVals(1),parVals(2),obj.freqHz,parVals(3),parVals(4),parVals(5));
            sr.network = sr.network.freqChangeUnit(obj.freqUnit);
        end

        function ms = buildMSstruct(obj,ms_vals,ms_unitScales,ms_max,ms_min,ms_optFlag)
            % BUILDMSSTRUCT builds a general mechanical switch structure

            ms.vals = ms_vals;
            ms.unitScales = ms_unitScales;
            ms.max = ms_max;
            ms.min = ms_min;
            ms.optFlag = ms_optFlag;
            parVals = ms.vals.*ms.unitScales;
            ms.network = TwoPort.Tline(parVals(1),parVals(2),obj.freqHz,parVals(3),parVals(4),parVals(5));
            ms.network = ms.network.freqChangeUnit(obj.freqUnit);
        end

        function S_struct = buildSourceStruct(obj,elementNameVect)
            % BUILDSOURCESTRUCT builds a general source structure

            S_struct.elements = elementNameVect;
            Ne = length(S_struct.elements);
            % First get the number of variables in the cascade
            S_struct.Nvars = zeros(1,Ne);
            networkVect = TwoPort.empty(0,Ne);
            for ii = 1:Ne
                S_struct.Nvars(ii) = length(obj.(S_struct.elements{ii}).vals);
                networkVect(ii) = obj.(S_struct.elements{ii}).network;
            end
            % Run the loop again, and allocate the long vectors
            valMat = zeros(5,sum(S_struct.Nvars));
            for ii = 1:Ne
                element_ = obj.(S_struct.elements{ii});
                valMat(:,(sum(S_struct.Nvars(1:(ii-1)))+1):sum(S_struct.Nvars(1:ii))) = [element_.vals; ...
                    element_.unitScales; ...
                    element_.max; ...
                    element_.min; ...
                    element_.optFlag];
            end
            S_struct.network = cascade(networkVect);
            S_struct.network = S_struct.network.getS([],networkVect(Ne).Zport2);
            S_struct.vals = valMat(1,:);
            S_struct.unitScales = valMat(2,:);
            S_struct.max = valMat(3,:);
            S_struct.min = valMat(4,:);
            S_struct.optFlag = valMat(5,:);
            
        end

    end

    methods (Static = true)

%         function R = buildResistor(types,vals,unitScales,freq)
%             % BUILDRESISTOR makes a load model from the internal description
%             % Not doing any error checking here for speed
%             %
%             % Returns:
%             % R - TwoPort S parameters
%             %
%             % Inputs:
%             % types - row cell vector containing {'Cpar'|'Lser'|'Load'}
%             % vals - row vector of corresponding values of the elements
%             % unitScales - in the specified unit scaling
%             % freq - frequency vector in Hz
% 
%             nComp = numel(types);
%             tp = TwoPort.empty(0,nComp-1);
%             for ii = 1:nComp-1
%                 funcType = str2func(['TwoPort.',types{ii}]);
%                 tp(ii) = funcType(vals(ii).*unitScales(ii),freq);
%             end
%             R = cascade(tp);
%             R = R.getS([],vals(end).*unitScales(end));
%         end
    end

end