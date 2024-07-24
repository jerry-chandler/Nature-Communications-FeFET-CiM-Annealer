function [input_x,input_y,Q,chipsize,chipsize_save] = matrixcut(A)

%calculate the connectivity
[len,~] = size(A);
connectivity_matrix = zeros(2,len);
connectivity_matrix(1,:) = 1:len;
for i = 1:len %calculate the connectivity of xi
    for j = 1:len
        if A(i,j) ~= 0
            connectivity_matrix(2,i) = connectivity_matrix(2,i) + 1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%sort in a decreasing trend
for i = 1:len-1
    for j = 1 : 1: len-i
        if connectivity_matrix(2,j) > connectivity_matrix(2,j-1) %change
            temp = connectivity_matrix(:,j-1);
            connectivity_matrix(:,j-1) = connectivity_matrix(:,j);
            connectivity_matrix(:,j) = temp;
        end
    end
end
increasing_todo = fliplr(connectivity_matrix(1,:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%high to low OR low to high
col_todo = increasing_todo;
line_todo = increasing_todo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%cut
%col preparation
col_rem = zeros(1,len);
col_rem_index = 1;
col_stay = zeros(1,len);
col_stay_index = 1;
%main loop in column
for j = col_todo    
    if ~ismember(j,col_stay) && ~ismember(j,col_rem) %remove
        col_rem(col_rem_index) = j;
        col_rem_index = col_rem_index + 1;
        % turn to the line
        for k = 1:len
            if A(j,k) ~=0 && ~ismember(k,col_stay)
                col_stay(col_stay_index) = k;
                col_stay_index = col_stay_index + 1;
            end
        end
    end
end
%line preparation
line_rem = zeros(1,len);
line_rem_index = 1;
line_stay = col_rem;
line_stay_index = col_rem_index;
%main loop in line
for i = line_todo
    if  ~ismember(i,line_stay) && ~ismember(i,line_rem)
        line_rem(line_rem_index) = i;
        line_rem_index = line_rem_index + 1;
        % turn to the column
        for k = 1:len
            if A(k,i) ~=0 && ~ismember(k,line_stay)
                line_stay(line_stay_index) = k;
                line_stay_index = line_stay_index + 1;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%xQy form
input_x = sort(line_stay(find(line_stay)));
input_y = sort(col_stay(find(col_stay)));
[~,len_x] = size(input_x); 
[~,len_y] = size(input_y); 
Q = zeros(len_x,len_y);
for i = 1:len_x
    for j = 1:len_y
        %Q(i,j)
        x0 = input_x(i);
        y0 = input_y(j);
        if A(x0,y0) ~= 0 %x0 x y0 exists
            if ismember(x0,input_y) && ismember(y0,input_x)
                %find the index
                index_y = find(input_y == x0);
                index_x = find(input_x == y0);
                Q(i,j) = 1;
                Q(index_x,index_y) = 1;
            else
                Q(i,j) = 2;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%output

fprintf("connectivity: low to high\n");

fprintf('the x:\n');
disp(sort(line_stay(find(line_stay))));
fprintf('the y:\n');
disp(sort(col_stay(find(col_stay))));
fprintf("original size: %d x %d = %d\n",len,len,len*len);
chipsize = (line_stay_index-1)*(col_stay_index-1);
fprintf("final size: %d x %d = %d\n",line_stay_index-1,col_stay_index-1,chipsize);
fprintf("size scale save(%%): %.2f\n\n", 100-chipsize/len/len*100);
chipsize_save = double(100-double(chipsize)/len/len*100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

