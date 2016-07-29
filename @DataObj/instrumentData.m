% Read all the instrument data
% Created by Amin July-Aug 2015

function o =  instrumentData(o)

DataPath = [o.Paths.load.metadata '/' o.run.id];

ls(o.Paths.load.metadata)

% Reading flowrates 
try
    TempDataPath = [DataPath '.flowrate.csv'];
    flowrate1 = csvread(TempDataPath,1,0);
    Sensor1TimeStamp = flowrate1(:,1);
    Sensor1 = flowrate1(:,2);
    o.FlowSensor.Readout = Sensor1;
    o.FlowSensor.TSraw = Sensor1TimeStamp;
    TempDataPath = [DataPath '.flowrate2.csv'];
    flowrate2 = csvread(TempDataPath,1,0);
    Sensor2TimeStamp = flowrate2(:,1);
    Sensor2 = flowrate2(:,2);
    o.FlowSensor.Readout2 = Sensor2;
    o.FlowSensor.TSraw2 = Sensor2TimeStamp;
    TempDataPath = [DataPath '.flowrate3.csv'];
    flowrate3 = csvread(TempDataPath,1,0);
    Sensor3TimeStamp = flowrate3(:,1);
    Sensor3 = flowrate3(:,2);
    o.FlowSensor.Readout3 = Sensor3;
    o.FlowSensor.TSraw3 = Sensor3TimeStamp;
catch exception
    disp('Error while reading flowrates!');
    msgErr = getReport(exception);
    disp(msgErr);
end

% Reading Chip Voltages
try
    TempDataPath = [DataPath '.chipVoltages.csv'];
    ChipVoltData = csvread(TempDataPath,1,0);
    ChipVoltTimeStamp = ChipVoltData(:,1);
    ADCVref = ChipVoltData(:,6);
    AFEVref = ChipVoltData(:,7);
    RFVHi = ChipVoltData(:,8);
    RFVLo = ChipVoltData(:,9);
    PPoly = ChipVoltData(:,10);
    RFVHiNB = ChipVoltData(:,12);
    RFVLoNB = ChipVoltData(:,13);
    o.ChipVoltage.Readout.ADCVref = ADCVref;
    o.ChipVoltage.Readout.AFEVref = AFEVref;
    o.ChipVoltage.Readout.RFVHi = RFVHi;
    o.ChipVoltage.Readout.RFVLo = RFVLo;
    o.ChipVoltage.Readout.RFVHiVLo = RFVHi-RFVLo; 
    o.ChipVoltage.Readout.PPoly = PPoly;
    o.ChipVoltage.Readout.RFVHiNB = RFVHiNB;
    o.ChipVoltage.Readout.RFVLoNB = RFVLoNB;
    o.ChipVoltage.Readout.RFVHiVLoNB = RFVHiNB-RFVLoNB; 
    o.ChipVoltage.TSraw = ChipVoltTimeStamp;    %ChipVoltTime_Adj;
catch exception
    disp('Error while reading chip voltages!');
    msgErr = getReport(exception);
    disp(msgErr);
end

% Reading System Voltages
try
    TempDataPath = [DataPath '.systemVoltages.csv'];
    SysVoltData = csvread(TempDataPath,1,0);
    SysVoltTimeStamp = SysVoltData(:,1);
    SysVoltages = SysVoltData(:,2:end);
    DVDD12 = SysVoltData(:,2);
    DVDD33 = SysVoltData(:,3);
    AVDD33 = SysVoltData(:,4);
    DVDD12current = 10000*(SysVoltData(:,5) - SysVoltData(:,6));
    DVDD33current = 10000*(SysVoltData(:,5) - SysVoltData(:,7));
    AVDD33current = 10000*(SysVoltData(:,5) - SysVoltData(:,8));

    o.SysVoltage.Readout = SysVoltages;
    o.SysVoltage.DVDD12 = DVDD12;
    o.SysVoltage.DVDD33 = DVDD33;
    o.SysVoltage.AVDD33 = AVDD33;
    o.SysVoltage.DVDD12current = DVDD12current;
    o.SysVoltage.DVDD33current = DVDD33current;
    o.SysVoltage.AVDD33current = AVDD33current;
    o.SysVoltage.TSraw = SysVoltTimeStamp;
  
