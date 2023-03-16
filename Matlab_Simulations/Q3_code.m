
% Q1.1 
Clear 
Close all;
clc
delta_t = [50 50 10 10];
tau = [10, 50, 10, 50];
t = 0 : dt : t_max;
z = 0;
g = 0;
t_max = 500 ;
dt = 1 ;
g_peak = 0.1 ;

for k = 1 : length(tau)
   G_norm = g_peak/(tau(k)/exp(1)) ;
   for j = 2:length(t)-1
       if(mod(t(j),delta_t(k))==0)
           u(j+1) = 1/delta_t(k);
       else
           u(j+1) = 0;
       end
   end
   if(k==1 || k==3)
       figure
       subplot(3,1,1)
       plot(t,u)
       xlabel("Time (msec)")
       ylabel("Spikes")
       title(['\Delta t value = ',num2str(delta_t(k))])
       for j = 1:length(t)-1
           z(j+1) = z(j) + dt*(G_norm*u(j) - z(j)/tau(k));
           g(j+1) = g(j) + dt*(z(j) - g(j)/tau(k));
       end
       subplot(3,1,2)
       plot(t,10*g,'m')
       ylabel("Conductance (G)")
       xlabel("Time (msec)")
       title(['\tau value =  ',num2str(tau(k))])
   else
       for j = 1:length(t)-1
           z(j+1) = z(j) + dt*(G_norm*u(j) - z(j)/tau(k));
           g(j+1) = g(j) + dt*(z(j) - g(j)/tau(k));
       end
       subplot(3,1,3)
       plot(t,10*g,'m')
       ylabel("Conductance (G)")
       xlabel("Time (msec)")
       title(['\tau value =  ',num2str(tau(k))])
   end
end


% Q1. 2

clear
close all;
clc
C = 1;
R = 10;
V_rest = 0;
V_spk = 70;
V_thr = 5;
E_ex = 70;
tau_syn = 10;
g_peak = 0.01;
t_max = 500;
dt = 1;
T_ISI = 30 ;
t = 0 : dt : t_max;
G_norm = g_peak/(tau_syn/exp(1));
I_inject = 0;
I_sync = 0;
z = 0;
g_ex = 0;
v = 0;
for j = 2:length(t)-1
   if(mod(t(j),T_ISI)==0)
       u(j+1) = 1;
   else
       u(j+1) = 0;
   end
end
for j = 1:length(t)-1
   z(j+1) = z(j) + dt*(G_norm*u(j) - z(j)/tau_syn);
   g_ex(j+1) = g_ex(j) + dt*(z(j) - g_ex(j)/tau_syn);   
   I_sync(j+1) = g_ex(j)*(v(j)-E_ex);
   if (v(j)==70)
       v(j+1)=V_rest;
   elseif (v(j)>=5)
       v(j+1)=70;
   else
       v(j+1) = v(j) + dt*(-g_ex(j)*(v(j)-E_ex)/C - v(j)/(R*C) + I_inject/C);
   end
end
subplot(4,1,1)
plot(t,u)
xlabel("Time (msec)")
xlim([0 t_max])
ylabel("Spikes")
subplot(4,1,2)
plot(t,g_ex,'r')
ylabel("Synaptic Conductance (g_ex)")
xlabel("Time (msec)")
xlim([0 t_max])
subplot(4,1,3)
plot(t,v,'b')
ylabel("Voltage (mV)")
xlabel("Time (msec)")
xlim([0 t_max])
ylim([V_rest-1 V_spk+1])
subplot(4,1,4)
plot(t,I_sync,'b')
ylabel("Current (mA)")
xlabel("Time (m Sec)")
xlim([0 t_max])
figure
plot(t,v,'r')
ylabel("Postsynaptic membrane voltage (mV)")
xlabel("Time (msec)")
ylim([V_rest-1 V_spk+1])
figure
plot(t,I_sync,'r')
ylabel("Current (mA)")
xlabel("Time (msec)")
xlim([0 t_max])



% Q2.1

clear
close all;
clc
C = 1;
R = 10;
V_rest = 0;
V_spk = 70;
V_thr = 5;
tau_thresh = 50;
E_inh = -15;
tau_syn = 10;
g_peak = 0.1;
t_max = 1500;
dt = 1;
T_ISI = 30 ;
t = 0 : dt : t_max ;
G_norm = g_peak/(tau_syn/exp(1)) ;
I_inject_1 = 1.1 ;
I_inject_2 = 0.9 ;
z = 0;
g_ex = 0;
v1 = 0 ;
v2 = 0 ;
I_sync_1 = 0;
I_sync_2 = 0;
theta_1 = 0;
theta_2 = 0;
for j = 2:length(t)-1
   if(mod(t(j),T_ISI)==0)
       u(j+1) = 1;
   else
       u(j+1) = 0;
   end
end
for j = 1:length(t)-1
   z(j+1) = z(j) + dt*(G_norm*u(j) - z(j)/tau_syn);
   g_ex(j+1) = g_ex(j) + dt*(z(j) - g_ex(j)/tau_syn);   
   I_sync_1(j+1) = g_ex(j)*(v1(j)-E_inh);   
   if (v1(j)==70)
       v1(j+1)=V_rest;
   elseif (v1(j)>=theta_1(j))
       v1(j+1)=70;
   else
       v1(j+1) = v1(j) + dt*(-g_ex(j)*(v1(j)-E_inh)/C - v1(j)/(R*C) + I_inject_1/C);
   end
   theta_1(j+1) = theta_1(j) + dt*(v1(j)/tau_thresh - theta_1(j)/tau_thresh);
   I_sync_2(j+1) = g_ex(j)*(v2(j)-E_inh);   
   if (v2(j)==70)
       v2(j+1)=V_rest;
   elseif (v2(j)>=theta_2(j))
       v2(j+1)=70;
   else
       v2(j+1) = v2(j) + dt*(-g_ex(j)*(v2(j)-E_inh)/C - v2(j)/(R*C) + I_inject_2/C);
   end
   theta_2(j+1) = theta_2(j) + dt*(v2(j)/tau_thresh - theta_2(j)/tau_thresh);
end
subplot(4,1,1)
plot(t,u)
ylabel("Spikes")
xlabel("Time (msec)")
xlim([0 t_max])
subplot(4,1,2)
plot(t,g_ex,'r')
ylabel("Conductance (G)")
xlabel("Time (msec)")
xlim([0 t_max])
subplot(4,1,3)
plot(t,v1,'m')
ylabel("Voltage(mV)")
xlabel("Time (msec)")
xlim([0 t_max])
ylim([V_rest-1 V_spk+1])
subplot(4,1,4)
plot(t,I_sync_1,'m')
ylabel("Current(mA)")
xlabel("Time (msec)")
xlim([0 t_max])
figure
plot(t,v1,'b')
hold on
plot(t,v2,'m')
ylabel("Voltage(mV)")
xlabel("Time (msec)")
ylim([V_rest-1 V_spk+1])
