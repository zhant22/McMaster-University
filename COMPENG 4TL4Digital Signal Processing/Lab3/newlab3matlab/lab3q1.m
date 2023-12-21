clc
clear 
close all
%a
I=imread("KillarneyPic.png");
% imshow(I);
whos I;

%b
I_double=double(I)/255;
% figure
% imshow(I)
figure;
imshow(I_double);

%c
figure;
imshow(I_double);colormap(gray);
figure;
imshow(I_double);colormap(1-gray);

%d
% Impulse sampling
I_impulse = I_double;
I_impulse(:, 2:5:end) = 0;
I_impulse(:, 3:5:end) = 0;
I_impulse(:, 4:5:end) = 0;
I_impulse(:, 5:5:end) = 0;
I_impulse(2:5:end, :) = 0;
I_impulse(3:5:end, :) = 0;
I_impulse(4:5:end, :) = 0;
I_impulse(5:5:end, :) = 0;
figure; imshow(I_impulse); title('Impulse sampling');

% Downsampling
I_downsample = I_double(1:5:end, 1:5:end);
figure; imshow(I_downsample); title('Downsampling');

% Zero-order
outputMatrix = zeros(776, 1395);
for i = 1:156
    for j = 1:279
        value = I_downsample(i,j);
        rowStart = (i - 1) * 5 + 1;
        rowEnd = i * 5;
        colStart = (j - 1) * 5 + 1;
        colEnd = j * 5;
        outputMatrix(rowStart:rowEnd, colStart:colEnd) = value;
    end
end
figure; imshow(outputMatrix);
% % Zero-order
% I_zero_order = repelem(I_downsample, 5, 5);
% figure; imshow(I_zero_order); title('Zero-Order');

% First-order


% targetSize = [776, 1395];
% originalImage = I_downsample;
% % 获取原始图像的尺寸
% [originalHeight, originalWidth, numChannels] = size(originalImage);
% 
% % 计算水平和垂直的缩放因子
% scaleX = targetSize(2) / originalWidth;
% scaleY = targetSize(1) / originalHeight;
% 
% % 创建目标大小的图像
% resizedImage = uint8(zeros(targetSize(1), targetSize(2), numChannels));
% 
% % 执行First-order hold插值
% for y = 1:targetSize(1)
%     for x = 1:targetSize(2)
%         % 计算在原始图像中对应的位置
%         originalX = (x - 0.5) / scaleX + 0.5;
%         originalY = (y - 0.5) / scaleY + 0.5;
% 
%         % 使用最近的像素值进行插值
%         originalX = min(max(originalX, 1), originalWidth);
%         originalY = min(max(originalY, 1), originalHeight);
% 
%         % 获取原始图像中的像素值
%         for channel = 1:numChannels
%             resizedImage(y, x, channel) = originalImage(round(originalY), round(originalX), channel);
%         end
%     end
% end
% 
% % 显示重建后的图像
% imshow(resizedImage);

A_first = I_downsample;
B_first = zeros(776, 1395);
B_first_old = zeros(776, 1395);
block_height = 5;
block_width = 5;

for i = 1:155
    for j = 1:278
        r = 5 * (i - 1) + 1;
        c = 5 * (j - 1) + 1;
        
        B_first_old(r, c) = A_first(i, j);
        B_first_old(r, c+4) = A_first(i, j+1);
        B_first_old(r+4, c) = A_first(i+1, j);
        B_first_old(r+4, c+4) = A_first(i+1, j+1);
% 
%         deltar=(B_first_old(r, c+4)-B_first_old(r, c))/5;
%         deltac=(B_first_old(r+4, c)-B_first_old(r, c))/5;
        
        
        for k = 1:block_width
            for l = 1:block_height
            B_first(r+k-1, c + l-1) =A_first(i, j) + (k-1) * (A_first(i+1, j) - A_first(i, j)) / block_width+(l-1)*(A_first(i, j+1) - A_first(i, j)) / block_height;
            end
        end
    end
end
imshow(B_first);
% % First-order
% I_first_order = interp1(1:size(I_downsample, 2), I_downsample', linspace(1, size(I_downsample, 2), size(I_double, 2)), 'linear')';
% figure; imshow(I_first_order); title('First-Order');