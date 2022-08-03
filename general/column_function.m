function out = column_function(func, matrix)
  % applies a given function to each column of a given matrix
  out = row_function(func, matrix.')';
end