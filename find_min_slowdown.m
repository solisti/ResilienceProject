function find_min_slowdown

    matrices = {'bcsstk18', 'bodyy5', 'cbuckle', 'G2_circuit'};

    num_matrices = length(matrices);
    comments = 'Step5';
    close all;

    protects = [0:0.01:1];   % percentage of protection
    num_protects = length(protects);

    for m = 1:num_matrices

        matrixname = matrices{m};
        disp(matrixname);

        bitflip_iter =1; 

        protect_method = 'Arow2norm';   
        % protect_method = 'random'; 
        analysis_filename = ['./data/', matrixname, '/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        slowdowns_Arow2norm = dlmread(analysis_filename);
        slowdowns_Arow2norm = slowdowns_Arow2norm';
        mean_slowdowns_Arow2norm = mean(slowdowns_Arow2norm);
    



        % find minimum slowdown 
        [min_value, min_index] = min(mean_slowdowns_Arow2norm);

        % mean_slowdowns_Arow2norm

        
        min_slowdown = ['./data/', matrixname, '/', matrixname,'_', protect_method, '_min_slowdown.txt'];  
        
        fileID = fopen(min_slowdown, 'w');  
        fprintf(fileID, '%f %f \n', min_value, min_index);  
        fclose(fileID);  


        overheads1_Arow2norm = slowdowns_Arow2norm;
        for p = 1:num_protects
            protect = protects(p);
            overheads1_Arow2norm(:, p) = 100*((protect+1)*slowdowns_Arow2norm(:, p)-1);
        end

        mean_overheads1_Arow2norm = mean(overheads1_Arow2norm);
        zeroth = mean_overheads1_Arow2norm(1)

        min_overhead = ['./data/', matrixname, '/', matrixname, '_', protect_method, '_min_overhead.txt']; 
        [min_value, min_index] = min(mean_overheads1_Arow2norm(:));
        
        fileID = fopen(min_overhead, 'w');  
        fprintf(fileID, '%f %f \n', min_value, min_index);  
        fclose(fileID);  
    end

end 