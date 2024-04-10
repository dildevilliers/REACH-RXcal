classdef OnePort < Network
    % ONEPORT is a 1-port Network

    properties (SetAccess = private)

    end

    properties (Dependent = true)
        
    end

    properties (Dependent = true, Hidden = true)
        
    end

    methods
        function obj = OnePort(data,freqGHz,type,Zport1)
            % ONEPORT class constructor method.

            if nargin > 0 && ~isempty(data), obj.data = data; end
            if nargin > 1 && ~isempty(freqGHz), obj.freq = freqGHz; end
            if nargin > 2 && ~isempty(type), obj.type = type; end
            if nargin > 3 && ~isempty(Zport1), obj.Zport(1,:) = Zport1; end

            assert(size(obj.data,3) == obj.Nf,'Third dimension of data must have the same number of elements as freq')
            assert(numel(obj.Zport1) == 1 || numel(obj.Zport1) == obj.Nf,'Zport1 must have the same number of elements as freq')

        end

        % Circuit solver
        function obj = series2port(obj,Zport1,Zport2)
            % SERIES2PORT returns a series connected 2-port network of the provided 1-port network

            obj = obj.getZ;
            Z1_ = 50;
            Z2_ = 50;
            if nargin > 1 && ~isempty(Zport1), Z1_ = Zport1; end
            if nargin > 2 && ~isempty(Zport2), Z2_ = Zport2; end
            d_ = ones(2,2,obj.Nf);
            d_(1,2,:) = obj.data;
            d_(2,1,:) = 0.*d_(2,1,:);
            obj = TwoPort(d_,obj.freqHz./1e9,'ABCD',Z1_,Z2_);
        end

        function obj = parallel2port(obj,Zport1,Zport2)
            % PARALLEL2PORT returns a parallel connected 2-port network of the provided 1-port network

            obj = obj.getY;
            Z1_ = 50;
            Z2_ = 50;
            if nargin > 1 && ~isempty(Zport1), Z1_ = Zport1; end
            if nargin > 2 && ~isempty(Zport2), Z2_ = Zport2; end
            d_ = ones(2,2,obj.Nf);
            d_(2,1,:) = obj.data;
            d_(1,2,:) = 0.*d_(1,2,:);
            obj = TwoPort(d_,obj.freqHz./1e9,'ABCD',Z1_,Z2_);
        end

        % Transformations
        function obj = getY(obj)
            % GETY returns the object of type Y-parameter

            switch obj.type
                case 'Y'
                    return;
                    % Do nothing
                case 'Z'
                    obj.data = 1./obj.data;
                case 'S'
                    objZ = obj.getZ;
                    obj.data = 1./objZ.data;
                otherwise
                    error('I should not be here...')
            end
            obj.type = 'Y';
        end

        function obj = getZ(obj)
            % GETZ returns the object of type Z-parameter

            switch obj.type
                case 'Z'
                    return;
                    % Do nothing
                case 'Y'
                    obj.data = 1./obj.data;
                case 'S'
                    Gam = obj.data;
                    obj.data = obj.Zport1.*(1 + Gam)./(1 - Gam);
                otherwise
                    error('I should not be here...')
            end
            obj.type = 'Z';
        end

        function obj = getS(obj,Zport1)
            % GETS returns the object of type Y-parameter

            Z1 = obj.Zport1;
            if nargin > 1 && ~isempty(Zport1), Z1 = Zport1(:); end

            if strcmp(obj.type,'S') && isequal(Z1,obj.Zport1)
                return;
                % Do nothing
            else
                % Change impedance levels and/or transform from other parameter - always via Z
                objZ = obj.getZ;
                ZL = objZ.data;
                obj.data = (ZL - Z1)./(ZL + Z1);
                obj.Zport(1) = Z1;
                obj.type = 'S';
            end
        end

    end

