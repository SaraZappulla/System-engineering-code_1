clear
clc

% components temperature limits / thermal ranges
IntGenPower_hot = 824; %orbit power eoportal; % 410 ex prof
CurrentEnergy = 80; %Ah 
Volt = 24; %V
WattH = CurrentEnergy*Volt;
timeH = 48/60;
IntGenPower_cold = WattH/timeH*0.3; %W
CompTemp_max = 40; %°C
CompTemp_min = -10; %°C from references it should be 10 but we use - 10 to have a margin
% 10 is the minimum of a component taken from the draft, but with 10 and
% the margin Tmax e Tmin sarebbero le stesse. Quindi ho cambiato a -10 per
% avere differenza tra le due
margin = 15; 
CompTemp_min_mar = 273.15+ CompTemp_min + margin;
CompTemp_max_mar = 273.15+ CompTemp_max - margin;

epsilon_rad = 0.80; % OSR/ITO Pilkington, 5-mill 0.88;
epsilon_coa = 0.05;%0.15; mars Vapor Deposited Aluminum because it is the lowest
alpha_coa = 0.08;%0.2 mars

rmoon = 1737.4;
SemiMajorAxis = rmoon+50; % lro 
eccentricity = 0.008;
l1 = 3.9; %1.5; %LRO sc size
l2 = 2.7; %1.8; % 
l3 = 2.6; %1.4; % 
% Size definition: hypotesis of equivalent sphere
TotalArea = 2 * (l1*l2 + l2*l3 + l3*l1);
rsphere = sqrt(TotalArea/(4*pi));

% Size definition: hypotesis of equivalent panel
PanelSize = 4.2672 * 3.2004; % from homework 4 and third one is 5.5 * 10^-3

%% Heat source

% solar flux
qo_hot = 1420; % ex prof 1367.5 from draft 
qo_cold = 1280;
Rplanet = 1; %distance of earth in AU
rlro = 1; %distance of mars in AU
qsun_sc_hot = qo_hot * (Rplanet/rlro)^2;
qsun_sc_cold = qo_cold * (Rplanet/rlro)^2;

% albedo flux
% our case is circular, so we do only one side of it
theta = 0; %deg2rad(85); % simplified we can put 85°
a_hot = 0.13; % 0.07 for the moon
a_cold = 0.06;
rplanet = rmoon; %3390; % for us moon radius
h = 50;
Rorbit = rplanet + h; %Rorbit = 3663;
qalb_pl_hot = qsun_sc_hot * a_hot * cos(theta) * (rplanet/Rorbit)^2;
qalb_pl_cold = qsun_sc_cold * a_cold * cos(theta) * (rplanet/Rorbit)^2;
% If you want to do only one computation use q_alb_cold

% infrared flux
sigma = 5.67 * 10^-8; %boltzman constant this is wrong
epsilon_ir_pl = 0.95; %infrared emissivity of the moon to change 0.85 mars from internet
Tpl_cold = 273.15-140; % 210 in mars temperature of the moon in K
Tpl_hot = 273.15+125;
Tpl_avg = (Tpl_hot+Tpl_cold)/2; %usiamo la T media: 0°C perchè quella calda darebbe troppi problemi
qIR_pl_hot = sigma * epsilon_ir_pl * Tpl_avg^4 * (rplanet/Rorbit)^2;
qIR_pl_cold = sigma * epsilon_ir_pl * Tpl_avg^4 * (rplanet/Rorbit)^2;

if qIR_pl_hot > 100
    disp('error in qIR_pl_hot')
end

%% Hot case / Cold case

Across = (pi * rsphere^2) %2*rsphere * pi * l1; %da file matteo  da file sara;
alpha_to_epsilon = alpha_coa/epsilon_coa;
Ka = 1; % choosen as 1 to mazimise the power, it can be a bit less

Fpl_sc = 0.5 * (1-(sqrt((h/rplanet)^2+(2*h/rplanet))/(1+h/rplanet)));
Qsun_hot = Across * alpha_coa * qsun_sc_hot;
Qalb_hot = TotalArea * Fpl_sc * alpha_coa * Ka * qalb_pl_hot;
QIR_hot = TotalArea * Fpl_sc * qIR_pl_hot;

% hot case
Tsc_max = ((IntGenPower_hot+Qsun_hot+Qalb_hot+QIR_hot)/(sigma*epsilon_coa*TotalArea))^(0.25)
Qtot_max = IntGenPower_hot+Qsun_hot+Qalb_hot+QIR_hot;
% Arad_min = (Qtot_max - sigma*epsilon_coa*TotalArea*Tsc_max^4)/(sigma*(epsilon_rad-epsilon_coa)*Tsc_max^4)
Arad_min = (Qtot_max - sigma*epsilon_coa*TotalArea*CompTemp_max_mar^4)/(sigma*(epsilon_rad-epsilon_coa)*CompTemp_max_mar^4)

if Tsc_max > CompTemp_max_mar
    disp('error Tmax')
end

Aemitting = TotalArea - Arad_min;
Qemitted = sigma*epsilon_coa * Aemitting * (Tsc_max^4-0);

% cold case
QIR_cold = TotalArea * Fpl_sc * qIR_pl_cold;
Tsc_min = ((IntGenPower_cold+QIR_cold)/(sigma*epsilon_coa*TotalArea))^(0.25)
Qheaters = sigma*epsilon_coa*Aemitting*CompTemp_min_mar^4-(IntGenPower_cold+QIR_cold)

% cold case with radiators
Tsc_min_withRad = ((IntGenPower_cold+QIR_cold)/(sigma*(epsilon_coa*Aemitting+epsilon_rad*Arad_min)))^(0.25)
Qheaters_withRad = sigma*(epsilon_coa*Aemitting+epsilon_rad*Arad_min)*CompTemp_min_mar^4-(IntGenPower_cold+QIR_cold)


if Tsc_min < CompTemp_min_mar  || Tsc_min_withRad < CompTemp_min_mar %|| Tsc_min_real < CompTemp_min_mar
    disp('error Tmin')
end
