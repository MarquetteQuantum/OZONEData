function I_kg_m2 = get_inertia_moment(mu_rot_kg)
% Returns moment of inertia of a given O2 molecule
  r0_m = getvar('o2_dist_a0') * getvar('m_per_a0');
  I_kg_m2 = mu_rot_kg * r0_m ^ 2;
end