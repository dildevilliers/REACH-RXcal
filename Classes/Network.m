classdef Network
    % NETWORK is the general superclass for OnePort, TwoPort and (later) NPort network classes

    properties (SetAccess = protected)
        freq(1,:) double % in fUnit
        fUnit(1,:) char {mustBeMember(fUnit,{'Hz','kHz','MHz','GHz','THz'})} = 'GHz' % Frequency unit 
        
        data(:,:,:) double  % port parameter data matrix

        Nports(1,1) double {mustBeInteger,mustBePositive} = 1
        Zport(:,:) double = 50  % Port impedances

        type(1,:) char {mustBeMember(type,{'S','Y','Z','ABCD'})} = 'S'
    end

    properties (Dependent = true)
        Zport1  % First port impedance - used a lot so make explicit

        Nf   % Number of frequencies
    end

    properties (Dependent = true, Hidden = true)
        fScale              % Scaling factor from fUnit to Hz
        freqHz

        nameMat
        d11         % Data of the (1,1) port - used a lot so make explicit
    end

    methods
        
        % Dependent getters
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

        function Nf = get.Nf(obj)
            Nf = numel(obj.freq);
        end

        function freqHz = get.freqHz(obj)
            freqHz = obj.freq.*obj.fScale;
        end

        function nameMat = get.nameMat(obj)
            if obj.Nports > 1 || strcmpi(obj.type,'S')
                nameMat = cell(obj.Nports,obj.Nports);
                switch obj.type
                    case {'S','Y','Z'}
                        for rr = 1:obj.Nports
                            for cc = 1:obj.Nports
                                nameMat(rr,cc) = {[obj.type,'_{',num2str(rr),num2str(cc),'}']};
                            end
                        end
                    case 'ABCD'
                        nameMat = {'A','B';'C','D'};
                    otherwise
                        error('I should not be here...')
                end
            else
                nameMat = {obj.type};
            end
        end

        function d11 = get.d11(obj)
            d11 = squeeze(obj.data(1,1,:));
        end

        function Zport1 = get.Zport1(obj)
            Zport1 = obj.Zport(1,:);
        end


        % Frequency manipulation
        function obj = freqChangeUnit(obj,fUnit)
            % FREQCHANGEUNIT changes the frequency unit to fUnit

            freqHz_ = obj.freq.*obj.fScale;
            obj.fUnit = fUnit;
            obj.freq = freqHz_./obj.fScale;
        end

        function obj = freqInterp(obj,freqInterp,interpMethod)
            % FREQINTERP interpolates on the frequency axis
            %
            % Inputs:
            % freqInterp - vector of frequencies where the data must be interpolated (in Hz)
            % interpMethod - interpolation method (interp1 standards)

            Di = nan(obj.Nports,obj.Nports,numel(freqInterp));
            for rr = 1:obj.Nports
                for cc = 1:obj.Nports
                    Di(rr,cc,:) = interp1(obj.freq.*obj.fScale,squeeze(obj.data(rr,cc,:)),freqInterp,interpMethod);
                end
            end
            obj.freq = freqInterp./obj.fScale;
            obj.data = Di;
        end

        % Plotting
        function plot11dB(obj,style)
            % PLOT11dB plots the 11 parameter in dB

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,dB20(obj.d11),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel(['|',obj.nameMat{1,1}, '| (dB)'])
        end

        function plot11mag(obj,style)
            % PLOT11mag plots the 11 parameter magnitude in linear scale

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,abs(obj.d11),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel(['|',obj.nameMat{1,1}, '|'])
        end

        function plot11real(obj,style)
            % PLOT11real plots the 11 parameter real part

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,real(obj.d11),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel(['real(',obj.nameMat{1,1},')'])
        end

        function plot11imag(obj,style)
            % PLOT11real plots the 11 parameter imaginary part

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,imag(obj.d11),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel(['imag(',obj.nameMat{1,1},')'])
        end

        function plot11RI(obj,style)
            % PLOT11RI plots the 11 parameter on the complex plane

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(real(obj.d11),imag(obj.d11),style), grid on, hold on
            xlabel(['real(',obj.nameMat{1,1}, ')'])
            ylabel(['imag(',obj.nameMat{1,1}, ')'])
        end

    end


    
end