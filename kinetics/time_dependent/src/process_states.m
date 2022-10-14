function [states, ref_energy_j] = process_states(o3_molecule, states, energy_range, gamma_range)
% Assigns extra properties and cuts by energy. Assumes the states are given for a signle combination of JKs.
  states = assign_extra_properties(o3_molecule, states);
  [ref_energy_j, threshold_energy_j] = ...
    get_higher_barrier_threshold(o3_molecule, states{1, 'J'}, states{1, 'K'}, states{1, 'vib_sym_well'});
  states = states(states{:, 'energy'} > ref_energy_j + energy_range(1), :);
  states = states(states{:, 'energy'} < ref_energy_j + energy_range(2), :);
  states{states{:, 'energy'} < threshold_energy_j, {'gamma_a', 'gamma_b', 'gamma_total'}} = 0;
  states{states{:, 'gamma_total'} < gamma_range(1), {'gamma_a', 'gamma_b', 'gamma_total'}} = 0;
  states(states{:, 'gamma_total'} > gamma_range(2), :) = [];
end