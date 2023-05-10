clc;
clear;
close all;

%% Ka-band for HGA
% Part 1 of the design

%S-band (tracking, telemetry and commanding) and high data rate Ka-band (downlink only)
% 
% SD=4; %science data [kbps]
% TM=100; %telemetry [kbps]
% %data= TM + SD;

R_data= 25000; %[kbps] %Range from 25 to 100 --> choosing the worst case scenario it would be 25000 --> maybe it's better to choose 100Mbps
%UHF %ultra-high-frequency
%X %X_band
%S %S_band
%Choose the kind of amplifier between TWTA (heavier and higher efficiency)
%and SSA (lighter and better for lower power) --> we chose TWTA
% P_input %Input power to the TTMTC system 
% %From graph enter with P_input and find mu_amp (choose the curve: SSA or TWTA)
% 

%P_tx=mu_amp*P_input; %P_output [W]
P_tx=41.9; %P_output [W]
P_txlog=10*log(P_tx); %In logaritmic scale

%Choose BER (Bit error rate) between TM/data downlink and TC uplink (valori sulle slides per i due casi)
BER = 10^(-5); %we chose TM/data downlink
%Enter into the graph with BER and choose the curve in order to retrieve
%Eb_No_min
Eb_No_min=5.5; %[dB]
%From QPSK and Reed-Solomon find alpha_mod and alpha_enc and simbol/bit -->
%by using the Reed-Salomon curve
alpha_mod=2; 
alpha_enc=2; 
R_data_real= R_data*alpha_enc/alpha_mod;
% We have a parabolic HGA (high-gain antenna):
mu_ant=0.55; % parabolic antenna --> seen from the figure of LRO
D_ant=1.1; %diameter of the antenna [m] from the graph mass-diameter --> actually (from the figure) it seems smaller
f=25.65*10^9; %frequency [Hz]
c=3*10^8; %velocity of light [km/s]
lambda=c/f; %wavelength
G_ant=10*log(pi*D_ant^2*mu_ant/(lambda^2)); %gain of the antenna [dB]
L_cable=-2; %Cable losses between -1dB and -3dB [dB]

% Part 2 of the design (Ground station)

D_ant_ground=18.3; %diamter of the ground antenna [m] --> we chose WS1 New Mexico
f_ground=25.5*10^9; %frequency from ground [Hz]
lambda_ground=c/f_ground; %wavelength
G_ant_ground=10*log(pi*D_ant_ground^2*mu_ant/(lambda_ground^2)); %gain of the antenna [dB]
theta_ground=65.3*lambda_ground/D_ant_ground; %beamwidth
%CAMBIARE r
r= 384.4*10^6; %distance between ground station and the satellite [m]
eta=0.1; %pointing accuracy
Lspace=20*log(lambda/(4*pi*r)); %Free space losses
Lpoint=-12*(eta/theta_ground)^2; %pointing losses
%Losses due to atmospheric (rain) --> compute them from the figure/graph --> L_atm
L_atm=3.8*10^-2; %[dB]

EIRP=P_tx+G_ant+L_cable; %effective isotropic radiated power

P_rx=EIRP+G_ant+Lspace+Lpoint+L_atm; %Receiver power
%Retrieve the temperature of the s/c and DSN (deep-space network) from the
%ground station antenna characteristics of the antenna (se non trovi, prendi i dati dalle slides)
T_s=21; %DSN temperature from the slides [K]

k=1.38*10^-23; %constant (Boltzmann)
No=10*log(k*T_s); %Noise density
%Ts is the DSN temperature. No is from Eb/No (computed before)
Eb_No=P_rx-No-10*log(R_data_real); %ratio Eb/No --> Error per bit to noise density

%Compare: if Eb_No> Eb_No_min + 3dB  --> the sizing is correct
beta_mod=deg2rad(78);%Modulation index
P_mod_loss=20*log(cos(beta_mod)); %Carrier modulation index reduction
P_carrier=P_rx+P_mod_loss; %Carrier power
B=30; %Receiver bandwidth [Hz]
SNR_carrier=P_carrier-No-10*log(B); %Signal to noise ratio

SNR_min=10; %from the slides [dB]

SNR_margin=SNR_carrier-SNR_min;

%Compare: if SNR_margin> 3dB  --> the sizing is correct
%% S-band for HGA
clc;
clear;
close all;


R_data= 0.125; %[kbps] %for downlink NEW

P_tx=5.8; % Diplexers NEW
P_txlog=10*log(P_tx); %

%Choose BER (Bit error rate) between TM/data downlink and TC uplink (valori sulle slides per i due casi)
BER = 10^(-5); %we chose TM/data downlink
%Enter into the graph with BER and choose the curve in order to retrieve
%Eb_No_min
Eb_No_min=9.5; %[dB] %uncoded(BPSK)

alpha_mod=1; %BPSK 
alpha_enc=2; 
R_data_real= R_data*alpha_enc/alpha_mod;
% We have a parabolic HGA (high-gain antenna):
mu_ant=0.55; % parabolic antenna --> seen from the figure of LRO
D_ant=1.1; %diameter of the antenna [m] from the graph mass-diameter --> actually (from the figure) it seems smaller

f=2271.2*10^6; %frequency [Hz] % NEW

c=3*10^8; %velocity of light [km/s]
lambda=c/f; %wavelength
G_ant=10*log(pi*D_ant^2*mu_ant/(lambda^2)); %gain of the antenna [dB]
L_cable=-2; %Cable losses between -1dB and -3dB [dB]

% Part 2 of the design (Ground station)

