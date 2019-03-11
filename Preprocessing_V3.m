function [Congruant,InCongruant]= Preprocessing_V3(data,events,TimeStart)

%% GetPulseTime
PulseD=data(260,:); %% Droite
PulseG=data(261,:); %% Gauche
Pulse=PulseD + PulseG;

[V]=find(abs(diff((Pulse)) < -0.001)); %% Trouver les pulses
[PulseTime]= GetPulseTime(PulseG,PulseD,TimeStart)*1000; % *1000 from second to millisecond

%% GetDinTime
[DinTime,~,DinNameSorted]=GetAllDin(events);
DinTime=DinTime*1000; % *1000 from second to millisecond
NextDinTime=DinTime(1);
index=1;
num_din=0;
din2_index=0;
din3_index=0;
din4_index=0;
din5_index=0;
EPOCHS_DIN2=[];
EPOCHS_DIN3=[];
EPOCHS_DIN4=[];
EPOCHS_DIN5=[];
chanindex= [1 2	3 4	5 6 7 8	10 11 12 13	14 15 16 17	18 19 20 21	22 23 24 25	26 27 28 29	32 33 34 35	36 37 38 39	40 41 42 43	44 45 46 47	48 49 50 51	52 53 54 55 56 57 58 59	60 61 62 63	64 65 66 67	68 69 70 71 75 76 77 78 79 80 81 83 85 87 88 89 90 93 94 95 96 97 98 99 100 101 104 105 106 107 109 110 113	114	115 117	119	122	124	125	126	128	129	130	131	132	135	136	137	138	139	140	141	142	143	144	147	148	149	152	153	154	155	157	159	160	161	163	164	167	168	169	170	171	172	176	177	178	180	181	182	183	184	185	189	190	191	193	194	195	196	197	198	201	202	203	204	205	206	207	210	211	212	213	214	219	220	221	222	223	224	225	226	252	253]; 
%chanindex=[1:256];
%% Calcul reaction Time
for i=1:178%size(DinTime,2)
        i
    if(i<size(DinTime,2))
        NextDinTime=DinTime(i+1);
    end    
%%
        RT1= PulseTime(index)-DinTime(i);
        while(RT1<0)
            index=index+1;
            RT1= PulseTime(index)-DinTime(i);
        end
%%
        [ResponseG]=GetResponseGauche(PulseG,V,index);
        [ResponseD]=GetResponseDroite(PulseD,V,index);
%%
        if(PulseTime(index)> NextDinTime && i~=size(DinTime,2))
            RT1 =-1;        
        end
%%
    switch DinNameSorted{i}
        
        case 'DIN2' %%% Gauche
        num_din=num_din+1;
        if ResponseG==1
        epoch=data(chanindex,floor(DinTime(num_din))-200:floor((DinTime(num_din)+13000)));
        [EpochFiltred,nbInterpolatedChannels]=Cleaning(epoch, 1000,4);
        %[EpochFiltred] = filterData(EpochFiltred(:,1:1000),1000,0.1,45);
        [EpochFiltred] = bst_bandpass_hfilter(EpochFiltred(:,1:1000),1000,0.1,45);
           if nbInterpolatedChannels<=20 && max(max(EpochFiltred))<60 && min(min(EpochFiltred))>-60
                din2_index=din2_index+1;
                EPOCHS_DIN2(din2_index,:,:)=EpochFiltred; %preprocessedEpoch;
           end
        end
        
        case 'DIN3' %%% Droite
        num_din=num_din+1;
        if ResponseD==1
        epoch=data(chanindex,floor(DinTime(num_din))-200:floor((DinTime(num_din)+13000)));
        [EpochFiltred,nbInterpolatedChannels]=Cleaning(epoch, 1000,4);
        [EpochFiltred] = bst_bandpass_hfilter(EpochFiltred(:,1:1000),1000,0.1,45);
            if nbInterpolatedChannels<=20 && max(max(EpochFiltred))<60 && min(min(EpochFiltred))>-60
               din3_index=din3_index+1;
               EPOCHS_DIN3(din3_index,:,:)=EpochFiltred; %preprocessedEpoch;
            end
        end
        
        case 'DIN4' %%% Gauche
        num_din=num_din+1;
        if ResponseG==1
        epoch=data(chanindex,floor(DinTime(num_din))-200:floor((DinTime(num_din)+13000)));
        [EpochFiltred,nbInterpolatedChannels]=Cleaning(epoch, 1000,4);
        [EpochFiltred] = bst_bandpass_hfilter(EpochFiltred(:,1:1000),1000,0.1,45);
            if nbInterpolatedChannels<=20 && max(max(EpochFiltred))<60 && min(min(EpochFiltred))>-60
                din4_index=din4_index+1;
                EPOCHS_DIN4(din4_index,:,:)=EpochFiltred; %preprocessedEpoch;
            end
        end
        
        case 'DIN5' %%% Droite
        num_din=num_din+1;
        if ResponseD==1
        epoch=data(chanindex,floor(DinTime(num_din))-200:floor((DinTime(num_din)+13000)));
        [EpochFiltred,nbInterpolatedChannels]=Cleaning(epoch, 1000,4);
        [EpochFiltred] = bst_bandpass_hfilter(EpochFiltred(:,1:1000),1000,0.1,45);
            if nbInterpolatedChannels<=20 && max(max(EpochFiltred))<60 && min(min(EpochFiltred))>-60
                din5_index=din5_index+1;
                EPOCHS_DIN5(din5_index,:,:)=EpochFiltred; %preprocessedEpoch;
            end
        end
   end
    
