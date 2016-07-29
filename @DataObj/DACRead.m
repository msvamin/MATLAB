function o = DACRead(o)

try
    dataRoot = o.Paths.load.root;
    [~, files] = findCalibrationTiming(dataRoot);
    %output = importMultipleDACRead(files.other);
    calibFilePaths = files.other;
catch
    DACRead_path = o.Paths.load.calibration;
    d=dir(fullfile(DACRead_path, '*twoStaged_bathtub.h5')); % List of all HDF file related to sensor reads    
    for k=1:length(d)
        calibFilePaths{k} = fullfile(DACRead_path, d(k).name);
    end
            
end

% d=dir(fullfile(DACRead_path, '*twoStaged_bathtub.h5')); % List of all HDF file related to sensor reads
% hinfo=h5info(fullfile(DACRead_path, d(1).name));
hinfo=h5info(calibFilePaths{1});
chip.number_of_phases=length(hinfo.Groups);

clear sensorRead_struct
for j=chip.number_of_phases:-1:1,
    fprintf('.');
    sensorRead_struct.phases(j)=str2num(hinfo.Groups(j).Name(2:4));
    adc_value=[];dac_value=[];idac=[];
    for k=1:numel(calibFilePaths),
        file = calibFilePaths{k};
        Adc_value = single(h5read(file, [hinfo.Groups(j).Name,'/adc_value']))';
        Dac_value = single(h5read(file, [hinfo.Groups(j).Name,'/dac_value']))';
        if k==1,
            size_dac=size(Adc_value,2);
            adc_value=Adc_value;
            dac_value=Dac_value;
        else
            size_dac=min(size(Adc_value,2),size_dac);
            adc_value = [adc_value(:,1:size_dac);Adc_value(:,1:size_dac)];
            dac_value = [dac_value(:,1:size_dac);Dac_value(:,1:size_dac)];
        end
        
        idac = [idac;single(h5read(file, [hinfo.Groups(j).Name,'/idac']))'];
    end
    [q,w] = sort(idac(:,1));
    sensorRead_struct.dac(j,:) = idac(w,2);
    sensorRead_struct.dac_value(j,:,:) = dac_value(w,2:end);
    sensorRead_struct.adc_value(j,:,:) = adc_value(w,2:end);
end
chip.row=ceil(idac(w,1)/1024);
chip.col=mod(idac(w,1)-1,1024)+1;
sensorRead_struct.unique_dac = unique(sensorRead_struct.dac_value);

% Gain.dac=dac_signed(1,:)-dac_signed(end/2+1,:);
% Gain.dacI=dac_signed(1+end/4,:)-dac_signed(3*end/4+1,:);
% sensorRead_struct.Gain=Gain;

chip.number_of_sensors = size(adc_value,1);
chip.number_of_rows = chip.number_of_sensors/1024;
chip.number_of_read_dacs = length(sensorRead_struct.unique_dac)';

%sensorRead_struct.chip = chip;
%%
% Indexing
sensors_index = 1:chip.number_of_sensors;
sensors_index_row = ceil(sensors_index / 1024);
sensors_index_column = mod(sensors_index - 1, 1024) + 1;
sensors_index_AFE = ceil(sensors_index_column / 4);

% AFE indexing

% upper half
for afe_number=1:256,
    AFE = 4*(afe_number-1);
    increment = 4;
    AFEs.upper(afe_number).index = [];
    for i = 1:chip.number_of_rows/2,
        AFEs.upper(afe_number).index = [AFEs.upper(afe_number).index ((i-1)*1024 + AFE + 1):((i-1)*1024 + AFE + increment)]; % 5 to plot one extra column
    end
end

% lower half
for afe_number=1:256,
    AFE = 4*(afe_number-1);
    AFE=512*chip.number_of_rows+AFE;
    increment = 4;
    AFEs.lower(afe_number).index = [];
    for i = 1:chip.number_of_rows/2,
        AFEs.lower(afe_number).index = [AFEs.lower(afe_number).index ((i-1)*1024 + AFE + 1):((i-1)*1024 + AFE + increment)]; % 5 to plot one extra column
    end
end

sensorRead_struct.AFEs = AFEs;

o.MultipleDACRead = sensorRead_struct;

chip.NB = (mod(chip.row,32)==0)|(mod(chip.row,32)==1)|(mod(chip.col,32)==0)|(mod(chip.col,32)==1)|(mod(chip.col,32)==2);
o.chip = chip;
end
