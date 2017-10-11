%%t_conesCustomMosaic  Show how to customize various mosaic parameters
%
% Description:
%
%
% BW:  The cone mosaic visualization routine is not performing
% correctly in the window.  We need the size of the cones to be larger
% at this eccentricity.

%% Jon's desired coordinates
eccentricityDeg = 6;
angle = 90;

%% Convert to x,y position in meters
eccentricityM = 1e-3*0.3*eccentricityDeg;
eccentricityXM = cosd(angle)*eccentricityM;
eccentricityYM = sind(angle)*eccentricityM;

%% Create coneMosaic using 'Song2011Young' density data
%
% The pigment width/height and pdWidth/pdHeight should vary with data source
cm = coneMosaic('center',[eccentricityXM eccentricityYM],'coneDensitySource','Song2011Young');
cm.pigment
cm.window;

%% So instead try the old subject data to find out
cm = coneMosaic('center',[eccentricityXM eccentricityYM],'coneDensitySource','Song2011Old');
cm.pigment
cm.window;

%% Make sure passing units parameter doesn't screw things up for now.
%
% Eventually we should respect all of the parameters handled by coneDensityReadData, but for right now
% center must be passed in meters.  We'll fix this when we update cone mosaic to use eccentricity and angle.
cm = coneMosaic('center',[eccentricityXM eccentricityYM],'coneDensitySource','Song2011Old','eccentricityUnits','mm');
cm.pigment
cm.window;

%%