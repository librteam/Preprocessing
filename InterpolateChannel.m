function [ interpolatedChannel ] = InterpolateChannel( epoch , IndexOfNeighbours )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


subEpoch=zeros(length(IndexOfNeighbours),size(epoch,2));

for i=1:length(IndexOfNeighbours)
    subEpoch(i,:)=epoch(IndexOfNeighbours(i),:);
end
interpolatedChannel=mean(subEpoch(find(~all(subEpoch==0,2)),:));%mean(subEpoch);
end