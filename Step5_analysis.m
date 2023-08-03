function Step5_analysis

% This function analyzes the slowdown associated with our selective 
% protection algorithm and the random protection algorithm under 
% different fractions of protection (from 1% to 100%). 

comments = 'Step5';

% matrices = {'cvxbqp1', 'thermal1', 'nd6k', ...
%    'bcsstk18', 'bodyy5', 'cbuckle', 'Pres_Poisson', 'bcsstk36', 'ct20stif', 'gyro_m', 't2dah_e', 'm_t1', 'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', ...
%    'Trefethen_20000', 'vanbody','wathen100'};
% matrices = {'bcsstk18', 'thermal1', 'ct20stif', 'cbuckle'}; 
matrices = {'bcsstk18', 'bodyy5', 'cbuckle', 'G2_circuit'};
% matrices = {'cvxbqp1', 'thermal1', 'nd6k', 'bcsstk18', 'bodyy5', 'cbuckle', 'Pres_Poisson', 'bcsstk36', 'ct20stif', 'gyro_m', 't2dah_e'};
num_matrices = length(matrices);

% bitflip_iter = 110;
protects = [0:0.01:1];   % percentage of protection
num_protects = length(protects);





for m = 1:num_matrices

    matrixname = matrices{m};
    disp(matrixname);

    new_error = ['./matrices/', matrixname, '_newerror.mat'];
    load(new_error, 'injections');

    % create new folders for these matrices if they don't already exist 

    path = ['./data/', matrixname];
    if exist(path, 'dir') ~= 7
        mkdir(path);
    end


    % for bitflip_iter = injections
        bitflip_iter = 1;
        %% load matrix norms
        norms_filename = ['./matrices/', matrixname, '_norms.mat'];
        load(norms_filename);
        N = length(A_row_2norm);
        [~, sorted_positions] = sort(A_row_2norm, 'descend');
        rand_positions = randperm(N);
        
        %% load experimental data
        result_filename = ['./data/', matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
        result = dlmread(result_filename);
    
        rel_grad_filename = ['./matrices/', matrixname, '_iter=', num2str(bitflip_iter), '_gradient_relative.mat'];
        abs_grad_filename = ['./matrices/', matrixname, '_iter=', num2str(bitflip_iter), '_gradient_absolute.mat'];
        xval_filename = ['./matrices/', matrixname, '_iter=', num2str(bitflip_iter), '_xval.mat'];
        load(rel_grad_filename);
        load(abs_grad_filename);
        load(xval_filename);
        

        grad_rel(isnan(grad_rel)) = 0;
        grad_abs(isnan(grad_rel)) = 0;

        [~, sorted_rel] = sort(grad_rel, 'ascend');
        [~, sorted_abs] = sort(grad_abs, 'ascend');
        [~, sorted_xval] = sort(xval, 'descend');
    
        error_positions = result(:, 4);
        noerror_converges = result(:, 7);
        converges = result(:, 8);
        converge_ratios = converges./noerror_converges;
        num_exps = length(error_positions);
        
        %% analyze data by A_row 2-norm
        protect_method = 'Arow2norm'; 
        analysis_filename = ['./data/', matrixname, '/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        % analysis_filename = ['./data/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        slowdowns = zeros(num_protects, num_exps);
        for p = 1:num_protects
            protect_percent = protects(p);
            protect_number = ceil(protect_percent * N);
            protect_positions = sorted_positions(1:protect_number);
            for e = 1:num_exps
                error_position = error_positions(e);
                converge_ratio = converge_ratios(e);
                if ismember(error_position, protect_positions)
                    slowdowns(p, e) = 1;
                else
                    slowdowns(p, e) = converge_ratio; 
                end
            end
        end
        dlmwrite(analysis_filename, slowdowns);
        
        %% analyze data by random
        protect_method = 'random'; 
        analysis_filename = ['./data/', matrixname, '/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        % analysis_filename = ['./data/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        slowdowns = zeros(num_protects, num_exps);
        for p = 1:num_protects
            protect_percent = protects(p);
            protect_number = ceil(protect_percent * N);
            protect_positions = rand_positions(1:protect_number);
            for e = 1:num_exps
                error_position = error_positions(e);
                converge_ratio = converge_ratios(e);
                if ismember(error_position, protect_positions)
                    slowdowns(p, e) = 1;
                else
                    slowdowns(p, e) = converge_ratio; 
                end
            end
        end
        dlmwrite(analysis_filename, slowdowns);
    
        %% analyze data by absoluted gradient
        protect_method = 'absgradient'; 
        analysis_filename = ['./data/', matrixname, '/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        % analysis_filename = ['./data/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        slowdowns = zeros(num_protects, num_exps);
        for p = 1:num_protects
            protect_percent = protects(p);
            protect_number = ceil(protect_percent * N);
            protect_positions = sorted_abs(1:protect_number); 
            for e = 1:num_exps
                error_position = error_positions(e);
                converge_ratio = converge_ratios(e);
                if ismember(error_position, protect_positions)
                    slowdowns(p, e) = 1;
                else
                    slowdowns(p, e) = converge_ratio; 
                end
            end
        end
        dlmwrite(analysis_filename, slowdowns);
    
        %% analyze data by relative gradient
        protect_method = 'relgradient'; 
        analysis_filename = ['./data/', matrixname, '/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        % analysis_filename = ['./data/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        slowdowns = zeros(num_protects, num_exps);
        for p = 1:num_protects
            protect_percent = protects(p);
            protect_number = ceil(protect_percent * N);
            protect_positions = sorted_rel(1:protect_number); 
            for e = 1:num_exps
                error_position = error_positions(e);
                converge_ratio = converge_ratios(e);
                if ismember(error_position, protect_positions)
                    slowdowns(p, e) = 1;
                else
                    slowdowns(p, e) = converge_ratio; 
                end
            end
        end
        dlmwrite(analysis_filename, slowdowns);
    
        %% analyze data by x value
        protect_method = 'xval'; 
        analysis_filename = ['./data/', matrixname, '/', comments, '_', matrixname, '_iter=', num2str(bitflip_iter), '_', protect_method, '.dat'];
        slowdowns = zeros(num_protects, num_exps);
        for p = 1:num_protects
            protect_percent = protects(p);
            protect_number = ceil(protect_percent * N);
            protect_positions = sorted_xval(1:protect_number);  
            for e = 1:num_exps
                error_position = error_positions(e);
                converge_ratio = converge_ratios(e);
                if ismember(error_position, protect_positions)
                    slowdowns(p, e) = 1;
                else
                    slowdowns(p, e) = converge_ratio; 
                end
            end
        end
        dlmwrite(analysis_filename, slowdowns);        
    end 

end 
    
% end