function pfunc = calc_part_func_o2_total(temp_k, zpe_j, mu_rot_kg, J_rot_start, J_rot_step, mu_trans_kg)
% Calculates the overall partition function of O+O2 system
  j_per_k = get_j_per_k();
  kt_energy_j = temp_k * j_per_k;
  pfunc_elec = calc_part_func_o2_elec(temp_k);
  pfunc_vib = calc_part_func_o2_vib(zpe_j, kt_energy_j);
  pfunc_rot = calc_part_func_o2_rot(mu_rot_kg, J_rot_start, J_rot_step, kt_energy_j);
  pfunc_trans = calc_part_func_o2_trans(mu_trans_kg, kt_energy_j);
  pfunc = pfunc_elec * pfunc_vib * pfunc_rot * pfunc_trans;
end