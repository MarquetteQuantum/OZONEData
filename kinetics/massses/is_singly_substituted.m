function res = is_singly_substituted(o3_molecule)
  res = sum(o3_molecule ~= '6') == 1;
end