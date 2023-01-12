function run_calculate_krec_lindemann()
% Finds krec using Lindemann's approximation
  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  
  o3_molecule = '666';
  J = 24;
  K = 2;
  vib_sym_well = 0;
  energy_range_j = [-3000, 50] * j_per_cm;
  gamma_range_j = [1, 200] * j_per_cm;

  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-35, nan] * j_per_cm;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma_m2 = 2300 * m_per_a0^2;
  region_names = iif(o3_molecule == "666", ["cov", "vdw"], ["sym", "asym", "vdw_a", "vdw_b"]);
  region_factors = iif(o3_molecule == "666", [1, 1], [1, 2, 2, 1]);

  closed_channel = "";
  localization_threshold = 1e-3;
  gamma_use_reference = false;
  
  resonances_prefix = [fullfile('data', 'resonances'), filesep];
  resonances_format = iif(is_monoisotopic(o3_molecule), "666", "686");
  barriers_prefix = [fullfile('data', 'barriers'), filesep];

  data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
  states = read_resonances(fullfile(resonances_prefix, data_key), resonances_format, delim=resonances_prefix);
  states = states(data_key);
  states = process_states(barriers_prefix, o3_molecule, states, energy_range_j, gamma_range_j, closed_channel=closed_channel, ...
    localization_threshold=localization_threshold, gamma_use_reference=gamma_use_reference);

  krec_m6_per_s = calculate_krec_lindemann_2(o3_molecule, states, temp_k, M_per_m3, sigma_m2, dE_j, region_names, region_factors)
end