classdef REACHcal

    properties

    end

    properties (SetAccess = private)
        r36_vals = [1,10,8,8,36];
        r36_types = {'Cpar','Lser','Cpar','Lser','Load'};
        r36_units = {'pF','nH','pF','nH','Ohm'};
        r36_max = [2,20,16,16,38];
        r36_min = [0,0,0,0,34];
        r36_optFlag = [1,1,1,1,1];
        


    end

    properties (Dependent = true)
        r36 TwoPort

    end

    properties (Dependent = true, Hidden = true)
        freqHz
    end

    properties (Constant = true)
        sourceNames = {'cold','hot','r25','r100','c12r27','c12r36','c12r69','c12r91','c25open','c25short','c25r10','c25r250'}
        freqUnit = 'MHz'
        freq = linspace(50,150,101);
    end

    methods
        function obj = REACHcal()
            % REACHcal constructor function


        end

        % Dependent getters
        function freqHz = get.freqHz(obj)
            freqHz = obj.freq.*1e6;
        end

        function r36 = get.r36(obj)
            r36 = REACHcal.buildResistor(obj.r36_types,obj.r36_vals,obj.r36_units,obj.freqHz);
        end

    end

    methods (Access = private)


    end

    methods (Static = true)
        function scaleFact = getScaleFact(units)
            % GETSCALEFACT returns the scale factors of an input vector of units
            
            scaleFact = ones(size(units));
            for ii = 1:numel(units)
                c1 = units{ii}(1);
                switch lower(c1)
                    case 'p'
                        scaleFact(ii) = 1e-12;
                    case 'n'
                        scaleFact(ii) = 1e-9;
                    case 'u'
                        scaleFact(ii) = 1e-6;
                    case 'm'
                        scaleFact(ii) = 1e-3;
                    case 'k'
                        scaleFact(ii) = 1e3;
                    otherwise
                        scaleFact(ii) = 1;
                end
            end
        end

        function R = buildResistor(types,vals,units,freq)
            % BUILDRESISTOR makes a load model from the internal description
            % Not doing any error checking here for speed
            %
            % Returns:
            % R - TwoPort S parameters
            %
            % Inputs:
            % types - row cell vector containing {'Cpar'|'Lser'|'Load'}
            % vals - row vector of corresponding values of the elements
            % units - in the specified units
            % freq - frequency vector in Hz


            nComp = numel(types);
            tp = TwoPort.empty(0,nComp-1);
            scaleFact = REACHcal.getScaleFact(units);
            for ii = 1:nComp-1
                funcType = str2func(['TwoPort.',types{ii}]);
                tp(ii) = funcType(vals(ii).*scaleFact(ii),freq);
            end
            R = cascade(tp);
            R = R.getS([],vals(end).*scaleFact(end));
        end
    end

end