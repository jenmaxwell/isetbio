function oi = oiInterpolateW(oi,newWave)
%Wavelength interpolation for optical image data
%
%  oi = oiInterpolateW(oi,[newWave])
%
% Interpolate the wavelength dimension of an optical image.
%   
% Examples:
%   oi = oiInterpolateW(oi,[400:10:700])
%
% Copyright ImagEval Consultants, LLC, 2003.

%% Params
if notDefined('oi'),      oi = vcGetObject('oi'); end
if notDefined('newWave'), error('New wavelength samples required'); end

% Note the current oi wave and mean illuminance
curWave = oiGet(oi,'wave');
meanIll = oiGet(oi,'mean illuminance');

%% Current oi photons
photons = oiGet(oi,'photons');

% We used to clear the data to save memory space.  
% oi = oiClearData(oi);

% We do this trick to be able to do a 1D interpolation. It is fast
% ... 2d is slow.  The RGB2XW format puts the photons in columns by
% wavelength.  The interp1 interpolates across wavelength
[photons, row, col] = RGB2XWFormat(photons);
newPhotons = interp1(curWave,photons',newWave)';
newPhotons = XW2RGBFormat(newPhotons,row,col);

oi = oiSet(oi,'wave',newWave); 
oi = oiSet(oi,'photons',newPhotons);

% Preserve the original mean luminance (stored in meanL) despite the resampling.
oi = oiSet(oi,'illuminance',oiCalculateIlluminance(oi));
oi = oiAdjustIlluminance(oi,meanIll);


%% End
