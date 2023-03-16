% Q2 - Code

i_step = 1.0;					% magnitude of current injection
i_start = 10;					% start time injection
i_stop = 60;					% stop time injection
capacitance = 1;			    % capacitance value
resistance = [ 2;       5;       10;      20;      50;]; % resistance values
plot_sym = ['- '  ;  '--'  ;  '-.'  ; '- ' ; ': ' ]; % plot symbols
stop_time = 100;					% simulation stop time
time_step = 1;						% time step for integration
t = 0:time_step:stop_time;					% time vector
for r = 1:length(resistance)			% loops over different resistance values
 v(1) = 0;
 R = resistance(r);
 for i=2:length(t)				% integration loop
   I = i_step*(t(i)>i_start & t(i)<=i_stop);	% injection current value
   delta_v = (-v(i-1)/R + I)/capacitance;			% calculates the value of change of voltage wrt time (dV/dt)
   v(i) = v(i-1) + delta_v*time_step;			% Euler integration
 end						% integration loop ends
 plot(t,v,plot_sym(r,:));				% plotting the graph
 hold on					
 x_axis = 0.5*stop_time;			
 y_axis = v(fix(length(v)/2))-1;
 label = ['R=' num2str(resistance(r))];  
 text(x_axis, y_axis, label);  
end					% end loop over resistance values
title ('RC-Circuit')	% graph title
xlabel('Time');					% x-axis label
ylabel('Voltage');				% y-axis label


% Q3 - code
min_voltage =  -50;
max_voltage = +150;
delta_v = 5;
v = min_voltage:delta_v:max_voltage;
% m
l=alpha_m(v);
j=beta_m(v);
tau = 1 ./ (l+j);
ss = l .* tau;
subplot(231); plot(v,tau); grid on;
axis('square'); axis([min_voltage max_voltage 0 1])
xlabel('v (mV)'); ylabel('tau (msec)'); title('\tau_m','fontsize',14);
subplot(234); plot(v,ss); grid on;
axis('square'); axis([min_voltage max_voltage 0 1])
xlabel('v (mV)'); title('m_\infty','fontsize',14);
% h
l=alpha_h(v);
j=beta_h(v);
tau = 1 ./ (l+j);
ss = l .* tau;
subplot(232); plot(v,tau); grid on;
axis('square'); axis([min_voltage max_voltage 0 10])
xlabel('v (mV)'); ylabel('tau (msec)'); title('\tau_h','fontsize',14);
subplot(235); plot(v,ss); grid on;
axis('square'); axis([min_voltage max_voltage 0 1])
xlabel('v (mV)'); title('h_\infty','fontsize',14);
% n
l=alpha_n(v);
j=beta_n(v);
tau = 1 ./ (l+j);
ss = l .* tau;
subplot(233); plot(v,tau); grid on;
axis('square'); axis([min_voltage max_voltage 0 10])
xlabel('v (mV)'); ylabel('tau (msec)'); title('\tau_n','fontsize',14);
subplot(236); plot(v,ss); grid on;
axis('square'); axis([min_voltage max_voltage 0 1])
xlabel('v (mV)'); title('n_\infty','fontsize',14);
orient landscape
% alpha_h
function rate = alpha_h(v)
   rate = 0.07*exp(-v/20.0);
end
% alpha_m
function rate = alpha_m(v)
ep_value = 1e-12;
 rate = zeros(size(v));	
 z = find(abs(v-25) > ep_value);		% non-singular case
 if(~isempty(z))
   rate(z) = 0.1*(-v(z)+25.0) ./ (exp((-v(z)+25.0)/10.0)-1.0);
 end
 z = find(abs(v-25) <= ep_value);		% singularity at v=25
 if(~isempty(z))
   rate(z) = 1.0;
 end
end
% alpha_n
function rate = alpha_n(v)
ep_value = 1e-12;
 rate = zeros(size(v));
 z = find(abs(v-1) > ep_value);
 if(~isempty(z))
   rate(z) = 0.01*(-v(z)+10.0) ./ (exp((-v(z)+10.0)/10.0) - 1.0);
 end
 z = find(abs(v-10) <= ep_value);		% singularity at v=10
 if(~isempty(z))
   rate(z) = 0.1;
 end
end
% beta_h
function rate = beta_h(v)
 rate =  1.0 ./ (exp((-v+30.0)/10.0) + 1.0);
end
% beta_m
function rate =  beta_m(v)
 rate = 4.0*exp(-v/18.0);
end
% beta_n
function rate = beta_n(v)
 rate = 0.125*exp(-v/80.0);
end

