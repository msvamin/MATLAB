%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GenapSys MBS class constructor  
% version 0.1.1 Dev: 11/18/2014 - Max Greenfeld
% Modified from Arman - main_DSP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function o = GenReads(o)

chip = o.chip;
chip.NB = (mod(chip.row,32)==0)|(mod(chip.row,32)==1)|(mod(chip.col,32)==0)|(mod(chip.col,32)==1)|(mod(chip.col,32)==2);

machine_states = o.MachineStates;

[~, ~, read_sizes] = find(machine_states.ReadSize);
readEnd_idx = cumsum(read_sizes);
readStart_idx = [1; readEnd_idx(1:end-1)+1];
numReads = numel(read_sizes);
Reads.Start_idx = readStart_idx;
Reads.End_idx = readEnd_idx;
Reads.numReads = numReads;

read_rows = find(machine_states.ReadSize); % Rows in the log file that correspond to CollectData which stores sensor reads
Reads.machine_states = machine_states(read_rows, :);fprintf('.');

% Parse Script Analysis
Reads.B1_INDX=[];Reads.B2_INDX=[];
for i=1:Reads.numReads
    if isequal(Reads.machine_states.BufferState(i),{'B2'})&(Reads.machine_states.Stages(i)==1)
        Reads.B2_INDX=[Reads.B2_INDX,[Reads.Start_idx(i):Reads.End_idx(i)]];
    elseif isequal(Reads.machine_states.BufferState(i),{'B1'})&(Reads.machine_states.Stages(i)==1)
        Reads.B1_INDX=[Reads.B1_INDX,[Reads.Start_idx(i):Reads.End_idx(i)]];
    end
end



Reads.combined.start_idx=Reads.Start_idx(1);Reads.combined.end_idx=Reads.End_idx(1);Reads.combined.bufferState=Reads.machine_states.BufferState(1);
for i=2:Reads.numReads
    if isequal(Reads.machine_states.BufferState(i),Reads.machine_states.BufferState(i-1))&isequal(Reads.machine_states.Stages(i),Reads.machine_states.Stages(i-1))
        Reads.combined.end_idx(end)=Reads.End_idx(i);
    else
        Reads.combined.start_idx(end+1)=Reads.Start_idx(i);
        Reads.combined.end_idx(end+1)=Reads.End_idx(i);
        Reads.combined.bufferState(end+1)=Reads.machine_states.BufferState(i);
    end
end
Reads.combined.ReadSize=Reads.combined.end_idx-Reads.combined.start_idx+1;
[~,jj]=max(Reads.combined.ReadSize);
Reads.B2_stretch=Reads.combined.start_idx(jj):Reads.combined.end_idx(jj);
Reads.B2_init=1:min(100,Reads.End_idx(1));
clear i jj

o.Reads = Reads;


