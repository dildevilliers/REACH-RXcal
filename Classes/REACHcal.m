classdef REACHcal

    properties

    end

    properties (SetAccess = private)
        dataPath(1,:) char
        
        Nf(1,1) double = 101
        fmin(1,1) double = 50  % in MHz
        fmax(1,1) double = 200 % in MHz
        
        % Resistors
        r36_vals = [1.91,17.7,9.4,15.1,37.8];
        r36_types = {'Cpar','Lser','Cpar','Lser','Load'};
        r36_unitScales = [1e-12,1e-9,1e-12,1e-9,1];
        r36_max = [2,20,16,16,38];
        r36_min = [0,0,0,0,34];
        r36_optFlag = [1,1,1,1,1];

        % Cables
        c2_vals = [49.5,1.95,0,1.9,0,0.005,0,1];   
        c2_unitScales = [1,1,1,1,1,1,1,1];
        c2_max = [52,2.1,0.1,2.1,0.1,0.01,0.1,2];
        c2_min = [48,1.8,-0.1,1.8,-0.1,0,-0.1,0];
        c2_optFlag = [1,1,1,1,1,1,1,1];
        
        % Mechanical switches
        ms1_vals = [50,25,2];
        ms1_unitScales = [1,1e-3,1];
        ms1_max = [52,33,10];
        ms1_min = [48,10,1];
        ms1_optFlag = [1,1,1];

        ms3_vals = [50,25,2];
        ms3_unitScales = [1,1e-3,1];
        ms3_max = [52,33,10];
        ms3_min = [48,10,1];
        ms3_optFlag = [1,1,1];

        % Semi-ridged links
        sr_mtsj2_vals = [50,30,2,0.0002];
        sr_mtsj2_unitScales = [1,1e-3,1,1];
        sr_mtsj2_max = [52,50,2.1,0.0005];
        sr_mtsj2_min = [48,10,1.9,0];
        sr_mtsj2_optFlag = [1,1,1,1];

        sr_mtsj1_vals = [50,30,2,0.0002];
        sr_mtsj1_unitScales = [1,1e-3,1,1];
        sr_mtsj1_max = [52,50,2.1,0.0005];
        sr_mtsj1_min = [48,10,1.9,0];
        sr_mtsj1_optFlag = [1,1,1,1];

    end

    properties (Dependent = true)
        freq(1,:) double
        r36(1,1) struct
        c2(1,1) struct
        ms1(1,1) struct
        ms3(1,1) struct
        sr_mtsj2(1,1) struct
        sr_mtsj1(1,1) struct

