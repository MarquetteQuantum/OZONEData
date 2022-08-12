function test_krec_eig()
% Tests finding krec via an eigenvalue problem
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '666';
  Js = 24;
  Ks = 2;
  syms = 0;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_m2 = 250 * m_per_a0^2;
  optional = map_create();
  optional('k_dependent_threshold') = 0;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < 300 * j_per_cm_1, :);
%   states = states(states{:, 'gamma_total'} < 1 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);

  krec_m6_per_s = find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, optional);
end