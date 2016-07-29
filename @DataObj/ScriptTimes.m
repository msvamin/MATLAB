function o = ScriptTimes(o)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creatd by Amin July-Aug 2015
% Adopted from DataAlignment.m by Mahdokht Masaeli 12/10/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data paths
run= o.run;

d=dir(fullfile(o.Paths.load.raw, '*.h5')); % List of all HDF file related to sensor reads
Scriptfilename = fullfile(o.Paths.load.root, [run.id '.scriptHandler.log']);

% Time stamp of script log
try
    [ScriptTS,ScriptCommands,DummyCommands] = ImportLogFile(Scriptfilename);
    chpf=char(ScriptCommands);
    chdummy = char(DummyCommands);
    StartScriptTime = double(ScriptTS(1));
    ScriptTimeStamp = ScriptTS - StartScriptTime;
    %ScriptDateTime = datestr(ScriptTS/86400/1000 + datenum(1970,1,1));
    %timeScriptj = [ScriptDateTime(:,end-7:end-6),ScriptDateTime(:,end-4:end-3),ScriptDateTime(:,end-1:end)];
    TimeZero = ScriptTimeStamp(1);
catch excp
    disp(getReport(excp,'extended'));
    disp('Log file cannot be imported.')
end

readstr='READ 0 4';
try
    firstReadInd=find(strcmp(cellstr(chpf(:,1:8)),readstr)==1);  % Find when chip reading starts
    TimeStReads=double(ScriptTimeStamp(firstReadInd));       % Time stamp of first chip read
    TimeStFirstRead=TimeStReads(1);
catch excp
    disp(getReport(excp,'extended'));
    sprintf('The run has no reads.')
end

try
    seqstr = ['startSequencing'];
    StartSeqInd=find(strcmp(cellstr(chdummy(:,1:15)),seqstr)==1);  % Find when chip reading starts
    TimeStartSeq=double(ScriptTimeStamp(StartSeqInd));       % Time stamp of first chip read
    TimeZero = TimeStartSeq(1);
catch excp
    disp(getReport(excp,'extended'));
    sprintf('Run script misses "start sequencing" command and first read point will be captured as time zero.')
end

% Added by Amin to find end sequencing time
try
    ESTI = find(strcmp(cellstr(chpf(:,1:27)),'Valve Preset:No Liquid Flow')); 
    EndSeqInd = ESTI(end); 
    TimeEndSeq=double(ScriptTimeStamp(EndSeqInd));       % Time stamp of first chip read
catch excp
    disp(getReport(excp,'extended'));
    sprintf('Run does not have "end sequencing" time stamp')
    TimeEndSeq = [];
end

try
    ScriptTimeStamp_Adj = ScriptTimeStamp-TimeZero;
    o.ScriptCommands.commands = ScriptCommands;
    o.ScriptCommands.TimeStamp = ScriptTimeStamp_Adj;
    o.ScriptCommands.TimeZero = TimeZero;
    o.ScriptCommands.TimeEndSeq = TimeEndSeq;
catch excp
    disp(getReport(excp,'extended'));
    sprintf('Problem with script log file')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time stamp of reads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    hinfo=h5info(fullfile(o.Paths.load.raw, d(1).name));
catch excp
    disp(getReport(excp,'extended'));
    disp([d(1).name,' is a corrputed file.']);
    return
end

number_of_reads=size(d,1);
%number_of_phases=length(hinfo.Datasets);
number_of_samples_per_read=hinfo.Datasets(1).Dataspace.Size(1);
%number_of_sensors=hinfo.Datasets(1).Dataspace.Size(2);

readtimeArray = zeros(1,number_of_reads*number_of_samples_per_read);

for i=1:number_of_reads
    [t1,~,readtime_current] = TimeStampInitFin(d(i).name(1:end-3));
    %[timeinit,timefin] = TimeStampInitFin(d(i).name(1:end-3));
    %readtime_current = timefin-timeinit;
    timeinit = ((((datenum(t1(1)-2016,t1(2),t1(3))*24)+t1(4))*60+t1(5))*60+t1(6))*1000+t1(7);
    
    readtimeArray((i-1)*number_of_samples_per_read+1:i*number_of_samples_per_read) =  ...
        timeinit+linspace(0,readtime_current,number_of_samples_per_read);
    
end

