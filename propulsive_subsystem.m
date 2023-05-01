%% 
clc
clear all
close all
delta_v=28+567+185+133+41+50+150+39+65;%somma velocità trovate a pag 5
v_SK=150; %velocita station keeping 
Isp=225; %impulso specifico mediano
m_dry=949; %massa a vuota
rho_h=1005; %densita idrazina (kg/m^3)
g0=9.81;
m_fuel=m_dry*((exp(delta_v/(Isp*g0)))-1); %massa del fuel
m_fuel_dato=894;
err=m_fuel_dato-m_fuel;%differenza tra mfuel dato e calcolato 
err_percentuale=err/m_fuel_dato;  %errore percentuale
delta_v_mar_020=delta_v+v_SK; %velocità con margine SK
m_dry_mar=m_dry*1.2;  %m dry con margine
m_fuel_mar=m_dry_mar*((exp(delta_v_mar_020/(Isp*g0)))-1)*1.02; %massa del fuel con margine
err_mar=m_fuel_dato-m_fuel_mar;%differenza tra mfuel dato e calcolato con margine 
err_percentuale_mar=err_mar/m_fuel_dato;  %errore percentuale con margine
vol_h=m_fuel_dato/rho_h; %volume hydrazina
vol_h_mar=vol_h*1.1; %volume h con margine
vol_tank1=vol_h/2; %volume 1 solo tank
vol_tank1_dato=0.45883779; %volume 1 solo tank assegnato
err_tank1=vol_tank1_dato-vol_tank1; %errore
err_percentuale_tank1=err_tank1/vol_tank1_dato; %errore percentuale
%pressure selection: helium or N2
p_tank1=2.413*10^6; %pressione in Pascal
R_specific_he=2077.3; % Joule/KgK
R_specific_N2=296.8;%Joule/KgK
R=8314;
gamma_he=1.67;
gamma_N2=1.40;
T_tank=293;
p_press=2.8958*10^7;
m_press_he=((p_tank1*vol_h_mar)/(R_specific_he*T_tank))*(gamma_he/(1-(p_tank1/p_press))) %massa pressurizzante helio (kg)
m_press_N2=(p_tank1*vol_h_mar/(R_specific_N2*T_tank))*(gamma_N2/(1-p_tank1/p_press));  %massa pressurizzante N2  (kg)
%we select helio lower mass
rho_he=0.1784; %densità elio
vol_press_dato=0.08193532; %volume di pressurizzante m^3 dato
vol_press=m_press_he*R_specific_he*T_tank/p_press %volume di pressurizzante

err_press=vol_press_dato-vol_press; %errore tra i volumi dei pressurizzanti
err_press_percentuale=err_press/vol_press_dato






