function val = osGet(obj, varargin)
% osGet: a method of @osIdentity that sets isetbio outersegment object 
% parameters using the input parser structure.
% 
% Parameters:
%       {'noiseFlag'} -  gets noise flag, noise-free ('0') or noisy ('1')
%       {'ConeCurrentSignal'} - cone current as a function of time
%       {'ConeCurrentSignalPlusNoise'} - noisy cone current signal
% 
% osGet(adaptedOS, 'noiseFlag')
% 
% 8/2015 JRG 

% Check for the number of arguments and create parser object.
% Parse key-value pairs.
% 
% Check key names with a case-insensitive string, errors in this code are
% attributed to this function and not the parser object.
error(nargchk(0, Inf, nargin));
p = inputParser; p.CaseSensitive = false; p.FunctionName = mfilename;

% Make key properties that can be set required arguments, and require
% values along with key names.
allowableFieldsToSet = {'noiseflag','rgbdata','patchsize','timestep','size'};
p.addRequired('what',@(x) any(validatestring(ieParamFormat(x),allowableFieldsToSet)));

% Define what units are allowable.
allowableUnitStrings = {'a', 'ma', 'ua', 'na', 'pa'}; % amps to picoamps

% Set up key value pairs.
% Defaults units:
p.addParameter('units','pa',@(x) any(validatestring(x,allowableUnitStrings)));

% Parse and put results into structure p.
p.parse(varargin{:}); params = p.Results;

switch ieParamFormat(params.what);  % Lower case and remove spaces

    case {'noiseflag'}        
        val = obj.noiseFlag;
                
    case{'patchsize'}
        val = obj.patchSize;
        
    case{'timestep'}
        val = obj.timeStep;
        
    case{'rgbdata'}
        val = obj.rgbData;
        
    case{'size'}
        val = size(obj.rgbData);
        
end
