function [ neighbours ] = FindNeighbours256( distance )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
filename='coord256.xlsx';
[num,chan,~]= xlsread(filename);
numa=num(:,1);
chanpos(:,1)=str2double(chan(:,1));
chanpos(:,2)=str2double(chan(:,2));
chanpos(:,3)=str2double(chan(:,3));
Label=chan(:,4);
nsensors = length(Label);

dist = zeros(nsensors,nsensors);
for i=1:nsensors
  dist(i,:) = sqrt(abs(sum((chanpos(1:nsensors,:) - repmat(chanpos(i,:), nsensors, 1)).^2,2)))';
end;

channeighbstructmat = (dist<distance);

% electrode istelf is not a neighbour
channeighbstructmat = (channeighbstructmat .* ~eye(nsensors));
neighbours=struct;
for i=1:nsensors
  neighbours(i).neighboursIndexes = numa(find(channeighbstructmat(i,:)));
end

end

