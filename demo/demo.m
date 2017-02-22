close all
clear all

clc

rng('default');

run('setup.m');


%% Create a set of vertices (4 clusters)
numPts=500;
pts=[randn(numPts,2) ; randn(numPts,2)+[20,20] ; randn(numPts,2)+[0,20] ; randn(numPts,2)+[20,0]];

%% Create the edge-weighted graph (affinity matrix)
D=pdist(pts); %all the pairwise distances
sigma=var(D); %an heuristic to tune sigma
A=squareform(exp(-D./(10*sigma))); %compute the affinity matrix of the graph as a Gaussian Kernel

A=A.*not(eye(size(A))); %no self-loop, set the diagonal to zero IMPORTANT !

%% Plot the clusters obtained by the different dynamical systems with default parameters.
figure;
subplot(2,2,1);
scatter(pts(:,1),pts(:,2),5);
title('Data Points');

subplot(2,2,2);
fprintf('Extracting clusters with Replicator Dynamics...');
tt=tic();
[C]=dominantset(A,[],[],[],[],0);
tt=toc(tt);
fprintf(['done ! (' num2str(tt) ' sec)\n']);
gscatter(pts(:,1),pts(:,2),C);
title(['Replicator Dynamics (#' num2str(numel(unique(C))) ' DS)']);

subplot(2,2,4);
fprintf('Extracting clusters with Exponential Replicator Dynamics...');
kappa=10;
tt=tic();
[C]=dominantset(A,[],[],[],[],2,kappa);
tt=toc(tt);
fprintf(['done ! (' num2str(tt) ' sec)\n']);
gscatter(pts(:,1),pts(:,2),C);
title(['Exponential Replicator Dynamics (#' num2str(numel(unique(C))) ' DS)']);

subplot(2,2,3);
fprintf('Extracting clusters with Infection-Immunization...');
tt=tic();
[C,stat]=dominantset(A,[],[],[],[],1);
tt=toc(tt);
fprintf(['done ! (' num2str(tt) ' sec)\n']);
gscatter(pts(:,1),pts(:,2),C);
title(['Infection Immunization (#' num2str(numel(unique(C))) ' DS)']);
