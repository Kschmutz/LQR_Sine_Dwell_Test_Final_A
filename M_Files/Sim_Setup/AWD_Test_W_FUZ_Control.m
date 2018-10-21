%clear all; close all; clc;
fprintf('Loading data for rear wheel driving model...')

open_system('All_Combined\AWD_EV_MODEL_rev2.mdl')
open_system('All_Combined\Controller_ABS_VLC_AYC_ALGO2.mdl')

open_system('All_Combined\AWD_EV_MODEL_rev2_SMC.mdl')
open_system('All_Combined\Controller_ABS_VLC_AYC_ALGO2_SMC.mdl')
%set_param('AWD_EV_MODEL','AlgebraicLoopSolver','LineSearch')
set_param('AWD_EV_MODEL_rev2','AlgebraicLoopSolver','TrustRegion')
%set_param('AWD_EV_MODEL_rev2','AlgebraicLoopSolver','LineSearch')
%USE ABOVE STATEMENT IF SOLVER HAS CONVERGENCE ERROR!!!!!!!!!!


%% Inputs
%TFL = 0;               % Torque input of front left tire [Nm]
%TFR = 0;               % Torque input of front right tire [Nm]
%TRL = 50;              % Torque input of rear left tire [Nm]
%TRR = 50;              % Torque input of rear right tire [Nm]

%fuzzyLogicDesigner
%xlabel('$\dot{r}$','FontSize',20,'Interpreter','latex')    //changes labels on axis
%ylabel('$Degree of Membership$','FontSize',20,'Interpreter','latex')
%plotmf(Fuzzy_AYC_Ctl,'input',1)     //plots fuzzy function
%plottools
%plottools('off')
%plotfis(Fuzzy_AYC_Ctl)             //plots whole FIS
%Load Fuzzy Inference System Controllers
%Fuzzy_Slip_Ctl_VLC = readfis('Fuzzy_Controller_Files\Fuzzy_Slip_Ctl_VLC');    %VLC FIS
%Fuzzy_Slip_Ctl_ABS = readfis('Fuzzy_Controller_Files\Fuzzy_Slip_Ctl_ABS');    %ABS FIS
%Fuzzy_AYC_Ctl      = readfis('Fuzzy_Controller_Files\Fuzzy_AYC_Ctl');         %AYC FIS

%Fuzzy_Slip_Ctl_VLC = readfis('C:\Users\kschmutz\OneDrive\Thesis MATLAB Working Directory\Fuzzy_Controller\Fuzzy_Slip_Ctl_VLC_2');      %VLC FIS
%Fuzzy_Slip_Ctl_ABS = readfis('C:\Users\kschmutz\OneDrive\Thesis MATLAB Working Directory\Fuzzy_Controller\Fuzzy_Slip_Ctl_ABS_2');      %ABS FIS
%Fuzzy_AYC_Ctl      = readfis('C:\Users\kschmutz\OneDrive\Thesis MATLAB Working Directory\Fuzzy_Controller\Fuzzy_AYC_Ctl');             %AYC FIS

%PassBand = 100;
%StopBand = 200;

%%
%ABS Test
% Split_u_Time_On = 500;          %Set time for split-u to start (Keep off w large time)
% 
% Throttle_Step_Time = 0;       %Step time of throttle signal
% Throttle_Init_Val = 0;          %Initial throttle value
% Throttle_Final_Val = -1;        %Final throttle value
% 
% Steering_Input_Select = 1;      %Steering Angle Selection (1 = No SA)
% SA_Start_Time = 1;            %Don't Care since channel not selected
% SA_Slope = 1;                   %Don't Care since channel not selected
% 
% Vx0 =26.82;                     % Initial vehicle longitude speed [m/s]
%%
%%
%Sine Test - LATEST AND GREATEST
% Split_u_Time_On = 500;          %Set time for split-u to start (Keep off w large time)
% 
% Throttle_Step_Time = 0;       %Step time of throttle signal
% Throttle_Init_Val = 0;          %Initial throttle value
% Throttle_Final_Val = 0;        %Final throttle value
% 
% Steering_Input_Select = 3;      %Steering Angle Selection (1 = No SA)
% SA_Start_Time = 1;            %Don't Care since channel not selected
% SA_Slope = 1;                   %Don't Care since channel not selected
% 
% Vx0 =22.35;                     % Initial vehicle longitude speed [m/s]
% SA_A = 6;

