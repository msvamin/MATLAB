function o = DataDigest(o, params)


% Metadata Alignment in time
% By: Amin Mousavi    28-May-2015   Modified    30-May-2015

% Modified by: Paul SanGiorgio 8 June 2015
%
% I changed the data structure to a more formal style with names instead of
% indices so that it would be more flexible.  In order to easily keep track
% of which indicies are "data" indices (i.e. those that we might want to
% plot and/or put in the correlation matrix).  I also added Categories so
% that different types of sensors can be grouped together.
%
% Modified by PS 7 July 2015
%
% I am making some fundamental changes here so as to make it easier to deal
% with in the future.

if nargin < 2
    params = struct();
end

TSn(1) = min(o.ChipTemp.TimeStamp);
TSx(1) = max(o.ChipTemp.TimeStamp);
TSn(2) = min(o.ChipVoltage.TimeStamp);
TSx(2) = max(o.ChipVoltage.TimeStamp);
TSn(3) = min(o.SysTemp.TimeStamp);
TSx(3) = max(o.SysTemp.TimeStamp);
TSn(4) = min(o.FlowSensor.TimeStamp);
TSx(4) = max(o.FlowSensor.TimeStamp);
TSn(5) = min(o.ValveState.TimeStamp);
TSx(5) = max(o.ValveState.TimeStamp);
TSn(6) = min(o.SysPressure.TimeStamp);
TSx(6) = max(o.SysPressure.TimeStamp);
TSn(7) = min(o.SysVoltage.TimeStamp);
TSx(7) = max(o.SysVoltage.TimeStamp);
TSn(8) = min(o.ReadTimeStamp);
TSx(8) = max(o.ReadTimeStamp);
%TSn(9) = o.ScriptCommands.TimeZero;
%TSx(9) = o.ScriptCommands.TimeEndSeq;

TS0 = [max(TSn)+100 min(TSx)-100];
TS1 = floor(TS0/100)*100;
TS = TS1(1):200:TS1(2);

% add info about the run here
DataAligned.run = o.run;
DataAligned.ReadsConfig = o.ReadsConfig;

% transfering the windowing from the sensor reads to our new universal time
% stamp


% I have to do some really ugly work here because despite my best efforts,
% the windowing still doesn't work.  The very end of the run seems to be
% counted as a sequencing portion, which screws everything up horribly.  So
% I am artificially cutting out the first and last portions of the window
%
% windowIdx = transferWindowing(TS,o.ReadTimeStamp,o.windowIdx);

temp = transferWindowing(TS,o.ReadTimeStamp,o.windowIdx);
inds = find(diff(temp)>1);

if length(inds)>2
    temp((inds(end)+1):end) = [];
    temp(1:inds(1)) = [];
    windowIdx = temp;
else % only two segments, can't cut them out
    windowIdx = temp;
end

% returning to the regular program!

instWindowIdx = windowIdx(1):windowIdx(end);
DataAligned.windowIdx = windowIdx;
DataAligned.instWindowIdx = instWindowIdx;
DataAligned.TS = TS(instWindowIdx)';
DataAligned.Windowed.TS = TS(windowIdx)';
DataAligned.Raw.TS = TS';

