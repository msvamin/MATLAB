function o = setPaths(o)

    % Defining the paths for loading and saving the data
    o.Paths.load.root = fullfile(o.Config.Paths.load.root, o.run.beta, o.run.id);
    o.Paths.load.raw = fullfile(o.Paths.load.root, o.Config.Paths.load.raw);
    o.Paths.load.calibration = fullfile(o.Paths.load.root, o.Config.Paths.load.calibration);
    o.Paths.load.metadata = fullfile(o.Paths.load.root, o.Config.Paths.load.metadata);
    o.Paths.save.root = fullfile(o.Config.Paths.save.root, o.run.beta, o.run.id);
    o.Paths.save.result = fullfile(o.Paths.save.root, o.Config.Paths.save.result);
    o.Paths.save.screening = fullfile(o.Paths.save.result, o.Config.Paths.save.screening);
    if ~isdir(o.Paths.save.screening)
        mkdir(o.Paths.save.screening);
    end
    o.Paths.save.metadata = fullfile(o.Paths.save.screening, o.Config.Paths.save.metadata);
    if ~isdir(o.Paths.save.metadata)
        mkdir(o.Paths.save.metadata);
    end
    o.Paths.save.chip = fullfile(o.Paths.save.screening, o.Config.Paths.save.chip);
    if ~isdir(o.Paths.save.chip)
        mkdir(o.Paths.save.chip);
    end
    o.Paths.save.sensors = fullfile(o.Paths.save.screening, o.Config.Paths.save.sensors);
    if ~isdir(o.Paths.save.sensors)
        mkdir(o.Paths.save.sensors);
    end
    o.Paths.save.bubble = fullfile(o.Paths.save.screening, o.Config.Paths.save.bubble);
    if ~isdir(o.Paths.save.bubble)
        mkdir(o.Paths.save.bubble);
    end
    
end
