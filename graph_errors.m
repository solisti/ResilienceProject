function plot_error_locations(matrix, errors)
    [m, n] = size(matrix);
    imagesc(abs(errors) > 0);
    colormap(gray);
    axis equal;
    axis tight;
    set(gca, 'XTick', 1:n, 'YTick', 1:m);
end
