function run_diagonalization()
% Tests finding krec via the solution of an eigenvalue problem
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
%   o3_molecules = {'666', '686', '686'};
  o3_molecules = {'666', '686'};
  Js = [0:32, 36:4:64];
%   Js = 24;
  Ks = 0:20;
%   Ks = 2;
  vib_syms_well = 0:1;
%   vib_syms_well = 1;
  temp_k = 298;
  M_concs_per_m3 = 6.44 * logspace(23, 28, 6);
%   M_concs_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_m2 = 1500 * m_per_a0^2;
%   transition_models = {{["cov"]}};
%   transition_models = {{["sym"], ["asym"]}};
%   transition_models = {{["cov"]}, {["sym"]}, {["asym"]}};
%   transition_models = {{["sym"]}};
  transition_models = repmat({{["sym"], ["asym"], ["vdw_a_sym", "vdw_a_asym"], ["vdw_b"]}}, [1, 2]);
%   region_names = "cov";
%   region_names = ["cov", "sym", "asym"];
  region_names = repmat(["all"], [1, 2]);
  K_dependent_threshold = false;
  check_eigenvectors = false;

  pressure_bar = m_conc_to_bar(M_concs_per_m3, temp_k);
  krecs_m6_per_s = zeros(length(M_concs_per_m3), length(o3_molecules), length(Ks), length(Js), length(vib_syms_well));
  krecs_dtau_m6_per_s = zeros(length(M_concs_per_m3), length(o3_molecules), length(Ks), length(Js), ...
    length(vib_syms_well));
  % Calculate all krecs
  tic
  for M_conc_ind = 1:length(M_concs_per_m3)
    M_conc_per_m3 = M_concs_per_m3(M_conc_ind);
    for o3_molecule_ind = 1:length(o3_molecules)
      o3_molecule = o3_molecules{o3_molecule_ind};
      transition_model = transition_models{o3_molecule_ind};
      region_name = region_names(o3_molecule_ind);
      for K_ind = 1:length(Ks)
        K = Ks(K_ind);
        for J_ind = 1:length(Js)
          J = Js(J_ind);
          if K > J || J > 32 && mod(K, 2) == 1
            continue
          end
          for sym_ind = 1:length(vib_syms_well)
            vib_sym_well = vib_syms_well(sym_ind);
            key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
            states = resonances(key);
            states = assign_extra_properties(o3_molecule, states);
            % todo: clean up
            states{:, 'all'} = states{:, 'cov'} + states{:, 'vdw'};
            ref_energy_j = get_higher_barrier_threshold(o3_molecule, J, K, vib_sym_well);
            states = states(states{:, 'energy'} > ref_energy_j - 3000 * j_per_cm_1, :);
            states = states(states{:, 'energy'} < ref_energy_j + 300 * j_per_cm_1, :);
          %   states = states(states{:, 'gamma_total'} < 1 * j_per_cm_1, :);
            dtau = get_dtau_2(J, K, vib_sym_well);
            
            krecs_m6_per_s(M_conc_ind, o3_molecule_ind, K_ind, J_ind, sym_ind) = find_krec_eig(o3_molecule, temp_k, ...
              sigma0_m2, states, dE_j, M_conc_per_m3, transition_model, region_name, ...
              K_dependent_threshold=K_dependent_threshold, chekc_eigenvectors=check_eigenvectors);
            krecs_dtau_m6_per_s(M_conc_ind, o3_molecule_ind, K_ind, J_ind, sym_ind) = ...
              krecs_m6_per_s(M_conc_ind, o3_molecule_ind, K_ind, J_ind, sym_ind) * dtau;
          end
        end
      end
    end
  end
  toc

%   % Plot JK maps
%   for o3_molecule_ind = 1:length(o3_molecules)
%     for sym_ind = 1:length(vib_syms_well)
%       for pressure_ind = 1:length(M_concs_per_m3)
%         plot_matrix(krecs_m6_per_s(pressure_ind, o3_molecule_ind, :, :, sym_ind), ...
%           x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
%       end
%     end
%   end

  % Sum over J, K, sym
  krecs_sum_m6_per_s = sum(krecs_dtau_m6_per_s, 3:5);
  % Plot krec vs pressure
  my_plot(pressure_bar, krecs_sum_m6_per_s(:, 1), "Pressure, bar", "k_{rec}, m^6/s", xscale="log");
  my_plot(pressure_bar, 2/3 * krecs_sum_m6_per_s(:, 2), new_plot=false, color="r");

%   my_plot(pressure_bar, 2 * krecs_sum_m6_per_s(:, 2), new_plot=false, color="r");
%   my_plot(pressure_bar, krecs_sum_m6_per_s(:, 3), new_plot=false, color="g");
%   krecs_sum_m6_per_s(:, 2) = krecs_sum_m6_per_s(:, 2) + krecs_sum_m6_per_s(:, 3);

  delta = 2/3 * krecs_sum_m6_per_s(:, 2) ./ krecs_sum_m6_per_s(:, 1);
  my_plot(pressure_bar, delta, "Pressure, bar", "\delta", xscale="log");
end