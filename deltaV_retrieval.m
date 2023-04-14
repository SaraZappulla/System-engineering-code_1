%% Earth to Moon direct transfer

% This code is meant to retrieve the delta v necessary to achieve the moon
% orbit in a direct transfer. The originar trasfer lasted between 4 and 5
% days. 
% The assumption done to calculate the deltav budget are here listed:
% The orbiter is performing an Hohmann transfer from the Earth surface
% (even tho Hohmann transfer is supposed to be between two circular and
% coplanar orbit, the injection into LTI (lunar trasfer insertion) was
% performed using the same launcher)
% Third body problem is not accounted in this calculation. The orbiter is
% arriving to the Moon SOI and then perform a insertion in the
% Commissioning orbit
% The insertion in the commissioning orbit is done in one impulsive
% manoeuver and not in 4 LOI in a long time span
% The correction done with the MCC is not accounted in this code

clc 
clear all
% departing date from Earth and arriving date on the Moon
dep_time1 = date2mjd2000([2009,06,18,05,32,0]); %18 june 2009
arr_time1 = date2mjd2000([2009,06,22,12,0,0]); %22 june 2009
mu1 = 398600; %Earth planetary constant
mu2 = astroConstants(20); %Moon planetary constant

%% definition of initial positions

[xP, vP] = ephMoon(arr_time1); % Moon analytic epherides, function used in Om course
module_xP = norm(xP); %radius module of moon referred to earth

% Considering an Hohmann transfer from the Earth surface to the Moon,
% outside its SOI, so considering the transfer to the center of the body
rEarth = 6378; %km average earth Radius
rp = rEarth; %periapsis radius of the tansfer orbit
ra = module_xP; %apoapsis radius of the transfer orbit
at = (rp + ra) /2; % [km]semi-major axis of the transfer orbit
et = (ra-rp)/(ra+rp); % eccentricity of the transfer orbit
pt = at*(1-et^2); % [km]semi-latum reptum of the transfer orbit
Vat = sqrt(mu1/pt)*(1-et); % [km/s]velocity at the apoapsis of the transfer orbit
Vpt = sqrt(mu1/pt)*(1+et); % [km/s]velocity at the periapsis of the transfer orbit

module_vP = norm(vP); % [km/s] moon module velocity
vLEO = 0; %[km/s] Assumed as 0 because velocity of Earth revolution negligible 
% with respect to the moon orbit velocity

deltavp = (Vpt-vLEO) %[Km/s] DeltaV to enter the tranfer trajectory
%deltava = module_vP - vat
tt = (sqrt(at^3/mu1)*pi)/3600/24 %[days]total transfer time for the lunar transfer

%% Insertion in lunar orbit

% With respect to moon reference plane the commissioning orbit has these average
% parameters
rmoon = 1737.4; % Km average moon radius
ra_com = 216 + rmoon; %km apocenter radius of Commissioning orbit 
rp_com = 30 + rmoon; %km pericenter radius of commissioning orbit
omega_com = 1.5*pi; %rad argument of pericenter of the commissioning orbit
e_com = 0.043; % eccentricity of the commissioning orbit
theta = 0/180*pi; % assumed so that the transfer is accomplished at the periapsis of the commissioning orbit
a_com = (rp_com + ra_com) /2; 
p_com = a_com*(1-e_com^2);

% this manoeuver is considered inside the Moon SOI
% orbiter velocity with respect to moon:
vat = module_vP - Vat; % moon speed - orbiter speed around the Earth 
vrad_com = sqrt(mu2/p_com)*(e_com*sin(theta)); %radial velocity at inserion point
vtheta_com = sqrt(mu2/p_com)*(1+e_com*cos(theta)); %tangential velocity at insertion point
v_com = norm([vrad_com,vtheta_com]); 

deltav1 = v_com-vat %[km/s] deltav needed to enter the commissioning orbit

Vreal1 = (567 + 185+133+41)/1000 %[km/s] delta v taken from the real data from LTI to commissioning orbit

error1 = deltav1-Vreal1 %error between computed deltaV and real one
percentage1 = error1/Vreal1 % percentage of error

%% orbit representation

% Representation of the Hohmann transfer 
%transfer orbit
ToF = tt*24*3600;
tspanT = linspace(0,ToF,10000);
rE = [-6378, 0, 0];
vE = [0 -Vpt 0];
yT = [rE vE];
options= odeset('RelTol',1e-13,'AbsTol',1e-14); %specifications needed for ode113
[tT,YT] = ode113(@(t,y) twobodyproblem_ode(t,y,mu1), tspanT, yT, options);

