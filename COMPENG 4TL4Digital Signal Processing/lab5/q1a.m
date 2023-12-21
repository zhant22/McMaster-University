clc
close all
% clear

fc = 1/3; 
N = [20, 50, 150]; 
% freq_range = linspace(0, 1, 1000);
% delta = [0.01, 0.02, 0.05, 0.1];
delta = [10,20,40];%relative sidelobe attenuation
% delta=[50];
for i = 1:length(N)
%     figure;
    for j = 1:length(delta)
    figure;
    subplot(length(delta),1,j);
    win = chebwin(N(i), delta(j));
    h = fir1(N(i)-1, fc, 'low', win);
%     hfvt = fvtool(dchebwin);
% hfvt = fvtool(chebwin);
% legend(hfvt); 
% plot(h);
    freqz(h, 1, 1024, 1);
    title(sprintf('N=%d, delta=%.2f', N(i), delta(j)));


    end
end
