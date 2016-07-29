
function o = PlotInstData(o)

% Plotting of MetaData
% Extracted from PanelPlotting
% Amin Mousavi 4/15/2015
close all

run = o.run;

% Flowrate
try
    FlowDataTimeMins =  o.FlowSensor.TimeStamp/60000;
    EndReadTimeMins = o.ScriptCommands.TimeStamp(end)/60000;
    FlowRate1 = o.FlowSensor.Readout;
catch err
    disp(err.identifier)
end
% Flowrate 2
try
    FlowDataTimeMins2 =  o.FlowSensor.TimeStamp2/60000;
    FlowRate2 = o.FlowSensor.Readout2;
catch err
    disp(err.identifier)
end
% Flowrate 3
try
    FlowDataTimeMins3 =  o.FlowSensor.TimeStamp3/60000;
    FlowRate3 = o.FlowSensor.Readout3;
catch err
    disp(err.identifier)
end

h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);
try
    hh1 = subplot(3,1,1);
    plot(FlowDataTimeMins,FlowRate1,'r')
    xlim([0 EndReadTimeMins])
    %title([run.id], 'interpreter', 'none')
    ylabel(sprintf('Chip (uL/min)'))
    grid on
    ylimMin = median(FlowRate1(find(abs(FlowRate1-median(FlowRate1))<3*std(FlowRate1))))-20;
    ylimMax = median(FlowRate1(find(abs(FlowRate1-median(FlowRate1))<3*std(FlowRate1))))+20;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.03*FlowDataTimeMins(end)-.03*FlowDataTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(FlowRate1),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.06*FlowDataTimeMins(end)-.06*FlowDataTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(FlowRate1),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh2 = subplot(3,1,2);
    plot(FlowDataTimeMins2,FlowRate2,'color',[0 .3 0])
    xlim([0 EndReadTimeMins])
    ylabel(sprintf('Waste (uL/min)'))
    grid on
    ylimMin = median(FlowRate2(find(abs(FlowRate2-median(FlowRate2))<3*std(FlowRate2))))-20;
    ylimMax = median(FlowRate2(find(abs(FlowRate2-median(FlowRate2))<3*std(FlowRate2))))+20;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.03*FlowDataTimeMins(end)-.03*FlowDataTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4 ,['Mean:',num2str(mean(FlowRate2),'%.2f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%         txt = text(1.06*FlowDataTimeMins(end)-.06*FlowDataTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(FlowRate2),'%.2f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh3 = subplot(3,1,3);
    plot(FlowDataTimeMins3,FlowRate3,'b')
    xlim([0 EndReadTimeMins])
    ylabel(sprintf('B2 (uL/min)'))
    grid on
    ylimMin = median(FlowRate3(find(abs(FlowRate3-median(FlowRate3))<3*std(FlowRate3))))-20;
    ylimMax = median(FlowRate3(find(abs(FlowRate3-median(FlowRate3))<3*std(FlowRate3))))+20;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.03*FlowDataTimeMins(end)-.03*FlowDataTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4 ,['Mean:',num2str(mean(FlowRate3),'%.2f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%         txt = text(1.06*FlowDataTimeMins(end)-.06*FlowDataTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(FlowRate3),'%.2f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
catch err
    disp(err.identifier)
end

try
    plot_file_name = [num2str(run.id),'-flowrate.fig'];
    saveas(gcf,[o.Paths.save.metadata, '/', plot_file_name]);
    plot_file_name = [num2str(run.id),'-flowrate.png'];
    print('-dpng','-r100',[o.Paths.save.metadata, '/', plot_file_name])
catch err
    disp(err.identifier)
end
close(h)

%% Chip Temperature
%Chip Temp
try
    ChipTempTimeMins =o.ChipTemp.TimeStamp/60000;
    RTDU = o.ChipTemp.Readout.RTDU;
    RTDM = o.ChipTemp.Readout.RTDM;
    RTDL = o.ChipTemp.Readout.RTDL;
catch err
    disp(err.identifier)
end
try
    IPTAT = o.ChipTemp.Readout.IPTAT;
catch err
    disp(err.identifier)
end

h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);
try
    hh1 = subplot(4,1,1);
    plot(ChipTempTimeMins,RTDU,'r')
    xlim([0 EndReadTimeMins])
    ylimMin = median(RTDU)-.5;
    ylimMax = median(RTDU)+.5;
    ylim([ylimMin ylimMax])
    ylabel('RTDU (oC)')
    grid on
%     try
%         txt = text(1.04*ChipTempTimeMins(end)-.04*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(RTDU),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipTempTimeMins(end)-.07*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(RTDU),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end 
    
    hh2 = subplot(4,1,2);
    plot(ChipTempTimeMins,RTDM,'color',[0 .3 0])
    xlim([0 EndReadTimeMins])
    ylimMin = median(RTDM)-.5;
    ylimMax = median(RTDM)+.5;
    ylim([ylimMin ylimMax])    
    ylabel('RTDM (oC)')
    grid on
%     try
%         txt = text(1.04*ChipTempTimeMins(end)-.04*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(RTDM),'%.2f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipTempTimeMins(end)-.07*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(RTDM),'%.2f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%     catch
%     end    
    
    hh3 = subplot(4,1,3);
    plot(ChipTempTimeMins,RTDL,'b')
    xlim([0 EndReadTimeMins])
    ylim([median(RTDL)-2 median(RTDL+2)])
    ylimMin = median(RTDL)-.5;
    ylimMax = median(RTDL)+.5;
    ylim([ylimMin ylimMax])    
    ylabel('RTDL (oC)')
    grid on
%     try
%         txt = text(1.04*ChipTempTimeMins(end)-.04*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(RTDL),'%.2f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipTempTimeMins(end)-.07*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(RTDL),'%.2f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%     catch
%     end    
    
    hh4 = subplot(4,1,4);
    plot(ChipTempTimeMins,IPTAT,'k')
    ylim([median(IPTAT)-2 median(IPTAT+2)])
    xlim([0 EndReadTimeMins])
    xlabel('Time (Min)')
    ylimMin = median(IPTAT)-.5;
    ylimMax = median(IPTAT)+.5;
    ylim([ylimMin ylimMax])    
    ylabel('IPTAT (oC)')
    grid on
%     try
%         txt = text(1.04*ChipTempTimeMins(end)-.04*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(IPTAT),'%.2f')],'Parent',hh4);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipTempTimeMins(end)-.07*ChipTempTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(IPTAT),'%.2f')],'Parent',hh4);
%         set(txt, 'rotation', 90)
%     catch
%     end    
    
catch err
    disp(err.identifier)
end

try
    plot_file_name = [num2str(run.id),'-ChipTemperature.fig'];
    saveas(gcf,[o.Paths.save.screening, '/', plot_file_name]);
    plot_file_name = [num2str(run.id),'-ChipTemperature.png'];
    print('-dpng','-r100',[o.Paths.save.screening, '/', plot_file_name])
catch err
    disp(err.identifier)
end
close(h)

%% Sys Temperature
h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);

