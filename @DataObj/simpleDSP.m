%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GenapSys MBS class constructor  
% version 0.1.1 Dev: 11/18/2014 - Max Greenfeld
% Modified from Arman - main_DSP
% Modified by Amin July-August 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [chip, MultipleDACRead, Gain] = simpleDSP(o, varargin)
function o = simpleDSP(o)

run = o.run; 

% Load Adaptive Bathtub
tic;

if run.chip_type=='A',
    dac_trans=64;
elseif run.chip_type=='B',
    dac_trans=128;
end

dac_reshaped = o.MultipleDACRead.dac;

dac_signed=2*(0.5-floor(dac_reshaped/dac_trans)).*mod(dac_reshaped,dac_trans);
if (size(dac_signed,1)==1)
    Gain.dac=[dac_signed(1,:)]';
else
    Gain.dac=[dac_signed(1,:)-dac_signed(end/2+1,:)]';
end
%Gain.dacI=[dac_signed(1+end/4,:)-dac_signed(3*end/4+1,:)]';



input = o.MultipleDACRead;
input.dac_reshaped = o.MultipleDACRead.dac;
output = bathtub_adaptive_dac_analysis(o,input);

sensor = output.sensor;
sensor.DAC_unsat=abs(input.adc_value(:,:,1))<16000;

if size(sensor.current_sensor,2) == 1
    Gain.phase_slope = sensor.current_sensor(:,1);
elseif size(sensor.current_sensor,2) == 2
    Gain.phase_slope=sensor.current_sensor(:,1)-sensor.current_sensor(:,2);
elseif size(sensor.current_sensor,2) == 4
    Gain.phase_slope=sensor.current_sensor(:,1)-sensor.current_sensor(:,3);
end

%MultipleDACRead = rmfield(MultipleDACRead,'chip');
o.Gain = Gain;
fprintf(['Simple DSP completed in ',num2str(toc),' seconds \n']);
fprintf([num2str(free_mem),'GB of memory is still available \n']);







