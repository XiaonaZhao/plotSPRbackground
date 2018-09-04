%%
clear
clc

% Author: s201346044@mail.dlut.edu.cn;
% Created: 9th July, 2018;
% The exp. is CV with 0 ~ -0.5V, 0.1 V/s, 2 circuits.

% ang1stSlide = [...
%     5587 326;...
%     5589 221;...
%     5591 235;...
%     5593 331;...
%     5595 331;...
%     5597 681;...
%     5599 323;...
%     5601 325;...
%     5603 116;...
%     5605 402;...
%     5607 326;...
%     5609 219;...
%     5611 317;...
%     5631 353;...
%     5636 255;...
%     5641 438;...
%     5646 423;...
%     5651 363;...
%     5656 452;...
%     5661 403]; % 1st column is the angle of laser, the other the begin slide

%% 1. Approach the file address;
maindir = uigetdir( 'Select the destination folder' );
list = dir(fullfile(maindir));
listNum = size(list, 1) - 2;

%% 2. Select the interesting frames; % in loop
fps = input('Please input the sampling rate of the exp.:\n');
tifNum = (0-(-0.5))*2*2/0.1*fps;
tifSeq = zeros((tifNum*listNum), 3); % A cell has cells
load ang1stSlide; % input the real data from the exp.

%% 3. Calculate the average of each frames in every folder one by one
q = 1;
frame = zeros(480, 640);

for j = 3:size(list, 1)
    fprintf('Now, process the Folder %d.\n', j-2);
    %     input('Please input the start number of this folder:\n');
    startNum = ang1stSlide(j-2,2);
    tifList = dir(fullfile(maindir, list(j).name, '*.tiff'));
    fileNum = length(tifList);
    
    if fileNum <= 0
        disp('Folder %d is empty', j-2);
        break
    end
    
    for jj = startNum:(startNum + tifNum-1) % fps = 106
        frame = imread(fullfile(maindir, list(j).name, tifList(jj).name));
        % 3. Read .tiff files;
        tifSeq(q, 3) = mean(frame(:)); % 4. Mean each frame;
        q = q + 1;
        clear frame
    end
    
    fprintf('Folder %d has been processed.\n', j-2);
end

%% 4. plot the [average(Intensity), angle, frames];

for jj =1:listNum
    tifSeq((1+(jj-1)*tifNum) : (tifNum*jj), 1) = ang1stSlide(jj,1);
end


%% 5. plot the [angle, Voltage, average(Intensity)];
Voltage1 = 0;
Voltage2 = -0.5;
VoltDots = (linspace(Voltage1,Voltage2,tifNum/4))'; % linspace is row vector
Volt = [VoltDots; flipud(-1*VoltDots(1:end))]; % 1c, that is [0 -0.5 0].
[r, c] = size(Volt);
Voltage = zeros(40*r,c);
Voltage(1:tifNum/2) = Volt;
for jj = 1:listNum*2-1 % there are 20 folders in total, and each has 2 circuits.
    Voltage(1+jj*tifNum/2:(jj+1)*tifNum/2) = [VoltDots; flipud(-1*VoltDots(1:end))];
end
tifSeq(:,2) = Voltage;

x = tifSeq(:,1);
y = tifSeq(:,2);
z = tifSeq(:,3);
plot3(x,y,z)
grid on
xlabel('Angle')
ylabel('Voltages')
zlabel('Intensity')

%% 6. plot the [angle, frames, average(Intensity)];
frames = (linspace(1,tifNum,tifNum))';
Frames = zeros(tifNum*20,1);
Frames(1:tifNum) = frames;
for jj = 1:listNum-1 % there are 20 folders in total, and each has 2 circuits.
    Frames(1+jj*tifNum:(jj+1)*tifNum) = frames;
end
tifSeq(:,2) = Frames;

x = tifSeq(:,1);
y = tifSeq(:,2);
z = tifSeq(:,3);
scatter3(x, y, z, 10, z, 'fill');
caxis([0 1e+04]);
% colormap(jet(1e+6));
% map = colormap;
% map(1,:) = [1 1 1];
colormap default
colorbar;
title('How the laser location and samping time in CV affect the intensity');
xlabel('Angle')
ylabel('Frames')
zlabel('Intensity')