catch exception
    disp('Error while reading system voltages!');
    msgErr = getReport(exception);
    disp(msgErr);
end

% Reading Chip Temperatures
try
    TempDataPath = [DataPath '.chipTemperatures.csv'];
    ChipTempData = csvread(TempDataPath,1,0);
    ChipTempTimeStamp = ChipTempData(:,1);
    TargetChipTemp = ChipTempData(:,2);
    IPTAT = ChipTempData(:,3);
    RTDU = ChipTempData(:,4); RTDM = ChipTempData(:,5); RTDL = ChipTempData(:,6);
    TempRise = ChipTempData(:,7);
    o.ChipTemp.Readout.TargetChipTemp = TargetChipTemp;
    o.ChipTemp.Readout.IPTAT = IPTAT;
    o.ChipTemp.Readout.RTDU = RTDU;
    o.ChipTemp.Readout.RTDM = RTDM;
    o.ChipTemp.Readout.RTDL = RTDL;
    o.ChipTemp.Readout.TempRise = TempRise;
    o.ChipTemp.TSraw = ChipTempTimeStamp;
catch exception
    disp('Error while reading chip temperatures!');
    msgErr = getReport(exception);
    disp(msgErr);
end

% Reading System Temperatures
try
    TempDataPath = [DataPath '.systemTemperatures.csv'];
    SysTempData = csvread(TempDataPath,1,0);
    SysTempSensor1 = SysTempData(:,2);
    CuBlock = SysTempData(:,2);
    HeatSink = SysTempData(:,3);
    Preheater = SysTempData(:,4);
    Ambient = SysTempData(:,5);
    Vref = SysTempData(:,6);
    SysTempTimeStamp = SysTempData(:,1);
    o.SysTemp.Readout.Sensor1 = SysTempSensor1;
    o.SysTemp.TSraw = SysTempTimeStamp;
    o.SysTemp.Readout.CuBlock = CuBlock; 
    o.SysTemp.Readout.HeatSink = HeatSink;
    o.SysTemp.Readout.Preheater = Preheater;
    o.SysTemp.Readout.Ambient = Ambient;
    o.SysTemp.Readout.Vref = Vref;
    o.SysTemp.Readout.JunkSensors = SysTempData(:,3:end);
catch exception
    disp('Error while reading system temperatures!');
    msgErr = getReport(exception);
    disp(msgErr);
end

% Reading System Pressures
try
    TempDataPath = [DataPath '.systemPressures.csv'];
    SysPresData = csvread(TempDataPath,1,0);
    SysPresTimeStamp = SysPresData(:,1);
    PumpPressure = SysPresData(:,2);
    CartridgePressure = SysPresData(:,3);
    o.SysPressure.Readout.Pump = PumpPressure;
    o.SysPressure.Readout.Cartridge = CartridgePressure;
    o.SysPressure.TSraw = SysPresTimeStamp;
catch exception
    disp('Error while reading system pressures!');
    msgErr = getReport(exception);
    disp(msgErr);
end

% Reading Valve States
try
    TempDataPath = [DataPath '.controlboardMetadata.csv'];
    [ControlBoardTS, ValveArray, PIDEffort1, PIDEffort2, PIDEffort3] = ImportControlBoardMetaData(TempDataPath);
    %diffValve = diff(ValveArray);
    ValveStateTime_Adj= ControlBoardTS(2:end); %ControlBoardTS(2:end)-ScriptTS(1)-TimeZero;
    o.ValveState.PeltierPIDEffort = PIDEffort1;
    o.ValveState.PreheaterPIDEffort = PIDEffort2;
    o.ValveState.CartridgePIDEffort = PIDEffort3;    
    o.ValveState.States = ValveArray;
    o.ValveState.TSraw = ValveStateTime_Adj;
catch exception
    disp('Error while reading valve states!');
    msgErr = getReport(exception);
    disp(msgErr);
end

end
