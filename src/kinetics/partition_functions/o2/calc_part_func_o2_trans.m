function pfunc = calc_part_func_o2_trans(mu_trans_kg, kt_energy_j)
% mu_trans_kg - reduced mass of the O+O2 system
  hbar_js = get_hbar_js();
  de_broglie_wl = sqrt(2*pi / (mu_trans_kg * kt_energy_j)) * hbar_js; % m
  pfunc = de_broglie_wl ^ -3; % m^-3
end