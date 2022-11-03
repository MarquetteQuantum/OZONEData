function out = column_function(func, matrix)
  % applies a given function to each column of a given matrix
  if isempty(matrix)
    return
  end

  col1_map = func(matrix(:, 1));
  out = zeros(length(col1_map), size(matrix, 2));
  out(:, 1) = col1_map;
  for i = 2:size(matrix, 2)
    out(:, i) = func(matrix(:, i));
  end
end