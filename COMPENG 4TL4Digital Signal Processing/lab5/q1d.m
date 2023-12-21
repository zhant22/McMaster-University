close all
clc
% clear
fc = 1/3;
N = [20, 50, 150]; 
N_values = [20, 50, 150];
Rs = [10, 20];
delta = [0.01, 0.02];
for i = 1:length(N)
    for j = 1:length(delta)
    figure;
%     subplot(length(delta),1,j);
    win = chebwin(N(i), delta(j));
   h = fir1(N(i)-1, fc, 'low', win);

        stem(h);
%     hfvt = fvtool(dchebwin);
% hfvt = fvtool(chebwin);
% legend(hfvt);
%     plot(h);
%     freqz(h, 1, 1024, 1);
    title(sprintf('N=%d, delta=%.2f', N(i), delta(j)));


    end
end
for i = 1:length(N_values)
     figure;
    for j = 1:length(Rs)
        [b, a] = cheby2(N_values(i), Rs(j), fc, 'low');
        
%         figure;
        subplot(length(Rs),1,j);
        stem(0:length(b)-1, b);
        title(sprintf('IIR Filter Order = %d, Rs =%d', N_values(i), Rs(j)));
        
    end
end
