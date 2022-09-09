function test_diagonalization()
% Tests finding krec via the solution of an eigenvalue problem
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '686';
  Js = 24;
  Ks = 2;
  syms = 0;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_m2 = 1500 * m_per_a0^2;
  transition_model = {["cov"]};
%   transition_model = {["sym"], ["asym"]};
  region_names = "cov";
  optional = map_create();
  optional('k_dependent_threshold') = 0;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  barrier_energy = estimate_barrier_energy(states);
  states = states(states{:, 'energy'} > barrier_energy - 3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < barrier_energy + 300 * j_per_cm_1, :);
%   states = states(states{:, 'gamma_total'} < 1 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);

  krec_m6_per_s = find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, transition_model, ...
    region_names, optional);
end