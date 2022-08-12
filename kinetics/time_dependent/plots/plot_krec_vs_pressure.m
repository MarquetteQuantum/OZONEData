function plot_krec_vs_pressure()
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '666';
  Js = [0:32, 36:4:64];
  Ks = 0:20;
  syms = 0:1;
  temp_k = 298;
  Ms_per_m3 = 6.44 * logspace(20, 32, 13);
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_m2 = 1500 * m_per_a0^2;
  optional = map_create();
  optional('k_dependent_threshold') = 0;
  k0_m3_per_s = get_k0_2(o3_molecule, temp_k, sigma0_m2);
%   k0_1 = 14.52e-16;
  
  tic
  krecs_m6_per_s = zeros(size(Ms_per_m3));
  for M_ind = 1:length(Ms_per_m3)
    M_per_m3 = Ms_per_m3(M_ind);
    for J_ind = 1:length(Js)
      J = Js(J_ind);
      for K_ind = 1:length(Ks)
        K = Ks(K_ind);

        if K > J || J > 32 && mod(K, 2) ~= 0
          continue
        end

        for sym_ind = 1:length(syms)
          sym = syms(sym_ind);
          
          key = get_key(o3_molecule, J, K, sym);
          states = resonances(key);
          states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
          states = states(states{:, 'energy'} < 300 * j_per_cm_1, :);
%           states = states(states{:, 'gamma_total'} < 1e-10 * k0_m3_per_s * M_per_m3 * j_per_cm_1, :);
%           states{states{:, 'gamma_total'} < 1e-10 * j_per_cm_1, 'gamma_total'} = 0;
%           states = states(states{:, 'gamma_total'} < 0.1 * j_per_cm_1, :);
          states = assign_extra_properties(o3_molecule, states);
          
          dtau = get_dtau_2(J, K, sym);
          krecs_m6_per_s(M_ind) = krecs_m6_per_s(M_ind) + ...
            dtau * find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, optional);
        end
      end
    end
  end
  toc
  
  experimental = get_krec_vs_pressure_experimental_666();
  krec_exp_m6_per_s = experimental(:, 2) * 1e-12;
  pressure = m_conc_to_bar(Ms_per_m3, temp_k);
  create_x_log_plot();
  plot(pressure, krecs_m6_per_s, 'b.-', 'MarkerSize', 10);
%   yyaxis right
  plot(experimental(:, 1), krec_exp_m6_per_s, 'k.', 'MarkerSize', 20);
  xlabel('Pressure, bar');
  ylabel('krec, m^6/s');
end
