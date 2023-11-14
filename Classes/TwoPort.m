classdef TwoPort

    properties
        type(1,:) char {mustBeMember(type,{'S','ABCD'})} = 'S'
    end

    properties (SetAccess = private)
        freq(1,:) double % in fUnit
        fUnit(1,:) char {mustBeMember(fUnit,{'Hz','kHz','MHz','GHz','THz'})} = 'GHz' % Frequency unit 
        
        data(2,2,:) double  % port parameter data matrix

        Zport(1,2) = [50,50]  % Port impedances
    end

    properties (Dependent = true)
        
    end

    properties (Dependent = true, Hidden = true)
        nameMat
        fScale              % Scaling factor from fUnit to Hz
    end

    properties (Constant = true)

    end

    methods
        function obj = TwoPort()
            % TWOPORT class constructor method.

        end

        % Dependent getters
        function nameMat = get.nameMat(obj)
            switch obj.type
                case 'S'
                    nameMat = {'S_{11}','S_{12}';'S_{21}','S_{22}'};
                case 'ABCD'
                    nameMat = {'A','B';'C','D'};
                otherwise
                    error('I should not be here...')

            end
        end

        function fScale = get.fScale(obj)
            switch lower(obj.fUnit)
                case 'thz'
                    fScale = 1e12;
                case 'ghz'
                    fScale = 1e9;
                case 'mhz'
                    fScale = 1e6;
                case 'khz'
                    fScale = 1e3;
                case 'hz'
                    fScale = 1e0;
                otherwise
                    error('I should not be here...')
            end

        end

        % Circuit solver
        function obj = cascade(obj)
            % CASCADE calculates the cascades circuit of the input array

            % Use pagemtimes()!

        end


    end

    methods (Access = private)

    end

    methods (Static = true)

    end

end