try
    SysTimeStamp = o.SysTemp.TimeStamp;
    SysTimeMins = SysTimeStamp/60000;  %%
    CuBlock = o.SysTemp.Readout.CuBlock;
    hh1 = subplot(3,1,1);
    plot(SysTimeMins,CuBlock,'color',[0 .3 0])
    xlabel('Time (Min)')
    ylabel('CuBlock (oC)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(CuBlock)-.5;
    ylimMax = median(CuBlock)+.5;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysTimeMins(end)-.04*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(CuBlock),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysTimeMins(end)-.07*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(CuBlock),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end

    HeatSink = o.SysTemp.Readout.HeatSink;
    hh2 = subplot(3,1,2);
    plot(SysTimeMins,HeatSink,'b')
    xlabel('Time (Min)')
    ylabel('HeatSink (oC)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(HeatSink)-.5;
    ylimMax = median(HeatSink)+.5;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysTimeMins(end)-.04*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(HeatSink),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysTimeMins(end)-.07*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(HeatSink),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end

%     Preheater = o.SysTemp.Readout.Preheater;
%     hh3 = subplot(4,1,3);
%     plot(SysTimeMins,CuBlock,'k')
%     xlabel('Time (Min)')
%     ylabel('Preheater (oC)')
%     grid on
%     xlim([0 EndReadTimeMins])
%     ylimMin = median(Preheater)-1;
%     ylimMax = median(Preheater)+1;
    %ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysTimeMins(end)-.04*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(Preheater),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysTimeMins(end)-.07*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(Preheater),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    Ambient = o.SysTemp.Readout.Ambient;
    hh4 = subplot(3,1,3);
    plot(SysTimeMins,Ambient,'c')
    xlabel('Time (Min)')
    ylabel('Ambient (oC)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(Ambient)-.5;
    ylimMax = median(Ambient)+.5;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysTimeMins(end)-.04*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(Ambient),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysTimeMins(end)-.07*SysTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(Ambient),'%.2f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
catch err
    disp(err.identifier)
end
try
    plot_file_name = [num2str(run.id),'-SystemTemperature.fig'];
    saveas(gcf,[o.Paths.save.metadata, '/', plot_file_name]);
    plot_file_name = [num2str(run.id),'-SystemTemperature.png'];
    print('-dpng','-r100',[o.Paths.save.metadata, '/',plot_file_name])
catch err
    disp(err.identifier)
end
close(h)

%% Chip Voltages
h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);

%Voltages
try
    ADCVref = o.ChipVoltage.Readout.ADCVref;
    AFEVref = o.ChipVoltage.Readout.AFEVref;
catch err
    disp(err.identifier)
end
try
    RFVHi = o.ChipVoltage.Readout.RFVHi;
    RFVLo = o.ChipVoltage.Readout.RFVLo;
    RFswing = (RFVHi-RFVLo)/2;
catch err
    disp(err.identifier)
end
try
    RFVHiNB = o.ChipVoltage.Readout.RFVHiNB;
    RFVLoNB = o.ChipVoltage.Readout.RFVLoNB;
catch err
    disp(err.identifier)
end
try
    PPoly = o.ChipVoltage.Readout.PPoly;
catch err
    disp(err.identifier)
end
try
    ChipVoltTime_Adj = o.ChipVoltage.TimeStamp;
    ChipVoltTimeMins = ChipVoltTime_Adj/60000;
catch err
    disp(err.identifier)
end
try
    ADCVrefOff = ADCVref-mean(ADCVref); AFEVrefOff = AFEVref-mean(AFEVref);
    RFVHiOff = RFVHi-mean(RFVHi); RFVLoOff = RFVLo-mean(RFVLo);
catch err
    disp(err.identifier)
end

try
    hh1 = subplot(5,1,1);
    plot(ChipVoltTimeMins,ADCVref,'r')
    xlabel('Time (Min)')
    ylabel('ADCVref (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(ADCVref)-.02;
    ylimMax = median(ADCVref)+.02;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*ChipVoltTimeMins(end)-.04*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(ADCVref),'%.3f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipVoltTimeMins(end)-.07*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(ADCVref),'%.3f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh2 = subplot(5,1,2);
    plot(ChipVoltTimeMins,AFEVref,'color',[0 .3 0])
    xlabel('Time (Min)')
    ylabel('AFEVref (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(AFEVref)-.02;
    ylimMax = median(AFEVref)+.02;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*ChipVoltTimeMins(end)-.04*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(AFEVref),'%.3f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipVoltTimeMins(end)-.07*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(AFEVref),'%.3f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh3 = subplot(5,1,3);
    plot(ChipVoltTimeMins,RFVHi,'b')
    xlabel('Time (Min)')
    ylabel('RFVHi (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(RFVHi)-.02;
    ylimMax = median(RFVHi)+.02;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*ChipVoltTimeMins(end)-.04*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(RFVHi),'%.3f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipVoltTimeMins(end)-.07*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(RFVHi),'%.3f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh4 = subplot(5,1,4);
    plot(ChipVoltTimeMins,RFVLo,'k')
    xlabel('Time (Min)')
    ylabel('RFVLo (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(RFVLo)-.02;
    ylimMax = median(RFVLo)+.02;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*ChipVoltTimeMins(end)-.04*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(RFVLo),'%.3f')],'Parent',hh4);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipVoltTimeMins(end)-.07*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(RFVLo),'%.3f')],'Parent',hh4);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh5 = subplot(5,1,5);
    plot(ChipVoltTimeMins,RFswing,'c')
    xlabel('Time (Min)')
    ylabel('RF Swing (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(RFswing)-.02;
    ylimMax = median(RFswing)+.02;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*ChipVoltTimeMins(end)-.04*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(RFVLo),'%.3f')],'Parent',hh4);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*ChipVoltTimeMins(end)-.07*ChipVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(RFVLo),'%.3f')],'Parent',hh4);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
