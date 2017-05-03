
function [ila_PDM_data] = read_vectored_ILA_PDM_capture(ila_data_csv_file)

% Read PDM data captured in ILA as 'vectorized' rows of 1024 bits
% Allows much longer bursts of PDM data to be captured than single bit into ILA

[ndata, text, alldata] = xlsread(ila_data_csv_file);

ila_PDM_data = zeros(length(alldata)-2,length(char(alldata(3,5))));      % import binary data starting row 3 of saved .CSV file from ILA export

for row = 3 : length(alldata)
    chars = char(alldata(row,5));
    for col = 1:length(chars)
        ila_PDM_data(row-2,col) = eval(chars(col));
    end
end

end

