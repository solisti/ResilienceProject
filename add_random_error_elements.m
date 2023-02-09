function result = add_random_error_elements(matrix, error_mean, error_stddev, fraction)
    [m, n] = size(matrix);
    num_elements = ceil(m * n * fraction);
    indices = randi(m * n, [num_elements, 1]);
    errors = error_mean + error_stddev * randn(num_elements, 1);
    matrix(indices) = matrix(indices) + errors;
    result = matrix;
end