D_ant_ground=18.3; %diamter of the ground antenna [m] --> we chose WS1 New Mexico
f_ground=2.2*10^9; %frequency from ground [Hz] NEW
lambda_ground=c/f_ground; %wavelength
G_ant_ground=10*log(pi*D_ant_ground^2*mu_ant/(lambda_ground^2)); %gain of the antenna [dB]
theta_ground=65.3*lambda_ground/D_ant_ground; %beamwidth
%CAMBIARE r
r= 384.4*10^6; %distance between ground station and the satellite [m]
eta=0.1; %pointing accuracy
Lspace=20*log(lambda/(4*pi*r)); %Free space losses
Lpoint=-12*(eta/theta_ground)^2; %pointing losses
%Losses due to atmospheric (rain) --> compute them from the figure/graph --> L_atm
L_atm=3.6*10^-2; %[dB] NEW

EIRP=P_tx+G_ant+L_cable; %effective isotropic radiated power

P_rx=EIRP+G_ant+Lspace+Lpoint+L_atm; %Receiver power
%Retrieve the temperature of the s/c and DSN (deep-space network) from the
%ground station antenna characteristics of the antenna (se non trovi, prendi i dati dalle slides)
T_s=21; %DSN temperature from the slides [K]

k=1.38*10^-23; %constant (Boltzmann)
No=10*log(k*T_s); %Noise density
%Ts is the DSN temperature. No is from Eb/No (computed before)
Eb_No=P_rx-No-10*log(R_data_real); %ratio Eb/No --> Error per bit to noise density

%Compare: if Eb_No> Eb_No_min + 3dB  --> the sizing is correct
beta_mod=deg2rad(78);%Modulation index
P_mod_loss=20*log(cos(beta_mod)); %Carrier modulation index reduction
P_carrier=P_rx+P_mod_loss; %Carrier power
B=30; %Receiver bandwidth [Hz]
SNR_carrier=P_carrier-No-10*log(B); %Signal to noise ratio

SNR_min=10; %from the slides [dB]

SNR_margin=SNR_carrier-SNR_min;

%Compare: if SNR_margin> 3dB  --> the sizing is correct



%% S-band for 2 Omni-directional
clc;
clear;
close all;


R_data= 4; %[kbps] %for downlink NEW

P_tx=5.8; % Diplexers NEW
P_txlog=10*log(P_tx); %

%Choose BER (Bit error rate) between TM/data downlink and TC uplink (valori sulle slides per i due casi)
BER = 10^(-7); %we chose TM/data downlink
%Enter into the graph with BER and choose the curve in order to retrieve
%Eb_No_min
Eb_No_min=11.5; %[dB] %uncoded(BPSK)

alpha_mod=1; %BPSK 
alpha_enc=2; 
R_data_real= R_data*alpha_enc/alpha_mod;
% We have a parabolic HGA (high-gain antenna):
mu_ant=0.7; % 'horn antenna?' --> seen from the figure of LRO
D_ant=0.3*2; %diameter of the antenna [m] from the graph mass-diameter --> actually (from the figure) it seems smaller

f=2271.2*10^6; %frequency [Hz] % NEW

c=3*10^8; %velocity of light [km/s]
lambda=c/f; %wavelength
G_ant=10*log(pi*D_ant^2*mu_ant/(lambda^2)); %gain of the antenna [dB]
L_cable=-2; %Cable losses between -1dB and -3dB [dB]

% Part 2 of the design (Ground station)

D_ant_ground=18.3; %diamter of the ground antenna [m] --> we chose WS1 New Mexico
f_ground=2.2*10^9; %frequency from ground [Hz] NEW
lambda_ground=c/f_ground; %wavelength
G_ant_ground=10*log(pi*D_ant_ground^2*mu_ant/(lambda_ground^2)); %gain of the antenna [dB]
theta_ground=65.3*lambda_ground/D_ant_ground; %beamwidth
%CAMBIARE r
r= 384.4*10^6; %distance between ground station and the satellite [m]
eta=0.1; %pointing accuracy
Lspace=20*log(lambda/(4*pi*r)); %Free space losses
Lpoint=-12*(eta/theta_ground)^2; %pointing losses
%Losses due to atmospheric (rain) --> compute them from the figure/graph --> L_atm
L_atm=3.6*10^-2; %[dB] NEW

EIRP=P_tx+G_ant+L_cable; %effective isotropic radiated power

P_rx=EIRP+G_ant+Lspace+Lpoint+L_atm; %Receiver power
%Retrieve the temperature of the s/c and DSN (deep-space network) from the
%ground station antenna characteristics of the antenna (se non trovi, prendi i dati dalle slides)
T_s=21; %DSN temperature from the slides [K]

k=1.38*10^-23; %constant (Boltzmann)
No=10*log(k*T_s); %Noise density
%Ts is the DSN temperature. No is from Eb/No (computed before)
Eb_No=P_rx-No-10*log(R_data_real); %ratio Eb/No --> Error per bit to noise density

%Compare: if Eb_No> Eb_No_min + 3dB  --> the sizing is correct
beta_mod=deg2rad(78);%Modulation index
P_mod_loss=20*log(cos(beta_mod)); %Carrier modulation index reduction
P_carrier=P_rx+P_mod_loss; %Carrier power
B=30; %Receiver bandwidth [Hz]
SNR_carrier=P_carrier-No-10*log(B); %Signal to noise ratio

SNR_min=10; %from the slides [dB]

SNR_margin=SNR_carrier-SNR_min;

%Compare: if SNR_margin> 3dB  --> the sizing is correct

