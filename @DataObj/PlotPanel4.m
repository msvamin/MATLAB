
function o = PlotPanel4(o)

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

%Valve State
idx = (o.ValveState.TimeStamp>0)&(o.ValveState.TimeStamp<o.ReadTimeStamp(end));
ValveStateTimeMins =  o.ValveState.TimeStamp(idx)/60000;
ValveArray = o.ValveState.States(idx,:);
ValveArrayAdj=ValveArray-repmat(min(ValveArray),length(ValveArray),1);

%Raw data
ReadTime_Adj = o.ReadTimeStamp;
ReadTimeMins = ReadTime_Adj/60000;

%%
h = figure(fignum);
set(h,'Color','w')
set(h,'Position',[1    1   1500  1025]);

%% Flow rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh1 = subplot(3,1,1);
hold on
grid on
plot(FlowDataTimeMins,FlowRate, 'r')
plot(FlowDataTimeMins2,FlowRate2, 'color',[0 .3 0])
plot(FlowDataTimeMins3,FlowRate3, 'b')
xlim([0 EndReadTimeMins])

title(sprintf('%s\n Flow Rates and Valve States on Instrumentation Window', run.id), 'interpreter', 'none')

ylabel(sprintf('Flow rate (uL/min)'))

set(hh1,'Position',  [Xposition      0.79    0.7750    0.15]) 

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

try
    %TS = [num2str(median(FlowRate)) ,num2str(std(FlowRate))];
    TS = ['Chip: ' sprintf('%.1f',median(FlowRate)) '\pm' sprintf('%.1f',std(FlowRate))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2+(ylimMax-ylimMin)*.2,TS,'color','r','parent',hh1, 'interpreter', 'tex');
    TS = ['Waste: ' sprintf('%.1f',median(FlowRate2)) '\pm' sprintf('%.1f',std(FlowRate2))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2,TS,'color',[0 .3 0],'parent',hh1, 'interpreter', 'tex');
    TS = ['B2: ' sprintf('%.1f',median(FlowRate3)) '\pm' sprintf('%.1f',std(FlowRate3))];
    txt = text(xlims(2)+2,(ylimMin+ylimMax)/2-(ylimMax-ylimMin)*.2,TS,'color','b','parent',hh1, 'interpreter', 'tex');
catch err
    disp(err.identifier)
end

%%
% ValveStates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh2 = subplot(3,1,2);
grid on
hold on
CC=jet(19);

A = {'Purge Pressure' 'Manifold Waste' 'C Backflow' 'CC' 'A Backflow' 'AC' 'G Backflow' 'GC' 'B2C' ' ' ' ' ' ' ' ' 'Purge Liquid' 'T Backflow' 'TC' 'B1C' 'Bead Wash' 'Sensor Waste' 'Fast Waste' ' ' 'Fan' 'Pump' 'Always on'};
inds=[1:3,5:11,16:24];
for i=1:19
    
    j=inds(i);
    ValveArraySelect = ValveArrayAdj(:,j)+i*1.4;
    h1(i)=plot(ValveStateTimeMins,double(ValveArraySelect),'color',CC(i,:));
    txt = text(EndReadTimeMins+2,min(double(ValveArraySelect)) ,A{25-inds(i)},'color','k','fontsize',7,'Parent',hh2);
end
xlim([0 EndReadTimeMins])

ylim([0 1.4*20])
ylabel('Valve states')
set(hh2,'Position',  [Xposition    0.704    0.7750    0.15])

ylims = get(gca,'Ylim');
set(hh2,'box','on')

%%
% Plotting average signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hh3 = subplot(3,1,3);
grid on
hold on
ylabel('Avg Sensor Read')
xlabel('Time (min)')
set(hh3,'box','on')

set(hh3,'Position',  [Xposition      0.0500    0.7750    0.15]);

plot(ReadTimeMins,o.SampleSensors.WithMagnet.Mean,'b');
plot(ReadTimeMins,o.SampleSensors.NoMagnet.Mean,'r');
xlim([0 EndReadTimeMins])

ylims = get(gca,'Ylim');
xlims = get(gca,'xlim');

ylimMin = ylims(1);
ylimMax = ylims(2);

txt = text(xlims(2)+2,(ylimMax+ylimMin)/2+(ylimMax-ylimMin)*.1,['With-Magnet:',num2str(mean(o.SampleSensors.WithMagnet.Mean),'%.2f'),'\pm',num2str(std(o.SampleSensors.WithMagnet.Mean),'%.2f')],'color','b','Parent',hh3, 'interpreter', 'tex');
txt = text(xlims(2)+2,(ylimMax+ylimMin)/2-(ylimMax-ylimMin)*.1,['No-Magnet:',num2str(mean(o.SampleSensors.NoMagnet.Mean),'%.2f'),'\pm',num2str(std(o.SampleSensors.NoMagnet.Mean),'%.2f')],'color','r','Parent',hh3, 'interpreter', 'tex');

samexaxis('xmt','on','ytac', 'join');

% Saving the plot
plot_file_name = [num2str(run.id),'-Panel4.fig'];
saveas(gcf,[o.Paths.save.screening,'/',plot_file_name]);
plot_file_name = [num2str(run.id),'-Panel4.png'];
%saveas(gcf,[NAS_report_folder_location,plot_file_name]);
set(gcf,'PaperUnits','inches','PaperSize',[20,10],'PaperPosition',[0 0 20 10])
print('-dpng','-r100',[o.Paths.save.screening,'/',plot_file_name])

%%

end
