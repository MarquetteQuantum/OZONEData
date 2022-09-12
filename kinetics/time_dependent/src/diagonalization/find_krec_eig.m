function krecs_m6_per_s = find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, transition_model, ...
  region_names, varargin)
% Finds krec by solving an eigenproblem
  kdis_per_s = find_kdis_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, transition_model, varargin{:});
  equilibrium_constants_total_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);

  ch = get_lower_channel_ind(o3_molecule);
  krecs_m6_per_s = zeros(length(region_names));
  for i = 1:length(region_names)
    Keq_m3 = sum(equilibrium_constants_total_m3(:, ch) .* states{:, region_names(i)});
    krecs_m6_per_s(i) = kdis_per_s * Keq_m3 / M_per_m3;
  end
end