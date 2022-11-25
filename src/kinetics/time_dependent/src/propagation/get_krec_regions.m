function krecs_m6_per_s = get_krec_regions(concentrations_per_m3, derivatives_func, M_per_m3, equilibrium_constants_total_m3, channel_ind, region_probs, ...
  optional)
% Calculates krecs for each region
  arguments
    concentrations_per_m3
    derivatives_func
    M_per_m3
    equilibrium_constants_total_m3
    channel_ind
    region_probs
    optional.separate_concentrations = false
  end

  num_states = iif(optional.separate_concentrations, numel(region_probs), size(region_probs, 1));
  derivatives_per_m3_s = derivatives_func(0, concentrations_per_m3);
  derivatives_o3_per_m3_s = derivatives_per_m3_s(1:num_states);
  if ~optional.separate_concentrations
    derivatives_region_per_m3_s = region_probs .* derivatives_o3_per_m3_s;
  else
    derivatives_region_per_m3_s = reshape(derivatives_o3_per_m3_s, [], size(region_probs, 2));
  end
  derivatives_region_total_per_m3_s = sum(derivatives_region_per_m3_s, 1);
  concentrations_o3_per_m3 = concentrations_per_m3(1:num_states);
  concentrations_reactants_per_m3 = reshape(concentrations_per_m3(num_states + 1 : end), 2, []);
  krecs_m6_per_s = get_krec(derivatives_region_total_per_m3_s, M_per_m3, concentrations_reactants_per_m3(:, channel_ind), sum(concentrations_o3_per_m3), ...
    equilibrium_constants_total_m3(channel_ind));
end