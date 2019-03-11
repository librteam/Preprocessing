function [ preprocessedEpoch,nbInterpolatedChannels ] = preprocessEpoch(epoch,samplingRate,neighbours,stdCoef )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%neighbours=FindNeighbours256(3);
neighboursDistance=3;
[numChan,time]=size(epoch);
%epoch=epoch*10^6;


%filtering
FrequencyBand=[0.1 45];
filterorder=floor(0.1*samplingRate);
b1 = fir1(filterorder,[FrequencyBand(1) FrequencyBand(2)]/(samplingRate/2));
for k = 1:numChan
    epoch(k,:) = filtfilt(b1,1,double(epoch(k,:)));
end

%remove of dc offset
for i = 1:numChan
    epoch(i,:) = epoch(i,:) - (sum(epoch(i,:),1) / time);
end

%Refiltering
FrequencyBand=[0.1 45];
filterorder=floor(0.1*samplingRate);
b1 = fir1(filterorder,[FrequencyBand(1) FrequencyBand(2)]/(samplingRate/2));
for k = 1:numChan
    epoch(k,:) = filtfilt(b1,1,double(epoch(k,:)));
end




zeroVec=zeros(1,time);
badChannelsCount=0;
for nchan=1:numChan
    signal=epoch(nchan,:);
    minSig=min(signal);
    maxSig=max(signal);
    if (minSig<-100 || maxSig >100)
        epoch(nchan,:)=zeroVec;
        badChannelsCount=badChannelsCount+1;
        badChannels(badChannelsCount)=nchan;        
    end
end
averagePerTime=mean(Epoch(find(~all(Epoch==0,2)),:));
stdPerTime=std(Epoch(find(~all(Epoch==0,2)),:));
%averagePerTime=mean(epoch);
%stdPerTime=std(epoch);
thresholdMin=averagePerTime-(stdCoef*stdPerTime);
thresholdMax=averagePerTime+(stdCoef*stdPerTime);

for nchan=1:numChan
    signal=epoch(nchan,:);
    for t=1:time
        if(signal(t)<thresholdMin(t) || signal(t)>thresholdMax(t))
            epoch(nchan,:)=zeroVec;
            badChannelsCount=badChannelsCount+1;
            badChannels(badChannelsCount)=nchan; 
            break;
        end
    end
end

%  for i=1:256
%      Final(i)=entropy(epoch(i,:));
%  end
% ToInterpolate= find(Final==0);
% 
% badChannels=cat(2,badChannels,ToInterpolate);
preprocessedEpoch=epoch;
uniqueBadChannels=unique(badChannels);
nbInterpolatedChannels=length(uniqueBadChannels)
if(nbInterpolatedChannels>40)
    preprocessedEpoch=[];
    return;
end

for i=1:length(uniqueBadChannels)
    signal=InterpolateChannel(epoch,neighbours(uniqueBadChannels(i)).neighboursIndexes);
    if(signal==zeroVec)
        while(signal==zeroVec)
           neighboursDistance=neighboursDistance+1; 
           newNeighbours=FindNeighbours256(neighboursDistance);
           signal=InterpolateChannel(epoch,newNeighbours(uniqueBadChannels(i)).neighboursIndexes);
        end
        neighboursDistance=3;
    end
    preprocessedEpoch(uniqueBadChannels(i),:)=signal;
end


end

