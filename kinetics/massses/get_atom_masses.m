function atom_masses = get_atom_masses(molecule)
% Converts string description of ozone isotopomer to an array of masses for constituent atoms
  oxygen_kg = getvar('oxygen_amu') * getvar('kg_per_amu');
  if isstring(molecule)
    molecule = convertStringsToChars(molecule);
  end
  atom_masses = arrayfun(@(c) oxygen_kg(str2double(c) - 5), molecule);
end