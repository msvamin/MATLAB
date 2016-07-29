function o = getRunInf(o, run_id)
    
    % Get the basic run Info from database
    % Created by Amin Mousavi 3/7/2016
    RESTurl = sprintf(o.Config.RestAPI.runInf, run_id);
    [rInf, ~] = getRESTdata(RESTurl, 'getExperimentInfoByIdAndState', o.Config.RestAPI.logging);
    RunInf.id = run_id;
   
    if ~isempty(rInf)
        RunInf.beta = rInf{1}{1};
        RunInf.startTime = rInf{1}{3};
        RunInf.endTime = rInf{1}{4};
        RunInf.Type = rInf{1}{5};
        RunInf.Operator = rInf{1}{6};
        RunInf.ChipId = rInf{1}{7};
        RunInf.ScriptName = rInf{1}{8};
        RunInf.ConfigName = rInf{1}{9};
        RunInf.Descrip = rInf{1}{13};
        RunInf.Analyte = rInf{1}{14};
        RunInf.reagent = rInf{1}{15};
    else
        disp('There is no information for this run in database!')
        RunInf.beta = getbetaId(run_id);
    end
    
    o.run = RunInf;
end
    