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
figure; imshow(I_impulse); title('(d-i) Impulse Sampling');

% Downsampling
I_downsample = I_double(:, 1:5:end);%111111111111111111111改
figure; imshow(I_downsample); title('(d-ii) Downsampling');

% Zero-order
img_zero_order = repelem(I_downsample, 1, 5);
figure; imshow(img_zero_order); title('(d-iii) Zero-Order Hold Reconstruction');

% First-order
img_first_order = interp1(1:size(I_downsample, 2), I_downsample', linspace(1, size(I_downsample, 2), size(I_double, 2)), 'linear')';
figure; imshow(img_first_order); title('(d-iv) First-Order Hold Reconstruction');