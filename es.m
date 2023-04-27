clc
clear all
close all
delta_v=1618;%somma velocità trovate a pag 5
 
Isp=318; %impulso specifico mediano
m_dry=555; %massa a vuota
rho_h=1010; %densita idrazina (kg/m^3)
g0=9.81;
mr=((exp(delta_v/(Isp*g0)))); %mass ratio
mr_dato=1.68;
err=mr_dato-mr;%differenza tra mfuel dato e calcolato 
err_percentuale=err/mr_dato;  %errore percentuale
delta_v_mar_020=delta_v; %velocità con margine SK
m_dry_mar=m_dry*1.2;  %m dry con margine
m_fuel=1123-m_dry_mar
vol_h=0.453; %volume hydrazina
vol_h_mar=vol_h; %volume h con margine
vol_tank1=vol_h_mar; %volume 1 solo tank
vol_tank1_dato=0.2275; %volume 1 solo tank assegnato
err_tank1=vol_tank1_dato-vol_tank1; %errore
err_percentuale_tank1=err_tank1/vol_tank1_dato; %errore percentuale
%pressure selection: helium or N2
p_tank1=13.7*10^5; %pressione in Pascal
R_specific_he=2077.3; % Joule/KgK
R_specific_N2=296.8;%Joule/KgK
R=8314;
gamma_he=1.67;
gamma_N2=1.40;
T_tank=300;
p_press=10*p_tank1;
m_press_he=((p_tank1*vol_h_mar)/(R_specific_he*T_tank))*(gamma_he/(1-(p_tank1/p_press)))*1.2 %massa pressurizzante helio (kg)
m_press_N2=(p_tank1*vol_h_mar/(R_specific_N2*T_tank))*(gamma_N2/(1-p_tank1/p_press))*1.2;  %massa pressurizzante N2  (kg)
%we select helio lower mass
rho_he=0.1784; %densità elio
vol_press_dato=0.101; %volume di pressurizzante m^3 dato
vol_press=m_press_he*R_specific_he*T_tank/p_press %volume di pressurizzante

err_press=vol_press_dato-vol_press; %errore tra i volumi dei pressurizzanti
err_press_percentuale=err_press/vol_press_dato



% 
% 
