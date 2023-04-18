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
% result_filename = ['./data/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
rel_grad_filename = ['./matrices/', matrixname, '_gradient_relative.mat'];
abs_grad_filename = ['./matrices/', matrixname, '_gradient_absolute.mat'];

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

grad_rel = zeros(N, 100);
grad_abs = zeros(N, 100);

% create new error file to select which iterations to inject error
new_error = ['./matrices/', matrixname, '_newerror.mat'];
% load iterations file
iter_filename = ['./matrices/', matrixname, '_convergence.mat'];
if exist(new_error, 'file') < 1 % file does not exist 
    if N <= M       % if number of vector elements is <= number of experiments, then inject error in all elements
        E = [1:N]'; % error in every location
        M = N;
    else
        load(iter_filename, 'noerror_converge');
%         num_elements = ceil(noerror_converge * fraction);
        error_max_iter = noerror_converge*100;

        if noerror_converge < M
            M = noerror_converge;
        end
        
        indices = datasample([1:noerror_converge], M, 'Replace',false); % find the interations we want to inject error in
        E = datasample([1:N], M, 'Replace',false); % error in M random locations from 1 to N

        injections = [2, round(noerror_converge * .25), round(noerror_converge * .5), round(noerror_converge * .75), round(noerror_converge - 1)];
    end
    save(new_error, 'indices', 'E', 'injections');
else % file already exists, then just load the file 
    load(new_error, 'indices', 'E', 'injections');
    M = length(E);
end

%% start pcg 
for i = injections
    bitflip_iter = i;
    result_filename = ['./data/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
    for m = 1:M

        % Inject errors from Experiment 1 to M, each at a random location 
        inject_error = 1;
        bitflip_pos = E(:, m);
        
        load(iter_filename, 'noerror_converge');
        error_max_iter = noerror_converge*100;
        
        [~,flag,iter,diff_v,first_temp_gradient,first_rel_gradient, p] = pcg4(A,b,tol,error_max_iter,L,L', inject_error,bitflip_pos,bitflip_iter);
        converge = iter;   % number of iterations in error-injecting run
    
        grad_abs(:, m) = first_temp_gradient;
        grad_rel(:, m) = first_rel_gradient;
    
        result = [N,flag,bitflip_iter,bitflip_pos,diff_v,A_row_2norm(bitflip_pos),noerror_converge,converge, max(p),grad_abs(bitflip_pos), grad_rel(bitflip_pos)];
        dlmwrite(result_filename, result, '-append');
        
        disp(['Matrix = ', matrixname, ', Experiment=', num2str(m), ', converge=', num2str(converge)]);
        if flag == 1
            disp('did not converged');
        end
    end
        
end


save(abs_grad_filename, "grad_abs");
save(rel_grad_filename, "grad_rel");

end