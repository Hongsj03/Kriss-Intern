clc
clear
close all
%% 데이터 로드
% load 'Corona.mat'
% load 'surface.mat'
load 'floating.mat'

%% filter
% h = designfilt('highpassfir', ...       % Response type
%        'StopbandFrequency',9000, ...     % Frequency constraints
%        'PassbandFrequency',10000, ...
%        'StopbandAttenuation',40, ...    % Magnitude constraints
%        'PassbandRipple',4, ...
%        'DesignMethod','kaiserwin', ...  % Design method
%        'ScalePassband',false, ...       % Design method options
%        'SampleRate',256000);         % Sample rate
%% SPL
 
Fs = 256000;
input=y_s_7kV_30cm_1(1:8320000,1);
ref_pressure = 20e-6;

N = length(input);
f = (0:N-1)*(Fs/N); % 주파수 벡터
fft_signal = fft(input);

% FFT 결과의 절대값 계산 (진폭 스펙트럼)
amplitude_spectrum = abs(fft_signal)/N;

% 주파수별 SPL 계산
spl_spectrum = 20 * log10(amplitude_spectrum / ref_pressure);

% 결과 플로팅
figure;
plot(f, spl_spectrum);
title('주파수별 SPL');
xlabel('주파수 (Hz)');
ylabel('SPL (dB)');
xlim([0 125000])
% overall_spl = calculateSPL(input, ref_pressure);
% fprintf('방전 신호의 전체 SPL: %.2f dB\n', overall_spl);



%% Move mean SPL (32.5s)
% 종류별로 각 데이터 바꿔주고 안 쓰는 input은 주석 처리
MOVING_INDEX=100;
Fs = 256000;
input=y_s_11_5kV_30cm_1(1:8320000,1);
ref_pressure = 20e-6;
z=buffer(input,256000,128000);
z=z-mean(z);
z(:,1)=[];
fft_z=2*abs(fft(z))/256000;
spl=20 * log10(fft_z / ref_pressure);
mean_spl_input_1=mean(spl,2);
move_mean_spl_input_1=movmean(mean_spl_input_1,MOVING_INDEX);

input=y_s_12kV_30cm_1(1:8320000,1);
ref_pressure = 20e-6;
z=buffer(input,256000,128000);
z=z-mean(z);
z(:,1)=[];
fft_z=2*abs(fft(z))/256000;
spl=20 * log10(fft_z / ref_pressure);
mean_spl_input_2=mean(spl,2);
move_mean_spl_input_2=movmean(mean_spl_input_2,MOVING_INDEX);

% input=y_s_6kV_30cm_1(1:8320000,1);
% ref_pressure = 20e-6;
% z=buffer(input,256000,128000);
% z=z-mean(z);
% z(:,1)=[];
% fft_z=2*abs(fft(z))/256000;
% spl=20 * log10(fft_z / ref_pressure);
% mean_spl_input_3=mean(spl,2);
% move_mean_spl_input_3=movmean(mean_spl_input_3,MOVING_INDEX);

% input=y_s_7kV_30cm_1(1:8320000,1);
% ref_pressure = 20e-6;
% z=buffer(input,256000,128000);
% z=z-mean(z);
% z(:,1)=[];
% fft_z=2*abs(fft(z))/256000;
% spl=20 * log10(fft_z / ref_pressure);
% mean_spl_input_4=mean(spl,2);
% move_mean_spl_input_4=movmean(mean_spl_input_4,MOVING_INDEX);

% xlim([0 500])

input_bgn=y_b_1(1:8320000,1);
z_bgn=buffer(input_bgn,256000,128000);
z_bgn=z_bgn-mean(z_bgn);
z_bgn(:,1)=[];
fft_z_bgn=2*abs(fft(z_bgn))/256000;
spl_bgn=20 * log10(fft_z_bgn / ref_pressure);
mean_spl_input_bgn=mean(spl_bgn,2);
move_mean_spl_input_bgn=movmean(mean_spl_input_bgn,MOVING_INDEX);

plot(move_mean_spl_input_1)
hold on
plot(move_mean_spl_input_2)
hold on
% plot(move_mean_spl_input_3)
hold on
% plot(move_mean_spl_input_4)
hold on
plot(move_mean_spl_input_bgn)
lgd = legend({'11.5 kV' '12 kV' 'B.G.N',},...
    'FontSize',12,'TextColor','blue','Location','northeast');
title ('Surface & Bgn (SPL)','FontSize',20,'FontWeight','bold','Color','r')
xlabel('Frequency(Hz)','FontSize',18,'FontWeight','bold','Color','b')
ylabel('SPL(dB)','FontSize',18,'FontWeight','bold','Color','b')
xlim([0 100000])

%%


