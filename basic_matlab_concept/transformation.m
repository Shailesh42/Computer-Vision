clc; 
close all;
clear all; 

subplot(4,4,1);
r =  imread("coins.png");
s = r ;
imshow(s);
title("identity trans.of gray image");

subplot(4,4,2);
n = (255- r);
imshow(n);
title("negative trans.of gray image");


subplot(4,4,3);
s = im2bw(r) ;
imshow(s);
title("identity trans. of binary image" );

subplot(4,4,4);
n = (1- im2bw(r));
imshow(n);
title("negative trans. of binary image");




d =(double(r)/255) ;

subplot(4,4,5);
u = 0.5 * log(d+1);
imshow(u);
title("log trans. (c = 0.6)");

subplot(4,4,6);
u = 1 * log(d+1);
imshow(u);
title("log trans. (c = 1)");

subplot(4,4,7);
u = 2 * log(d+1);
imshow(u);
title("log trans. (c = 1.8)");


subplot(4,4,9);
v = 0.5 * (exp(d)-1);
imshow(v);
title("antilog trans. c = 0.6 ");

subplot(4,4,10);
v = 1 * (exp(d)-1);
imshow(v);
title("antilog trans. c = 1 ");

subplot(4,4,11);
v = 2 * (exp(d)-1);
imshow(v);
title("antilog trans. c = 1.8 ");


subplot(4, 4,13 );
x = 1*(d.^1);
imshow(x);
title("power law t.(gamma = 1,c= 1)");

subplot(4,4,14 );
x = 1 * (d.^0.5);
imshow(x);
title("power law t.(gamma = 0.2,c= 1)");

subplot(4,4,15 );
x = 1*(d.^1.5);
imshow(x);
title("power law t.(gamma = 2.1,c= 1)");


subplot(4,4,1);
x =  imread("peppers.png");
r = rgb2gray(x);
s = r ;
imshow(s);
title("identity trans.of gray image");

subplot(4,4,2);
n = (255- r);
imshow(n);
title("negative trans.of gray image");


subplot(4,4,3);
s = im2bw(r) ;
imshow(s);
title("identity trans. of binary image" );

subplot(4,4,4);
n = (1- im2bw(r));
imshow(n);
title("negative trans. of binary image");




d =(double(r)/255) ;

subplot(4,4,5);
u = 0.5 * log(d+1);
imshow(u);
title("log trans. (c = 0.6)");

subplot(4,4,6);
u = 1 * log(d+1);
imshow(u);
title("log trans. (c = 1)");

subplot(4,4,7);
u = 2 * log(d+1);
imshow(u);
title("log trans. (c = 1.8)");


subplot(4,4,9);
v = 0.5 * (exp(d)-1);
imshow(v);
title("antilog trans. c = 0.6 ");

subplot(4,4,10);
v = 1 * (exp(d)-1);
imshow(v);
title("antilog trans. c = 1 ");

subplot(4,4,11);
v = 2 * (exp(d)-1);
imshow(v);
title("antilog trans. c = 1.8 ");


subplot(4, 4,13 );
x = 1*(d.^1);
imshow(x);
title("power law t.(gamma = 1,c= 1)");

subplot(4,4,14 );
x = 1 * (d.^0.5);
imshow(x);
title("power law t.(gamma = 0.2,c= 1)");

subplot(4,4,15 );
x = 1*(d.^1.5);
imshow(x);
title("power law t.(gamma = 2.1,c= 1)");


subplot(4,4,1);
r =  imread("cameraman.tif");
s = r ;
imshow(s);
title("identity trans.of gray image");

subplot(4,4,2);
n = (255- r);
imshow(n);
title("negative trans.of gray image");


subplot(4,4,3);
s = im2bw(r) ;
imshow(s);
title("identity trans. of binary image" );

subplot(4,4,4);
n = (1- im2bw(r));
imshow(n);
title("negative trans. of binary image");




d =(double(r)/255) ;

subplot(4,4,5);
u = 0.5 * log(d+1);
imshow(u);
title("log trans. (c = 0.6)");

subplot(4,4,6);
u = 1 * log(d+1);
imshow(u);
title("log trans. (c = 1)");

subplot(4,4,7);
u = 2 * log(d+1);
imshow(u);
title("log trans. (c = 1.5)");


subplot(4,4,9);
v = 0.5 * (exp(d)-1);
imshow(v);
title("antilog trans.(c = 0.8) ");

subplot(4,4,10);
v = 1 * (exp(d)-1);
imshow(v);
title("antilog trans. (c = 1) ");

subplot(4,4,11);
v = 2 * (exp(d)-1);
imshow(v);
title("antilog trans. (c = 1.4) ");


subplot(4, 4,13 );
x = 1*(d.^1);
imshow(x);
title("power law t.(gamma = 1,c= 2)");

subplot(4,4,14 );
x = 1 * (d.^0.5);
imshow(x);
title("power law t.(gamma = 0.5,c= 2)");

subplot(4,4,15 );
x = 1*(d.^1.5);
imshow(x);
title("power law t.(gamma = 2.5,c= 2)");

