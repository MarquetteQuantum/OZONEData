function mu_rot_kg = get_mu_rot(o2_molecule)
% Returns reduced mass of a given O2 molecule
  atom_masses_kg = get_atom_masses(o2_molecule);
  mu_rot_kg = prod(atom_masses_kg) / sum(atom_masses_kg);
end