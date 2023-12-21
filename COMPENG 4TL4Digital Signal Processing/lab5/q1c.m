close all
clc
for i = 1:length(N)

        figure;
    for j = 1:length(delta)
        win = chebwin(N(i), delta(j));
        
        h_fir = fir1(N(i)-1, fc, 'low', win);
        
        subplot(length(delta),1,j);
%         stem(0:length(h_fir)-1, h_fir);%xiugaile 
        stem(0:length(h_fir)-1, h_fir);
        title(sprintf('FIR Filter Order = %d, delta=%.2f', N(i), delta(j)));
        
    end
end
N_values = [20, 50, 150]; 
for i = 1:length(N_values)

        figure;
    for j = 1:length(Rs)
        [b, a] = cheby2(N_values(i), Rs(j), fc, 'low');
        
        subplot(length(delta),1,j);
%         stem(0:length(h_fir)-1, h_fir);%xiugaile 
        stem(0:length(b)-1, b);
        title(sprintf('IIR Filter Order = %d, Rs=%.2f', N_values(i),Rs(j)));
        
    end
end
