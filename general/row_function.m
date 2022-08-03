function out = row_function(func, matrix)
  % applies a given function to each row of a given matrix
  if isempty(matrix)
    return
  end

  out = cell(size(matrix, 1), 1);
  for i = 1:size(matrix, 1)
    out{i} = func(matrix(i, :));
  end

  if isnumeric(out{1}) || islogical(out{1})
    out = cell2mat(out);
  end
end