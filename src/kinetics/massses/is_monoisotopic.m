function res = is_monoisotopic(molecule)
  molecule = convertStringsToChars(molecule);
  res = all(molecule == molecule(1));
end