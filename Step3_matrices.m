function Step3_matrices

% This function calls Step3_solving, which injects error to a specific
% matrix at a particular iteration. 

% matrices = {'cvxbqp1', 'thermal1', 'nd6k', ...
%    'bcsstk18', 'bodyy5', 'cbuckle', 'Pres_Poisson', 'bcsstk36', 'ct20stif', 'gyro_m', 't2dah_e', 'm_t1', 'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', ...
%    'Trefethen_20000', 'vanbody','wathen100'};

matrices = {'bcsstk18', 'thermal1', 'ct20stif', 'cbuckle'}; 

% matrices = {'m_t1', 'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', 'Trefethen_20000', 'vanbody','wathen100'};
% matrices = {'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', 'Trefethen_20000', 'vanbody','wathen100'};
  
num_matrices = length(matrices);
bitflip_iter = 1;



%get number of iterations needed to converge w/o error
for m = 1:num_matrices
    matrixname = matrices{m};
    noerror_run(matrixname, bitflip_iter);
end

for m = 1:num_matrices
    matrixname = matrices{m};  
    Step3_solving(matrixname, bitflip_iter);
end 

for m = 1:num_matrices
    new_error = ['./matrices/', matrices{m}, '_newerror.mat'];
    load(new_error, 'indices', 'E');
    graph_errors(indices, E, matrices{m});
%     sort_gradient(matrices{m});
end 

close all; 

end