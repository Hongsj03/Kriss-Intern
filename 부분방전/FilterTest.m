clc
clear all
close all
%%
fs=256000;
dt=1/fs;
t=0:dt:((256000*dt))-dt;

A=1; % Amplitude
F=30000; % 주파수
T=0.1; % 신호 점유 시간
alpha = 3000; % 감쇠 계수
t=0:dt:(T/dt)*dt-dt;
damped_sin_x=exp(-alpha.*t).*A.*sin(2*pi*F*t);
a=zeros(round(0.1/dt),1)';
temp_signal=[a a damped_sin_x a a damped_sin_x a a damped_sin_x a];
background_noise=0.3*randn(256000,1)';
signal=temp_signal+background_noise;
t=0:dt:(1/dt)*dt-dt;

figure,
subplot(3,1,1)
plot(t,signal,'k','linewidth',1)
xlim([0 max(t)])
% ylim([min(damped_sin_x)*1.1 max(damped_sin_x)*1.1])
set(gca, 'fontsize',25, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
grid minor
box on
xlabel 'Time [sec]'
ylabel 'Amplitude [V]'
hold on
plot(t,temp_signal,'r','linewidth',1)
ylim([-2 2])
%%
bpfilt = designfilt('bandpassfir', ...
    'FilterOrder',19000,'CutoffFrequency1',20000, ...
    'CutoffFrequency2',40000,'SampleRate',256000);

% filteres_signal=filtfilt(bpfilt,signal);
%%
bpfilt = designfilt('bandpassiir', ...       % Response type
       'StopbandFrequency1',18000, ...    % Frequency constraints
       'PassbandFrequency1',20000, ...
       'PassbandFrequency2',40000, ...
       'StopbandFrequency2',42000, ...
       'StopbandAttenuation1',50, ...   % Magnitude constraints
       'PassbandRipple',.00001, ...
       'StopbandAttenuation2',50, ...
       'DesignMethod','ellip', ...      % Design method
       'MatchExactly','passband', ...   % Design method options
       'SampleRate',256000)               % Sample rate
filteres_signal=filtfilt(bpfilt,signal);

%%
hold on
fvtool(bpfilt)
%%
hold on
subplot(3,1,2)
plot(t,filteres_signal,'k','linewidth',1)
xlim([0 max(t)])
% ylim([min(damped_sin_x)*1.1 max(damped_sin_x)*1.1])
set(gca, 'fontsize',25, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
grid minor
box on
xlabel 'Time [sec]'
ylabel 'Amplitude [V]'
hold on
% plot(t,temp_signal,'r','linewidth',1)
ylim([-2 2])