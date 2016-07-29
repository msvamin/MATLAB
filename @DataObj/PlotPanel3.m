
function o = PlotPanel3(o)

% Plotting of Panels
% Extracted from PanelPlotting
% Amin Mousavi 10/26/2015
% Modified by Amin 4/13/2016

run = o.run;
%%
fignum = 1;
Xposition = 0.06;
%% Load data

TimeZeroMins = o.ScriptCommands.TimeZero/60000;
EndReadTimeMins = o.ScriptCommands.TimeStamp(end)/60000;

%Voltages
idx = (o.ChipVoltage.TimeStamp>0)&(o.ChipVoltage.TimeStamp<o.ReadTimeStamp(end));
ADCVref = o.ChipVoltage.Readout.ADCVref(idx);
AFEVref = o.ChipVoltage.Readout.AFEVref(idx);
RFVHi = o.ChipVoltage.Readout.RFVHi(idx);
RFVLo = o.ChipVoltage.Readout.RFVLo(idx);
RFswing = (RFVHi-RFVLo)/2;
RFavg = (RFVHi-RFVLo)/2;
RFVHiNB = o.ChipVoltage.Readout.RFVHiNB(idx);
RFVLoNB = o.ChipVoltage.Readout.RFVLoNB(idx);
PPoly = o.ChipVoltage.Readout.PPoly(idx);
ChipVoltTime_Adj = o.ChipVoltage.TimeStamp(idx);
ChipVoltTimeMins = ChipVoltTime_Adj/60000;

ADCVrefOff = ADCVref-mean(ADCVref); 
AFEVrefOff = AFEVref-mean(AFEVref);
RFswingOff = RFswing-mean(RFswing); 
RFavgOff = RFavg-mean(RFavg);

%System voltage

idx = (o.SysVoltage.TimeStamp>0)&(o.SysVoltage.TimeStamp<o.ReadTimeStamp(end));
SysVoltages = o.SysVoltage.Readout(idx,:);
DVDD12 = SysVoltages(:,1);   
DVDD12off = DVDD12-mean(DVDD12);
DVDD12_current = (SysVoltages(:,4)-SysVoltages(:,5))/0.1*1000;
DVDD12_currentoff = DVDD12_current-mean(DVDD12_current);

DVDD33 = SysVoltages(:,2);   
DVDD33off = DVDD33-mean(DVDD33);
DVDD33_current = (SysVoltages(:,4)-SysVoltages(:,6))/0.1*1000;
DVDD33_currentoff = DVDD33_current-mean(DVDD33_current);

AVDD33 = SysVoltages(:,3);   
AVDD33off = AVDD33-mean(AVDD33);
AVDD33_current = (SysVoltages(:,4)-SysVoltages(:,7))/0.1*1000;
AVDD33_currentoff = AVDD33_current-mean(AVDD33_current);

SysVoltTime_Adj = o.SysVoltage.TimeStamp(idx);
SysVoltTimeMins = SysVoltTime_Adj/60000;

%Raw data

ReadTime_Adj = o.ReadTimeStamp;
ReadTimeMins = ReadTime_Adj/60000;
    
%%
h = figure(fignum);
set(h,'Color','w')
set(h,'Position',[1    1   1500  1025]);

% Chip voltages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh1 = subplot(4,1,1);
grid on
hold on
set(hh1,'box','on')

plot(ChipVoltTimeMins,ADCVrefOff,'r')
plot(ChipVoltTimeMins,AFEVrefOff,'color',[0 .3 0])
plot(ChipVoltTimeMins,RFswingOff,'b')
plot(ChipVoltTimeMins,RFavgOff,'k')
xlim([0 EndReadTimeMins])

title(sprintf('%s\n Chip Voltages, System Voltages and Currents on Instrumentation Window', run.id), 'interpreter', 'none')

ylabel(sprintf('Chip Voltages'))
set(hh1,'Position',  [Xposition      0.79    0.7750    0.15])

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.3 ,['ADCVref:',num2str(mean(ADCVref),'%.2f'),'\pm',num2str(std(ADCVref),'%.2e')],'color','r','Parent',hh1, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1 ,['AFEVref:',num2str(mean(AFEVref),'%.2f'),'\pm',num2str(std(AFEVref),'%.2e')],'color',[0 .3 0],'Parent',hh1, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1 ,['RFswing:',num2str(mean(RFVHi),'%.2f'),'\pm',num2str(std(RFVHi),'%.2e')],'color','b','Parent',hh1, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.3 ,['RFaverage:',num2str(mean(RFVLo),'%.2f'),'\pm',num2str(std(RFVLo),'%.2e')],'color','k','Parent',hh1, 'interpreter', 'tex');
catch err
    disp(err.identifier)
