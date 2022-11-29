function states = assign_extra_properties(o3_molecule, states)
% Assigns extra properties necessary for kinetics calculations
  states = assign_K(states);
  states = assign_K_ind(states);
  states = assign_K_vib_sym_well(states);
  states = assign_K_vib_sym_well_ind(states);
  states = assign_degeneracy(states);
  if is_monoisotopic(o3_molecule)
    states = assign_trivial_separation(states);
  else
    states = assign_cumulative_probs(states);
  end
end