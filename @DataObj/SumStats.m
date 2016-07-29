function o = SumStats(o)

stdM = nanstd(single(o.MI(:,o.windowIdx))');
CRstats.stdM_mean = nanmean(stdM);
CRstats.stdM_std = nanstd(stdM);
%o.stdM.mean = CRstats.stdM_mean;
%o.stdM.std = CRstats.stdM_std;
o.stdM = stdM;

try
    CRstats.runQAversion = '';
    CRstats.parserversion = '';
    CRstats.beta = o.run.beta;
    CRstats.id = o.run.id;
    CRstats.Analyte = o.run.Analyte;
    %CRstats.chip_type = o.run.chip_type;
    %CRstats.ReagentPack = o.run.runoff;
    CRstats.Operator = o.run.Operator;
    CRstats.Start_idx = o.windowIdx(1);
    CRstats.End_idx = o.windowIdx(end);
    CRstats.numReads = o.ReadsConfig.number_of_reads;
    CRstats.number_of_phases = o.chip.number_of_phases;
    CRstats.number_of_sensors = o.chip.number_of_sensors;
    CRstats.number_of_rows = o.chip.number_of_rows;
    CRstats.number_of_read_dacs = o.chip.number_of_read_dacs;
    CRstats.number_of_samples = o.ReadsConfig.number_of_samples;
    CRstats.ConfigName = o.run.ConfigName;
    CRstats.ScriptName = o.run.ScriptName;
    CRstats.Descrip = o.run.Descrip;
    CRstats.Type = o.run.Type;
catch exception
    DispError = ['runQAreport: Loading dataWrapper information ERROR'];
    disp(exception.identifier);
    disp(exception.message);
    %FunctionErrors = [FunctionErrors; [{exception.identifier} {exception.message}]];
    %storeExperimentException(o.run.id, 'runQAexception', exception.identifier, exception.message, '77');
end

%Calculating the Stats
try
        CRstats.FlowRateMean = o.DataAligned.Flowrate.mean;
        CRstats.FlowRateSTD = sqrt(o.DataAligned.Flowrate.var);
        CRstats.RTDUMean = o.DataAligned.ChipTempRTDU.mean;
        CRstats.RTDUSTD = sqrt(o.DataAligned.ChipTempRTDU.var);
        CRstats.RTDMMean = o.DataAligned.ChipTempRTDM.mean;
        CRstats.RTDMSTD = sqrt(o.DataAligned.ChipTempRTDM.var);
        CRstats.RTDLMean = o.DataAligned.ChipTempRTDL.mean;
        CRstats.RTDLSTD = sqrt(o.DataAligned.ChipTempRTDL.var);
        CRstats.IPTATMean = o.DataAligned.ChipTempIPTAT.mean;
        CRstats.IPTATSTD = sqrt(o.DataAligned.ChipTempIPTAT.var);
        CRstats.PumpPressureMean = o.DataAligned.SysPressurePump.mean;
        CRstats.PumpPressureSTD = sqrt(o.DataAligned.SysPressurePump.var);
        CRstats.CartridgePressureMean = o.DataAligned.SysPressureCartridge.mean;
        CRstats.CartridgePressureSTD = sqrt(o.DataAligned.SysPressureCartridge.var);
        CRstats.ADCVrefMean = o.DataAligned.ChipVoltageADCVref.mean;
        CRstats.ADCVrefSTD = sqrt(o.DataAligned.ChipVoltageADCVref.var);
        CRstats.AFEVrefMean = o.DataAligned.ChipVoltageAFEVref.mean;
        CRstats.AFEVrefSTD = sqrt(o.DataAligned.ChipVoltageAFEVref.var);
        CRstats.RFVHiMean = o.DataAligned.ChipVoltageRFVHi.mean;
        CRstats.RFVHiSTD = sqrt(o.DataAligned.ChipVoltageRFVHi.var);
        CRstats.RFVLoMean = o.DataAligned.ChipVoltageRFVLo.mean;
        CRstats.RFVLoSTD = sqrt(o.DataAligned.ChipVoltageRFVLo.var);

        CRstats.FlowRateMIN = min(o.DataAligned.Flowrate.Reads);
        CRstats.FlowRateMAX = max(o.DataAligned.Flowrate.Reads);
        CRstats.RTDUMIN = min(o.DataAligned.ChipTempRTDU.Reads);
        CRstats.RTDUMAX = max(o.DataAligned.ChipTempRTDU.Reads);
        CRstats.RTDMMIN = min(o.DataAligned.ChipTempRTDM.Reads);
        CRstats.RTDMMAX = max(o.DataAligned.ChipTempRTDM.Reads);
        CRstats.RTDLMIN = min(o.DataAligned.ChipTempRTDL.Reads);
        CRstats.RTDLMAX = max(o.DataAligned.ChipTempRTDL.Reads);
        CRstats.IPTATMIN = min(o.DataAligned.ChipTempIPTAT.Reads);
        CRstats.IPTATMAX = max(o.DataAligned.ChipTempIPTAT.Reads);
        CRstats.PumpPressureMIN = min(o.DataAligned.SysPressurePump.Reads);
        CRstats.PumpPressureMAX = max(o.DataAligned.SysPressurePump.Reads);
        CRstats.CartridgePressureMIN = min(o.DataAligned.SysPressureCartridge.Reads);
        CRstats.CartridgePressureMAX = max(o.DataAligned.SysPressureCartridge.Reads);
        CRstats.ADCVrefMIN = min(o.DataAligned.ChipVoltageADCVref.Reads);
        CRstats.ADCVrefMAX = max(o.DataAligned.ChipVoltageADCVref.Reads);
        CRstats.AFEVrefMIN = min(o.DataAligned.ChipVoltageAFEVref.Reads);
        CRstats.AFEVrefMAX = max(o.DataAligned.ChipVoltageAFEVref.Reads);
        CRstats.RFVHiMIN = min(o.DataAligned.ChipVoltageRFVHi.Reads);
        CRstats.RFVHiMAX = max(o.DataAligned.ChipVoltageRFVHi.Reads);
        CRstats.RFVLoMIN = min(o.DataAligned.ChipVoltageRFVLo.Reads);
        CRstats.RFVLoMAX = max(o.DataAligned.ChipVoltageRFVLo.Reads);  
        CRstats.DAC_mean = mean(o.Gain.dac);
        CRstats.DAC_std = std(o.Gain.dac);
        CRstats.DAC_min = min(o.Gain.dac);
        CRstats.DAC_max = max(o.Gain.dac);
        CRstats.stdM_mean = mean(o.stdM);
        CRstats.stdM_std = std(o.stdM);
catch
    
end

% Flatten Data for CSV
try
    
    FtoSave = {
        'beta'
        'id'
        'Analyte'
        'chip_type'
        'ReagentPack'
        'Operator'
        'runQAversion'
        'parserversion'
        
        'ConfigName'
        'ScriptName'
        'Descrip'
        'Type'
        
        'Start_idx'
        'End_idx'
        'numReads'
        'number_of_phases'
        'number_of_sensors'
        'number_of_rows'
        'number_of_read_dacs'
        'number_of_samples'
        
        'DAC_mean'
        'DAC_std'
        'stdM_mean'
        'stdM_std'
%        'SaturatedSensors'
        
        'FlowRateMean'
        'FlowRateSTD'
        'RTDUMean'
        'RTDUSTD'
        'RTDMMean'
        'RTDMSTD'
        'RTDLMean'
        'RTDLSTD'
        'IPTATMean'
        'IPTATSTD'
        'PumpPressureMean'
        'PumpPressureSTD'
        'CartridgePressureMean'
        'CartridgePressureSTD'
        'ADCVrefMean'
        'ADCVrefSTD'
        'AFEVrefMean'
        'AFEVrefSTD'
        'RFVHiMean'
        'RFVHiSTD'
        'RFVLoMean'
        'RFVLoSTD'
        
%        'SUM_numbubbles'
%        'SUM_MDiams'
%        'SUM_TotAreas'
        
        'FlowRateMIN'
        'FlowRateMAX'
        'RTDUMIN'
        'RTDUMAX'
        'RTDMMIN'
        'RTDMMAX'
        'RTDLMIN'
        'RTDLMAX'
        'IPTATMIN'
        'IPTATMAX'
        'PumpPressureMIN'
        'PumpPressureMAX'
        'CartridgePressureMIN'
        'CartridgePressureMAX'
        'ADCVrefMIN'
        'ADCVrefMAX'
        'AFEVrefMIN'
        'AFEVrefMAX'
        'RFVHiMIN'
        'RFVHiMAX'
        'RFVLoMIN'
        'RFVLoMAX'
%        'P_Open'
%        'saturated_sensors'
%        'P_Short'
%        'DAC_min'
%        'DAC_max'
        };
    
    SumStats = {};
    for i=1:length(FtoSave)
        if isfield(CRstats,FtoSave{i})
            if isempty(getfield(CRstats,FtoSave{i}))
                SumStats = [SumStats [{''}]];
            else
                save_string = getfield(CRstats,FtoSave{i});
                if isnumeric(save_string)
                    save_string = num2str(save_string);
                end
                
                SumStats = [SumStats save_string];
            end
        else
            SumStats = [SumStats [{''}]];
        end
    end
    size(SumStats)
    FNames = fieldnames(CRstats);
    
    c = [FtoSave';SumStats];
    TSaveName =  [o.Paths.save.screening, '/', o.run.id, '-RunSummaryStats.csv'];
    fid = fopen(TSaveName, 'w') ;
        
    fprintf(fid, '%s,', c{1,1:end});
    fprintf(fid, '\n');
    fprintf(fid, '%s,', c{2,1:end});
    fclose(fid);
    
    FlatData.c = c;
%    FlatData.c{105} = 'RTDLMIN';
%    FlatData.c{107} = 'RTDLMAX';

    storeExperimentFeatures_Rev4(FlatData);        
    %Saving to database
    %storeExperimentState(run_id,'7','5','77')

end