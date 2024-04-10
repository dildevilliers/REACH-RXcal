classdef TwoPort < Network
    % TWOPORT is a 2-port Network

    properties
        
    end

    properties (SetAccess = private)

    end

    properties (SetAccess = private, Hidden = true)
        
    end

    properties (Dependent = true)
        Zport2
    end

    properties (Dependent = true, Hidden = true)
        d12
        d21
        d22
    end

    properties (Constant = true)

    end

    methods
        function obj = TwoPort(data,freqGHz,type,Zport1,Zport2)
            % TWOPORT class constructor method.

            obj.Nports = 2;
            obj.Zport = ones(obj.Nports,1).*obj.Zport(1,1);

            if nargin > 0 && ~isempty(data), obj.data = data; end
            if nargin > 1 && ~isempty(freqGHz), obj.freq = freqGHz; end
            if nargin > 2 && ~isempty(type), obj.type = type; end
            if nargin > 3 && ~isempty(Zport1), obj.Zport(1,:) = Zport1; end
            if nargin > 4 && ~isempty(Zport2), obj.Zport(2,:) = Zport2; end
            

            assert(size(obj.data,3) == obj.Nf,'Third dimension of data must have the same number of elements as freq')
            assert(numel(obj.Zport1) == 1 || numel(obj.Zport1) == obj.Nf,'Zport1 must have the same number of elements as freq')
            assert(numel(obj.Zport2) == 1 || numel(obj.Zport2) == obj.Nf,'Zport2 must have the same number of elements as freq')

            
        end

        % Dependent getters
        function d12 = get.d12(obj)
            d12 = squeeze(obj.data(1,2,:));
        end

        function d21 = get.d21(obj)
            d21 = squeeze(obj.data(2,1,:));
        end

        function d22 = get.d22(obj)
            d22 = squeeze(obj.data(2,2,:));
        end

        function Zport2 = get.Zport2(obj)
            Zport2 = obj.Zport(2,:);
        end

        % Circuit solver
        function obj = cascade(obj)
            % CASCADE calculates the cascaded circuit of the input array
            obj = obj.connection('cascade');
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
            if nargin > 1 && ~isempty(Zport1), Z1 = Zport1(:); end
            if nargin > 2 && ~isempty(Zport2), Z2 = Zport2(:); end

            if strcmp(obj.type,'S') && isequal(Z1,obj.Zport1) && isequal(Z2,obj.Zport2)
                % Do nothing
            elseif strcmp(obj.type,'S')
                % Change impedance levels
                objABCD = obj.getABCD;
                objABCD.Zport(1) = Z1;
                objABCD.Zport(2) = Z2;
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
                    case 'Y'
                        Y11 = obj.d11;
                        Y12 = obj.d12;
                        Y21 = obj.d21;
                        Y22 = obj.d22;

                        den = (1 + Y11.*Z1).*(1 + Y22.*Z2) - Y12.*Y21.*Z1.*Z2;
                        obj.data(1,1,:) = ((1 - Y11.*conj(Z1)).*(1 + Y22.*Z2) + Y12.*Y21.*conj(Z1).*Z2)./den;
                        obj.data(1,2,:) = (-2.*Y12.*sqrt(real(Z1).*real(Z2)))./den;
                        obj.data(2,1,:) = (-2.*Y21.*sqrt(real(Z1).*real(Z2)))./den;
                        obj.data(2,2,:) = ((1 + Y11.*Z1).*(1 - Y22.*conj(Z2)) + Y12.*Y21.*Z1.*conj(Z2))./den;
                    case 'Z'
                        Z11 = obj.d11;
                        Z12 = obj.d12;
                        Z21 = obj.d21;
                        Z22 = obj.d22;

                        den = (Z11 + Z1).*(Z22 + Z2) - Z12.*Z21;
                        obj.data(1,1,:) = ((Z11 - conj(Z1)).*(Z22 + Z2) - Z12.*Z21)./den;
                        obj.data(1,2,:) = (2.*Z12.*sqrt(real(Z1).*real(Z2)))./den;
                        obj.data(2,1,:) = (2.*Z21.*sqrt(real(Z1).*real(Z2)))./den;
                        obj.data(2,2,:) =  ((Z11 + Z1).*(Z22 - conj(Z2)) - Z12.*Z21)./den;
                    otherwise
                        error('I should not be here...')
                end
                obj.type = 'S';
                obj.Zport(1) = Z1;
                obj.Zport(2) = Z2;
            end
        end

        function obj = getABCD(obj)
            % GETABCD returns the object of type ABCD-parameter

            switch obj.type
                case 'ABCD'
                    return;
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
                case 'Y'
                    Y11 = obj.d11;
                    Y12 = obj.d12;
                    Y21 = obj.d21;
                    Y22 = obj.d22;

                    obj.data(1,1,:) = -Y22./Y21;
                    obj.data(1,2,:) = -1./Y21;
                    obj.data(2,1,:) = (Y12.*Y21 - Y11.*Y22)./Y21;
                    obj.data(2,2,:) = -Y11./Y21;
                case 'Z'
                    Z11 = obj.d11;
                    Z12 = obj.d12;
                    Z21 = obj.d21;
                    Z22 = obj.d22;

                    obj.data(1,1,:) = Z11./Z21;
                    obj.data(1,2,:) = (Z11.*Z22 - Z12.*Z21)./Z21;
                    obj.data(2,1,:) = 1./Z21;
                    obj.data(2,2,:) = Z22./Z21;
                otherwise
                    error('I should not be here...')
            end
            obj.type = 'ABCD';
        end

        function obj = getY(obj)
            % GETY returns the object of type Y-parameter

            switch obj.type
                case 'Y'
                    return;
                    % Do nothing
                case 'Z'
                    obj.data = pageinv(obj.data);
                case 'ABCD'
                    A = obj.d11;
                    B = obj.d12;
                    C = obj.d21;
                    D = obj.d22;

                    obj.data(1,1,:) = D./B;
                    obj.data(1,2,:) = (B.*C - A.*D)./B;
                    obj.data(2,1,:) = -1./B;
                    obj.data(2,2,:) = A./B;
                case 'S'
                    S11 = obj.d11;
                    S12 = obj.d12;
                    S21 = obj.d21;
                    S22 = obj.d22;

                    Z1 = obj.Zport1(:);
                    Z2 = obj.Zport2(:);

                    den = (conj(Z1) + S11.*Z1).*(conj(Z2) + S22.*Z2) - S12.*S21.*Z1.*Z2;
                    obj.data(1,1,:) = ((1 - S11).*(conj(Z2) + S22.*Z2) + S12.*S21.*Z2)./den;
                    obj.data(1,2,:) = (-2.*S12.*sqrt(real(Z1).*real(Z2)))./den;
                    obj.data(2,1,:) = (-2.*S21.*sqrt(real(Z1).*real(Z2)))./den;
                    obj.data(2,2,:) = ((1 - S22).*(conj(Z1) + S11.*Z1) + S12.*S21.*Z1)./den;
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
                    obj.data = pageinv(obj.data);
                case 'ABCD'
                    A = obj.d11;
                    B = obj.d12;
                    C = obj.d21;
                    D = obj.d22;

                    obj.data(1,1,:) = A./C;
                    obj.data(1,2,:) = (A.*D - B.*C)./C;
                    obj.data(2,1,:) = 1./C;
                    obj.data(2,2,:) = D./C;
                case 'S'
                    S11 = obj.d11;
                    S12 = obj.d12;
                    S21 = obj.d21;
                    S22 = obj.d22;

                    Z1 = obj.Zport1(:);
                    Z2 = obj.Zport2(:);

                    den = (1 - S11).*(1 - S22) - S12.*S21;
                    obj.data(1,1,:) = ((conj(Z1) + S11.*Z1).*(1 - S22) + S12.*S21.*Z1)./den;
                    obj.data(1,2,:) = (2.*S12.*sqrt(real(Z1).*real(Z2)))./den;
                    obj.data(2,1,:) = (2.*S21.*sqrt(real(Z1).*real(Z2)))./den;
                    obj.data(2,2,:) = ((1 - S11).*(conj(Z2) + S22.*Z2) + S12.*S21.*Z2)./den;
                otherwise
                    error('I should not be here...')
            end
            obj.type = 'Z';
        end

        function obj = inv(obj)
            % INV returns the inverse ABCD matrix for de-embedding

            typeIn = obj.type;
            obj = obj.getABCD;
            obj.data = pageinv(obj.data);
            transFun = str2func(['get',typeIn]);
            obj = transFun(obj);
        end

        % Output

        function writeTouchStone(obj,pathName,N)
            % writeTouchStone writes an .s2p or .s1p touchstone output file to pathName
            % N is the number of ports. If N = 1, the .s1p output as seen from port 1 will be written. 
            %   Here it is assumed that Zport2 is the load connected to the network.
            % Default is N = 2 for the full .s2p file
            % TODO: Fix this for arrays of Zport

            assert(numel(obj.Zport1) == 1 && numel(obj.Zport2) == 1,'Not implemented yet for variable impedance')

            if nargin < 2 || isempty(pathName), pathName = 'temp.s2p'; end
            if nargin < 3 || isempty(N), N = 2; end
            assert(N == 1 || N == 2,'N must be 1 or 2')

            [p,n] = fileparts(pathName);
            if ~isempty(p) && ~isequal(p(end),'\'), p = [p,'\']; end

            obj = obj.getS;

            header = {'! S-parameter export from MATLAB TwoPort class';...
                ['!   Creation date: ',char(datetime('now'))]};
            data_ = [obj.freq(:),...
                    dB20(obj.d11(:)),rad2deg(angle(obj.d11))];

            datform_f = '%1.7f\t';
            datform_s = '%1.7f\t%12.4f\t';

            if N == 2
                fid = fopen([p,n,'.s2p'],'w+');

                header = [header;...
                    {['# ',upper(obj.fUnit),' S DB R ',num2str(obj.Zport1),' ',num2str(obj.Zport2)];...
                    ['! FREQ.',upper(obj.fUnit),'      S11dB       S11deg       S21dB        S21deg       S12dB         S12deg       S22dB       S22deg   ']}];
                
                data_ = [data_,...
                    dB20(obj.d21(:)),rad2deg(angle(obj.d21)),...
                    dB20(obj.d12(:)),rad2deg(angle(obj.d12)),...
                    dB20(obj.d22(:)),rad2deg(angle(obj.d22))];
                dataFormat = [datform_f,repmat(datform_s,1,4),'\n'];
            elseif N == 1
                fid = fopen([p,n,'.s1p'],'w+');

                header = [header;...
                    {['# ',upper(obj.fUnit),' S DB R ',num2str(obj.Zport1)];...
                    ['! FREQ.',upper(obj.fUnit),'      S11dB       S11deg       ']}];

                dataFormat = [datform_f,datform_s,'\n'];
            else
                error('I should not be here')
            end

            for hh = 1:numel(header)
                fprintf(fid,'%s\n',header{hh});
            end
            for dd = 1:size(data_,1)
                fprintf(fid,dataFormat,data_(dd,:));
            end

            fclose(fid);
            
        end

        % Plotting
        function plot21dB(obj,style)
            % PLOT21dB plots the 21 parameter in dB

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,dB20(obj.d21),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel(['|',obj.nameMat{2,1}, '| (dB)'])
        end

        function plot21phase(obj,style)
            % PLOT21phase plots the 21 parameter in deg

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(obj.freq,rad2deg(angle((obj.d21))),style), grid on, hold on
            xlabel(['Frequency (',obj.fUnit,')'])
            ylabel([obj.nameMat{2,1}, ' (deg)'])
        end

        function plot21RI(obj,style)
            % PLOT21RI plots the 21 parameter on the complex plane

            if nargin < 2 || isempty(style), style = 'k'; end

            plot(real(obj.d21),imag(obj.d21),style), grid on, hold on
            xlabel(['real(',obj.nameMat{2,1}, ')'])
            ylabel(['imag(',obj.nameMat{2,1}, ')'])
        end

    end

    methods (Access = private)

    end

    methods (Static = true)
        function obj = readTouchStone(pathNameExt, NrPorts, freqInterp)
            % READTOUCHSTONE reads a touchstone file
            % ToDo: lots of checks to handle any type besides S (will crash with noise data)
            %
            % Inputs:
            % pathNameExt - path name and extension to file
            % NrPort - number of ports, which is mostly left empty if it can be deduced from extension or header
            % freqInterp - vector of frequencies where the data must be interpolated (in Hz) 
        
            if nargin < 2 || isempty(NrPorts)
                [S, freq] = touchread(pathNameExt);
            else
                [S, freq] = touchread(pathNameExt,NrPorts);
            end

            obj = TwoPort(S,freq./1e9,'S');
            
            if nargin > 2 && ~isempty(freqInterp)
                obj = obj.freqInterp(freqInterp,'linear');
            end

            
        end
        
        function obj = Cpar(C,f,Zport1,Zport2)
            % function obj = Cpar(L,f,Zport1,Zport2)
            % Shunt capacitance TwoPort object.
            %
            % Inputs:
            % C - Capacitence in F (can, in general, be function of frequency)
            % f - frequency in Hz
            % Zport1 - Port 1 impedance (can generally be function of frequency)
            % Zport2 - Port 2 impedance (can generally be function of frequency)

            if nargin < 3 || isempty(Zport1), Zport1 = 50; end
            if nargin < 4 || isempty(Zport2), Zport2 = 50; end

            f = f(:).';
            Nf = length(f);
            wC = 2.*pi.*f.*C;
            T(1,1,:) = ones(Nf,1);
            T(1,2,:) = zeros(Nf,1);
            T(2,1,:) = 1i.*wC;
            T(2,2,:) = T(1,1,:);
            obj = TwoPort(T,1e-9.*f,'ABCD',Zport1,Zport2);
        end

        function obj = Lser(L,f,Zport1,Zport2)
            % function obj = Lser(L,f,Zport1,Zport2)
            % Series inductance TwoPort object
            %
            % Inputs:
            % L - Inductance in H (can, in general, be function of frequency)
            % f - frequency in Hz
            % Zport1 - Port 1 impedance (can generally be function of frequency)
            % Zport2 - Port 2 impedance (can generally be function of frequency)

            if nargin < 3 || isempty(Zport1), Zport1 = 50; end
            if nargin < 4 || isempty(Zport2), Zport2 = 50; end

            f = f(:).';
            Nf = length(f);
            wL = 2.*pi.*f.*L;
            T(1,1,:) = ones(Nf,1);
            T(1,2,:) = 1i.*wL;
            T(2,1,:) = zeros(Nf,1);
            T(2,2,:) = T(1,1,:);
            obj = TwoPort(T,1e-9.*f,'ABCD',Zport1,Zport2);
        end

        function obj = PI_CLC(C1,L,C2,f,Zport1,Zport2)
            % function obj = PI_CLC(C1,L,C2,f,Zport1,Zport2)
            % PI network with C1-L-C2 order TwoPort object
            %
            % Inputs:
            % C1 - port 1 side capacitance in F (can, in general, be function of frequency)
            % L - Inductance in H (can, in general, be function of frequency)
            % C1 - port 2 side capacitance in F (can, in general, be function of frequency)
            % f - frequency in Hz
            % Zport1 - Port 1 impedance (can generally be function of frequency)
            % Zport2 - Port 2 impedance (can generally be function of frequency)

            if nargin < 5 || isempty(Zport1), Zport1 = 50; end
            if nargin < 6 || isempty(Zport2), Zport2 = 50; end

            f = f(:).';
            Nf = length(f);
            wC1 = 2.*pi.*f.*C1;
            wL = 2.*pi.*f.*L;
            wC2 = 2.*pi.*f.*C2;
            Y1 = 1i.*wC1;
            Y2 = 1i.*wC2;
            Y3 = -1i./wL;
            T(1,1,:) = ones(1,Nf) + Y2./Y3;
            T(1,2,:) = 1./Y3;
            T(2,1,:) = Y1 + Y2 + Y1.*Y2./Y3;
            T(2,2,:) = 1 + Y1./Y3;
            obj = TwoPort(T,1e-9.*f,'ABCD',Zport1,Zport2);
        end

        function obj = Tline(Z0,L,f,eps_r,tan_delta,R_prime,Zport1,Zport2)
            % function obj = Tline(Z0,L,f,eps_r,tan_delta,R_prime,Zport1,Zport2)
            % Transmission line TwoPort object
            %
            % Inputs:
            % Z0 - characteristic impedance in Ohm (can, in general, be function of frequency)
            % L - Length in [m]
            % f - frequency in Hz
            % eps_r - relative permittivity (can, in general, be function of frequency) [1]
            % tan_delta - loss tangent (can, in general, be function of frequency) [0]
            % R_prime - resistance per unit length in Ohm/m (can, in general, be function of frequency) [0]
            % Zport1 - Port 1 impedance (can generally be function of frequency)
            % Zport2 - Port 2 impedance (can generally be function of frequency)

            f = f(:).';
            Nf = length(f);
            
            if nargin < 4 || isempty(eps_r), eps_r = 1; end
            if nargin < 5 || isempty(tan_delta), tan_delta = 0; end
            if nargin < 6 || isempty(R_prime), R_prime = 0; end
            if nargin < 7 || isempty(Zport1), Zport1 = 50; end
            if nargin < 8 || isempty(Zport2), Zport2 = 50; end

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
            obj = TwoPort(T,1e-9.*f(:).','ABCD',Zport1,Zport2);
        end

    end

end