function graph_errors(iteration, error, matrixname)
    m = length(error);
    n = length(iteration);
    
    fig = scatter(iteration,error);
    xlabel('Iteration Number');
    ylabel('Error Location');
    saveas(fig,['./figures/error_location', matrixname], 'png');