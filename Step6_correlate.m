function Step6_correlate

% This function plots Figure 2 of the paper

close all;
comments = 'correlate_slowdown';
mrk = 'o';
mrk_size = 30;
color = 'b';

%matrices = {'cvxbqp1', 'thermal1', 'nd6k', ...
%    'bcsstk18', 'bodyy5', 'cbuckle', 'Pres_Poisson', 'bcsstk36', 'ct20stif', 'gyro_m', 't2dah_e', 'm_t1', 'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', ...
%    'Trefethen_20000', 'vanbody','wathen100'};
% matrices = {'bcsstk18'};
% matrices = {'bcsstk18', 'thermal1', 'ct20stif', 'cbuckle'}; 
matrices = {'cbuckle'};
num_matrices = length(matrices);

% bitflip_iter = 1;

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

    % for i = injections
    %     bitflip_iter = i;
    % %% load experimental data
    %     result_filename = ['./data/', matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
    %     result = dlmread(result_filename);
    %     A_row_2norms = result(:, 6);
    %     noerror_converges = result(:, 7);
    %     converges = result(:, 8);
    %     converge_ratios = converges./noerror_converges;
    % 
    %     %% slowdown figure
    %     figure;
    %     scatter(A_row_2norms, converge_ratios, mrk_size, mrk, 'filled', color);
    %     set(gca,'xscale');
    %     xlabel('Row 2-norm of matrix A');
    %     ylabel('Slowdown (x times)');
    %     title(matrixname, 'interpreter', 'none');
    %     set(gca,'FontSize',15);
    %     hold off;
    %     figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter), '_row2norm'];
    %     print(figure_filename, '-dpng');
    % 
    %     %% load gradients
    %     % rel_grad_filename = ['./matrices/', matrixname, '_iter=', num2str(bitflip_iter), '_gradient_relative.mat'];
    %     % abs_grad_filename = ['./matrices/', matrixname, '_iter=', num2str(bitflip_iter), '_gradient_absolute.mat'];
    % 
    %     r = result(:, 11);
    %     figure;
    %     scatter(r, converge_ratios, mrk_size, mrk, 'filled', color);
    %     set(gca,'xscale');
    %     xlabel('relative gradient');
    %     ylabel('Slowdown (x times)');
    %     title(matrixname, 'interpreter', 'none');
    %     set(gca,'FontSize',15);
    %     hold off;
    %     figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter), '_gradient_relative'];
    %     print(figure_filename, '-dpng');
    % 
    % 
    %     g = result(:,10);
    %     figure;
    %     scatter(g, converge_ratios, mrk_size, mrk, 'filled', color);
    %     set(gca,'xscale');
    %     xlabel('absolute gradient');
    %     ylabel('Slowdown (x times)');
    %     title(matrixname, 'interpreter', 'none');
    %     set(gca,'FontSize',15);
    %     hold off;
    %     figure_filename = ['./figures/', matrixname, '/',comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter), 'gradient_absolute'];
    %     print(figure_filename, '-dpng');
    % 
    %     figure;
    %     x = result(:,13);
    %     scatter(x, converge_ratios, mrk_size, mrk, 'filled', color);
    %     set(gca, 'xscale');
    %     xlabel('x-values');
    %     ylabel('Slowdown');
    %     title(matrixname, 'interpreter', 'none');
    %     set(gca, 'FontSize', 15);
    % 
    % 
    %     hold off;
    % 
    %     figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter), '_x'];
    %     print(figure_filename, '-dpng');
    % 
    %     figure;
    %     sg = result(:,12);
    %     scatter(sg, converge_ratios, mrk_size, mrk, 'filled', color);
    %     set(gca, 'xscale');
    %     xlabel('gradient (not absolute)');
    %     ylabel('Slowdown');
    %     title(matrixname, 'interpreter', 'none');
    %     set(gca, 'FontSize', 15);
    % 
    % 
    %     hold off;
    % 
    %     figure_filename = ['./figures/', matrixname, '/',comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter), '_grad(no_abs)'];
    %     print(figure_filename, '-dpng');
    % 
    %     hold off; 
    % end 
    % 
    % close all;

    figure;
    hold on;
    disp_names = {'$2$', '$0.25I_o$', '$0.5I_o$', '$0.75I_o$', '$I_o$'}; 
    colors = {'r'; '#77AC30'; 'b'; '#EDB120'; 'm'};
    markers = ['o'; 'x'; 's'; '+'; 'd']; 
    index = 0;
    for i = injections
        index=index+1;
        bitflip_iter = i;
    %% load experimental data
        result_filename = ['./data/', matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
        result = dlmread(result_filename);
        A_row_2norms = result(:, 6);
        noerror_converges = result(:, 7);
        converges = result(:, 8);
        converge_ratios = converges./noerror_converges;

        %colororder(['r'; 'g'; 'b'; 'k'; 'm']);

        scatter(A_row_2norms, converge_ratios, mrk_size, markers(index), MarkerFaceColor=char(colors(index)), MarkerEdgeColor=char(colors(index)));
        %set(gca,'xscale','log');
        set(gca,'yscale','log');
        xlabel('Row 2-norm of matrix A');
        ylabel('Slowdown');
        %title(matrixname, 'interpreter', 'latex');
        set(gca,'FontSize',14);
        legend(disp_names, Location="northwest", Interpreter="latex");
        figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_row2norm'];
        print(figure_filename, '-dpng');
    end 
    hold off; 
    %close all; 
end 
    
end