ToF = tt*24*3600;
tspanM = linspace(-100000,100000,10000);
xmoon = [module_xP,0,0];
vmoon = [0, module_vP,0];
yM = [xmoon vmoon];
options= odeset('RelTol',1e-13,'AbsTol',1e-14); %specifications needed for ode113
[tT,YM] = ode113(@(t,y) twobodyproblem_ode(t,y,mu1), tspanM, yM, options);

figure(1)
hold on
grid on
axis equal
plot3(YT(:,1),YT(:,2),YT(:,3),'k');
plot3(YM(:,1),YM(:,2),YM(:,3),'b--');
plot3(rE(1),rE(2),rE(3),'ro');
plot3(module_xP,0,0,'bo');
earth_sphere
legend('Transfer orbit','Moon orbit','Orbiter position at departing time','Moon position at arrival time')

%% From commisioning to nominal orbit 
% a direct manowuver is computed to pass from the commissioning orbit to
% the nominal orbit
% Nominal orbit e = 0 average 
% a_com, e_com, p_com, already implemented up
r_nom = 50 + rmoon; % km nominal orbit radius
V_nom = sqrt(mu2/r_nom); % nominal orbit speed if considered as circular 
% with an approximation of +/- 15.1 km

% intersectin of commissioning orbit with nominal orbit
theta = acos(((p_com/r_nom)-1)/e_com);
Vrad_com = sqrt(mu2/p_com)*e_com*sin(theta); %radial velocity at manoeuver point
Vtheta_com = sqrt(mu2/p_com)*(1+e_com*cos(theta)); %tangent velocity at manoeuver point

deltavrad = 0-Vrad_com;
deltavtheta = V_nom - Vtheta_com;

Vnom_com = norm(deltavrad+deltavtheta)
V_real2 = 50/1000

error2 = (Vnom_com - V_real2)
percentage2 = error2/V_real2

%% Station keeping

% The actual station keeping is performed twice a month with two
% manoeuvers:
% the first one from a circular orbit (1) (which eccentricity oscillate to
% maximum 0.007 and argument of pericenter of 20°) to a completely circular
% orbit (2)
% the second one a completely circular (2) to circular orbit (3) (which eccentricity oscillate to
% maximum 0.007 and argument of pericenter of 160°)

% Here listed the orbit datas
e1 = 0.007; %orbits' eccentricity
e2 = 0;
e3 = e1;

omega1 = 20; %[°] argument of pericenter
omega2 = 0;
omega3 = 160;

rp = rmoon + 50 -15.1; % periapsis radius of orbit 1 and 3
ra = rmoon + 50 +15.1; % apoapsis radius of orbit 1 and 3
rc = rmoon + 50; %circular orbit radius

a1 = (rp + ra)/2;
p1 = a1*(1-e1^2);


% Option 1: SK performed with just one manoeuver to correct the argument of
% pericenter
deltaeta = 140; %[°] difference between omega1 and omega3
theta11 = deltaeta/2 + omega1; %[°]true anomaly of the manoeuver on orbit 1
theta21 = 360 - (deltaeta/2 - omega3); %[°]true anomaly of the manoeuver on orbit 3
V11 = sqrt(mu2/p1)*e1*sin(theta11*pi/180) %delta v of the manoeuver

Vreal = 11/1000 %km/s

error31 = V11 - Vreal
percentage31 = error31/Vreal

% Option 2: more similar to the real transfer considering two sequential
% manoeuvers to do the SK

% true anomaly of the intersection with the circular orbit and velocities
theta1 = acos(((p1/rc)-1)/e1);
Vrad1 = sqrt(mu2/p1)*e1*sin(theta1);
Vtheta1 = sqrt(mu2/p1)*(1+e1*cos(theta1));
V1 = norm([Vrad1,Vtheta1]); 

Vc = sqrt(mu2/rc); %velocity on circular orbit 
V12rad = Vrad1; 
V12theta = Vc - Vtheta1;

deltav32 = norm(V12rad,V12theta)

error32 = deltav32 - Vreal
percentage32 = error32/Vreal

%% verification of moon SOI

% Radius of sphere of influence of the moon 
RSOI = module_xP*(mu2/mu1)^0.4

% Larger than our low lunar orbit so the approximation above can be
% considered
