function pfunc = calc_part_func_o2_rot(mu_rot_kg, J_start, J_step, kt_energy_j)
% mu_rot_kg - reduced mass of the O2 system
  eps = 1e-10;
  I_kg_m2 = get_inertia_moment(mu_rot_kg);
  threshold_energy_j = rigid_rotor_energy(J_start, I_kg_m2);
  
  pfunc = 0;
  J = J_start;
  while true
    energy_j = rigid_rotor_energy(J, I_kg_m2);
    new_pfunc = pfunc + (2*J + 1) * exp(-(energy_j - threshold_energy_j) / kt_energy_j);
    if new_pfunc - pfunc < eps
      break
    end
    pfunc = new_pfunc;
    J = J + J_step;
  end
end