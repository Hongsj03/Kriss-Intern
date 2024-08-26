clc
clear
close all
%%
load 'Corona.mat'

d = designfilt('bandpassfir', ...
    'FilterOrder',40,'CutoffFrequency1',40000, ...
    'CutoffFrequency2',60000,'SampleRate',256000);      % Sample rate
%%
fvtool(d)
%% 고전압 (Corona)

fs=256000;
dt=1/fs;
t=0:dt:length(y_s_7kV_50cm_1)*dt-dt;

%plot(t,y_s_7kV_50cm_1(:,1));

% Background=filtfilt(d,y_b_1(:,1));
% figure(1)
% plot(t,Background)
% title('Background noise')
% xlabel 't'
% ylabel 'A'

filteres_signal=filtfilt(d,y_s_7kV_50cm_1(:,1));
figure(2)
plot(t,filteres_signal)
title('7kv 50cm')
xlabel 't (s)'
ylabel 'A'
for a=0:32
xline(a,'--r');

end
xlim([0 8])
ylim([-0.05 0.04])



pd_magnitude = filteres_signal(:,1); 

threshold = 0.013; 
pd_indices = find(pd_magnitude > threshold); 
pd_times = t(pd_indices); % 발생한 시간
pd_values = pd_magnitude(pd_indices); % 방전 크기

figure(3);
scatter(pd_times, pd_values, 'filled');
xlim([0 8])
ylim([0 0.2])
title('시간 도메인 부분 방전 산점도');
xlabel('시간 (초)');
ylabel('부분 방전 크기 (pC)');
grid on;

for a=0:32
xline(a,'--r');

end





%% 짧은 거리 (Corona)

fs=256000;
dt=1/fs;
t=0:dt:length(y_s_7kV_30cm_1)*dt-dt;



filteres_signal=filtfilt(d,y_s_7kV_30cm_1(:,1));
figure(1)
plot(t,filteres_signal)
title('7kv 30cm')
xlabel 't (s)'
ylabel 'A'
for a=0:32
xline(a,'--r');

end
xlim([0 8])
ylim([-0.05 0.04])

pd_magnitude = filteres_signal(:,1); 


threshold = 0.013; 
pd_indices = find(pd_magnitude > threshold); 
pd_times = t(pd_indices); % 발생한 시간
pd_values = pd_magnitude(pd_indices); % 방전 크기

figure(3);
scatter(pd_times, pd_values, 'filled');
xlim([0 8])
ylim([0 0.2])
title('시간 도메인 부분 방전 산점도');
xlabel('시간 (초)');
ylabel('부분 방전 크기 (pC)');
grid on;

for a=0:32
xline(a,'--r');

end


%%
signal=y_b_3;
n_index=floor(length(y_b_1)/256000);
buf_signal=reshape(signal(1:256000*n_index,1), [256000, n_index]);
buf_signal=buf_signal-mean(buf_signal);
fft_buf_signal=2*abs(fft(buf_signal));
mean_fft_buf_signal=mean(fft_buf_signal,2);

a1=mean_fft_buf_signal;

signal=y_s_4kV_30cm_1;
n_index=floor(length(y_s_4kV_30cm_1)/256000);
buf_signal=reshape(signal(1:256000*n_index,1), [256000, n_index]);
buf_signal=buf_signal-mean(buf_signal);
fft_buf_signal=2*abs(fft(buf_signal));
mean_fft_buf_signal=mean(fft_buf_signal,2);

a2=mean_fft_buf_signal;

signal=y_s_5kV_30cm_1;
n_index=floor(length(y_s_5kV_30cm_1)/256000);
buf_signal=reshape(signal(1:256000*n_index,1), [256000, n_index]);
buf_signal=buf_signal-mean(buf_signal);
fft_buf_signal=2*abs(fft(buf_signal));
mean_fft_buf_signal=mean(fft_buf_signal,2);

a3=mean_fft_buf_signal;


signal=y_s_6kV_30cm_1;
n_index=floor(length(y_s_6kV_30cm_1)/256000);
buf_signal=reshape(signal(1:256000*n_index,1), [256000, n_index]);
buf_signal=buf_signal-mean(buf_signal);
fft_buf_signal=2*abs(fft(buf_signal));
mean_fft_buf_signal=mean(fft_buf_signal,2);

a4=mean_fft_buf_signal;
% 
% 
% signal=y_s_7kV_30cm_1;
% n_index=floor(length(y_s_4kV_30cm_1)/256000);
% buf_signal=reshape(signal(1:256000*n_index,1), [256000, n_index]);
% buf_signal=buf_signal-mean(buf_signal);
% fft_buf_signal=2*abs(fft(buf_signal));
% mean_fft_buf_signal=mean(fft_buf_signal,2);
% 
% a5=mean_fft_buf_signal;
%%


figure
plot( (a1))
hold on
plot( (a2))
hold on
plot( (a3))
hold on
plot( (a4))
hold on
% plot( (a5))
legend 'bgn' '4kV' '5kV' '6kV' '7kV'
% xlim([0 500])
% ylim([0 100])

%%

plot(fft_buf_signal(:,1))
hold on
plot(mean_fft_buf_signal)
hold on

%% 겹쳐서 확인

data=y_s_7kV_50cm_1;
fs=256000;
dt=1/fs;
t=0:dt:length(y_b_1)*dt-dt;

Background=filtfilt(d,y_b_1(:,1));
figure(1)
hold on
filteres_signal=filtfilt(d,data(:,1));
plot(t,filteres_signal)
title '7kV50cm'
ylabel 'A'
for a=0:32
xline(a,'--r');

end

plot(t,Background)

hold off
xlim([0 3])

%% Raw Data 겹쳐 그리기

input_C=y_s_7kV_30cm_1;
input_B=y_b_1;
fs=240000;
dt=1/fs;

[p q]=rat(240000/256000);
a=resample(input_C,p,q);
aa_data=a(1:4000*5,1);

data_f1=filtfilt(d,aa_data);
t=0:dt:length(aa_data(:,1))*dt-dt;

[p q]=rat(240000/256000);
b=resample(input_B,p,q);
bb_data=b(1:4000*5,1);

data_f2=filtfilt(d,bb_data);

figure;
hold on
plot(t,data_f1) % corona
plot(t,data_f2) % bgn
hold off
title ('Corona & Bgn','FontSize',20,'FontWeight','bold','Color','r')
xlabel('Time(s)','FontSize',18,'FontWeight','bold','Color','b')
ylabel('Amplitude(m)','FontSize',18,'FontWeight','bold','Color','b')
lgd = legend({'Corona','Bgn',},...
    'FontSize',12,'TextColor','blue','Location','northwest');
xlim([0 0.083])


