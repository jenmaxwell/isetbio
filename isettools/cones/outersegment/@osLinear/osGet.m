function val = osGet(obj, varargin)
% Gets isetbio outersegment object parameters.
% 
% Parameters:
%       {'noiseFlag'} -  sets current as noise-free ('0') or noisy ('1')
%       {'sConeFilter'} - the linear filter for S-cone temporal response
%       {'mConeFilter'} - the linear filter for M-cone temporal response
%       {'lConeFilter'} - the linear filter for L-cone temporal response
%       {'patchSize'} - cone current as a function of time
%       {'timeStep'} - noisy cone current signal
%       {'size'} - array size of photon rate
%       {'coneCurrentSignal'} - cone current as a function of time
% 
% osGet(adaptedOS, 'noiseFlag')
% 
% 8/2015 JRG NC DHB


% Check for the number of arguments and create parser object.
% 
% Check key names with a case-insensitive string, errors in this code are
% attributed to this function and not the parser object.
narginchk(0, Inf);
p = inputParser; p.CaseSensitive = false; p.FunctionName = mfilename;

% Make key properties that can be set required arguments.
allowableFieldsToSet = {...
    'noiseflag',...
    'sconefilter',...
    'mconefilter',...
    'lconefilter',...
    'patchsize',...
    'timestep',...
    'size',...
    'conecurrentsignal'};
p.addRequired('what',@(x) any(validatestring(ieParamFormat(x),allowableFieldsToSet)));

% Parse and put results into structure p.
p.parse(varargin{:}); 
params = p.Results;

switch ieParamFormat(params.what)

    case{'sconefilter'}
        val = obj.sConeFilter;
        
    case{'mconefilter'}
        val = obj.mConeFilter;
    
    case{'lconefilter'}
        val = obj.lConeFilter;        
        
    case{'patchsize'}
        val = obj.patchSize;
        
    case{'timestep'}
        val = obj.timeStep;
        
    case{'size'}
        val = size(obj.coneCurrentSignal);
        
    case{'noiseflag'}
        val = obj.noiseFlag;
        
    case{'conecurrentsignal'}
        val = obj.coneCurrentSignal;
end

