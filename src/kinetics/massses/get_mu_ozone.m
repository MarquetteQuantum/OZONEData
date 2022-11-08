function mu_kg = get_mu_ozone(o3_molecule)
% returns reduced mass for a given O3 molecule
  atom_masses_kg = get_atom_masses(o3_molecule);
  mu_kg = sqrt(prod(atom_masses_kg) / sum(atom_masses_kg));
end