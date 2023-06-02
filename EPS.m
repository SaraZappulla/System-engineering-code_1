%% EPS
clear all
close all
clc

% DATA (pag 8): put data for our mission
Pd= 375; % power request in daylight
Pe= 225.04; % power request in eclipse

Te= 48*60;%period in eclipse worst case
Td= 2*3600-Te;%period in daylight
lifetime=3; %years
xd=0.85; %pag 5 DET IS THE CHOOSEN ONE
xe=0.65; %pag 10
A_sa_initial=10.7 % m^2 solar array area

%% Solar arrays
P_sa= Pe*Te/(xe*Td)+Pd/xd; % power of solar arrays requested W
% In this case the SA are dimensioned for the maximum power demand

%data: Silicon based cells (pag 12: typical values)
% put data of our mission
epsilon_bol=0.26; % efficiency at the beginning of life
Id=0.7;
dpy=0.028; % degradation through years
Io=588.5; % W/m^2 pag 10
t=5.5*10^-4; %mm thickness
rho_Si=10; %kg/m^3 density of the Silicon based cells
Po=epsilon_bol*Io; % specific power output W/m^2

mytheta=deg2rad(30); % you have to assume it! 30 deg is the maximum angle you can usually found out
P_bol=Po*Id*cos(mytheta); % specific power at bol W/m^2

L_life=(1-dpy)^(lifetime); %lifetime degradation
P_eol=L_life*P_bol; % specific power at the end of life W/m^2
A_sa=P_sa/P_eol; % solar arrays surface m^2
if A_sa<A_sa_initial
    disp('correct solar arrays area')
else
    disp('not correct solar arrays area')
end

m_sa=rho_Si*A_sa*t;

% refine the size of the solar cells:
A_cell=0.0035; %m^2 typical values of cell area
N_sa=ceil(A_sa/A_cell);
V_sys_sa= 28; %V assumed from slide 3(if the power demand is less than 2kW)
V_cell_sa=2.6; %V usually
N_series_sa= ceil(V_sys_sa/V_cell_sa);
V_real_sa=N_series_sa*V_cell_sa;
N_real_sa=ceil(N_sa/N_series_sa)*N_series_sa;
A_sa_real=N_real_sa*A_cell;

%% Battery
%data
N_battery= 1; %Li-ion battery in this case ( slide 8)
DOD=0.6; % from slide 19 higher because short mission 5 years
eta=0.4; % from literature
%secondary battery because is litium ioni
Es= 140; %Wh/kg
Ed= 250; %Wh/dm^3
V_cell_battery=3.6; %V

C=Te/3600*Pe/(DOD*N_battery*eta); %Wh
m_battery=C/Es; %kg
V_batt=C*10^-3/Ed; %m^3
V_sys_batt=28; %V
C_Ah=C/V_sys_batt; %Ah it's about 22.5(as slide 8)
V_sp=A_sa*t;

% refine the size of the battery
N_series_battery= ceil(V_sys_batt/V_cell_battery);
V_real_battery=N_series_battery*V_cell_battery;
mu=0.8; %usually
C_cell=7.5; %Ah from cell datasheet
C_string=mu*C_cell*V_real_battery; %Wh
N_parallel=ceil(C/C_string);
C_real_battery=N_parallel*C_string; %Wh

%% total volume and mass

m_tot = m_sa + m_battery %total system mass budget
v_tot = V_batt + V_sp % total system volume budget