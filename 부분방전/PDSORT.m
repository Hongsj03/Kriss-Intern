clc
clear 
close all
%%
load 'surface'

fs=256000;
temp_bgn_data=y_b_1;
[m n]=size(temp_bgn_data);
segment_index=floor(m/fs);

surface_bgn_data(:,1)=y_b_1(1:segment_index*fs,1);
surface_bgn_data(:,2)=y_b_2(1:segment_index*fs,1);
surface_bgn_data(:,3)=y_b_3(1:segment_index*fs,1);
surface_4kv_data(:,1)=y_s_4kV_30cm_1(1:segment_index*fs,1);
surface_4kv_data(:,2)=y_s_4kV_30cm_2(1:segment_index*fs,1);
surface_4kv_data(:,3)=y_s_4kV_30cm_3(1:segment_index*fs,1);
surface_5kv_data(:,1)=y_s_5kV_30cm_1(1:segment_index*fs,1);
surface_5kv_data(:,2)=y_s_5kV_30cm_2(1:segment_index*fs,1);
surface_5kv_data(:,3)=y_s_5kV_30cm_3(1:segment_index*fs,1);
surface_6kv_data(:,1)=y_s_6kV_30cm_1(1:segment_index*fs,1);
surface_6kv_data(:,2)=y_s_6kV_30cm_2(1:segment_index*fs,1);
surface_6kv_data(:,3)=y_s_6kV_30cm_3(1:segment_index*fs,1);
clearvars -except surface_bgn_data surface_4kv_data surface_5kv_data surface_6kv_data


load 'floating'

fs=256000;
temp_bgn_data=y_b_1;
[m n]=size(temp_bgn_data);
segment_index=floor(m/fs);

floating_bgn_data_set(:,1)=y_b_1(1:segment_index*fs,1);
floating_bgn_data_set(:,2)=y_b_2(1:segment_index*fs,1);
floating_bgn_data_set(:,3)=y_b_3(1:segment_index*fs,1);
floating_11_5_kv_data_set(:,1)=y_s_11_5kV_30cm_1(1:segment_index*fs,1);
floating_11_5_kv_data_set(:,2)=y_s_11_5kV_30cm_2(1:segment_index*fs,1);
floating_11_5_kv_data_set(:,3)=y_s_11_5kV_30cm_3(1:segment_index*fs,1);
floating_12_kv_data_set(:,1)=y_s_12kV_30cm_1(1:segment_index*fs,1);
floating_12_kv_data_set(:,2)=y_s_12kV_30cm_2(1:segment_index*fs,1);
floating_12_kv_data_set(:,3)=y_s_12kV_30cm_3(1:segment_index*fs,1);

clearvars -except floating_bgn_data_set floating_11_5_kv_data_set floating_12_kv_data_set surface_bgn_data surface_4kv_data surface_5kv_data surface_6kv_data

load 'Corona'

fs=256000;
temp_bgn_data=y_b_1;
[m n]=size(temp_bgn_data);
segment_index=floor(m/fs);

Corona_bgn_data_set(:,1)=y_b_1(1:segment_index*fs,1);
Corona_bgn_data_set(:,2)=y_b_2(1:segment_index*fs,1);
Corona_bgn_data_set(:,3)=y_b_3(1:segment_index*fs,1);
Corona_4_kv_data_set(:,1)=y_s_4kV_30cm_1(1:segment_index*fs,1);
Corona_4_kv_data_set(:,2)=y_s_4kV_30cm_1(1:segment_index*fs,1);
Corona_4_kv_data_set(:,3)=y_s_4kV_30cm_1(1:segment_index*fs,1);
Corona_5_kv_data_set(:,1)=y_s_5kV_30cm_1(1:segment_index*fs,1);
Corona_5_kv_data_set(:,2)=y_s_5kV_30cm_2(1:segment_index*fs,1);
Corona_5_kv_data_set(:,3)=y_s_5kV_30cm_3(1:segment_index*fs,1);
Corona_6_kv_data_set(:,1)=y_s_6kV_30cm_1(1:segment_index*fs,1);
Corona_6_kv_data_set(:,2)=y_s_6kV_30cm_2(1:segment_index*fs,1);
Corona_6_kv_data_set(:,3)=y_s_6kV_30cm_3(1:segment_index*fs,1);
Corona_7_kv_data_set(:,1)=y_s_7kV_30cm_1(1:segment_index*fs,1);
Corona_7_kv_data_set(:,2)=y_s_7kV_30cm_2(1:segment_index*fs,1);
Corona_7_kv_data_set(:,3)=y_s_7kV_30cm_3(1:segment_index*fs,1);

