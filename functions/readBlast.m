function [x_blasts, y_blasts] = readBlast(fullPathLabelOriginal)

x_blasts = [];
y_blasts = [];
fp1 = fopen(fullPathLabelOriginal, 'r');
while ~feof(fp1)
    t = fgets(fp1); t(end) = [];
    if numel(t) == 0
        break;
    end %if numel(t) == 0
    C = strsplit(t, '\t');
    x_blasts = [x_blasts str2double(C{1})];
    y_blasts = [y_blasts str2double(C{2})];
end % while

fclose(fp1);

end % end function

