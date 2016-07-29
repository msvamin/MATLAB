
function o = PlotPanel2(o)

% Plotting of Panel 2 for windowed data
% Extracted from PanelPlotting
% Amin Mousavi 4/19/2016

run = o.run;
%%
fignum = 1;
Xposition = 0.06;

%% Load data
windowIdx = o.windowIdx;
windowedTime = o.ReadIndProp.TimeStamp(windowIdx);
windowedTimeMins = windowedTime/60000;
WinEndTime = windowedTimeMins(end);

%Flow
FlowDataTimeMins =  o.FlowSensor.TimeStamp/60000;
TimeZeroMins = o.ScriptCommands.TimeZero/60000;
EndReadTimeMins = o.ScriptCommands.TimeStamp(end)/60000;
WinFlowRate = o.ReadIndProp.FlowRate(windowIdx);

FlowDataTimeMins2 =  o.FlowSensor.TimeStamp2/60000;
WinFlowRate2 = o.ReadIndProp.FlowRate2(windowIdx);

FlowDataTimeMins3 =  o.FlowSensor.TimeStamp3/60000;
WinFlowRate3 = o.ReadIndProp.FlowRate3(windowIdx);

%Chip Temp
ChipTempTimeMins =o.ChipTemp.TimeStamp/60000;
RTDU = o.ReadIndProp.ChipTemp.RTDU(windowIdx);
RTDM = o.ReadIndProp.ChipTemp.RTDM(windowIdx);
RTDL = o.ReadIndProp.ChipTemp.RTDL(windowIdx);
RTDUOff = RTDU-mean(RTDU);
RTDMOff = RTDM-mean(RTDM);
RTDLOff = RTDL-mean(RTDL);
IPTAT = o.ReadIndProp.ChipTemp.IPTAT(windowIdx);
IPTATOff = IPTAT-mean(IPTAT);

%Sys Temp
SysTempTimeMins =o.SysTemp.TimeStamp/60000;
CuT = o.ReadIndProp.SysTemps.CuBlock(windowIdx);
Ambient = o.ReadIndProp.SysTemps.Ambient(windowIdx);

%Pressure
PumpPressure = o.ReadIndProp.PumpPressure(windowIdx);
CartridgePressure = o.ReadIndProp.CartridgePressure(windowIdx) ;
CartridgePOff = CartridgePressure-mean(CartridgePressure);
PumpPOff = PumpPressure-mean(PumpPressure);

SysPresTime_Adj = o.SysPressure.TimeStamp;
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
plot(windowedTimeMins, WinFlowRate, 'r')
plot(windowedTimeMins, WinFlowRate2, 'color',[0 .3 0])
plot(windowedTimeMins, WinFlowRate3, 'b')
xlim([0 WinEndTime])
title(sprintf('%s\n Flow Rates, Temperatures and Pressures on Sequencing Window', run.id), 'interpreter', 'none')

ylabel(sprintf('Flow rate (uL/min)'))

set(hh1,'Position',  [Xposition      0.79    0.7750    0.15]) 

ylims = get(hh1,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    %TS = [num2str(median(FlowRate)) ,num2str(std(FlowRate))];
    TS = ['Chip: ' sprintf('%.1f',median(WinFlowRate)) '\pm' sprintf('%.1f',std(WinFlowRate))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2+(ylimMax-ylimMin)*.2,TS,'color','r','parent',hh1, 'interpreter', 'tex');
    TS = ['Manifold: ' sprintf('%.1f',median(WinFlowRate2)) '\pm' sprintf('%.1f',std(WinFlowRate2))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2 ,TS,'color',[0 .3 0],'parent',hh1, 'interpreter', 'tex');
    TS = ['B2: ' sprintf('%.1f',median(WinFlowRate3)) '\pm' sprintf('%.1f',std(WinFlowRate3))];
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

plot(windowedTimeMins, RTDUOff,'r')
plot(windowedTimeMins, RTDMOff,'color',[0 .3 0])
plot(windowedTimeMins, RTDLOff,'b')
%plot(ChipTempTimeMins,IPTATOff,'c')
xlim([0 WinEndTime])

ylabel('Chip Temp (oC)')
set(hh2,'Position',  [Xposition      0.61    0.7750    0.15]) 

ylims = get(hh2,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);
    
try
    txt2 = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.2, ['RTDU:',num2str(median(RTDU),'%.2f'),'\pm',num2str(std(RTDU),'%.2f')],'color','r','Parent',hh2, 'interpreter', 'tex');
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
plot(windowedTimeMins, CuT, 'r')
plot(windowedTimeMins, Ambient, 'b')
xlim([0 WinEndTime])

ylabel(sprintf('System Temp (oC)'))

set(hh3,'Position',  [Xposition      0.43    0.7750    0.15]) 

ylims = get(hh3,'Ylim');
xlims = get(gca,'xlim');

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

plot(windowedTimeMins, CartridgePOff,'b');
plot(windowedTimeMins, PumpPOff,'r');
xlim([0 WinEndTime])

ylabel('Pressure (psi)')
ylabel(sprintf('Pressure (psi)'))
set(hh4,'Position',  [Xposition     0.250    0.7750    0.15])

ylimMax = 3*max(std(CartridgePOff),std(PumpPOff));
ylimMin = -ylimMax;
ylim([ylimMin ylimMax])
xlims = get(gca,'xlim');

txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1 ,['Pump:',num2str(mean(PumpPressure),'%.2f'),'\pm',num2str(std(PumpPressure),'%.2f')],'color','r','Parent',hh4, 'interpreter', 'tex');
txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1 ,['Cartridge:',num2str(mean(CartridgePressure),'%.2f'),'\pm',num2str(std(CartridgePressure),'%.2f')],'color','b','Parent',hh4, 'interpreter', 'tex');

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

plot(windowedTimeMins, o.SampleSensors.WithMagnet.Mean(windowIdx),'b');
plot(windowedTimeMins, o.SampleSensors.NoMagnet.Mean(windowIdx),'r');
xlim([0 WinEndTime])

ylims = get(hh5,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1 ,['With-Magnet:',num2str(mean(o.SampleSensors.WithMagnet.Mean(windowIdx)),'%.2f'),'\pm',num2str(std(o.SampleSensors.WithMagnet.Mean),'%.2f')],'color','b','Parent',hh5, 'interpreter', 'tex');
txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1 ,['No-Magnet:',num2str(mean(o.SampleSensors.NoMagnet.Mean(windowIdx)),'%.2f'),'\pm',num2str(std(o.SampleSensors.NoMagnet.Mean),'%.2f')],'color','r','Parent',hh5, 'interpreter', 'tex');

samexaxis('xmt','on','ytac', 'join');

% Saving the plot
plot_file_name = [num2str(run.id),'-Panel2.fig'];
saveas(gcf,[o.Paths.save.screening,'/',plot_file_name]);
plot_file_name = [num2str(run.id),'-Panel2.png'];
%saveas(gcf,[NAS_report_folder_location,plot_file_name]);
set(gcf,'PaperUnits','inches','PaperSize',[20,10],'PaperPosition',[0 0 20 10])
print('-dpng','-r100',[o.Paths.save.screening,'/',plot_file_name])

%%

end
