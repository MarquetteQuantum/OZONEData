function states = process_states(o3_molecule, states)
% Assigns extra properties and cuts by energy. Assumes the states are given for a signle combination of JKs.
  j_per_cm = get_j_per_cm();
  states = assign_extra_properties(o3_molecule, states);
  ref_energy_j = get_higher_barrier_threshold(o3_molecule, states{1, 'J'}, states{1, 'K'}, states{1, 'vib_sym_well'});
  states = states(states{:, 'energy'} > ref_energy_j - 3000 * j_per_cm, :);
  states = states(states{:, 'energy'} < ref_energy_j + 300 * j_per_cm, :);
end