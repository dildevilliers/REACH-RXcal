classdef TwoPort

    properties
        
    end

    properties (SetAccess = private)
        type(1,:) char {mustBeMember(type,{'S','ABCD'})} = 'S'

        freq(1,:) double % in fUnit
        fUnit(1,:) char {mustBeMember(fUnit,{'Hz','kHz','MHz','GHz','THz'})} = 'GHz' % Frequency unit 
        
        data(2,2,:) double  % port parameter data matrix

        Zport1(1,:) = 50  % Port 1 impedances
        Zport2(1,:) = 50  % Port 2 impedances
    end

    properties (Dependent = true)
        Nf   % Number of frequencies
        
    end

    properties (Dependent = true, Hidden = true)
        nameMat
        fScale              % Scaling factor from fUnit to Hz
        d11
        d12
        d21
        d22
    end

    properties (Constant = true)

    end

    methods
        function obj = TwoPort(data,freqGHz,type,Zport1,Zport2)
            % TWOPORT class constructor method.

            if nargin > 0 && ~isempty(data), obj.data = data; end
            if nargin > 1 && ~isempty(freqGHz), obj.freq = freqGHz; end
            if nargin > 2 && ~isempty(type), obj.type = type; end
            if nargin > 3 && ~isempty(Zport1), obj.Zport1 = Zport1; end
            if nargin > 4 && ~isempty(Zport2), obj.Zport2 = Zport2; end
            

            assert(size(obj.data,3) == obj.Nf,'Third dimension of data must have the same number of elements as freq')
            assert(numel(obj.Zport1) == 1 || numel(obj.Zport1) == obj.Nf,'Zport1 must have the same number of elements as freq')
            assert(numel(obj.Zport2) == 1 || numel(obj.Zport2) == obj.Nf,'Zport2 must have the same number of elements as freq')

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

        function Nf = get.Nf(obj)
            Nf = numel(obj.freq);
        end

        function d11 = get.d11(obj)
            d11 = squeeze(obj.data(1,1,:));
        end

        function d12 = get.d12(obj)
            d12 = squeeze(obj.data(1,2,:));
        end

        function d21 = get.d21(obj)
            d21 = squeeze(obj.data(2,1,:));
        end

        function d22 = get.d22(obj)
            d22 = squeeze(obj.data(2,2,:));
        end

        % Circuit solver
        function obj = cascade(objIn)
            % CASCADE calculates the cascades circuit of the input array

            % Use pagemtimes()!
            
            obj = objIn(1);
            typeIn = obj.type;
            if length(objIn) > 1
                obj = obj.getABCD;
                for ii = 2:length(objIn)
                    obj0 = getABCD(objIn(ii));
                    if ~strcmp(obj.fUnit,obj0.fUnit), obj0 = obj0.freqChangeUnit(obj.fUnit); end
                    assert(isequal(obj.freq,obj0.freq),'Frequencies do not match')
                    obj.data = pagemtimes(obj.data,obj0.data);
                    
                end
            end
            transFun = str2func(['get',typeIn]);
            obj = transFun(obj);
        end

        % Frequency scaling
        function obj = freqChangeUnit(obj,fUnit)
            % FREQCHANGEUNIT changes the frequency unit to fUnit

            freqHz = obj.freq.*obj.fScale;
            obj.fUnit = fUnit;
            obj.freq = freqHz./obj.fScale;
        end

        % Transformations between types
        function obj = getS(obj,Zport1,Zport2)
            % GETS returns the object of type S-parameter
            % If the object is already of type 'S', the retturned object will be of the same type, 
            % but in the new impedance environment defined by Zport1 and Zport2
            %
            % Inputs:
            % Zport1 - Port 1 impedance (can generally be function of frequency)
            % Zport2 - Port 2 impedance (can generally be function of frequency)

            Z1 = obj.Zport1;
            Z2 = obj.Zport2;
            if nargin > 1 && ~isempty(Zport1), Z1 = Zport1; end
            if nargin > 2 && ~isempty(Zport2), Z2 = Zport2; end

            if strcmp(obj.type,'S') && isequal(Z1,obj.Zport1) && isequal(Z2,obj.Zport2)
                % Do nothing
            elseif strcmp(obj.type,'S')
                % Change impedance levels
                objABCD = obj.getABCD;
                objABCD.Zport1 = Z1;
                objABCD.Zport2 = Z2;
                obj = objABCD.getS;
            else
                switch obj.type
                    case 'ABCD'
                    A = obj.d11;
                    B = obj.d12;
                    C = obj.d21;
                    D = obj.d22;

                    den = A.*Z2 + B + C.*Z1.*Z2 + D.*Z1;
                    obj.data(1,1,:) = (A.*Z2 + B - C.*conj(Z1).*Z2 - D.*conj(Z1))./den;
                    obj.data(1,2,:) = (2.*(A.*D - B.*C).*sqrt(real(Z1).*real(Z2)))./den;
                    obj.data(2,1,:) = (2.*sqrt(real(Z1).*real(Z2)))./den;
                    obj.data(2,2,:) = (-A.*conj(Z2) + B - C.*Z1.*conj(Z2) + D.*Z1)./den;
                otherwise
                    error('I should not be here...')
                end
                obj.type = 'S';
                obj.Zport1 = Z1;
                obj.Zport2 = Z2;
            end
        end

        function obj = getABCD(obj)
            % GETABCD returns the object of type ABCD-parameter

            switch obj.type
                case 'ABCD'
                    % Do nothing
                case 'S'
                    S11 = obj.d11;
                    S12 = obj.d12;
                    S21 = obj.d21;
                    S22 = obj.d22;

                    Z1 = obj.Zport1(:);
                    Z2 = obj.Zport2(:);

                    den = 2.*S21.*sqrt(real(Z1).*real(Z2));
                    obj.data(1,1,:) = ((conj(Z1) + S11.*Z1).*(1 - S22) + S12.*S21.*Z1)./den;
                    obj.data(1,2,:) = ((conj(Z1) + S11.*Z1).*(conj(Z2) + S22.*Z2) - S12.*S21.*Z1.*Z2)./den;
                    obj.data(2,1,:) = ((1 - S11).*(1 - S22) - S12.*S21)./den;
                    obj.data(2,2,:) = ((1 - S11).*(conj(Z2) + S22.*Z2) + S12.*S21.*Z2)./den;
                otherwise
                    error('I should not be here...')
            end
            obj.type = 'ABCD';
        end

        % Plotting
        function plot11dB(obj,style)
            % PLOT11dB plots the 11 parameter in dB

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,dB20(obj.d11),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel(['|',obj.nameMat{1,1}, '| (dB)'])
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

        function plot21dB(obj,style)
            % PLOT21dB plots the 21 parameter in dB

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,dB20(obj.d21),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel([obj.nameMat{2,1}, '(dB)'])
        end

        function plot21phase(obj,style)
            % PLOT21phase plots the 21 parameter in deg

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,rad2deg(angle((obj.d21))),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel([obj.nameMat{2,1}, '(dB)'])
        end


    end

    methods (Access = private)

    end

    methods (Static = true)
        function obj = readTouchStone(pathNameExt, NrPorts)
            % READTOUCHSTONE reads a touchstone file
            % ToDo: lots of checks to handle any type besides S (will crash with noise data)
        
            if nargin < 2
                [S, freq] = touchread(pathNameExt);
            else
                [S, freq] = touchread(pathNameExt,NrPorts);
            end
            obj = TwoPort(S,freq./1e9,'S');

        end
        
        function obj = Cpar(C,f)
            % function obj = Cpar(L,f)
            % Shunt capacitance TwoPort object.
            %
            % Inputs:
            % C - Capacitence in F (can, in general, be function of frequency)
            % f - frequency in Hz

            f = f(:).';
            Nf = length(f);
            wC = 2.*pi.*f.*C;
            T(1,1,:) = ones(Nf,1);
            T(1,2,:) = zeros(Nf,1);
            T(2,1,:) = 1i.*wC;
            T(2,2,:) = T(1,1,:);
            obj = TwoPort(T,1e-9.*f,'ABCD');
        end

        function obj = Lser(L,f)
            % function obj = Lser(L,f)
            % Series inductance TwoPort object
            %
            % Inputs:
            % L - Inductance in H (can, in general, be function of frequency)
            % f - frequency in Hz

            f = f(:).';
            Nf = length(f);
            wL = 2.*pi.*f.*L;
            T(1,1,:) = ones(Nf,1);
            T(1,2,:) = 1i.*wL;
            T(2,1,:) = zeros(Nf,1);
            T(2,2,:) = T(1,1,:);
            obj = TwoPort(T,1e-9.*f,'ABCD');
        end

        function obj = Tline(Z0,L,f,eps_r,tan_delta,R_prime)
            % function obj = Tline(Z0,L,f,eps_r,tan_delta,R_prime)
            % Transmission line TwoPort object
            %
            % Inputs:
            % Z0 - characteristic impedance in Ohm (can, in general, be function of frequency)
            % L - Length in [m]
            % f - frequency in Hz
            % eps_r - relative permittivity (can, in general, be function of frequency) [1]
            % tan_delta - loss tangent (can, in general, be function of frequency) [0]
            % R_prime - resistance per unit length in Ohm/m (can, in general, be function of frequency) [0]

            f = f(:).';
            Nf = length(f);
            
            if nargin < 4 || isempty(eps_r), eps_r = 1; end
            if nargin < 5 || isempty(tan_delta), tan_delta = 0; end
            if nargin < 6 || isempty(R_prime), R_prime = 0; end

            eps_r = eps_r(:).';
            tan_delta = tan_delta(:).';
            R_prime = R_prime(:).';

            if numel(eps_r) > 1, assert(numel(eps_r) == Nf,'eps_r must have the same number of elements as f'); end
            if numel(tan_delta) > 1, assert(numel(tan_delta) == Nf,'tan_delta must have the same number of elements as f'); end
            if numel(R_prime) > 1, assert(numel(R_prime) == Nf,'R_prime must have the same number of elements as f'); end

            c0 = 299792458;
            alpha_c = R_prime./(2.*Z0);  % nepers/m
            alpha_d = pi.*sqrt(eps_r).*tan_delta.*f/c0;

            beta = 2*pi.*f./c0.*sqrt(eps_r);
            
            gamma = alpha_c + alpha_d + 1i.*beta;

            gL = gamma.*L;
            T(1,1,:) = cosh(gL);
            T(1,2,:) = Z0.*sinh(gL);
            T(2,1,:) = 1./Z0.*sinh(gL);
            T(2,2,:) = T(1,1,:);
            obj = TwoPort(T,1e-9.*f(:).','ABCD');
        end

    end

end