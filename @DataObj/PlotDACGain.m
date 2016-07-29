function o = PlotDACGain(o)

% DAC Gain Plots
% Extracted from runQAreport
% Amin Mousavi 10/27/2015
% Amin Mousavi 5/9/2016


% DAC gain histogram
try
    h = figure;
    histogram(o.Gain.dac.withMagnet,0:5:500, 'FaceColor', 'b')
    hold;
    
    histogram(o.Gain.dac.noMagnet,0:5:500, 'FaceColor', 'r')
    legend('With-magnet','No-magnet')
    
    xlabel('DAC Gain')
    ylabel('Number of sensors')
    %title([sprintf('Mean %.1f',mean(o.Gain.dac.withMagnet)) '\pm' sprintf('%.1f',std(o.Gain.dac.withMagnet))], 'interpreter', 'tex')
    %title([sprintf('Mean %.1f',mean(o.Gain.dac.noMagnet)) '\pm' sprintf('%.1f',std(o.Gain.dac.noMagnet))], 'interpreter', 'tex')
    
    %save2pdf(       [SaveDataPath{i}{2} o.run.id '-hist-DACgain.pdf'], gcf, 600)
    save2jpg_report([o.Paths.save.chip '/' o.run.id '-hist-DACgain.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-hist-DACgain.fig']);
    
    close(h)
catch err
    disp(err.identifier)
    disp('Error in plotting DAC Gain histogram')
end

% DAC Gain heatmap
try
    h = figure;
    imagesc(reshape(o.Gain.dac.all,1024,o.chip.number_of_rows)');
    colorbar
    title('DAC Gain')
    xlabel('Columns')
    ylabel('Rows')
    %QAFigureFormat(gcf,gca)
    
    save2jpg_report([o.Paths.save.chip '/' o.run.id '-heatmap-DACgain.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-heatmap-DACgain.fig']);
    
    imagesc(reshape(o.Gain.dac.all,1024,o.chip.number_of_rows)');
    colorbar
    title('DAC Gain')
    xlabel('Columns')
    ylabel('Rows')
    %QAFigureFormat(gcf,gca)
    
    save2jpg_report([o.Paths.save.chip '/' o.run.id '-heatmap-DACgain.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-heatmap-DACgain.fig']);
    
    close(h)
catch err
    disp(err.identifier)
    disp('Error in plotting DAC Gain heatmap')
end

% Calculating the noise
nSamples = o.Mask.nSamples;
nXrange = size(o.Mask.xrange,2);
nCycles = nXrange/nSamples;

WBsensors=find(o.chip.NB==0);
NBsensors=find(o.chip.NB);
WMrawData = single(o.MI(WBsensors,o.Mask.xrange(1+nSamples:2*nSamples)));
NMrawData = single(o.MI(NBsensors,o.Mask.xrange(1+nSamples:2*nSamples)));

WMres = pcares(WMrawData, 8);
NMres = pcares(NMrawData, 8);

stdM = zeros(1,size(o.MI,1));

noiseWM = std(WMres');
noiseNM = std(NMres');
stdM(:,WBsensors) = noiseWM;
stdM(:,NBsensors) = noiseNM;

% Read noise histogram
try
    h = figure;
    histogram(noiseWM,0:5:500, 'FaceColor', 'b')
    hold;
    
    histogram(noiseNM,0:5:500, 'FaceColor', 'r')
    legend('With-magnet','No-magnet')
    
    xlabel('Read Noise')
    ylabel('Number of sensors')
    %title([sprintf('Mean %.1f',mean(o.Gain.dac.withMagnet)) '\pm' sprintf('%.1f',std(o.Gain.dac.withMagnet))], 'interpreter', 'tex')
    %title([sprintf('Mean %.1f',mean(o.Gain.dac.noMagnet)) '\pm' sprintf('%.1f',std(o.Gain.dac.noMagnet))], 'interpreter', 'tex')
    
    %save2pdf(       [SaveDataPath{i}{2} o.run.id '-hist-DACgain.pdf'], gcf, 600)
    save2jpg_report([o.Paths.save.chip '/' o.run.id '-hist-ReadNoise.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-hist-ReadNoise.fig']);
    
    close(h)
catch err
    disp(err.identifier)
    disp('Error in plotting Read noise histogram')
end

% Plotting heat stdM
try
    h= figure;
    imagesc(reshape(stdM,1024,o.chip.number_of_rows)',[0 500]);
    colorbar
    title('Read Noise')
    xlabel('Columns')
    ylabel('Rows')
    %QAFigureFormat(gcf,gca)
    save2jpg_report([o.Paths.save.chip '/' o.run.id '-heatmap-ReadNoise.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-heatmap-ReadNoise.fig']);
    close(h)
catch err
    disp(err.identifier)
    disp('Error in plotting Read noise heatmap')
end





end
