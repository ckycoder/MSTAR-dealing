
clear all;close all;
ReadPath_chip = 'D:\科研\MSTAR\MSTAR-PublicTargetChips-T72-BMP2-BTR70-SLICY\MSTAR_PUBLIC_TARGETS_CHIPS_T72_BMP2_BTR70_SLICY\TARGETSJPG\TEST\15_DEG\BMP2\SN_9563\';


ReadPath_cult = 'D:\科研\MSTAR\MSTAR-PublicClutter-CD1\MSTAR_PUBLIC_CLUTTER_CD1\CLUTTERJPG\15_DEG\HB06158.jpg';

SavePath = 'D:\科研\MSTAR\合成图';


Files = dir(ReadPath_chip);
NumberOfFiles = length(Files);
my_num=NumberOfFiles-3;

cult=imread(ReadPath_cult);

for k = 3 : NumberOfFiles-1
    chip_file = strcat(ReadPath_chip,Files(k).name);
    sar_data(k-2,:,:) = imread(chip_file);
end
[num,row,col] = size(sar_data);
%%寻找目标位置
num2=70;
my_rand=rand(1784,1476);
my_rand(:,1:num2)=0;
my_rand(:,1476-num2:1476)=0;
my_rand(1:num2,:)=0;
my_rand(1784-num2:1784,:)=0;
my_rand(find(my_rand<0.99999))=0;
[row,col]=find(my_rand>0.1);

row(row==0) = [];
col(col==0) = [];

psi_num=size(row);
for i=1:psi_num(1,1);
   if row(i,1)~=0
       for j=(i+1):psi_num(1,1)
     
         if abs(row(i,1)-row(j,1))<98
             if abs(col(i,1)-col(j,1))<98
                row(j,1)=0;
                col(j,1)=0;
             end
         end
        end
    end
end
row(row==0) = [];
col(col==0) = [];
%%
truth_num=size(row);

my_cult=cult;

for i=1:truth_num(1,1)
    mean_chip = mean(mean(sar_data(i,:,:)));
    mean_cult = mean(mean(my_cult(row(i,1)-64:row(i,1)+63,col(i,1)-64:col(i,1)+63)));
    my_cult(row(i,1)-24:row(i,1)+23,col(i,1)-24:col(i,1)+23) = sar_data(i,40:87,35:82)/mean_chip*mean_cult*1.2;
    %my_cult(row(i,1)-64:row(i,1)+63,col(i,1)-64:col(i,1)+63) = sar_data(i,:,:)/mean_chip*mean_cult;
end

figure,
colormap(gray(256));
imagesc(my_cult)
axis image;        % Retain wid to hgt image aspect..
axis off;          % Turn off axis labelling..


brighten(0.5);





