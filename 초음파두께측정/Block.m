clc
clear
clear all
%%

load 'all.dat'
% load 'Crack1.dat'
% load 'Crack2.dat'
% load 'Crack3.dat'
% load 'Crack4.dat'
% load 'Crack5.dat'
% load 'Crack6.dat'

%% 결함 부위 없음

clc
close all

all2=all(:,2)-mean(all(:,2));
fs=1/(all(2,1)-all(1,1));
N=length(all2);
k=0:N-1;
T=N/fs;
freq=k/T;
dt=1/fs;
t=0:dt:length(all(:,2))*dt-dt;
% subplot(2,1,1)
plot(all2)
title('No Cracks')
xlabel 'Frequency [MHz]'
ylabel 'Amplitude'
grid on

% 첫번째 결함 발견된 부위


Crack2z=Crack2(:,2)-mean(Crack2(:,2));
fs=1/(Crack2(2,1)-Crack2(1,1));
N=length(Crack2z);
k=0:N-1;
T=N/fs;
freq=k/T;
dt=1/fs;
t=0:dt:length(Crack2(:,2))*dt-dt;
hold on
plot(wshift('1d',Crack2z,-144400))
title('First Crack')
xlabel 'Frequency [MHz]'
ylabel 'Amplitude'
grid on


h=all(:,2)-Crack2(:,2);
figure(3);
plot(freq/1000000,h);

%%
xx=all2(454300:476400,1);
y=wshift('1d',Crack2z,-144400);
yy=y(454300:476400,1);
xxx=mscohere(xx,yy,hamming(2560),2000,22101);
%%
N=length(xx);
k=0:N/2;
T=N/fs;
freq=k/T;
figure,plot(freq/1000000,xxx)
xlim([0 30])
%%


% a=2*abs(fft(all2))/length(all2);
% fs=1/(all(2,1)-all(1,1));
% n_fft=length(all2);
% k=0:n_fft-1;
% T=n_fft/fs;
% freq=k/T;
% dt=1/fs;
% t=0:dt:length(all(:,2))*dt-dt;
% subplot(3,1,2)
% plot(freq/1000000,(a))
% title('FFT')
% xlabel 'Frequency [MHz]'
% xlim([0 5])


