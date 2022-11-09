function test_propagation()
  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  ref_pressure_per_m3 = 6.44e24;
  ch1_concs_per_m3 = [6.44e18, 6.44e20];
  base_time_s = linspace(0, 10000e-9, 5001);
  
  o3_molecule = '686';
  J = 24;
  K = 2;
  vib_sym_well = 0;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 2000 * m_per_a0^2;
  energy_range = [-3000, 300] * j_per_cm;
  gamma_range = [1, inf] * j_per_cm;
  K_dependent_threshold = false;
  separate_concentrations = false;
  closed_channel = "";
  localization_threshold = 1e-3;

  transition_model = {["sym"], ["asym"]};
  region_names = ["sym", "asym"];
  
  data_prefix = [fullfile('data', 'resonances'), filesep];
  data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
  states = read_resonances(fullfile(data_prefix, data_key), o3_molecule, delim=data_prefix);
  states = states(data_key);
  states = process_states(o3_molecule, states, energy_range, gamma_range, closed_channel=closed_channel, ...
    localization_threshold=localization_threshold);

  initial_concentrations_per_m3 = get_initial_concentrations(ch1_concs_per_m3, o3_molecule, states, temp_k, ...
    K_dependent_threshold=K_dependent_threshold, separate_concentrations=separate_concentrations, ...
    region_names=region_names);
  pressure_ratio = M_per_m3 / ref_pressure_per_m3;
  time_s = base_time_s / pressure_ratio;
  
  tic
  [krecs_m6_per_s, eval_times_s] = propagate_concentrations_2(o3_molecule, states, initial_concentrations_per_m3, ...
    time_s, sigma0_tran_m2, temp_k, M_per_m3, dE_j, region_names, K_dependent_threshold=K_dependent_threshold, ...
    separate_concentrations=separate_concentrations, transition_model=transition_model);
  toc

  plot_region = 1;
  plot_time_ns = eval_times_s * 1e9;
  x_lim = [plot_time_ns(2), plot_time_ns(end)];
  my_plot(plot_time_ns, krecs_m6_per_s(plot_region, :), "Time, ns", "k_{rec}, m^6/s", xlim=x_lim);
end