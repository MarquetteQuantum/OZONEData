function res = implies(a, b)
% Logical implication
  if a && ~b
    res = false;
  else
    res = true;
  end
end