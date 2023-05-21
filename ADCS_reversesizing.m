%% Dati esercizio
clc
close all
clear all
L1=3.9; %documento da 40 pagine?
L2=2.7;
L3=2.6;
V=L1*L2*L3; %volume
m=1846; %massa totale dry+ fuel
A=L1*L2; %area
rho=m/V; %assunta uniforme in tutto il satellite
I1=rho*(L2^3+L3^3)/3; %minor axis
I2=rho*(L3^3+L1^3)/3;
I3=rho*(L2^3+L1^3)/3; %major axis
Ls1=4.2672; %solar panel length
Ls2=3.2004;
Ls3=5.5*10^-3; %solar panel thickness
Lhga=2.5908; %lunghezza antenna
As=Ls1*Ls2;   %deployed solar panel areas doc: LRO: leading NASA's way back to the Moon
Vs=Ls1*Ls2*Ls3; %solar panel volume
rhos=2.06; %take existing density as a reference https://www.spectrolab.com/DataSheets/Panel/panels.pdf
mY=rhos*Vs;   %massa pannelli solari 
Iys=rhos*(Ls1^3+Ls2^3)/3; %inerzia pannelli solai
Izhga=rho*(Lhga^3)/3 %inerzia antenna
I2=I2+Iys;
I3=I3+Izhga

%% Gravity gradient
teta=5*pi/180; %inclination is 85°, hence theta = 90-i
mu=4902.777; %mu luna da wiki
R=30+1737.4 %30+raggio medio luna, raggio minimo
Tgg=1.5*mu*(I3-I1)*sin(2*teta)/R^3  %torque gravity gradient
%% Solar radiation pressure 
c=3*10^8; %speed of light

Fs=1367; %solar constant of the Moon, assumed equal to Earth's one due to their vicinty
q = 0.5; %reflectivity coefficient of the body assumed as average
I=0; %incidence angle with the solar arrays, take 0 as worst case
armx=L2/2+Ls2/2;%distance of centre of solar pressure on centre of gravity
%ipotizziamo centro di pressione =baricentro pannello  e si trova a metà 
Tsrp=Fs*As*(1+q)*cos(I)*armx/c;%solar radiation prressure torque
%% reaction wheel sizing
eta=2;%disturbance margin factor stima preliminare
Td=(Tgg+Tsrp);
Trw=eta*Td;% reaction wheels control torque
Tnominal=0.16; %maximum reaction wheel momentum da documento di Matteo parte 1
if Trw>Tnominal
    disp('sizing incorrect')
end
a=(R+(216+1737.4))/2; %semi major axis
torbit=2*pi*sqrt((a)^3/mu); %both a and mu are in km
hrw=Trw*torbit; %momentum storage of RW
hrwnominal=60; %preso dal documento di matteo parte 1 pag 3
%forse è necessario mettere il confronto con il max angular momentum of
%wheels
norbit=hrwnominal/hrw; %numero di orbite dopo la quale è necessario desaturare
%% thrusters 
n=2; %number of thrusters
F=22; %thrust of each thrusters 22N
b=L2/2; %braccio da controllare
T=n*F*b; %torque moment of thrusters
Isp=229.5%impulso specifico thrusters preso dalle slide
go=9.81
F_th=Td/(n*b); %force to counteract the external disturbances by thrusters
t_dump=5
F=hrwnominal/(t_dump*b*n)
if t_dump<1 
    disp ('error')
end
mass_prop=t_dump*F/(Isp*go)
T_scientific=60*60*24*365*2;
total_mass=4*mass_prop*T_scientific/(torbit*ceil(norbit-1)) %massa consumata dagli 8 thrusters ogni 2 anni
mass_1thrust=0.72 %kg slide19