%         source_r36(1,1) TwoPort

        Sr36(1,1) struct
        
    end

    properties (Dependent = true, Hidden = true)
        freqHz

        optFlag
        X0full
        LBfull
        UBfull
        err_source_r36


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

            if nargin < 1 || isempty(dataPath)
                p = mfilename("fullpath");
                obj.dataPath = [fileparts(p),'\..\data\calibration\'];
            else
                obj.dataPath = dataPath;
            end

        end

        % Dependent getters
        function freq = get.freq(obj)
            freq = linspace(obj.fmin,obj.fmax,obj.Nf);
        end

        function freqHz = get.freqHz(obj)
            freqHz = obj.freq.*1e6;
        end

        function r36 = get.r36(obj)
            r36 = obj.buildRstruct('r36');
        end

        function c2 = get.c2(obj)
            c2 = obj.buildCableStruct('c2');
        end

        function ms1 = get.ms1(obj)
            ms1 = obj.buildMSstruct('ms1');
        end

        function ms3 = get.ms3(obj)
            ms3 = obj.buildMSstruct('ms3');
        end

        function sr_mtsj1 = get.sr_mtsj1(obj)
            sr_mtsj1 = obj.buildSRstruct('sr_mtsj1');
        end

        function sr_mtsj2 = get.sr_mtsj2(obj)
            sr_mtsj2 = obj.buildSRstruct('sr_mtsj2');
        end

        function Sr36 = get.Sr36(obj)
            Sr36 = obj.buildSourceStruct({'sr_mtsj2','ms1','c2','ms3','r36'});
        end

        function err_source_r36 = get.err_source_r36(obj)
            S11_meas = obj.readSourceS11('c12r36');
            S11_model = obj.Sr36.network.getS.d11;
            err_source_r36 = sqrt(sum(abs(S11_model(:) - S11_meas(:)).^2))./obj.Nf;
            err_source_r36 = 2.*err_source_r36 + sqrt(sum(abs(dB20(S11_model(:)) - dB20(S11_meas(:))).^2))./obj.Nf;
        end

        function optFlag = get.optFlag(obj)
%             optFlag = [obj.r36_optFlag,obj.ms3_optFlag,obj.c2_optFlag,obj.ms1_optFlag,obj.sr_mtsj2_optFlag];
            optFlag = obj.Sr36.optFlag;
        end

        function X0full = get.X0full(obj)
%             X0full = [obj.r36_vals,obj.ms3_vals,obj.c2_vals,obj.ms1_vals,obj.sr_mtsj2_vals];
            X0full = obj.Sr36.vals;
        end
        
        function LBfull = get.LBfull(obj)
%             LBfull = [obj.r36_min,obj.ms3_min,obj.c2_min,obj.ms1_min,obj.sr_mtsj2_min];
            LBfull = obj.Sr36.min;
        end
        
        function UBfull = get.UBfull(obj)
%             UBfull = [obj.r36_max,obj.ms3_max,obj.c2_max,obj.ms1_max,obj.sr_mtsj2_max];
            UBfull = obj.Sr36.max;
        end
        
        % Measurement data
        function [S11,freq] = readSourceS11(obj,sourceName,interpFlag)
            % READSOURCES11 returns the measured source S11 in a vector
            % Also interpolates onto the object frequencies

            if nargin < 3 || isempty(interpFlag), interpFlag = true; end

            assert(ismember(sourceName,obj.sourceNames),'Unknown source name - checkREACHcal.sourceNames')
            [S11,freq] = touchread([obj.dataPath,sourceName,'\',sourceName,'.s1p']);
            S11 = squeeze(S11(1,1,:));
            if interpFlag
                S11 = interp1(freq,S11,obj.freqHz,'linear');
                freq = obj.freqHz;
            end
        end

        % Optimization
        function [obj] = tempOpt(obj)
            options = optimoptions('fmincon','display','iter');
%             X0 = [obj.r36_vals,obj.c2_vals];
%             LB = [obj.r36_min,obj.c2_min];
%             UB = [obj.r36_max,obj.c2_max];
            X0 = obj.X0full(find(obj.optFlag == 1));
            LB = obj.LBfull(find(obj.optFlag == 1));
            UB = obj.UBfull(find(obj.optFlag == 1));
            optVals = fmincon(@(x) errFunc(obj,x),X0,[],[],[],[],LB,UB,[],options);
%             optVals = ga(@(x) errFunc(obj,x),length(X0),[],[],[],[],LB,UB,[],options);

%             obj.r36_vals = optVals(1:length(obj.r36_vals));
%             obj.c2_vals = optVals((length(obj.r36_vals)+1):end);
            [~,obj] = obj.errFunc(optVals);

        end

        function [err,obj] = errFunc(obj,x)
            X = obj.X0full;
            X(obj.optFlag == 1) = x;
            
%             Nr36 = length(obj.r36_vals);
%             Nms3 = length(obj.ms3_vals);
%             Nc2 = length(obj.c2_vals);
%             Nms1 = length(obj.ms1_vals);
%             Nsr_mtsj2 = length(obj.sr_mtsj2_vals);
%             
%             obj.r36_vals = X(1:Nr36);
%             obj.ms3_vals = X((Nr36+1):(Nr36+Nms3));
%             obj.c2_vals = X((Nr36+Nms3+1):(Nr36+Nms3+Nc2));
%             obj.ms1_vals = X((Nr36+Nms3+Nc2+1):(Nr36+Nms3+Nc2+Nms1));
%             obj.sr_mtsj2_vals = X((Nr36+Nms3+Nc2+Nms1+1):(Nr36+Nms3+Nc2+Nms1+Nsr_mtsj2));
%             err = obj.err_source_r36;


            Ne = length(obj.Sr36.elements);
            for ii = 1:Ne
                obj.([obj.Sr36.elements{ii},'_vals']) = X((sum(obj.Sr36.Nvars(1:(ii-1)))+1):sum(obj.Sr36.Nvars(1:ii)));
            end
            err = obj.err_source_r36;
        end


        % Plotting
        function plotCablePars(obj,cVals)
            % PLOTCABLEPARS Plots the requested cable parameters over frequency

            [Z0,L,~,eps_r,tan_delta,r_prime] = getCablePars(obj,cVals);

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

    end

    methods (Access = private)
        function [Z0,L,freq,eps_r,tan_delta,r_prime] = getCablePars(obj,cableName)
            % GETCABLEPARS Calculates the frequency dependent Tline parameters

            switch cableName
                case 'c2'
                    cVals = obj.c2_vals;
                    cUnit = obj.c2_unitScales;
                case 'c10'
                    cVals = obj.c10_vals;
                    cUnit = obj.c10_unitScales;
                otherwise
                    error('Unknown cable name')
            end
            cVals = cVals.*cUnit;

            Z0 = cVals(1);
            L = cVals(2);
            freq = obj.freqHz;
            
            fn = (freq - min(freq))./(max(freq) - min(freq));
            eps_r = cVals(3).*fn + cVals(4);
            tan_delta = cVals(5).*fn + cVals(6);
            r_prime = cVals(7).*fn + cVals(8);
        end

        function cable = buildCableStruct(obj,cableName)
            % BUILDCABLESTRUCT builds a general cable structure

            [Z0,L,f,eps_r,tan_delta,r_prime] = obj.getCablePars(cableName);
            cable.network = TwoPort.Tline(Z0,L,f,eps_r,tan_delta,r_prime);
            cable.network = cable.network.freqChangeUnit(obj.freqUnit);
            cable.vals = obj.([cableName,'_vals']);
            cable.unitScales = obj.([cableName,'_unitScales']);
            cable.max = obj.([cableName,'_max']);
            cable.min = obj.([cableName,'_min']);
            cable.optFlag = obj.([cableName,'_optFlag']);
        end

        function r = buildRstruct(obj,rName)
            % BUILDRSTRUCT builds a general resistor structure
           
            r.vals = obj.([rName,'_vals']);
            r.unitScales = obj.([rName,'_unitScales']);
            r.max = obj.([rName,'_max']);
            r.min = obj.([rName,'_min']);
            r.optFlag = obj.([rName,'_optFlag']);
            r.types = obj.([rName,'_types']);
            r.network = REACHcal.buildResistor(r.types,r.vals,r.unitScales,obj.freqHz);
            r.network = r.network.freqChangeUnit(obj.freqUnit);    
        end

        function sr = buildSRstruct(obj,srName)
            % BUILDSRSTRUCT builds a general semi-rigid structure

            sr.vals = obj.([srName,'_vals']);
            sr.unitScales = obj.([srName,'_unitScales']);
            sr.max = obj.([srName,'_max']);
            sr.min = obj.([srName,'_min']);
            sr.optFlag = obj.([srName,'_optFlag']);
            parVals = sr.vals.*sr.unitScales;
            sr.network = TwoPort.Tline(parVals(1),parVals(2),obj.freqHz,parVals(3),parVals(4));
            sr.network = sr.network.freqChangeUnit(obj.freqUnit);
        end

        function ms = buildMSstruct(obj,msName)
            % BUILDMSSTRUCT builds a general mechanical switch structure

            ms.vals = obj.([msName,'_vals']);
            ms.unitScales = obj.([msName,'_unitScales']);
            ms.max = obj.([msName,'_max']);
            ms.min = obj.([msName,'_min']);
            ms.optFlag = obj.([msName,'_optFlag']);
            parVals = ms.vals.*ms.unitScales;
            ms.network = TwoPort.Tline(parVals(1),parVals(2),obj.freqHz,parVals(3));
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
%         function scaleFact = getScaleFact(units)
%             % GETSCALEFACT returns the scale factors of an input vector of units
%             
%             scaleFact = ones(size(units));
%             for ii = 1:numel(units)
%                 c1 = units{ii}(1);
%                 switch lower(c1)
%                     case 'p'
%                         scaleFact(ii) = 1e-12;
%                     case 'n'
%                         scaleFact(ii) = 1e-9;
%                     case 'u'
%                         scaleFact(ii) = 1e-6;
%                     case 'm'
%                         scaleFact(ii) = 1e-3;
%                     case 'k'
%                         scaleFact(ii) = 1e3;
%                     otherwise
%                         scaleFact(ii) = 1;
%                 end
%             end
%         end

        function R = buildResistor(types,vals,unitScales,freq)
            % BUILDRESISTOR makes a load model from the internal description
            % Not doing any error checking here for speed
            %
            % Returns:
            % R - TwoPort S parameters
            %
            % Inputs:
            % types - row cell vector containing {'Cpar'|'Lser'|'Load'}
            % vals - row vector of corresponding values of the elements
            % unitScales - in the specified unit scaling
            % freq - frequency vector in Hz

            nComp = numel(types);
            tp = TwoPort.empty(0,nComp-1);
            for ii = 1:nComp-1
                funcType = str2func(['TwoPort.',types{ii}]);
                tp(ii) = funcType(vals(ii).*unitScales(ii),freq);
            end
            R = cascade(tp);
            R = R.getS([],vals(end).*unitScales(end));
        end
    end

end