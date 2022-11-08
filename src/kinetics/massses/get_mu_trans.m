function mu_trans_kg = get_mu_trans(o2_molecule, o_atom)
% Returns reduced mass of translational motion of a given O2 + O system
  o2_atom_masses_kg = get_atom_masses(o2_molecule);
  o2_mass_kg = sum(o2_atom_masses_kg);
  o_mass_kg = get_atom_masses(o_atom);
  mu_trans_kg = o2_mass_kg * o_mass_kg / (o2_mass_kg + o_mass_kg);
end