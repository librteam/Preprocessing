function [ preprocessedEpochs ] = preprocessSubject( data )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

epochs=DecomposeData(data,40000);
count=0;
preprocessedEpochs=struct;
samplingRate=1000;
interpolatedChannPerEpoch=zeros(length(epochs),1);
stdCoef = 5; rejectionPercentage = 15;
e=false;
neighbours=FindNeighbours256(3);
while(e==false && stdCoef<=7)
    for i=1:length(epochs)
        currentEpoch=epochs(i).Epoch;
        [preprocessedEpoch,nbIntChann]=preprocessEpoch(currentEpoch,samplingRate,neighbours,stdCoef);
        interpolatedChannPerEpoch(i)=nbIntChann;
        nbElectrodes=size(preprocessedEpoch,1);
        maxRejectedElectrodes = (nbElectrodes * rejectionPercentage) / 100;
        if (nbIntChann <= maxRejectedElectrodes)
            count=count+1;
            preprocessedEpochs(count).Epoch=preprocessedEpoch;
            preprocessedEpochs(count).nbInterpolatedChannels=nbIntChann;
        end
    end
    if(count>=3)
        e=true;
    else
        stdCoef=stdCoef+1;
    end
end

end

