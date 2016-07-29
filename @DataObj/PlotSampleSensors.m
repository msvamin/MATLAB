
function o = PlotSampleSensors(o)

% Sample Sensors Plot

% Plot Sensor MAP
NumberOfSensors = 10;

xtime = o.ReadTimeStamp/60000;

h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);

chooseRandSen=randsample([1:o.SampleSensors.numSampleSen],NumberOfSensors);
    
subplot(2,1,1)
    
for i=1:NumberOfSensors
    plot(xtime, o.SampleSensors.WithMagnet.Reads(chooseRandSen(i),:))
    hold on
end
title('With-magnet sample sensors')
xlabel('Time [min]')

subplot(2,1,2)

for i=1:NumberOfSensors
    plot(xtime, o.SampleSensors.NoMagnet.Reads(chooseRandSen(i),:))
    hold on
end
title('No-magnet sample sensors')
xlabel('Time [min]')

save2jpg_report(fullfile(o.Paths.save.sensors, [o.run.id '-SampleSensors.jpg']),gcf)
saveas(gcf,     fullfile(o.Paths.save.sensors, [o.run.id '-SampleSensors.fig'])); 
    
close(h)

% Average Sensors Plot
h = figure;
set(h,'Color','w')

set(h,'Position',[1    1   900 600]);

   
subplot(2,1,1)
    
plot(xtime, o.SampleSensors.WithMagnet.Mean, 'b')

title('With-magnet average signal')
xlabel('Time [min]')

subplot(2,1,2)

plot(xtime, o.SampleSensors.NoMagnet.Mean, 'r')

title('No-magnet average signal')
xlabel('Time [min]')

save2jpg_report(fullfile(o.Paths.save.sensors, [o.run.id '-AverageSignal.jpg']),gcf)
saveas(gcf,     fullfile(o.Paths.save.sensors, [o.run.id '-AverageSignal.fig'])); 
    
close(h)
