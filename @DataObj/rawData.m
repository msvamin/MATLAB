function o = rawData(o)
% Loads the sensor chip data
% Modified by Amin for runQA Data Object

sensorRead_path = o.Paths.load.raw;

range_perc = 0.99;
maxNumberOfReads = 10000;
checkSatReads = 0;

sensorRead_struct = struct;

try
    D = dir(fullfile(sensorRead_path, '*.h5'));
    hinfo = h5info(fullfile(sensorRead_path, D(1).name));
catch ME;
    ME.getReport
    return
end


numReads = min(numel(D), maxNumberOfReads);
numPhases = length(hinfo.Datasets);
numSamplesPerRead = hinfo.Datasets(1).Dataspace.Size(1);
numSensors = hinfo.Datasets(1).Dataspace.Size(2);
readSize = [numPhases, numSensors, numSamplesPerRead];

for i = 1:numPhases
    phases_name{i} = hinfo.Datasets(i).Name;
end

for j=1:numPhases,
    sensorRead_struct.phases(j, 1)=str2double(hinfo.Datasets(j).Name);
end

X=zeros(numSensors, numSamplesPerRead, numReads, 'int16');

if numPhases >2
    Xq = X;
else
    Xq = [];
end

datasetNames = {hinfo.Datasets(:).Name};

fprintf('Importing sensor reads ... ');
tic;
parfor i=1:numReads,
    if rem(i,100) == 0
        disp(i);
    end
    readTry = 1;
    while(readTry)
        try
            [x, xq] = tryToRead(numPhases, D(i).name, sensorRead_path, datasetNames, ...
                i < min(numReads, checkSatReads), range_perc, readSize);
            readTry = 0;
        catch ME
            disp(['Failed to load H5 file, try number ' num2str(readTry)]);
            readTry = readTry+1;
            pause(5);
            %             break;
        end
        if(readTry>10)
            disp(['Potential file corruption on file number ' num2str(i)]);
            disp(D(i).name);
            run_id = sensorRead_path(14:end-11);
            %             storeExperimentState(run_id,'9','-1','99');
            attempts = 1;
            disp('Trying to load in previous file.');
            while attempts
                try
                    [x, xq] = tryToRead(numPhases, D(i-1).name, sensorRead_path, datasetNames, ...
                        i < min(numReads, checkSatReads), range_perc,readSize);
                    attempts = 0;
                    readTry = 0;
                catch
                    disp(['Failed to load backup H5 file, try number ' num2str(attempts)]);
                    attempts = attempts + 1;
                    pause(5);
                end
                if attempts > 10
                    disp('Giving up on loading in data, zero filling.')
                    x = zeros(readSize(2:3));
                    xq = zeros(readSize(2:3));
                    readTry = 0;
                    attempts = 0;
                end
            end
            %Change the state in database
        end
    end
    
    X(:,:,i) = x;
    Xq(:,:,i) = xq;
end

disp(['Load time = ' num2str(toc) ' seconds']);

%close(w);

%% Indexing
%number_of_sensors = size(M,2);
nCols = 1024;
number_of_rows = numSensors/nCols;
%number_of_sample_per_read = size(M,3); % Should CHANGE!
%number_of_reads = size(M,4);
number_of_samples = numSamplesPerRead * numReads;

fprintf([num2str(free_mem),'GB of memory is still available \n']);
X = reshape(X, numSensors, number_of_samples);
if ~isempty(Xq)
    Xq = reshape(Xq, numSensors, number_of_samples);
end
%% Reshape M
% M = reshape(single(M),numPhases,numSensors,number_of_samples);

%% function output
o.ReadsConfig.number_of_sensors = numSensors;
o.ReadsConfig.number_of_rows = number_of_rows;
o.ReadsConfig.number_of_samples = number_of_samples;
o.ReadsConfig.number_of_phases = numPhases;    
o.ReadsConfig.number_of_reads = numReads;
o.ReadsConfig.Phases = phases_name;

o.MI = X;
o.MQ = Xq;
o.M = [];

end

function [x, xq] = tryToRead(numPhases, fileName, sensorPath, dsetnames, ...
    checkSatReads, range_perc, readSize)

[~, fname, ext] = fileparts(fileName);
m=zeros(readSize, 'int16');
for j=1:numPhases
    read=int16(h5read(fullfile(sensorPath, [fname ext]),['/',dsetnames{j}])');
    if checkSatReads
        read(abs(read)>range_perc*(2^14))=NaN;  % only make the reads at the begining to be NAN. All others are saturated values.
    end
    m(j,:,:) = read;
end
if numPhases == 2
    x = m(1,:,:) - m(2,:,:);
    xq = [];
elseif numPhases == 4
    x = m(1,:,:) - m(3,:,:);
    xq = m(2,:,:) - m(4,:,:);
else
    error('Unsupported number of phases while trying to read HDF5 files.');
end
end
    