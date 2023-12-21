%clc,clear,close all
wc = 0.3;
M = 3;
[b ,a] = butter(M, wc, 'low');
wp = pi*(0:0.001:wc);
glp = grpdelay(b,a,wp);
M2 = 10;
F = wp/pi;
edges = [0 wc];
Gd = max(glp) - glp;
[b2, a2] = iirgrpdelay(M2,F,edges, Gd);
dlmwrite('b2',b2);
dlmwrite('a2',a2);
bf = conv(b,b2);
af = conv(a,a2);
[h,w] = freqz(bf,af);
subplot(2,1,1)
plot(w/pi,abs(h));
grid on;
ylabel("Magnitude");
subplot(2,1,2)
[gd,w] = grpdelay(bf,af);
plot(w/pi,gd)
grid on;
xlabel('Norm freq');
ylabel('Group delay');