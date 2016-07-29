
function o = PlotPanel1(o)

% Plotting of Panels
% Extracted from PanelPlotting
% Amin Mousavi 10/26/2015
% Modified by Amin 4/13/2016

run = o.run;
%%
fignum = 1;
Xposition = 0.06;
%% Load data

%Flow

TimeZeroMins = o.ScriptCommands.TimeZero/60000;
EndReadTimeMins = o.ScriptCommands.TimeStamp(end)/60000;
idx = (o.FlowSensor.TimeStamp>0)&(o.FlowSensor.TimeStamp<o.ReadTimeStamp(end));
FlowDataTimeMins =  o.FlowSensor.TimeStamp(idx)/60000;
FlowRate = o.FlowSensor.Readout(idx);
    
FlowDataTimeMins2 =  o.FlowSensor.TimeStamp2(idx)/60000;
FlowRate2 = o.FlowSensor.Readout2(idx);

FlowDataTimeMins3 =  o.FlowSensor.TimeStamp3(idx)/60000;
FlowRate3 = o.FlowSensor.Readout3(idx);

%Chip Temp

idx = (o.ChipTemp.TimeStamp>0)&(o.ChipTemp.TimeStamp<o.ReadTimeStamp(end));
ChipTempTimeMins =o.ChipTemp.TimeStamp(idx)/60000;
RTDU = o.ChipTemp.Readout.RTDU(idx);
RTDM = o.ChipTemp.Readout.RTDM(idx);
RTDL = o.ChipTemp.Readout.RTDL(idx);
IPTAT = o.ChipTemp.Readout.IPTAT(idx);
    
%Sys Temp

idx = (o.SysTemp.TimeStamp>0)&(o.SysTemp.TimeStamp<o.ReadTimeStamp(end));
SysTempTimeMins =o.SysTemp.TimeStamp(idx)/60000;
CuT = o.SysTemp.Readout.CuBlock(idx);
Ambient = o.SysTemp.Readout.Ambient(idx);
    
%Pressure

idx = (o.SysPressure.TimeStamp>0)&(o.SysPressure.TimeStamp<o.ReadTimeStamp(end));
PumpPressure = o.SysPressure.Readout.Pump(idx);
CartridgePressure = o.SysPressure.Readout.Cartridge(idx);
SysPresTime_Adj = o.SysPressure.TimeStamp(idx);
CartridgePOff = CartridgePressure-mean(CartridgePressure);
PumpPOff = PumpPressure-mean(PumpPressure);
SysPressureTimeMins = SysPresTime_Adj/60000;

%Raw data

ReadTime_Adj = o.ReadTimeStamp;
ReadTimeMins = ReadTime_Adj/60000;

%%
h = figure(fignum);
set(h,'Color','w')
set(h,'Position',[1    1   1500  1025]);

%% Flow rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh1 = subplot(5,1,1);
hold on
grid on
plot(FlowDataTimeMins,FlowRate, 'r')
plot(FlowDataTimeMins2,FlowRate2, 'color',[0 .3 0])
plot(FlowDataTimeMins3,FlowRate3, 'b')
xlim([0 EndReadTimeMins])
title(sprintf('%s\n Flow Rates, Temperatures and Pressures on Instrumentation Window', run.id), 'interpreter', 'none')

ylabel(sprintf('Flow rate (uL/min)'))

set(hh1,'Position',  [Xposition      0.79    0.7750    0.15]) 

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    %TS = [num2str(median(FlowRate)) ,num2str(std(FlowRate))];
    TS = ['Chip: ' sprintf('%.1f',median(FlowRate)) '\pm' sprintf('%.1f',std(FlowRate))];
    %EndReadTimeMins+3
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2+(ylimMax-ylimMin)*.2,TS,'color','r','parent',hh1, 'interpreter', 'tex');
    TS = ['Waste: ' sprintf('%.1f',median(FlowRate2)) '\pm' sprintf('%.1f',std(FlowRate2))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2,TS,'color',[0 .3 0],'parent',hh1, 'interpreter', 'tex');
    TS = ['B2: ' sprintf('%.1f',median(FlowRate3)) '\pm' sprintf('%.1f',std(FlowRate3))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2-(ylimMax-ylimMin)*.2,TS,'color','b','parent',hh1, 'interpreter', 'tex');
catch err
    disp(err.identifier)
end

%%
% Chip Temperature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh2 = subplot(5,1,2);
grid on
hold on
set(hh2,'box','on')

plot(ChipTempTimeMins,RTDU,'r')
plot(ChipTempTimeMins,RTDM,'color',[0 .3 0])
plot(ChipTempTimeMins,RTDL,'b')
%plot(ChipTempTimeMins,IPTAT,'c')
xlim([0 EndReadTimeMins])

ylabel('Chip Temp (oC)')
set(hh2,'Position',  [Xposition      0.61    0.7750    0.15]) 

