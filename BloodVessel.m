function [final] = BloodVessel (originalImage1)
% RGB to grayscale
%imshow([originalImage1(:,:,1),originalImage1(:,:,2),originalImage1(:,:,3)]);


%close all
%clear all
%originalImage1=imread ('u:\teamblood\DRIVE\test\images\03_test.tif');
%greyImage1 = originalImage1(:,:,2);
greyImage1 = rgb2gray(originalImage1);
greyImage1 = double(greyImage1);
% Use a mask to remove the background
mask1 = find_mask(greyImage1);
mask1 = 1-mask1;
frangi1=FrangiFilter2D(greyImage1);
maskedFrangi1 = frangi1.*mask1;
%figure; imshow(maskedFrangi1);
%level = graythresh(maskedFrangi1);
%thresholded1 = im2bw(maskedFrangi1,level*0.05);

thresholded1 = im2bw(maskedFrangi1,0.001);
%figure; imshow(thresholded1); title('thresh')

CC = bwconncomp(thresholded1, 8);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);
BW2 = ismember(L, find([S.Area] >= 30));
    %figure; imshow(BW2); title('1st selection >');
BW3 = ismember(L, find([S.Area] < 30)); 
    %figure; imshow(BW3); title('1st selection <');

se4=strel('disk',1);
po=imdilate(BW2, se4);
    %figure; imshow(po); title('1st selection > + dilate')
%bw4 = imerode(po,se4);
%Iskel = bwmorph(po,'skel',Inf);
%Iendp = bwmorph(Iskel,'endpoints');
% Iconn = bwlabel(Iskel,8);
% Idiff = Iskel - Iendp;
%Iendplab = Iconn - Idiff; %endpoints like connected components
%[n m] = size(bw4);

CC2 = bwconncomp(po, 4);
S2 = regionprops(CC2, 'Area');
L2 = labelmatrix(CC2);
po1 = ismember(L2, find([S2.Area] < 150));
    %figure; imshow(po1); title('2nd selection <');
po2 = ismember(L2, find([S2.Area] >= 150));
    %figure; imshow(po2); title('2nd selection >');

CC3 = bwconncomp(po1, 4);
S3 = regionprops(CC3, 'Area','Eccentricity');
L3 = labelmatrix(CC3);
%po2 = ismember(L3, find([S3.Area] >= 200));
poCen = ismember(L3, find([S3.Eccentricity] >= 0.95));
    %figure; imshow(poCen); title('3rd selection Eccentricity')
final = imadd(po2,poCen);
    %figure; imshow(final); title('final before dilate')

   final = imerode(final,se4);
se5=strel('disk',2);
%final = imerode(final,se5);
%figure; imshow(final); title('final');
end