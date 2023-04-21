function [x_blasts, y_blasts, x_other, y_other] = readBlastOther(fullPathLabelOriginal)

x_blasts = [];
y_blasts = [];
x_other = [];
y_other = [];
fp1 = fopen(fullPathLabelOriginal, 'r');
t = fgets(fp1); t(end) = [];
if strcmp(t, 'WBC_probable_lymphoblasts') == 1
    while ~feof(fp1)
        t = fgets(fp1); t(end) = [];
        if strcmp(t, 'Other_cases') == 1
            break;
        else % if strcmp(t, 'normal') == 1
            C = strsplit(t, ' ');
            x_blasts = [x_blasts str2double(C{1})];
            y_blasts = [y_blasts str2double(C{2})];
        end %if strcmp
    end % while
end % if strcmp(t, 'blasts') == 1
while ~feof(fp1)
    t = fgets(fp1); t(end) = [];
    C = strsplit(t, ' ');
    x_other = [x_other str2double(C{1})];
    y_other = [y_other str2double(C{2})];
end % while ~feof(fp1)
fclose(fp1);

end % end function

