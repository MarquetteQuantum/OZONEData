function dE_up_j = get_dE_up(dE_down_j, temp_k)
% Calculates dE_up corresponding to dE_down to satisfy the reversibility principle
  j_per_k = get_j_per_k();
  kt_energy_j = temp_k * j_per_k;
  dE_up_j = dE_down_j / (dE_down_j / kt_energy_j - 1);
end