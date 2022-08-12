function plot_krec_eig_vs_emax()
% Plots krec vs lower energy bound (convergence)
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
  sigma0_m2 = 1500 * m_per_a0^2;
  optional = map_create();
  optional('k_dependent_threshold') = 0;
  optional("check_eigenvectors") = true;
%   emaxs = 200;
  emaxs = 100:100:1000;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);
  krecs_m6_per_s = zeros(size(emaxs));
  for i = 1:length(emaxs)
    next_states = states(states{:, 'energy'} < emaxs(i) * j_per_cm_1, :);
    krecs_m6_per_s(i) = find_krec_eig(o3_molecule, temp_k, sigma0_m2, next_states, dE_j, M_per_m3, optional);
  end
  
  my_plot(emaxs, krecs_m6_per_s, "E_{max}, cm^{-1}", "k_{rec}, m^6/s", yscale="log", color="g", new_plot=false);
end