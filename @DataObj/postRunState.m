function o = postRunState(o, experimentStateListId, stateId, usernameId)
    
    % Send Run State to Database
    % Created by Amin Mousavi 3/16/2016
    
    tokenRequest = ['{"experimentId":"' o.run.id '" ,"experimentStateList_id":' experimentStateListId ' ,"state":' stateId ' ,"username_id":' usernameId '}'];

    RESTtype = 'experimentState';
    
    [~, ~] = postRESTdata(o.Config.RestAPI.runState, tokenRequest, RESTtype, o.Config.RestAPI.logging);

end
    