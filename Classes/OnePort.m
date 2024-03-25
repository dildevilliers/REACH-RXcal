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
    end
end