ylims = get(gca,'Ylim');

ylimMin = ylims(1);
ylimMax = ylims(2);
    
try
    txt2 = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.2,['RTDU:',num2str(median(RTDU),'%.2f'),'\pm',num2str(std(RTDU),'%.2f')],'color','r','Parent',hh2, 'interpreter', 'tex');
    txt3 = text(xlims(2)+2,(ylimMax+ylimMin)/2 ,            ['RTDM:',num2str(median(RTDM),'%.2f'),'\pm',num2str(std(RTDM),'%.2f')],'color',[0 .3 0],'Parent',hh2, 'interpreter', 'tex');
    txt4 = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.2, ['RTDL:',num2str(median(RTDL),'%.2f'),'\pm',num2str(std(RTDL),'%.2f')],'color','b','Parent',hh2, 'interpreter', 'tex');
catch err
    disp(err.identifier)
end

%% System Temperature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh3 = subplot(5,1,3);
hold on
grid on
plot(SysTempTimeMins,CuT, 'r')
plot(FlowDataTimeMins,Ambient, 'b')
xlim([0 EndReadTimeMins])

%ylabel('Flow rate (uL/min)')
ylabel(sprintf('System Temp (oC)'))

%set(hh1,'Position', [0.05    0.91   0.7750    0.0641])
set(hh3,'Position',  [Xposition      0.43    0.7750    0.15]) 

ylims = get(gca,'Ylim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    %TS = [num2str(median(FlowRate)) ,num2str(std(FlowRate))];
    TS = ['CuBlock: ' sprintf('%.1f',median(CuT)) '\pm' sprintf('%.1f',std(CuT))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2+(ylimMax-ylimMin)*.1 ,TS,'color','r','parent',hh3, 'interpreter', 'tex');
    TS = ['Ambient: ' sprintf('%.1f',median(Ambient)) '\pm' sprintf('%.1f',std(Ambient))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2-(ylimMax-ylimMin)*.1 ,TS,'color','b','parent',hh3, 'interpreter', 'tex');

catch err
    disp(err.identifier)
end

%%
% Pressure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh4 = subplot(5,1,4);
grid on
hold on
set(hh4,'box', 'on')

plot(SysPressureTimeMins,CartridgePOff,'b');
plot(SysPressureTimeMins,PumpPOff,'r');
xlim([0 EndReadTimeMins])

ylabel('Pressure (psi)')
ylabel(sprintf('Pressure (psi)'))
set(hh4,'Position',  [Xposition     0.250    0.7750    0.15])

ylimMax = 3*max(std(CartridgePOff),std(PumpPOff));
ylimMin = -ylimMax;
ylim([ylimMin ylimMax])

txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1,['Pump:',num2str(mean(PumpPressure),'%.2f'),'\pm',num2str(std(PumpPressure),'%.2f')],'color','r','Parent',hh4, 'interpreter', 'tex');
txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1,['Cartridge:',num2str(mean(CartridgePressure),'%.2f'),'\pm',num2str(std(CartridgePressure),'%.2f')],'color','b','Parent',hh4, 'interpreter', 'tex');

%%
% Plotting average signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh5 = subplot(5,1,5);
grid on
hold on
ylabel('Avg Sensor Read')
xlabel('Time (min)')
set(hh5,'box','on')

set(hh5,'Position',  [Xposition      0.0500    0.7750    0.15]);

plot(ReadTimeMins,o.SampleSensors.WithMagnet.Mean,'b');
plot(ReadTimeMins,o.SampleSensors.NoMagnet.Mean,'r');
xlim([0 EndReadTimeMins])

ylims = get(gca,'Ylim');

ylimMin = ylims(1);
ylimMax = ylims(2);

txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1,['With-Magnet:',num2str(mean(o.SampleSensors.WithMagnet.Mean),'%.2f'),'\pm',num2str(std(o.SampleSensors.WithMagnet.Mean),'%.2f')],'color','b','Parent',hh5, 'interpreter', 'tex');
txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1,['No-Magnet:',num2str(mean(o.SampleSensors.NoMagnet.Mean),'%.2f'),'\pm',num2str(std(o.SampleSensors.NoMagnet.Mean),'%.2f')],'color','r','Parent',hh5, 'interpreter', 'tex');

samexaxis('xmt','on','ytac', 'join');

% Saving the plot
plot_file_name = [num2str(run.id),'-Panel1.fig'];
saveas(gcf,[o.Paths.save.screening,'/',plot_file_name]);
plot_file_name = [num2str(run.id),'-Panel1.png'];
%saveas(gcf,[NAS_report_folder_location,plot_file_name]);
set(gcf,'PaperUnits','inches','PaperSize',[20,10],'PaperPosition',[0 0 20 10])
print('-dpng','-r100',[o.Paths.save.screening,'/',plot_file_name])

%%

end
