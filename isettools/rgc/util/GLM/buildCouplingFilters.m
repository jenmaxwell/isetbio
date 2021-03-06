function [couplingFilters, weightMatrix] = buildCouplingFilters(obj, dt)
% builds the coupling filters for the rgcMosaicGLM object.
% 
% Inputs: rgcMosaicGLM object, dt for bin fraction of stimulus time step
% (usually 0.01 or less).
% 
% Outputs: the couplingFilters as a cell array, where each cell is itself an
% array of time series filters. If the mosaic is 3x3, then each coupling
% filter cell will be 3x3xlength(time series).
% 
% Example:
%     [obj.couplingFilter, obj.couplingMatrix] = buildCouplingFilters(obj, .01);
% 
%%%% Written by J. Pillow

% DTsim = .01; % Bin size for simulating model & computing likelihood (in units of stimulus frames)
nkt = 20;    % Number of time bins in filter;

% dt = .01
% --- Make basis for post-spike (h) current ------
ihbasprs.ncols = 5;  % Number of basis vectors for post-spike kernel
ihbasprs.hpeaks = [.1 2];  % Peak location for first and last vectors
ihbasprs.b = .5;  % How nonlinear to make spacings
ihbasprs.absref = .1; % absolute refractory period 
[iht,ihbas,ihbasis] = makeBasis_PostSpike(ihbasprs,dt);
psf = ihbasis*[-10 -5 0 2 -2]';  % h current

% psf = mosaicGet(obj, 'postSpikeFilter');

% Make some coupling kernels
ihbasprs.ncols = 5;  % Number of basis vectors for post-spike kernel
ihbasprs.hpeaks = [.1 2];  % Peak location for first and last vectors
ihbasprs.b = .5;  % How nonlinear to make spacings
ihbasprs.absref = .1; % absolute refractory period 

[iht,ihbas,ihbasis] = makeBasis_PostSpike(ihbasprs,dt);
hhcpl = ihbasis*[.6;.47;.25;0;0]*2;
hhcpl(:,2) = ihbasis*[-1;-1;0;0;.25]*2;
% ih(:,2,1) = hhcpl(:,2); % 2nd cell coupling to first
% ih(:,1,2) = hhcpl(:,1); % 1st cell coupling to second
ihind = 2;



%%%%

nCells = size(obj.cellLocation);

otherCenterLocations = vertcat(obj.cellLocation{:});

for xcell = 1:nCells(1)
    for ycell = 1:nCells(2)
        otherCenterIndX(xcell,ycell) = xcell;
        otherCenterIndY(xcell,ycell) = ycell;
    end
end

% for mosaic = 1:5
for xcell = 1:nCells(1)
    for ycell = 1:nCells(2)
        
        cellCenterLocation = obj.cellLocation{xcell,ycell};
        
        weightMatrixT = reshape(exp(-(2./(1*obj.rfDiameter))*(sum((bsxfun(@minus, cellCenterLocation, otherCenterLocations)).^2,2).^(1/2))),nCells(1),nCells(2));
       
        distMatrixX = reshape((bsxfun(@minus, xcell, otherCenterIndX)),nCells(1),nCells(2));
        distMatrixY = reshape((bsxfun(@minus, ycell, otherCenterIndY)),nCells(1),nCells(2));
        distMatrix = sqrt(distMatrixX.^2+distMatrixY.^2);
        
        weightMatrixT(weightMatrixT==1) = 0; 
        weightMatrixT(weightMatrixT<0.1) = 0;
        
%         weightMatrixT(distMatrix>sqrt(2)) = 0;
        
        
        % weightMatrix{xcell,ycell,mosaic} = weightMatrixT;
        weightMatrix{xcell,ycell} = weightMatrixT;
                
        % couplingFilters{xcell,ycell,mosaic} = reshape(hhcpl(:,1)*weightMatrix(:)',nCells(1),nCells(2),length(hhcpl(:,1)));
        couplingFilters{xcell,ycell} = reshape((hhcpl(:,ihind)*weightMatrixT(:)')',nCells(1),nCells(2),length(hhcpl(:,1)));

        couplingFilters{xcell,ycell}(xcell, ycell, :) = psf; % set cell's own coupling filter to PSF
        
    end
end
% end

% obj = mosaicSet(obj,'couplingFilter', couplingFilters);
% obj = mosaicSet(obj,'couplingMatrix', weightMatrix);