end
clear ResponseG ResponseD RT1
Congruant=permute(cat(1,EPOCHS_DIN2,EPOCHS_DIN5),[2 3 1]);
InCongruant=permute(cat(1,EPOCHS_DIN3,EPOCHS_DIN4),[2 3 1]);
end
%%
function [Value]= GetPulseTime(PulseG,PulseD,TimeStart)
         Pulse=PulseD + PulseG;
         [Value]=find(abs(diff((Pulse)) < -0.001)); %% Trouver les pulses
         Value=TimeStart+(Value*0.001); %%% Temps des pulses en sec.
end
%%
function [TimeSorted,isort,DinNameSorted]=GetAllDin(events)

k=1;
for i=1:size(events,2)
    if(strcmp(events(1,i).label,'DIN2') || strcmp(events(1,i).label,'DIN3')|| strcmp(events(1,i).label,'DIN4')|| strcmp(events(1,i).label,'DIN5'))
        for j=1:size(events(1,i).times,2)
             EventsTimes(k)=events(1,i).times(1,j);
             DinName{k}=events(1,i).label;
             k=k+1;
        end
    end
end

[values,isort]=sort(EventsTimes);%% Sort Events time
previousTime=0;
k=0;
for i=1:size(isort,2)
  if(values(i)~=previousTime)
      k=k+1;
      previousTime=values(i);
      DinNameSorted{k}=DinName{isort(i)};%% DIN name after sorting
      TimeSorted(k)=values(i);
  end
end
end
%%
function [Response]=GetResponseGauche(PulseG,V,index)

  X=PulseG(V(index)+1); %%% Reponse sur le Pulse gauche.. correct if X is a peak
        if X<-0.001
            Response=1;
        else
            Response=0;
        end

end
%%
function [Response]=GetResponseDroite(PulseD,V,index)

  X=PulseD(V(index)+1); %%% Reponse sur le Pulse droite.. correct if X is a peak
        if X<-0.001
            Response=1;
        else
            Response=0;
        end

end
%%
function [ChanToInterpolate]=Variance(data)
   
   [nchan,~]=size(data);
     for i=1:nchan
         V(i)=var(data(i,:));
     end
   Vmean=mean(V);
   ChanToInterpolate=find(V>3*Vmean);
   
end
%%
function [dataF]=filterData(data,samplingRate,lowpass,highpass)

FrequencyBand=[lowpass highpass];
 filterorder=floor(0.01*samplingRate);
 [b1, a1] = fir1(filterorder,[FrequencyBand(1) FrequencyBand(2)]/(samplingRate/2),'bandpass');
   for k = 1:179
       dataF(k,:) = filtfilt(b1,a1,double(data(k,:)));
   end

end
%%
function [preprocessedEpoch,nbInterpolatedChannels]=Cleaning(EpochRaw, samplingRate,stdCoef)

neighboursDistance=3;
neighbours=FindNeighbours179(3);
%% Filtring
[dataF] = bst_bandpass_hfilter(EpochRaw,samplingRate,0.1,45);
%[dataF] = eegfilt(EpochRaw,samplingRate,0.1,45,0,1000);
%[dataF]=filterData(EpochRaw,samplingRate,0.1,45);
%dataF=dataF(:,1:1000);
Epoch=dataF(:,1:1000)*10^6;
EpochRaw=Epoch;
[numChan,time]=size(Epoch);
zeroVec=zeros(1,time);
badChannelsCount=0;
for nchan=1:numChan
    signal=Epoch(nchan,:);
    minSig=min(signal);
    maxSig=max(signal);
    if (minSig<-100 || maxSig >100)
        Epoch(nchan,:)=zeroVec;
        badChannelsCount=badChannelsCount+1;
        badChannels(badChannelsCount)=nchan;        
    end
end

averagePerTime=mean(Epoch(find(~all(Epoch==0,2)),:));%mean(Epoch);
stdPerTime=std(Epoch(find(~all(Epoch==0,2)),:));%std(Epoch);
thresholdMin=averagePerTime-(stdCoef*stdPerTime);
thresholdMax=averagePerTime+(stdCoef*stdPerTime);

for nchan=1:numChan
    signal=Epoch(nchan,:);
    for t=1:time
        if(signal(t)<thresholdMin(t) || signal(t)>thresholdMax(t))
            Epoch(nchan,:)=zeroVec;
            badChannelsCount=badChannelsCount+1;
            badChannels(badChannelsCount)=nchan; 
            break;
        end
    end
end
%[ChanToInterpolate]=Variance(Epoch);
preprocessedEpoch=Epoch;
%badChannels=cat(2,badChannels,ChanToInterpolate);
uniqueBadChannels=unique(badChannels);
nbInterpolatedChannels=length(uniqueBadChannels)
if nbInterpolatedChannels> 25
    nbInterpolatedChannels=26;
    preprocessedEpoch=EpochRaw;
else
for i=1:length(uniqueBadChannels)
    signal=InterpolateChannel(Epoch,neighbours(uniqueBadChannels(i)).neighboursIndexes);
    if(signal==zeroVec)
        while(signal==zeroVec)
           neighboursDistance=neighboursDistance+1; 
           newNeighbours=FindNeighbours179(neighboursDistance);
           signal=InterpolateChannel(Epoch,newNeighbours(uniqueBadChannels(i)).neighboursIndexes);
        end
        neighboursDistance=3;
    end
    preprocessedEpoch(uniqueBadChannels(i),:)=signal;
end
end

end