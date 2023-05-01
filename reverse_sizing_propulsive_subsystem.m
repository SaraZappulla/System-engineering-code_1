clc
clear all
close all

% This program allow to calculate masses and volumes of the propulsive
% subsystem of the mission considering different input and comparing the
% results with expected values
% inputs 
delta_v = 28+567+185+133+41+50+150+39+65; %sum of velocities from the document
v_SK = 150; %station keeping speed
g0 = 9.81;
m_dry = 949; % dry mass of the orbiter from NASA and eoportal

Isp_mono = 225; %specific impulse hydrazine monopropellant 
Isp_double = 316; %specific impulse N2H4-N2O4
rho_h = 1005; % hydrazine density (kg/m^3)
rho_p = 1.5712*1000; % propellant density

m_fuel_dato = 894; % fuel total mass 
delta_v_mar_020 = delta_v+v_SK; %SK margin of 100%
m_dry_mar = m_dry*1.2;  %dry mass margin of 20%

m_fuel_mar=m_dry_mar*((exp(delta_v_mar_020/(Isp_mono*g0)))-1)*1.02 %fuel mass considering margin of 2%
m_fuel_other_mar=m_dry_mar*((exp(delta_v_mar_020/(Isp_double*g0)))-1)*1.02 % bipropellant mass considering 2% amrgin
% error and percentage of error with respect to given data
err_mar=m_fuel_dato-m_fuel_mar; 
err_percentuale_mar=err_mar/m_fuel_dato  

%% propellant volume and tank masses
R=8314; %gas universal constant
T_tank = 293; %temperature of the tank
mmol_h = 32.0452; % hydrazine molar mass
mmol_other = 20.532; % N2H4-N2O4 molar mass

R_spec_other = R/mmol_other; % specific gas constants
R_spec_h = R/mmol_h;

vol_h=m_fuel_dato/rho_h; % monopropellant volume
vol_h_mar = vol_h*1.1; % propellant volume margine of 10%
vol_tank1=vol_h/2; %volume of 1 tank over 2
vol_tank1_dato=0.45883779; %volume of 1 tank taken from real data

% error and percentage of error respect to the real value
err_tank1=vol_tank1_dato-vol_tank1; 
err_percentuale_tank1=err_tank1/vol_tank1_dato; 

%tanks material
p_tank1=2.413*10^6; %pressure tank in Pa
sigma_ti = 950*10^6; % deformation stress titanium
%sigma_al = 503*10^6; % deformation stress alluminium
sigma_alloy=770*10^6
rho_ti = 4500; % density of titanium
%rho_al = 2810; % density of alluminium
rho_alloy=8700 %density of inconel 625

% thickness of the tanks with 2 tanks
rtank = (0.75*vol_tank1/pi)^(1/3); % tank radius considering it spherical
ttank_ti = p_tank1*rtank/(2*sigma_ti);
ttank_alloy = p_tank1*rtank/(2*sigma_alloy);
mtank_ti = 4*pi/3*rho_ti*((rtank+ttank_ti)^3-rtank^3)
mtank_alloy = 4*pi/3*rho_alloy*((rtank+ttank_alloy)^3-rtank^3)

% if it was 1 tank:
rtank1 = (0.75*vol_h_mar/pi)^(1/3); % tank radius considering it spherical
ttank_ti1 = p_tank1*rtank1/(2*sigma_ti); %thickness of the tank
ttank_al1 = p_tank1*rtank1/(2*sigma_alloy);
mtank_ti1 = 4*pi/3*rho_ti*((rtank1+ttank_ti1)^3-rtank1^3) %mass of the empty tank
mtank_al1 = 4*pi/3*rho_alloy*((rtank1+ttank_al1)^3-rtank1^3)

% if it was 3 tank:
rtank3 = (0.75*vol_h_mar/3/pi)^(1/3); % tank radius considering it spherical
ttank_ti3 = p_tank1*rtank3/(2*sigma_ti); %thickness of the tank
ttank_al3 = p_tank1*rtank3/(2*sigma_alloy);
mtank_ti3 = 4*pi/3*rho_ti*((rtank3+ttank_ti3)^3-rtank3^3) %mass of the empty tank
mtank_al3 = 4*pi/3*rho_alloy*((rtank3+ttank_al3)^3-rtank3^3)

%% Pressurant mass

%pressurant gas selection: helium or N2
R_specific_he=2077.3; % Joule/KgK
R_specific_N2=296.8;%Joule/KgK
gamma_he=1.67;
gamma_N2=1.40;
rho_he=0.1784; %densità elio
rho_N2 = 1.16;
vol_press_dato=0.08193532; %given pressurant volume

T_tank=293; %temperature of the tanks [K]
p_press=2.8958*10^7; %pressure of the pressurant tank [Pa]
rho_P2 = rho_he * (p_press/101325)
rho_P2_N2 = rho_N2 * (p_press/101325)

vol_he = vol_h_mar/((p_press/p_tank1)-1)
m_press_he = vol_he*rho_P2*1.2;
m_press_N2 = vol_he*rho_P2_N2*1.2;
%we select helio because has lower mass

m_press_dato = 3.3;%vol_press_dato*rho_he;
err_press_vol=vol_press_dato-vol_he; %errore tra i volumi dei pressurizzanti
err_press_vol_percentuale=err_press_vol/vol_press_dato

err_press_mass = m_press_dato-m_press_he;
err_press_mass_percentuale=err_press_mass/m_press_dato
err_press_mass_N2 = m_press_dato-m_press_N2;
err_press_mass_percentuale_N2=err_press_mass_N2/m_press_dato

%% total mass
% masses of the engines
m_th_90 = 1.12; %prof slide
m_th_22 = 0.59; %https://www.satcatalog.com/component/mr-106l-22n/
%total mass of the propulsive system dry
mtot = (mtank_ti*2 + m_press_he + m_th_90*4 + m_th_22*8)*1.1 %margin of 10% accounts for cables