end

%% System voltages

hh2 = subplot(4,1,2);
grid on
hold on
set(hh2,'box','on')

plot(SysVoltTimeMins,DVDD12off,'r')
plot(SysVoltTimeMins,DVDD33off,'color',[0 .3 0])
plot(SysVoltTimeMins,AVDD33off,'b')
xlim([0 EndReadTimeMins])

ylabel(sprintf('System Voltages'))
set(hh2,'Position',  [Xposition      0.61    0.7750    0.15])

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.2 ,['DVDD12:',num2str(mean(DVDD12),'%.2f'),'\pm',num2str(std(ADCVref),'%.2e')],'color','r','Parent',hh2, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2 ,['DVDD33:',num2str(mean(DVDD33),'%.2f'),'\pm',num2str(std(AFEVref),'%.2e')],'color',[0 .3 0],'Parent',hh2, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.2 ,['AVDD33:',num2str(mean(AVDD33),'%.2f'),'\pm',num2str(std(RFVHi),'%.2e')],'color','b','Parent',hh2, 'interpreter', 'tex');
catch err
    disp(err.identifier)
end

% System currents

hh3 = subplot(4,1,3);
grid on
hold on
set(hh3,'box','on')

plot(SysVoltTimeMins,DVDD12_currentoff,'r')
plot(SysVoltTimeMins,DVDD33_currentoff,'color',[0 .3 0])
plot(SysVoltTimeMins,AVDD33_currentoff,'b')
xlim([0 EndReadTimeMins])

ylabel(sprintf('System Currents'))
set(hh3,'Position',  [Xposition      0.43    0.7750    0.15]) 

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.2 ,['DVDD12 current:',num2str(mean(DVDD12_current),'%.2f'),'\pm',num2str(std(DVDD12_current),'%.2e')],'color','r','Parent',hh3, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2 ,['DVDD33 current:',num2str(mean(DVDD33_current),'%.2f'),'\pm',num2str(std(DVDD33_current),'%.2e')],'color',[0 .3 0],'Parent',hh3, 'interpreter', 'tex');
    txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.2 ,['AVDD33 current:',num2str(mean(AVDD33_current),'%.2f'),'\pm',num2str(std(AVDD33_current),'%.2e')],'color','b','Parent',hh3, 'interpreter', 'tex');
catch err
    disp(err.identifier)
end

%%
% Plotting average signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh4 = subplot(4,1,4);
grid on
hold on
ylabel('Avg Sensor Read')
xlabel('Time (min)')
set(hh4,'box','on')

set(hh4,'Position',  [Xposition      0.0500    0.7750    0.15]);

plot(ReadTimeMins,o.SampleSensors.WithMagnet.Mean,'b');
plot(ReadTimeMins,o.SampleSensors.NoMagnet.Mean,'r');
xlim([0 EndReadTimeMins])

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1,['With-Magnet:',num2str(mean(o.SampleSensors.WithMagnet.Mean),'%.2f'),'\pm',num2str(std(o.SampleSensors.WithMagnet.Mean),'%.2f')],'color','b','Parent',hh4, 'interpreter', 'tex');
txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1,['No-Magnet:',num2str(mean(o.SampleSensors.NoMagnet.Mean),'%.2f'),'\pm',num2str(std(o.SampleSensors.NoMagnet.Mean),'%.2f')],'color','r','Parent',hh4, 'interpreter', 'tex');

samexaxis('xmt','on','ytac', 'join');

% Saving the plot
plot_file_name = [num2str(run.id),'-Panel3.fig'];
saveas(gcf,[o.Paths.save.screening,'/',plot_file_name]);
plot_file_name = [num2str(run.id),'-Panel3.png'];
set(gcf,'PaperUnits','inches','PaperSize',[20,10],'PaperPosition',[0 0 20 10])
print('-dpng','-r100',[o.Paths.save.screening,'/',plot_file_name])

%%

end
