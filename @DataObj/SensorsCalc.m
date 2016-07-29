function o = SensorsCalc(o)

    % Picking Random Sensors
    % Created by Amin 3/9/2016
    
    % Number of sample sensors extracted from config file
    numSS = o.Config.SensorReads.numRandSen;
    
    % Finding the indexes for no-magnet and with-magnet sensors
    idNMall = find(o.chip.NB);
    idWMall = find(~o.chip.NB);
    
    % Sampling the sensors
    NoMagnetSenIdx = datasample(idNMall,numSS);
    WithMagnetSenIdx = datasample(idWMall,numSS);
    NoMagnetReads = o.MI(NoMagnetSenIdx,:);
    WithMagnetReads = o.MI(WithMagnetSenIdx,:);
    
    % Calculating the mean and median
    NMmean = mean(NoMagnetReads,1);
    WMmean = mean(WithMagnetReads,1);
    NMmed = median(NoMagnetReads,1);
    WMmed = median(WithMagnetReads,1);
   
    
    % Saving the result as a field
    o.SampleSensors.numSampleSen = numSS;
    
    o.SampleSensors.NoMagnet.Indexes = NoMagnetSenIdx;
    o.SampleSensors.NoMagnet.Reads = NoMagnetReads;
    o.SampleSensors.NoMagnet.Mean = NMmean;
    o.SampleSensors.NoMagnet.Median = NMmed;
    
    o.SampleSensors.WithMagnet.Indexes = WithMagnetSenIdx;
    o.SampleSensors.WithMagnet.Reads = WithMagnetReads;
    o.SampleSensors.WithMagnet.Mean = WMmean;
    o.SampleSensors.WithMagnet.Median = WMmed;
    
    %delete the big data
    %o.M = [];
    %o.MI = [];
    %o.MQ = [];
    
end
