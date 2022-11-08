function mass = get_ozone_mass(o3_molecule)
% Returns sum of masses of all atoms in given ozone molecule
  atom_masses = get_atom_masses(o3_molecule);
  mass = sum(atom_masses);
end