%%
%Constant Steering Angle Test - LATEST AND GREATEST
Split_u_Time_On = 500;          %Set time for split-u to start (Keep off w large time)

Throttle_Step_Time = 500;       %Step time of throttle signal
Throttle_Init_Val = 0;          %Initial throttle value
Throttle_Final_Val = .1;        %Final throttle value (DOESN'T MATTER)

Steering_Input_Select = 2;      %Steering Angle Selection (2 = Ramp)
SA_Start_Time = .2;
SA_Slope = -1;

Vx0 =13.41;                     % Initial vehicle longitude speed [m/s]
SA_A = 2;

%%
%%
%Split-u Test
% Split_u_Time_On = 1;          %Set time for split-u to start (Keep off w large time)
% 
% Throttle_Step_Time = 1.5;       %Step time of throttle signal
% Throttle_Init_Val = 0;          %Initial throttle value
% Throttle_Final_Val = -1;        %Final throttle value (DOESN'T MATTER)
% 
% Steering_Input_Select = 1;      %Steering Angle Selection (1 = No SA)
% SA_Start_Time = .2;
% SA_Slope = 1;
% 
% Vx0 =26.82;                     % Initial vehicle longitude speed [m/s]
%%
%%
%Variables wich remain constant for all tests
Vy0 = 0.0001;                   % Initial vehicle lateral speed [m/s]
r0 = 0.0001;                    % Initial yaw rate [rad/s]

SR_Eq_Accel_Brake_Threshold = -0.01;       %Throttle position threshold for Slip Ratio to change definitions from Accel to Brake or Vice-Versa

T_Avail = 175;          % Peak Torque available by motors [Nm]

GRR = 10;               % Gear reduction ratio (GRR:1) -> Multiplies torque
GRR_E = .99;            % Gear reduction efficiency (.95-.99 for Spur/Helical)

%D_Slip = 0.1;            % Desired slip for PID
%%Choose which controller!
Yaw_Control_Select = 1;     %1:LQR-STA, 2:SMC 
%%
% Sliding Mode Controller Settings
Target_SR = 0.1;   %ABS Test
PWM_Low_Lim = 0.05;
PWM_SW_Threshold = 0;
Yaw_Ctrl_Gain = 0.2;
%Slip_Err_P_Gain = 5000;
Tau_SRC = 1/(2*pi*(4));
fcutoff_SRC = 1/(2*pi*(Tau_SRC));
%Slip_Err_D_Gain = 2;     %small D gain results in better (harder stopping) control (0.01) but exeeds limit (SR=0.1)
%Lat_Accel_Err_Gain = 0.2;  %fixed from paper as 0.15

%Slip Ratio Controller gains
SE_P_Gain = 0.13;
SE_D_Gain = 0.002;
SE_Alpha_Gain = 30;
SE_Beta_Gain = 500;

YAW_P_Gain = 30;
YAW_D_Gain = 15;
YAW_Alpha_Gain = 0.1;
YAW_Beta_Gain = 4;

R_SA_P_Gain = 0.08;
R_SA_D_Gain = 0.01;
R_SA_Alpha_Gain = 0.01;
R_SA_Beta_Gain = 5;

V_SA_P_Gain = 0.08;
V_SA_D_Gain = 0.01;

f_R_SA_cutoff = 1;
f_R_SA_cutoff_HP = 0.5;
f_YAW_cutoff = 1;

YAW_Prop_Gain = 0.02;
YAW_Int_Gain = 10;

%old (But maybe okay..)
%YAW_P_Gain = 20;
%YAW_D_Gain = 8;
%YAW_Alpha_Gain = 10;
%YAW_Beta_Gain = 100;

WT_P_Gain = 0;
%WT_I_Gain = 0.5;
f_WT_cutoff = 2;

%LQR-STA Yaw/Beta Controller parameters
STA_BETA = 5;
STA_DBETA = 0.2;
STA_YE = .15;
STA_DYE = 0.03;
STA_OUT_K = 5.8;
STA_OUT_K_BETA = 6.8;

SR_Lim_p = 0.08;
SR_Lim_n = -0.08;

STA_BETA_a = 150;
STA_DBETA_a = 10;
STA_YE_a = 3;
STA_DYE_a = 1;
STA_OUT_K_a = 4.8;

KX2 = 0.000966173905722;
KX1 = 0.000470209135277;
KX0 = -0.200020354244;

%SM Yaw controller parameters (Comparison Algorithm)
Beta_Err_P_Gain = 10;
Yaw_Err_P_Gain = 5;
Yaw_Ctrl_Gain_SMCC = 0.2;
Tau_Yaw = 1/(2*pi*20);

%single test values
SA_SAT_p = 4;  SA_SAT_n = -SA_SAT_p;
Vx0 = 13.41;


%Motor Model
z=0.005;

%% Parameters
g = 9.81;               %   Gravity acceleration [m/s^2]
m  = 1350;              %   Mass of the vehicle [kg]
Lf = 1.5;               %   Distance from front axle to CoG [m]
Lr = 1.5;               %   Distance from rear axle to CoG [m]
Lw = 1.5;               %   Distance between wheels [m]
hg = 0.5;               %   Hight of CoG [m]
Ixx = 0.8*(m*(Lw/2)^2);              %   Moment of Inertia roll axis
Iyy = 0.8*(m*((Lr+Lf)/2)^2);              %   Moment of inertia pitch axis
%Kspr = ??;              %   spring constants of suspension
%Cdamp = ??;             %   damping coefficient of suspension

Cf = 90000;             %Front Cornering Stiffness
Cr = 90000;             %Rear Cornering Stiffness

Jz = 1/12*m*((Lf+Lr)^2+Lw^2);    %   Body moment of inertia around vertical axle
%Jw changed from 12 -> 1.2. Wheel is being treated as hollow ring.
Jw = 1.2;            %   Wheel rotational moment of inertial >>Inertia = Mass(at radius r) * radius^2; sum multiple masses at diff radii for total
                    %   Value should be 0.3-0.5
Rw = .33;           %   Wheel rolling radius [m]

% Magic formular (Longitudinal)
Kxnorm = 30;      % normalized stiffness
Kxnorm_2 = 8;
%(Condition 1)
Muxp = .99;         % peak friction coefficient
Muxs = 0.27;         % sliding friction coefficient was .5 kds 5/16/14
%(Condition 2)
Muxp_2 = 0.3;         % peak friction coefficient
Muxs_2 = 0.29;       % sliding friction coefficient 


% Magic formular (Lateral)
Ky0 = 90000;        % static cornering stiffness [N/rad]
Fz0 = 3000;         % static vertical load     [N]
Fz = m*g/4;
%(Condition 1)
Muyp0 = 0.85;       % static peak friction coefficient
Muys = 0.80;        % friction coefficient when sliding 
%(Condition 2)
Muyp0_2 = 0.3;       % static peak friction coefficient
Muys_2 = 0.29;        % friction coefficient when sliding 

% Combined slip parameters
%(Condition 1)
rx1 = 15;
rx2 = 15;
ry1 = 15;
ry2 = 15;
%(Condition 2)
rx1_2 = 15;
rx2_2 = 15;
ry1_2 = 15;
ry2_2 = 15;

%%  Vehicle Dynamics Model
%   We take "idnlgreydemo11.m" as reference to construct this model. This
%   model uses some approximations, so it is not that good. Anyway, as time
%   goes by, we will improve it.
%
%   In our model, vehicle has three degrees of freedom, which are longitude
%   motion, lateral motion and yaw rate. Other freedoms will be taken into
%   consideration as our research processes.

%   By using Newton's law and coordinate transformation, the longitude
%   speed V_x, the lateral speed V_y and yaw rate r around the CoG(center 
%   of gravity) can be expressed by following three differential equations.
%
%      d
%   m[ -- Vx(t) - Vy(t)*r(t)] = (  (Fx,FL(t)+Fx,FR(t))*cos(delta(t))
%      dt                           - (Fy,FL(t)+Fy,FR(t))*sin(delta(t))
%                                   + Fx,RL(t)+Fx,RR(t)
%                                  
%      d
%   m[ -- Vy(t) + Vx(t)*r(t)] =(  (Fx,FL(t)+Fx,FR(t))*sin(delta(t))
%      dt                          + (Fy,FL(t)+Fy,FR(t))*cos(delta(t))
%                                  + Fy,RL(t)+Fy,RR(t))
%      d
%   Jz -- r(t)   =   Lf*(  (Fx,FL(t)+Fx,FR(t))*sin(delta(t))
%      dt                   + (Fy,FL(t)+Fy,FR(t))*cos(delta(t)))
%                  - Lr*(Fy,RL(t)+Fy,RR(t)))
%                  + Lw/2 ( (Fx,FL(t)-Fx,FR(t))*cos(delta(t)) 
%                           + (Fy,FR(t)-Fy,FL(t))*sin(delta(t)))
%                           + Fx, RL(t) - Fx, RR(t))
%
%   where subscript x is used to denote that a force F acts in the
%   longitudinal direction and y that it acts in the lateral direction. The
%   abbreviations FL, FR, RL and RR label the tires: Front Left, Front Right,
%   Rear Left and Rear Right, respectively. 
%   In addition, delta(t) (an input) is the steering angle, J a moment of
%   inertia, and Lf and Lr the distances from the center of gravity to the 
%   front and rear axles, respectively.

%
%   Note that moment of inertia Jz can be calculated from Lf and Lr.

%%  Tyre Dynamics Model
%   Tyre dynamics model should be treated in two cases, which are driven
%   wheel and driving wheel. If there is no torque applied on a single
%   wheel, longitude force applied on this wheel should be zero due to our
%   omission of friction force, like rolling resistance etc.
%
%   The equation is as follows:
%      d
%   Jw -- w = T - Rw * Fx
%      dt
%
%   where T is the applied torque, Jw is rotation moment of inertia, Rw is
%   rolling radius, w is angular speed and Fx is longitude force generating
%   by road.

%   In addition, linear velocity and slip angle(Belta_ii) of each wheel can be 
%   calculated from vehilce's velocity by using geometric relationship.
%
%   Vx,FR = (Vx - r*Lw/2)cos(delta(t)) + (Vy + r*Lf)sin(delta(t))
%   Vx,FL = (Vx + r*Lw/2)cos(delta(t)) + (Vy + r*Lf)sin(delta(t))
%   Vx,RR =  Vx - r*Lw/2
%   Vx,RL =  Vx + r*Lw/2
%                                 Vy + r*Lf
%   Belta,FR = delta(t) - atan (---------------)
%                                 Vx - r*Lw/2
%
%                                 Vy + r*Lf
%   Belta,FL = delta(t) - atan (---------------)
%                                 Vx + r*Lw/2
%
%                        Vy - r*Lr
%   Belta,RR = - atan (---------------)
%                        Vx - r*Lw/2
%
%                        Vy - r*Lr
%   Belta,RR = - atan (---------------)
%                        Vx + r*Lw/2
%
%%   Initial Conditions

% Vx0                % Initial vehicle longitude speed [m/s]
% Vy0                % Initial vehicle lateral speed [m/s]
% r0                 % Initial yaw rate [rad/s]

VxFR = Vx0 - Lw*r0/2;   % Initial FR tyre longitude speed [m/s]
VxFL = Vx0 + Lw*r0/2;   % Initial FL tyre longitude speed [m/s]
VxRR = Vx0 - Lw*r0/2;   % Initial RR tyre longitude speed [m/s]
VxRL = Vx0 + Lw*r0/2;   % Initial RL tyre longitude speed [m/s]

wFR0 = VxFR/Rw;          
wFL0 = VxFL/Rw;
wRR0 = VxRR/Rw;
wRL0 = VxRL/Rw;


%%  Tire Model (Magic Formula)
%   Magic formula is an semiempirical and nonlinear tire model. It is a
%   sine function embedded with tangent functions.
%
%   Following formula is based on the materials given  by Kening Li. We
%   neglect camber angle and shift. Therefore, this is a simple tyre model. 
%
%   General formula is
%   F = D sin{ Carctan [ Bx-E(Bx-arctanBx) ] }
%
%   Here F can be longtitude or lateral force and x can be slip ratio s or
%   alpha* correspondingly.
%   Note alpha* is defined as the tangent of slip angle.
%
%   C reflects the shape of curve, D reflects peak value, E reflects the
%   the shape near peak value and B is stiffness factors. K=BCD, which
%   reflects the slope near zero.
%
%   Parameters of magic formula are: cornering stiffness, peak friction
%   coefficient,friction coefficient when slips (s=inf) and vetical load.
%   Therefore we normalize F to get F_norm. F_norm=F/Fz, where Fz is the
%   vertical load.
%
%   x, y stand for longitude and lateral direction respectively
%   n stands for norm
%   K stands for cornering stiffness
%   Fz stands for vertical load
%   p stands for peak value
%   s stands for friction coefficient when s=inf
%   Mu stands for friction coefficient
%

%------------------  Longitude Slip Characteristics  ----------------------
%   
%   Fx_norm(s) = D sin{ C arctan [ B * s - E * ( B*s - arctan (B*s)) ] }
%
%   Kx_norm = Kx(Fz) / Fz
%   Dx_norm = Mux_peak
%   Cx_norm = 2 - (2/pi) * arcsin( Mux_slide/Mux_peak )
%   Bx_norm = Kx_norm / (Cx_norm * Dx_norm)
%   s_peak = 3 * Dx_norm / Kx_norm = 3 / (Bx_norm * Cx_norm)
%       [corresponding slip ratio when u reaches its peak value]
%
%               Bx_norm * s_peak - tan( pi /( 2 * Cx_norm ) )
%   Ex_norm = -----------------------------------------------
%               Bx_norm * s_peak - arctan ( Bx_norm * s_peak )
%
%   Fx = Fx_norm * Fz
% 
% Kxnorm       % normalized stiffness
% Muxp         % peak friction coefficient
% Muxs         % sliding friction coefficient

% Parameters in magic formula
%(Condition 1)
Dx = Muxp;
Cx = 2 - 2/pi * asin( Muxs/Muxp );
Bx = Kxnorm / ( Cx*Dx );
sp = 3 / ( Bx*Cx )   % slip ratio at which Mu is max.
Ex = ( Bx * sp - tan( pi / ( 2 * Cx )) ) / ( Bx * sp-atan( Bx * sp ) );

%(Condition 2)
Dx_2 = Muxp_2;
Cx_2 = 2 - 2/pi * asin( Muxs_2/Muxp_2 );
Bx_2 = Kxnorm_2 / ( Cx_2*Dx_2 );
sp_2 = 3 / ( Bx_2*Cx_2 );   % slip ratio at which Mu is max.
Ex_2 = ( Bx_2 * sp_2 - tan( pi / ( 2 * Cx_2 )) ) / ( Bx_2 * sp_2-atan( Bx_2 * sp_2 ) );

%Test Formula   KDS 2/7/14
%u = slip ratio
%  u=-1:.001:1;
%  LongSlip = Dx_2*sin(Cx_2*atan(Bx_2*u-Ex_2*(Bx_2*u-atan(Bx_2*u))));
%  figure;
%  hhh(1) = subplot(2,1,1); % upper plot
%  plot(u,LongSlip)
%  hold on;

%u = slip ratio
 u=-1:.001:1;
 LongSlip = Dx*sin(Cx*atan(Bx*u-Ex*(Bx*u-atan(Bx*u))));
 %figure;
 hhh(1) = subplot(2,1,1); % upper plot
 plot(u,LongSlip)
 hold on;

%------------------  Lateral Slip Characteristics  ------------------------
%   
%   Here independent variable a is tangent of alpha (the slip angle)
%   Due to the nonlienar property between lateral direction, vertical  load
%   and stiffness, we needs parameters in static situation, which is
%   represented by 0.
%   
%   Fy_norm(a) = D sin{ C arctan [ B*a-E(B*a-arctan (B*a)) ] }
%
%   Due to nonlinear relation between cornering stiffness and vertical load,
%   K depends on Fz.
%   
%   Ky(Fz) = k1 * sin[ 2*arctan(Fz/k2)]                 [N/rad]
%       k1 = Ky0, which is the static stiffness
%       k2 = Fz0, which is the static verticl load
%
%   Ky_norm = Ky(Fz)/Fz
%
%   Due to nonlinear relation between friction coefficient and vertical
%   load, friction coefficient (Muy) depends on Fz too
%            Fz + p1
%   Muyp = ----------- Muys
%               Fz
%   p1 = ( Muyp0 / Muys -1 ) * Fz0
%
%   Dy_norm = Muy_peak
%   Cy_norm = 2 - (2/pi) * arcsin(Muy_slide/Muy_peak)
%   By_norm = Ky_norm / (Cy_norm * Dy_norm)
%   a_peak = 3 * Dy_norm / Ky_norm = 3 / (By_norm * Cy_norm)
%       [corresponding slip angle when u reaches its peak value]
%
%               By_norm * a_peak - tan( pi/(2*Cy_norm) )
%   Ey_norm = --------------------------------------------
%               By_norm * a_peak - arctan (By_norm*a_peak)
%
%   Fy = Fy_norm * Fz

% Ky0 = 90000;        % static cornering stiffness [N/rad]
% Fz0 = 8142;         % static vertical load     [N]
% Fz = m * g /4;      % vertical load            [N]
% Muyp0 = 0.85;       % static peak friction coefficient
% Muys = 0.80;        % friction coefficient when sliding 

%(Condition 1)
Ky = Ky0 * sin( 2 * atan(Fz / Fz0) );
p = ( ( Muyp0 / Muys ) - 1 ) * Fz0;
Muyp = ( Fz + p) * Muys / Fz;

Kynorm = Ky / Fz;

Dy = Muyp;
Cy = 2 - 2 / pi * asin( Muys / Muyp );
By = Kynorm / ( Cy * Dy );
ap = 3 / ( By * Cy );  
Ey = ( By * ap - tan( pi / ( 2 * Cy )))/( By * ap - atan( By * ap ));

%(Condition 2)
Ky_2 = Ky0 * sin( 2 * atan(Fz / Fz0) );
p_2 = ( ( Muyp0_2 / Muys_2 ) - 1 ) * Fz0;
Muyp_2 = ( Fz + p) * Muys_2 / Fz;

Kynorm_2 = Ky_2 / Fz;

Dy_2 = Muyp_2;
Cy_2 = 2 - 2 / pi * asin( Muys_2 / Muyp_2 );
By_2 = Kynorm_2 / ( Cy_2 * Dy_2 );
ap_2 = 3 / ( By_2 * Cy_2 );  
Ey_2 = ( By_2 * ap_2 - tan( pi / ( 2 * Cy_2 )))/( By_2 * ap_2 - atan( By_2 * ap_2 ));

%Test Formula   KDS 2/7/14
%uu = steering angle (rads)
uu = -1:.001:1;
lz = tan(u);
angle = -1:.001:1;
degrees = uu*180/pi;
pz = tan(angle);
%LatSlip = (Dy*sin(Cy*atan(By*u-Ey*(By*u-atan(By*u)))));
LatSlip = (Dy*sin(Cy*atan(By*uu-Ey*(By*uu-atan(By*uu)))));

hhh(2) = subplot(2,1,2); % lower plot
plot(degrees,LatSlip)
%valuefin=pz*LatSlip;
%hold off;

%[X Y] = meshgrid(LongSlip, LatSlip);
% Z = zeros(length(LatSlip),length(LongSlip));
% for iii = 1:length(LongSlip)
%     Z(:,iii) = uu';
% end
% %mesh(X,Y,Z)
% %surf(X,Y,Z)
% surf(LongSlip, LatSlip', Z);

%surf(LongSlip,LatSlip,uu)

%------------------  Combined Slip Characteristics  -----------------------
%   When vehicle works under combined slip situation, longitudinal and
%   lateral force will affect each other and form a famous friction circle,
%   which limits values of these two forces.
%
%   Generally, we add a weighting function to each pure slip force as
%   follows:
%

% %longitudinal motion

   %Bxc = rx1 * cos( atan (rx2 * u));
   %Gxc = cos( atan (Bxc * uu ));
      
   %Fx0 = Dx*sin(Cx*atan(Bx*u-Ex*(Bx*u-atan(Bx*u))));
   %Fxc = Gxc * Fx0;        %Fx0 is the pure longitudinal force
   
% %lateral motion 
   
   %Byc = ry1 * cos( atan (ry2 * uu));
   %Gyc = cos( aran (Byc * u));
   
   %Fy0 = (Dy*sin(Cy*atan(By*uu-Ey*(By*uu-atan(By*uu)))));
   %Fyc = Gyc * Fy0;        %Fy0 is the pure lateral force
   
fprintf('\ndone.');