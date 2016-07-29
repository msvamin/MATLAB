
function o = PlotADC(o)

% ADC Plots
% Extracted from runQAreport
% Amin Mousavi 4/15/2015

adc_value = o.MultipleDACRead.adc_value;
adc_value_I = squeeze(adc_value(1,:,:));
[~, adc_ind] = min(abs(adc_value_I'));
adc_I=[];
for i=1:length(adc_ind)
    adc_I(i) = adc_value_I(i,adc_ind(i));
end

try
    figure
    histogram(adc_I, 'edgecolor', 'b')
    xlabel('ADC read')
    ylabel('Number of sensors')
    %title([sprintf('Mean %.1f',CRstats.DAC_mean) '\pm' sprintf('%.1f',CRstats.DAC_std)])
    QAFigureFormat(gcf,gca)
    
    %save2pdf(       [SaveDataPath{i}{2} o.run.id '-hist-DACgain.pdf'], gcf, 600)
    save2jpg_report([o.Paths.save.chip '/' o.run.id '-hist-ADCread.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-hist-ADCread.fig']);
catch err
    disp(err.identifier)
end

try
    imagesc(reshape(adc_I,1024,size(adc_value,2)/1024)');
    colorbar
    title('ADC value')
    xlabel('Columns')
    ylabel('Rows')
    QAFigureFormat(gcf,gca)

    save2jpg_report([o.Paths.save.chip '/' o.run.id '-heatmap-ADCread.jpg'],gcf)
    saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-heatmap-ADCread.fig']);
catch err
    disp(err.identifier)
end

try
    adc_value_minus_read = -(min(abs(squeeze(adc_value(1,:,:)))')-single(o.MI(:,1))');    %%%%+o.M(1,:,1)   THIS SHOULD BE FIRST PHASE
catch err
    disp(err.identifier)
end

% try
%     figure
%     hist(adc_value_minus_read)
%     xlabel('First read minus ADC')
%     %title([sprintf('Mean %.1f',CRstats.DAC_mean) '\pm' sprintf('%.1f',CRstats.DAC_std)])
%     QAFigureFormat(gcf,gca)
%     
%     %save2pdf(       [SaveDataPath{i}{2} o.run.id '-hist-DACgain.pdf'], gcf, 600)
%     save2jpg_report([o.Paths.save.chip '/' o.run.id '-hist-FirstReadMinusADC.jpg'],gcf)
%     saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-hist-FirstReadMinusADC.fig']);
% catch err
%     disp(err.identifier)
% end
% 
% try
%     imagesc(reshape(adc_value_minus_read',1024,size(adc_value,2)/1024)');
%     colorbar
%     title('First read minus ADC value')
%     QAFigureFormat(gcf,gca)
%     save2jpg_report([o.Paths.save.chip '/' o.run.id '-heatmap-FirstReadMinusADC.jpg'],gcf)
%     saveas(gcf,     [o.Paths.save.chip '/' o.run.id '-heatmap-FirstReadMinusADC.fig']);
% catch err
%     disp(err.identifier)
% end

close all
end

