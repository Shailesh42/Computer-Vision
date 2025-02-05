clc;
clear all;
close all; 
I = imread("coins.png");
r = im2double(I); 
noise = imnoise(r, "gaussian",0.01);
[rows,cols] = size(noise);

noise_i = noise ;
 
for i = 1 : rows
    for j = 1 : cols 
          noise_i(i,j) = noise_i(i,j) *(-1)^(i+j);
    end
end   

padd_i = padarray(noise_i,[rows cols],0,'post');
dft_mtx = fft2(padd_i);

D_values =[70,90,150];
for k = 1: 3
  D = D_values(k);
  ILP = zeros(2*rows,2*cols);
  IHP = ones(2*rows,2*cols);
  GLP = zeros(2*rows,2*cols);
  GHP = ones(2*rows,2*cols);
  for i = 1 : 2*rows
     for j = 1 :2 *cols
        Duv = sqrt((i - rows)^2 + (j - cols)^2);
        if Duv <= 70
             ILP(i, j) = 1 ;
        end
        GLP(i, j) = exp((-1)*(Duv^2)/(2 *(D^2)));
     end
  end
  GHP = GHP -GLP ;
  IHP = IHP-ILP ;
  figure();
  subplot(3,2,1);
  imshow(I);
  title("original");
  subplot(3,2,2);
  imshow(noise);
  title("noise img");
  IHP = 1 -ILP;
  GHP = 1- GLP;

  GUV = dft_mtx.*ILP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,3);
  imshow(filter_img);
  title(['Ideal LPF, D = ', num2str(D)]);
  GUV = dft_mtx.*IHP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,4);
  imshow(filter_img);
  title(['IDeal HPF, D = ', num2str(D)]);

  GUV = dft_mtx.*GLP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,5);
  imshow(filter_img);
  title(['Gaussian LPF, D = ', num2str(D)]);

  GUV = dft_mtx.*GHP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,6);
  imshow(filter_img);
  title(['Gaussian HPF, D = ', num2str(D)]);
end

I = imread("coins.png");
r = im2double(I); 
noise = imnoise(r, "speckle");
[rows,cols] = size(noise);

noise_i = noise ;
 
for i = 1 : rows
    for j = 1 : cols 
          noise_i(i,j) = noise_i(i,j) *(-1)^(i+j);
    end
end   

padd_i = padarray(noise_i,[rows cols],0,'post');
dft_mtx = fft2(padd_i);

D_values =[70,90,150];
for k = 1: 3
  D = D_values(k);
  ILP = zeros(2*rows,2*cols);
  IHP = ones(2*rows,2*cols);
  GLP = zeros(2*rows,2*cols);
  GHP = ones(2*rows,2*cols);
  for i = 1 : 2*rows
     for j = 1 :2 *cols
        Duv = sqrt((i - rows)^2 + (j - cols)^2);
        if Duv <= 70
             ILP(i, j) = 1 ;
        end
        GLP(i, j) = exp((-1)*(Duv^2)/(2 *(D^2)));
     end
  end
  GHP = GHP -GLP ;
  IHP = IHP-ILP ;
  figure();
  subplot(3,2,1);
  imshow(I);
  title("original");
  subplot(3,2,2);
  imshow(noise);
  title("noise img");
  IHP = 1 -ILP;
  GHP = 1- GLP;

  GUV = dft_mtx.*ILP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,3);
  imshow(filter_img);
  title(['Ideal LPF, D = ', num2str(D)]);
  GUV = dft_mtx.*IHP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,4);
  imshow(filter_img);
  title(['IDeal HPF, D = ', num2str(D)]);

  GUV = dft_mtx.*GLP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,5);
  imshow(filter_img);
  title(['Gaussian LPF, D = ', num2str(D)]);

  GUV = dft_mtx.*GHP ;
  idft_mtx = real(ifft2(GUV));
  for i = 1 : rows
    for j = 1 : cols 
          idft_mtx(i,j) = idft_mtx(i,j) *(-1)^(i+j);
    end
  end
  filter_img = idft_mtx(1:rows,1:cols);
  subplot(3,2,6);
  imshow(filter_img);
  title(['Gaussian HPF, D = ', num2str(D)]);
end
