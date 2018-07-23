clear
clc

% Author: s201346044@mail.dlut.edu.cn;
% Created: 9th July, 2018;
% The exp. is CV with 0 ~ -0.5V, 0.1 V/s, 2 circuits.

%%
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
ang1stSlide; % input the real data from the exp.
%%
q = 1;
frame = cell(tifNum,1);

for j = 3:size(list, 1)
    fprintf('Now, process the Folder %d.\n', j-2);
    %     input('Please input the start number of this folder:\n');
    startNum = ang1stSlide(j-2,2);
    tifList = dir(fullfile(maindir, list(j).name, '*.tiff'));
    fileNum = length(tifList);
    
    if fileNum > 0
        for ii = 1:tifNum
            for jj = startNum:(startNum + tifNum) % fps = 106
                frame{ii}= imread(fullfile(maindir, list(j).name, tifList(jj).name));
                % 3. Read .tiff files;
                tifSeq(q, 3) = mean(frame{ii}(:)); % 4. Mean each frame;
                q = q + 1;
            end
        end
        clear frame
    else
        disp('Folder %d is empty', j-2);
    end
    fprintf('Folder %d has been processed.\n', j-2);
end
%% 5. plot the [average(Intensity), angle, frames];
