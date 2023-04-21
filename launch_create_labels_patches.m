clc
close all
clear variables
fclose('all');
addpath('./functions');

plotta = 0;
ms = 25;
lw = 3;
sizePatches = 256;
overlapPct = 0.25; % 25%
pixelToll = 5;

dbname = 'ALL-IDB1';

dirDb = ['./' dbname '/im/']; 
dirLabelsBlasts = ['./' dbname '/xyc/']; 
dirLabelsOther = ['./' dbname '/other/']; 
dirLabelsMerge = ['./' dbname '/merge/']; 
extImg = 'jpg';
extLabels = 'xyc';

% CREATE LABELS
fprintf(1, 'Creating labels...\n');
files = dir([dirLabelsBlasts '*.' extLabels]);

for i = 1 : numel(files)

    filename = files(i).name;
    fullPathLabelBlast = [dirLabelsBlasts filename];
    fullPathLabelOther = [dirLabelsOther filename];

    fprintf(1, ['\t' filename '\n']);
    
    % load original (only blasts)
    [x_blasts, y_blasts] = readBlast(fullPathLabelBlast);
    % load other
    [x_other, y_other] = readOther(fullPathLabelOther);
    % pause

    % write updated
    % start with blasts
    filenameLabelMerge = [dirLabelsMerge filename];
    fp = fopen(filenameLabelMerge, 'w');
    fprintf(fp, 'WBC_probable_lymphoblasts\n');
    for r = 1 : numel(x_blasts)
        fprintf(fp, '%d %d\n', x_blasts(r), y_blasts(r));
    end % for r
    % end %if isnan
    % write non blasts
    fprintf(fp, 'Other_cases\n');
    for r = 1 : numel(x_other)
        fprintf(fp, '%d %d\n', x_other(r), y_other(r));
    end % for r
    fclose(fp);

end % for i


% CREATE PATCHES
fprintf(1, 'Creating patches...\n');

dirPatches = ['./' dbname '/patches_' num2str(sizePatches) '_overlap_' num2str(overlapPct) '_toll_' num2str(pixelToll) '/'];
[~, ~, ~] = mkdir(dirPatches);
dirPatchesInfo = [dirPatches 'info/'];
[~, ~, ~] = mkdir(dirPatchesInfo);

% init table
T = table("ciao", 1, 1, "ciao", "ciao", 'VariableNames', ...
    {'Filename', ...
    'White blood cell probable ALL lymphoblast', 'Other cases', ...
    'Centroids blasts', 'Centroids other cases'});
count_T = 1;

files = dir([dirDb '*.' extImg]);

max_blasts = -1;
max_other = -1;

for i = 1 : numel(files)

    filename_img = files(i).name;
    [C, ~] = strsplit(filename_img, '.');
    filename_noext = C{1};
    filename_img_full = [dirDb filename_img];
    im_full = imread(filename_img_full);

    fprintf(1, ['\t' filename_img '\n']);

    % blockedImage can directly load an image too
    bim = blockedImage(im_full);
    % See help selectBlockLocations for more examples.
    blockSize = [sizePatches sizePatches];
    blockOffsets = round(blockSize.*(1-overlapPct));
    bls = selectBlockLocations(bim,...
        'BlockSize', blockSize,...
        'BlockOffSets', blockOffsets,...
        'ExcludeIncompleteBlocks', true);
    % Create a datastore from this set of blocks
    bimds = blockedImageDatastore(bim, 'BlockLocationSet', bls);

    if plotta
        % Visualize the block locations to confirm logic
        hd = figure(1);
        bigimageshow(bim)
        % Block size is in row-col (height-width) order
        blockWH = fliplr(bls.BlockSize(1,1:2));
        colors = prism(size(bls.BlockOrigin,1));
        for ind = 1:size(bls.BlockOrigin,1)
            % blockColor = colors(ind,:);
            blockColor = colors(3,:);
            % BlockOrigin is already in x-y order
            drawrectangle('Position', [bls.BlockOrigin(ind,1:2), blockWH], 'Color', blockColor, 'FaceAlpha', 0.1);
        end % for ind
        hd.WindowState = 'maximized';
        axis off
        pause(0.5);
        % close(hd)
    end % end plotta

    % pause

    % read position of blasts and other
    filenameLabelOriginal = strrep(filename_img, extImg, extLabels);
    fullPathLabelOriginal = [dirLabelsMerge filenameLabelOriginal];
    [x_blasts, y_blasts, x_other, y_other] = readBlastOther(fullPathLabelOriginal);

    % Read each block and write it out
    count = 1;
    while hasdata(bimds)

        % init
        blast_present = 0;
        other_present = 0;

        count_blasts = 0;
        count_other = 0;

        centroids_blasts = [];
        centroids_other = [];

        [data, info] = read(bimds);
        filenamePatch = [filename_noext '_patch_' num2str(count) '.tif'];

        % check wbc locations and assign label
        % blasts
        for b = 1 : numel(x_blasts)
            c1 = (x_blasts(b) >= info.Start(2) - pixelToll);
            c2 = (x_blasts(b) <= info.End(2) + pixelToll);
            c3 = (y_blasts(b) >= info.Start(1) - pixelToll);
            c4 = (y_blasts(b) <= info.End(1) + pixelToll);
            if (c1 && c2 && c3 && c4)
                blast_present = 1;
                count_blasts = count_blasts + 1;
                centroids_blasts = [centroids_blasts, bound(x_blasts(b) - info.Start(2), 1, sizePatches), ...
                    bound(y_blasts(b) - info.Start(1), 1, sizePatches)];
                %break;
            end % if c1
        end % for b
        % normal
        for b = 1 : numel(x_other)
            c1 = (x_other(b) >= info.Start(2) - pixelToll);
            c2 = (x_other(b) <= info.End(2) + pixelToll);
            c3 = (y_other(b) >= info.Start(1) - pixelToll);
            c4 = (y_other(b) <= info.End(1) + pixelToll);
            if (c1 && c2 && c3 && c4)
                other_present = 1;
                count_other = count_other + 1;
                centroids_other = [centroids_other, bound(x_other(b) - info.Start(2), 1, sizePatches), ...
                    bound(y_other(b) - info.Start(1), 1, sizePatches)];
                %break;
            end % if c1
        end % for b

        % write only if something is present
        % if blast_present == 1 || normal_present == 1
        if true % always
            % write patch img
            imwrite(data{1}, [dirPatches filenamePatch]);
            % save patch info
            save([dirPatchesInfo filename_noext '_patch_' num2str(count) '.mat'], 'info');
            % write patch table

            if numel(centroids_blasts) > 0
                table_centroids_blasts = num2str(centroids_blasts);
            else %if numel
                table_centroids_blasts = 'N/A';
            end %if numel
            if numel(centroids_other) > 0
                table_centroids_normals = num2str(centroids_other);
            else %if numel
                table_centroids_normals ='N/A';
            end %if numel

            T(count_T,:) = {filenamePatch, blast_present, other_present, ...
                table_centroids_blasts, table_centroids_normals};
            count_T = count_T + 1;
        end % if blast_present == 1 || normal_present == 1

        % update patch count
        count = count + 1;

        if count_blasts > max_blasts
            max_blasts = count_blasts;
        end % if count
    
        if count_other > max_other
            max_other = count_other;
        end % if count

        % pause

    end % while hasdata

    % pause

end % for i

% pause

filenameTable = [dirPatches 'ALL_IDB1_patches_' num2str(sizePatches) '_overlap_' num2str(overlapPct) '_toll_' num2str(pixelToll) '.csv'];
writetable(T, filenameTable);



