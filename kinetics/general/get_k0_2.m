function k0_m3_per_s = get_k0_2(o3_molecule, temp_k, sigma0_m2)
% Calculates rate coefficient multiplier (k0) for a given O3 molecule
  j_per_k = getvar('j_per_k');
  kg_per_amu = getvar('kg_per_amu');
%   argon_mass_kg = getvar('argon40_kg');
  nitrogen_amu = getvar('nitrogen_amu');

  ozone_mass_kg = get_ozone_mass(o3_molecule);
  third_body_mass_kg = nitrogen_amu(1) * 2 * kg_per_amu;
  kt_energy_j = temp_k * j_per_k;
  k0_m3_per_s = get_k0(ozone_mass_kg, third_body_mass_kg, kt_energy_j, sigma0_m2);
end