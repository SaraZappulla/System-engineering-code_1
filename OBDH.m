%memory starting from data measured in words

code_RW=1000;
code_thruster=600;
code_CSS=500;
code_MIMU=800;
code_ST=2000;
code_kalman=2000; %used kinematic integration
code_error=1000;
code_attdet=15000;
code_attcntrl=24000;
code_orbitprop=13000;
code_eph=3500;
code_EPS=2400;
code_TCS=800;
code_telemetry=2000;

data_RW=300;
data_thruster=400;
data_CSS=100;
data_MIMU=500;
data_ST=15000;
data_kalman=200; %used kinematic integration
data_error=100;
data_attdet=3500;
data_attcntrl=4200;
data_orbitprop=4000;
data_eph=2500;
data_EPS=1000;
data_TCS=1500;
data_telemetry=6500;



PC_ROM = 4;
PC_RAM = 36;
PC_bitwordsratio = 32; %Lunar Reconnaissance Orbiter Mission and Spacecraft Design, Craig R. Tooley
data_ADCS = (data_RW*4+data_thruster*8+data_ST*2+data_CSS*10+data_MIMU+data_kalman+ ...
    data_error+data_attdet+data_attcntrl+data_orbitprop+data_eph);
ROM=(data_ADCS+data_telemetry+data_TCS+data_EPS)*PC_bitwordsratio/8/1000
%smaller than PC_ROM: design ideal
code_ADCS = (code_RW*4+code_thruster*8+code_ST*2+code_CSS*10+code_MIMU+code_kalman+ ...
    code_error+code_attdet+code_attcntrl+code_orbitprop+code_eph);

RAM=(data_ADCS+data_telemetry+data_TCS+data_EPS+code_ADCS+code_EPS+code_telemetry+code_TCS) ... 
    *PC_bitwordsratio/8/1000
%smaller thna PC_RAM: design ideal