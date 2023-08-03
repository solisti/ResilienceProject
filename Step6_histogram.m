function Step6_histogram

% This function plots Figure 1 of the paper. 

close all;
comments = 'histogram';
color = 'b';

%matrices = {'cvxbqp1', 'thermal1', 'nd6k', ...
%    'bcsstk18', 'bodyy5', 'cbuckle', 'Pres_Poisson', 'bcsstk36', 'ct20stif', 'gyro_m', 't2dah_e', 'm_t1', 'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', ...
%    'Trefethen_20000', 'vanbody','wathen100'};
% matrices = {'bcsstk18'};
% matrices = {'bcsstk18', 'thermal1', 'ct20stif', 'cbuckle'}; 
matrices = {'bcsstk18', 'bodyy5', 'cbuckle', 'G2_circuit'};
num_matrices = length(matrices);

% bitflip_iter = 110;




for m = 1:num_matrices
    matrixname = matrices{m};
    disp(matrixname);

    % create new folders for these matrices if they don't already exist 
    path = ['./figures/', matrixname];
    if exist(path, 'dir') ~= 7
        mkdir(path);
    end

    new_error = ['./matrices/', matrixname, '_newerror.mat'];
    load(new_error, 'injections');


    bitflip_iter = 1;
    result_filename = ['./data/', matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
    result = dlmread(result_filename);
    noerror_converges = result(:, 7);
    converges = result(:, 8);
    converge_ratios = converges./noerror_converges;

    %% plot histograms
    figure;
    histogram(converge_ratios, 'NumBins', 20, 'DisplayName',num2str(bitflip_iter));
    title(matrixname, 'interpreter', 'none');
    %set(gca,'xscale','log');
    xlabel('Slowdown');
    ylabel('Number of Experiments');
    % legend();
    set(gca,'FontSize',15);
    hold off;
    figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter)];
    print(figure_filename, '-dpng');
    close all;

    end
end