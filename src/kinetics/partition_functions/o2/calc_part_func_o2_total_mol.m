function pfunc_m_3 = calc_part_func_o2_total_mol(temp_k, o2_molecule, o_atom, J_rot_start)
% Calculates total partition function for a given channel of O2 + O system
  zpe_j = get_channel_zpe(o2_molecule);
  mu_rot_kg = get_mu_rot(o2_molecule);
  mu_trans_kg = get_mu_trans(o2_molecule, o_atom);
  J_rot_step = iif(is_monoisotopic(o2_molecule), 2, 1);
  pfunc_m_3 = calc_part_func_o2_total(temp_k, zpe_j, mu_rot_kg, J_rot_start, J_rot_step, mu_trans_kg);
end