function Step3_solving(matrixname, bitflip_iter)

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

% the % of error we want in the matrix
fraction = .01;

% create new error file to select which iterations to inject error
new_error = ['./matrices/', matrixname, '_newerror.mat'];
% load iterations file
iter_filename = ['./matrices/', matrixname, '_convergence.mat'];
if exist(new_error, 'file') < 1 % file does not exist 
    if N <= M       % if number of vector elements is <= number of experiments, then inject error in all elements
        E = [1:N]'; % error in every location
        M = N;
    else
%         E = datasample([1:N], M);  % error in M random locations from 1 to N
        load(iter_filename, 'noerror_converge');
        num_elements = ceil(noerror_converge * fraction);
        
        indices = datasample([1:noerror_converge], num_elements); % find the interations we want to inject error in
        E = randi(N, [num_elements, M]);

    end
    save(new_error, 'indices', 'E');
else % file already exists, then just load the file 
%     M = length(E);
    load(new_error, 'indices', 'E');
end

% create iterations file
% iter_filename = ['./matrices/', matrixname, '_convergence.mat'];
% total_iterations = {}

% if m.ismember(newerror)
%     bitflip_iter = m
% end

%% start pcg 
for m = 0:M
    if m == 0
        % Experiment 0: make an error-free run
        inject_error = 0;
        [~,flag,iter,~] = pcg3(A, b, tol, max_iter, L, L', inject_error, 0, 0);
        
        if flag == 1
           disp('error-free execution does not converge');
           return;
        end
        noerror_converge = iter;   % number of iterations in error-free run
        error_max_iter = noerror_converge*100;   % set max number of iterations to run when injecting errors (100x)
        disp(['Matrix = ', matrixname, ', Experiment=', num2str(m), ', converge=', num2str(noerror_converge)]);
%         save(iter_filename, 'noerror_converge');
    else
        % Inject errors from Experiment 1 to M, each at a random location 
        inject_error = 1;
        bitflip_pos = E(:, m);
        bitflip_iter = indices;
        
        [~,flag,iter,diff_v] = pcg3(A, b, tol, error_max_iter, L, L', inject_error, bitflip_pos, bitflip_iter);
        converge = iter;   % number of iterations in error-injecting run
        
%         result = [N,flag,bitflip_iter',bitflip_pos,diff_v,A_row_2norm(bitflip_pos),noerror_converge,converge];
        result = vertcat(N,flag,bitflip_iter',bitflip_pos,diff_v,A_row_2norm(bitflip_pos),noerror_converge,converge);
        dlmwrite(result_filename, result, '-append');
        
        disp(['Matrix = ', matrixname, ', Experiment=', num2str(m), ', converge=', num2str(converge)]);
        if flag == 1
            disp('did not converged');
        end
        
    end
end

end