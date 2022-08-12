function res = is_eigenvector_good(matrix, vector, threshold)
% Returns true if the given vector is an eigenvector of matrix, false otherwise
% Threshold specifies the maximum value for angle deviation (in rad)
  arguments
    matrix (:, :) double
    vector (:, 1) double
    threshold (1, 1) double = 1e-3
  end

  new_vector = matrix * vector;
  angle = acos(dot(new_vector, vector) / norm(new_vector) / norm(vector));
  res = angle < threshold;
end