%     methods (Access = private)
%         function obj = connection(objIn,connectType)
%             % CONNECTION is the internal function to connect elements in series/parallel
% 
%             switch connectType
%                 case 'parallel'
%                     transFunc = @getY;
%                     conFunc = @plus;
%                 case 'series'
%                     transFunc = @getZ;
%                     conFunc = @plus;
%                 otherwise
%                     error('I should not be here')
%             end
% 
%             obj = objIn(1);
%             typeIn = obj.type;
%             if length(objIn) > 1
%                 obj = transFunc(obj);
%                 for ii = 2:length(objIn)
%                     obj0 = transFunc(objIn(ii));
%                     if ~strcmp(obj.fUnit,obj0.fUnit), obj0 = obj0.freqChangeUnit(obj.fUnit); end
%                     tol = min(obj.freq).*1e-9;
%                     assert(max(abs(obj.freq - obj0.freq)) < tol,'Frequencies do not match')
%                     obj.data = conFunc(obj.data,obj0.data);
%                 end
%             end
%             transFun = str2func(['get',typeIn]);
%             obj = transFun(obj);
% 
%         end
%     end

    methods (Static = true)
        function obj = readTouchStone(pathNameExt, freqInterp)
            % READTOUCHSTONE reads a touchstone file
            % ToDo: lots of checks to handle any type besides S (will crash with noise data)
            %
            % Inputs:
            % pathNameExt - path name and extension to file
            % freqInterp - vector of frequencies where the data must be interpolated (in Hz) 
        
            [S, freq] = touchread(pathNameExt,1);
            
            obj = OnePort(S,freq./1e9,'S');
            
            if nargin > 2 && ~isempty(freqInterp)
                obj = obj.freqInterp(freqInterp,'linear');
            end
        end
        
        function obj = C(C,f,Zport1)
            % function obj = C(C,f,Zport1)
            % OnePort (two-terminal) capacitor
            %
            % Inputs:
            % C - Capacitance in F (can, in general, be function of frequency)
            % f - frequency in Hz
            % Zport1 - Port 1 impedance (can generally be function of frequency)

            if nargin < 3 || isempty(Zport1), Zport1 = 50; end

            f = f(:).';
            Zc(1,1,:) = 1./(1i.*2.*pi.*f.*C);
            obj = OnePort(Zc,1e-9.*f,'Z',Zport1);
        end

        function obj = L(L,f,Zport1)
            % function obj = L(L,f,Zport1)
            % OnePort (two-terminal) inductor
            %
            % Inputs:
            % L - Inductance in H (can, in general, be function of frequency)
            % f - frequency in Hz
            % Zport1 - Port 1 impedance (can generally be function of frequency)

            if nargin < 3 || isempty(Zport1), Zport1 = 50; end

            f = f(:).';
            Zl(1,1,:) = 1i.*2.*pi.*f.*L;
            obj = OnePort(Zl,1e-9.*f,'Z',Zport1);
        end

        function obj = R(R,f,Zport1)
            % function obj = R(R,f,Zport1)
            % OnePort (two-terminal) resistor
            %
            % Inputs:
            % R - Resistance in Ohm (can, in general, be function of frequency)
            % f - frequency in Hz
            % Zport1 - Port 1 impedance (can generally be function of frequency)

            if nargin < 3 || isempty(Zport1), Zport1 = 50; end

            f = f(:).';
            Zr(1,1,:) = ones(1,numel(f)).*R;
            obj = OnePort(Zr,1e-9.*f,'Z',Zport1);
        end

        function obj = TlineLoad(ZL,Z0,L,f,eps_r,Zport1)
            % function obj = TlineLoad(ZL,Z0,L,f,eps_r)
            % Loaded lossless transmission line OnePort object
            %
            % Inputs:
            % ZL - load impedance in Ohm (can, in general, be function of frequency)
            % Z0 - characteristic impedance in Ohm (can, in general, be function of frequency)
            % L - Length in [m]
            % f - frequency in Hz
            % eps_r - relative permittivity (can, in general, be function of frequency) [1]
            
            f = f(:).';
            Nf = length(f);
            
            if nargin < 5 || isempty(eps_r), eps_r = 1; end
            if nargin < 6 || isempty(Zport1), Zport1 = 50; end
            
            eps_r = eps_r(:).';
            
            if numel(eps_r) > 1, assert(numel(eps_r) == Nf,'eps_r must have the same number of elements as f'); end
            
            c0 = 299792458;
            
            beta = 2*pi.*f./c0.*sqrt(eps_r);
            
            bL = beta.*L;
            tanbL = tan(bL);
            if ZL == 0
                Zin(1,1,:) = 1i.*Z0.*tanbL;
            elseif isinf(ZL)
                Zin(1,1,:) = -1i.*Z0./tanbL;
            else
                Zin(1,1,:) = Z0.*(ZL + 1i.*tanbL)./(Z0 + 1i.*tanbL);
            end
            obj = OnePort(Zin,1e-9.*f,'Z',Zport1);
        end
    end
end