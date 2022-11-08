function k_stab_m3_per_s = get_k0(ozone_mass_kg, third_body_mass_kg, kt_energy_j, sigma_stab_m2)
% calculates kstab corresponding to sigma_stab (stabilization cross-section)
% ozone_mass is the sum of masses of individual atoms, NOT the reduced mass (mu)
  mu_stab_kg = ozone_mass_kg * third_body_mass_kg / (ozone_mass_kg + third_body_mass_kg);
  velocity_m_per_s = sqrt(8*kt_energy_j / (pi*mu_stab_kg));
  k_stab_m3_per_s = sigma_stab_m2 * velocity_m_per_s;
end