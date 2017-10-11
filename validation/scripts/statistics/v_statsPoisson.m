%%  v_statsPoisson
%
% Test the iePoisson random number generator calls
%
% Tests using poisspdf with the stats toolbox.
%
% BW ISETBIO Team, 2015

%% 
ieInit

%% Create a small lambda set of samples and plot them

% A small number
nSamp = [50000,1];
lambda = 2;
v = iePoisson(lambda,'nSamp',nSamp);

vcNewGraphWin;
edges = 0:9;
h = histogram(v(:),edges);
P = poisspdf(edges,lambda);
hold on; plot(edges + 0.5,P*nSamp(1),'-o');


%% A slightly larger number
lambda = 8;
v = iePoisson(lambda,'nSamp',nSamp);
% fprintf('Mean %.2f and variance %.2f\n',mean(v(:)), var(v));

% vcNewGraphWin;
edges = lambda + [-lambda:lambda];
h = histogram(v(:),edges);
P = poisspdf(edges,lambda);
hold on; plot(edges + 0.5,P*nSamp(1),'-o');

%%  Now try a big lambda, which should be gaussian

lambda = 16;
v = iePoisson(lambda,'nSamp',nSamp);
fprintf('Mean %.2f and variance %.2f\n',mean(v(:)), var(v));

edges = lambda + [-lambda:lambda];
h = histogram(v(:),edges);
P = poisspdf(edges,lambda);
hold on; plot(edges + 0.5,P*nSamp(1),'-o');

ylabel('Number of samples');
xlabel('Sample value')

%% END
