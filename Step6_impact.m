function Step6_impact

% This function plots Figure 1 of the paper. 

close all;
comments = 'impact';
color = 'b';

%matrices = {'cvxbqp1', 'thermal1', 'nd6k', ...
%    'bcsstk18', 'bodyy5', 'cbuckle', 'Pres_Poisson', 'bcsstk36', 'ct20stif', 'gyro_m', 't2dah_e', 'm_t1', 'msc23052', '2cubes_sphere', 'pwtk', 'G2_circuit', 'raefsky4', ...
%    'Trefethen_20000', 'vanbody','wathen100'};
% matrices = {'bcsstk18'};
% matrices = {'bcsstk18', 'thermal1', 'ct20stif', 'cbuckle'}; 
matrices = {'cbuckle'};
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


    for i = injections
        bitflip_iter = i;
        result_filename = ['./data/', matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
        result = dlmread(result_filename);
        noerror_converges = result(:, 7);
        converges = result(:, 8);
        converge_ratios = converges./noerror_converges;

%         %% plot unsorted figure
%         figure;
%         plot(converge_ratios, 'DisplayName',num2str(i));
%         title(matrixname, 'interpreter', 'none');
%         %set(gca,'xscale','log');
%         xlabel('Sample runs');
%         ylabel('Slowdown (x times)');
%         legend();
%         set(gca,'FontSize',15);
%         hold off;
%         comments = 'impact_unsorted';
%         figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter)];
%         print(figure_filename, '-dpng');
%         close all;


%         %% plot sorted figure
%         figure;
%         % hold on;
%         plot(sort(converge_ratios), 'DisplayName', num2str(i));
%         title(matrixname, 'interpreter', 'none');
%         %set(gca,'xscale','log');
%         xlabel('Sample runs');
%         ylabel('Slowdown (x times)');
%         legend();
%         set(gca,'FontSize',15);
%         hold off;
%         comments = 'impact_sorted';
%         figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname, '_bitflip_iter=', num2str(bitflip_iter)];
%         print(figure_filename, '-dpng');
    end 
    

    %% plot all iterations

    figure;
    disp_names = {'$2$', '$0.25I_o$', '$0.5I_o$', '$0.75I_o$', '$I_o$'}; 
    colors = {'r'; '#77AC30'; 'b'; '#EDB120'; 'm'};
    index = 0;
    for i = injections
        index=index+1;
        bitflip_iter = i;
        result_filename = ['./data/', matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
        %% load experimental data
        result = dlmread(result_filename);
        noerror_converges = result(:, 7);
        converges = result(:, 8);
        converge_ratios = converges./noerror_converges;
        %colororder(['r'; 'g'; 'b'; 'k'; 'm']); 
        % plot sorted
        hold on;
        plot(sort(converge_ratios), 'DisplayName', char(disp_names(index)), 'LineWidth', 2, 'Color', char(colors(index)));
        %title(matrixname, 'interpreter', 'none');
        set(gca,'yscale','log');
        xlabel('Runs');
        ylabel('Slowdown');
        legend(Location="northwest", Interpreter="latex");
        set(gca,'FontSize',14);
        % hold off;
        comments = 'impact_sorted';
        figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname];
        print(figure_filename, '-dpng');

    end

    hold off; 

%     figure;
%     % plot unsorted
%     for i = injections
%         bitflip_iter = i;
%         result_filename = ['./data/' matrixname, '/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
%         %% load experimental data
%         % result_filename = ['./data/Step3_', matrixname, '_iter=', num2str(bitflip_iter), '.dat'];
%         result = dlmread(result_filename);
%         noerror_converges = result(:, 7);
%         converges = result(:, 8);
%         converge_ratios = converges./noerror_converges;
% 
% 
%         colororder(['r'; 'g'; 'b'; 'y'; 'm']);
% 
%         % plot unsorted
%         hold on;
%         plot(converge_ratios, 'DisplayName', num2str(i));
%         title(matrixname, 'interpreter', 'none');
%         %set(gca,'xscale','log');
%         xlabel('Sample runs');
%         ylabel('Slowdown (x times)');
%         legend();
%         set(gca,'FontSize',15);
%         % hold off;
%         comments = 'impact_unsorted';
%         figure_filename = ['./figures/', matrixname, '/', comments, '_', matrixname];
%         print(figure_filename, '-dpng');
% 
%     end
%     hold off;
% 
%     close all;
end