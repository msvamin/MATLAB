function o = createMask(o, varargin)
% function mask = createMask(runInfo, varargin)
%
% this function is a wrapper for alignBS2CR_Dev that looks to see if there
% are any NOOP commands in the scripthandler log.  If there are, then it
% calls a different aligner, alignNOOP.
% Modified by Amin to work with runQA  12/18/2015

params = inputParser;
addParameter(params, 'nSamples', 64, @isnumeric);

%Added by Amin
o.IndMask = nan(1,size(o.MI,2));
o.windowIdx = 1:size(o.MI,2);
o.IndMask(o.windowIdx) = 1;

% Generate the path to the experiment

%expPath = fullfile('/NAS', runInfo.beta, runInfo.id);
expPath = o.Paths.load.root;

%scriptPath = fullfile(expPath,[runInfo.id '.scriptHandler.log']);
scriptPath = fullfile(expPath,[o.run.id '.scriptHandler.log']);

fd = fopen(scriptPath, 'r');
str = textscan(fd,'%s'); % just load the whole thing as a string
fclose(fd);

isNOOP = any(strfind([str{1}{:}],'NOOP')); % confusing, but I think it works

isDiscrete = length(strfind([str{1}{:}],'readInParallelOn')) > 2;

if isDiscrete
    nSamples = 32;
else
    nSamples = 64;
end

if isNOOP
    mask = alignNOOP(expPath, scriptPath, ...
        'nSamples', nSamples, ...
        varargin{:});
else
    %mask = alignBS2CR_SPDev(expPath, runInfo.id, ...
    mask = alignBS2CR_SPDev(expPath, o.run.id, ...
        'nSamples', nSamples, ...
        varargin{:});
end

mask.nSamples = nSamples;

% Added by Amin
o.windowIdx = mask.xrange;
o.IndMask = nan(1,size(o.MI,2));
o.IndMask(o.windowIdx) = 1;
o.Mask = mask

end