catch err
    disp(err.identifier)
end

try
    plot_file_name = [num2str(run.id),'-ChipVoltage.fig'];
    saveas(gcf,[o.Paths.save.chip, '/',plot_file_name]);
    plot_file_name = [num2str(run.id),'-ChipVoltage.png'];
    print('-dpng','-r100',[o.Paths.save.chip, '/',plot_file_name])
catch err
    disp(err.identifier)
end
close(h)

%% Chip Swing and common mode change
% close all
% 
% figure
% 
% try
%     subplot(4,1,1)
%     plot(ChipVoltTimeMins,(AFEVref-(RFVHi+RFVLo)/2),'b')
%     ylabel('AFEVref-(RFVHi+RFVLo)/2')
%     xlabel('Time (Min)')
%     xlim([0 EndReadTimeMins])
%     grid on
%     subplot(4,1,2)
%     plot(ChipVoltTimeMins,RFVHi-RFVLo,'r')
%     ylabel('RFVHi-RFVLo')
%     xlabel('Time (Min)')
%     xlim([0 EndReadTimeMins])
%     grid on
%     subplot(4,1,3)
%     plot(ChipVoltTimeMins,(AFEVref-(RFVHiNB+RFVLoNB)/2),'g')
%     ylabel('AFEVref-(RFVHiNB+RFVLoNB)/2')
%     xlabel('Time (Min)')
%     xlim([0 EndReadTimeMins])
%     grid on
%     subplot(4,1,4)
%     plot(ChipVoltTimeMins,RFVHiNB-RFVLoNB,'k')
%     ylabel('RFVHiNB-RFVLoNB')
%     xlabel('Time (Min)')
%     xlim([0 EndReadTimeMins])
%     grid on
% catch
% end
% try
%     plot_file_name = [num2str(run.id),'-ChipSwing.fig'];
%     saveas(gcf,[o.Paths.save.metadata, '/',plot_file_name]);
%     plot_file_name = [num2str(run.id),'-ChipSwing.png'];
%     print('-dpng','-r100',[o.Paths.save.metadata, '/',plot_file_name])
% catch err
%     disp(err.identifier)
% end