FieldData = {{'ChipTempTarget','ChipTemp','Readout','TargetChipTemp'},...
    {'ChipTempIPTAT','ChipTemp','Readout','IPTAT'},...
    {'ChipTempRTDU','ChipTemp','Readout','RTDU'},...
    {'ChipTempRTDM','ChipTemp','Readout','RTDM'},...
    {'ChipTempRTDL','ChipTemp','Readout','RTDL'},...
    {'ChipTempTempRise','ChipTemp','Readout','TempRise'},...
    {'SysTempCuBlock','SysTemp','Readout','CuBlock'},...
    {'SysTempHeatSink','SysTemp','Readout','HeatSink'},...
    {'SysTempPreheater','SysTemp','Readout','Preheater'},...
    {'SysTempAmbient','SysTemp','Readout','Ambient'},...
    {'SysTempVref','SysTemp','Readout','Vref'},...
    {'ChipVoltageADCVref','ChipVoltage','Readout','ADCVref'},...
    {'ChipVoltageAFEVref','ChipVoltage','Readout','AFEVref'},...
    {'ChipVoltageRFVHi','ChipVoltage','Readout','RFVHi'},...
    {'ChipVoltageRFVLo','ChipVoltage','Readout','RFVLo'},...
    {'ChipVoltageRFVHiVLo','ChipVoltage','Readout','RFVHiVLo'},...
    {'ChipVoltagePPoly','ChipVoltage','Readout','PPoly'},...
    {'ChipVoltageRFVHiNB','ChipVoltage','Readout','RFVHiNB'},...
    {'ChipVoltageRFVLoNB','ChipVoltage','Readout','RFVLoNB'},...
    {'ChipVoltageRFVHiVLoNB','ChipVoltage','Readout','RFVHiVLoNB'},...
    {'Flowrate','FlowSensor','Readout'},...
    {'Flowrate2','FlowSensor','Readout2'},...
    {'Flowrate3','FlowSensor','Readout3'},...
    {'SysPressurePump','SysPressure','Readout','Pump'},...
    {'SysPressureCartridge','SysPressure','Readout','Cartridge'},...
    {'CartridgePIDEffort','ValveState','CartridgePIDEffort'},...
    {'PeltierPIDEffort','ValveState','PeltierPIDEffort'},...
    {'PreheaterPIDEffort','ValveState','PreheaterPIDEffort'},...
    {'DVDD12','SysVoltage','DVDD12'},...
    {'DVDD33','SysVoltage','DVDD33'},...
    {'AVDD33','SysVoltage','AVDD33'},...
    {'DVDD12current','SysVoltage','DVDD12current'},...
    {'DVDD33current','SysVoltage','DVDD33current'},...
    {'AVDD33current','SysVoltage','AVDD33current'}};

nf = numel(FieldData);
DataAligned.FieldList = {};

for kf = 1:nf
    fd = FieldData{kf};
    xloc = {fd{2},'TimeStamp'};
    x = getfield(o,xloc{:});
    yloc = fd(2:end);
    y = getfield(o,yloc{:});
    % Added by Amin to keep two vectors have the same size
    [MM, II] = min([size(x,1), size(y,1)]);
    if(II==1)
        y = y(1:MM);
    else
        x = x(1:MM);
    end
    DataAligned = assignData(DataAligned,x,y,fd);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sensor Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sensor data needs to be handled a little bit specially as we need to
% generate the PC that will be used

