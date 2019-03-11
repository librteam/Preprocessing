function [preprocessedEpochs]=CleanMatDataRestingState(data)
%%
% Input: data.mat
% Output: preprocessedEpochs: struct of clean epochs
%%
preprocessedEpochs=preprocessSubject(data(1:256,:));
end