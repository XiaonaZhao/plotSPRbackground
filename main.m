clear
clc

%  Author: s201346044@mail.dlut.edu.cn;
% Created: 9th July, 2018;

tifNum = input('Please input the total quantity of tiff files:\n');
maindir = uigetdir( 'Select the destination folder' );
list = dir(fullfile(maindir));
listNum = size(list, 1) - 2;
tifSeq = cell(tifNum, 3); % A cell has cells
for j = 3:size(list, 1)
    fprintf('Now, process the Folder %d.\n', j-2);
    startNum = input('Please input the start number of this folder:\n');
    tifList = dir(fullfile(maindir, list(j).name, '*.tiff'));
%     tifNum = length(tifList);
    if tifNum > 0
        for jj = startNum:(tifNum - 1) % fps = 106
            tifSeq(jj, 3) = imread(fullfile(maindir, list(j).name, tifList{jj})); % read all tiff files
        end
    else
        disp('Folder %d is empty', j);
    end
end