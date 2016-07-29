function o = ChipTempHist(o)

    % Plotting the histograms of Chip temperatures for in-cylce and cross-cylce
    nSamples = o.Mask.nSamples;
    nXrange = size(o.Mask.xrange,2);
    nCycles = nXrange/nSamples;
    
    %cycleMask = zeros(nCycles, nXrange);
    RTDL = zeros(nCycles, nSamples);
    RTDM = zeros(nCycles, nSamples);
    RTDU = zeros(nCycles, nSamples);
    IPTAT = zeros(nCycles, nSamples);
    
    for i = 1:nCycles
       RTDL(i,:) = o.ReadIndProp.ChipTemp.RTDL(o.Mask.xrange(1+(i-1)*nSamples:i*nSamples)); 
       RTDM(i,:) = o.ReadIndProp.ChipTemp.RTDM(o.Mask.xrange(1+(i-1)*nSamples:i*nSamples)); 
       RTDU(i,:) = o.ReadIndProp.ChipTemp.RTDU(o.Mask.xrange(1+(i-1)*nSamples:i*nSamples)); 
       IPTAT(i,:) = o.ReadIndProp.ChipTemp.IPTAT(o.Mask.xrange(1+(i-1)*nSamples:i*nSamples)); 
    end
    
    % In-Cycle Average
    avgCycleRTDL = mean(RTDL, 2);
    diffOutCycleRTDL = diff(avgCycleRTDL);
    maxCycleRTDL = max(RTDL, [], 2);
    minCycleRTDL = min(RTDL, [], 2);
    diffInCycleRTDL = maxCycleRTDL - minCycleRTDL;
    
    avgCycleRTDM = mean(RTDM,2);
    diffOutCycleRTDM = diff(avgCycleRTDM);
    maxCycleRTDM = max(RTDM, [], 2);
    minCycleRTDM = min(RTDM, [], 2);
    diffInCycleRTDM = maxCycleRTDM - minCycleRTDM;
    
    avgCycleRTDU = mean(RTDU, 2);
    diffOutCycleRTDU = diff(avgCycleRTDU);
    maxCycleRTDU = max(RTDU, [], 2);
    minCycleRTDU = min(RTDU, [], 2);
    diffInCycleRTDU = maxCycleRTDU - minCycleRTDU;
    
    avgCycleIPTAT = mean(IPTAT, 2);
    diffOutCycleIPTAT = diff(avgCycleIPTAT);
    maxCycleIPTAT = max(IPTAT, [], 2);
    minCycleIPTAT = min(IPTAT, [], 2);
    diffInCycleIPTAT = maxCycleIPTAT - minCycleIPTAT;    

    h = figure;
    set(h,'Color','w')
    set(h,'Position',[1    1   900 600]);
    % Histogram of cross cycle diff of chip temperatures
    subplot(2,2,1)

    %hist(diffOutCycleRTDL)
    histogram(diffOutCycleRTDL, 'FaceColor', 'b')
    xlabel('RTDL')

    subplot(2,2,2)
    %hist(diffOutCycleRTDM)
    histogram(diffOutCycleRTDM, 'FaceColor', 'b')
    xlabel('RTDM')

    subplot(2,2,3)
    %hist(diffOutCycleRTDU)
    histogram(diffOutCycleRTDU, 'FaceColor', 'b')
    xlabel('RTDU')

    subplot(2,2,4)
    %hist(diffOutCycleIPTAT)
    histogram(diffOutCycleIPTAT, 'FaceColor', 'b')
    xlabel('IPTAT')

    plot_file_name = [num2str(o.run.id),'-ChipTempCrossCycleHist.fig'];
    saveas(gcf,[o.Paths.save.metadata, '/', plot_file_name]);
    plot_file_name = [num2str(o.run.id),'-ChipTempCrossCycleHist.png'];
    print('-dpng','-r100',[o.Paths.save.metadata, '/', plot_file_name])

    close(h)
    
    h = figure;
    set(h,'Color','w')
    set(h,'Position',[1    1   900 600]);
    % Histogram of in-cycle max-min of chip temperatures
    subplot(2,2,1)

    %hist(diffInCycleRTDL)
    histogram(diffInCycleRTDL, 'FaceColor', 'b')
    xlabel('RTDL')

    subplot(2,2,2)
    %hist(diffInCycleRTDM)
    histogram(diffInCycleRTDM, 'FaceColor', 'b')
    xlabel('RTDM')

    subplot(2,2,3)
    %hist(diffInCycleRTDU)
    histogram(diffInCycleRTDU, 'FaceColor', 'b')
    xlabel('RTDU')

    subplot(2,2,4)
    %hist(diffInCycleIPTAT)
    histogram(diffInCycleIPTAT, 'FaceColor', 'b')
    xlabel('IPTAT')

    plot_file_name = [num2str(o.run.id),'-ChipTempInCycleHist.fig'];
    saveas(gcf,[o.Paths.save.metadata, '/', plot_file_name]);
    plot_file_name = [num2str(o.run.id),'-ChipTempInCycleHist.png'];
    print('-dpng','-r100',[o.Paths.save.metadata, '/', plot_file_name])

    close(h)
    
end
