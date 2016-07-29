function o = postRunSpecs(o, Specs)
    
    % Send Run State to Database
    % Created by Amin Mousavi 3/16/2016
    
    tokenRequest = ['{"experimentId":"' o.run.id '" ,"sensor":"' Specs{1} '" ,"testType":"' Specs{2} ...
        '" ,"testWindow":"' Specs{3} '" ,"targetValue":' Specs{4} ' ,"failPBHW":' Specs{5} ...
        ' ,"warningPBHW":' Specs{6} ' ,"score":"' Specs{7} '" }'];

    RESTtype = 'experimentSpecTests';
    
    [~, ~] = postRESTdata(o.Config.RestAPI.runSpecs, tokenRequest, RESTtype, o.Config.RestAPI.logging);

end
    