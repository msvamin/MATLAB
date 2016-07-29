
function o = chooseSensors(o)

% Finding with-magnet and no-magnet sensors
WMsensors=find(o.chip.NB==0);
NMsensors=find(o.chip.NB);
NumberOfSensors = 10;

% Choosing sample sensors
chooseWMsensors = randsample(WMsensors,NumberOfSensors);
chooseNMsensors = randsample(NMsensors,NumberOfSensors);

withMagnet = single(o.MI(chooseWMsensors,:));
noMagnet = single(o.MI(chooseNMsensors,:));

% Calculating the average signals
averageWM = mean(single(o.MI(WMsensors,:)),1);
averageNM = mean(single(o.MI(NMsensors,:)),1);

o.SampleSensors.withMagnet = withMagnet;
o.SampleSensors.noMagnet = noMagnet;
o.AverageSignal.withMagnet = averageWM;
o.AverageSignal.noMagnet = averageNM;

end