%%
clearvars -except Corona_bgn_data_set Corona_4_kv_data_set Corona_5_kv_data_set Corona_6_kv_data_set Corona_7_kv_data_set floating_bgn_data_set floating_11_5_kv_data_set floating_12_kv_data_set surface_bgn_data surface_4kv_data surface_5kv_data surface_6kv_data
%%
vars = who;

for i = 1:length(vars)

    varName = vars{i};
    
    varValue = eval(varName);
    
    reshapedVarValue = reshape(varValue, 256000, 96);
    
    newVarName = ['reshape_', varName];
    
    assignin('base', newVarName, reshapedVarValue);
end

allVars = who;

reshapeVars = allVars(startsWith(allVars, 'reshape_'));

varsToDelete = setdiff(allVars, reshapeVars);

clear(varsToDelete{:});
clear allVars reshapeVars varsToDelete;
%%
vars = who;

for i = 1:length(vars)

    varName = vars{i};
    
    varValue = eval(varName);
    
    fft_result = 2*abs(fft(varValue))/length(256000);
    mean_fft_result=mean(fft_result,2);
    newVarName = ['fft_', varName];
    newVarName2 = ['mean_fft_', varName];
    assignin('base', newVarName, fft_result);
    assignin('base', newVarName2, mean_fft_result);
end

%% Filter

d = designfilt('bandpassfir', ...
    'FilterOrder',40,'CutoffFrequency1',40000, ...
    'CutoffFrequency2',60000,'SampleRate',256000);      % Sample rate
%% PRPD
noise_data=y_b_1;
corona_data=Corona_7_kv_data_set;
surface_data=surface_6kv_data;
floating_data=floating_12_kv_data_set;



fs=256000;
dt=1/fs;
t=0:dt:length(corona_data(1:256000,1))*dt-dt;

Co=filtfilt(d,corona_data(1:256000,1));
Su=filtfilt(d,surface_data(1:256000,1));
Fl=filtfilt(d,floating_data(1:256000,1));
Bgn=filtfilt(d,noise_data(1:256000,1));
y = sin(2*pi*1*t);

% Corona
pd_magnitude = Co; 
P_threshold = rms(Bgn);
pd_indices1 = find(pd_magnitude > P_threshold); 
pd_times1 = t(pd_indices1); % 발생한 시간
pd_values1 = pd_magnitude(pd_indices1); % 방전 크기
phase_angles = mod(360 * pd_times1 * 60, 360); 
figure(1);
scatter(phase_angles, pd_values1, 'filled');

title('PRPD Diagram(Corona)');
xlabel('Phase Angle ');

ylabel('Partial Discharge Magnitude');
grid on;

yyaxis right
plot(t*360,y,'r','linewidth',5)
ylim([-3 3])
ylabel('Amplitude');
box on
hold on
xline(180,'--k')
xlim([0 360])

% Surface
pd_magnitude2 = Su; 
P_threshold = rms(Bgn);
pd_indices2 = find(pd_magnitude2 > P_threshold ); 
pd_times2 = t(pd_indices2); % 발생한 시간
pd_values2 = pd_magnitude2(pd_indices2); % 방전 크기
phase_angles = mod(360 * pd_times2 * 60, 360); 
figure(2);
scatter(phase_angles, pd_values2, 'filled');

title('PRPD Diagram(Surface)');
xlabel('Phase Angle ');
ylabel('Partial Discharge Magnitude');
grid on;

yyaxis right
plot(t*360,y,'r','linewidth',5)
ylim([-3 3])
ylabel('Amplitude');
box on
hold on
xline(180,'--k')
xlim([0 360])

% Floating

pd_magnitude3 = Fl; 
P_threshold = rms(Bgn);
pd_indices3 = find(pd_magnitude3 > P_threshold); 
pd_times3 = t(pd_indices3); % 발생한 시간
pd_values3 = pd_magnitude3(pd_indices3); % 방전 크기
phase_angles = mod(360 * pd_times3 * 60, 360); 
figure(3);
scatter(phase_angles, pd_values3, 'filled');

