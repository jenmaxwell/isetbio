function [oi,fullName] = oiSPDScale(oi,fullName,op,skipIlluminant)
% Multiply, Divide, Add or Subtract the oi irradiance data
%
%    oi = oiSPDScale(oi,fullName,op,skipIlluminant);
%
%  The oi photon data are divided, multiplied, etc. using the spectral
%  information in fullName.  The calculation is applied to each pixel
%  in the oi. 
%  
%  When using multiply and divide, the spd values in the file are just
%  scale factors without real units.
%
%  When using add and subtract, however, the spd values in the file
%  must be in units of energy.  We convert them to photons and combine
%  them with the photon data in scene.  The values are in energy units
%  because that is the way most of the official formulae and data are
%  provided by standards organizations.
%
%  The fullName parameter is either a file that can be read using
%  ieReadSpectra, or a vector with length equal to the number of
%  wavelength samples in the oi.
%
%  The data in fullName are interpolated according to the information
%  in scene.
%
%  If fullname is not passed in, the user is asked to select the file.
%  The parameter op is set to '/', '*','+', or '-' to specify the
%  operation.  The routine name should probably be changed to
%  oiSPDOp, or oiSPDAdjust.
%
%  It is also possible to send in a data vector for fullName.  In this
%  case, YOU must make sure that the vector is the same dimensionality
%  as the number of wavelength samples in the oi.  If adding or
%  subtracting, the data must be in units of ENERGY.  If multiplying
%  or dividing, well it is just a dimensionless scale factor.
%
% Examples
%   [oi,fullName] = oiSPDScale(oi,'D65.mat','*');
%
% Copyright ImagEval Consultants, LLC, 2003.

if notDefined('scene'), [~, oi] = vcGetSelectedObject('OI'); end
if notDefined('fullName'), fullName = vcSelectDataFile('lights'); end
if isempty(fullName), return; end

% NOTE:  Check that the wavelength representations of the different objects
% agree

energy  = oiGet(oi,'energy');
wave    = oiGet(oi,'wave');
nWave   = oiGet(oi,'nwave');

% If the spd is sent in, it must be in energy units
if ischar(fullName),    spd = ieReadSpectra(fullName,wave);
else,                   spd = fullName;
end

% OK, this is awkward.  Almost all of the data we have stored on disk are
% in energy format.  Almost all of the calculations we perform are on
% photons.  So, I normally do this conversion.  If I were a better person,
% each of the data files would have a units field (e.g., quanta/sr/s/m2 and
% so forth) and I wouldn't have to guess.  This will come in the next
% release.

% If the scene has a current illuminant, say it is a multispectral scene,
% then we change the illuminant information also for multiply and divide.
switch op
    % I think these operations might be handled using RGB2XWFormat more
    % efficiently.
    case {'/','divide'}
        % for ii=1:nWave
        %    energy(:,:,ii) = energy(:,:,ii)/spd(ii);
        % end
        energy = bsxfun(@rdivide, energy, reshape(spd, [1 1 nWave]));

    case {'multiply','*'}
        % for ii=1:nWave
        %     energy(:,:,ii) = energy(:,:,ii)*spd(ii);
        % end
        energy = bsxfun(@times, energy, reshape(spd, [1 1 nWave]));

    case {'add','+','sum', 'plus'}
        % for ii=1:nWave
        %     energy(:,:,ii) = energy(:,:,ii) + spd(ii);
        % end
        energy = bsxfun(@plus, energy, reshape(spd, [1 1 nWave]));
    case {'subtract','-', 'minus'}
        energy = bsxfun(@minus, energy, reshape(spd, [1 1 nWave]));
    otherwise
        error('Unknown operation.')
end

% Place the adjusted data in the scene structure
[XW,r,c,~] = RGB2XWFormat(energy);
photons = XW2RGBFormat(Energy2Quanta(wave,XW')',r,c);
oi   = oiSet(oi,'photons',photons);

% Update the scene luminance information
illuminance = oiCalculateIlluminance(oi);
oi = oiSet(oi,'illuminance',illuminance);

end