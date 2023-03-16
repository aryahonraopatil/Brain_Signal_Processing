%% Main 2016/11/14 by T. Ezaki
%% This program estimates a maximum entropy distribution
%% using the maximum-likelihood method.
threshold =0.0; %for binarization, above (below) which ROI activity is defined to be +1 (-1).
Name = [];
% import data: nodeMax x time points
originalData= importdata('testdata.dat');
%%binarize
binarizedData = pfunc_01_Binarizer(originalData,threshold);
%%main part
[h,J] = pfunc_02_Inferrer_ML(binarizedData);
%%[h,J] = pfunc_02_Inferrer_PL(binarizedData);
[probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, binarizedData);
%% Calculate Energy
energy = mfunc_Energy(h,J);
% Calculate local minima
nodeNumber = length(h);
[LocalMinIndex, BasinGraph, AdjacentList]=mfunc_LocalMin(nodeNumber,energy);
% Calculate Energy Path by Djkstra:
[Cost, Path] = mfunc_DisconnectivityGraph(energy, LocalMinIndex, AdjacentList);
% Show Activity Pattern:
vectorList = mfunc_VectorList(nodeNumber);
mfunc_ActivityMap(vectorList, LocalMinIndex, Name);
disp('ended')
