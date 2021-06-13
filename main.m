%Author: Awabullah Syed 
%----------------------Loop Gain of 41.32 -------------------------------%
sys1 = zpk([],[0,-3,-10],41.32) %Section 1a - K = 41.32
%----------------------Lead-Compensator Deisng---------------------------%
sys2 = zpk([],[0,-3, -10],750*13.92*32.16) %Compensated Open Loop TF
sys3 = zpk([],[0,-3, -10],750) %Uncompensated System K = 750
s = tf('s')
 Gc = (s+4.0368)/(s+48) % First Phase_lead Compensator  
 Gc2 = (s+6.8)/(s+218)  % Second Phase_lead compensator 
 C = Gc * Gc2 % Both Compensator Combined
Open_Loop = zpk ([-4.0368 -6.8],[0 -3 -10 -48 -218],750*13.92*32.16) 
CL = feedback(Open_Loop,1)
G_lead = zpk ([-4.0368 -6.8],[-48 -218],1)
%---------------------------Plot Unit Step Respones----------------------%
t = 0:0.1:25;
u = t;
[y,t,x] = lsim(CL,u,t)
plot(t,y,'k--'); hold on 
plot(t,u,'r');
xlabel('Time /sec')
ylabel('Amplitude')
title('Unit Ramp Response of the Closed Loop System')
legend('Ramp Input','System Output'); hold off 
%------------------------------Transient Performance---------------------%
band_width = bandwidth(CL) %Bandwidth of the closed loop system 
peak_magnitude = getPeakGain(CL) %Peak gain of closed loop compensated sys

%% Deadbeat 
num=[0.04 0.04];
den=[1 0.2 0.04];
sys = tf(num,den)
Gpd = c2d (sys,1,'matched')
%Samplie time:1 seconds - Discrete-time transfer function 
Dznum=[1];
Dzden=[1 -1];
D = tf (Dznum, Dzden, -1)

Dz=D*1/Gpd
sysold=Dz*Gpd
syscld = connect (sysold, [1 -1])

step(syscld)


%%
% ramp = 1/31 %1/kv
% C_unit = ramp * C 
% 
% 
% I = sys2 * C_unit
% step(I); hold on 
% plot([0 10],[0 10],'k--') %slope of 1 since Unit Ramp Response 
% legend (' System Output','Ramp Input')
% title('Unit Ramp Respones'); hold off

 %C = Gc * Gc2 


% sys4 = zpk([],[0 ],1)
% sys5 = series(sys4,sys2)

% C1 = zpk([-4.0368],[-48],1)
% C2 = zpk([-6.8],[-218],1)
% C3 = C1 * C2
% C4_Unit = unit_ramp * C3
% unit_ramp = 1/s^2

% a = 750*13.92*32.16
% num_C = conv([1 6.8], [1 4.0368])
% num = conv(num_C, a)
% 
% den_C = conv([1 218],[1 48])
% b = conv([1 0],[1 3])
% den_TF = conv(b,[1 10])
% G = tf(num,den_TF)
% 
% G_Unit = tf(conv(num,[1 0]),den_TF)
% %kv = 25
% kv = dcgain(G_Unit)
% ess = 1/kv
% %aug_sys2 = tf(conv
%aug_sys2=series(tf(1,[1 0]),unit_func) %Augment sys2 to produce unit ramp

%%
%---------------------------Lead Compensator Root Locus Approach----------% 
Gs = zpk ([],[0 0 -7 -60],1) %Unity feedback plant TF
Gc = zpk( [-1],[-14.02],17707) %Phase-Lead Comp, First Iteration
%-------------------------Lead-Lag Compensator---------------------------%
Glead = zpk ([-1],[-83],1) %Selected Lead Compensator 
Glag = zpk ([-0.276],[-0.04],[1]) %Lag Compensator 
openLoop = zpk ([-1 -0.276],[0 0 -7 -60 -83 -0.04],[202588]) %Lead-Lag
Ts = feedback(openLoop,1) %Closed Loop Transfer Function
%-------------------------------Filter------------------------------------%
F2 = zpk ([],[-2.5],2.5) %Filter to meet design criteria
%---------------------------------Parabolic Plot-------------------------%
t = 0:0.1:20;
u = 0.5*t.*t;
sys_withfilter = Ts * F2
[y,x]=lsim(sys_withfilter,u,t)
plot(t,y,'k--'); hold on 
plot(t,u,'r');
xlabel('Time (sec')
ylabel('Amplitude')
title('Parabolic Response of the Closed Loop Transfer Function')
legend ('Input','Output'); hold off
%----------------------------Performance Metrics for final Design---------%
band_width = bandwidth(sys_withfilter) %Bandwidth of the closed loop system 
peak_magnitude = getPeakGain(sys_withfilter) %Peak gain of closed loop compensated sys
[wn,zeta]=damp(sys_withfilter)
%%
%new = zpk([-1.02],[-3.57],384020) %Using Matlab Root Locus Editor - Unstable

% GC_5 = zpk([-1],[0 0 -7 -60 -1119],2504255)



%Gc =  [[(s+4.0368)]/[(s+48)]] % First Phase_lead Compensator with 
%Gc2 = [[(s+13)]/[(s+57.34)]]