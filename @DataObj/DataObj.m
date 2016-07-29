classdef DataObj  < handle
    % This class defines a run object. This is built off of wrapdataMAT by
    % Max Greenfeld Feb-March 2015. It is used for parallel processing
    % development of runs.
    % Modified by Amin July-August 2015: some of the properties and methods
    % are modified
    
    properties
        M               % Raw signal of sensors
        MI              % I-mode
        MQ              % Q-mode
        SampleSensors   % Sample sensors
        stdM            % Standard deviation of raw signal
        run             % Run information
        Config          % RunQA Config
        dataCheck       % Data Check Result
        Reads           % Def by Arman
        chip            % Chip related information
        MultipleDACRead % DAC reads        
        ReadsConfig     % The structure of sensor reads
        Gain            % Gains
        ChipTemp        % Chip temperature signals
        ChipVoltage     % Chip voltage signals
        SysTemp         % System temperature signals
        FlowSensor      % Flow rates
        ValveState      % Valve states
        SysPressure     % System pressures
        SysVoltage      % System voltages
        ScriptCommands  % Commands of scriptHandler.log
        ReadTimeStamp   % Time stamps
        ReadIndProp     % Aligned Time stamps
        IndMask         % Mask index
        windowIdx       % Windowing index
        MachineStates   % Machine states extracted from scriptHandler.log
        DataAligned     % Data Digest object
        Paths           % Paths for loading and writing data
        Tables          % Spec and stats tables
        Mask            % Windowing object
    end
    
    methods
        
        % Loading functions
        o = getRunInf(o, run_id)        % Gets the Run info from database
        o = setPaths(o)                 % Set the load and save paths
        o = checkData(o)                % Check the data
        o = rawData(o)                  % Loads sensors reads
        o = chooseSensors(o)            % Chooses random sensors and calculates average
        o = DACRead(o)                  % Imports chip realted information
        o = SensorsCalc(o)            % Picking some sample sensors
        %output = bathtub_adaptive_dac_analysis(o, input )
        o = GenReads(o)                 % (Modified by Amin)
        o = GainCalc(o)                 % Gain Calculation
        o = MachineStatesParse(o)       % Extract machine states from script log
        o =  instrumentData(o)          % Loads the instrument and Chip Data
        o = FilterInstData(o, params)   % Filters instrument signals
        o = createMask(o, varargin)     % Creates mask and windowing
        o = DataDigest(o, params)       % Creates Data Digest object
        o = SumStats(o)                 % Calculates the statistics
        o = SpecsTest(o)                % Do the spec tests
        o = dailyRinseReport(o, load_flag) % Daily Rinse Report generation
        % Plotting functions
        o = PlotInstData(o)             % Plots the instrument signals
        o = PlotADC(o)                  % Plots the ADC hist and heatmap
        o = PlotSampleSensors(o)        % Plots sample sensors
        o = PlotPanels(o)               % Plots the panels
        o = PlotPanel1(o)               % Plots the panel 1
        o = PlotPanel2(o)               % Plots the panel 2
        o = PlotPanel3(o)               % Plots the panel 3
        o = PlotPanel4(o)               % Plots the panel 4
        o = PlotAvgSignal(o)            % Plots the average signal
        o = PlotDACGain(o)              % Plots DAC Gain
        o = BubbleMovie(o)              % Generates bubble movie
        o = ChipTempHist(o)             % Plots the hist of chip temps
        o = postRunState(o, expStListId, stateId, userId)   % Store the Run State into the cloud database
        
        function o = DataObj(M)
            if nargin == 1,
                o(M) = DataObj;
            end
        end
        
        function o = construct(o, id, varargin)
            
            %o.Config = config;
            
            % Getting run Information
            o.run.id = id;
            o.postRunState('7','1','77');
            
            % Hack waiting
            if strcmp(o.Config.PipeMode, 'auto')
                disp('Hack waiting...');
                pause(900);
            end
            
            o.getRunInf(id);
            o.run.ReadType = '';
            o.run.template = '';
            o.run.primer = '';
            
            % Setting the load and save paths
            o.setPaths;
            
            % Check Data
            o.checkData;
            
            if ~o.dataCheck.sanityCheck
                o.postRunState('7','-1','77');
                error('The data for this experiment is not complete and the runQA analysis is not possible!')
            end
            o.postRunState('7','2','77');
            %=========================================
            % Loading Data
            %=========================================
            try
                disp('Loading raw data...')
                o.rawData; 
            catch
                disp('Error in loading raw data!')
            end
            try
                disp('Loading instrument data...')
                o.instrumentData;
            catch
                disp('Error in loading instrument data!')
            end
            try
                disp('Windowing...')
                o.createMask;
            catch
                disp('Error in windowing!')
            end
%             try
%                 disp('Filtering instrument data...')
%                 o.FilterInstData;
%             catch
%                 disp('Error in filtering instrument data!')
%             end            
            try
                disp('Checking for Rinse info in script...')
                o.dailyRinseReport(false);
                disp('Rinse data table was created')
            catch
                disp('There is no Rinse data in the script!')
            end
                
            try
                disp('Loading Chip Info...')
                o.DACRead;
            catch
                disp('Error in loading Chip Info!')
            end            
            try
                disp('Sample Sensors...')
                o.SensorsCalc;
            catch
                disp('Error in Sample Sensors!')
            end
            try
                disp('Parsing machine states...')
                o.MachineStatesParse;
            catch
                disp('Error in parsing machine states')
            end
            try
                disp('Generate Reads...')
                o.GenReads;
            catch
                disp('Error in GenReads!')
            end
            try
                disp('Gain calculation...')
                o.GainCalc;
            catch
                disp('Error in Gain Calculation!')
            end

            try
                disp('Loading times...')
                o.ScriptTimes;
            catch
                disp('Error in loading times!')
            end

            try
                disp('Data digest...')
                o.DataDigest;
            catch
                disp('Error in data digest!')
             end
            
            try
                disp('Spec Tests...')
                o.SpecsTest;
            catch
                disp('Error in Spec Tests!')
            end
            
            try
                disp('Uploading stats to database...')
                o.SumStats;
            catch
                disp('Error in uploading stats into database!')
            end
            o.postRunState('7','3','77');

        end
        
    end
    
end
