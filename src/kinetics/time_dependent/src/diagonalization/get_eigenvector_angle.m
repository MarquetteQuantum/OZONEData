function angle = get_eigenvector_angle(matrix, vector)
% Returns angle between the original vector and matrix*vector
  new_vector = matrix * vector;
  angle = acos(dot(new_vector, vector) / norm(new_vector) / norm(vector));
end