function  o = MachineStatesParse(o)
    function ret = isNTP(state_str)
         ret = strcmp(state_str, 'A') || strcmp(state_str, 'T') || strcmp(state_str, 'C') || strcmp(state_str, 'G');
    end
% This function parses the input script for current experiment and
% determines the state of the machine at each collect data point

    %system(['python python_scripts/scriptParser.py ', script_path]); % Parse script log text file to identify the state of machine at each point 
    States = {'NoFlow', 'A', 'T', 'C', 'G', 'B1', 'B2', 'Runoff'};
    Codes = {'vE40000', 'vE00020', 'vE08000', 'vE00008', 'vE00080', 'vE10000', 'vE00100', 'vE080A8'};
    
    script_path = fullfile(o.Paths.load.root, [o.run.id '.scriptHandler.log']);
    fd = fopen(script_path, 'r');
    columns = textscan(fd, '%d64,%[^,],%s', 'Delimiter', '');    
    fclose(fd);
   % columns{1}(end) = []; columns{2}(end) = []; % remove the final end "command"!
    line_no = numel(columns{1});
    
    Buffer = ones(line_no, 1);    
    [~, idx] = ismember(columns{2}, Codes);    
    [transition_time_idx, ~, transition_state_idx] = find(idx);
    for i = 1:numel(transition_state_idx)-1
        Buffer(transition_time_idx(i):transition_time_idx(i+1)) = transition_state_idx(i);
    end    
    BufferState = States(Buffer)';

    Stages = zeros(line_no, 1); 
    StageStart_idx = find(strcmp(columns{3}, 'powerFPGAOn'));
    StageEnd_idx = find(strcmp(columns{3}, 'powerFPGAOff'));


    try
        for i = 1:numel(StageStart_idx)
            Stages(StageStart_idx(i):StageEnd_idx(i)) = i;
        end
    catch
        Stages = zeros(size(columns{1}));
        disp('The run doesnot have FPGAoff command')
    end
    
   ReadDuration = zeros(line_no, 1);
   Read_size = zeros(line_no, 1);
   CalibRead_size = zeros(line_no, 1);

   current_NTPSeq = '';
   NTPSeq = cell(line_no, 1);
    
   i = 0;
    while(i < line_no)
        i = i + 1;
        if(strcmp(columns{2}{i}, 'command')) % FPGA command
           cmd_options = strsplit(columns{3}{i}, ',');
           if(strcmp(cmd_options{1}, 'CollectData'))
                  read_options = strsplit(cmd_options{2}, ' ');
                  read_type = str2double(read_options{3}); % 7 for calibration, 4 for actual sensor read                  
                  read_size = str2double(read_options{4});
                  if(read_type == 7)
                      CalibRead_size(i) = read_size; % CollectData for Bathtub calbration
                  elseif(read_type == 4)
                        offset = 0; total_size = read_size;
                        while(offset + i <= line_no)
                            offset = offset + 1;
                            if(strcmp(columns{2}(offset+i), 'command'))
                                cmd_options = strsplit(columns{3}{offset + i}, ',');
                                if(strcmp(cmd_options{1}, 'CollectData'))
                                    read_options = strsplit(cmd_options{2}, ' ');                          
                                    total_size = total_size + str2double(read_options{4});
                                    continue;
                                end
                            end
                            break;
                        end                      
                      NTPSeq{i} = current_NTPSeq;
                      Read_size(i) = total_size;          
                      ReadDuration(i) =   columns{1}(i + offset) - columns{1}(i);
                      i = i + offset - 1;
                      current_NTPSeq = '';
                  end                  
           end
        else %Control board command to control valves 
            idx = find(strcmp(Codes, columns{2}(i)));
            if(~isempty(idx))
                current_BufferState = States{idx};
                if (isNTP(current_BufferState))
                    current_NTPSeq = strcat(current_NTPSeq, current_BufferState);
                    NTPSeq{i} = current_NTPSeq;
                end                
            end            
        end        
   end
   rel_time = (columns{1} - columns{1}(1)) / 10^3; % in seconds
   machine_states = dataset(rel_time, columns{1}, columns{2}, columns{3},  Stages, BufferState, Read_size, CalibRead_size, NTPSeq, ReadDuration, 'VarNames', {'Seconds', 'TimeStamp', 'Type', 'Options', 'Stages', 'BufferState', 'ReadSize', 'CalibReadSize', 'NTPSeq', 'ReadDuration'});

    o.MachineStates = machine_states;
end


