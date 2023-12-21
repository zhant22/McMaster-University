clc
close all
% clear
% Constants
fc = 1/3;
% fc = [2.5e6 29e6]/500e6;
N_values = [20, 50, 150]; 
% N_values = 6;
% ftype = 'bandpass';

Rs = [10, 20,40];
% Rs=[80];
for i = 1:length(N_values)
    for j = 1: length(Rs)
%     figure;
    [b, a] = cheby2(N_values(i), Rs(j), fc, 'low');
[z,p,k] = cheby2(N_values(i), Rs(j), fc, 'low');
sos = zp2sos(z,p,k);
% h=impz(sos);
% plot(h);

%     hfvt = fvtool(b,a,sos,'FrequencyScale');
% plot(sos);
hfvt = fvtool(sos);
legend(hfvt,'TF Design','ZPK Design')
legend(hfvt,'ZPK Design')
    fprintf('IIR Filter Order = %d\n', N_values(i));
    freqz(b, a, 1024, 1);
% freqz(b, a, 101111, 1);

title(sprintf('N=%d, delta=%d', N_values(i), Rs(j)));
    end
end
