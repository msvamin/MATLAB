
% The runQA wrapper for pipeline
% Created by Amin Mousavi 3/2/2016

% Adding paths
addpath(genpath('/opt/postprocess/src'))
javaaddpath('/opt/postprocess/src/lib/httpcore-4.2.jar')
javaaddpath('/opt/postprocess/src/lib/httpclient-4.2.jar')

import org.apache.http.impl.client.DefaultHttpClient.*
import org.apache.http.client.methods.HttpPost.*
import org.apache.http.entity.StringEntity.*

% Loading the runQA config
config_Path = which('runQAconfig.json');
config = loadjson(config_Path);

% Creating a log file
[aa,bb] = system('uname -a | cut -f2 -d" "');
MATserver = bb(1:end-1);
runQAlog = fopen(fullfile(config.Paths.save.root, config.Paths.log, [MATserver '--' datestr(now, 'yyyy mmmm dd HH MM SS') '-runQAjob.log']),'w');
fprintf(runQAlog,'%s %s %s | %s | %s \n','Starting The runQA job in', config.PipeMode, 'mode', MATserver, datestr(now) );

% Getting the RunList for Batch Mode
RunList = {};
if strcmp(config.PipeMode, 'batch')
    RunList = config.RunList;
end

while ~isempty(RunList) || strcmp(config.PipeMode,'auto') ;

    close all
    
    % Getting the Run ID
    switch config.PipeMode
        case 'auto'
            DaysInterval = 3;
            RunIds = getRunList(DaysInterval, config);
            TempRuns = unique(RunIds);
            if ~isempty(TempRuns)
                run_id = TempRuns{datasample(1:length(TempRuns),1)};
                %run_id = TempRuns{1};
                display(run_id)
            else
                disp('Waiting ...')
                pause(300)
                disp('Starting again ...')
                continue;
            end
        case 'batch'
            run_id = RunList{1};
            display(run_id)
            RunList(1) = [];      
    end
    
    fprintf(runQAlog,'\n \n Starting analysis of %s\n',run_id);
    
    dataWrapper = DataObj;
    dataWrapper.Config = config;
    try
        dataWrapper.getRunInf(run_id);
        if strcmp(dataWrapper.run.Type,'Daily Rinse')
            % The analysis for Daily Rinse Runs
            dataWrapper.dailyRinseReport(true);
            continue;
        end
    catch
    end
    
    %Starting analysis
        
    if config.Initialization
        stime = now;
        try
            disp('Initializing ...');
            fprintf(runQAlog,'\n Initializing ...');
            %dataWrapper = DataObj;
            dataWrapper.construct(run_id)
            %Initilizing done
            disp('Initialization OKAY');
            fprintf(runQAlog,'\n Initialization OKAY');           

        catch err
            disp('Initialization ERROR')
            disp(err.identifier)
            fprintf(runQAlog,'\n %s',err.identifier);            
            fprintf(runQAlog,'\n Initialization ERROR');
            continue;
        end
        
    end
    
    if config.Plotting
        stime = now;
        try
            disp('Generating runQA plots ...');
            fprintf(runQAlog,'\n Generating runQA plots ...');
            %runQA plots
            try
                disp('Panel1 plotting...')
                dataWrapper.PlotPanel1;
            catch
                disp('Error in panel1 plotting!')
            end
             try
                disp('Panel2 plotting...')
                dataWrapper.PlotPanel2;
            catch
                disp('Error in panel2 plotting!')
             end
             try
                disp('Panel3 plotting...')
                dataWrapper.PlotPanel3;
            catch
                disp('Error in panel3 plotting!')
             end
             try
                disp('Panel4 plotting...')
                dataWrapper.PlotPanel4;
            catch
                disp('Error in panel4 plotting!')
            end           
            try
                disp('Instrument data plotting...')
                dataWrapper.PlotInstData;
            catch
                disp('Error in instrument data plotting!')
            end
             try
                disp('Plotting the histograms for chip temperatures...')
                dataWrapper.ChipTempHist;
            catch
                disp('Error in plotting the histograms for chip temperatures!')
            end             
%             try
%                 disp('ADC plotting...')
%                 
%                 dataWrapper.PlotADC;
%             catch
%                 disp('Error in ADC plotting!')
%             end
            try
                disp('Sample sensors plotting...')
                dataWrapper.PlotSampleSensors;
            catch
                disp('Error in sample sensors plotting!')
            end
            try
                disp('DAC Gain plotting...')
                dataWrapper.PlotDACGain;
            catch
                disp('Error in DAC Gain plotting!')
            end
            
            dataWrapper.postRunState('7','4','77');
            
            disp('Generate runQA plots OKAY');
            fprintf(runQAlog,'\n Generate runQA plots OKAY');
        catch err
            disp('Generate runQA plots ERROR')
            disp(err.identifier)
            fprintf(runQAlog,'\n %s',err.identifier);            
            fprintf(runQAlog,'\n Generate runQA plots ERROR');
        end
    end
    
    % PAUL - 13 Nov 2015
    %
    % Adding back in bubble detect movies!
    
    if config.BubbleMovie
        try
            disp('Generating Bubble Movie...');
            fprintf(runQAlog,'\n Generating Bubble Movie...');
            dataWrapper.BubbleMovie;
            dataWrapper.postRunState('7','5','77');
            fprintf(runQAlog,'\n Generating Bubble Movie OKAY');
        catch err
            disp('Generate Bubble Movie ERROR')
            disp(err.identifier)
            fprintf(runQAlog,'\n %s',err.identifier);            
            fprintf(runQAlog,'\n Generate Bubble Movie ERROR');
            
        end
    end
    
    %try to print report
    if config.Report
        try
            try
                PrintRunReport(dataWrapper.run.beta,dataWrapper.run.id,{'/NAS'})
            catch
            end
            if exist(fullfile('/NAS',dataWrapper.run.beta,dataWrapper.run.id,'result',[ run_id '-RunReportRev5.pdf']), 'file')
                %pdfreport has been generated
                dataWrapper.postRunState('7','6','77');
                disp('pdf Report OKAY');
                fprintf(runQAlog,'\n pdf Report OKAY');
            else
                disp('pdf Report ERROR');
                fprintf(runQAlog,'\n pdf Report ERROR');
            end
            
        catch err
            fprintf(runQAlog,'\n %s',err.identifier);            
            fprintf(runQAlog,'\n ERROR in PrintRunReport');
        end
    end
    
    if config.ClearBigData
        if exist('dataWrapper', 'var')
            dataWrapper.M = [];
            dataWrapper.MQ = [];
            dataWrapper.MI = [];
            save(fullfile(dataWrapper.Paths.save.screening,[dataWrapper.run.id, '-wrap.mat']), 'dataWrapper')
            disp('Save dataWrapper object OKAY');
            fprintf(runQAlog,'\n Save dataWrapper object OKAY');
            clear dataWrapper;
            disp('dataWrapper DELETED');
            fprintf(runQAlog,'\n dataWrapper DELETED');
        end
    end
    
    close all;
end



