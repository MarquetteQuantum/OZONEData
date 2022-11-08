function rot_energies_j = get_o2_rotational_energies(o2_molecule, js)
% Returns rotational energy levels 
  o2_r0_m = getvar('o2_dist_m');
  o2_I_kg_m2 = get_mu_rot(o2_molecule) * o2_r0_m^2;
  rot_energies_j = rigid_rotor_energy(js, o2_I_kg_m2);
end