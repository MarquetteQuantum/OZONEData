function plot_krec_eig_vs_emin()
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
  sigma0_m2 = 250 * m_per_a0^2;
  optional = map_create();
  optional('k_dependent_threshold') = 0;
  optional("check_eigenvectors") = true;
  emins = -1000:-1000:-9000;
  emax = 300;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} < emax * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);
  krecs_m6_per_s = zeros(size(emins));
  for i = 1:length(emins)
    next_states = states(states{:, 'energy'} > emins(i) * j_per_cm_1, :);
    krecs_m6_per_s(i) = find_krec_eig(o3_molecule, temp_k, sigma0_m2, next_states, dE_j, M_per_m3, optional);
  end
  
  my_plot(emins, krecs_m6_per_s, "E_{min}, cm^{-1}", "k_{rec}, m^6/s", xdir="reverse", yscale="log", color="b", ...
    new_plot=true);
end