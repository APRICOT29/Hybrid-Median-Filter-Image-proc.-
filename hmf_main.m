%Hybrid median filter
Irgb = imread("sample-img.png");
I = rgb2gray(Irgb);
IB = imnoise (I, 'salt & pepper');
img_hmed=hmf(I,3);
figure(1);
imshow(I)
title('Noisy Image')
figure(2);
imshow(img_hmed)
title('Noisy Image filtered by a 3-by-3 hybrid median filter')
% Error Identification and comparative analysis
N = ones (3)/9; % convolution kernel
If1 = imfilter (IB, N); 
img_med = medfilt2 (IB, [3 3]);
fprintf('*********ERROR COMPARISON********\n\n')
err_IB= immse(I,IB);
fprintf('\nthe mean-squared error of the noisy image is %0.4f\n',err_IB);
err2_IB= psnr(I,IB);
fprintf('\nthe psnr ratio of the noisy image is %0.4f\n',err2_IB);
err_If1= immse(I,If1);
fprintf('\nthe mean-squared error of the image filtered by averaging filter is %0.4f\n',err_If1);
err2_If1= psnr(I,If1);
fprintf('\nthe psnr ratio of the image filtered by averaging filter is %0.4f\n',err2_If1);
err_img_med= immse(I,img_med);
fprintf('\nthe mean-squared error of the image filtered by median filter is %0.4f\n',err_img_med);
err2_img_med= psnr(I,img_med);
fprintf('\nthe psnr ratio of the image filtered by median filter is %0.4f\n',err2_img_med);
err_img_hmed= immse(I,img_hmed);
fprintf('\nthe mean-squared error of the image filtered by hybrid median filter is %0.4f\n',err_img_hmed);
err2_img_hmed= psnr(I,img_hmed);
fprintf('\nthe psnr ratio of the image filtered by hybrid median filter is %0.4f\n',err2_img_hmed);
