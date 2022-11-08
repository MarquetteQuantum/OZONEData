function out = row_function(func, matrix)
  % applies a given function to each row of a given matrix
  out = column_function(func, matrix')';
end