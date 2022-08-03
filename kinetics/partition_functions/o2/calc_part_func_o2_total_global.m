function pfunc = calc_part_func_o2_total_global(is_heavy, is_channel_B)
% Calculates total partition function for O+O2 system using global parameters
  temp_k = evalin('base', 'temp_k');
  if is_channel_B == 1
    mu_rot_kg = get_mu_rot_b(is_heavy);
    mu_trans_kg = get_mu_trans_b(is_heavy);
    Js = 1:2:99;
  else
    mu_rot_kg = get_mu_rot_a(is_heavy);
    mu_trans_kg = get_mu_trans_a(is_heavy);
    Js = 0:100;
  end
  pfunc = calc_part_func_o2_total(temp_k, mu_rot_kg, mu_trans_kg, Js);
end