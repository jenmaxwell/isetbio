classdef oiSequence
    % OISEQUENCE - Class for generating a temporal sequence of optical images
    %
    % The stimuli for many psychophysical and physiological experiments can
    % be described as a fixed background image combined with a time-varying
    % image. The oiSequence class includes methods that combine the such
    % image combinations across time.
    %
    % There is a companion method, oisCreate() that produces certain
    % classic oiSequences (harmonics, vernier targets, impulses). For some
    % cases, that function may provide a simpler interface for creating an
    % oiSequence.
    %
    % To create an oiSequence using this function ...
    %
    %    oiSeq = oiSequence(oiBackground, oiModulated, timeAxis, weightsTime, ...
    %                       'PARAM1',val,'PARAM2', val,  ...) 
    %
    % Optional parameter name/value pairs chosen from the following:
    %
    %   'composition'     -  add or blend or xor the fixed and modulated OIs
    %   'modulationRegion'-  choose a region of interest for the modulation
    %
    % Examples
    %   oiSequence = oiSequence(oiBackground, oiModulated, ...
    %                      modulationFunctionTimeAxis, modulationFunction)
    %
    %   modulationRegion.radiusInMicrons = 300;
    %   oiSequence = oiSequence(oiBackground, oiModulated, ...
    %                  modulationFunctionTimeAxis, modulationFunction, ...
    %                  'modulationRegion', modulationRegion);
    %
    % See also: oisCreate, t_oiSequence
    %
    %  NPC, ISETBIO TEAM, 2016
    
    % Programming TODO
    %
    % Maybe set up some oiGet/Set routines with the syntax
    %    oiSequence.get('oiFixed mumble') and
    %    oiSequence.get('oiModulated mumble')???
    %    Maybe oiSequence.get('frame',val)???
    
    
    properties
        photonsFixed;         % Photons stored as double
        photonsModulated;     % Photons stored as double
    end
    
    properties (Dependent)
        length
    end
    
    properties (SetAccess = private)
        % the fixed oi (an oi, the background)
        oiFixed
        
        % the modulated oi (an oi, the pedestal)
        oiModulated
        
        % the oiSequence timebase
        timeAxis
        
        % whether to add the oiModulated to the oiFixed or to blend it with the oiFixed
        composition;
        
        % the modulating function (an array of modulation values, one for
        % each frame)
        modulationFunction;
        
        % the modulating region (a struct describing the region extent to
        % be modulated (for now just a radius)
        modulationRegion;
    end
    
    
    methods  % public methods
        
        % constructor
        function obj = oiSequence(oiFixed, oiModulated, oiTimeAxis, modulationFunction, varargin)
            
            defaultModulationRegion = struct(...
                'radiusInMicrons', nan);
            
            p = inputParser;
            p.addRequired('oiFixed',  @isstruct);
            p.addRequired('oiModulated',  @isstruct);
            p.addRequired('oiTimeAxis', @isnumeric);
            p.addRequired('modulationFunction',  @isnumeric);
            p.addParameter('modulationRegion', defaultModulationRegion, @isstruct);
            p.addParameter('composition', 'add', @(x)ismember(x, {'add', 'blend', 'xor'}));
            p.parse(oiFixed, oiModulated, oiTimeAxis, modulationFunction, varargin{:});
            
            obj.oiFixed = p.Results.oiFixed;
            obj.oiModulated = p.Results.oiModulated;
            obj.timeAxis = p.Results.oiTimeAxis;
            obj.modulationFunction = p.Results.modulationFunction;
            obj.modulationRegion = p.Results.modulationRegion;
            obj.composition = p.Results.composition;
            
            % The timeAxis must be the same length as the number of
            % values in the modulationFunction.  If it only has 1 value, we
            % are going to assume that the value is delta T and we will
            % create the whole vector.  If it has a vector, but that vector
            % is not the same length as the modulationFunction, we throw an
            % error.
            if length(obj.timeAxis) == 1
                % First moment in time is 0. Increments by the set value.
                obj.timeAxis = obj.timeAxis*(0:(length(modulationFunction))-1);
            elseif length(obj.timeAxis) ~= length(obj.modulationFunction)
                error('Time axis does not match modulation function');
            end
            
            % Make sure that oiFixed and oiModulated have identical shape
            oiFixedSpatialSupport      = round(oiGet(obj.oiFixed, 'spatial support','microns'), 7);
            oiModulatedSpatialSupport  = round(oiGet(obj.oiModulated, 'spatial support','microns'), 7);
            
            if (any(size(oiFixedSpatialSupport) ~= size(oiModulatedSpatialSupport)))
                error('Mismatch between spatial dimensions of oiFixed, oiModulated');
            end
            if (any(oiFixedSpatialSupport(:) ~= oiModulatedSpatialSupport(:)))
                error('Mismatch between spatial support of oiFixed, oiModulated');
            end
        end
        
        %% Define methods in the @oiSequence directory
        
        % Method to compute the maximum number of eye movement for current
        % sequence and a given integrationTime
        maxEyeMovementsNum = maxEyeMovementsNumGivenIntegrationTime(obj, integrationTime);
        
        % Method for on-the-fly computation of the oi at desired index
        oiFrame = frameAtIndex(obj, index);
        
        % Visualize the sequence
        [uData, hFig] = visualize(obj,varargin);
        
        function val = timeStep(obj)
            val = obj.timeAxis(2) - obj.timeAxis(1);
        end
        
        %% Local get methods
        
        % Return the length of the oiSequence
        function val = get.length(obj)
            val = numel(obj.modulationFunction);
        end
        
        % Return the modulationFunction used
        function val = get.modulationFunction(obj)
            val = obj.modulationFunction;
        end
        
        % Return the timeAxis used
        function val = get.timeAxis(obj)
            val = obj.timeAxis;
        end
        
        % Return the composition type used
        function val = get.composition(obj)
            val = obj.composition;
        end
        
        
    end
    
end

