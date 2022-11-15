function [states, ref_energy_j] = process_states(barriers_prefix, o3_molecule, states, energy_range, gamma_range, optional)
% Assigns extra properties and cuts by energy. Assumes the states are given for a signle combination of JKs.
  arguments
    barriers_prefix
    o3_molecule
    states
    energy_range
    gamma_range
    optional.closed_channel = ""
    optional.localization_threshold = 0
  end

  states = assign_extra_properties(o3_molecule, states);
  [ref_energy_j, threshold_energy_j] = ...
    get_higher_barrier_threshold(barriers_prefix, o3_molecule, states{1, 'J'}, states{1, 'K'}, states{1, 'vib_sym_well'});
  states = states(states{:, 'energy'} > ref_energy_j + energy_range(1), :);
  states = states(states{:, 'energy'} < ref_energy_j + energy_range(2), :);
  states{states{:, 'energy'} < threshold_energy_j, {'gamma_a', 'gamma_b', 'gamma_total'}} = 0;

  if optional.closed_channel ~= ""
    states{:, "gamma_" + optional.closed_channel} = 0;
    states{:, "gamma_total"} = sum(states{:, ["gamma_a", "gamma_b"]}, 2);
  end

  states{states{:, 'gamma_total'} < gamma_range(1), {'gamma_a', 'gamma_b', 'gamma_total'}} = 0;
  states(states{:, 'gamma_total'} > gamma_range(2), :) = [];

  if optional.localization_threshold > 0
    prob_fields = ["sym", "asym", "vdw_a_sym", "vdw_a_asym", "vdw_b", "inf"];
    for i = 1:size(states, 1)
      localized_prob = states{i, prob_fields};
      localized_prob(localized_prob < optional.localization_threshold) = 0;
      prob_contrib = (1 - sum(localized_prob)) / sum(localized_prob ~= 0);
      localized_prob(localized_prob ~= 0) = localized_prob(localized_prob ~= 0) + prob_contrib;
      states{i, prob_fields} = localized_prob;
    end
  end
end