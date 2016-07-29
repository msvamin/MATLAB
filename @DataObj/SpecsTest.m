function o = SpecsTest(o)
    
% This function loads the json Spec Sheet do the tests and report the result as a table
% by Amin Mousavi    12/22/2015

    Tables = struct;
    % Loading the Specs Sheet
    SpecSheet_Path = which('betaV3specs.json');
    Specs_Value = loadjson(SpecSheet_Path);

    row = 1;
    row2 = 1;
    specTable(row,:) = {'Parameter'  'Units'   'Test Type'   'Test Window'   'Target Value'   'Fail PBHW'      'Warning PBHW'   'Score'};
    statTable(row2,:) = {'Parameter'   'Units'   'Windowing'   'Mean'   'Std'   'Min'   'Max'};
    spT = {};
    % Looping over different sensors
    for i = 1:length(Specs_Value.Sensor)
        
        % Check if there is a field for the sensor
        if ~isempty(Specs_Value.Sensor{i}.Field)
            
            % Tags for accessing the data in MATLAB obj
            field_tags = Specs_Value.Sensor{i}.Field;
            % Extracting the data
            sensor_data = o;
            for j = 1:length(field_tags)
                sensor_data = sensor_data.(field_tags{j});
            end
            Units = Specs_Value.Sensor{i}.Units;
            
            if ~isempty(Specs_Value.Sensor{i}.Test)
                % Spec Tests for the Sensor Data
                specTests = Specs_Value.Sensor{i}.Test;
                for k = 1:length(specTests)
                    switch specTests{k}.TargetType
                        case 'NumericTarget'
                            tgValue = str2double(specTests{k}.TargetValue);
                            testType = 'Numeric Test';
                        case 'MeanTarget'
                            %tgValue = mean(sensor_data);
                            testType = 'Mean Test';
                        otherwise
                            continue;
                    end
                        
                    WarnPBHW = str2double(specTests{k}.WarningPBHW);
                    FailPBHW = str2double(specTests{k}.FailPBHW);                    
                    testWin = specTests{k}.TestWindow;
                    % Use appropriate windowing to do the test
                    switch testWin
                        % Instrument Windowing
                        case 'Instrumentation'
                            maxVal = max(sensor_data(o.Mask.xrange(1):o.Mask.xrange(end)));
                            minVal = min(sensor_data(o.Mask.xrange(1):o.Mask.xrange(end)));
                            meanVal = mean(sensor_data(o.Mask.xrange(1):o.Mask.xrange(end)));
                            stdVal = std(sensor_data(o.Mask.xrange(1):o.Mask.xrange(end)));
                        % Sequencing Windowing
                        case 'Sequencing'
                            maxVal = max(sensor_data(o.Mask.xrange));
                            minVal = min(sensor_data(o.Mask.xrange));
                            meanVal = mean(sensor_data(o.Mask.xrange));
                            stdVal = std(sensor_data(o.Mask.xrange));
                        % Full Signal
                        case 'Full'
                            maxVal = max(sensor_data);
                            minVal = min(sensor_data);
                            meanVal = mean(sensor_data);
                            stdVal = std(sensor_data);
                    end
                    
                    if strcmp(testType, 'Mean Test')
                        tgValue = meanVal;
                    end
                    
                    % Spec Test
                    testScore = '{\color{red}FAIL}';
                    tS = 'FAIL';
                    if (maxVal < tgValue+FailPBHW) && (maxVal > tgValue-FailPBHW) &&...
                          (minVal < tgValue+FailPBHW) && (minVal > tgValue-FailPBHW) 
                        testScore = '{\color{orange}WARNING}';
                        tS = 'WARNING';
                    end
                    if (maxVal < tgValue+WarnPBHW) && (maxVal > tgValue-WarnPBHW) &&...
                          (minVal < tgValue+WarnPBHW) && (minVal > tgValue-WarnPBHW) 
                        testScore = '{\color{green}PASS}';
                        tS = 'PASS';
                    end
                      
                    row = row + 1;
                    specTable(row,:) = {Specs_Value.Sensor{i}.FullName   Units   testType    ...
                        testWin     sprintf('%.2f',tgValue) ... %num2str(tgValue) ...
                        specTests{k}.FailPBHW      specTests{k}.WarningPBHW   testScore};
                    spT(row-1,:) = {Specs_Value.Sensor{i}.FullName   testType    ...
                        testWin     sprintf('%.2f',tgValue) ... %num2str(tgValue) ...
                        specTests{k}.FailPBHW      specTests{k}.WarningPBHW   tS};
                        %[num2str(tgValue-FailPBHW) ' to ' num2str(tgValue+FailPBHW)] ...
                        %[num2str(tgValue-WarnPBHW) ' to ' num2str(tgValue+WarnPBHW)] ...
                        %testScore};
                        %[sprintf('%.4f',round(tgValue-FailPBHW,4)) ' to ' sprintf('%.4f',round(tgValue+FailPBHW,4))] ...
                        %[sprintf('%.4f',round(tgValue-WarnPBHW,4)) ' to ' sprintf('%.4f',round(tgValue+WarnPBHW,4))] ...
                    if ~(strcmp(statTable(row2,1),Specs_Value.Sensor{i}.FullName) && strcmp(statTable(row2,3),testWin))
                        row2 = row2 + 1;
                        statTable(row2,:) = {Specs_Value.Sensor{i}.FullName   Units   testWin ...
                            sprintf('%.2f', meanVal)   sprintf('%.6f', stdVal) ...
                            sprintf('%.2f', minVal)   sprintf('%.2f', maxVal)};
                            %num2str(meanVal)   num2str(stdVal)   num2str(minVal)   num2str(maxVal)};
                    end
                        
                end
                
            end
        end
    end
    
    % Saving the tables csv files
    fid = fopen(fullfile(o.Paths.save.screening,[o.run.id '-SpecTable.csv']),'w');
    for j = 1:size(specTable,1)
        fprintf(fid, '%s,', specTable{j,1:end-1});
        fprintf(fid,'%s\n',specTable{j,end}); 
    end
    fclose(fid);

    fid = fopen(fullfile(o.Paths.save.screening,[o.run.id '-StatTable.csv']),'w');
    for j = 1:size(statTable,1)
        fprintf(fid, '%s,', statTable{j,1:end-1});
        fprintf(fid,'%s\n',statTable{j,end}); 
    end
    fclose(fid);
    
    % Create a tex file for the pdf report
    PrintTablePipe(specTable, fullfile(o.Paths.save.screening,[o.run.id '-TableRunSpecs.tex']));
    PrintTablePipe(statTable, fullfile(o.Paths.save.screening,[o.run.id '-TableRunStats.tex']));
    Tables.specs = specTable;
    Tables.stats = statTable;
    o.Tables = Tables;
    
    % Add the REST calling here
    for i = 1:length(spT)
        o.postRunSpecs(spT(i,:));
    end
    
end

