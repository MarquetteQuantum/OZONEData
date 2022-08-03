function I_kg_m2 = get_inertia_moment_2(o2_molecule)
% Returns moment of inertia of a given O2 molecule
  mu_rot_kg = get_mu_rot(o2_molecule);
  I_kg_m2 = get_inertia_moment(mu_rot_kg);
end