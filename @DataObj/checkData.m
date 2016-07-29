function o = checkData(o)

    
    % Check for the existence of folders and files
    % Created by Amin 3/8/2016
    
    runCheck = [];
    if exist(o.Paths.load.root, 'dir')
        runCheck.InNAS = 1;
    else
        runCheck.InNAS = 0;
    end

    h5List = dir(fullfile(o.Paths.load.raw, '*.h5'));
    runCheck.UniqueH5_FileSizes = unique([h5List.bytes]');
    runCheck.NumberOfH5_Files = size(h5List,1);
    
    TD = dir(fullfile(o.Paths.load.calibration,'*_algo1_gainCalc.h5'));
    runCheck = UpdateStruct(TD,runCheck, 'algo0_algo0first_bathtub');

    TD = dir(fullfile(o.Paths.load.calibration,'*_algo1_algo1twoStaged_bathtub.h5'));
    runCheck = UpdateStruct(TD,runCheck, 'algo1_algo1twoStaged_bathtub');

    TD = dir(fullfile(o.Paths.load.calibration,'*_algo1_gainCalc.h5'));
    runCheck = UpdateStruct(TD,runCheck, 'algo1_gainCalc');

    TD = dir(fullfile(o.Paths.load.calibration,'*algo1_bathtub.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'algo1_bathtub');

    TD = dir(fullfile(o.Paths.load.metadata,'*chipTemperatures.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'chipTemperatures');

    TD = dir(fullfile(o.Paths.load.metadata,'*chipVoltages.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'chipVoltages');

    TD = dir(fullfile(o.Paths.load.metadata,'*controlboardMetadata.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'controlboardMetadata');

    TD = dir(fullfile(o.Paths.load.metadata,'*flowrate.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'flowrate');

    TD = dir(fullfile(o.Paths.load.metadata,'*systemPressures.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'systemPressures');

    TD = dir(fullfile(o.Paths.load.metadata,'*systemTemperatures.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'systemTemperatures');

    TD = dir(fullfile(o.Paths.load.metadata,'*systemVoltages.csv'));
    runCheck = UpdateStruct(TD,runCheck, 'systemVoltages');

    %TD = dir(fullfile(o.Paths.load.metadata,'*_algo1_BubbleDetect_bathtub.csv'));
    %runCheck = UpdateStruct(TD,runCheck, 'algo1_BubbleDetect_bathtub');

    %Check if okay for pipeline
    CSpipeline = runCheck.InNAS + ...
    runCheck.algo0_algo0first_bathtub + ...
    runCheck.algo1_algo1twoStaged_bathtub + ...
    runCheck.algo1_gainCalc + ...
    runCheck.chipTemperatures + ...
    runCheck.chipVoltages + ...
    runCheck.controlboardMetadata + ...
    runCheck.flowrate + ...
    runCheck.systemPressures + ...
    runCheck.systemTemperatures + ...
    runCheck.systemVoltages + ...
    runCheck.algo1_bathtub;
    %runCheck.algo1_BubbleDetect_bathtub + ...
    

    if CSpipeline == 12 
        runCheck.sanityCheck = 1;
    else
        runCheck.sanityCheck = 0;
    end

    o.dataCheck = runCheck;

    TableDataCheck = {   
        'UniqueH5 FileSizes'                num2str(size(runCheck.UniqueH5_FileSizes,1))     ''
        'Number of H5 files'                num2str(runCheck.NumberOfH5_Files)               ''
        'algo0 algo0first bathtub'          num2str(runCheck.algo0_algo0first_bathtub)       ''
        'algo1 algo1twoStaged bathtub'      num2str(runCheck.algo1_algo1twoStaged_bathtub)   ''
        'algo1 gainCalc'                    num2str(runCheck.algo1_gainCalc)                 '' 
        'chipTemperatures'                  num2str(runCheck.chipTemperatures)               ''    
        'chipVoltages'                      num2str(runCheck.chipVoltages)                   ''    
        'controlboardMetadata'              num2str(runCheck.controlboardMetadata)           ''    
        'flowrate'                          num2str(runCheck.flowrate)                       ''    
        'systemPressures'                   num2str(runCheck.systemPressures)                ''    
        'systemTemperatures'                num2str(runCheck.systemTemperatures)             ''    
        'systemVoltages'                    num2str(runCheck.systemVoltages)                 ''    
        %'algo1 BubbleDetect bathtub'        num2str(runcheck.parse.algo1_BubbleDetect_bathtub)     ''    
        'algo1 bathtub'                     num2str(runCheck.algo1_bathtub)                  ''
        'algo1 gainCalc'                    num2str(runCheck.algo1_gainCalc)                 ''             
        };
    
    TexfileName = fullfile(o.Paths.save.screening, [o.run.id, '-DataCheck.tex']);
    PrintTablePipe(TableDataCheck(:,1:2), TexfileName);
    
end

function STUD = UpdateStruct(TD,STUD, FieldName)

    if ~isempty(TD)
        STUD.(FieldName) = 1;
    else
        STUD.(FieldName) = 0;
    end
end
