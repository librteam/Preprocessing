function [preprocessedEpochs]=CleanRawDataRestingState(filename)
%% Input: filename: raw data file name
%  Output: preprocessedEpochs: struct of clean epochs
%
%%
EEG = pop_readegi( filename );
preprocessedEpochs=preprocessSubject(EEG.data(1:256,:));
end