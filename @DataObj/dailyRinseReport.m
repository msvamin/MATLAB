% Function for generating the report for the daily rinse runs
% Amin Mousavi 5/27/2016

function o = dailyRinseReport(o, load_flag)


o.postRunState('7','0','77');

% If the dat is not available then load it
if load_flag
    o.setPaths;
    try
        disp('Loading instrument data...')
        o.instrumentData;
    catch
        disp('Error in loading instrument data!')
    end
    try
        disp('Windowing...')
        o.createMask;
    catch
        disp('Error in windowing!')
    end
end

% The state names 
state_names = { 'PurgeSWFirst', ...
                'PurgeSWLast', ...
                'PurgeMWFirst', ...
                'PurgeCBFirst', ...
                'PurgeTBFirst', ...
                'PurgeABFirst', ...
                'PurgeGBFirst', ...
                'PurgeTBLast', ...
                'PurgeGBLast', ...
                'PurgeABLast', ...
                'PurgeCBLast', ...
                'PurgeMWLast', ...
                'PurgeB2'
                };

st_len = length(state_names);
state_starts = cell(st_len);
state_ends = cell(st_len);
for i = 1:st_len
    for j = 1:length(o.Mask.stateList)
        if strcmp(o.Mask.stateList(j), [state_names{i} 'Beg'])
            state_starts{i} = o.Mask.stateTimes(j)+1;
        end
        if strcmp(o.Mask.stateList(j), [state_names{i} 'End'])
            state_ends{i} = o.Mask.stateTimes(j);
        end
        
    end
end

flowrate1_avg = cell(st_len);
flowrate2_avg = cell(st_len);
flowrate3_avg = cell(st_len);
pump_pressure_avg = cell(st_len);
resistance1 = cell(st_len);
resistance2 = cell(st_len);
resistance3 = cell(st_len);

for i = 1:st_len
    
    % FlowRate 1
    ts = o.FlowSensor.TSraw/1000;
    idx = (ts < state_ends{i})&(ts > state_starts{i});
    flowrate1_avg{i} = mean(o.FlowSensor.Readout(idx));
    
    % FlowRate 2
    ts = o.FlowSensor.TSraw2/1000;
    idx = (ts < state_ends{i})&(ts > state_starts{i});
    flowrate2_avg{i} = mean(o.FlowSensor.Readout2(idx));
    
    % FlowRate 3
    ts = o.FlowSensor.TSraw3/1000;
    idx = (ts < state_ends{i})&(ts > state_starts{i});
    flowrate3_avg{i} = mean(o.FlowSensor.Readout3(idx));

    % Pump Pressure
    ts = o.SysPressure.TSraw/1000;
    idx = (ts < state_ends{i})&(ts > state_starts{i});
    pump_pressure_avg{i} = mean(o.SysPressure.Readout.Pump(idx));

    resistance1{i} = flowrate1_avg{i}/pump_pressure_avg{i};
    resistance2{i} = flowrate2_avg{i}/pump_pressure_avg{i};
    resistance3{i} = flowrate3_avg{i}/pump_pressure_avg{i};

end

% Saving the tables csv files
fid = fopen(fullfile(o.Paths.save.screening,[o.run.id '-DailyRinseTable.csv']),'w');
%fprintf(fid, 'State, FlowRate1 Avg, FlowRate2 Avg, FlowRate3 Avg, Pump Pressure Avg\n');
fprintf(fid, 'State, Resistance 1, Resistance 2, Resistance 3\n');
for i = 1:st_len
    fprintf(fid, '%s,', state_names{i});
%     fprintf(fid, '%d,', flowrate1_avg{i});
%     fprintf(fid, '%d,', flowrate2_avg{i});
%     fprintf(fid, '%d,', flowrate3_avg{i});
%     fprintf(fid, '%d\n', pump_pressure_avg{i});
    fprintf(fid, '%d,', resistance1{i});
    fprintf(fid, '%d,', resistance2{i});
    fprintf(fid, '%d\n', resistance3{i});
end
fclose(fid);

