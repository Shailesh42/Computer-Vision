clc;
clear all;
close all;

subplot(5,2,1);  r = imread("pout.tif");     imshow(r);      title("the original Image");
subplot(5,2,2);    imhist(r);    xlabel("intensity");     ylabel("No of pixels");
title("original histogram");

[nk, rk] = imhist(r);
pdf = nk / numel(r);
cdf = cumsum(pdf); 
sk = cdf * 255 ;
sk = round(sk);
[rows, cols] = size(r);
equi_img = zeros(rows,cols,'uint8');
for i =1:rows
   for j = 1:cols
      equi_img(i,j) = sk(r(i,j)+1);
   end
end
subplot(5,2,3); imshow(equi_img); title("equalized Image");
[nk2, rk2] = imhist(equi_img); 
subplot(5,2,4);    imhist(equi_img);   xlabel("intensity");     ylabel("No of pixels");
title("equalized histogram"); 

% subplot(5,2,5);     n = histeq(r);      imshow(n);     title("equalized Image");
% subplot(5,2,6);    imhist(n);    xlabel("intensity");    ylabel("No of pixels");
% title("equalized histogram");

[nk3, rk3] = imhist(equi_img);
      pdf3 = nk3 / numel(equi_img); 
      cdf3 = cumsum(pdf3);
sk3 = cdf3 * 255 ;
sk3 = round(sk3);
[rows, cols] = size(equi_img);  
equi_img2 = zeros(rows,cols,'uint8');
for i =1:rows
   for j = 1:cols
      equi_img2(i,j) = sk3(equi_img(i,j)+1);
   end
end
subplot(5,2,7);        imshow(equi_img2);        title("equalized Image");
[nk4, rk4] = imhist(equi_img2);
subplot(5,2,8); imhist(equi_img2); xlabel("intensity"); ylabel("No of pixels");
title("equalized histogram of second term ");

subplot(5,2,9); n = histeq(equi_img); imshow(n); title("equalized Image");
subplot(5,2,10);     imhist(n); xlabel("intensity");     ylabel("No of pixels");
title("equalized histogram");
