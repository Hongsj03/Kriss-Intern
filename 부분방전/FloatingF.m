clc
clear
close all
%%
load 'floating.mat'

d = designfilt('bandpassfir', ...
    'FilterOrder',40,'CutoffFrequency1',40000, ...
    'CutoffFrequency2',60000,'SampleRate',256000);      % Sample rate
%%
fvtool(d)
%% 고전압 (floating)

fs=256000;
dt=1/fs;
t=0:dt:length(y_s_12kV_50cm_1)*dt-dt;

%plot(t,y_s_7kV_50cm_1(:,1));

% Background=filtfilt(d,y_b_1(:,1));
% figure(1)
% plot(t,Background)
% title('Background noise')
% xlabel 't'
% for a=0:32
% xline(a,'--r');
% 
% end
% xlim([0 8])
% ylim([-0.04 0.04])

filteres_signal=filtfilt(d,y_s_12kV_50cm_1(:,1));
figure(2)
plot(t,filteres_signal)
title('12kv 50cm')
xlabel 't'
for a=0:32
xline(a,'--r');

end
xlim([0 8])
ylim([-0.2 0.2])

pd_magnitude = filteres_signal(:,1); % 부분 방전 크기 시계열 데이터


threshold = 0.01254; % 부분 방전 이벤트 임계값
pd_indices = find(pd_magnitude > threshold); % 임계값 이상인 인덱스 찾기
pd_times = t(pd_indices); % 부분 방전이 발생한 시간
pd_values = pd_magnitude(pd_indices); % 부분 방전 크기

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



%% 짧은 거리 (floating)

fs=256000;
dt=1/fs;
t=0:dt:length(y_s_12kV_30cm_1)*dt-dt;



filteres_signal=filtfilt(d,y_s_12kV_30cm_1(:,1));
figure(1)
plot(t,filteres_signal)
title('12kv 30cm')
xlabel 't (s)'
ylabel 'A'
for a=0:32
xline(a,'--r');

end
xlim([0 8])
ylim([-0.2 0.2])

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

%% Raw Data 겹쳐 그리기

input_F=y_s_12kV_30cm_1;
input_B=y_b_1;
fs=240000;
dt=1/fs;

[p q]=rat(240000/256000);
a=resample(input_F,p,q);
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
title ('Floating & Bgn','FontSize',20,'FontWeight','bold','Color','r')
xlabel('Time(s)','FontSize',18,'FontWeight','bold','Color','b')
ylabel('Amplitude(m)','FontSize',18,'FontWeight','bold','Color','b')
lgd = legend({'Floating','Bgn',},...
    'FontSize',12,'TextColor','blue','Location','northwest');
xlim([0 0.083])