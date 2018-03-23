%% Channel parameters
channel = struct();

channel.snr             = inf;
channel.amp             = [1 0.5 0.3];
channel.delay           = [0 20e-9 50e-9];
channel.phase           = [0 0 0];
channel.aoa             = [90 120 70];
channel.nRays           = length(channel.amp);
channel.isNarrowBand    = true;
channel.MULTIPATH       = true;

%% Usage of Jac's model
channel.external = true;

% number of rays we consdier
d = 3;
if channel.external
    channel.nRays = d;
    
    load('data/Lichen_workspace_TC0010.mat');
%     close
    
    % channel model to use (itx-th Tx position)
    itx = 1;
    data = data(itx,:);
    
    % Rx antenna of interest
    M = highAccPosChar.numAntElm;
    irx = [7 8 9 10 11];
    irx = irx(1:M);
    data = data(irx);
    
    indxray = [1 3 4];
    indxray = indxray(1:d);
    % only use first d rays
    channel.extChnl = struct('tau', arrayfun(@(x) x.tau(indxray), data, 'UniformOutput', false),...
                             'h', arrayfun(@(x) x.h(indxray), data, 'UniformOutput', false),...
                             'TX_pos', {data(:).TX_pos});
                         
    % AoA of rays of interest
    channel.AoA = set.AoA(indxray);
    
    % number of multipath rays
    channel.nRays = length(channel.extChnl(1).tau);
    
    % antenna position
    simAntChar.antPosX = arrayfun(@(x) x.pos(1), set.RX);
    simAntChar.antPosY = arrayfun(@(x) x.pos(2), set.RX);
    simAntChar.antPosZ = arrayfun(@(x) x.pos(3), set.RX);
end