DataSamples = randsample(size(o.MI,1),1000);
Msamples = single(o.MI(DataSamples,o.windowIdx(1):o.windowIdx(end))');
Msamples_win = single(o.MI(DataSamples,o.windowIdx)');
Msamples_raw = single(o.MI(DataSamples,:)');
[~, Scores, ~] = pca(Msamples);
[~, Scores_win, ~] = pca(Msamples_win);
[~, Scores_raw, ~] = pca(Msamples_raw);

x = {o.ReadTimeStamp(o.windowIdx(1):o.windowIdx(end)),o.ReadTimeStamp(o.windowIdx),o.ReadTimeStamp};
y = {Scores(:,1),Scores_win(:,1),Scores_raw(:,1)};

fd = {'IFirstPC','SensorReads'};
DataAligned = assignData(DataAligned,x,y,fd);

% look for Q data if it exists
if size(o.MQ,1)~=0
    Msamples = single(o.MQ(DataSamples,o.windowIdx(1):o.windowIdx(end))');
    Msamples_win = single(o.MQ(DataSamples,o.windowIdx)');
    Msamples_raw = single(o.MQ(DataSamples,:)');
    [~, Scores, ~] = pca(Msamples);
    [~, Scores_win, ~] = pca(Msamples_win);
    [~, Scores_raw, ~] = pca(Msamples_raw);
    
    x = {o.ReadTimeStamp(o.windowIdx(1):o.windowIdx(end)),o.ReadTimeStamp(o.windowIdx),o.ReadTimeStamp};
    y = {Scores(:,1),Scores_win(:,1),Scores_raw(:,1)};

    fd = {'QFirstPC','SensorReads'};
    DataAligned = assignData(DataAligned,x,y,fd);
end

% generate the correlation matrix here

nfields = numel(DataAligned.FieldList);
dmat = [];
dmat_win = [];
dmat_raw = [];

% here I am normalizing and centering all of the data.  Without this step,
% there are rounding errors due to the data being of varying magnitude.

for ni = 1:nfields
    y = DataAligned.(DataAligned.FieldList{ni}).Reads;
    m = DataAligned.(DataAligned.FieldList{ni}).mean;
    s = sqrt(DataAligned.(DataAligned.FieldList{ni}).var);
    dmat = [dmat, (y-m)./s];
    y = DataAligned.Windowed.(DataAligned.FieldList{ni}).Reads;
    m = DataAligned.Windowed.(DataAligned.FieldList{ni}).mean;
    s = sqrt(DataAligned.Windowed.(DataAligned.FieldList{ni}).var);
    dmat_win = [dmat_win, (y-m)./s];
    y = DataAligned.Raw.(DataAligned.FieldList{ni}).Reads;
    m = DataAligned.Raw.(DataAligned.FieldList{ni}).mean;
    s = sqrt(DataAligned.Raw.(DataAligned.FieldList{ni}).var);
    dmat_raw = [dmat_raw, (y-m)./s];
end

CorrMat = corrcoef(dmat);
CorrMat_win = corrcoef(dmat_win);
CorrMat_raw = corrcoef(dmat_raw);

DataAligned.CorrMat = CorrMat;
DataAligned.Windowed.CorrMat = CorrMat_win;
DataAligned.Raw.CorrMat = CorrMat_raw;

% now generate the plots

% this is my custom color map that is very useful for correlation matrix
% plotting
mymap = [[ones(1,32), linspace(1,0,32)]',[linspace(0,1,32), linspace(1,0,32)]',[linspace(0,1,32), ones(1,32)]'];

o.DataAligned = DataAligned;

f1 = figure(1);
set(f1,'Position', [1    1   1000    1000])

% adding an extra row/column for the benefit of pcolor, which otherwise
% drops the last row/column from the plot.
CorrMat(end+1,end+1) = 0;
pcolor(CorrMat(2:end,2:end));
caxis([-1 1])
colormap(mymap);
title('Correlation Matrix')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
set(gca, 'Position',  [0.16 0.21 .8 .75]);
colorbar
for ni = 2:nfields
    txt = text(0.8,ni-0.5,DataAligned.FieldList{ni});
    txt.FontSize = 8;
    txt.HorizontalAlignment = 'right';
end
for ni = 2:nfields
    txt = text(ni-0.5,0.5,DataAligned.FieldList{ni},'rotation',-90);
    txt.FontSize = 8;
    txt.HorizontalAlignment = 'left';
end

plot_file_name = [num2str(o.run.id),'-CorrelationMatrix.fig'];
saveas(gcf,[o.Paths.save.screening, '/', plot_file_name]);
plot_file_name = [num2str(o.run.id),'-CorrelationMatrix.png'];
set(gcf,'PaperUnits','inches','PaperSize',[25,20],'PaperPosition',[0 0 25 20])
print('-dpng','-r100',[o.Paths.save.screening, '/', plot_file_name])
close(f1);

f2 = figure(2);
set(f2,'Position', [1    1   1000    1000])
CorrMat_win(end+1,end+1) = 0;
pcolor(CorrMat_win(2:end,2:end))
caxis([-1 1])
colormap(mymap);
title('Windowed Data Correlation Matrix')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
set(gca, 'Position',  [0.16 0.21 .8 .75]);
colorbar
for ni = 2:nfields
    txt = text(0.8,ni-0.5,DataAligned.FieldList{ni});
    txt.FontSize = 8;
    txt.HorizontalAlignment = 'right';
end
for ni = 2:nfields
    txt = text(ni-0.5,0.5,DataAligned.FieldList{ni},'rotation',-90);
    txt.FontSize = 8;
    txt.HorizontalAlignment = 'left';
end

plot_file_name = [num2str(o.run.id),'-WindowedCorrelationMatrix.fig'];
saveas(gcf,[o.Paths.save.screening, '/', plot_file_name]);
plot_file_name = [num2str(o.run.id),'-WindowedCorrelationMatrix.png'];
set(gcf,'PaperUnits','inches','PaperSize',[25,20],'PaperPosition',[0 0 25 20])
print('-dpng','-r100',[o.Paths.save.screening, '/', plot_file_name])
close(f2);

Data1 = fullfile(o.Paths.save.screening, [o.run.id, '-DataAligned.mat']);
Data2 = fullfile('/NAS', 'PipelineReports','CorrelationData',[o.run.id, '-DataAligned.mat']);
save(Data1, 'DataAligned')
copyfile(Data1, Data2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% nested sub functions
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function DataAligned = assignData(DataAligned,x,y,fd)
        if ~iscell(x)
            RR = interp1(x,y,TS);
            DataAligned.FieldList{end+1} = fd{1};
            DataAligned.(fd{1}).Category = getCategory(fd{2});
            DataAligned.(fd{1}).Reads = RR(instWindowIdx)';
            DataAligned.(fd{1}).mean = mean(RR(instWindowIdx)); % this is reported to inst reports
            DataAligned.(fd{1}).var = var(RR(instWindowIdx));
            DataAligned.Windowed.(fd{1}).Reads = RR(windowIdx)';
            DataAligned.Windowed.(fd{1}).mean = mean(RR(windowIdx));
            DataAligned.Windowed.(fd{1}).var = var(RR(windowIdx));
            DataAligned.Raw.(fd{1}).Reads = RR';
            DataAligned.Raw.(fd{1}).mean = mean(RR);
            DataAligned.Raw.(fd{1}).var = var(RR);
        else % this is to deal with the sensor data
            DataAligned.FieldList{end+1} = fd{1};
            DataAligned.(fd{1}).Category = getCategory(fd{2});
            for k = 1:3
                xk = x{k};
                yk = y{k};
                RR = interp1(xk,yk,TS);
                switch k
                    case 1
                        DataAligned.(fd{1}).Reads = RR(instWindowIdx)';
                        DataAligned.(fd{1}).mean = mean(RR(instWindowIdx)); % this is reported to inst reports
                        DataAligned.(fd{1}).var = var(RR(instWindowIdx));
                    case 2
                        DataAligned.Windowed.(fd{1}).Reads = RR(windowIdx)';
                        DataAligned.Windowed.(fd{1}).mean = mean(RR(windowIdx));
                        DataAligned.Windowed.(fd{1}).var = var(RR(windowIdx));
                    case 3
                        DataAligned.Raw.(fd{1}).Reads = RR';
                        DataAligned.Raw.(fd{1}).mean = mean(RR);
                        DataAligned.Raw.(fd{1}).var = var(RR);
                end
            end
        end
    end

    function cat = getCategory(str)
        switch str
            case 'ChipTemp'
                cat = 'Chip Temperatures';
                return
            case 'SysTemp'
                cat = 'System Temperatures';
                return
            case 'ChipVoltage'
                cat = 'Chip Voltages';
                return
            case {'FlowSensor','ValveState'}
                cat = 'Fluidics';
                return
            case 'SysPressure'
                cat = 'Fluidics';
                return
            case 'SysVoltage'
                cat = 'System Voltages';
                return
            case 'SensorReads'
                cat = 'Sensor Reads';
                return
            otherwise
                cat = 'Unknown';
                return
        end
    end
end