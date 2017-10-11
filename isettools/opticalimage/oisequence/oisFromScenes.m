function [oiseq,OIs] = oisFromScenes(oi, scenes, composition, modulation, varargin)
% Combine two scenes and an oi into an oi sequence
%
% Required
%   'oi'  - An optical image structure
%   'scenes' - A cell array of two matched scenes that will be combined
%
% Optional parameters
%   'composition'  - 'add' or 'blend'
%   'modulation'   - Series of weights describing the add or blend
%
% In the case of 'add', the first scene will be on steadily and should be,
% say, the uniform scene.
%
%{
oi = oiCreate;
hParams = harmonicP;
hParams.freq = 5;
hParams.GaborFlag = 0.2;
scenes{2} = sceneCreate('harmonic',hParams);
mn = sceneGet(scenes{2},'mean luminance');
bb = blackbody(sceneGet(scenes{2},'wave'),3000);
scenes{2} = sceneAdjustIlluminant(scenes{2},bb);
scenes{2} = sceneAdjustLuminance(scenes{2},mn);
ieAddObject(scenes{2}); sceneWindow;

hParams.contrast = 0;
scenes{1} = sceneCreate('harmonic',hParams);
modulation = ieScale(fspecial('gaussian',[1,50],15),0,1);
[ois,OI] = oisFromScenes(oi,scenes,'blend',modulation);
ois.visualize;
%}
% BW ISETBIO Team, LLC

%%
p = inputParser;
p.KeepUnmatched = true;

% Required
p.addRequired('oi',@isstruct);
p.addRequired('scenes',@iscell);
p.addRequired('composition',@ischar);
p.addRequired('modulation');

% Parameters
p.addParameter('sampleTimes',[],@isvector);

p.parse(oi,scenes,composition,modulation,varargin{:});

sampleTimes = p.Results.sampleTimes;
if isempty(sampleTimes)
    % 1 ms sampling assumed
    sampleTimes = 0.001*((1:length(modulation))-1);
end

%%

OIs = cell(1, 2);
for ii = 1:2
    OIs{ii} = oiCompute(oi,scenes{ii});
end

oiseq = oiSequence(OIs{1}, OIs{2}, sampleTimes, modulation, ...
    'composition', composition);

return;