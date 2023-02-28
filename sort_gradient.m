function sort_gradient(matrixname)

rel_grad_filename = ['./data/Step3_', matrixname, '_relative_gradient','.dat'];
abs_grad_filename = ['./data/Step3_', matrixname, '_absolute_gradient','.dat'];

r_sorted_filename = ['./data/Step3_', matrixname, '_relative_gradient_sorted','.dat'];
a_sorted_filename = ['./data/Step3_', matrixname, '_absolute_gradient_sorted','.dat'];

filename = {rel_grad_filename, abs_grad_filename};
sorted_entries = {r_sorted_filename, a_sorted_filename};

for f = 1:length(filename)

    % Open the .dat file for reading
    fid = fopen(filename{f}, 'r');
    
    % Read the contents of the file and store them in a cell array
    entries = textscan(fid, '%s', 'Delimiter', '\n');
    entries = entries{1};
    
    % Sort the cell array of entries
    sorted_entries = sort(entries, 'descend');
    
    % Close the file
    fclose(fid);
    
    % Open the .dat file for writing
    fid = fopen(sorted_entries{f}, 'w');
    
    % Write the sorted cell array to the new file
    fprintf(fid_out, '%s\n', sorted_entries{:});
    
    % Close the file
    fclose(fid);
end
end
