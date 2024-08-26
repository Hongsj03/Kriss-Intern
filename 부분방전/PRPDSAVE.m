c_data=Corona_7_kv_data_set(:,1);
n_data=Corona_bgn_data_set(:,1);
s_data=surface_6kv_data(:,1);
f_data=floating_12_kv_data_set(:,1);
% clearvars -except c_data f_data n_data s_data
%%
input=f_data;

sec=2;
fs=240000;
dt=1/fs;

[p q]=rat(240000/256000);
a=resample(input,p,q);
aa_data=a(1:4000*(sec*60+1),1);


for iii=0:50:4000
figure(1)
clf
del=iii;
clear ininpit_data inininpit
ininpit_data=aa_data(1+del:(240000*sec)+del,1);
inininpit=reshape(ininpit_data, [4000 (sec*60)]);
t=0:dt:length(ininpit_data(:,1))*dt-dt;
threshold = rms(n_data);
y = max(inininpit(:,1))*sin(2*pi*60*t);

for i = 1:60
    clear aaaa bbbb
    [aaaa bbbb]=find(abs(inininpit(:, i)) >= threshold);
    
%     if Coronaa(:, i) > threshold
      hold on;
      scatter(t(1,aaaa), inininpit(aaaa, i),'*');
%     end
end
hold on
plot(t,y,'r','linewidth',5)
% hold off;
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Scatter Plot of 1-Second Signal Divided into 60 Parts');
xlim( [0 0.0167])
ylabel('Amplitude');
box on
cd 'C:\Users\KRISS206\Desktop\partial discharge data\New Folder\Floating2'
saveas(gcf,sprintf('FIG_shift_index_%d.png',iii)); 

end
%%