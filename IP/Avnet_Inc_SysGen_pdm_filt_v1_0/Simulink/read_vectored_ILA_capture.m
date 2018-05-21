
function [ ila_data] = read_vectored_ILA_capture(ila_data_csv_file)

[ndata, text, alldata] = xlsread(ila_data_csv_file);

ila_data = zeros(length(alldata)-2,length(char(alldata(3,5))));      % import binary data starting row 3 of saved .CSV file from ILA export

for row = 3 : length(alldata)
    chars = char(alldata(row,5));
    for col = 1:length(chars)
        ila_data(row-2,col) = eval(chars(col));
    end
end

end

