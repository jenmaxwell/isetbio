function d = displaySet(d,parm,val,varargin)
%DISPLAYSET - Set display parameter values
%
%   d = displaySet(d,parm,val,varargin)
%
% Parameters
%   'name'               - display name
%   'gTable'             - gamma table
%   'wave'               - sample wavelength
%   'spd'                - spectral power distribution (average, not peak)
%   'dpi'                - dots per inch
%   'size'               - vector of [h, v] in meters
%   'dixel'              - subpixel structure
%   'viewing distance'   - viewing distance
%   'comment'            - comments for this display
%   'main image'         - main display window image
%
% Examples:
%
%  d = displayCreate;
%  d = displaySet(d,'gTable',val)
%  d = displaySet(d,'gTable','linear');
%  d = displaySet(d,'name','My Display Type');
%
% See also: 
%   displayGet, displayCreate, ieLUTDigital, ieLUTLinear
%
% Copyright ImagEval 2011
%
% 6/25/15  dhb  Added size set

if notDefined('parm'), error('Parameter not found.');  end

% Convert parameter format
parm = ieParamFormat(parm);

switch parm
    case {'name'}
        d.name = val;
    case {'type'}
        d.type = val;
    case {'gtable','dv2intensity','gamma'}
        % d = displaySet(d,'gamma',val)
        % d = displaySet(d,'gamma','linear');
        % From digital values to primary intensity
        % Should be same number of columns as primaries
        if ischar(val) && strcmp(val, 'linear')
            % User just wants a linear gamma table
            val = linspace(0,1,size(d.gamma,1));
            val = repmat(val(:),1,displayGet(d, 'nprimaries'));
        end
        d.gamma = val;
    case {'wave','wavelength'}  %nanometers
        % d = displaySet(d,'wave',val);
        % Force column, interpolate SPD, and don't do anything if it turns
        % out that the value was already as sent in.
        if ~isfield(d, 'wave')
            d.wave = val(:);
        elseif ~isequal(val(:),d.wave)
            spd = displayGet(d,'spd');
            wave = displayGet(d,'wave');
            newSPD = interp1(wave, spd, val(:), 'linear');
            
            am = displayGet(d, 'ambient spd');
            newAM = interp1(wave, am, val(:), 'linear', 0);
            
            d.wave = val(:);
            d = displaySet(d,'spd',newSPD);
            d = displaySet(d, 'ambient spd', newAM);
        end

    case {'spd','spdprimaries'}
        % d = displaySet(d,'spd primaries',val);
        if ~ismatrix(val), error('unknown spd structure'); end
        if size(val,1) < size(val, 2), val = val'; end
        d.spd = val;
    case {'dpi'}
        % displaySet(d, 'dpi', val);
        % Dots per inch of the pixels (full pixel center-to-center)
        d.dpi = val;
    case {'size'}
        % displaySet(d,'size',val)
        % [h,v] size in meters
        if (~ismatrix(val)) error('unknown form for size'); end
        if (~length(val) == 2) error ('size should be [h,v]'); end
        d.size = val;
    case {'viewingdistance'}
        % displaySet(d, 'viewing distance', val);
        % viewing distance in meters
        d.dist = val;
    case {'refreshrate'}
        % refresh rate of the display in Hz
        d.refreshRate = val;
    case {'mainimage'}
        % main display image for displayWindow
        % This should be an RGB image
        d.mainimage = val;
    case {'dixel'}
        % displaySet(d, 'dixel', val)
        % dixel structure
        assert(isstruct(val), 'dixel should be a structure');
        d.dixel = val;
    case {'dixelintensitymap', 'dixelimage'}
        % dixel intensity map
        if size(val, 3) ~= displayGet(d, 'nprimaries')
            error('bad dixel intensity image size');
        end
        d.dixel.intensitymap = val;
    case {'dixelcontrolmap'}
        if size(val, 3) ~= displayGet(d, 'nprimaries')
            error('bad dixel control image size');
        end
        d.dixel.controlmap = val;
    case {'pixelsperdixel'}
        d.dixel.nPixels = val;
    case {'renderfunction'}
        d.dixel.renderFunc = val;
    case {'comment'}
        % comment for the display
        d.comment = val;
    case {'ambientspd'}
        % ambient spd for display
        d.ambient = val;
    otherwise
        error('Unknown parameter %s\n',parm);
end

end