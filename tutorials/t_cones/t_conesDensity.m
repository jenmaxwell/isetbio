%%t_conesDensity  Show how human cone density varies across the retina
%
% Description:
%     Plot the log10 cone density across the retinal surface.
%
%     The plot shows different angles and up to an eccentricity of 10 mm, which
%     is about +/-30 deg.

% BW, ISETBIO Team, 2017
%
% 09/05/17  dhb  Clean up.

%% Initialize
ieInit;

%% Set range
pos = 0:(1e-4):10e-3;       % Eccentricity in meters
ang = (0:.02:1.02)*2*pi;    % Angle around all 360 deg (plus a little)

%% Fill up a matrix with cone density
coneDensity = zeros(length(pos),length(ang));
for jj=1:length(ang)
    for ii = 1:length(pos)
        coneDensity(ii,jj) = coneDensityReadData('eccentricity',pos(ii),...
            'angle',ang(jj),...
            'whichEye','left');
    end
end

%% You could plot the individual lines
% vcNewGraphWin;
% semilogx(pos*1e3*(1/3),coneDensity)
% xlabel('Position (deg)')
% ylabel('Density');
% grid on

%% But the surface plot looks snazzy
[A,T] = meshgrid(ang,pos);
[X,Y] = pol2cart(A,T);
surf(X*1e3,Y*1e3,log10(coneDensity))
colormap(hsv)
xlabel('Position (mm)')
ylabel('Position (mm)')
zlabel('log_{10} Cones / mm^2 ')

%%
