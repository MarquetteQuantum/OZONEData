function initial_concentrations_per_m3 = get_initial_concentrations(ch1_concs_per_m3, o3_molecule, states, temp_k, optional)
% Returns initial concentrations of all states and reactants
% Initial concentrations of all states are assumed to be 0
% Assumes 2nd channel is in equilibrium with first
  arguments
    ch1_concs_per_m3
    o3_molecule
    states
    temp_k
    optional.K_dependent_threshold = false
    optional.separate_concentrations = false
    optional.region_names = []
  end

  assert(implies(optional.separate_concentrations, ~isempty(optional.region_names)), "region_names has to be provided if separate_concentrations is true");
  states_mult = iif(optional.separate_concentrations, length(optional.region_names), 1);
  num_concs = size(states, 1) * states_mult;
  num_reactants = iif(is_monoisotopic(o3_molecule), 2, 4);
  initial_concentrations_per_m3 = zeros(num_concs + num_reactants, 1);
  initial_concentrations_per_m3(num_concs + 1) = ch1_concs_per_m3(1); % ch1, reactant 1
  initial_concentrations_per_m3(num_concs + 2) = ch1_concs_per_m3(2); % ch1, reactant 2
  if num_reactants == 4
    Keqs_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, K_dependent_threshold=optional.K_dependent_threshold);
    Kex = Keqs_m3(1, 2) / Keqs_m3(1, 1);
    % channel 2 is in equilibrium with channel 1
    initial_concentrations_per_m3(num_concs + 3) = initial_concentrations_per_m3(num_concs + 1) / sqrt(Kex);
    initial_concentrations_per_m3(num_concs + 4) = initial_concentrations_per_m3(num_concs + 2) / sqrt(Kex);
  end
end