readtimeArray = round(readtimeArray');

ReadTime_Adj = readtimeArray-readtimeArray(1)+TimeStFirstRead-TimeZero;
    
    %Added by Amin to skip the readings after end seq
%     try
%         ReadTime_Adj = ReadTime_Adj(ReadTime_Adj<TimeEndSeq);
%     catch
%     end

%EndReadTime = ScriptTimeStamp(end);
o.ReadTimeStamp = ReadTime_Adj;
o.ReadIndProp.TimeStamp = ReadTime_Adj;

o.FlowSensor.TimeStamp = o.FlowSensor.TSraw-ScriptTS(1)-TimeZero;
try
    o.FlowSensor.TimeStamp2 = o.FlowSensor.TSraw2-ScriptTS(1)-TimeZero;
catch
    disp('There is no data for flow sensor 2')
end
try
    o.FlowSensor.TimeStamp3 = o.FlowSensor.TSraw3-ScriptTS(1)-TimeZero;
catch
    disp('There is no data for flow sensor 3')
end

MetaDatafilename = [o.Paths.load.metadata,'/',run.id,'.controlboardMetadata.csv'];
[~,~, PIDEffort1, PIDEffort2, PIDEffort3] = ImportControlBoardMetaData(MetaDatafilename);
o.ValveState.PeltierPIDEffort = PIDEffort1;
o.ValveState.PreheaterPIDEffort = PIDEffort2;
o.ValveState.CartridgePIDEffort = PIDEffort3;

o.ValveState.TimeStamp = o.ValveState.TSraw-ScriptTS(1)-TimeZero;
o.ChipTemp.TimeStamp = o.ChipTemp.TSraw-ScriptTS(1)-TimeZero;
o.SysPressure.TimeStamp = o.SysPressure.TSraw-ScriptTS(1)-TimeZero;
o.ChipVoltage.TimeStamp = o.ChipVoltage.TSraw-ScriptTS(1)-TimeZero;
o.SysVoltage.TimeStamp = o.SysVoltage.TSraw-ScriptTS(1)-TimeZero;
o.SysTemp.TimeStamp = o.SysTemp.TSraw-ScriptTS(1)-TimeZero;

% ReadIndProp
for i = 1:length(ReadTime_Adj)
    Amindifftime = min(abs(o.FlowSensor.TimeStamp-ReadTime_Adj(i)));
    [AmindiffIdx, ~ ]= find(abs(o.FlowSensor.TimeStamp-ReadTime_Adj(i))==Amindifftime);
    FlowDataTime_Idx(i) = AmindiffIdx(1);
    
    Bmindifftime = min(abs(o.ValveState.TimeStamp-ReadTime_Adj(i)));
    [BmindiffIdx, ~ ]= find(abs(o.ValveState.TimeStamp-ReadTime_Adj(i))==Bmindifftime);
    ValveStateTime_Idx(i) = BmindiffIdx(1);
    
    Cmindifftime = min(abs(o.ChipTemp.TimeStamp-ReadTime_Adj(i)));
    [CmindiffIdx, ~ ]= find(abs(o.ChipTemp.TimeStamp-ReadTime_Adj(i))==Cmindifftime);
    ChipTempTime_Idx(i) = CmindiffIdx(1);
    
    Dmindifftime = min(abs(o.SysTemp.TimeStamp-ReadTime_Adj(i)));
    [DmindiffIdx, ~ ]= find(abs(o.SysTemp.TimeStamp-ReadTime_Adj(i))==Dmindifftime);
    SysTempTime_Idx(i) = DmindiffIdx(1);
    
    Emindifftime = min(abs(o.SysPressure.TimeStamp-ReadTime_Adj(i)));
    [EmindiffIdx, ~ ]= find(abs(o.SysPressure.TimeStamp-ReadTime_Adj(i))==Emindifftime);
    SysPresTime_Idx(i) = EmindiffIdx(1);
    
    Fmindifftime = min(abs(o.ChipVoltage.TimeStamp-ReadTime_Adj(i)));
    [FmindiffIdx, ~ ]= find(abs(o.ChipVoltage.TimeStamp-ReadTime_Adj(i))==Fmindifftime);
    ChipVoltTime_Idx(i) = FmindiffIdx(1);
    
    Gmindifftime = min(abs(o.SysVoltage.TimeStamp-ReadTime_Adj(i)));
    [GmindiffIdx, ~ ]= find(abs(o.SysVoltage.TimeStamp-ReadTime_Adj(i))==Gmindifftime);
    SysVoltTime_Idx(i) = GmindiffIdx(1);
    
    try
        % added by PS
        Xmindifftime = min(abs(o.FlowSensor.TimeStamp2-ReadTime_Adj(i)));
        [XmindiffIdx, ~ ]= find(abs(o.FlowSensor.TimeStamp2-ReadTime_Adj(i))==Xmindifftime);
        FlowDataTime_Idx2(i) = XmindiffIdx(1);
    catch
        disp('There is no data for flow sensor 2')
    end
    try
        % added by Amin
        Xmindifftime = min(abs(o.FlowSensor.TimeStamp3-ReadTime_Adj(i)));
        [XmindiffIdx, ~ ]= find(abs(o.FlowSensor.TimeStamp3-ReadTime_Adj(i))==Xmindifftime);
        FlowDataTime_Idx3(i) = XmindiffIdx(1);
    catch
        disp('There is no data for flow sensor 3')
    end    
end

o.ReadIndProp.FlowRate = o.FlowSensor.Readout(FlowDataTime_Idx);
o.ReadIndProp.FlowRate2 = o.FlowSensor.Readout2(FlowDataTime_Idx2); % added by PS
o.ReadIndProp.FlowRate3 = o.FlowSensor.Readout3(FlowDataTime_Idx3); % added by Amin

o.ReadIndProp.ValveState = o.ValveState.States(ValveStateTime_Idx,:);

o.ReadIndProp.ChipTemp.RTDU = o.ChipTemp.Readout.RTDU(ChipTempTime_Idx);
o.ReadIndProp.ChipTemp.RTDM = o.ChipTemp.Readout.RTDM(ChipTempTime_Idx);
o.ReadIndProp.ChipTemp.RTDL = o.ChipTemp.Readout.RTDL(ChipTempTime_Idx);
o.ReadIndProp.ChipTemp.IPTAT = o.ChipTemp.Readout.IPTAT(ChipTempTime_Idx);

o.ReadIndProp.SysTemp = o.SysTemp.Readout.Sensor1(SysTempTime_Idx);
o.ReadIndProp.SysTemps.CuBlock = o.SysTemp.Readout.CuBlock(SysTempTime_Idx);
o.ReadIndProp.SysTemps.HeatSink = o.SysTemp.Readout.HeatSink(SysTempTime_Idx);
o.ReadIndProp.SysTemps.Preheater = o.SysTemp.Readout.Preheater(SysTempTime_Idx);
o.ReadIndProp.SysTemps.Ambient = o.SysTemp.Readout.Ambient(SysTempTime_Idx);
o.ReadIndProp.SysTemps.Vref = o.SysTemp.Readout.Vref(SysTempTime_Idx);

o.ReadIndProp.PumpPressure = o.SysPressure.Readout.Pump(SysPresTime_Idx);
o.ReadIndProp.CartridgePressure = o.SysPressure.Readout.Cartridge(SysPresTime_Idx);

o.ReadIndProp.ChipVoltage.ADCref = o.ChipVoltage.Readout.ADCVref(ChipVoltTime_Idx);
o.ReadIndProp.ChipVoltage.AFEref = o.ChipVoltage.Readout.AFEVref(ChipVoltTime_Idx);
o.ReadIndProp.ChipVoltage.RFVHi = o.ChipVoltage.Readout.RFVHi(ChipVoltTime_Idx);
o.ReadIndProp.ChipVoltage.RFVLo = o.ChipVoltage.Readout.RFVLo(ChipVoltTime_Idx);
o.ReadIndProp.ChipVoltage.PPoly = o.ChipVoltage.Readout.PPoly(ChipVoltTime_Idx);

o.ReadIndProp.SysVoltages = o.SysVoltage.Readout(SysVoltTime_Idx);
o.ReadIndProp.SysVolts.DVDD12 = o.SysVoltage.DVDD12(SysVoltTime_Idx);
o.ReadIndProp.SysVolts.DVDD33 = o.SysVoltage.DVDD33(SysVoltTime_Idx);
o.ReadIndProp.SysVolts.AVDD33 = o.SysVoltage.AVDD33(SysVoltTime_Idx);
o.ReadIndProp.SysVolts.DVDD12current = o.SysVoltage.DVDD12current(SysVoltTime_Idx);
o.ReadIndProp.SysVolts.DVDD33current = o.SysVoltage.DVDD33current(SysVoltTime_Idx);
o.ReadIndProp.SysVolts.AVDD33current = o.SysVoltage.AVDD33current(SysVoltTime_Idx);