function [x_other, y_other] = readOther(fullPathLabelOriginal)

x_other = [];
y_other = [];
fp1 = fopen(fullPathLabelOriginal, 'r');
t = fgets(fp1); t(end) = [];
while ~feof(fp1)
    t = fgets(fp1); t(end) = [];
    if numel(t) == 0
        break;
    end %if numel(t) == 0
    C = strsplit(t, ' ');
    x_other = [x_other str2double(C{1})];
    y_other = [y_other str2double(C{2})];
end % while ~feof(fp1)
fclose(fp1);

end % end function

