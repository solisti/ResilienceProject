function noerror_run(matrixname, bitflip_iter)

% This function injects error to a specific matrix at a particular iteration. 
% matrixnname: name of the matrix 
% bitflip_iter: iteration number to inject error 

M = 100; % number of experiments, each injects error at a random vector element

% load matrix
matrixfile = ['./matrices/', matrixname, '.mat'];
load(matrixfile);
A = Problem.A;
disp('Done loading matrix');
drawnow('update');
[N, ~] = size(A);
% [hor, ver] = size(A);
result_filename = ['./data/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];

% load preconditioner of matrix
precond_filename = ['./matrices/', matrixname, '_precond.mat'];
load(precond_filename);
disp('Done loading incomplete Cholesky factorization');
drawnow('update');

% load row 2-norm of matrix
norms_filename = ['./matrices/', matrixname, '_norms.mat'];
load(norms_filename);
disp('Done loading row 2-norms of matrix');
drawnow('update');

% setup
xx = ones(N, 1);    % all-1 vector
b = A*xx;           % b is set as A times the all-1 vector 
tol = 1e-6;
max_iter = 10000;

% create error file 
error_filename = ['./matrices/', matrixname, '_error.mat'];
if exist(error_filename, 'file') < 1 % file does not exist 
    if N <= M       % if number of vector elements is <= number of experiments, then inject error in all elements
        E = [1:N]'; % error in every location
        M = N;
    else
        E = datasample([1:N], M);  % error in M random locations from 1 to N
    end
    save(error_filename, 'E');
else % file already exists, then just load the file 
    load(error_filename, 'E');
    M = length(E);
end

% create iterations file
iter_filename = ['./matrices/', matrixname, '_convergence.mat'];
% total_iterations = {};

%% start pcg 
for m = 0:M

    inject_error = 0;
    [~,flag,iter,~,~,~,~,~,~] = pcg4(A, b, tol, max_iter, L, L', inject_error, 0, 0);
    % [~,flag,iter,~,~,~,~,~,~]
    % [x,flag,iter,diff_v,first_temp_gradient,first_rel_gradient, pval, standard_gradient, xval] = pcg4(A, b, tol, max_iter, L, L', inject_error, 0, 0);
    
    if flag == 1
       disp('error-free execution does not converge');
       return;
    end
    noerror_converge = iter;   % number of iterations in error-free run
    error_max_iter = noerror_converge*100;   % set max number of iterations to run when injecting errors (100x)
    disp(['Matrix = ', matrixname, ', Experiment=', num2str(m), ', converge=', num2str(noerror_converge)]);
    save(iter_filename, 'noerror_converge');
end

end