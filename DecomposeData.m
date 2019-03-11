function [ epochs ] = DecomposeData( data , timeWindow)
%UNTITLED8 Summary of this function goes here
%Detailed explanation goes here
numberOfEpochs=floor(size(data,2)/timeWindow);
epochs=struct;
for i=2:numberOfEpochs
    epoch=data(:,((i-1)*timeWindow)+1:i*timeWindow);
    epochs(i-1).Epoch= epoch;
end

end