title('PRPD Diagram(Floating)');
xlabel('Phase Angle ');

ylabel('Partial Discharge Magnitude');
grid on;

yyaxis right
plot(t*360,y,'r','linewidth',5)
ylim([-3 3])
ylabel('Amplitude');
box on
hold on
xline(180,'--k')
xlim([0 360])

%% PRPD 1/60 
corona_data=y_s_4kV_30cm_1;
noise_data=y_b_1;
surface_data=surface_6kv_data;
floating_data=floating_12_kv_data_set;

input=surface_data;
fs=256000;
dt=1/fs;
t=0:dt:length(input(1:256000,1))*dt-dt;


fs = 256000;
dt = 1/fs;
t = 0:dt:(length(input(1:256000, 1))*dt - dt);
Bgn=filtfilt(d,noise_data(1:256000,1));

Co = filtfilt(d, input(1:256000, 1));

inputtt = zeros(4266, 60);
startldx=100;
for i = 1:60
    inputtt(:, i) = Co(startldx+(i-1)*4266 :startldx+i*4266-1, 1); 
end


% 임계값 계산
threshold = rms(Bgn);
y = max(inputtt(:,1))*sin(2*pi*t);

figure;
% hold on;
for i = 1:60
    clear aaaa bbbb
    [aaaa bbbb]=find(abs(inputtt(:, i)) >= threshold);
    
%     if Coronaa(:, i) > threshold
        hold on;
        scatter(t(1,aaaa), inputtt(aaaa, i),'*');
%     end
end
hold on
plot(t*0.016666,y,'r','linewidth',5)
% hold off;
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Scatter Plot of 1-Second Signal Divided into 60 Parts');
xlim( [0 0.0167])
ylabel('Amplitude');
box on

%% PRPD *3

fs=256000;
dt=1/fs;
t=0:dt:length(corona_data(:,1))*dt-dt;

y = sin(2*pi*1*t);

% Corona
pd_magnitude = Corona_7_kv_data_set(:,1); 
pd_indices1 = find(pd_magnitude ); 
pd_times1 = t(pd_indices1); % 발생한 시간
pd_values1 = pd_magnitude(pd_indices1); % 방전 크기
phase_angles = mod(360 * pd_times1 * 60, 1080); 
figure(1);
scatter(phase_angles, pd_values1, 'filled');

title('PRPD Diagram(Corona)');
xlabel('Phase Angle ');

ylabel('Partial Discharge Magnitude');
grid on;

yyaxis right
plot(t*360,y,'r','linewidth',5)
ylim([-3 3])
ylabel('Amplitude');
box on
hold on
xline(360,'--k')
xline(720,'--k')
xlim([0 1080])

% Surface
pd_magnitude2 = surface_6kv_data(:,1); 
pd_indices2 = find(pd_magnitude2 ); 
pd_times2 =t(pd_indices2); % 발생한 시간
pd_values2 = pd_magnitude2(pd_indices2); % 방전 크기
phase_angles = mod(360 * pd_times2 * 60, 1080); 
figure(2);
scatter(phase_angles, pd_values2, 'filled');

title('PRPD Diagram(Surface)');
xlabel('Phase Angle ');
ylabel('Partial Discharge Magnitude');
grid on;

yyaxis right
plot(t*360,y,'r','linewidth',5)
ylim([-3 3])
ylabel('Amplitude');
box on
hold on
xline(360,'--k')
xline(720,'--k')
xlim([0 1080])


% Floating

pd_magnitude3 = floating_12_kv_data_set(:,1); 
pd_indices3 = find(pd_magnitude3 ); 
pd_times3 = t(pd_indices3); % 발생한 시간
pd_values3 = pd_magnitude3(pd_indices3); % 방전 크기
phase_angles = mod(360 * pd_times3 * 60, 1080); 
figure(3);
scatter(phase_angles, pd_values3, 'filled');

title('PRPD Diagram(Floating)');
xlabel('Phase Angle ');

ylabel('Partial Discharge Magnitude');
grid on;

yyaxis right
plot(t*360,y,'r','linewidth',5)
ylim([-3 3])
ylabel('Amplitude');
box on
hold on
xline(360,'--k')
xline(720,'--k')
xlim([0 1080])