%% System voltages and currents
%System voltage
try
    SysVoltages = o.SysVoltage.Readout;
    DVDD12 = SysVoltages(:,1);   DVDD12off = DVDD12-mean(DVDD12);
    DVDD12_current = (SysVoltages(:,4)-SysVoltages(:,5))/0.1*1000;
    DVDD12_currentoff = DVDD12_current-mean(DVDD12_current);
catch err
    disp(err.identifier)
end
try
    DVDD33 = SysVoltages(:,2);   DVDD33off = DVDD33-mean(DVDD33);
    DVDD33_current = (SysVoltages(:,4)-SysVoltages(:,6))/0.1*1000;
    DVDD33_currentoff = DVDD33_current-mean(DVDD33_current);
catch err
    disp(err.identifier)
end
try
    AVDD33 = SysVoltages(:,3);   AVDD33off = AVDD33-mean(AVDD33);
    AVDD33_current = (SysVoltages(:,4)-SysVoltages(:,7))/0.1*1000;
    AVDD33_currentoff = AVDD33_current-mean(AVDD33_current);
catch err
    disp(err.identifier)
end
try
    SysVoltTime_Adj = o.SysVoltage.TimeStamp;
    SysVoltTimeMins = SysVoltTime_Adj/60000;
catch err
    disp(err.identifier)
end

h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);

