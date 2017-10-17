%%t_coneMosaicBasic  Basic introduction to the cone mosaic object.
%
% Shows how to create a cone mosaic object and compute cone
% isomerizations across a set of small eye movements.  This lets you
% look at the result in the coneMosaic window.
%

%% Initialize and clear
ieInit;

%% Build a simple scene and oi (retinal image) for computing
%
% First the scene
s = sceneCreate('rings rays');
s = sceneSet(s,'fov',1);

% Then the oi
oi = oiCreate;
oi = oiCompute(oi,s);

%% Build a default cone mosaic and compute isomerizatoins
%
% Create the coneMosaic object
cMosaic = coneMosaic;  

% Set size to show about half the scene.  Speeds things
% up.
cMosaic.setSizeToFOV(0.5*sceneGet(s,'fov')); 

%% Generate a sequence of 100 eye posistions.
cMosaic.emGenSequence(100);

%% Compute isomerizations for each eye position.
cMosaic.compute(oi);

%% Bring up a window so that we can look at things.
%
% Using the pull down in the window, you can look at 
% the mosaic, the isomerizations for one fixation, or
% the movie of fixations.
cMosaic.window;

%% Change some of the variables

cMosaic.macular.density = 0.0;   % Smokers
cMosaic.compute(oi);
cMosaic.window;
cMosaic.plot('hline absorptions lms','xy',[25,25]);   % Circle not coming up on cone mosaic screen

cMosaic.macular.density = 0.35;   % Non-smokers
cMosaic.compute(oi);
cMosaic.window;
cMosaic.plot('hline absorptions lms','xy',[25,25]);


