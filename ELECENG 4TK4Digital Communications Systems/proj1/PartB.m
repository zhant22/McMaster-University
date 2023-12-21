clc;
clear;
%inputing the chanel values and random signals set.
h=[0.28 1 0.28];
x= rand(1,2000);

% implementing random generator output as requested.
for a = 1:1:2000
    if (x(a)>0.5)
        RG(a) = 1;
    elseif(x(a)<=0.5)
        RG(a) = -1;
    end
end

ho = conv(RG,h); %output signal
received = ho + normrnd(0,sqrt(0.001),[1,length(ho)]); %received signal factored in noise


for emsemble = 1:1:50
    wnew = rand(11,1);
    errsqur = transpose([0 0 0 0 0 0 0 0 0 0 0]);
    temp = [zeros(1,2000)];
    for loop = 1:1:1900
            err(loop) = received(loop+1:1:loop+11)*wnew - RG(loop);
            stor(loop) = err(loop)^2;
            errsqur = errsqur + err(loop)*transpose(received(loop+1:1:loop+11));
            wnew = wnew - 0.5*0.0075*2*(errsqur/loop);
    end
    temp(1:length(stor)) = temp(1:length(stor)) + stor;
end
MSE = temp/50;
wnew
size = 1:1:2000;
plot(size,MSE);

eyediagram(received,length(ho));
eyediagram(temp,length(ho));