try
    SysVoltTimeStamp = o.SysVoltage.TimeStamp;
    SysVoltTimeMins = SysVoltTimeStamp/60000;
    
    hh1 = subplot(3,1,1);
    plot(SysVoltTimeMins,DVDD12,'r')
    xlabel('Time (Min)')
    ylabel('DVDD12 (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(DVDD12)-.2;
    ylimMax = median(DVDD12)+.2;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysVoltTimeMins(end)-.04*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(DVDD12),'%.3f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysVoltTimeMins(end)-.07*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(DVDD12),'%.3f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh2 = subplot(3,1,2);
    plot(SysVoltTimeMins,DVDD33,'color',[0 .3 0])
    xlabel('Time (Min)')
    ylabel('DVDD33 (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(DVDD33)-.4;
    ylimMax = median(DVDD33)+.4;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysVoltTimeMins(end)-.04*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(DVDD33),'%.3f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysVoltTimeMins(end)-.07*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(DVDD33),'%.3f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh3 = subplot(3,1,3);
    plot(SysVoltTimeMins,AVDD33,'b')
    xlabel('Time (Min)')
    ylabel('AVDD33 (V)')
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(AVDD33)-.4;
    ylimMax = median(AVDD33)+.4;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysVoltTimeMins(end)-.04*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(AVDD33),'%.3f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysVoltTimeMins(end)-.07*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(AVDD33),'%.3f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%     catch
%     end

catch err
    disp(err.identifier)
end

try
    plot_file_name = [num2str(run.id),'-SystemVoltage.fig'];
    saveas(gcf,[o.Paths.save.metadata, '/',plot_file_name]);
    plot_file_name = [num2str(run.id),'-SystemVoltage.png'];
    print('-dpng','-r100',[o.Paths.save.metadata, '/',plot_file_name])
catch err
    disp(err.identifier)
end
close(h)

try
    
    h = figure;
    set(h,'Color','w')

    set(h,'Position',[1    1   900 600]);
    
    hh1 = subplot(3,1,1);
    plot(SysVoltTimeMins,DVDD12_current,'r')
    xlabel('Time (Min)')
    ylabel(sprintf('DVDD12 Current\n (mA)'))
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(DVDD12_current)-200;
    ylimMax = median(DVDD12_current)+200;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysVoltTimeMins(end)-.04*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(DVDD12_current),'%.3f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysVoltTimeMins(end)-.07*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(DVDD12_current),'%.3f')],'Parent',hh1);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh2 = subplot(3,1,2);
    plot(SysVoltTimeMins,DVDD33_current,'color',[0 .3 0])
    xlabel('Time (Min)')
    ylabel(sprintf('DVDD33 Current\n (mA)'))
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(DVDD33_current)-200;
    ylimMax = median(DVDD33_current)+200;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysVoltTimeMins(end)-.04*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(DVDD33_current),'%.3f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysVoltTimeMins(end)-.07*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(DVDD33_current),'%.3f')],'Parent',hh2);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
    hh3 = subplot(3,1,3);
    plot(SysVoltTimeMins,AVDD33_current,'b')
    xlabel('Time (Min)')
    ylabel(sprintf('AVDD33 Current\n (mA)'))
    grid on
    xlim([0 EndReadTimeMins])
    ylimMin = median(AVDD33_current)-200;
    ylimMax = median(AVDD33_current)+200;
    ylim([ylimMin ylimMax])
%     try
%         txt = text(1.04*SysVoltTimeMins(end)-.04*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Mean:',num2str(mean(AVDD33_current),'%.3f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%         txt = text(1.07*SysVoltTimeMins(end)-.07*SysVoltTimeMins(1),(ylimMax+ylimMin)/2 - (ylimMax-ylimMin)/4,['Std:',num2str(std(AVDD33_current),'%.3f')],'Parent',hh3);
%         set(txt, 'rotation', 90)
%     catch
%     end
    
catch err
    disp(err.identifier)
end

try
    plot_file_name = [num2str(run.id),'-SystemCurrents.fig'];
    saveas(gcf,[o.Paths.save.metadata, '/', plot_file_name]);
    plot_file_name = [num2str(run.id),'-SystemCurrents.png'];
    print('-dpng','-r100',[o.Paths.save.metadata, '/', plot_file_name])
catch err
    disp(err.identifier)
end
close(h)

end