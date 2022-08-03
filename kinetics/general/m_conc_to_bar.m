function bars = m_conc_to_bar(m_conc_per_m3, temp_k)
% Converts pressure from m^-3 to bar
  avogadro_per_mol = getvar('avogadro_per_mol');
  R_j_per_mol_k = getvar('R_j_per_mol_k');
  pa_per_bar = getvar('pa_per_bar');
  bars = m_conc_per_m3 / avogadro_per_mol * R_j_per_mol_k * temp_k / pa_per_bar;
end