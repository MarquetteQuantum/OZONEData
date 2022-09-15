function test_diagonalization()
% Tests finding krec via the solution of an eigenvalue problem
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '686';
  Js = [0:32, 36:4:64];
  Ks = 0:20;
  vib_syms_well = 0:1;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_m2 = 1500 * m_per_a0^2;
%   transition_model = {["cov"]};
  transition_model = {["sym"], ["asym"]};
  region_names = "cov";
  K_dependent_threshold = false;

  krecs_m6_per_s = zeros(length(Ks), length(Js), length(vib_syms_well));
  tic
  for J_ind = 1:length(Js)
    J = Js(J_ind);
    for K_ind = 1:length(Ks)
      K = Ks(K_ind);
      if K > J || J > 32 && mod(K, 2) == 1
        continue
      end
      for sym_ind = 1:length(vib_syms_well)
        vib_sym_well = vib_syms_well(sym_ind);
        key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
        states = resonances(key);
        states = assign_extra_properties(o3_molecule, states);
        ref_energy_j = get_higher_barrier_threshold(o3_molecule, J, K, vib_sym_well);
        states = states(states{:, 'energy'} > ref_energy_j - 3000 * j_per_cm_1, :);
        states = states(states{:, 'energy'} < ref_energy_j + 300 * j_per_cm_1, :);
      %   states = states(states{:, 'gamma_total'} < 1 * j_per_cm_1, :);
        
        krecs_m6_per_s(K_ind, J_ind, sym_ind) = find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, ...
          M_per_m3, transition_model, region_names, K_dependent_threshold=K_dependent_threshold);
      end
    end
  end
  toc

  plot_matrix(krecs_m6_per_s(:, :, 1), x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K", ...
    title="vib sym well = 0");
  plot_matrix(krecs_m6_per_s(:, :, 2), x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K", ...
    title="vib sym well = 1");
  plot_matrix(sum(krecs_m6_per_s, 3), x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K", ...
    title="both vib sym well");
end